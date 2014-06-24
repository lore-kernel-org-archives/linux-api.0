From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 3/9] seccomp: introduce writer locking
Date: Tue, 24 Jun 2014 20:35:50 +0200
Message-ID: <20140624183550.GB1258@redhat.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org> <1403560693-21809-4-git-send-email-keescook@chromium.org> <20140624165216.GA29272@redhat.com> <CAGXu5j+G8qAkGD7H=3R2iw2ZTqZSrMPa2f=czoEjwSW5wKqUWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+G8qAkGD7H=3R2iw2ZTqZSrMPa2f=czoEjwSW5wKqUWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/24, Kees Cook wrote:
>
> On Tue, Jun 24, 2014 at 9:52 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Kees,
> >
> > I am still trying to force myself to read and try to understand what
> > this series does ;) Just a minor nit so far.
>
> The use-case this solves is when a userspace process does not control
> (or know) when a thread is spawned (e.g. via shared library init, or
> LD_PRELOAD) but wants to make sure seccomp filters have been applied
> to it.

Yes, thanks, I understand this. But the details are not clear to me so
far, I'll try to re-read this series later.

> >> @@ -1142,6 +1168,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >>  {
> >>       int retval;
> >>       struct task_struct *p;
> >> +     unsigned long irqflags;
> >>
> >>       if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
> >>               return ERR_PTR(-EINVAL);
> >> @@ -1196,7 +1223,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >>               goto fork_out;
> >>
> >>       ftrace_graph_init_task(p);
> >> -     get_seccomp_filter(p);
> >>
> >>       rt_mutex_init_task(p);
> >>
> >> @@ -1434,7 +1460,13 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >>               p->parent_exec_id = current->self_exec_id;
> >>       }
> >>
> >> -     spin_lock(&current->sighand->siglock);
> >> +     spin_lock_irqsave(&current->sighand->siglock, irqflags);
> >> +
> >> +     /*
> >> +      * Copy seccomp details explicitly here, in case they were changed
> >> +      * before holding tasklist_lock.
> >> +      */
> >> +     copy_seccomp(p);
> >>
> >>       /*
> >>        * Process group and session signals need to be delivered to just the
> >> @@ -1446,7 +1478,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >>       */
> >>       recalc_sigpending();
> >>       if (signal_pending(current)) {
> >> -             spin_unlock(&current->sighand->siglock);
> >> +             spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
> >>               write_unlock_irq(&tasklist_lock);
> >>               retval = -ERESTARTNOINTR;
> >>               goto bad_fork_free_pid;
> >> @@ -1486,7 +1518,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >>       }
> >>
> >>       total_forks++;
> >> -     spin_unlock(&current->sighand->siglock);
> >> +     spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
> >>       write_unlock_irq(&tasklist_lock);
> >>       proc_fork_connector(p);
> >>       cgroup_post_fork(p);
> >
> > It seems that the only change copy_process() needs is copy_seccomp() under the locks.
> > Everythinh else (irqflags games) looks obviously unneeded?
>
> I got irq lock dep warnings without these changes.

With or without your patches? Could you show the waring?

> If they're
> unneeded, that's totally fine by me, but some change (either this or
> markings to keep lockdep happy) is needed.

Yes, we need to understand what what happens...

Oleg.
