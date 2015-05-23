From: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] capabilities: Ambient capabilities
Date: Sat, 23 May 2015 14:37:06 -0500
Message-ID: <20150523193705.GA30563@mail.hallyn.com>
References: <cover.1431671529.git.luto@kernel.org>
 <cc4749638a21079cce12f9f30c806170558e56e5.1431671529.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cc4749638a21079cce12f9f30c806170558e56e5.1431671529.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Thanks very much, Andy.  Comments and ack below.

Quoting Andy Lutomirski (luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
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

PI would have worked great if most programs wanting privilege were
self-contained and compiled.  Shell scripts and lots of fork+execing
make pI [much less useful] [completely useless].  See also golang's
predisposition to fork+exec.

> This is a problem that has bitten many people who have tried to use
> capabilities for anything useful.
> 
> ===== The proposed change =====
> 
> This patch adds a fifth capability mask called the ambient mask
> (pA).  pA does what pI should have done.

Or at least what most people want it to do.

> pA obeys the invariant that no bit can ever be set in pA if it is
> not set in both pP and pI.  Dropping a bit from pP or pI drops that
> bit from pA.  This ensures that existing programs that try to drop
> capabilities still do so, with a complication.  Because capability
> inheritance is so broken, setting KEEPCAPS, using setresuid to

Sorry, did you mean "... setting KEEPCAPS and then either using
setresuid to a nonroot uid or calling execve ..." ?

> switch to nonroot uids, or calling execve effectively drops
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
> 
> Unprivileged users can create user namespaces, map themselves to a
> nonzero uid, and create both privileged (relative to their
> namespace) and unprivileged process trees.  This is currently more
> or less impossible.  Hallelujah!
> 
> You cannot use pA to try to subvert a setuid, setgid, or file-capped
> program: if you execute any such program, pA gets cleared and the
> resulting evolution rules are unchanged by this patch.

Christoph, just to be sure, is this ^ going to suffice for you?

Seems like it should since any program which is setuid-root, i.e.
passwd, isn't likely to be designed to exec other programs.

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
> open question.)  I've therefore taken the more paranoid route.

I'm definitely open to revisiting this question after the current
patch has been in use for awhile.

> An alternative would be to require PR_SET_NO_NEW_PRIVS before
> setting ambient capabilities.  I think that this would be annoying
> and would make granting otherwise unprivileged users minor ambient
> capabilities (CAP_NET_BIND_SERVICE or CAP_NET_RAW for example) much
> less useful than it is with this patch.
> 
> ===== Footnotes =====
> 
> [1] Files that are missing the "security.capability" xattr or that
> have unrecognized values for that xattr end up with has_cap set to
> false.  The code that does that appears to be complicated for no
> good reason.
> 
> [2] The libcap capability mask parsers and formatters are
> dangerously misleading and the documentation is flat-out wrong.  fE
> is *not* a mask; it's a single bit.  This has probably confused
> every single person who has tried to use file capabilities.
> 
> [3] Linux very confusingly processes both the script and the
> interpreter if applicable, for reasons that elude me.  The results
> from thinking about a script's file capabilities and/or setuid bits
> are mostly discarded.

Not quite sure what you mean here - setuid and fX are ignored on
shell scripts, but I think you're saying something less simple is
going on?

> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
> Cc: Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
> Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
> Cc: Andrew G. Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>
> Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

