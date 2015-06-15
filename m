From: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC PATCH 07/18] kthread: Make iterant kthreads freezable by
 default
Date: Mon, 15 Jun 2015 11:28:38 +0200
Message-ID: <20150615092838.GK9409@pathway.suse.cz>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
 <1433516477-5153-8-git-send-email-pmladek@suse.cz>
 <20150609072003.GY21465@mtj.duckdns.org>
 <20150609155313.GC9409@pathway.suse.cz>
 <20150610043154.GG11955@mtj.duckdns.org>
 <20150612132440.GH9409@pathway.suse.cz>
 <20150613232222.GB346@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150613232222.GB346-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat 2015-06-13 18:22:22, Tejun Heo wrote:
> > I try to better understand why freezer is considered to be a blunt
> > tool. Is it because it is a generic API, try_to_freeze() is put on
> > "random" locations, so that it does not define the safe point
> > precisely enough?
>
> Not that.  I don't know how to explain it better.  Hmmm... okay, let's
> say there's a shared queue Q and N users o fit.  If you wanna make Q
> empty and keep it that way for a while, the right thing to do is
> blocking new queueing and then wait till Q drains - you choke the
> entity that you wanna control.
>
> Instead of that, freezer is trying to block the "N" users part.  In
> majority of cases, it blocks enough but it's pretty difficult to be
> sure whether you actually got all N of them (as some of them may not
> involve kthreads at all or unfreezable kthreads might end up doing
> those operations too on corner cases) and it's also not that clear
> whether blocking the N users actually make Q empty.  Maybe there are
> things which can be in flight asynchronously on Q even all its N users
> are blocked.  This is inherently finicky.

I feel convinced that it does not make sense to make kthreads
freezable by default and that we should not use it when not
necessary.

Thanks a lot for patience and so detailed explanation.

Best Regards,
Petr
