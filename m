From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/10] fs: add RWF_DSYNC aand RWF_SYNC
Date: Tue, 29 Mar 2016 19:37:33 +0200
Message-ID: <1459273054-13478-10-git-send-email-hch@lst.de>
References: <1459273054-13478-1-git-send-email-hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1459273054-13478-1-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is the per-I/O equivalent of O_DSYNC and O_SYNC, and very useful for
all kinds of file servers and storage targets.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/read_write.c         | 6 +++++-
 include/uapi/linux/fs.h | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index cf377cf..3729d8d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -698,12 +698,16 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
 	struct kiocb kiocb;
 	ssize_t ret;
 
-	if (flags & ~RWF_HIPRI)
+	if (flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC))
 		return -EOPNOTSUPP;
 
 	init_sync_kiocb(&kiocb, filp);
 	if (flags & RWF_HIPRI)
 		kiocb.ki_flags |= IOCB_HIPRI;
+	if (flags & RWF_DSYNC)
+		kiocb.ki_flags |= IOCB_DSYNC;
+	if (flags & RWF_SYNC)
+		kiocb.ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
 	kiocb.ki_pos = *ppos;
 
 	ret = fn(&kiocb, iter);
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index a079d50..7f067fe 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -324,5 +324,7 @@ struct fscrypt_policy {
 
 /* flags for preadv2/pwritev2: */
 #define RWF_HIPRI			0x00000001 /* high priority request, poll if possible */
+#define RWF_DSYNC			0x00000002 /* per-IO O_DSYNC */
+#define RWF_SYNC			0x00000002 /* per-IO O_SYNC */
 
 #endif /* _UAPI_LINUX_FS_H */
-- 
2.1.4

