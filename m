From: y@redhat.com
Subject: [Patch v5 2/6] create compat_readv()
Date: Fri, 19 Dec 2008 16:58:21 +0100
Message-ID: <918.41274775124$1229702429@news.gmane.org>
References: <1229702305-23027-1-git-send-email-y>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1229702305-23027-1-git-send-email-y>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Factor out some code from compat_sys_readv() which can be shared with the
upcoming compat_sys_preadv().

Signed-off-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/compat.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index aab2234..361cb7d 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1167,16 +1167,11 @@ out:
 	return ret;
 }
 
-asmlinkage ssize_t
-compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
+static size_t compat_readv(struct file *file, const struct compat_iovec __user *vec,
+                           unsigned long vlen, loff_t *pos)
 {
-	struct file *file;
 	ssize_t ret = -EBADF;
 
-	file = fget(fd);
-	if (!file)
-		return -EBADF;
-
 	if (!(file->f_mode & FMODE_READ))
 		goto out;
 
@@ -1184,12 +1179,25 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec, unsign
 	if (!file->f_op || (!file->f_op->aio_read && !file->f_op->read))
 		goto out;
 
-	ret = compat_do_readv_writev(READ, file, vec, vlen, &file->f_pos);
+	ret = compat_do_readv_writev(READ, file, vec, vlen, pos);
 
 out:
 	if (ret > 0)
 		add_rchar(current, ret);
 	inc_syscr(current);
+	return ret;
+}
+
+asmlinkage ssize_t
+compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
+{
+	struct file *file;
+	ssize_t ret;
+
+	file = fget(fd);
+	if (!file)
+		return -EBADF;
+	ret = compat_readv(file, vec, vlen, &file->f_pos);
 	fput(file);
 	return ret;
 }
-- 
1.5.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
