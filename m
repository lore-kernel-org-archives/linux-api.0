From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Fri, 4 Mar 2016 09:56:46 +1100
Message-ID: <20160303225646.GT29057@dastard>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
 <20160302040947.16685.42926.stgit@birch.djwong.org>
 <CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
 <20160302225601.GB21890@birch.djwong.org>
 <CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
 <yq1bn6v8mqg.fsf@sermon.lab.mkp.net>
 <20160303180924.GA4116@infradead.org>
 <yq1vb5375oh.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1vb5375oh.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 03, 2016 at 01:54:54PM -0500, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
> 
> Christoph>  - FALLOC_FL_PUNCH_HOLE assures zeroes are returned, but
> Christoph> space is deallocated as much as possible -
> Christoph> FALLOC_FL_ZERO_RANGE assures zeroes are returned, AND blocks
> Christoph> are actually allocated
> 
> That works for me. I think it would be great if we could have consistent
> interfaces for fs and block. The more commonality the merrier.

Absolutely in agreement here. it would be much nicer if filesystems
could just call bdev->ops->fallocate(PUNCH_HOLE, off, len) and
bdev->ops->fallocate(ZERO_RANGE, off, len) than all the weird
"technology specific" blkdev_issue_foo() functions we have grown
over time. Let the block device implement them as it sees fit - the
higher levels don't need to care about protocol/technology details.

---

FWIW, this reminds me of a "bigger picture" I think we should
be working towards. Does anyone remember this:

https://lwn.net/Articles/592091/

(Splitting filesytems in two)

i.e. if we add fallocate support to punch holes, zero ranges and
*allocate blocks* to a block device, we're mostly at the point where
we can offload all freespace management that the filesystem
currently does to the underlying block device.

There's really only a small extension we'd need - the block
allocation done by the block device needs to be able to return the
the sector and length of the newly allocated extent. Indeed, this is
something we talked about last year at LSFMM as a solution to the
SMR write ordering problem:

https://lwn.net/Articles/637035/

(near the end, paragraph talking about a "new kind of write command")

That "new kind of write command" would enable delayed allocation
algorithms to continue to work at the filesystem level on block
devices that freespace management completely is offloaded to...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
