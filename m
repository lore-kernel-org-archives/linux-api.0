From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Fri, 13 Nov 2015 13:36:04 -0800
Message-ID: <20151113213604.GD2217@birch.djwong.org>
References: <20151110051526.GA2217@birch.djwong.org>
 <DDB9C85B850785449757F9914A034FCB444D1676@G9W0766.americas.hpqcorp.net>
 <20151111061435.GA32272@birch.djwong.org>
 <56460608.2070107@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56460608.2070107@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Seymour, Shane M" <shane.seymour@hpe.com>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 13, 2015 at 08:47:20AM -0700, Jens Axboe wrote:
> On 11/10/2015 11:14 PM, Darrick J. Wong wrote:
> >On Wed, Nov 11, 2015 at 05:30:07AM +0000, Seymour, Shane M wrote:
> >>A quick question about this part of the patch:
> >>
> >>>+	uint64_t end = start + len - 1;
> >>
> >>>+	if (end >= i_size_read(bdev->bd_inode))
> >>  		return -EINVAL;
> >>
> >>>+	/* Invalidate the page cache, including dirty pages */
> >>>+	mapping = bdev->bd_inode->i_mapping;
> >>>+	truncate_inode_pages_range(mapping, start, end);
> >>
> >>blk_ioctl_zeroout accepts unsigned values for start and end (uint64_t) but
> >>loff_t types are turned from i_size_read() and passed as the 2nd and 3rd
> >>values to truncate_inode_pages_range() and loff_t is a signed value. It
> >>should be possible to pass in some values would overflow the calculation of
> >>end causing the test on the value of end and the result of i_size_read to
> >>pass but then end up passing a large unsigned value for in start that would
> >>be implicitly converted to signed in truncate_inode_pages_range. I was
> >>wondering if you'd tested passing in data that would cause sign conversion
> >>issues when passed into truncate_inode_pages_range (does it handle it
> >>gracefully?) or should this code:
> >>
> >>	if (start & 511)
> >>  		return -EINVAL;
> >>  	if (len & 511)
> >>  		return -EINVAL;
> >>
> >>be something more like this (for better sanity checking of your arguments)
> >>which will ensure that you don't have implicit conversion issues from
> >>unsigned to signed and ensure that the result of adding them together won't
> >>either:
> >>
> >>	if ((start & 511) || (start > (uint64_t)LLONG_MAX))
> >>  		return -EINVAL;
> >>  	if ((len & 511) ) || (len > (uint64_t)LLONG_MAX))
> >>  		return -EINVAL;
> >>	if (end > (uint64_t)LLONG_MAX)
> >>		return -EINVAL;
> >>
> >>My apologies in advance if I've made a mistake when looking at this and my
> >>concerns about unsigned values being implicitly converted to signed are
> >>unfounded (I would have hoped for compiler warnings about any implicit
> >>conversions though).
> >
> >I don't have a device large enough to test for signedness errors, since passing
> >huge values for start and len never make it past the i_size_read check.
> >However, I do see that I forgot to check the padding values, so I'll update
> >that.
> 
> modprobe null_blk nr_devices=1 gb=512000

I tried doing that for some huge device sizes and this is what I saw:

# modprobe null_blk nr_devices=1 gb=17179869184
modprobe: ERROR: could not insert 'null_blk': Numerical result out of range
# modprobe null_blk nr_devices=1 gb=8589934591
modprobe: ERROR: could not insert 'null_blk': Numerical result out of range
# modprobe null_blk nr_devices=1 gb=8589934592
modprobe: ERROR: could not insert 'null_blk': Numerical result out of range
# modprobe null_blk nr_devices=1 gb=4294967295
modprobe: ERROR: could not insert 'null_blk': Numerical result out of range
# modprobe null_blk nr_devices=1 gb=4294967294
modprobe: ERROR: could not insert 'null_blk': Numerical result out of range
# modprobe null_blk nr_devices=1 gb=2147483647
# lsblk /dev/nullb0
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
nullb0 249:0    0   2E  0 disk 

Looks like the biggest nullblk device I can create is 2E?

(Same result with "modprobe scsi-debug virtual_gb=...")

> will get you a /dev/nullb0 that is 500TB. Adjust 'gb' at will. Or
> use loop with a big ass sparse file.

I tried that, too.  XFS only wanted to let me create an 8E file.  So
did btrfs.  Eventually, I figured out the following:

# echo '0 18446744073709551616 zero' | dmsetup create MOO-backing
# echo '0 18446744073709551616 snapshot /dev/mapper/MOO-backing /dev/sda N 512' | dmsetup create MOO
# lsblk /dev/mapper/MOO
NAME       MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
MOO (dm-1) 251:1    0  16E  0 dm   

Well, now we're getting somewhere.  It's a little funny that we asked
for 2^64 sectors, the dm table says 2^64, but the device claims a size
of 2^55... but it's 16E which exhausts our loff_t.  Let's try wrapping
around the end:

# /djwong/t/blkzero/test /dev/mapper/MOO 18446744073709543424 4096
OFFSET=-8192 BUFSZ=4096 USER_COHERENCE=0 DIRECTIO=0 EXCLUSIVE=0

# /djwong/t/blkzero/test /dev/mapper/MOO 18446744073709543424 8192
OFFSET=-8192 BUFSZ=8192 USER_COHERENCE=0 DIRECTIO=0 EXCLUSIVE=0
/dev/mapper/MOO: Invalid argument

# /djwong/t/blkzero/test /dev/mapper/MOO 18446744073709543424 12288
OFFSET=-8192 BUFSZ=12288 USER_COHERENCE=0 DIRECTIO=0 EXCLUSIVE=0

#

Hmm.  The third case should fail, since that clearly goes off the end
of the device.  However, it's not correct to compare start or end
against LLONG_MAX because the block layer clearly supports devices
that are larger than LLONG_MAX bytes.  However, the case where the
"end" calculation overflows should be easy to spot with a quick
"if (end < start) return -EINVAL;"

Curiously, if I create the DM device with 2^55 sectors, the dm
snapshot errors out:

# echo '0 36028797018963967 zero' | dmsetup create MOO-backing
# echo '0 36028797018963967 snapshot /dev/mapper/MOO-backing /dev/sda N 512' | dmsetup create MOO
# /djwong/t/blkzero/test /dev/mapper/MOO 18446744073709543424 4096
OFFSET=-8192 BUFSZ=4096 USER_COHERENCE=0 DIRECTIO=0 EXCLUSIVE=0
/dev/mapper/MOO: Input/output error

and dmesg spits out:

"device-mapper: snapshots: Invalidating snapshot: Error reading/writing."

FWIW, truncate_inode_pages_range takes the loff_t and converts that
into a pgoff_t, which is unsigned long.  If the start pgoff_t > the
end pgoff_t, the function does nothing.  On the off chance the
blkdev_issue_zeroout call doesn't fail when it's given weird
arguments, invalidate_inode_pages2_range seems to do roughly the same
thing with pgoff_t.  Will add the one check and resend.

--D
