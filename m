From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Fri, 27 Mar 2015 01:12:43 -0700
Message-ID: <20150327081243.GA26453@infradead.org>
References: <cover.1426528417.git.milosz@adfin.com>
 <20150326202824.65d03787.akpm@linux-foundation.org>
 <E1YbN1J-0084qO-3s@intern.SerNet.DE>
 <20150326230833.4ccfaebb.akpm@linux-foundation.org>
 <E1YbPEF-0088HN-S8@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E1YbPEF-0088HN-S8@intern.SerNet.DE>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Cc: Andrew Morton <akpm@linux-foundation.org>, Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 27, 2015 at 09:02:51AM +0100, Volker Lendecke wrote:
> No, this is not the case. Maybe my whole understanding of
> pread is wrong: I always thought that it won't return short
> if the file spans the pread range. EINTR nonwithstanding.

Per Posix it could, however if we do it for regular file reads
hell will break lose because no one expects it.  So in practice
it can't.

> 
> > 	if (it's all in cache)
> 
> I know I'm repeating myself: We have a race condition here.
> A small one, but it is racy. I've seen loaded systems where
> we spend seconds between becoming re-scheduled. In these
> systems, it will be the norm to block in later reads. And we
> don't have a good way to detect this situation afterwards
> and turn to threads as a precaution next time.

Exactly.  One that matters in real life, too.  Nevermind that
preadv2 is a way cleaner interface than fincore.
