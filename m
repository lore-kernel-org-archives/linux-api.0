From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Date: Tue, 13 Oct 2009 09:03:22 +0900 (JST)
Message-ID: <20091013083744.C747.A69D9226@jp.fujitsu.com>
References: <20091013022335.C741.A69D9226@jp.fujitsu.com> <20091012122246.a941013b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091012122246.a941013b.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Bryan Donlan <bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Timo Sirainen <tss-X3B1VOXEql0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> On Tue, 13 Oct 2009 04:03:45 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> 
> > > Start simple.  What's wrong with mutex_lock() on the reader and writer
> > > sides?  rwsems might be OK too.
> > > 
> > > In both cases we should think about whether persistent readers can
> > > block the writer excessively though.
> > 
> > I thought your mention seems reasonable. then I mesured various locking
> > performance.
> > 
> > 		no-contention	read-read contetion	read-write contention
> > w/o patch	4627 ms		 7575 ms		 N/A
> > mutex		5717 ms		33872 ms (!)		14793 ms
> > rw-semaphoe	6846 ms		10734 ms		36156 ms (!)
> > seqlock		4754 ms		 7558 ms		 9373 ms
> > 
> > Umm, seqlock is significantly better than other.
> 
> Sure, but even the worst case there is 1,000,000 operations in 34
> seconds (yes?). 33 microseconds for a /proc read while under a specific
> local DoS attack is OK!
> 
> If so then all implementations are acceptable and we should choose the
> simplest, most-obviously-correct one.

Hm, ok!

I had guessed you don't accept this slowness. but my guess was wrong.
I have no objection to use rw-semaphoe if you accept it. 
