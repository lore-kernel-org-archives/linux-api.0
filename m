From: Brian Foster <bfoster-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] block: implement (some of) fallocate for block
 devices
Date: Mon, 21 Mar 2016 16:59:29 -0400
Message-ID: <20160321205928.GA48412@bfoster.bfoster>
References: <20160315194221.30093.70506.stgit@birch.djwong.org>
 <20160315194244.30093.6483.stgit@birch.djwong.org>
 <CAMM=eLf1kj0btbxX=QqWzPm_M1MiGYqK9z6sCYqdbqMQ-b3R1Q@mail.gmail.com>
 <20160321191116.GB12309@birch.djwong.org>
 <20160321192229.GA17220@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160321192229.GA17220-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 21, 2016 at 03:22:29PM -0400, Mike Snitzer wrote:
> On Mon, Mar 21 2016 at  3:11pm -0400,
> Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Mon, Mar 21, 2016 at 02:52:00PM -0400, Mike Snitzer wrote:
> > > On Tue, Mar 15, 2016 at 3:42 PM, Darrick J. Wong
> > > <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > > > After much discussion, it seems that the fallocate feature flag
> > > > FALLOC_FL_ZERO_RANGE maps nicely to SCSI WRITE SAME; and the feature
> > > > FALLOC_FL_PUNCH_HOLE maps nicely to the devices that have been
> > > > whitelisted for zeroing SCSI UNMAP.  Punch still requires that
> > > > FALLOC_FL_KEEP_SIZE is set.  A length that goes past the end of the
> > > > device will be clamped to the device size if KEEP_SIZE is set; or will
> > > > return -EINVAL if not.  Both start and length must be aligned to the
> > > > device's logical block size.
> > > >
> > > > Since the semantics of fallocate are fairly well established already,
> > > > wire up the two pieces.  The other fallocate variants (collapse range,
> > > > insert range, and allocate blocks) are not supported.
> > > 
> > > I'd like to see fallocate (block allocation) extend down to DM thinp.
> > > This more traditional use of fallocate would be useful for ensuring
> > > ENOSPC won't occur -- especially important if the FS has committed
> > > space in response to fallocate.  As of now fallocate doesn't inform DM
> > > thinp at all.  Curious why you decided not to wire it up?
> > 
> > I don't know what to wire it up to. :)
> 
> Fair enough.  Yes something needs to be invented.
>  
> > I didn't find any blkdev_* function that looked encouraging, though I
> > haven't dug too deeply into bfoster's "prototype a block reservation
> > allocation model" patchset yet.  At a high level I'd guess that would
> > be a reasonable piece to connect to?  It looks like the piece I want
> > is blk_provision_space().
> 
> Yes, something like that.
> 

Just a note that the caveat/hack with the provision call in there is
that it returns an allocated block count. That was necessary to help
maintain the local reservation accounting. I'd love to find a way to
handle that more cleanly or take advantage of generic fallocate, but I
don't have a clear idea on how to do that at the moment. (I do wonder
whether an internal-only set of falloc "reserve" flags would fly...).

Anyways, that's a separate topic. Feel free to steal any of that dm-thin
provision code if it is useful for generic fallocate(). :)

Brian

> > > But I'm not sure what "it" (the "allocate blocks" variant) even is
> > > given falloc.h doesn't show anything like "_ALLOCATE_BLOCKS"...
> > 
> > The default behavior of fallocate is to allocate blocks, which means
> > that one invokes it by not passing any mode flags (except possibly
> > KEEP_SIZE).
> 
> OK.
> 
> > > It would require a new block interface to pass the fallocate extent
> > > down.  But it seems bizarre to implement "some of" fallocate but not
> > > the most widely used case for fallocate.
> > 
> > Agreed.  I'd like to get the existing functionality wired up sooner than
> > later, and plumbing "allocate blocks" down to thinp can be done as a
> > followup.
> > 
> > (Or stall long enough that it becomes one patchset.)
> 
> Sure, sounds good.  Glad we're in agreement.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
