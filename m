From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/2] man2/fallocate.2: document behavior with shared blocks
Date: Mon, 17 Oct 2016 18:54:27 -0700
Message-ID: <147675566778.12400.16090171199161180354.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: mtk.manpages@gmail.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a blurb to the fallocate manpage explaining that the fallocate
command with the UNSHARE mode flag may use CoW to unshare blocks to
guarantee that a disk write won't fail with ENOSPC.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man2/fallocate.2 |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/man2/fallocate.2 b/man2/fallocate.2
index 54d6340..3ed1460 100644
--- a/man2/fallocate.2
+++ b/man2/fallocate.2
@@ -79,6 +79,16 @@ but the file size will not be changed even if
 is greater than the file size.
 Preallocating zeroed blocks beyond the end of the file in this manner
 is useful for optimizing append workloads.
+
+If the
+.B FALLOC_FL_UNSHARE
+flag is specified in
+.IR mode ,
+shared file data extents will be made private to the file to guarantee
+that a subsequent write will not fail due to lack of space.
+Typically, this will be done by performing a copy-on-write operation on
+all shared data in the file.
+This flag may not be supported by all filesystems.
 .PP
 Because allocation is done in block size chunks,
 .BR fallocate ()

