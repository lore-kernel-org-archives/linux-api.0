From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 143/166] preadv/pwritev: Add preadv and pwritev system
 calls.
Date: Fri, 03 Apr 2009 13:53:16 +0200
Message-ID: <49D5F8AC.6040608@redhat.com>
References: <200904022359.n32NxNYu022834@imap1.linux-foundation.org> <alpine.LFD.2.00.0904021839390.15441@localhost.localdomain> <49D5CA58.20908@redhat.com> <49D5D609.7030400@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030909000609080900040506"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <49D5D609.7030400-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--------------030909000609080900040506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Gerd Hoffmann wrote:

> Patch attached for comments (builds, but otherwise not tested yet).

New patch, updates compat_sys_writev() which was incomplete in the
previous version.  Now tested on x86_64, both 32 and 64-bit binaries.

cheers,
  Gerd


--------------030909000609080900040506
Content-Type: text/plain;
 name="0001-preadv-pwritev-tweak-interface.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-preadv-pwritev-tweak-interface.patch"

>From fc35c3cee3c3f821c39359fa6b33198d1a0219e6 Mon Sep 17 00:00:00 2001
From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Fri, 3 Apr 2009 11:08:00 +0200
Subject: [PATCH] preadv/pwritev: tweak interface.

Go from "u32" to "unsigned long" for the pos_{high,low} syscall
arguments.  That way we avoid the 32/32 split for 64bit archs,
and we still side-step the ABI issue with unaligned 64bit args
on a number of 32bit archs.  pos_high on 64bit is unused for
the time being. Some day we might be happy to have it though ;)

Signed-off-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/compat.c              |    8 ++++----
 fs/read_write.c          |   12 ++++++++----
 include/linux/compat.h   |    4 ++--
 include/linux/syscalls.h |    4 ++--
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 1c859da..17e1dd1 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1236,9 +1236,9 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
 
 asmlinkage ssize_t
 compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
-		  unsigned long vlen, u32 pos_high, u32 pos_low)
+		  unsigned long vlen, unsigned long pos_high, unsigned long pos_low)
 {
-	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+	loff_t pos = ((loff_t)pos_high << BITS_PER_COMPAT_LONG) | pos_low;
 	struct file *file;
 	int fput_needed;
 	ssize_t ret;
@@ -1293,9 +1293,9 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec,
 
 asmlinkage ssize_t
 compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
-		   unsigned long vlen, u32 pos_high, u32 pos_low)
+		   unsigned long vlen, unsigned long pos_high, unsigned long pos_low)
 {
-	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+	loff_t pos = ((loff_t)pos_high << BITS_PER_COMPAT_LONG) | pos_low;
 	struct file *file;
 	int fput_needed;
 	ssize_t ret;
diff --git a/fs/read_write.c b/fs/read_write.c
index 6d5d8ff..8201e60 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -731,10 +731,14 @@ SYSCALL_DEFINE3(writev, unsigned long, fd, const struct iovec __user *, vec,
 	return ret;
 }
 
+#define HALF_LONG (BITS_PER_LONG / 2)
+
 SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
-		unsigned long, vlen, u32, pos_high, u32, pos_low)
+		unsigned long, vlen, unsigned long, pos_high, unsigned long, pos_low)
 {
-	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+	/* gcc optimizes away the shifts for
+	 * sizeof(pos_high) == sizeof(pos), i.e. on 64bit archs */
+	loff_t pos = (((loff_t)pos_high << HALF_LONG) << HALF_LONG) | pos_low;
 	struct file *file;
 	ssize_t ret = -EBADF;
 	int fput_needed;
@@ -757,9 +761,9 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
 }
 
 SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
-		unsigned long, vlen, u32, pos_high, u32, pos_low)
+		unsigned long, vlen, unsigned long, pos_high, unsigned long, pos_low)
 {
-	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+	loff_t pos = (((loff_t)pos_high << HALF_LONG) << HALF_LONG) | pos_low;
 	struct file *file;
 	ssize_t ret = -EBADF;
 	int fput_needed;
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 9723edd..f4b607e 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -193,10 +193,10 @@ asmlinkage ssize_t compat_sys_writev(unsigned long fd,
 		const struct compat_iovec __user *vec, unsigned long vlen);
 asmlinkage ssize_t compat_sys_preadv(unsigned long fd,
 		const struct compat_iovec __user *vec,
-		unsigned long vlen, u32 pos_high, u32 pos_low);
+		unsigned long vlen, unsigned long pos_high, unsigned long pos_low);
 asmlinkage ssize_t compat_sys_pwritev(unsigned long fd,
 		const struct compat_iovec __user *vec,
-		unsigned long vlen, u32 pos_high, u32 pos_low);
+		unsigned long vlen, unsigned long pos_high, unsigned long pos_low);
 
 int compat_do_execve(char * filename, compat_uptr_t __user *argv,
 	        compat_uptr_t __user *envp, struct pt_regs * regs);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b299a82..25e60b0 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -462,9 +462,9 @@ asmlinkage long sys_pread64(unsigned int fd, char __user *buf,
 asmlinkage long sys_pwrite64(unsigned int fd, const char __user *buf,
 			     size_t count, loff_t pos);
 asmlinkage long sys_preadv(unsigned long fd, const struct iovec __user *vec,
-			   unsigned long vlen, u32 pos_high, u32 pos_low);
+			   unsigned long vlen, unsigned long pos_high, unsigned long pos_low);
 asmlinkage long sys_pwritev(unsigned long fd, const struct iovec __user *vec,
-			    unsigned long vlen, u32 pos_high, u32 pos_low);
+			    unsigned long vlen, unsigned long pos_high, unsigned long pos_low);
 asmlinkage long sys_getcwd(char __user *buf, unsigned long size);
 asmlinkage long sys_mkdir(const char __user *pathname, int mode);
 asmlinkage long sys_chdir(const char __user *filename);
-- 
1.6.1.3


--------------030909000609080900040506--
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
