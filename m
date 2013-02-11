From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [CRIU] [PATCH 3/3] signalfd: add ability to read siginfo-s
	without dequeuing signals (v2)
Date: Mon, 11 Feb 2013 17:47:27 +0100
Message-ID: <20130211164727.GA27511@redhat.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org> <1359486181-29088-1-git-send-email-avagin@openvz.org> <20130207173447.GA5888@redhat.com> <CANaxB-xmSiPfbUAh+rQSgVxBzTXmVQcC7U741WYKaasG3_yc5w@mail.gmail.com> <20130208191056.GA13674@redhat.com> <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com> <20130209182239.GA9947@redhat.com> <CAKgNAkiYrP046mEv1_GJED5DckJrZSHvwu2u=P_BRxx-NuKALQ@mail.gmail.com> <20130210100424.GA15978@paralelels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130210100424.GA15978-yYYamFZzV1regbzhZkK2zA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/10, Andrew Vagin wrote:
>
> On Sat, Feb 09, 2013 at 11:53:04PM +0100, Michael Kerrisk (man-pages) wrote:
> >
> > This looks promising, but I am not sure I understand the user-space
> > API. Could you explain how it would look to (say) pull all per-thread
> > signals from user space?
> >
>
> 	siginfo_t *signals = malloc(...);
> 	...
>
> 	ret = ptrace(PTRACE_ATTACH, pid, NULL, NULL);

Yes. I assume this should not be a problem since c/r needs to ptrace
the task anyway?

> For shared (per-process) signals one line should be changed:
>  ret = ptrace(PTRACE_PEEKSIGNAL, pid, PTRACE_PEEK_SHARED + i, signals + i);

Yes. Except I'd say "PTRACE_PEEK_SHARED | i" to clarify that
PTRACE_PEEK_SHARED is "flag". Note that we can more flags, say,
PTRACE_PEEK_DEQUEUE which obviously means "dequeue signal" (but in
this case we should filter out SIGKILL/SIGSTOP).

And note that either way (I mean ptrace or signalfd) this can not
actually peek a signal which doesn't have the sigqueue (say,
SEND_SIG_FORCED). I guess this is not the problem, c/r can look
at /proc/pid/status#*Pnd aditionally.

OK, you seem to agree with this approach, I'll try to make the
working patch tomorrow. At least ptrace_peek_signal() needs another
is_compat argument for compat_ptrace_request().

Oleg.

> > > --- x/kernel/ptrace.c
> > > +++ x/kernel/ptrace.c
> > > @@ -618,6 +618,35 @@ static int ptrace_setsiginfo(struct task
> > >         return error;
> > >  }
> > >
> > > +static int ptrace_peek_signal(struct task_struct *child,
> > > +                               unsigned long addr, siginfo_t __user *uinfo)
> > > +{
> > > +       siginfo_t info;
> > > +       struct sigpending *pending;
> > > +       int ret = -ESOMETHING;
> > > +
> > > +       pending = &child->pending;
> > > +       if (addr & PTRACE_PEEK_SHARED) {
> > > +               addr &= ~PTRACE_PEEK_SHARED;
> > > +               pending = &child->signal->shared_pending;
> > > +       }
> > > +
> > > +       spin_lock_irq(&child->sighand->siglock);
> > > +       list_for_each_entry(q, &pending->list, list) {
> > > +               if (!addr--) {
> > > +                       copy_siginfo(info, &q->info);
> > > +                       ret = 0;
> > > +                       break;
> > > +               }
> > > +       }
> > > +       spin_lock_irq(&child->sighand->siglock);
> > > +
> > > +       if (!ret)
> > > +               ret = copy_siginfo_to_user(uinfo, info);
> > > +       if (!ret)
> > > +               ret = __put_user(info, si_code);
> > > +       return ret;
> > > +}
> > >
> > >  #ifdef PTRACE_SINGLESTEP
> > >  #define is_singlestep(request)         ((request) == PTRACE_SINGLESTEP)
> > > @@ -742,6 +771,10 @@ int ptrace_request(struct task_struct *c
> > >                 ret = put_user(child->ptrace_message, datalp);
> > >                 break;
> > >
> > > +       case PTRACE_PEEKSIGNAL:
> > > +               ret = ptrace_peek_signal(child, addr, datavp);
> > > +               break;
> > > +
> > >         case PTRACE_GETSIGINFO:
> > >                 ret = ptrace_getsiginfo(child, &siginfo);
> > >                 if (!ret)
> > >
> >
> >
> >
> > --
> > Michael Kerrisk
> > Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> > Author of "The Linux Programming Interface"; http://man7.org/tlpi/
> > _______________________________________________
> > CRIU mailing list
> > CRIU-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
> > https://lists.openvz.org/mailman/listinfo/criu