> ---
>  fs/proc/array.c              |  5 ++-
>  include/linux/cred.h         |  8 ++++
>  include/uapi/linux/prctl.h   |  6 +++
>  kernel/user_namespace.c      |  1 +
>  security/commoncap.c         | 87 +++++++++++++++++++++++++++++++++++++++-----
>  security/keys/process_keys.c |  1 +
>  6 files changed, 97 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 1295a00ca316..bc15356d6551 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -282,7 +282,8 @@ static void render_cap_t(struct seq_file *m, const char *header,
>  static inline void task_cap(struct seq_file *m, struct task_struct *p)
>  {
>  	const struct cred *cred;
> -	kernel_cap_t cap_inheritable, cap_permitted, cap_effective, cap_bset;
> +	kernel_cap_t cap_inheritable, cap_permitted, cap_effective,
> +			cap_bset, cap_ambient;
>  
>  	rcu_read_lock();
>  	cred = __task_cred(p);
> @@ -290,12 +291,14 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
>  	cap_permitted	= cred->cap_permitted;
>  	cap_effective	= cred->cap_effective;
>  	cap_bset	= cred->cap_bset;
> +	cap_ambient	= cred->cap_ambient;
>  	rcu_read_unlock();
>  
>  	render_cap_t(m, "CapInh:\t", &cap_inheritable);
>  	render_cap_t(m, "CapPrm:\t", &cap_permitted);
>  	render_cap_t(m, "CapEff:\t", &cap_effective);
>  	render_cap_t(m, "CapBnd:\t", &cap_bset);
> +	render_cap_t(m, "CapAmb:\t", &cap_ambient);
>  }
>  
>  static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
> diff --git a/include/linux/cred.h b/include/linux/cred.h
> index 2fb2ca2127ed..05178874e771 100644
> --- a/include/linux/cred.h
> +++ b/include/linux/cred.h
> @@ -122,6 +122,7 @@ struct cred {
>  	kernel_cap_t	cap_permitted;	/* caps we're permitted */
>  	kernel_cap_t	cap_effective;	/* caps we can actually use */
>  	kernel_cap_t	cap_bset;	/* capability bounding set */
> +	kernel_cap_t	cap_ambient;	/* Ambient capability set */
>  #ifdef CONFIG_KEYS
>  	unsigned char	jit_keyring;	/* default keyring to attach requested
>  					 * keys to */
> @@ -197,6 +198,13 @@ static inline void validate_process_creds(void)
>  }
>  #endif
>  
> +static inline bool cap_ambient_invariant_ok(const struct cred *cred)
> +{
> +	return cap_issubset(cred->cap_ambient,
> +			    cap_intersect(cred->cap_permitted,
> +					  cred->cap_inheritable));
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
>  # define PR_FP_MODE_FR		(1 << 0)	/* 64b FP registers */
>  # define PR_FP_MODE_FRE		(1 << 1)	/* 32b compatibility */
>  
> +/* Control the ambient capability set */
> +#define PR_CAP_AMBIENT		47
> +# define PR_CAP_AMBIENT_GET	1
> +# define PR_CAP_AMBIENT_RAISE	2
> +# define PR_CAP_AMBIENT_LOWER	3
> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 4109f8320684..dab0f808235a 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -39,6 +39,7 @@ static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
>  	cred->cap_inheritable = CAP_EMPTY_SET;
>  	cred->cap_permitted = CAP_FULL_SET;
>  	cred->cap_effective = CAP_FULL_SET;
> +	cred->cap_ambient = CAP_EMPTY_SET;
>  	cred->cap_bset = CAP_FULL_SET;
>  #ifdef CONFIG_KEYS
>  	key_put(cred->request_key_auth);
> diff --git a/security/commoncap.c b/security/commoncap.c
> index f66713bd7450..09541a6a85a0 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -272,6 +272,16 @@ int cap_capset(struct cred *new,
>  	new->cap_effective   = *effective;
>  	new->cap_inheritable = *inheritable;
>  	new->cap_permitted   = *permitted;
> +
> +	/*
> +	 * Mask off ambient bits that are no longer both permitted and
> +	 * inheritable.
> +	 */
> +	new->cap_ambient = cap_intersect(new->cap_ambient,
> +					 cap_intersect(*permitted,
> +						       *inheritable));
> +	if (WARN_ON(!cap_ambient_invariant_ok(new)))

This seems redundant (but safe) in this particular case since you've just
calculated it to be precisely (pA & pP & pI)

> +		return -EINVAL;
>  	return 0;
>  }
>  
> @@ -352,6 +362,7 @@ static inline int bprm_caps_from_vfs_caps(struct cpu_vfs_cap_data *caps,
>  
>  		/*
>  		 * pP' = (X & fP) | (pI & fI)
> +		 * The addition of pA' is handled later.
>  		 */
>  		new->cap_permitted.cap[i] =
>  			(new->cap_bset.cap[i] & permitted) |
> @@ -479,10 +490,13 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
>  {
>  	const struct cred *old = current_cred();
>  	struct cred *new = bprm->cred;
> -	bool effective, has_cap = false;
> +	bool effective, has_cap = false, is_setid;
>  	int ret;
>  	kuid_t root_uid;
>  
> +	if (WARN_ON(!cap_ambient_invariant_ok(old)))
> +		return -EPERM;
> +
>  	effective = false;
>  	ret = get_file_caps(bprm, &effective, &has_cap);
>  	if (ret < 0)
> @@ -527,8 +541,9 @@ skip:
>  	 *
>  	 * In addition, if NO_NEW_PRIVS, then ensure we get no new privs.
>  	 */
> -	if ((!uid_eq(new->euid, old->uid) ||
> -	     !gid_eq(new->egid, old->gid) ||
> +	is_setid = !uid_eq(new->euid, old->uid) || !gid_eq(new->egid, old->gid);
> +
> +	if ((is_setid ||
>  	     !cap_issubset(new->cap_permitted, old->cap_permitted)) &&
>  	    bprm->unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
>  		/* downgrade; they get no more than they had, and maybe less */
> @@ -544,10 +559,24 @@ skip:
>  	new->suid = new->fsuid = new->euid;
>  	new->sgid = new->fsgid = new->egid;
>  
> +	/* File caps or setid cancels ambient. */
> +	if (has_cap || is_setid)
> +		cap_clear(new->cap_ambient);
> +
> +	/*
> +	 * Now that we've computed pA', update pP' to give:
> +	 *   pP' = (X & fP) | (pI & fI) | pA'
> +	 */
> +	new->cap_permitted = cap_combine(new->cap_permitted, new->cap_ambient);
> +
>  	if (effective)
>  		new->cap_effective = new->cap_permitted;
>  	else
> -		cap_clear(new->cap_effective);
> +		new->cap_effective = new->cap_ambient;
> +
> +	if (WARN_ON(!cap_ambient_invariant_ok(new)))
> +		return -EPERM;
> +
>  	bprm->cap_effective = effective;
>  
>  	/*
> @@ -562,7 +591,7 @@ skip:
>  	 * Number 1 above might fail if you don't have a full bset, but I think
>  	 * that is interesting information to audit.
>  	 */
> -	if (!cap_isclear(new->cap_effective)) {
> +	if (!cap_issubset(new->cap_effective, new->cap_ambient)) {
>  		if (!cap_issubset(CAP_FULL_SET, new->cap_effective) ||
>  		    !uid_eq(new->euid, root_uid) || !uid_eq(new->uid, root_uid) ||
>  		    issecure(SECURE_NOROOT)) {
> @@ -573,6 +602,10 @@ skip:
>  	}
>  
>  	new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
> +
> +	if (WARN_ON(!cap_ambient_invariant_ok(new)))
> +		return -EPERM;
> +
>  	return 0;
>  }
>  
> @@ -594,7 +627,7 @@ int cap_bprm_secureexec(struct linux_binprm *bprm)
>  	if (!uid_eq(cred->uid, root_uid)) {
>  		if (bprm->cap_effective)
>  			return 1;
> -		if (!cap_isclear(cred->cap_permitted))
> +		if (!cap_issubset(cred->cap_permitted, cred->cap_ambient))
>  			return 1;
>  	}
>  
> @@ -696,10 +729,18 @@ static inline void cap_emulate_setxuid(struct cred *new, const struct cred *old)
>  	     uid_eq(old->suid, root_uid)) &&
>  	    (!uid_eq(new->uid, root_uid) &&
>  	     !uid_eq(new->euid, root_uid) &&
> -	     !uid_eq(new->suid, root_uid)) &&
> -	    !issecure(SECURE_KEEP_CAPS)) {
> -		cap_clear(new->cap_permitted);
> -		cap_clear(new->cap_effective);
> +	     !uid_eq(new->suid, root_uid))) {
> +		if (!issecure(SECURE_KEEP_CAPS)) {
> +			cap_clear(new->cap_permitted);
> +			cap_clear(new->cap_effective);
> +		}
> +
> +		/*
> +		 * Pre-ambient programs except setresuid to nonroot followed

[ I see 'except' has already been pointed out in the thread :) ]

> +		 * by exec to drop capabilities.  We should make sure that
> +		 * this remains the case.
> +		 */
> +		cap_clear(new->cap_ambient);
>  	}
>  	if (uid_eq(old->euid, root_uid) && !uid_eq(new->euid, root_uid))
>  		cap_clear(new->cap_effective);
> @@ -929,6 +970,32 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>  			new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
>  		return commit_creds(new);
>  
> +	case PR_CAP_AMBIENT:
> +		if (((!cap_valid(arg3)) | arg4 | arg5))
> +			return -EINVAL;
> +
> +		if (arg2 == PR_CAP_AMBIENT_GET) {
> +			return !!cap_raised(current_cred()->cap_ambient, arg3);
> +		} else if (arg2 != PR_CAP_AMBIENT_RAISE &&
> +			   arg2 != PR_CAP_AMBIENT_LOWER) {
> +			return -EINVAL;
> +		} else {
> +			if (arg2 == PR_CAP_AMBIENT_RAISE &&
> +			    (!cap_raised(current_cred()->cap_permitted, arg3) ||
> +			     !cap_raised(current_cred()->cap_inheritable,
> +					 arg3)))
> +				return -EPERM;
> +
> +			new = prepare_creds();
> +			if (!new)
> +				return -ENOMEM;
> +			if (arg2 == PR_CAP_AMBIENT_RAISE)
> +				cap_raise(new->cap_ambient, arg3);
> +			else
> +				cap_lower(new->cap_ambient, arg3);
> +			return commit_creds(new);
> +		}
> +
>  	default:
>  		/* No functionality available - continue with default */
>  		return -ENOSYS;
> diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
> index bd536cb221e2..43b4cddbf2b3 100644
> --- a/security/keys/process_keys.c
> +++ b/security/keys/process_keys.c
> @@ -848,6 +848,7 @@ void key_change_session_keyring(struct callback_head *twork)
>  	new->cap_inheritable	= old->cap_inheritable;
>  	new->cap_permitted	= old->cap_permitted;
>  	new->cap_effective	= old->cap_effective;
> +	new->cap_ambient	= old->cap_ambient;
>  	new->cap_bset		= old->cap_bset;
>  
>  	new->jit_keyring	= old->jit_keyring;
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
