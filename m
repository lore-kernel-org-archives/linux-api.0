From: Alexander Shishkin <virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org>
Subject: Re:
 timerfd-add-tfd_notify_clock_set-to-watch-for-clock-changes.patch added to
 -mm tree
Date: Fri, 11 Mar 2011 17:08:57 +0200
Message-ID: <20110311150857.GJ11410@shisha.kicks-ass.net>
References: <20110311135023.GA23552@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110311135023.GA23552-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Tokarev <mjt-XAri/EZa3C4vJsYlp49lxw@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Shishkin <virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2011 at 02:50:23PM +0100, Oleg Nesterov wrote:
> > @@ -218,10 +266,12 @@ SYSCALL_DEFINE4(timerfd_settime, int, uf
> >  	 * it to the new values.
> >  	 */
> >  	for (;;) {
> > +		spin_lock(&notifiers_lock);
> >  		spin_lock_irq(&ctx->wqh.lock);
> > -		if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
> > +		if (!list_empty(&notifiers_list) || hrtimer_try_to_cancel(&ctx->tmr) >= 0)
> >  			break;
> 
> Confused. Why do we check the global notifiers_list?

You're right, it's a bug, should be &ctx->notifiers_list.

> IOW. Suppose that this list is not empty and timerfd_settime() is called
> without TFD_NOTIFY_CLOCK_SET. Now we are going to reprogramm the timer
> without stopping it?
> 
> And. What if timerfd_settime(TFD_NOTIFY_CLOCK_SET, utmr => NULL) is called
> twice? timerfd_setup() blindly does list_add(), and we corrupt the list, no?

Another catch.

There will be a quite a bit of rework required, though, considering tglx's
comments.

Thanks!
--
Alex
