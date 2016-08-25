From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] man2/ioctl_fideduperange.2: clarify operation some more
Date: Thu, 25 Aug 2016 16:26:35 -0700
Message-ID: <147216759592.32321.6779960916548032481.stgit@birch.djwong.org>
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

Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 man2/ioctl_ficlonerange.2  |    2 +-
 man2/ioctl_fideduperange.2 |   26 ++++++++++++++++++++++----
 2 files changed, 23 insertions(+), 5 deletions(-)


diff --git a/man2/ioctl_ficlonerange.2 b/man2/ioctl_ficlonerange.2
index ac0738a..0e3ae0e 100644
--- a/man2/ioctl_ficlonerange.2
+++ b/man2/ioctl_ficlonerange.2
@@ -114,7 +114,7 @@ regions in directories.
 .TP
 .B EOPNOTSUPP
 This can appear if the filesystem does not support reflinking either file
-descriptor.
+descriptor, or if either file descriptor refers to special inodes.
 .TP
 .B EPERM
 .IR dest_fd
diff --git a/man2/ioctl_fideduperange.2 b/man2/ioctl_fideduperange.2
index c52fa2a..2112d10 100644
--- a/man2/ioctl_fideduperange.2
+++ b/man2/ioctl_fideduperange.2
@@ -99,21 +99,39 @@ Each deduplication operation targets
 bytes in file descriptor
 .IR dest_fd
 at offset
-.IR logical_offset ".
+.IR dest_offset ".
 The field
 .IR reserved
 must be zero.
+During the call,
+.IR src_fd
+must be open for reading and
+.IR dest_fd
+must be open for writing.
+For any call to this ioctl, there may not be more than 65,536
+requests attached; each request may not exceed 16MiB.
+By convention, the storage used by
+.IR src_fd
+is mapped into
+.IR dest_fd
+and the previous contents in
+.IR dest_fd
+are freed.
 
 Upon successful completion of this ioctl, the number of bytes successfully
 deduplicated is returned in
 .IR bytes_deduped
 and a status code for the deduplication operation is returned in
 .IR status ".
-
+If even a single byte in the range does not match, the deduplication
+request will be ignored and
+.IR status
+set to
+.BR FILE_DEDUPE_RANGE_DIFFERS .
 The
 .IR status
 code is set to
-.B 0
+.B FILE_DEDUPE_RANGE_SAME
 for success, a negative error code in case of error, or
 .B FILE_DEDUPE_RANGE_DIFFERS
 if the data did not match.
@@ -150,7 +168,7 @@ regions in directories.
 .TP
 .B EOPNOTSUPP
 This can appear if the filesystem does not support deduplicating either file
-descriptor.
+descriptor, or if either file descriptor refers to special inodes.
 .TP
 .B EPERM
 .IR dest_fd
