From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/3] block: implement (some of) fallocate for
	block devices
Date: Mon, 21 Mar 2016 14:52:00 -0400
Message-ID: <CAMM=eLf1kj0btbxX=QqWzPm_M1MiGYqK9z6sCYqdbqMQ-b3R1Q@mail.gmail.com>
References: <20160315194221.30093.70506.stgit@birch.djwong.org>
	<20160315194244.30093.6483.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160315194244.30093.6483.stgit@birch.djwong.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-api@vger.kernel.org, david@fromorbit.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 3:42 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> After much discussion, it seems that the fallocate feature flag
> FALLOC_FL_ZERO_RANGE maps nicely to SCSI WRITE SAME; and the feature
> FALLOC_FL_PUNCH_HOLE maps nicely to the devices that have been
> whitelisted for zeroing SCSI UNMAP.  Punch still requires that
> FALLOC_FL_KEEP_SIZE is set.  A length that goes past the end of the
> device will be clamped to the device size if KEEP_SIZE is set; or will
> return -EINVAL if not.  Both start and length must be aligned to the
> device's logical block size.
>
> Since the semantics of fallocate are fairly well established already,
> wire up the two pieces.  The other fallocate variants (collapse range,
> insert range, and allocate blocks) are not supported.

I'd like to see fallocate (block allocation) extend down to DM thinp.
This more traditional use of fallocate would be useful for ensuring
ENOSPC won't occur -- especially important if the FS has committed
space in response to fallocate.  As of now fallocate doesn't inform DM
thinp at all.  Curious why you decided not to wire it up?

But I'm not sure what "it" (the "allocate blocks" variant) even is
given falloc.h doesn't show anything like "_ALLOCATE_BLOCKS"...

It would require a new block interface to pass the fallocate extent
down.  But it seems bizarre to implement "some of" fallocate but not
the most widely used case for fallocate.

Mike
