From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch 050/160] prctl: add PR_SET_PROCTITLE_AREA option for prctl()
Date: Tue,  9 Mar 2010 14:14:09 +0900 (JST)
Message-ID: <20100309134421.7CDE.A69D9226@jp.fujitsu.com>
References: <201003052142.o25Lgbpg029522@imap1.linux-foundation.org> <alpine.LFD.2.00.1003061100170.4530@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.00.1003061100170.4530-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tss-X3B1VOXEql0@public.gmane.org, xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

> 
> 
> On Fri, 5 Mar 2010, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:
> > 
> > This patch makes it possible for userspace to implement setproctitle()
> > cleanly.  It adds a new PR_SET_PROCTITLE_AREA option for prctl(), which
> > updates task's mm_struct->arg_start and arg_end to the given area.
> 
> This looks overly complicated. Why do you change the whole locking rules, 
> instead of protecting _only_ the "arg_start/arg_end" case? 
> 
> The thing is, there's no reason to hold the mmap_sem over the whole thing, 
> and I don't think this is important enough to be a valid reason for 
> exposing a whole new "locked" access variant, when a simple "protect just 
> the arg_start/end" would handle it.

Hmm..

I did it at several previous iteration. but Alan and Oleg don't like such
approach. After small discussion, we concluded that this reusing mmap_sem doesn't
have unignorable downside.

We discussed this patch need to conder following two performance worrieness.

Q1) The system doesn't have badboy process, it shouldn't have system
    performance degression.
A1) In writer side, setproctitle() is not frequently called function.
    then, performance damage is nothing. In reader side, this patch doesn't
    add to take any new lock.

Q2) The attacker's process use setproctitle() for attack. The system
    should have enough DoS tolerability.
A2) a lot of /proc file takes mmap_sem. then, this feature doesn't introduce
    new attack way. plus, fork-bomb provide very efficient attack way rather
    than mmap_sem flood. then, we concluded the attackers don't use mmap_sem
    flood in practice.


However, reusing mmap_sem is not my strong mention. if you really dislike it,
I can change it soon.
