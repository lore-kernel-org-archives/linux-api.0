From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Thu, 26 Mar 2015 23:08:33 -0700
Message-ID: <20150326230833.4ccfaebb.akpm@linux-foundation.org>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326202824.65d03787.akpm@linux-foundation.org>
	<E1YbN1J-0084qO-3s@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1YbN1J-0084qO-3s-dqLtpHMqGvUyWpdLl23E4A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org
Cc: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 27 Mar 2015 06:41:25 +0100 Volker Lendecke <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org> wrote:

> On Thu, Mar 26, 2015 at 08:28:24PM -0700, Andrew Morton wrote:
> > A thing which bugs me about pread2() is that it is specifically
> > tailored to applications which are able to use a partial read result. 
> > ie, by sending it over the network.
> 
> Can you explain what you mean by this? Samba gets a pread
> request from a client for some bytes. The client will be
> confused when we send less than requested although the file
> is long enough to satisfy all.

Well it was my assumption that samba would be able to do something
useful with a partial read - pread() is allowed to return less than requested.

If it isn't the case that samba can use the partial read result then
what does it do?  It has to save the partial data, then do the
additional IO?  That's pretty clunky compared to

	if (it's all in cache)
		read it all now
	else
		ask a worker thread to read it all

> > And of course fincore could be used by Samba etc to avoid blocking on
> > reads.  It wouldn't perform quite as well as pread2(), but I bet it's
> > good enough.
> > 
> > Bottom line: with pread2() there's still a need for fincore(), but with
> > fincore() there probably isn't a need for pread2().
> 
> fincore would be a second syscall per pread, and it is not
> atomic. I've had discussions with MIPS based vendors who
> are worried about every single syscall. This is the #1
> hottest code path in Samba.

Bear in mind that these operations involve physical IO and large
memcpy's.  Yes, a fincore() approach will consume more CPU but the
additional overhead will be relatively small.

Tradeoffs are involved, and it may turn out that choosing a more
flexible and powerful interface which is somewhat more CPU intensive is
a better decision.  It's hard to say until this is quantified (ie:
measured).

> > And I'm doubtful about claims that it absolutely has to be non-blocking
> > 100% of the time.  I bet that 99.99% is good enough.  A fincore()
> > option to run mark_page_accessed() against present pages would help
> > with the race-with-reclaim situation.
> 
> If you can make sure that after an fincore the pages remain
> in memory for x milliseconds the atomicity concern might go
> away.

It won't be guaranteed that the fincore()+pread() will be
non-blocking.  But blocking will be very rare.  I don't know whether
the additional expense of activating the pages within fincore() is
justified - needs runtime testing.
