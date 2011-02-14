From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH, v6 2/3] Implement timer slack notifier chain
Date: Mon, 14 Feb 2011 16:52:44 +0200
Message-ID: <20110214145244.GB3666@shutemov.name>
References: <1297688787-3592-1-git-send-email-kirill@shutemov.name>
 <1297688787-3592-3-git-send-email-kirill@shutemov.name>
 <alpine.LFD.2.00.1102141428080.26192@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102141428080.26192-bi+AKbBUZKagILUCTcTcHdKyNwTtLsGr@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 14, 2011 at 02:32:23PM +0100, Thomas Gleixner wrote:
> On Mon, 14 Feb 2011, Kirill A. Shutsemov wrote:
> 
> > From: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> > 
> > Process can change its timer slack using prctl(). Timer slack notifier
> > call chain allows to react on such change or forbid it.
> 
> So we add a notifier call chain and more exports to allow what ?

To allow the cgroup contoller validate the value.

> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -1691,15 +1691,10 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
> >  			error = perf_event_task_enable();
> >  			break;
> >  		case PR_GET_TIMERSLACK:
> > -			error = current->timer_slack_ns;
> > +			error = prctl_get_timer_slack();
> 
>   What's the point of replacing current->timer_slack_ns with a
>   function which does exactly the same ?

To keep it consistent. BTW, prctl_get_seccomp() does the same.

> 
> > +long prctl_set_timer_slack(long timer_slack_ns)
> > +{
> > +	int err;
> > +
> > +	/* Reset timer slack to default value */
> > +	if (timer_slack_ns <= 0) {
> > +		current->timer_slack_ns = current->default_timer_slack_ns;
> > +		return 0;
> 
>   That does not make any sense at all. Why is setting
>   default_timer_slack_ns not subject to validation ?

Hm.. In case of cgroup_timer_slack it's always valid.
But, yes, in general, we should validate it.

>   Why is it treaded seperately ?

What do you mean?

> > +	}
> > +
> > +	err = blocking_notifier_call_chain(&timer_slack_notify_list,
> > +			timer_slack_ns, NULL);
> > +	if (err == NOTIFY_DONE)
> > +		current->timer_slack_ns = timer_slack_ns;
> > +
> > +	return notifier_to_errno(err);
> 
> Thanks,
> 
> 	tglx

-- 
 Kirill A. Shutemov
