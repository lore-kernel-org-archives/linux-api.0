From: Dave Chinner <david@fromorbit.com>
Subject: Re: fallocate mode flag for "unshare blocks"?
Date: Thu, 31 Mar 2016 12:18:13 +1100
Message-ID: <20160331011813.GJ30721@dastard>
References: <20160302155007.GB7125@infradead.org>
 <20160330182755.GC2236@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160330182755.GC2236@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
> Or is it ok that fallocate could block, potentially for a long time as
> we stream cows through the page cache (or however unshare works
> internally)?  Those same programs might not be expecting fallocate to
> take a long time.

Yes, it's perfectly fine for fallocate to block for long periods of
time. See what gfs2 does during preallocation of blocks - it ends up
calling sb_issue_zerout() because it doesn't have unwritten
extents, and hence can block for long periods of time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
