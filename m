From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 1/2] capabilities: Ambient capabilities
Date: Tue, 9 Jun 2015 16:09:58 -0700
Message-ID: <CAGXu5j+Y85U9pjZUO0LM8rOO-YJrqvwzsXNjmaxN=D+JiQrpJw@mail.gmail.com>
References: <cover.1432770087.git.luto@kernel.org>
	<eb28c29616751f0b17bfc1be7eae5bb718d58f9f.1432770087.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <eb28c29616751f0b17bfc1be7eae5bb718d58f9f.1432770087.git.luto@kernel.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Andrew Morton <akpm@linuxfoundation.org>, James Morris <james.l.morris@oracle.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Jonathan Corbet <corbet@lwn.net>, Christoph Lameter <cl@linux.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Wed, May 27, 2015 at 4:47 PM, Andy Lutomirski <luto@kernel.org> wrote:
> Credit where credit is due: this idea comes from Christoph Lameter
> with a lot of valuable input from Serge Hallyn.  This patch is
> heavily based on Christoph's patch.
>
> ===== The status quo =====
>
> On Linux, there are a number of capabilities defined by the kernel.
> To perform various privileged tasks, processes can wield
> capabilities that they hold.
>
> Each task has four capability masks: effective (pE), permitted (pP),
> inheritable (pI), and a bounding set (X).  When the kernel checks
> for a capability, it checks pE.  The other capability masks serve to
> modify what capabilities can be in pE.
>
> Any task can remove capabilities from pE, pP, or pI at any time.  If
> a task has a capability in pP, it can add that capability to pE
> and/or pI.  If a task has CAP_SETPCAP, then it can add any
> capability to pI, and it can remove capabilities from X.
>
> Tasks are not the only things that can have capabilities; files can
> also have capabilities.  A file can have no capabilty information at
> all [1].  If a file has capability information, then it has a
> permitted mask (fP) and an inheritable mask (fI) as well as a single
> effective bit (fE) [2].  File capabilities modify the capabilities
> of tasks that execve(2) them.
>
> A task that successfully calls execve has its capabilities modified
> for the file ultimately being excecuted (i.e. the binary itself if
> that binary is ELF or for the interpreter if the binary is a
> script.) [3] In the capability evolution rules, for each mask Z, pZ
> represents the old value and pZ' represents the new value.  The
> rules are:
>
>   pP' = (X & fP) | (pI & fI)
>   pI' = pI
>   pE' = (fE ? pP' : 0)
>   X is unchanged
>
> For setuid binaries, fP, fI, and fE are modified by a moderately
> complicated set of rules that emulate POSIX behavior.  Similarly, if
> euid == 0 or ruid == 0, then fP, fI, and fE are modified differently
> (primary, fP and fI usually end up being the full set).  For nonroot
> users executing binaries with neither setuid nor file caps, fI and
> fP are empty and fE is false.
>
> As an extra complication, if you execute a process as nonroot and fE
> is set, then the "secure exec" rules are in effect: AT_SECURE gets
> set, LD_PRELOAD doesn't work, etc.
>
> This is rather messy.  We've learned that making any changes is
> dangerous, though: if a new kernel version allows an unprivileged
> program to change its security state in a way that persists cross
> execution of a setuid program or a program with file caps, this
> persistent state is surprisingly likely to allow setuid or
> file-capped programs to be exploited for privilege escalation.
>
> ===== The problem =====
>
> Capability inheritance is basically useless.
>
> If you aren't root and you execute an ordinary binary, fI is zero,
> so your capabilities have no effect whatsoever on pP'.  This means
> that you can't usefully execute a helper process or a shell command
> with elevated capabilities if you aren't root.
>
> On current kernels, you can sort of work around this by setting fI
> to the full set for most or all non-setuid executable files.  This
> causes pP' = pI for nonroot, and inheritance works.  No one does
> this because it's a PITA and it isn't even supported on most
> filesystems.
>
> If you try this, you'll discover that every nonroot program ends up
> with secure exec rules, breaking many things.
>
> This is a problem that has bitten many people who have tried to use
> capabilities for anything useful.
>
> ===== The proposed change =====
>
> This patch adds a fifth capability mask called the ambient mask
> (pA).  pA does what most people expect pI to do.
>
> pA obeys the invariant that no bit can ever be set in pA if it is
> not set in both pP and pI.  Dropping a bit from pP or pI drops that
> bit from pA.  This ensures that existing programs that try to drop
> capabilities still do so, with a complication.  Because capability
> inheritance is so broken, setting KEEPCAPS, using setresuid to
> switch to nonroot uids, and then calling execve effectively drops
> capabilities.  Therefore, setresuid from root to nonroot
> conditionally clears pA unless SECBIT_NO_SETUID_FIXUP is set.
> Processes that don't like this can re-add bits to pA afterwards.
>
> The capability evolution rules are changed:
>
>   pA' = (file caps or setuid or setgid ? 0 : pA)
>   pP' = (X & fP) | (pI & fI) | pA'
>   pI' = pI
>   pE' = (fE ? pP' : pA')
>   X is unchanged
>
> If you are nonroot but you have a capability, you can add it to pA.
> If you do so, your children get that capability in pA, pP, and pE.
> For example, you can set pA = CAP_NET_BIND_SERVICE, and your
> children can automatically bind low-numbered ports.  Hallelujah!

