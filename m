From: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache only)
Date: Mon, 30 Mar 2015 19:06:45 -0400
Message-ID: <CANP1eJEjj-kGsMUi_YUZqdPC3JH0GWNAKvter2RM0DfeitWSbg@mail.gmail.com>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326202824.65d03787.akpm@linux-foundation.org>
	<20150327081822.GA28669@infradead.org>
	<20150327013516.8c6788be.akpm@linux-foundation.org>
	<20150327084833.GA7689@infradead.org>
	<20150327020159.eadd0ce1.akpm@linux-foundation.org>
	<20150327155854.GA5548@samba2>
	<20150330073604.GB22229@infradead.org>
	<20150330132625.52b1250527ca3dcda79e349e@linux-foundation.org>
	<20150330203227.GA4987@samba2>
	<CANP1eJH5g0oWaLO0nD7XAcAO-rFHNTGUopF1aPLEifAbPnPOKQ@mail.gmail.com>
	<20150330155700.92f4c8a0bf13418aaf01ae04@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150330155700.92f4c8a0bf13418aaf01ae04-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Volker Lendecke <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 30, 2015 at 6:57 PM, Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Mon, 30 Mar 2015 18:49:06 -0400 Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org> wrote:
>
>> > A fincore+pread solution that blocks is simply unsafe
>> > to use for us. We'll have to stay with the threadpool :-(.
>>
>> We're getting data from a network filesystem Ceph in our case, but it
>> could be pNFS. In many cases those filesystems have some kind
>> hierarchy and it's not uncommon for us to se requests that take 20 to
>> 25 milliseconds to complete. In this case the miss becomes very
>> expensive. And it's not just that one requests experiences the slow
>> down all the request being serviced by that (single) epoll thread
>> experience head-of-line blocking because of one stalled request.
>>
>> 10K request a second is a common load for many web services / video
>> servers servings chunks of data. If we experience one miss a second,
>> that 25 million stall will impact 250 other requests (all of them will
>> have a 25ms latency tacked on).
>
> I'd expect a fincore() which doesn't do SetPageReferenced() to be
> orders of magnitude better than this.  A fincore() which does use
> SetPageReferenced() will be in the "basically never happens" region -
> it would take massive and artificial memory stress to trigger.

I'm just responding to the upper bound you put out in an email a few
back of 0.0001% miss. And, people run web caches (like Apache Traffic
Server) at much higher rates than that.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org
