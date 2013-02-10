From: Andrew Vagin <avagin@parallels.com>
Subject: Re: [CRIU] [PATCH 3/3] signalfd: add ability to read siginfo-s
 without dequeuing signals (v2)
Date: Sun, 10 Feb 2013 14:04:24 +0400
Message-ID: <20130210100424.GA15978@paralelels.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org>
 <1359486181-29088-1-git-send-email-avagin@openvz.org>
 <20130207173447.GA5888@redhat.com>
 <CANaxB-xmSiPfbUAh+rQSgVxBzTXmVQcC7U741WYKaasG3_yc5w@mail.gmail.com>
 <20130208191056.GA13674@redhat.com>
 <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com>
 <20130209182239.GA9947@redhat.com>
 <CAKgNAkiYrP046mEv1_GJED5DckJrZSHvwu2u=P_BRxx-NuKALQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkiYrP046mEv1_GJED5DckJrZSHvwu2u=P_BRxx-NuKALQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, criu@openvz.org, Cyrill Gorcunov <gorcunov@openvz.org>, Andrey Wagin <avagin@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Dave Jones <davej@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

On Sat, Feb 09, 2013 at 11:53:04PM +0100, Michael Kerrisk (man-pages) wrote:
> On Sat, Feb 9, 2013 at 7:22 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 02/08, Michael Kerrisk (man-pages) wrote:
> >>
> >> On Fri, Feb 8, 2013 at 8:10 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> >
> >> > Well. I do not know. Up to you and Michael.
> >> >
> >> > But honestly, I can't say this all looks really nice. And why do we
> >> > need SIGNALFD_PEEK then?
> >>
> >> It surely is no beauty. The hope is at least to make it less ugly than it was.
> >
> > This is subjective, but I am not sure about "less" ;) Yes, we avoid the
> > magic offsets, but we add SFD_SHARED/PER_THREAD which need to change
> > dequeue_signal plus other complications. And for what?
> >
> >> > Seriously, perhaps we should simply add signalfd_fops->ioctl() for PEEK.
> >> > Or add PTRACE_{PEEK,POKE}_SIGNAL which looks even logical and useful...
> >> > And much simpler/straightforward.
> >> >
> >> > But I am not going to argue.
> >>
> >> I suppose I had wondered along similar lines, but in a slightly
> >> different direction: would the use of a /proc interface to get the
> >> queued signals make some sense?
> >
> > (Can't resist sorry... yes we need /proc/pid/cr or /dev/cr or whatever
> >  which dumps almost everything c/r needs without need to add a lot of
> >  cr code everywhere).
> >
> > Perhaps, but I am not sure about the textual representation.
> >
> > And to me, the best solution is the simplest solution. Please look
> > at the patch below. It is trivial. And we can also drop the SFD_RAW
> > patch in -mm.
> 
> Oleg,
> 
> This looks promising, but I am not sure I understand the user-space
> API. Could you explain how it would look to (say) pull all per-thread
> signals from user space?
>

	siginfo_t *signals = malloc(...);
	...

	ret = ptrace(PTRACE_ATTACH, pid, NULL, NULL);
	if (ret == -1)
		goto err;

	for (i = 0; ; i++) {
		ret = ptrace(PTRACE_PEEKSIGNAL, pid, i, signals + i);
		if (ret == -1) {
			if (errno == ESOMETHING)
				break;
			else
				goto err_detach;
		}
	}
...
err_detach:
	ret = ptrace(PTRACE_DETACH, pid, NULL, NULL);
err:
...

For shared (per-process) signals one line should be changed:
 ret = ptrace(PTRACE_PEEKSIGNAL, pid, PTRACE_PEEK_SHARED + i, signals + i);

> Thanks,
> 
> Michael
> 
> 
> > --- x/kernel/ptrace.c
> > +++ x/kernel/ptrace.c
> > @@ -618,6 +618,35 @@ static int ptrace_setsiginfo(struct task
> >         return error;
> >  }
> >
> > +static int ptrace_peek_signal(struct task_struct *child,
> > +                               unsigned long addr, siginfo_t __user *uinfo)
> > +{
> > +       siginfo_t info;
> > +       struct sigpending *pending;
> > +       int ret = -ESOMETHING;
> > +
> > +       pending = &child->pending;
> > +       if (addr & PTRACE_PEEK_SHARED) {
> > +               addr &= ~PTRACE_PEEK_SHARED;
> > +               pending = &child->signal->shared_pending;
> > +       }
> > +
> > +       spin_lock_irq(&child->sighand->siglock);
> > +       list_for_each_entry(q, &pending->list, list) {
> > +               if (!addr--) {
> > +                       copy_siginfo(info, &q->info);
> > +                       ret = 0;
> > +                       break;
> > +               }
> > +       }
> > +       spin_lock_irq(&child->sighand->siglock);
> > +
> > +       if (!ret)
> > +               ret = copy_siginfo_to_user(uinfo, info);
> > +       if (!ret)
> > +               ret = __put_user(info, si_code);
> > +       return ret;
> > +}
> >
> >  #ifdef PTRACE_SINGLESTEP
> >  #define is_singlestep(request)         ((request) == PTRACE_SINGLESTEP)
> > @@ -742,6 +771,10 @@ int ptrace_request(struct task_struct *c
> >                 ret = put_user(child->ptrace_message, datalp);
> >                 break;
> >
> > +       case PTRACE_PEEKSIGNAL:
> > +               ret = ptrace_peek_signal(child, addr, datavp);
> > +               break;
> > +
> >         case PTRACE_GETSIGINFO:
> >                 ret = ptrace_getsiginfo(child, &siginfo);
> >                 if (!ret)
> >
> 
> 
> 
> -- 
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Author of "The Linux Programming Interface"; http://man7.org/tlpi/
> _______________________________________________
> CRIU mailing list
> CRIU@openvz.org
> https://lists.openvz.org/mailman/listinfo/criu
