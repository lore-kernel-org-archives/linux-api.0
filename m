From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [RFC DONOTMERGE v8 0/3] fallocate for block devices
Date: Tue, 12 Apr 2016 21:01:21 -0700
Message-ID: <20160413040121.10562.98998.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfoster-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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
fallocate interface between files and block devices.  It also allows
the combination of PUNCH_HOLE and NO_HIDE_STALE to invoke non-zeroing
discard.

The point of this patchset is not to go upstream, but is to be a
starting point for a discussion at LSF.  Don't merge this!  Foremost
in my mind is whether or not we require the offset/len parameters to
be aligned to logical block size or minimum_io_size; what error code
to return for unaligned values; and whether or not we should allow
byte ranges and zero blocks with the page cache (like file fallocate
does now).  It'll also be a jumping off point for Brian Foster and
Mike Snitzer's patches to allow bdev clients to ask that space be
allocated to a range, and to plumb that out to userspace.

Test cases for the new block device fallocate have been submitted to
the xfstests list as generic/70[5-7], though the latest versions of
those test cases will be attached to this patchset for convenience.

Comments and questions are, as always, welcome.  Patches are against
4.6-rc3.

v7: Strengthen parameter checking and fix various code issues pointed
out by Linus and Christoph.
v8: More code rearranging, rebase to 4.6-rc3, and dig into alignment
issues.

--D
