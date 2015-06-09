From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 07/18] kthread: Make iterant kthreads freezable by
 default
Date: Tue, 9 Jun 2015 16:20:03 +0900
Message-ID: <20150609072003.GY21465@mtj.duckdns.org>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
 <1433516477-5153-8-git-send-email-pmladek@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433516477-5153-8-git-send-email-pmladek-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello, Petr.

On Fri, Jun 05, 2015 at 05:01:06PM +0200, Petr Mladek wrote:
> Many kthreads already calls set_freezable() before they enter the main
> cycle. One of the reasons for creating iterant kthreads is to create
> a safe point for freezing and make even more kthreads properly
> freezable. Therefore it would make sense to set all iterant
> kthreads freezable by default.

Actually, for most cases, making kthreads freezable is unnecessary and
often indicative of something going wrong.  This is a crude mechanism
which goes along the line of "if all threads are stopped, the machine
should be safe to be put into whatever state", which isn't true at all
as there usually are a lot of stuff going on asynchronously especially
when interacting with hardware.

In most cases, we want to implement proper power management callbacks
which plug new issuance of whatever work-unit the code is dealing with
and drain in-flight ones.  Whether the worker threads are frozen or
not doesn't matter once that's implemented.

It seems that people have been marking kthreads freezable w/o really
thinking about it - some of them are subtly broken due to missing
drainage of in-flight things while others simply don't need freezing
for correctness.

We do want to clean up freezer usage in the kernel but definitely do
not want to make kthreads freezable by default especially given that
the freezer essentially is one giant lockdep-less system-wide lock.

> However some kthreads might be hard to make properly freezable.
> For example, if they do non-interruptible sleeps. They would
> need to explicitly clear PF_NOFREEZE flag in the init() call.
> But it should be avoided whenever possible.

So, big no here.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
