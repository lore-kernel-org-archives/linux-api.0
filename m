From: Chris Mason <clm-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v5 9/9] btrfs: btrfs_copy_file_range() only supports
 reflinks
Date: Fri, 16 Oct 2015 07:49:19 -0400
Message-ID: <20151016114919.GB6874@ret.masoncoding.com>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443634014-3026-10-git-send-email-Anna.Schumaker@Netapp.com>
 <20151011142939.GA30905@infradead.org>
 <561B8A09.5070507@draigBrady.com>
 <20151012143444.GA10156@infradead.org>
 <20151012234106.GD11398@birch.djwong.org>
 <20151013072959.GB10794@infradead.org>
 <20151014184608.GK850@birch.djwong.org>
 <20151015060045.GA23996@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151015060045.GA23996-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, P??draig Brady <P@draigBrady.com>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Oct 14, 2015 at 11:00:45PM -0700, Christoph Hellwig wrote:
> On Wed, Oct 14, 2015 at 11:46:08AM -0700, Darrick J. Wong wrote:
> > The documentation for fallocate ought to be updated to include that as part of
> > guaranteeing that subsequent writes to the range won't fail due to ENOSPC,
> > shared blocks will be unshared.
> > 
> > Incidentally, btrfs leaves shared blocks alone.  OTOH, given that it's totally
> > COW it probably doesn't make sense to unshare blocks anyway... but maybe I
> > also don't want to dive into btrfs f-allocation behavior at this time. :)
> > 
> > Ok, so I'll rework the XFS funshare code into something that hangs off the
> > regular fallocate call, and get rid of the explicit 'funshare' bits.
> 
> Yes, that would be my preference.  I'd also like to understand what
> exactly btrfs does in fallocate.

For which part?  The answer changes based on how many references there
are to a given fallocated region.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
