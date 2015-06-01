From: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] seccomp: add ptrace commands for suspend/resume
Date: Mon, 1 Jun 2015 13:47:07 -0600
Message-ID: <20150601194707.GA2818@hopstrocity>
References: <1433186918-9626-1-git-send-email-tycho.andersen@canonical.com>
 <CALCETrVaE5UsTSQDf=48R8J9gG6YiMdp30wOMD+aZvxtOjrLRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVaE5UsTSQDf=48R8J9gG6YiMdp30wOMD+aZvxtOjrLRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 01, 2015 at 12:38:57PM -0700, Andy Lutomirski wrote:
> On Mon, Jun 1, 2015 at 12:28 PM, Tycho Andersen
> <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> > This patch is the first step in enabling checkpoint/restore of processes
> > with seccomp enabled.
> >
> > One of the things CRIU does while dumping tasks is inject code into them
> > via ptrace to collect information that is only available to the process
> > itself. However, if we are in a seccomp mode where these processes are
> > prohibited from making these syscalls, then what CRIU does kills the task.
> >
> > This patch adds a new ptrace command, PTRACE_SUSPEND_SECCOMP that enables a
> > task from the init user namespace which has CAP_SYS_ADMIN to disable (and
> > re-enable) seccomp filters for another task so that they can be
> > successfully dumped (and restored).
> >
> > Signed-off-by: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > CC: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> > CC: Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > CC: Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>
> > CC: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > CC: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> > CC: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  include/linux/seccomp.h     |  8 ++++++
> >  include/uapi/linux/ptrace.h |  1 +
> >  kernel/ptrace.c             | 10 ++++++++
> >  kernel/seccomp.c            | 62 ++++++++++++++++++++++++++++++++++++++++++++-
> >  4 files changed, 80 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> > index a19ddac..7cc870f 100644
> > --- a/include/linux/seccomp.h
> > +++ b/include/linux/seccomp.h
> > @@ -25,6 +25,9 @@ struct seccomp_filter;
> >  struct seccomp {
> >         int mode;
> >         struct seccomp_filter *filter;
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +       bool suspended;
> > +#endif
> >  };
> >
> >  #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
> > @@ -53,6 +56,11 @@ static inline int seccomp_mode(struct seccomp *s)
> >         return s->mode;
> >  }
> >
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +extern int suspend_seccomp(struct task_struct *);
> > +extern int resume_seccomp(struct task_struct *);
> > +#endif
> > +
> >  #else /* CONFIG_SECCOMP */
> >
> >  #include <linux/errno.h>
> > diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
> > index cf1019e..8ba4e4f 100644
> > --- a/include/uapi/linux/ptrace.h
> > +++ b/include/uapi/linux/ptrace.h
> > @@ -17,6 +17,7 @@
> >  #define PTRACE_CONT               7
> >  #define PTRACE_KILL               8
> >  #define PTRACE_SINGLESTEP         9
> > +#define PTRACE_SUSPEND_SECCOMP    10
> >
> >  #define PTRACE_ATTACH            16
> >  #define PTRACE_DETACH            17
> > diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> > index c8e0e05..a6b6527 100644
> > --- a/kernel/ptrace.c
> > +++ b/kernel/ptrace.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/highmem.h>
> >  #include <linux/pagemap.h>
> >  #include <linux/ptrace.h>
> > +#include <linux/seccomp.h>
> >  #include <linux/security.h>
> >  #include <linux/signal.h>
> >  #include <linux/uio.h>
> > @@ -1003,6 +1004,15 @@ int ptrace_request(struct task_struct *child, long request,
> >                 break;
> >         }
> >  #endif
> > +
> > +#if defined(CONFIG_SECCOMP) && defined(CONFIG_CHECKPOINT_RESTORE)
> > +       case PTRACE_SUSPEND_SECCOMP:
> > +               if (data)
> > +                       return suspend_seccomp(child);
> > +               else
> > +                       return resume_seccomp(child);
> > +#endif
> > +
> >         default:
> >                 break;
> >         }
> > diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> > index 980fd26..a358a58 100644
> > --- a/kernel/seccomp.c
> > +++ b/kernel/seccomp.c
> > @@ -569,6 +569,7 @@ static int mode1_syscalls_32[] = {
> >  static void __secure_computing_strict(int this_syscall)
> >  {
> >         int *syscall_whitelist = mode1_syscalls;
> > +
> >  #ifdef CONFIG_COMPAT
> >         if (is_compat_task())
> >                 syscall_whitelist = mode1_syscalls_32;
> > @@ -590,6 +591,11 @@ void secure_computing_strict(int this_syscall)
> >  {
> >         int mode = current->seccomp.mode;
> >
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +       if (current->seccomp.suspended)
> > +               return;
> > +#endif
> 
> IMO it's unfortunate that this has any runtime overhead at all.  Can
> it be suspend be multiplexed into mode to avoid this?
> 
> >
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +       if (unlikely(current->seccomp.suspended))
> > +               return SECCOMP_PHASE1_OK;
> > +#endif
> > +
> 
> Ditto.
> 
> > @@ -769,7 +780,8 @@ static long seccomp_set_mode_strict(void)
> >                 goto out;
> >
> >  #ifdef TIF_NOTSC
> > -       disable_TSC();
> > +       if (!current->seccomp.suspended)
> > +               disable_TSC();
> >  #endif
> 
> If you get here with seccomp suspended, you have already utterly
> failed.  Please don't try to pretend that you're going to do something
> sensible if this happens.
> 
> CRIU needs to freeze the target task reliably before suspending
> seccomp to avoid massive security holes.

Sorry, I should probably have mentioned this. It actually useful on
restore: the problem is that CRIU maps its restorer code into memory,
does all of the necessary work to restore (including restore the
seccomp stuff), and then tries to unmap that blob and gets killed.

So, the criu restore procedure is to suspend seccomp, restore the
seccomp state, and then let criu resume the seccomp state just before
the final task resume.

> >         seccomp_assign_mode(current, seccomp_mode);
> >         ret = 0;
> > @@ -901,3 +913,51 @@ long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
> >         /* prctl interface doesn't have flags, so they are always zero. */
> >         return do_seccomp(op, 0, uargs);
> >  }
> > +
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +int suspend_seccomp(struct task_struct *task)
> > +{
> > +       int ret = -EACCES;
> > +
> > +       spin_lock_irq(&task->sighand->siglock);
> > +
> > +       if (!capable(CAP_SYS_ADMIN))
> > +               goto out;
> > +
> > +       task->seccomp.suspended = true;
> > +
> > +#ifdef TIF_NOTSC
> > +       if (task->seccomp.mode == SECCOMP_MODE_STRICT)
> > +               clear_tsk_thread_flag(task, TIF_NOTSC);
> > +#endif
> 
> And what if the task is running?
> 
> > +
> > +       ret = 0;
> > +out:
> > +       spin_unlock_irq(&task->sighand->siglock);
> > +
> > +       return ret;
> > +}
> > +
> > +int resume_seccomp(struct task_struct *task)
> > +{
> > +       int ret = -EACCES;
> > +
> > +       spin_lock_irq(&task->sighand->siglock);
> > +
> > +       if (!capable(CAP_SYS_ADMIN))
> > +               goto out;
> > +
> > +       task->seccomp.suspended = false;
> > +
> > +#ifdef TIF_NOTSC
> > +       if (task->seccomp.mode == SECCOMP_MODE_STRICT)
> > +               set_tsk_thread_flag(task, TIF_NOTSC);
> > +#endif
> 
> Ditto.  Or can the task not be running here?

It is stopped since ptrace requires it to be stopped; I don't know if
that's enough to guarantee correctness, though. Is there some
additional barrier that is needed?

Tycho

> --Andy
