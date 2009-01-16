From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 2/5] create compat_writev()
Date: Fri, 16 Jan 2009 17:45:41 +0100
Message-ID: <1232124344-25892-3-git-send-email-kraxel@redhat.com>
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1232124344-25892-1-git-send-email-kraxel@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
List-Id: linux-api@vger.kernel.org

Factor out some code from compat_sys_writev() which can be shared with the
upcoming compat_sys_pwritev().

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 fs/compat.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 63738cc..9f20d10 100644
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
1.6.1
