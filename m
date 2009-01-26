From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v7 5/5] switch compat readv/preadv/writev/pwritev from fget to fget_light
Date: Mon, 26 Jan 2009 14:26:29 +0100
Message-ID: <1232976389-13021-6-git-send-email-kraxel@redhat.com>
References: <1232976389-13021-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1232976389-13021-1-git-send-email-kraxel@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
List-Id: linux-api@vger.kernel.org


Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 fs/compat.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 1a67eee..ad442ec 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1194,13 +1194,14 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
 		 unsigned long vlen)
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
 
@@ -1210,15 +1211,16 @@ compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
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
 
@@ -1249,13 +1251,14 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec,
 		  unsigned long vlen)
 {
 	struct file *file;
+	int fput_needed;
 	ssize_t ret;
 
-	file = fget(fd);
+	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
 	ret = compat_writev(file, vec, vlen, &file->f_pos);
-	fput(file);
+	fput_light(file, fput_needed);
 	return ret;
 }
 
@@ -1265,15 +1268,16 @@ compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
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
1.6.1