Chrome OS could use this right now. :)

> Unprivileged users can create user namespaces, map themselves to a
> nonzero uid, and create both privileged (relative to their
> namespace) and unprivileged process trees.  This is currently more
> or less impossible.  Hallelujah!
>
> You cannot use pA to try to subvert a setuid, setgid, or file-capped
> program: if you execute any such program, pA gets cleared and the
> resulting evolution rules are unchanged by this patch.
>
> Users with nonzero pA are unlikely to unintentionally leak that
> capability.  If they run programs that try to drop privileges,
> dropping privileges will still work.
>
> It's worth noting that the degree of paranoia in this patch could
> possibly be reduced without causing serious problems.  Specifically,
> if we allowed pA to persist across executing non-pA-aware setuid
> binaries and across setresuid, then, naively, the only capabilities
> that could leak as a result would be the capabilities in pA, and any
> attacker *already* has those capabilities.  This would make me
> nervous, though -- setuid binaries that tried to privilege-separate
> might fail to do so, and putting CAP_DAC_READ_SEARCH or
> CAP_DAC_OVERRIDE into pA could have unexpected side effects.
> (Whether these unexpected side effects would be exploitable is an
> open question.)  I've therefore taken the more paranoid route.  We
> can revisit this later.

I think this is correct. Stuff using file caps, or set*id bits are
fundamentally using a different privilege management model. Keeping pA
separate makes a lot of sense to me.

> An alternative would be to require PR_SET_NO_NEW_PRIVS before
> setting ambient capabilities.  I think that this would be annoying
> and would make granting otherwise unprivileged users minor ambient
> capabilities (CAP_NET_BIND_SERVICE or CAP_NET_RAW for example) much
> less useful than it is with this patch.

Agreed: we should keep nnp out of this.

> ===== Footnotes =====
>
> [1] Files that are missing the "security.capability" xattr or that
> have unrecognized values for that xattr end up with has_cap set to
> false.  The code that does that appears to be complicated for no
> good reason.

Would it make more sense to have has_cap true, but have it lack any actual caps?

> [2] The libcap capability mask parsers and formatters are
> dangerously misleading and the documentation is flat-out wrong.  fE
> is *not* a mask; it's a single bit.  This has probably confused
> every single person who has tried to use file capabilities.

Sounds like it would be a valuable documentation patch.

> [3] Linux very confusingly processes both the script and the
> interpreter if applicable, for reasons that elude me.  The results
> from thinking about a script's file capabilities and/or setuid bits
> are mostly discarded.

I wonder if this is important enough to fix?

