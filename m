From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/6] vfs: support FS_XFLAG_REFLINK and FS_XFLAG_COWEXTSIZE
Date: Tue, 6 Sep 2016 12:15:15 -0700
Message-ID: <20160906191515.GA26927@birch.djwong.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
 <147216786073.525.16014208838990530622.stgit@birch.djwong.org>
 <20160905145622.GB7662@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160905145622.GB7662-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 05, 2016 at 07:56:22AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 25, 2016 at 04:31:00PM -0700, Darrick J. Wong wrote:
> > Introduce XFLAGs for the new XFS reflink inode flag and the CoW extent
> > size hint, and actually plumb the CoW extent size hint into the fsxattr
> > structure.
> 
> Just curious, but why would we even bother to expose the reflink flag
> to userspace?

So far I've put the reflink flag to use in xfs_scrub to look for
obvious signs of brokenness such as extents that overlap or have the
shared flag set but the inode flag is off; and to skip various kinds
of checks that don't have to happen when blocks don't overlap.

I doubt there's much of a use for the flag outside of the XFS utilities.
For a while I pondered only exposing the fsxattr flag if the caller had
CAP_SYS_ADMIN (the level of priviledge required to run scrub) but
decided that I wouldn't change the existing interface like that unless
I had a really good reason.

--D
