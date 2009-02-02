From: akpm@linux-foundation.org
Subject: + preadv-pwritev-create-compat_readv.patch added to -mm tree
Date: Mon, 02 Feb 2009 13:35:30 -0800
Message-ID: <200902022135.n12LZUUN010608@imap1.linux-foundation.org>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kraxel@redhat.com, arnd@arndb.de, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, ralf@linux-mips.org, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org


The patch titled
     preadv/pwritev: create compat_readv()
has been added to the -mm tree.  Its filename is
     preadv-pwritev-create-compat_readv.patch

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
Subject: preadv/pwritev: create compat_readv()
From: Gerd Hoffmann <kraxel@redhat.com>

This patch series:

Implement the preadv() and pwritev() syscalls.  *BSD has this syscall for
quite some time.

Test code:

#if 0
set -x
gcc -Wall -O2 -o preadv $0
exit 0
#endif
/*
 * preadv demo / test
 *
 * (c) 2008 Gerd Hoffmann <kraxel@redhat.com>
 *
 * build with "sh $thisfile"
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <inttypes.h>
#include <sys/uio.h>

/* ----------------------------------------------------------------- */
/* syscall windup                                                    */

#include <sys/syscall.h>
#if 0
/* WARNING: Be sure you know what you are doing if you enable this.
 * linux syscall code isn't upstream yet, syscall numbers are subject
 * to change */
# ifndef __NR_preadv
#  ifdef __i386__
#   define __NR_preadv  333
#   define __NR_pwritev 334
#  endif
#  ifdef __x86_64__
#   define __NR_preadv  295
#   define __NR_pwritev 296
#  endif
# endif
#endif
#ifndef __NR_preadv
# error preadv/pwritev syscall numbers are unknown
#endif

static ssize_t preadv(int fd, const struct iovec *iov, int iovcnt, off_t offset)
{
    uint32_t pos_high = (offset >> 32) & 0xffffffff;
    uint32_t pos_low  =  offset        & 0xffffffff;

    return syscall(__NR_preadv, fd, iov, iovcnt, pos_high, pos_low);
}

static ssize_t pwritev(int fd, const struct iovec *iov, int iovcnt, off_t offset)
{
    uint32_t pos_high = (offset >> 32) & 0xffffffff;
    uint32_t pos_low  =  offset        & 0xffffffff;

    return syscall(__NR_pwritev, fd, iov, iovcnt, pos_high, pos_low);
}

/* ----------------------------------------------------------------- */
/* demo/test app                                                     */

static char filename[] = "/tmp/preadv-XXXXXX";
static char outbuf[11] = "0123456789";
static char inbuf[11]  = "----------";

static struct iovec ovec[2] = {{
        .iov_base = outbuf + 5,
        .iov_len  = 5,
    },{
        .iov_base = outbuf + 0,
        .iov_len  = 5,
    }};

static struct iovec ivec[3] = {{
        .iov_base = inbuf + 6,
        .iov_len  = 2,
    },{
        .iov_base = inbuf + 4,
        .iov_len  = 2,
    },{
        .iov_base = inbuf + 2,
        .iov_len  = 2,
    }};

void cleanup(void)
{
    unlink(filename);
}

int main(int argc, char **argv)
{
    int fd, rc;

    fd = mkstemp(filename);
    if (-1 == fd) {
        perror("mkstemp");
        exit(1);
    }
    atexit(cleanup);

    /* write to file: "56789-01234" */
    rc = pwritev(fd, ovec, 2, 0);
    if (rc < 0) {
        perror("pwritev");
        exit(1);
    }

    /* read from file: "78-90-12" */
    rc = preadv(fd, ivec, 3, 2);
    if (rc < 0) {
        perror("preadv");
        exit(1);
    }

    printf("result  : %s\n", inbuf);
    printf("expected: %s\n", "--129078--");
    exit(0);
}


This patch:

Factor out some code from compat_sys_readv() which can be shared with the
upcoming compat_sys_preadv().


Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <linux-api@vger.kernel.org>
Cc: <linux-arch@vger.kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff -puN fs/compat.c~preadv-pwritev-create-compat_readv fs/compat.c
--- a/fs/compat.c~preadv-pwritev-create-compat_readv
+++ a/fs/compat.c
@@ -1167,16 +1167,12 @@ out:
 	return ret;
 }
 
-asmlinkage ssize_t
-compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec, unsigned long vlen)
+static size_t compat_readv(struct file *file,
+			   const struct compat_iovec __user *vec,
+			   unsigned long vlen, loff_t *pos)
 {
-	struct file *file;
 	ssize_t ret = -EBADF;
 
-	file = fget(fd);
-	if (!file)
-		return -EBADF;
-
 	if (!(file->f_mode & FMODE_READ))
 		goto out;
 
@@ -1184,12 +1180,26 @@ compat_sys_readv(unsigned long fd, const
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
+compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
+		 unsigned long vlen)
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
_

Patches currently in -mm which might be from kraxel@redhat.com are

linux-next.patch
preadv-pwritev-create-compat_readv.patch
preadv-pwritev-create-compat_writev.patch
preadv-pwritev-add-preadv-and-pwritev-system-calls.patch
preadv-pwritev-mips-add-preadv2-and-pwritev2-syscalls.patch
preadv-pwritev-switch-compat-readv-preadv-writev-pwritev-from-fget-to-fget_light.patch
