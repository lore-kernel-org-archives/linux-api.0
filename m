From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v7 5/6] block: loop: introduce ioctl command of LOOP_SET_DIRECT_IO
Date: Thu, 16 Jul 2015 23:37:47 +0800
Message-ID: <1437061068-26118-6-git-send-email-ming.lei@canonical.com>
References: <1437061068-26118-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437061068-26118-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: "Justin M. Forbes" <jforbes@fedoraproject.org>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@canonical.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

If loop block is mounted via 'mount -o loop', it isn't easy
to pass file descriptor opened as O_DIRECT, so this patch
introduces a new command to support direct IO for this case.

Cc: linux-api@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/loop.c      | 19 +++++++++++++++++++
 include/uapi/linux/loop.h |  1 +
 2 files changed, 20 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 35aa3dd..3f26a0a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1214,6 +1214,20 @@ static int loop_set_capacity(struct loop_device *lo, struct block_device *bdev)
 	return figure_loop_size(lo, lo->lo_offset, lo->lo_sizelimit);
 }
 
+static int loop_set_dio(struct loop_device *lo, unsigned long arg)
+{
+	int error = -ENXIO;
+	if (lo->lo_state != Lo_bound)
+		goto out;
+
+	__loop_update_dio(lo, !!arg);
+	if (lo->use_dio == !!arg)
+		return 0;
+	error = -EINVAL;
+ out:
+	return error;
+}
+
 static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 	unsigned int cmd, unsigned long arg)
 {
@@ -1257,6 +1271,11 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
 			err = loop_set_capacity(lo, bdev);
 		break;
+	case LOOP_SET_DIRECT_IO:
+		err = -EPERM;
+		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
+			err = loop_set_dio(lo, arg);
+		break;
 	default:
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
 	}
diff --git a/include/uapi/linux/loop.h b/include/uapi/linux/loop.h
index 949851c..c8125ec 100644
--- a/include/uapi/linux/loop.h
+++ b/include/uapi/linux/loop.h
@@ -87,6 +87,7 @@ struct loop_info64 {
 #define LOOP_GET_STATUS64	0x4C05
 #define LOOP_CHANGE_FD		0x4C06
 #define LOOP_SET_CAPACITY	0x4C07
+#define LOOP_SET_DIRECT_IO	0x4C08
 
 /* /dev/loop-control interface */
 #define LOOP_CTL_ADD		0x4C80
-- 
1.9.1
