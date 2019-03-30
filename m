From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 4/5] signal: PIDFD_SIGNAL_TID threads via pidfds
Date: Sat, 30 Mar 2019 02:22:31 +0100
Message-ID: <20190330012229.yt3hecmgaj2r6vp7@brauner.io>
References: <20190329155425.26059-1-christian@brauner.io>
 <20190329155425.26059-5-christian@brauner.io>
 <CAG48ez0=Q2CzgTGLiEU7F9B=gS-58VrpKz2XQ369cemo2FJdbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez0=Q2CzgTGLiEU7F9B=gS-58VrpKz2XQ369cemo2FJdbQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.li>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 02:06:34AM +0100, Jann Horn wrote:
> On Fri, Mar 29, 2019 at 4:54 PM Christian Brauner <christian@brauner.io> wrote:
> > With the addition of pidfd_open() it is possible for users to reference a
> > specific thread by doing:
> >
> > int pidfd = pidfd_open(<tid>, 0);
> >
> > This means we can extend pidfd_send_signal() to signal a specific thread.
> > As promised in the commit for pidfd_send_signal() [1] the extension is
> > based on a flag argument, i.e. the scope of the signal delivery is based on
> > the flag argument, not on the type of file descriptor.
> > To this end the flag PIDFD_SIGNAL_TID is added. With this change we now
> > cover most of the functionality of all the other signal sending functions
> > combined:
> [...]
> > diff --git a/include/uapi/linux/wait.h b/include/uapi/linux/wait.h
> > index d6c7c0701997..b72f0ef84fe5 100644
> > --- a/include/uapi/linux/wait.h
> > +++ b/include/uapi/linux/wait.h
> [...]
> > +/* Flags to pass to pidfd_send_signal */
> > +#define PIDFD_SIGNAL_TID 1 /* Send signal to specific thread */
> 
> nit: s/1/1U/; the flags argument is an `unsigned int`

Will change.

> 
> >  #endif /* _UAPI_LINUX_WAIT_H */
> > diff --git a/kernel/signal.c b/kernel/signal.c
> > index eb97d0cc6ef7..9f93da85b2b9 100644
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> [...]
> > +static int pidfd_send_signal_specific(struct pid *pid, int sig,
> > +                                     struct kernel_siginfo *info)
> > +{
> > +       struct task_struct *p;
> > +       int error = -ESRCH;
> > +
> > +       rcu_read_lock();
> > +       p = pid_task(pid, PIDTYPE_PID);
> > +       if (p)
> > +               error = __do_send_specific(p, sig, info);
> > +       rcu_read_unlock();
> > +
> > +       return error;
> > +}
> > +
> >  /**
> > - * sys_pidfd_send_signal - send a signal to a process through a task file
> > - *                          descriptor
> > + * sys_pidfd_send_signal - send a signal to a process through a pidfd
> > +
> >   * @pidfd:  the file descriptor of the process
> >   * @sig:    signal to be sent
> >   * @info:   the signal info
> >   * @flags:  future flags to be passed
> 
> nit: comment is outdated, it isn't "future flags" anymore

Will remove.

> 
> [...]
> > + *   rt_tgsigqueueinfo(<tgid>, <tid>, <sig>, <uinfo>)
> > + * - pidfd_send_signal(<pidfd>, <sig>, <info>, PIDFD_SIGNAL_TID);
> > + *   which is equivalent to
> > + *   rt_tgsigqueueinfo(<tgid>, <tid>, <sig>, <uinfo>)
> > + *
> >   * In order to extend the syscall to threads and process groups the @flags
> >   * argument should be used. In essence, the @flags argument will determine
> >   * what is signaled and not the file descriptor itself. Put in other words,
> 
> nit: again, outdated comment about @flags

Will update.

> 
> [...]
> > @@ -3626,43 +3695,16 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
> >                 prepare_kill_siginfo(sig, &kinfo);
> >         }
> >
> > -       ret = kill_pid_info(sig, &kinfo, pid);
> > +       if (flags & PIDFD_SIGNAL_TID)
> > +               ret = pidfd_send_signal_specific(pid, sig, &kinfo);
> > +       else
> > +               ret = kill_pid_info(sig, &kinfo, pid);
> 
> nit: maybe give pidfd_send_signal_specific() and kill_pid_info() the
> same signatures, since they perform similar operations with the same
> argument types?

Yes, let's do
pidfd_send_signal_specific.(pid, sig, &kinfo);
kill_pid_info..............(pid, sig, &kinfo);

so it matches the argument order of the syscalls itself too.

> 
> Something that was already kinda weird in the existing code, but is
> getting worse with TIDs is the handling of SI_USER with siginfo.

Right, that's what we discussed earlier.

> Copying context lines from above here:
> 
>         if (info) {
>                 ret = copy_siginfo_from_user_any(&kinfo, info);
>                 if (unlikely(ret))
>                         goto err;
>                 ret = -EINVAL;
>                 if (unlikely(sig != kinfo.si_signo))
>                         goto err;
>                 if ((task_pid(current) != pid) &&
>                     (kinfo.si_code >= 0 || kinfo.si_code == SI_TKILL)) {
>                         /* Only allow sending arbitrary signals to yourself. */
>                         ret = -EPERM;
>                         if (kinfo.si_code != SI_USER)
>                                 goto err;
>                         /* Turn this into a regular kill signal. */
>                         prepare_kill_siginfo(sig, &kinfo);
>                 }
>         } else {
>                 prepare_kill_siginfo(sig, &kinfo);
>         }
> 
> So for signals to PIDs, the rule is that if you send siginfo with
> SI_USER to yourself, the siginfo is preserved; otherwise the kernel
> silently clobbers it. That's already kind of weird - silent behavior

Clobbers as in "silently replaces it whatever it seems fit?

> difference depending on a security check. But now, for signals to
> threads, I think the result is going to be that signalling the thread
> group leader preserves information, and signalling any other thread
> clobbers it? If so, that seems bad.
> 
> do_rt_sigqueueinfo() seems to have the same issue, from a glance - but
> there, at least the error case is just a -EPERM, not a silent behavior
> difference.
> 
> Would it make sense to refuse sending siginfo with SI_USER to
> non-current? If you actually want to send a normal SI_USER signal, you

Yeah.

> can use info==NULL, right? That should create wrongness parity with
> do_rt_sigqueueinfo().

So you'd just do (just doing it non-elegantly rn):
if ((task_pid(current) != pid) &&
    (kinfo.si_code >= 0 || kinfo.si_code == SI_TKILL)) {
        ret = -EPERM;
        goto err;
}

> To improve things further, I guess you'd have to move the comparison
> against current into pidfd_send_signal_specific(), or move the task
> lookup out of it, or something like that?

Looks like a sane suggestion to me. Would you care to send a patch for
that? This is clearly a bugfix suitable for 5.1 so I'd rather not wait
until 5.2.
