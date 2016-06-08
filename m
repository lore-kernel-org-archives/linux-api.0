From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] ioctl_ficlonerange.2/ioctl_fideduperange.2: mention same-fs
 requirement
Date: Wed, 8 Jun 2016 09:40:40 -0700
Message-ID: <20160608164040.GB5740@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Mention that FICLONE, FICLONERANGE, and FIDEDUPERANGE all require both
files to reside on the same filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 man2/ioctl_ficlonerange.2  |    1 +
 man2/ioctl_fideduperange.2 |    1 +
 2 files changed, 2 insertions(+)

diff --git a/man2/ioctl_ficlonerange.2 b/man2/ioctl_ficlonerange.2
index 0cb1567..c6e0762 100644
--- a/man2/ioctl_ficlonerange.2
+++ b/man2/ioctl_ficlonerange.2
@@ -36,6 +36,7 @@ file appear in the
 .I dest_fd
 file by sharing the underlying storage, which is faster than making a separate
 physical copy of the data.
+Both files must reside within the same filesystem.
 If a file write should occur to a shared region,
 the filesystem must ensure that the changes remain private to the file being
 written.
diff --git a/man2/ioctl_fideduperange.2 b/man2/ioctl_fideduperange.2
index c69f8c5..44a7765 100644
--- a/man2/ioctl_fideduperange.2
+++ b/man2/ioctl_fideduperange.2
@@ -34,6 +34,7 @@ file appear in the
 .B dest_fd
 file by sharing the underlying storage if the file data is identical
 ("deduplication").
+Both files must reside within the same filesystem.
 This reduces storage consumption by allowing the filesystem
 to store one shared copy of the data.
 If a file write should occur to a shared
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
