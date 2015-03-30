From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache only)
Date: Mon, 30 Mar 2015 18:49:06 -0400
Message-ID: <CANP1eJH5g0oWaLO0nD7XAcAO-rFHNTGUopF1aPLEifAbPnPOKQ@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150330203227.GA4987@samba2>
Sender: linux-arch-owner@vger.kernel.org
To: Jeremy Allison <jra@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 30, 2015 at 4:32 PM, Jeremy Allison <jra@samba.org> wrote:
> On Mon, Mar 30, 2015 at 01:26:25PM -0700, Andrew Morton wrote:
>>
>> cons:
>>
>> d) fincore() is more expensive
>>
>> e) fincore() will very occasionally block
>
> The above is the killer for Samba. If fincore
> returns true but when we schedule the pread
> we block, we're hosed.
>
> Once we block, we're done serving clients on the main
> thread until this returns. That can cause unpredictable
> response times which can cause client timeouts.
>
> A fincore+pread solution that blocks is simply unsafe
> to use for us. We'll have to stay with the threadpool :-(.

We're getting data from a network filesystem Ceph in our case, but it
could be pNFS. In many cases those filesystems have some kind
hierarchy and it's not uncommon for us to se requests that take 20 to
25 milliseconds to complete. In this case the miss becomes very
expensive. And it's not just that one requests experiences the slow
down all the request being serviced by that (single) epoll thread
experience head-of-line blocking because of one stalled request.

10K request a second is a common load for many web services / video
servers servings chunks of data. If we experience one miss a second,
that 25 million stall will impact 250 other requests (all of them will
have a 25ms latency tacked on).

>
>> And I don't believe that e) will be a problem in the real world.  It's
>> a significant increase in worst-case latency and a negligible increase
>> in average latency.  I've asked at least three times for someone to
>> explain why this is unacceptable and no explanation has been provided.
>
> See above.



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
