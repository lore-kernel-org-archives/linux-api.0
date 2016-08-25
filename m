From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] man2/fallocate.2: document behavior with shared blocks
Date: Thu, 25 Aug 2016 16:26:29 -0700
Message-ID: <147216758965.32321.5757278057091864768.stgit@birch.djwong.org>
References: <147216758326.32321.8525481353986871349.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <147216758326.32321.8525481353986871349.stgit-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add a blurb to the fallocate manpage explaining that the fallocate
command may use CoW to unshare blocks to guarantee that a disk write
won't fail with ENOSPC.

Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 man2/fallocate.2 |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/man2/fallocate.2 b/man2/fallocate.2
index 54d6340..e050536 100644
--- a/man2/fallocate.2
+++ b/man2/fallocate.2
@@ -83,6 +83,12 @@ is useful for optimizing append workloads.
 Because allocation is done in block size chunks,
 .BR fallocate ()
 may allocate a larger range of disk space than was specified.
+.PP
+Filesystems which allow files to share the same physical storage may
+employ copy on write to unshare the physical blocks to guarantee that
+subsequent writes will not fail due to lack of disk space.
+If the disk blocks are then re-shared, a subsequent write may still
+fail due to lack of space.
 .SS Deallocating file space
 Specifying the
 .BR FALLOC_FL_PUNCH_HOLE
