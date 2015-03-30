From: Jeremy Allison <jra@samba.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Mon, 30 Mar 2015 13:32:27 -0700
Message-ID: <20150330203227.GA4987@samba2>
References: <cover.1426528417.git.milosz@adfin.com>
 <20150326202824.65d03787.akpm@linux-foundation.org>
 <20150327081822.GA28669@infradead.org>
 <20150327013516.8c6788be.akpm@linux-foundation.org>
 <20150327084833.GA7689@infradead.org>
 <20150327020159.eadd0ce1.akpm@linux-foundation.org>
 <20150327155854.GA5548@samba2>
 <20150330073604.GB22229@infradead.org>
 <20150330132625.52b1250527ca3dcda79e349e@linux-foundation.org>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150330132625.52b1250527ca3dcda79e349e@linux-foundation.org>
Sender: linux-arch-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jeremy Allison <jra@samba.org>, Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 30, 2015 at 01:26:25PM -0700, Andrew Morton wrote:
> 
> cons:
> 
> d) fincore() is more expensive
> 
> e) fincore() will very occasionally block

The above is the killer for Samba. If fincore
returns true but when we schedule the pread
we block, we're hosed.

Once we block, we're done serving clients on the main
thread until this returns. That can cause unpredictable
response times which can cause client timeouts.

A fincore+pread solution that blocks is simply unsafe
to use for us. We'll have to stay with the threadpool :-(.

> And I don't believe that e) will be a problem in the real world.  It's
> a significant increase in worst-case latency and a negligible increase
> in average latency.  I've asked at least three times for someone to
> explain why this is unacceptable and no explanation has been provided.

See above.
