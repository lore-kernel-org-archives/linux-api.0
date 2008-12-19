From: y@redhat.com
Subject: [Patch v5 6/6] switch compat readv/preadv/writev/pwritev from fget to fget_light
Date: Fri, 19 Dec 2008 16:58:25 +0100
Message-ID: <17199.758886318$1229702555@news.gmane.org>
References: <1229702305-23027-1-git-send-email-y>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753159AbYLSQAd@vger.kernel.org>
In-Reply-To: <1229702305-23027-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
List-Id: linux-api@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>


Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
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
