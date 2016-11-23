From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] fideduperange.2: fix the discussion of maximum sizes
Date: Tue, 22 Nov 2016 20:48:16 -0800
Message-ID: <20161123044816.GG16807@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Fix the discussion of the limitations on the dest_count and src_length
parameters to the fideduperange ioctl to reflect what's actually in the
kernel.

Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 man2/ioctl_fideduperange.2 |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/man2/ioctl_fideduperange.2 b/man2/ioctl_fideduperange.2
index 2112d10..057229d 100644
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
@@ -108,8 +108,15 @@ During the call,
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
+This limit will be enforced silently by the filesystem.
 By convention, the storage used by
 .IR src_fd
 is mapped into
@@ -144,6 +151,13 @@ is set to indicate the error.
 .SH ERRORS
 Error codes can be one of, but are not limited to, the following:
 .TP
+.B ENOMEM
+The kernel was unable to allocate sufficient memory to perform the
+operation or
+.IR dest_count
+is so large that the input argument description spans more than a single
+page of memory.
+.TP
 .B EBADF
 .IR src_fd
 is not open for reading;
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