>
> Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Aaron Jones <aaronmdjones@gmail.com>
> CC: Ted Ts'o <tytso@mit.edu>
> Cc: linux-security-module@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-api@vger.kernel.org
> Cc: akpm@linuxfoundation.org
> Cc: Andrew G. Morgan <morgan@kernel.org>
> Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>
> Cc: Markku Savela <msa@moth.iki.fi>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Signed-off-by: Christoph Lameter <cl@linux.com> # Original author
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  fs/proc/array.c              |  5 ++-
>  include/linux/cred.h         |  8 ++++
>  include/uapi/linux/prctl.h   |  6 +++
>  kernel/user_namespace.c      |  1 +
>  security/commoncap.c         | 91 +++++++++++++++++++++++++++++++++++++++-----
>  security/keys/process_keys.c |  1 +
>  6 files changed, 101 insertions(+), 11 deletions(-)
>
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 1295a00ca316..bc15356d6551 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -282,7 +282,8 @@ static void render_cap_t(struct seq_file *m, const char *header,
>  static inline void task_cap(struct seq_file *m, struct task_struct *p)
>  {
>         const struct cred *cred;
> -       kernel_cap_t cap_inheritable, cap_permitted, cap_effective, cap_bset;
> +       kernel_cap_t cap_inheritable, cap_permitted, cap_effective,
> +                       cap_bset, cap_ambient;
>
>         rcu_read_lock();
>         cred = __task_cred(p);
> @@ -290,12 +291,14 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
>         cap_permitted   = cred->cap_permitted;
>         cap_effective   = cred->cap_effective;
>         cap_bset        = cred->cap_bset;
> +       cap_ambient     = cred->cap_ambient;
>         rcu_read_unlock();
>
>         render_cap_t(m, "CapInh:\t", &cap_inheritable);
>         render_cap_t(m, "CapPrm:\t", &cap_permitted);
>         render_cap_t(m, "CapEff:\t", &cap_effective);
>         render_cap_t(m, "CapBnd:\t", &cap_bset);
> +       render_cap_t(m, "CapAmb:\t", &cap_ambient);
>  }
>
>  static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
> diff --git a/include/linux/cred.h b/include/linux/cred.h
> index 2fb2ca2127ed..05178874e771 100644
> --- a/include/linux/cred.h
> +++ b/include/linux/cred.h
> @@ -122,6 +122,7 @@ struct cred {
>         kernel_cap_t    cap_permitted;  /* caps we're permitted */
>         kernel_cap_t    cap_effective;  /* caps we can actually use */
>         kernel_cap_t    cap_bset;       /* capability bounding set */
> +       kernel_cap_t    cap_ambient;    /* Ambient capability set */
>  #ifdef CONFIG_KEYS
>         unsigned char   jit_keyring;    /* default keyring to attach requested
>                                          * keys to */
> @@ -197,6 +198,13 @@ static inline void validate_process_creds(void)
>  }
>  #endif
>
> +static inline bool cap_ambient_invariant_ok(const struct cred *cred)
> +{
> +       return cap_issubset(cred->cap_ambient,
> +                           cap_intersect(cred->cap_permitted,
> +                                         cred->cap_inheritable));
> +}
> +
>  /**
>   * get_new_cred - Get a reference on a new set of credentials
>   * @cred: The new credentials to reference
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index 31891d9535e2..65407f867e82 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -190,4 +190,10 @@ struct prctl_mm_map {
>  # define PR_FP_MODE_FR         (1 << 0)        /* 64b FP registers */
>  # define PR_FP_MODE_FRE                (1 << 1)        /* 32b compatibility */
>
> +/* Control the ambient capability set */
> +#define PR_CAP_AMBIENT         47
> +# define PR_CAP_AMBIENT_GET    1
> +# define PR_CAP_AMBIENT_RAISE  2
> +# define PR_CAP_AMBIENT_LOWER  3

I assume this is to avoid bumping the structures in capset(2)?
Bikeshed: Instead of GET/RAISE/LOWER, why not READ/DROP/ADD, which
would follow the existing names used for the bounding set (though we
add "ADD", which is not available to bset)?

> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 4109f8320684..dab0f808235a 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -39,6 +39,7 @@ static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
>         cred->cap_inheritable = CAP_EMPTY_SET;
>         cred->cap_permitted = CAP_FULL_SET;
>         cred->cap_effective = CAP_FULL_SET;
> +       cred->cap_ambient = CAP_EMPTY_SET;
>         cred->cap_bset = CAP_FULL_SET;
>  #ifdef CONFIG_KEYS
>         key_put(cred->request_key_auth);
> diff --git a/security/commoncap.c b/security/commoncap.c
> index f66713bd7450..835a7584f7ea 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -272,6 +272,16 @@ int cap_capset(struct cred *new,
>         new->cap_effective   = *effective;
>         new->cap_inheritable = *inheritable;
>         new->cap_permitted   = *permitted;
> +
> +       /*
> +        * Mask off ambient bits that are no longer both permitted and
> +        * inheritable.
> +        */
> +       new->cap_ambient = cap_intersect(new->cap_ambient,
> +                                        cap_intersect(*permitted,
> +                                                      *inheritable));
> +       if (WARN_ON(!cap_ambient_invariant_ok(new)))
> +               return -EINVAL;
>         return 0;
>  }
>
> @@ -352,6 +362,7 @@ static inline int bprm_caps_from_vfs_caps(struct cpu_vfs_cap_data *caps,
>
>                 /*
>                  * pP' = (X & fP) | (pI & fI)
> +                * The addition of pA' is handled later.
>                  */
>                 new->cap_permitted.cap[i] =
>                         (new->cap_bset.cap[i] & permitted) |
> @@ -479,10 +490,13 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
>  {
>         const struct cred *old = current_cred();
>         struct cred *new = bprm->cred;
> -       bool effective, has_cap = false;
> +       bool effective, has_cap = false, is_setid;
>         int ret;
>         kuid_t root_uid;
>
> +       if (WARN_ON(!cap_ambient_invariant_ok(old)))
> +               return -EPERM;
> +
>         effective = false;
>         ret = get_file_caps(bprm, &effective, &has_cap);
>         if (ret < 0)
> @@ -527,8 +541,9 @@ skip:
>          *
>          * In addition, if NO_NEW_PRIVS, then ensure we get no new privs.
>          */
> -       if ((!uid_eq(new->euid, old->uid) ||
> -            !gid_eq(new->egid, old->gid) ||
> +       is_setid = !uid_eq(new->euid, old->uid) || !gid_eq(new->egid, old->gid);
> +
> +       if ((is_setid ||
>              !cap_issubset(new->cap_permitted, old->cap_permitted)) &&
>             bprm->unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
>                 /* downgrade; they get no more than they had, and maybe less */
> @@ -544,10 +559,28 @@ skip:
>         new->suid = new->fsuid = new->euid;
>         new->sgid = new->fsgid = new->egid;
>
> +       /* File caps or setid cancels ambient. */
> +       if (has_cap || is_setid)
> +               cap_clear(new->cap_ambient);
> +
> +       /*
> +        * Now that we've computed pA', update pP' to give:
> +        *   pP' = (X & fP) | (pI & fI) | pA'
> +        */
> +       new->cap_permitted = cap_combine(new->cap_permitted, new->cap_ambient);
> +
> +       /*
> +        * Set pE' = (fE ? pP' : pA').  Because pA' is zero if fE is set,
> +        * this is the same as pE' = (fE ? pP' : 0) | pA'.
> +        */
>         if (effective)
>                 new->cap_effective = new->cap_permitted;
>         else
> -               cap_clear(new->cap_effective);
> +               new->cap_effective = new->cap_ambient;
> +
> +       if (WARN_ON(!cap_ambient_invariant_ok(new)))
> +               return -EPERM;
> +
>         bprm->cap_effective = effective;
>
>         /*
> @@ -562,7 +595,7 @@ skip:
>          * Number 1 above might fail if you don't have a full bset, but I think
>          * that is interesting information to audit.
>          */
> -       if (!cap_isclear(new->cap_effective)) {
> +       if (!cap_issubset(new->cap_effective, new->cap_ambient)) {
>                 if (!cap_issubset(CAP_FULL_SET, new->cap_effective) ||
>                     !uid_eq(new->euid, root_uid) || !uid_eq(new->uid, root_uid) ||
>                     issecure(SECURE_NOROOT)) {
> @@ -573,6 +606,10 @@ skip:
>         }
>
>         new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
> +
> +       if (WARN_ON(!cap_ambient_invariant_ok(new)))
> +               return -EPERM;
> +
>         return 0;
>  }
>
> @@ -594,7 +631,7 @@ int cap_bprm_secureexec(struct linux_binprm *bprm)
>         if (!uid_eq(cred->uid, root_uid)) {
>                 if (bprm->cap_effective)
>                         return 1;
> -               if (!cap_isclear(cred->cap_permitted))
> +               if (!cap_issubset(cred->cap_permitted, cred->cap_ambient))
>                         return 1;
>         }
>
> @@ -696,10 +733,18 @@ static inline void cap_emulate_setxuid(struct cred *new, const struct cred *old)
>              uid_eq(old->suid, root_uid)) &&
>             (!uid_eq(new->uid, root_uid) &&
>              !uid_eq(new->euid, root_uid) &&
> -            !uid_eq(new->suid, root_uid)) &&
> -           !issecure(SECURE_KEEP_CAPS)) {
> -               cap_clear(new->cap_permitted);
> -               cap_clear(new->cap_effective);
> +            !uid_eq(new->suid, root_uid))) {
> +               if (!issecure(SECURE_KEEP_CAPS)) {
> +                       cap_clear(new->cap_permitted);
> +                       cap_clear(new->cap_effective);
> +               }
> +
> +               /*
> +                * Pre-ambient programs expect setresuid to nonroot followed
> +                * by exec to drop capabilities.  We should make sure that
> +                * this remains the case.
> +                */
> +               cap_clear(new->cap_ambient);
>         }
>         if (uid_eq(old->euid, root_uid) && !uid_eq(new->euid, root_uid))
>                 cap_clear(new->cap_effective);
> @@ -929,6 +974,32 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>                         new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
>                 return commit_creds(new);
>
> +       case PR_CAP_AMBIENT:
> +               if (((!cap_valid(arg3)) | arg4 | arg5))
> +                       return -EINVAL;
> +
> +               if (arg2 == PR_CAP_AMBIENT_GET) {
> +                       return !!cap_raised(current_cred()->cap_ambient, arg3);
> +               } else if (arg2 != PR_CAP_AMBIENT_RAISE &&
> +                          arg2 != PR_CAP_AMBIENT_LOWER) {
> +                       return -EINVAL;
> +               } else {
> +                       if (arg2 == PR_CAP_AMBIENT_RAISE &&
> +                           (!cap_raised(current_cred()->cap_permitted, arg3) ||
> +                            !cap_raised(current_cred()->cap_inheritable,
> +                                        arg3)))
> +                               return -EPERM;
> +
> +                       new = prepare_creds();
> +                       if (!new)
> +                               return -ENOMEM;
> +                       if (arg2 == PR_CAP_AMBIENT_RAISE)
> +                               cap_raise(new->cap_ambient, arg3);
> +                       else
> +                               cap_lower(new->cap_ambient, arg3);
> +                       return commit_creds(new);
> +               }
> +
>         default:
>                 /* No functionality available - continue with default */
>                 return -ENOSYS;
> diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
> index bd536cb221e2..43b4cddbf2b3 100644
> --- a/security/keys/process_keys.c
> +++ b/security/keys/process_keys.c
> @@ -848,6 +848,7 @@ void key_change_session_keyring(struct callback_head *twork)
>         new->cap_inheritable    = old->cap_inheritable;
>         new->cap_permitted      = old->cap_permitted;
>         new->cap_effective      = old->cap_effective;
> +       new->cap_ambient        = old->cap_ambient;
>         new->cap_bset           = old->cap_bset;
>
>         new->jit_keyring        = old->jit_keyring;
> --
> 2.1.0
>

Do you have tests for the capability behaviors we could add to the
selftests/ tree?

-Kees

-- 
Kees Cook
Chrome OS Security
