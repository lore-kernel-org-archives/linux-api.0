From: y@redhat.com
Subject: [Patch v5 2/6] create compat_readv()
Date: Fri, 19 Dec 2008 16:58:21 +0100
Message-ID: <16946.8370070264$1229702461@news.gmane.org>
References: <1229702305-23027-1-git-send-email-y>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751803AbYLSP64@vger.kernel.org>
In-Reply-To: <1229702305-23027-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
List-Id: linux-api@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

Factor out some code from compat_sys_readv() which can be shared with the
upcoming compat_sys_preadv().

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
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
