From: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] nbd: add support for feature negotiation
Date: Wed,  7 Sep 2011 16:41:42 +0200
Message-ID: <1315406503-7883-3-git-send-email-pbonzini@redhat.com>
References: <1315406503-7883-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315406503-7883-1-git-send-email-pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Clements <Paul.Clements-G8/ITkJZaeZWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add a IOCTL to negotiate features between the server and the
kernel module (mediated by the usermode client).  Features are
stored in the pre-existing flags field.

Also zero out the flags when NBD_DO_IT completes.

Cc: Paul Clements <Paul.Clements-G8/ITkJZaeZWk0Htik3J/w@public.gmane.org>
Signed-off-by: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/block/nbd.c |    8 ++++++++
 include/linux/nbd.h |   24 +++++++++++++++---------
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index be23aec..c4fe9c8 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -85,6 +85,7 @@ static const char *ioctl_cmd_to_ascii(int cmd)
 	case NBD_PRINT_DEBUG: return "print-debug";
 	case NBD_SET_SIZE_BLOCKS: return "set-size-blocks";
 	case NBD_DISCONNECT: return "disconnect";
+	case NBD_SET_FEATURES: return "set-features";
 	case BLKROSET: return "set-read-only";
 	case BLKFLSBUF: return "flush-buffer-cache";
 	}
@@ -634,6 +635,12 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
 		lo->xmit_timeout = arg * HZ;
 		return 0;
 
+	case NBD_SET_FEATURES:
+		if (((u64) arg) & NBD_FEATURE_RESERVED)
+			return -EINVAL;
+		lo->flags = (lo->flags & NBD_FEATURE_RESERVED) | (u64)arg;
+		return 0;
+
 	case NBD_SET_SIZE_BLOCKS:
 		lo->bytesize = ((u64) arg) * lo->blksize;
 		bdev->bd_inode->i_size = lo->bytesize;
@@ -672,6 +679,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
 		printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
 		if (file)
 			fput(file);
+		lo->flags = 0;
 		lo->bytesize = 0;
 		bdev->bd_inode->i_size = 0;
 		set_capacity(lo->disk, 0);
diff --git a/include/linux/nbd.h b/include/linux/nbd.h
index 0582054..926f19d 100644
--- a/include/linux/nbd.h
+++ b/include/linux/nbd.h
@@ -17,16 +17,22 @@
 
 #include <linux/types.h>
 
-#define NBD_SET_SOCK	_IO( 0xab, 0 )
-#define NBD_SET_BLKSIZE	_IO( 0xab, 1 )
-#define NBD_SET_SIZE	_IO( 0xab, 2 )
-#define NBD_DO_IT	_IO( 0xab, 3 )
-#define NBD_CLEAR_SOCK	_IO( 0xab, 4 )
-#define NBD_CLEAR_QUE	_IO( 0xab, 5 )
-#define NBD_PRINT_DEBUG	_IO( 0xab, 6 )
-#define NBD_SET_SIZE_BLOCKS	_IO( 0xab, 7 )
-#define NBD_DISCONNECT  _IO( 0xab, 8 )
-#define NBD_SET_TIMEOUT _IO( 0xab, 9 )
+#define NBD_SET_SOCK		_IO(0xab, 0)
+#define NBD_SET_BLKSIZE		_IO(0xab, 1)
+#define NBD_SET_SIZE		_IO(0xab, 2)
+#define NBD_DO_IT		_IO(0xab, 3)
+#define NBD_CLEAR_SOCK		_IO(0xab, 4)
+#define NBD_CLEAR_QUE		_IO(0xab, 5)
+#define NBD_PRINT_DEBUG		_IO(0xab, 6)
+#define NBD_SET_SIZE_BLOCKS	_IO(0xab, 7)
+#define NBD_DISCONNECT		_IO(0xab, 8)
+#define NBD_SET_TIMEOUT		_IO(0xab, 9)
+#define NBD_SET_FEATURES	_IO(0xab, 10)
+
+/* bits 0 and 1 are already used for flags in the protocol, we do
+ * not want any overlap.  Bits 32-63 are reserved because they
+ * are inaccessible on 32-bit platforms.  */
+#define NBD_FEATURE_RESERVED	0xFFFFFFFF00000003LL
 
 enum {
 	NBD_CMD_READ = 0,
-- 
1.7.6
