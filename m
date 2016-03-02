From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Wed, 2 Mar 2016 14:56:01 -0800
Message-ID: <20160302225601.GB21890@birch.djwong.org>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
 <20160302040947.16685.42926.stgit@birch.djwong.org>
 <CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 02, 2016 at 10:52:01AM -0800, Linus Torvalds wrote:
> On Tue, Mar 1, 2016 at 8:09 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > Create a new ioctl to expose the block layer's newfound ability to
> > issue either a zeroing discard, a WRITE SAME with a zero page, or a
> > regular write with the zero page.  This BLKZEROOUT2 ioctl takes
> > {start, length, flags} as parameters.  So far, the only flag available
> > is to enable the zeroing discard part -- without it, the call invokes
> > the old BLKZEROOUT behavior.  start and length have the same meaning
> > as in BLKZEROOUT.
> 
> NAK, just based on annoyance with the randomness of this interface:
> 
>  - without describing what the point of the new flag and lots of extra

The new flag means "if the device supports discard and that discard zeroes data
then it's ok to use discard".  The difference between discard/unmap and
write-same is in thin-provisioned storage arrays -- UNMAP can release backing
store, whereas WRITE SAME ensures that something's been written to media.

So by default, BLKZEROOUT2 means "ensure subsequent reads return zeroes and
make sure there's real space waiting for the next time I write to this".
Passing in the flag changes that to "ensure subsequent reads return zeroes and
I don't care what happens to the backing store".

I'll grant that this distinction could be clarified in the header file,
though anyone familiar with WS/UNMAP to want to use them from userspace
ought to know that already.

> expansion room is, this should never be merged. We don't add padding
> just randomly.

Oh yes we do.  Adding required-zero padding to allow for future increases of
the expressiveness of an ioctl is very common. 

$ egrep -rn '(reserved|padding).*;' include/uapi/ | wc -l
564

The size of the ioctl structure is embedded in the ioctl number definition,
so we might as well reserve a lot of space ahead of time.  Better that than
having to declare new ioctl numbers every time someone needs to add something.
Both ext4 and XFS perform this sort of future proofing.

>  - Somewhat related to that: the flags are checked for zero, but the
> random expansion room isn't. So not only are the random expansion
> fields not explained, they will contain random garbage in the future.

Wrong.  The padding fields /are/ checked, and the ioctl returns EINVAL
if they aren't zero:

static int blk_ioctl_zeroout2(struct block_device *bdev, fmode_t mode,
               unsigned long arg)
{
...
       if (p.padding || p.padding2)
               return -EINVAL;
...
}

>  - why is that "FMODE_WRITE" check not in the common code, but duplicated?

The old BLKZEROOUT checked FMODE_WRITE before copying the ioctl data from
userspace, so the new BLKZEROOUT will behave the same way when possible to
minimize porting hassle for userland.

> it all seems very ad-hoc. It makes a big deal about that idiotic
> "discard" behavior, which is entirely pointless.

No.  This is not about enabling use of "that idiotic discard behavior", for
that there's BLKDISCARD.  This ioctl does NOT use the handwavy old TRIM
advisory request thing that could return "fuzzy wuzzy" without violating the
specs.

BLKZEROOUT is about telling a device "after this call I want subsequent reads
to return zeroes".  The first patch fixes the problem that the pagecache isn't
invalidated when we tell the device that we want to be able to read zeroes.
Even if it behaves according to spec (and even if it doesn't) without that
patch, userland programs can end up reading stale data out of the kernel.  That
first patch is purely a bug fix.

However, even once the cache coherence problem is fixed, there's still the
problem that the old BLKZEROOUT didn't maintain page cache coherence and
userspace has no way to figure out whether BLKZEROOUT on a given system
actually will.  The reason for creating a new ioctl is to establish an ioctl
that guarantees a page cache flush or returns an error code.  While we're
defining a new number, we might as well allow for userspace to control the
discard parameter to blkdev_issue_zeroout(), and reserve more space in the
structure than we think we need.

> Who cares about that discard behavior anyway? Why is it set to "false"
> in the current version of BLKZEROOUT in the first place? Why do we do
> that WRITE_SAME without questioning it, but "discard" is somehow so
> special that it has a flag, and it's turned off by default?

Some users want to use the SCSI command (WRITE SAME) that won't return
GOOD status until blocks full of zeroes have been committed to stable storage
that can be rewritten, and other users are fine with a zeroing TRIM/UNMAP which
can release the storage and DMA back pages of zeroes without committing
any stable storage to future rewrites.

> If this is some "security issue" where somebody believes that discard
> is not secure, then those people are full of shit. Discard and
> write-same have exactly the same semantics - they may just unmap the
> target range with the guarantee that you'll get zeroes on read.

No.  The point is that mkfs can zero out filesystem metadata blocks with
confidence that a subsequent re-read will always return zeroes.  We tried
making mke2fs use BLKZEROOUT and the cache coherence problem bit us in the
arse.

If you care about securely deleting data, throw it into the sun.

> So quite frankly, right now it seems that
> 
>  (a) the *only* excuse for this patch is that people want to use "discard"
>
>  (b) the reason we already don't use "discard" for the old BLKZEROOUT
> is very questionable

See above.

>  (c) any future possible use of flags is not described and is questionable

How?  If any of the other flag bits are set, it'll return -EINVAL.  Or do you
mean that you think there will never be a need for any other flags?  Or are
you complaining that you think there's too much padding and stuff in the
structure?

> You'll find people who think that "write-same with some non-zero
> pattern" would be a real over-write and good for security. Those
> people will then argue that a sane extension would be to make that
> pattern part of the future expansion of BLKZEROOUT2. And those people
> are full of shit. Write-same with a non-zero pattern may well be just
> a discard with the pattern set in another table.
> 
> So the whole patch looks pointless.

I disagree, obviously.

> Why isn't the patch just "change false to true in blk_ioctl_zeroout()
> when it calls blkdev_issue_zeroout()".

Some people might want real storage blocks full of zeroes backing the LBAs they
just wrote out, others might not care.

--D

> 
> No new interface, no new random padding, just a simple "it makes
> absolutely no sense to not allow discard".
> 
>                     Linus
