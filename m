From: Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v7 2/5] create compat_writev()
Date: Mon, 26 Jan 2009 14:26:26 +0100
Message-ID: <1232976389-13021-3-git-send-email-kraxel@redhat.com>
References: <1232976389-13021-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1232976389-13021-1-git-send-email-kraxel@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
List-Id: linux-api@vger.kernel.org

Factor out some code from compat_sys_writev() which can be shared with the
upcoming compat_sys_pwritev().

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 fs/compat.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 75c1b46..4e65644 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1204,15 +1204,12 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
 	return ret;
 }
 
-asmlinkage ssize_t
-compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
+static size_t compat_writev(struct file *file,
+			    const struct compat_iovec __user *vec,
+			    unsigned long vlen, loff_t *pos)
 {
-	struct file *file;
 	ssize_t ret = -EBADF;
 
-	file = fget(fd);
-	if (!file)
-		return -EBADF;
 	if (!(file->f_mode & FMODE_WRITE))
 		goto out;
 
@@ -1220,12 +1217,26 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec, unsig
 	if (!file->f_op || (!file->f_op->aio_write && !file->f_op->write))
 		goto out;
 
-	ret = compat_do_readv_writev(WRITE, file, vec, vlen, &file->f_pos);
+	ret = compat_do_readv_writev(WRITE, file, vec, vlen, pos);
 
 out:
 	if (ret > 0)
 		add_wchar(current, ret);
 	inc_syscw(current);
+	return ret;
+}
+
+asmlinkage ssize_t
+compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec,
+		  unsigned long vlen)
+{
+	struct file *file;
+	ssize_t ret;
+
+	file = fget(fd);
+	if (!file)
+		return -EBADF;
+	ret = compat_writev(file, vec, vlen, &file->f_pos);
 	fput(file);
 	return ret;
 }
-- 
1.6.1
