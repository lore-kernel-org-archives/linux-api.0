From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Mon, 30 Mar 2015 00:36:04 -0700
Message-ID: <20150330073604.GB22229@infradead.org>
References: <cover.1426528417.git.milosz@adfin.com>
 <20150326202824.65d03787.akpm@linux-foundation.org>
 <20150327081822.GA28669@infradead.org>
 <20150327013516.8c6788be.akpm@linux-foundation.org>
 <20150327084833.GA7689@infradead.org>
 <20150327020159.eadd0ce1.akpm@linux-foundation.org>
 <20150327155854.GA5548@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150327155854.GA5548@samba2>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeremy Allison <jra@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 27, 2015 at 08:58:54AM -0700, Jeremy Allison wrote:
> The problem with the above is that we can't tell the difference
> between pread2() returning a short read because the pages are not
> in cache, or because someone truncated the file. So we need some
> way to differentiate this.

Is a race vs truncate really that time critical that you can't
wait for the thread pool to do the second read to notice it?

> My preference from userspace would be for pread2() to return
> EAGAIN if *all* the data requested is not available (where
> 'all' can be less than the size requested if the file has
> been truncated in the meantime).

That is easily implementable, but I can see that for example web apps
would be happy to get as much as possible.  So if Samba can be ok
with short reads and only detecting the truncated case in the slow
path that would make life simpler.  Otherwise we might indeed need two
flags.
