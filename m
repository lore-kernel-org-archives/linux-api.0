From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Date: Fri, 9 Oct 2009 23:39:35 -0700
Message-ID: <20091009233935.1be0edf9.akpm@linux-foundation.org>
References: <20091009134354.12A7.A69D9226@jp.fujitsu.com>
	<20091009171344.3fc5f28b.akpm@linux-foundation.org>
	<3e8340490910091922g7891b31al649e91f15ffae687@mail.gmail.com>
	<20091009194250.eb76e338.akpm@linux-foundation.org>
	<3e8340490910091957t21eb16e0r63eba2314ddb83a8@mail.gmail.com>
	<2f11576a0910092332s6e0e3dcs35864e3a2164be0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2f11576a0910092332s6e0e3dcs35864e3a2164be0-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Bryan Donlan <bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Timo Sirainen <tss-X3B1VOXEql0@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, 10 Oct 2009 15:32:35 +0900 KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:

> >>> The solution is to use the seqlock to detect this, and prevent the
> >>> secret information from ever making it back to process B's userspace.
> >>> Note that it's not enough to just recheck arg_start, as process A may
> >>> reassign the proctitle area back to its original position after having
> >>> it somewhere else for a while.
> >>
> >> Well seqlock is _a_ solution. __Another is to use a mutex or an rwsem
> >> around the whole operation.
> >>
> >> With the code as you propose it, what happens if a process sits in a
> >> tight loop running setproctitle? __Do other processes running `ps' get
> >> stuck in a livelock until the offending process gets scheduled out?
> >
> > It does seem like a maximum spin count should be put in there - and
> > maybe a timeout as well (since with FUSE etc it's possible to engineer
> > page faults that take arbitrarily long).
> > Also, it occurs to me that:
> 
> makes sense.
> I like maximum spin rather than timeout.

Start simple.  What's wrong with mutex_lock() on the reader and writer
sides?  rwsems might be OK too.

In both cases we should think about whether persistent readers can
block the writer excessively though.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
