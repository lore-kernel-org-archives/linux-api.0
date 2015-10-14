From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 9/9] btrfs: btrfs_copy_file_range() only supports
 reflinks
Date: Wed, 14 Oct 2015 11:46:08 -0700
Message-ID: <20151014184608.GK850@birch.djwong.org>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443634014-3026-10-git-send-email-Anna.Schumaker@Netapp.com>
 <20151011142939.GA30905@infradead.org>
 <561B8A09.5070507@draigBrady.com>
 <20151012143444.GA10156@infradead.org>
 <20151012234106.GD11398@birch.djwong.org>
 <20151013072959.GB10794@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151013072959.GB10794-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: P??draig Brady <P@draigBrady.com>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 13, 2015 at 12:29:59AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 12, 2015 at 04:41:06PM -0700, Darrick J. Wong wrote:
> > One of the patches in last week's XFS reflink patchbomb adds FALLOC_FL_UNSHARE
> > flag; at the moment it _only_ forces copy-on-write of shared blocks, and it
> > leaves holes alone.
> 
> Yes, I've seen the implementation. 
> 
> > Obviously we haven't yet figured out what are peoples' preferences in terms of
> > "fill the holes and unshare the shared" vs. "only unshare the shared" vs. "only
> > fill the holes".  It isn't that hard to add a FALLOC_FL_UNSHARE_FILL_HOLES flag
> > that fills the holes while unsharing is going on.
> > 
> > Personally I suspect that the most interest is in filling holes and unsharing,
> > because they don't want to pay for allocation at a critical stage for anywhere
> > in the file.  But I could be wrong, so allowing both goals to be expressed via
> > mode allows flexibility.
> 
> Exactly.  And a normal falloc should do just that - fill holes and
> ensure that we don't need to COW already allocated locks.  So I don't
> think we need a new fallocate interface for that.

The documentation for fallocate ought to be updated to include that as part of
guaranteeing that subsequent writes to the range won't fail due to ENOSPC,
shared blocks will be unshared.

Incidentally, btrfs leaves shared blocks alone.  OTOH, given that it's totally
COW it probably doesn't make sense to unshare blocks anyway... but maybe I
also don't want to dive into btrfs f-allocation behavior at this time. :)

Ok, so I'll rework the XFS funshare code into something that hangs off the
regular fallocate call, and get rid of the explicit 'funshare' bits.

> The question is if we
> want a copy interface that gives you the same semantics as if you also
> called an fallocate on the destination range.  For that case we'd
> usually want to avoid doing the clone and instead do a in-kernel or
> hardware assisted copy and then fill the holes with unwritten extents.

Probably; I can easily imagine people wanting to fill the holes and also
not wanting them filled.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
