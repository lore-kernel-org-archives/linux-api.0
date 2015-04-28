From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Should mmap MAP_LOCKED fail if mm_poppulate fails?
Date: Tue, 28 Apr 2015 22:21:41 +0200
Message-ID: <20150428202140.GC30918@dhcp22.suse.cz>
References: <20150114095019.GC4706@dhcp22.suse.cz>
 <1430223111-14817-1-git-send-email-mhocko@suse.cz>
 <CA+55aFxzLXx=cC309h_tEc-Gkn_zH4ipR7PsefVcE-97Uj066g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxzLXx=cC309h_tEc-Gkn_zH4ipR7PsefVcE-97Uj066g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue 28-04-15 09:01:59, Linus Torvalds wrote:
> On Tue, Apr 28, 2015 at 5:11 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> >
> > The first patch is dumb and straightforward. It should be safe as is and
> > also good without the follow up 2 patches which try to handle potential
> > allocation failures in the do_munmap path more gracefully. As we still
> > do not fail small allocations even the first patch could be simplified
> > a bit and the retry loop replaced by a BUG_ON right away.
> 
> I think the BUG_ON() is a bad idea in the first place, and is in fact
> a good reason to ignore the patch series entirely.

> What is the point of that BUG_ON()?
> 
> Hell, people add too many of those things. There is *no* excuse for
> killing the kernel for things like this (and in certain setups,
> BUG_ON() *will* cause the machine to be rebooted). None. It's
> completely inexcusable.
> 
> Thinking like this must go. BUG_ON() is for things where our internal
> data structures are so corrupted that we don't know what to do, and
> there's no way to continue. Not for "I want to sprinkle these things
> around and this should not happen".

The BUG_ON in do_munmap_nofail was to catch an unexpected failure
mode which would be caused by later changes. So it was a way to express
an invariant.
Anyway I understand your point above.

> I also think that the whole complex "do_munmap_nofail()" is broken to
> begin with,

Could you be more specific please?

> along with the crazy "!fatal_signal_pending()" thing.

The primary motivation was to back out when we know that the whole
thread group will go and we will cleanup the whole state anyway. As
the only real reason to fail do_munmap is an allocation failure (the
sysctl_max_map_count one is pro-actively avoided) then this basically
means that we have been OOM killed.
On the other hand the allocating thread will get TIF_MEMDIE and access
to memory reserves sooner or later if we are really OOM so the explicit
check is not really needed and it can be dropped.

> There is absolutely no excuse for any of this.
> 
> Your code is also fundamentally buggy in that it tries to do unmap()
> after it has dropped all locks, and things went wrong. So you may nto
> be unmapping some other threads data.
> 
> There is no way in hell any of these patches can ever be applied.
> 
> There's a reason we don't handle populate failures - it's exactly
> because we've dropped the locks etc. After dropping the locks, we
> *cannot* clean up any more, because there's no way to know whather
> we're cleaning up the right thing.  You'd have to hold the write lock
> over the whole populate, which has serious problems of its own.
> 
> So NAK on this series. I think just documenting the man-page might be
> better. I don't think MAP_LOCKED is sanely fixable.

I am OK with this answer as well. Users who really need no-later faults
behavior should use mlock(). I will cook up a patch for man pages and
post it tomorrow.

> We might improve on MAP_LOCKED by having a heuristic up-front
> (*before* actually doing any mmap) to verify that it's *likely* that
> it will work. So we could return ENOMEM early if it looks like the
> user would hit the resource limits, for example. That wouldn't be any
> guarantee (another process might eat up the resource limit anyway),
> and in fact it might be overly eager to fail (maybe the
> mmap(MAP_LOCKED ends up unmapping an older locked mapping and we deny
> it too eagerly), but it would probably work well enough in practice.

As you've said. This would be inherently racy. Some of those checks are
already done before any destructive actions but this doesn't cover all
of them and certainly cannot cover the area fault in by definition.

> That, together with a warning in the man-page about mmap(MAP_LOCKED)
> not being able to return "I only locked part of the mapping", if you
> want full error handling you need to do mmap()+mlock() and check the
> two errors separately.
> 
> Hmm? But I really dislike your patch-series as-is.
> 
>                        Linus
> 
>                       Linus
> 
>                            Linus

-- 
Michal Hocko
SUSE Labs
