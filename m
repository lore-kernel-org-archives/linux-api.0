From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v7] seccomp, ptrace: add support for dumping seccomp filters
Date: Tue, 13 Oct 2015 10:10:00 -0700
Message-ID: <CAGXu5jJ4k9nVMA8TT_YFR=QzAJsQefu0nY2sjGD2HCWKUTtW6g@mail.gmail.com>
References: <1444747626-8129-1-git-send-email-tycho.andersen@canonical.com>
	<1444747626-8129-2-git-send-email-tycho.andersen@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444747626-8129-2-git-send-email-tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 13, 2015 at 7:47 AM, Tycho Andersen
<tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> This patch adds support for dumping a process' (classic BPF) seccomp
> filters via ptrace.
>
> PTRACE_SECCOMP_GET_FILTER allows the tracer to dump the user's classic BPF
> seccomp filters. addr should be an integer which represents the ith seccomp
> filter (0 is the most recently installed filter). data should be a struct
> sock_filter * with enough room for the ith filter, or NULL, in which case
> the filter is not saved. The return value for this command is the number of
> BPF instructions the program represents, or negative in the case of errors.
> Command specific errors are ENOENT: which indicates that there is no ith
> filter in this seccomp tree, and EMEDIUMTYPE, which indicates that the ith
> filter was not installed as a classic BPF filter.
>
> A caveat with this approach is that there is no way to get explicitly at
> the heirarchy of seccomp filters, and users need to memcmp() filters to
> decide which are inherited. This means that a task which installs two of
> the same filter can potentially confuse users of this interface.
>
> v2: * make save_orig const
>     * check that the orig_prog exists (not necessary right now, but when
>        grows eBPF support it will be)
>     * s/n/filter_off and make it an unsigned long to match ptrace
>     * count "down" the tree instead of "up" when passing a filter offset
>
> Signed-off-by: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> CC: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

This looks good to me. I'd love to hear an "ok" from ptrace folks, but
I think this is ready.

-Kees

> CC: Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> CC: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> CC: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> CC: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> CC: Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>
> ---
>  include/linux/seccomp.h     | 11 +++++++
>  include/uapi/linux/ptrace.h |  2 ++
>  kernel/ptrace.c             |  5 +++
>  kernel/seccomp.c            | 77 ++++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 94 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> index f426503..2296e6b 100644
> --- a/include/linux/seccomp.h
> +++ b/include/linux/seccomp.h
> @@ -95,4 +95,15 @@ static inline void get_seccomp_filter(struct task_struct *tsk)
>         return;
>  }
>  #endif /* CONFIG_SECCOMP_FILTER */
> +
> +#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
> +extern long seccomp_get_filter(struct task_struct *task,
> +                              unsigned long filter_off, void __user *data);
> +#else
> +static inline long seccomp_get_filter(struct task_struct *task,
> +                                     unsigned long n, void __user *data)
> +{
> +       return -EINVAL;
> +}
> +#endif /* CONFIG_SECCOMP_FILTER && CONFIG_CHECKPOINT_RESTORE */
>  #endif /* _LINUX_SECCOMP_H */
> diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
> index a7a6979..c9d0b21 100644
> --- a/include/uapi/linux/ptrace.h
> +++ b/include/uapi/linux/ptrace.h
> @@ -23,6 +23,8 @@
>
>  #define PTRACE_SYSCALL           24
>
> +#define PTRACE_SECCOMP_GET_FILTER      40
> +
>  /* 0x4200-0x4300 are reserved for architecture-independent additions.  */
>  #define PTRACE_SETOPTIONS      0x4200
>  #define PTRACE_GETEVENTMSG     0x4201
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 787320d..b760bae 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -1016,6 +1016,11 @@ int ptrace_request(struct task_struct *child, long request,
>                 break;
>         }
>  #endif
> +
> +       case PTRACE_SECCOMP_GET_FILTER:
> +               ret = seccomp_get_filter(child, addr, datavp);
> +               break;
> +
>         default:
>                 break;
>         }
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 06858a7..7bc8305 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -347,6 +347,7 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
>  {
>         struct seccomp_filter *sfilter;
>         int ret;
> +       const bool save_orig = config_enabled(CONFIG_CHECKPOINT_RESTORE);
>
>         if (fprog->len == 0 || fprog->len > BPF_MAXINSNS)
>                 return ERR_PTR(-EINVAL);
> @@ -370,7 +371,7 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
>                 return ERR_PTR(-ENOMEM);
>
>         ret = bpf_prog_create_from_user(&sfilter->prog, fprog,
> -                                       seccomp_check_filter, false);
> +                                       seccomp_check_filter, save_orig);
>         if (ret < 0) {
>                 kfree(sfilter);
>                 return ERR_PTR(ret);
> @@ -867,3 +868,77 @@ long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
>         /* prctl interface doesn't have flags, so they are always zero. */
>         return do_seccomp(op, 0, uargs);
>  }
> +
> +#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
> +long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
> +                       void __user *data)
> +{
> +       struct seccomp_filter *filter;
> +       struct sock_fprog_kern *fprog;
> +       long ret;
> +       unsigned long count = 0;
> +
> +       spin_lock_irq(&current->sighand->siglock);
> +       if (!capable(CAP_SYS_ADMIN) ||
> +           current->seccomp.mode != SECCOMP_MODE_DISABLED) {
> +               ret = -EACCES;
> +               goto out_self;
> +       }
> +
> +       spin_lock_irq(&task->sighand->siglock);
> +       if (task->seccomp.mode != SECCOMP_MODE_FILTER) {
> +               ret = -EINVAL;
> +               goto out_task;
> +       }
> +
> +       filter = task->seccomp.filter;
> +       while (filter) {
> +               filter = filter->prev;
> +               count++;
> +       }
> +
> +       if (filter_off >= count) {
> +               ret = -ENOENT;
> +               goto out_task;
> +       }
> +       count -= filter_off;
> +
> +       filter = task->seccomp.filter;
> +       while (filter && count > 1) {
> +               filter = filter->prev;
> +               count--;
> +       }
> +
> +       if (WARN_ON(count != 1)) {
> +               /* The filter tree shouldn't shrink while we're using it. */
> +               ret = -ENOENT;
> +               goto out_task;
> +       }
> +
> +       fprog = filter->prog->orig_prog;
> +       if (!fprog) {
> +               /* This must be a new non-cBPF filter, since we save every
> +                * every cBPF filter's orig_prog above when
> +                * CONFIG_CHECKPOINT_RESTORE is enabled.
> +                */
> +               ret = -EMEDIUMTYPE;
> +               goto out_task;
> +       }
> +
> +       ret = fprog->len;
> +       if (!data)
> +               goto out_task;
> +
> +       if (copy_to_user(data, fprog->filter, bpf_classic_proglen(fprog))) {
> +               ret = -EFAULT;
> +               goto out_task;
> +       }
> +
> +out_task:
> +       spin_unlock_irq(&task->sighand->siglock);
> +
> +out_self:
> +       spin_unlock_irq(&current->sighand->siglock);
> +       return ret;
> +}
> +#endif
> --
> 2.5.0
>



-- 
Kees Cook
Chrome OS Security
