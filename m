From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 0/3] fallocate for block devices to provide zero-out
Date: Fri, 04 Mar 2016 16:55:56 -0800
Message-ID: <20160305005556.29738.66782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shane.seymour-ZPxbGqLxI0U@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
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

Test cases[1] for the new block device fallocate will have been
submitted to the xfstests list as generic/70[5-7], though the
numbering will change to a lower number when the API and the tests are
accepted upstream.

Comments and questions are, as always, welcome.  Patches are against
4.5-rc6.

--D

[1] https://github.com/djwong/xfstests/commit/fdc0980ef01076dfb246fd1db2511227e9f67a3f
