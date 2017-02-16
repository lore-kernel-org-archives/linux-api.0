From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v4 2/4] seccomp: Add sysctl to configure actions that
 should be logged
Date: Wed, 15 Feb 2017 17:10:35 -0800
Message-ID: <CAGXu5j+xttArLAuSFHGMB8BqZ7tNrELmSFascGYPgDmwcorStw@mail.gmail.com>
References: <1487044559-6351-1-git-send-email-tyhicks@canonical.com> <1487044559-6351-3-git-send-email-tyhicks@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487044559-6351-3-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 13, 2017 at 7:55 PM, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index e36dfe9..270a227 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -509,6 +509,22 @@ static void seccomp_send_sigsys(int syscall, int reason)
>  }
>  #endif /* CONFIG_SECCOMP_FILTER */
>
> +static u32 seccomp_log_max_action = SECCOMP_RET_KILL;
> +
> +static inline void seccomp_log(unsigned long syscall, long signr, u32 action)
> +{
> +       /* Force an audit message to be emitted when the action is not greater
> +        * than the configured maximum action.
> +        */
> +       if (action <= seccomp_log_max_action)
> +               return __audit_seccomp(syscall, signr, action);
> +
> +       /* Let the audit subsystem decide if the action should be audited based
> +        * on whether the current task itself is being audited.
> +        */

Nitpick on comment style, please use:

/*
 * line 1
 * line 2...
 */

> +       return audit_seccomp(syscall, signr, action);
> +}
> +
>  /*
>   * Secure computing mode 1 allows only read/write/exit/sigreturn.
>   * To be fully secure this must be combined with rlimit
> @@ -534,7 +550,7 @@ static void __secure_computing_strict(int this_syscall)
>  #ifdef SECCOMP_DEBUG
>         dump_stack();
>  #endif
> -       audit_seccomp(this_syscall, SIGKILL, SECCOMP_RET_KILL);
> +       seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL);
>         do_exit(SIGKILL);
>  }
>
> @@ -633,18 +649,30 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
>                 return 0;
>
>         case SECCOMP_RET_ALLOW:
> +               /* Open-coded seccomp_log(), optimized for the RET_ALLOW hot
> +                * path.
> +                *
> +                * We only want to log RET_ALLOW actions when the admin has
> +                * configured them to be logged via the log_max_action sysctl.
> +                * Therefore, call __audit_seccomp() directly so that RET_ALLOW
> +                * actions are not audited simply because the task is being
> +                * audited.
> +                */
> +               if (unlikely(seccomp_log_max_action == SECCOMP_RET_ALLOW))
> +                       __audit_seccomp(this_syscall, 0, action);
> +
>                 return 0;
>
>         case SECCOMP_RET_KILL:
>         default:
> -               audit_seccomp(this_syscall, SIGSYS, action);
> +               seccomp_log(this_syscall, SIGSYS, action);
>                 do_exit(SIGSYS);
>         }
>
>         unreachable();
>
>  skip:
> -       audit_seccomp(this_syscall, 0, action);
> +       seccomp_log(this_syscall, 0, action);
>         return -1;
>  }
>  #else
> @@ -917,12 +945,96 @@ long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
>  #define SECCOMP_RET_TRACE_NAME         "trace"
>  #define SECCOMP_RET_ALLOW_NAME         "allow"
>
> +/* Largest strlen() of all action names */
> +#define SECCOMP_RET_MAX_NAME_LEN       5
> +
>  static char seccomp_actions_avail[] = SECCOMP_RET_KILL_NAME    " "
>                                       SECCOMP_RET_TRAP_NAME     " "
>                                       SECCOMP_RET_ERRNO_NAME    " "
>                                       SECCOMP_RET_TRACE_NAME    " "
>                                       SECCOMP_RET_ALLOW_NAME;
>
> +struct seccomp_action_name {
> +       u32             action;
> +       const char      *name;
> +};
> +
> +static struct seccomp_action_name seccomp_action_names[] = {

As long as I'm nit-picking, this can be const too. :)

-Kees

-- 
Kees Cook
Pixel Security
