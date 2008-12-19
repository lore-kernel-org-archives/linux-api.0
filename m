From: y@redhat.com
Subject: [Patch v5 6/6] switch compat readv/preadv/writev/pwritev from fget to fget_light
Date: Fri, 19 Dec 2008 16:58:25 +0100
Message-ID: <5443.39396660707$1229702450@news.gmane.org>
References: <1229702305-23027-1-git-send-email-y>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1229702305-23027-1-git-send-email-y>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


Signed-off-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/compat.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 4e1fa33..8d48705 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1192,13 +1192,14 @@ asmlinkage ssize_t
 compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
 {
 	struct file *file;
+	int fput_needed;
 	ssize_t ret;
 
-	file = fget(fd);
+	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
 	ret = compat_readv(file, vec, vlen, &file->f_pos);
-	fput(file);
+	fput_light(file, fput_needed);
 	return ret;
 }
 
@@ -1208,15 +1209,16 @@ compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	struct file *file;
+	int fput_needed;
 	ssize_t ret;
 
 	if (pos < 0)
 		return -EINVAL;
-	file = fget(fd);
+	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
 	ret = compat_readv(file, vec, vlen, &pos);
-	fput(file);
+	fput_light(file, fput_needed);
 	return ret;
 }
 
@@ -1245,13 +1247,14 @@ asmlinkage ssize_t
 compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
 {
 	struct file *file;
+	int fput_needed;
 	ssize_t ret;
 
-	file = fget(fd);
+	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
 	ret = compat_writev(file, vec, vlen, &file->f_pos);
-        fput(file);
+        fput_light(file, fput_needed);
         return ret;
 }
 
@@ -1261,15 +1264,16 @@ compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	struct file *file;
+	int fput_needed;
 	ssize_t ret;
 
 	if (pos < 0)
 		return -EINVAL;
-	file = fget(fd);
+	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
 	ret = compat_writev(file, vec, vlen, &pos);
-	fput(file);
+	fput_light(file, fput_needed);
 	return ret;
 }
 
-- 
1.5.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
