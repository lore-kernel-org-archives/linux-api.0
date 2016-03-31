From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fallocate mode flag for "unshare blocks"?
Date: Thu, 31 Mar 2016 00:54:40 -0700
Message-ID: <20160331075440.GA4209@infradead.org>
References: <20160302155007.GB7125@infradead.org>
 <20160330182755.GC2236@birch.djwong.org>
 <20160331011813.GJ30721@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160331011813.GJ30721@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 31, 2016 at 12:18:13PM +1100, Dave Chinner wrote:
> On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
> > Or is it ok that fallocate could block, potentially for a long time as
> > we stream cows through the page cache (or however unshare works
> > internally)?  Those same programs might not be expecting fallocate to
> > take a long time.
> 
> Yes, it's perfectly fine for fallocate to block for long periods of
> time. See what gfs2 does during preallocation of blocks - it ends up
> calling sb_issue_zerout() because it doesn't have unwritten
> extents, and hence can block for long periods of time....

gfs2 fallocate is an implementation that will cause all but the most
trivial users real pain.  Even the initial XFS implementation just
marking the transactions synchronous made it unusable for all kinds
of applications, and this is much worse.  E.g. a NFS ALLOCATE operation
to gfs2 will probab;ly hand your connection for extended periods of
time.

If we need to support something like what gfs2 does we should have a
separate flag for it.
