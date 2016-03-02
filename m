From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of blocks
Date: Wed, 2 Mar 2016 15:49:53 -0800
Message-ID: <CA+55aFyNPnjJ-Nsu3bMr+HuLQnkj1B8FMddNnXW7HJqxdUzJmQ@mail.gmail.com>
References: <20160302040932.16685.62789.stgit@birch.djwong.org>
	<20160302040947.16685.42926.stgit@birch.djwong.org>
	<CA+55aFx_NPn0VYk=+Ad5S_r=D6J1xFmWmf7JzQ7RmkwKmdkYOg@mail.gmail.com>
	<20160302225601.GB21890@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160302225601.GB21890@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 2, 2016 at 2:56 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> Oh yes we do.  Adding required-zero padding to allow for future increases of
> the expressiveness of an ioctl is very common.
>
> $ egrep -rn '(reserved|padding).*;' include/uapi/ | wc -l
> 564

Most of those should be for alignment reasons. In particular, you'll
find them to make sure subsequent u64's are properly aligned, or at
the end to make sure we have names for the padding at the end when the
last member is differently sized than the alignment of the structure.

> Wrong.  The padding fields /are/ checked, and the ioctl returns EINVAL
> if they aren't zero:

Ok, I obviously overlooked that. Good.

>>  - why is that "FMODE_WRITE" check not in the common code, but duplicated?
>
> The old BLKZEROOUT checked FMODE_WRITE before copying the ioctl data from
> userspace, so the new BLKZEROOUT will behave the same way when possible to
> minimize porting hassle for userland.

That's a valid reason in theory, but I don't think anybody actually
cares. An error is an error. If you pass in invalid pointers _and_ a
read-only file descriptor, nobody will actually look at whether you
got EBADF or EFAULT.

> No.  This is not about enabling use of "that idiotic discard behavior", for
> that there's BLKDISCARD.  This ioctl does NOT use the handwavy old TRIM
> advisory request thing that could return "fuzzy wuzzy" without violating the
> specs.

So you agree that we could just make BLKZEROOUT always use trim?

> BLKZEROOUT is about telling a device "after this call I want subsequent reads
> to return zeroes".  The first patch fixes the problem that the pagecache isn't
> invalidated when we tell the device that we want to be able to read zeroes.
> Even if it behaves according to spec (and even if it doesn't) without that
> patch, userland programs can end up reading stale data out of the kernel.  That
> first patch is purely a bug fix.

Oh, I'm not at all arguing against the first patch.

It's the second one I think falls under the heading of "seems
over-engineered and unnecessary".

> However, even once the cache coherence problem is fixed, there's still the
> problem that the old BLKZEROOUT didn't maintain page cache coherence and
> userspace has no way to figure out whether BLKZEROOUT on a given system
> actually will.  The reason for creating a new ioctl is to establish an ioctl
> that guarantees a page cache flush or returns an error code.  While we're
> defining a new number, we might as well allow for userspace to control the
> discard parameter to blkdev_issue_zeroout(), and reserve more space in the
> structure than we think we need.

So quite frankly, this brings up three issues:

 - why was this not explained in the commit message

 - why would anybody *want* to control that parameter?

 - what other parameters _could_ there be?

> Some users want to use the SCSI command (WRITE SAME) that won't return
> GOOD status until blocks full of zeroes have been committed to stable storage
> that can be rewritten, and other users are fine with a zeroing TRIM/UNMAP which
> can release the storage and DMA back pages of zeroes without committing
> any stable storage to future rewrites.

Ehh. I'm not convinced that any disk that completes a TRIM command
without it beign "stable" would do the same for WRITE_SAME.

>From everything I've ever seen, the difference between "stable on
disk" and "not stable" has almost never been about the particular
command used, and always been about the choice of the particular
target disk.

> No.  The point is that mkfs can zero out filesystem metadata blocks with
> confidence that a subsequent re-read will always return zeroes.  We tried
> making mke2fs use BLKZEROOUT and the cache coherence problem bit us in the
> arse.

Again, I don't disagree about the cache coherence at all.

> How?  If any of the other flag bits are set, it'll return -EINVAL.  Or do you
> mean that you think there will never be a need for any other flags?  Or are
> you complaining that you think there's too much padding and stuff in the
> structure?

I absolutely *detest* code that tries to be overly forward-thinking by
randomly adding fields without even having an idea of what those
fields could possibly be used for.

I'm perfectly ok with padding that has a *reason*. Not a "we might use
it for something in the future".

> Some people might want real storage blocks full of zeroes backing the LBAs they
> just wrote out, others might not care.

.. but the flag doesn't even set that. Even if you avoid TRIM, there
is absolutely zero guarantees that WRITE_SAME would do "real storage
blocks full of zeroes backing the LBAs they just wrote out".

In fact, even if you do a real write of zeroed buffers, there's no
such guarantee. Doing some compression in the disk controller isn't
exactly unusual, even in enterprise hw (ie de-dup etc).

So I think this boils down to:

 - I can see the "guaranteed cache flush". Get an error on old kernels
that might be without the flush.

   At the same time, that sounds sad. The "add cache flush" sounds
like something that should be backported to stable, but new ioctl's?
Very questionable.

   So now people who care would be forced to effectively do big zero
writes because they can't trust old kernels even if they are correct.

 - it would seem that what you really want is a *generic* "invalidate
this page cache range" thing, because you have other users like the
whole "assemble SCSI command by hand" usage cases.

   For example, maybe sync_file_range() should just be extended to
have a SYNC_FILE_RANGE_INVALIDATE flag? That sounds like a *much* more
generic thing that could be useful for other things than just the zero
write?

 - I'd be much more ok with flags and extensions if they had
explanations and future cases.

IOW, this thing seems both too specific ("I need guarantees about
cache flushing, but only for this zerowrite thing") and too
"future-proofing" (I don't know what I might want in the future, but
zerowrite is such a generic operation that it migth want to have tons
of other arguments too").

It just rubs me the wrong way.

              Linus
