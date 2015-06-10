From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v4] seccomp: add ptrace options for suspend/resume
Date: Tue, 9 Jun 2015 18:08:42 -0700
Message-ID: <CALCETrVuNzZRAw40reo_2ne9saO5KbbG-omFUQXDo=+XFhpuWA@mail.gmail.com>
References: <1433897388-9567-1-git-send-email-tycho.andersen@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433897388-9567-1-git-send-email-tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 9, 2015 at 5:49 PM, Tycho Andersen
<tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
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
>
> v3 changes:
>
> * get rid of various #ifdefs everywhere
> * report more sensible errors when PTRACE_O_SUSPEND_SECCOMP is incorrectly
>   used
>
> v4 changes:
>
> * get rid of may_suspend_seccomp() in favor of a capable() check in ptrace
>   directly
>
> Signed-off-by: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> CC: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> CC: Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> CC: Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>
> CC: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/ptrace.h      | 1 +
>  include/uapi/linux/ptrace.h | 6 ++++--
>  kernel/ptrace.c             | 9 +++++++++
>  kernel/seccomp.c            | 8 ++++++++
>  4 files changed, 22 insertions(+), 2 deletions(-)
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
> index c8e0e05..11fa460 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -556,6 +556,15 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
>         if (data & ~(unsigned long)PTRACE_O_MASK)
>                 return -EINVAL;
>
> +       if (unlikely(data & PTRACE_O_SUSPEND_SECCOMP)) {
> +               if (!config_enabled(CONFIG_CHECKPOINT_RESTORE) ||
> +                   !config_enabled(CONFIG_SECCOMP))
> +                       return -EINVAL;
> +
> +               if (!capable(CAP_SYS_ADMIN))
> +                       return -EPERM;

I tend to think that we should also require that current not be using
seccomp.  Otherwise, in principle, there's a seccomp bypass for
privileged-but-seccomped programs.  In any event, CRIU isn't going to
work well if you run the restorer under seccomp, since it'll start
nesting in a manner that probably isn't desirable.

> +       }
> +
>         /* Avoid intermediate state when all opts are cleared */
>         flags = child->ptrace;
>         flags &= ~(PTRACE_O_MASK << PT_OPT_FLAG_SHIFT);
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 980fd26..645e42d 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -590,6 +590,10 @@ void secure_computing_strict(int this_syscall)
>  {
>         int mode = current->seccomp.mode;
>
> +       if (config_enabled(CONFIG_CHECKPOINT_RESTORE) &&
> +           unlikely(current->ptrace & PT_SUSPEND_SECCOMP))
> +               return;
> +
>         if (mode == 0)
>                 return;
>         else if (mode == SECCOMP_MODE_STRICT)
> @@ -691,6 +695,10 @@ u32 seccomp_phase1(struct seccomp_data *sd)
>         int this_syscall = sd ? sd->nr :
>                 syscall_get_nr(current, task_pt_regs(current));
>
> +       if (config_enabled(CONFIG_CHECKPOINT_RESTORE) &&
> +           unlikely(current->ptrace & PT_SUSPEND_SECCOMP))
> +               return SECCOMP_PHASE1_OK;
> +

If it's not hard, it might still be nice to try to fold this into
mode.  This code is rather hot.  If it would be a mess, then don't
worry about it for now.

Otherwise seems reasonable.

--Andy
