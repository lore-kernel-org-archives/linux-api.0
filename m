From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] block: implement (some of) fallocate for
 block devices
Date: Mon, 21 Mar 2016 12:11:16 -0700
Message-ID: <20160321191116.GB12309@birch.djwong.org>
References: <20160315194221.30093.70506.stgit@birch.djwong.org>
	<20160315194244.30093.6483.stgit@birch.djwong.org>
	<CAMM=eLf1kj0btbxX=QqWzPm_M1MiGYqK9z6sCYqdbqMQ-b3R1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAMM=eLf1kj0btbxX=QqWzPm_M1MiGYqK9z6sCYqdbqMQ-b3R1Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-api@vger.kernel.org, david@fromorbit.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 21, 2016 at 02:52:00PM -0400, Mike Snitzer wrote:
> On Tue, Mar 15, 2016 at 3:42 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > After much discussion, it seems that the fallocate feature flag
> > FALLOC_FL_ZERO_RANGE maps nicely to SCSI WRITE SAME; and the feature
> > FALLOC_FL_PUNCH_HOLE maps nicely to the devices that have been
> > whitelisted for zeroing SCSI UNMAP.  Punch still requires that
> > FALLOC_FL_KEEP_SIZE is set.  A length that goes past the end of the
> > device will be clamped to the device size if KEEP_SIZE is set; or will
> > return -EINVAL if not.  Both start and length must be aligned to the
> > device's logical block size.
> >
> > Since the semantics of fallocate are fairly well established already,
> > wire up the two pieces.  The other fallocate variants (collapse range,
> > insert range, and allocate blocks) are not supported.
> 
> I'd like to see fallocate (block allocation) extend down to DM thinp.
> This more traditional use of fallocate would be useful for ensuring
> ENOSPC won't occur -- especially important if the FS has committed
> space in response to fallocate.  As of now fallocate doesn't inform DM
> thinp at all.  Curious why you decided not to wire it up?

I don't know what to wire it up to. :)

I didn't find any blkdev_* function that looked encouraging, though I
haven't dug too deeply into bfoster's "prototype a block reservation
allocation model" patchset yet.  At a high level I'd guess that would
be a reasonable piece to connect to?  It looks like the piece I want
is blk_provision_space().

> But I'm not sure what "it" (the "allocate blocks" variant) even is
> given falloc.h doesn't show anything like "_ALLOCATE_BLOCKS"...

The default behavior of fallocate is to allocate blocks, which means
that one invokes it by not passing any mode flags (except possibly
KEEP_SIZE).

> It would require a new block interface to pass the fallocate extent
> down.  But it seems bizarre to implement "some of" fallocate but not
> the most widely used case for fallocate.

Agreed.  I'd like to get the existing functionality wired up sooner than
later, and plumbing "allocate blocks" down to thinp can be done as a
followup.

(Or stall long enough that it becomes one patchset.)

--D

> 
> Mike
