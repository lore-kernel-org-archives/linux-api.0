From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Mon, 30 Mar 2015 15:57:00 -0700
Message-ID: <20150330155700.92f4c8a0bf13418aaf01ae04@linux-foundation.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CANP1eJH5g0oWaLO0nD7XAcAO-rFHNTGUopF1aPLEifAbPnPOKQ@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Milosz Tanski <milosz@adfin.com>
Cc: Jeremy Allison <jra@samba.org>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Mon, 30 Mar 2015 18:49:06 -0400 Milosz Tanski <milosz@adfin.com> wrote:

> > A fincore+pread solution that blocks is simply unsafe
> > to use for us. We'll have to stay with the threadpool :-(.
> 
> We're getting data from a network filesystem Ceph in our case, but it
> could be pNFS. In many cases those filesystems have some kind
> hierarchy and it's not uncommon for us to se requests that take 20 to
> 25 milliseconds to complete. In this case the miss becomes very
> expensive. And it's not just that one requests experiences the slow
> down all the request being serviced by that (single) epoll thread
> experience head-of-line blocking because of one stalled request.
> 
> 10K request a second is a common load for many web services / video
> servers servings chunks of data. If we experience one miss a second,
> that 25 million stall will impact 250 other requests (all of them will
> have a 25ms latency tacked on).

I'd expect a fincore() which doesn't do SetPageReferenced() to be
orders of magnitude better than this.  A fincore() which does use
SetPageReferenced() will be in the "basically never happens" region -
it would take massive and artificial memory stress to trigger.
