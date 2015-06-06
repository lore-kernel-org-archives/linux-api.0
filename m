From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 11/18] jffs2: Convert jffs2_gcd_mtd kthread into
	the iterant API
Date: Sun, 7 Jun 2015 00:58:54 +0200
Message-ID: <20150606225854.GA20352@redhat.com>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz> <1433516477-5153-12-git-send-email-pmladek@suse.cz> <20150606211648.GA15591@redhat.com> <alpine.LNX.2.00.1506062322550.12753@pobox.suse.cz> <20150606223001.GA18838@redhat.com> <alpine.LNX.2.00.1506070034100.12753@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1506070034100.12753-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 06/07, Jiri Kosina wrote:
>
> On Sun, 7 Jun 2015, Oleg Nesterov wrote:
>
> > > I personally don't see a huge principal difference between
> > > "kthread_signal_dequeue() + kthread_do_signal_{stop,...}" vs. generic
> > > "kthread_do_signal()" that's just basically completely general and
> > > takes care of 'everything necessary'.
> >
> > Then why do we need the new API ?
>
> Well, in a nutshell, because of the "it's general and takes care of
> everything" part.

...

> Signal handling is just
> one of the piggy-backers on top of this general cleanup.

And to avoid the confusion: so far I only argued with the signal
handling part of this API. Namely with kthread_do_signal(), especially
with the SIG_DFL logic.

If we want somthing like kthread_iterant agree it should probably help to
handle the signals too. But afaics kthread_do_signal() doesn't really help
and certainly it is not strictly necessary.

Oleg.
