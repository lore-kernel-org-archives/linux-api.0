From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v7 0/3] fallocate for block devices to provide zero-out
Date: Tue, 15 Mar 2016 12:42:21 -0700
Message-ID: <20160315194221.30093.70506.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, torvalds@linux-foundation.org, darrick.wong@oracle.com
Cc: bfields@fieldses.org, tytso@mit.edu, martin.petersen@oracle.com, linux-api@vger.kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, jlayton@poochiereds.net, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org

Hi,

This is a redesign of the patch series that fixes various interface
problems with the existing "zero out this part of a block device"
code.  BLKZEROOUT2 is gone.

The first patch is still a fix to the existing BLKZEROOUT ioctl to
invalidate the page cache if the zeroing command to the underlying
device succeeds.

The second patch changes the internal block device functions to reject
attempts to discard or zeroout that are not aligned to the logical
block size.  Previously, we only checked that the start/len parameters
were 512-byte aligned, which caused kernel BUG_ONs for unaligned IOs
to 4k-LBA devices.

The third patch creates an fallocate handler for block devices, wires
up the FALLOC_FL_PUNCH_HOLE flag to zeroing-discard, and connects
FALLOC_FL_ZERO_RANGE to write-same so that we can have a consistent
fallocate interface between files and block devices.

Test cases for the new block device fallocate have been submitted to
the xfstests list as generic/70[5-7], though the numbering will change
to a lower number when the API and the tests are accepted upstream.
Look for the v2 testcase patch, which reflects v7 of this patchset.

Comments and questions are, as always, welcome.  Patches are against
4.5.

v7: Strengthen parameter checking and fix various code issues pointed
out by Linus and Christoph.

--D
