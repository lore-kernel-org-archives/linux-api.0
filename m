From: Chris Mason <clm-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v5 9/9] btrfs: btrfs_copy_file_range() only supports
 reflinks
Date: Fri, 16 Oct 2015 09:19:50 -0400
Message-ID: <20151016131950.GC6874@ret.masoncoding.com>
References: <1443634014-3026-10-git-send-email-Anna.Schumaker@Netapp.com>
 <20151011142939.GA30905@infradead.org>
 <561B8A09.5070507@draigBrady.com>
 <20151012143444.GA10156@infradead.org>
 <20151012234106.GD11398@birch.djwong.org>
 <20151013072959.GB10794@infradead.org>
 <20151014184608.GK850@birch.djwong.org>
 <20151015060045.GA23996@infradead.org>
 <20151016114919.GB6874@ret.masoncoding.com>
 <20151016122544.GC5889@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151016122544.GC5889-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, P??draig Brady <P@draigBrady.com>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 16, 2015 at 05:25:44AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 16, 2015 at 07:49:19AM -0400, Chris Mason wrote:
> > > Yes, that would be my preference.  I'd also like to understand what
> > > exactly btrfs does in fallocate.
> > 
> > For which part?  The answer changes based on how many references there
> > are to a given fallocated region.
> 
> Both cases.  With btrfs allocating new block on every write how do you
> avoid that ENOSPC?  Is there a unassigned block preallocation that's
> made persistent in some way?

So:

fallocate 1g -> foo

reflink foo foo2

We've now implicitly doubled the size of the fallocate, but at reflink
time btrfs doesn't account for the doubling.  It's actually much
better in this case to just use a hole because neither foo or foo2 can
use the preallocated space until the 1g is fully unshared.

When we're doing writes, it'll check the preallocated extents for extra
refs and force COW if any exist.  So writes into a preallocated region
can enospc.

-chris
