From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] seccomp: add ptrace options for suspend/resume
Date: Thu, 4 Jun 2015 09:44:36 -0700
Message-ID: <CAGXu5jLBm6ZBptsDTrNV6OrFSwoZ__k3867-Ji+6oYuTQ8ncWQ@mail.gmail.com>
References: <1433369396-13360-1-git-send-email-tycho.andersen@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433369396-13360-1-git-send-email-tycho.andersen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho.andersen@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Roland McGrath <roland@hack.frob.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 3, 2015 at 3:09 PM, Tycho Andersen
<tycho.andersen@canonical.com> wrote:
> This patch is the first step in enabling checkpoint/restore of processes
> with seccomp enabled.
>
> One of the things CRIU does while dumping tasks is inject code into them
> via ptrace to collect information that is only available to the process
> itself. However, if we are in a seccomp mode where these processes are
> prohibited from making these syscalls, then what CRIU does kills the task.
>
> This patch adds a new ptrace option, PTRACE_O_SUSPEND_SECCOMP, that enables
> a task from the init user namespace which has CAP_SYS_ADMIN and no seccomp
> filters to disable (and re-enable) seccomp filters for another task so that
> they can be successfully dumped (and restored). We restrict the set of
> processes that can disable seccomp through ptrace because although today
> ptrace can be used to bypass seccomp, there is some discussion of closing
> this loophole in the future and we would like this patch to not depend on
> that behavior and be future proofed for when it is removed.
>
> Note that seccomp can be suspended before any filters are actually
> installed; this behavior is useful on criu restore, so that we can suspend
> seccomp, restore the filters, unmap our restore code from the restored
> process' address space, and then resume the task by detaching and have the
> filters resumed as well.
>
> v2 changes:
>
> * require that the tracer have no seccomp filters installed
> * drop TIF_NOTSC manipulation from the patch
> * change from ptrace command to a ptrace option and use this ptrace option
>   as the flag to check. This means that as soon as the tracer
>   detaches/dies, seccomp is re-enabled and as a corrollary that one can not
>   disable seccomp across PTRACE_ATTACHs.

This feature gives me the creeps, but I think it's okay. Could it be
further restricted so that the process doing the suspension is already
ptracing the target?

> Signed-off-by: Tycho Andersen <tycho.andersen@canonical.com>
> CC: Kees Cook <keescook@chromium.org>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Will Drewry <wad@chromium.org>
> CC: Roland McGrath <roland@hack.frob.com>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Serge E. Hallyn <serge.hallyn@ubuntu.com>
> ---
>  include/linux/ptrace.h      |  1 +
>  include/linux/seccomp.h     |  4 ++++
>  include/uapi/linux/ptrace.h |  6 ++++--
>  kernel/ptrace.c             |  6 ++++++
>  kernel/seccomp.c            | 23 +++++++++++++++++++++++
>  5 files changed, 38 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
> index 987a73a..061265f 100644
> --- a/include/linux/ptrace.h
> +++ b/include/linux/ptrace.h
> @@ -34,6 +34,7 @@
>  #define PT_TRACE_SECCOMP       PT_EVENT_FLAG(PTRACE_EVENT_SECCOMP)
>
>  #define PT_EXITKILL            (PTRACE_O_EXITKILL << PT_OPT_FLAG_SHIFT)
> +#define PT_SUSPEND_SECCOMP     (PTRACE_O_SUSPEND_SECCOMP << PT_OPT_FLAG_SHIFT)
>
>  /* single stepping state bits (used on ARM and PA-RISC) */
>  #define PT_SINGLESTEP_BIT      31
> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> index a19ddac..ae3ec52 100644
> --- a/include/linux/seccomp.h
> +++ b/include/linux/seccomp.h
> @@ -53,6 +53,10 @@ static inline int seccomp_mode(struct seccomp *s)
>         return s->mode;
>  }
>
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +extern bool may_suspend_seccomp(void);
> +#endif

