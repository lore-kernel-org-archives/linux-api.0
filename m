From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] fideduperange.2: fix the discussion of maximum sizes
Date: Tue, 22 Nov 2016 20:22:22 -0800
Message-ID: <20161123042222.GA30324@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: mtk.manpages@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fix the discussion of the limitations on the dest_count and src_length
parameters to the fideduperange ioctl to reflect what's actually in the
kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man2/ioctl_fideduperange.2 |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/man2/ioctl_fideduperange.2 b/man2/ioctl_fideduperange.2
index 2112d10..59f0ea9 100644
--- a/man2/ioctl_fideduperange.2
+++ b/man2/ioctl_fideduperange.2
@@ -95,7 +95,7 @@ struct file_dedupe_range_info {
 .in
 
 Each deduplication operation targets
-.IR length
+.IR src_length
 bytes in file descriptor
 .IR dest_fd
 at offset
@@ -108,8 +108,14 @@ During the call,
 must be open for reading and
 .IR dest_fd
 must be open for writing.
-For any call to this ioctl, there may not be more than 65,536
-requests attached; each request may not exceed 16MiB.
+The combined size of the struct
+.IR file_dedupe_range
+and the struct
+.IR file_dedupe_range_info
+array must not exceed the system page size.
+The maximum size of
+.IR src_length
+is filesystem dependent and is typically 16MiB.
 By convention, the storage used by
 .IR src_fd
 is mapped into
