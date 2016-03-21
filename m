From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/3] block: implement (some of) fallocate for block
 devices
Date: Mon, 21 Mar 2016 15:22:29 -0400
Message-ID: <20160321192229.GA17220@redhat.com>
References: <20160315194221.30093.70506.stgit@birch.djwong.org>
 <20160315194244.30093.6483.stgit@birch.djwong.org>
 <CAMM=eLf1kj0btbxX=QqWzPm_M1MiGYqK9z6sCYqdbqMQ-b3R1Q@mail.gmail.com>
 <20160321191116.GB12309@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160321191116.GB12309@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, Bruce Fields <bfields@fieldses.org>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-api@vger.kernel.org, david@fromorbit.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Andrew Morton <akpm@linux-foundation.org>, device-mapper development <dm-devel@redhat.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 21 2016 at  3:11pm -0400,
Darrick J. Wong <darrick.wong@oracle.com> wrote:

> On Mon, Mar 21, 2016 at 02:52:00PM -0400, Mike Snitzer wrote:
> > On Tue, Mar 15, 2016 at 3:42 PM, Darrick J. Wong
> > <darrick.wong@oracle.com> wrote:
> > > After much discussion, it seems that the fallocate feature flag
> > > FALLOC_FL_ZERO_RANGE maps nicely to SCSI WRITE SAME; and the feature
> > > FALLOC_FL_PUNCH_HOLE maps nicely to the devices that have been
> > > whitelisted for zeroing SCSI UNMAP.  Punch still requires that
> > > FALLOC_FL_KEEP_SIZE is set.  A length that goes past the end of the
> > > device will be clamped to the device size if KEEP_SIZE is set; or will
> > > return -EINVAL if not.  Both start and length must be aligned to the
> > > device's logical block size.
> > >
> > > Since the semantics of fallocate are fairly well established already,
> > > wire up the two pieces.  The other fallocate variants (collapse range,
> > > insert range, and allocate blocks) are not supported.
> > 
> > I'd like to see fallocate (block allocation) extend down to DM thinp.
> > This more traditional use of fallocate would be useful for ensuring
> > ENOSPC won't occur -- especially important if the FS has committed
> > space in response to fallocate.  As of now fallocate doesn't inform DM
> > thinp at all.  Curious why you decided not to wire it up?
> 
> I don't know what to wire it up to. :)

Fair enough.  Yes something needs to be invented.
 
> I didn't find any blkdev_* function that looked encouraging, though I
> haven't dug too deeply into bfoster's "prototype a block reservation
> allocation model" patchset yet.  At a high level I'd guess that would
> be a reasonable piece to connect to?  It looks like the piece I want
> is blk_provision_space().

Yes, something like that.

> > But I'm not sure what "it" (the "allocate blocks" variant) even is
> > given falloc.h doesn't show anything like "_ALLOCATE_BLOCKS"...
> 
> The default behavior of fallocate is to allocate blocks, which means
> that one invokes it by not passing any mode flags (except possibly
> KEEP_SIZE).

OK.

> > It would require a new block interface to pass the fallocate extent
> > down.  But it seems bizarre to implement "some of" fallocate but not
> > the most widely used case for fallocate.
> 
> Agreed.  I'd like to get the existing functionality wired up sooner than
> later, and plumbing "allocate blocks" down to thinp can be done as a
> followup.
> 
> (Or stall long enough that it becomes one patchset.)

Sure, sounds good.  Glad we're in agreement.
