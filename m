From: y@redhat.com
Subject: [Patch v5 3/6] create compat_writev()
Date: Fri, 19 Dec 2008 16:58:22 +0100
Message-ID: <4140.23761773041$1229702502@news.gmane.org>
References: <1229702305-23027-1-git-send-email-y>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751893AbYLSP7q@vger.kernel.org>
In-Reply-To: <1229702305-23027-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
List-Id: linux-api@vger.kernel.org

From: Gerd Hoffmann <kraxel@redhat.com>

Factor out some code from compat_sys_writev() which can be shared with the
upcoming compat_sys_pwritev().

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 fs/compat.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 361cb7d..1ca314f 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1202,15 +1202,11 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec, unsign
 	return ret;
 }
 
-asmlinkage ssize_t
-compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
+static size_t compat_writev(struct file *file, const struct compat_iovec __user *vec,
+                            unsigned long vlen, loff_t *pos)
 {
-	struct file *file;
 	ssize_t ret = -EBADF;
 
-	file = fget(fd);
-	if (!file)
-		return -EBADF;
 	if (!(file->f_mode & FMODE_WRITE))
 		goto out;
 
@@ -1218,16 +1214,29 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsig
 	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
 		goto out;
 
-	ret = compat_do_readv_writev(WRITE, file, vec, vlen, &file->f_pos);
+	ret = compat_do_readv_writev(WRITE, file, vec, vlen, pos);
 
 out:
 	if (ret > 0)
 		add_wchar(current, ret);
 	inc_syscw(current);
-	fput(file);
 	return ret;
 }
 
+asmlinkage ssize_t
+compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
+{
+	struct file *file;
+	ssize_t ret;
+
+	file = fget(fd);
+	if (!file)
+		return -EBADF;
+	ret = compat_writev(file, vec, vlen, &file->f_pos);
+        fput(file);
+        return ret;
+}
+
 asmlinkage long
 compat_sys_vmsplice(int fd, const struct compat_iovec __user *iov32,
 		    unsigned int nr_segs, unsigned int flags)
-- 
1.5.6.5
