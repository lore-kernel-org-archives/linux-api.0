From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v10 0/3] fallocate for block devices
Date: Wed, 28 Sep 2016 17:39:30 -0700
Message-ID: <147510957066.8940.13803086684642725401.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, akpm@linux-foundation.org, darrick.wong@oracle.com
Cc: linux-block@vger.kernel.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, hch@infradead.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, bart.vanassche@sandisk.com
List-Id: linux-api@vger.kernel.org

Hi Andrew & others,

This is a resend of the patchset to fix page cache coherency with
BLKZEROOUT and implement fallocate for block devices.  This time I'm
sending it direct to Andrew for inclusion because the block layer
maintainer has not been responsive over the past year of submissions.
Can this please go upstream for 4.9?

The first patch is still a fix to the existing BLKZEROOUT ioctl to
invalidate the page cache if the zeroing command to the underlying
device succeeds.  Without this patch we still have the pagecache
coherence bug that's been in the kernel forever.

The second patch changes the internal block device functions to reject
attempts to discard or zeroout that are not aligned to the logical
block size.  Previously, we only checked that the start/len parameters
were 512-byte aligned, which caused kernel BUG_ONs for unaligned IOs
to 4k-LBA devices.

The third patch creates an fallocate handler for block devices, wires
up the FALLOC_FL_PUNCH_HOLE flag to zeroing-discard, and connects
FALLOC_FL_ZERO_RANGE to write-same so that we can have a consistent
fallocate interface between files and block devices.  It also allows
the combination of PUNCH_HOLE and NO_HIDE_STALE to invoke non-zeroing
discard.

Test cases for the new block device fallocate are now in xfstests as
generic/349-351.

Comments and questions are, as always, welcome.  Patches are against
4.8-rc8.

v7: Strengthen parameter checking and fix various code issues pointed
out by Linus and Christoph.
v8: More code rearranging, rebase to 4.6-rc3, and dig into alignment
issues.
v9: Forward port to 4.7.
v10: Forward port to 4.8.  Remove the extra call to
invalidate_inode_pages2_range per Bart Van Assche's request.

--D
