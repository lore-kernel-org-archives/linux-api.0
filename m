From: akpm@linux-foundation.org
Subject: [merged] preadv-pwritev-create-compat_writev.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:57 -0700
Message-ID: <200904061937.n36Jbv5d013184@imap1.linux-foundation.org>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: kraxel@redhat.com, arnd@arndb.de, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, ralf@linux-mips.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org
List-Id: linux-api@vger.kernel.org


The patch titled
     preadv/pwritev: create compat_writev()
has been removed from the -mm tree.  Its filename was
     preadv-pwritev-create-compat_writev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: preadv/pwritev: create compat_writev()
From: Gerd Hoffmann <kraxel@redhat.com>

Factor out some code from compat_sys_writev() which can be shared with the
upcoming compat_sys_pwritev().

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <linux-api@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff -puN fs/compat.c~preadv-pwritev-create-compat_writev fs/compat.c
--- a/fs/compat.c~preadv-pwritev-create-compat_writev
+++ a/fs/compat.c
@@ -1232,15 +1232,12 @@ compat_sys_readv(unsigned long fd, const
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
 
@@ -1248,12 +1245,26 @@ compat_sys_writev(unsigned long fd, cons
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
_

Patches currently in -mm which might be from kraxel@redhat.com are

origin.patch
linux-next.patch