#else
static inline bool may_suspend_seccomp(void) { return false; }
#endif

> +
>  #else /* CONFIG_SECCOMP */
>
>  #include <linux/errno.h>
> diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
> index cf1019e..a7a6979 100644
> --- a/include/uapi/linux/ptrace.h
> +++ b/include/uapi/linux/ptrace.h
> @@ -89,9 +89,11 @@ struct ptrace_peeksiginfo_args {
>  #define PTRACE_O_TRACESECCOMP  (1 << PTRACE_EVENT_SECCOMP)
>
>  /* eventless options */
> -#define PTRACE_O_EXITKILL      (1 << 20)
> +#define PTRACE_O_EXITKILL              (1 << 20)
> +#define PTRACE_O_SUSPEND_SECCOMP       (1 << 21)
>
> -#define PTRACE_O_MASK          (0x000000ff | PTRACE_O_EXITKILL)
> +#define PTRACE_O_MASK          (\
> +       0x000000ff | PTRACE_O_EXITKILL | PTRACE_O_SUSPEND_SECCOMP)
>
>  #include <asm/ptrace.h>
>
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index c8e0e05..e3e68a2 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -15,6 +15,7 @@
>  #include <linux/highmem.h>
>  #include <linux/pagemap.h>
>  #include <linux/ptrace.h>
> +#include <linux/seccomp.h>
>  #include <linux/security.h>
>  #include <linux/signal.h>
>  #include <linux/uio.h>
> @@ -556,6 +557,11 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
>         if (data & ~(unsigned long)PTRACE_O_MASK)
>                 return -EINVAL;
>
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +       if (data & PTRACE_O_SUSPEND_SECCOMP && !may_suspend_seccomp())
> +               return -EPERM;
> +#endif

I'd like to avoid seeing any #ifdefs added to the .c files. Using a
static inline for may_suspend_seccomp() should cause this statement to
be eliminated by the compiler.

> +
>         /* Avoid intermediate state when all opts are cleared */
>         flags = child->ptrace;
>         flags &= ~(PTRACE_O_MASK << PT_OPT_FLAG_SHIFT);
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 980fd26..2a1bd35 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -590,6 +590,11 @@ void secure_computing_strict(int this_syscall)
>  {
>         int mode = current->seccomp.mode;
>
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +       if (unlikely(current->ptrace & PT_SUSPEND_SECCOMP))
> +               return;
> +#endif

Could PT_SUSPEND_SECCOMP be defined to "0" with not
CONFIG_CHECKPOINT_RESTORE? Then this wouldn't need ifdefs, and should
be similarly eliminated by the compiler.

> +
>         if (mode == 0)
>                 return;
>         else if (mode == SECCOMP_MODE_STRICT)
> @@ -691,6 +696,11 @@ u32 seccomp_phase1(struct seccomp_data *sd)
>         int this_syscall = sd ? sd->nr :
>                 syscall_get_nr(current, task_pt_regs(current));
>
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +       if (unlikely(current->ptrace & PT_SUSPEND_SECCOMP))
> +               return SECCOMP_PHASE1_OK;
> +#endif
> +
>         switch (mode) {
>         case SECCOMP_MODE_STRICT:
>                 __secure_computing_strict(this_syscall);  /* may call do_exit */
> @@ -901,3 +911,16 @@ long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
>         /* prctl interface doesn't have flags, so they are always zero. */
>         return do_seccomp(op, 0, uargs);
>  }
> +
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +bool may_suspend_seccomp(void)
> +{
> +       if (!capable(CAP_SYS_ADMIN))
> +               return false;
> +
> +       if (current->seccomp.mode != SECCOMP_MODE_DISABLED)
> +               return false;
> +
> +       return true;
> +}
> +#endif /* CONFIG_CHECKPOINT_RESTORE */
> --
> 2.1.4
>

Thanks for working on this!

-Kees

-- 
Kees Cook
Chrome OS Security
