From: akpm@linux-foundation.org
Subject: + preadv-pwritev-switch-compat-readv-preadv-writev-pwritev-from-fget-to-fget_light.patch added to -mm tree
Date: Mon, 02 Feb 2009 13:35:41 -0800
Message-ID: <200902022135.n12LZf8Y010899@imap1.linux-foundation.org>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kraxel@redhat.com, arnd@arndb.de, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, ralf@linux-mips.org, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org


The patch titled
     preadv/pwritev: switch compat readv/preadv/writev/pwritev from fget to fget_light
has been added to the -mm tree.  Its filename is
     preadv-pwritev-switch-compat-readv-preadv-writev-pwritev-from-fget-to-fget_light.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: preadv/pwritev: switch compat readv/preadv/writev/pwritev from fget to fget_light
From: Gerd Hoffmann <kraxel@redhat.com>

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <linux-api@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN fs/compat.c~preadv-pwritev-switch-compat-readv-preadv-writev-pwritev-from-fget-to-fget_light fs/compat.c
--- a/fs/compat.c~preadv-pwritev-switch-compat-readv-preadv-writev-pwritev-from-fget-to-fget_light
+++ a/fs/compat.c
@@ -1194,13 +1194,14 @@ compat_sys_readv(unsigned long fd, const
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
 
@@ -1210,15 +1211,16 @@ compat_sys_preadv(unsigned long fd, cons
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
 
@@ -1249,13 +1251,14 @@ compat_sys_writev(unsigned long fd, cons
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
 
@@ -1265,15 +1268,16 @@ compat_sys_pwritev(unsigned long fd, con
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
 
_

Patches currently in -mm which might be from kraxel@redhat.com are

linux-next.patch
preadv-pwritev-create-compat_readv.patch
preadv-pwritev-create-compat_writev.patch
preadv-pwritev-add-preadv-and-pwritev-system-calls.patch
preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls.patch
preadv-pwritev-switch-compat-readv-preadv-writev-pwritev-from-fget-to-fget_light.patch
