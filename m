From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 02/17] y2038: Remove newstat family from default
 syscall set
Date: Tue, 17 Jul 2018 16:18:41 +0200
Message-ID: <CAK8P3a3a8Fyi3e24CE=SPmdEKskEjeDr9YZte7DU_jT2svF3Uw@mail.gmail.com>
References: <20180716161103.16239-1-arnd@arndb.de> <20180716161103.16239-3-arnd@arndb.de>
 <20180717125039.GB25416@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180717125039.GB25416@infradead.org>
Sender: netdev-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, GNU C Library <libc-alpha@sourceware.org>, Albert ARIBAUD <albert.aribaud@3adev.fr>, Networking <netdev@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Dominik Brodowski <linux@dominikbrodowski.net>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 17, 2018 at 2:50 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jul 16, 2018 at 06:10:48PM +0200, Arnd Bergmann wrote:
>> We have four generations of stat() syscalls:
>> - the oldstat syscalls that are only used on the older architectures
>> - the newstat family that is used on all 64-bit architectures but
>>   lacked support for large files on 32-bit architectures.
>> - the stat64 family that is used mostly on 32-bit architectures to
>>   replace newstat
>> - statx() to replace all of the above, adding 64-bit timestamps among
>>   other things.
>>
>> We already compile stat64 only on those architectures that need it,
>> but newstat is always built, including on those that don't reference
>> it. This adds a new __ARCH_WANT_NEW_STAT symbol along the lines of
>> __ARCH_WANT_OLD_STAT and __ARCH_WANT_STAT64 to control compilation of
>> newstat. All architectures that need it use an explict define, the
>> others now get a little bit smaller, and future architecture (including
>> 64-bit targets) won't ever see it.
>>
>> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Do I read this right that you only want to provide statx by default?

Yes, that is correct.

> It is a little different from the traditional stat calls, so I'd like
> to know this is actually ok from libc folks first.

That would definitely help. See below for the stat implementation
I did in my musl libc prototype based on statx(). It passes the
LTP syscall tests, but that doesn't mean all the corner cases
are correct.

       Arnd

diff --git a/src/stat/fstat.c b/src/stat/fstat.c
index ab4afc0..b4f2027 100644
--- a/src/stat/fstat.c
+++ b/src/stat/fstat.c
@@ -1,3 +1,4 @@
+#define _BSD_SOURCE
 #include <sys/stat.h>
 #include <errno.h>
 #include <fcntl.h>
@@ -8,6 +9,9 @@ void __procfdname(char *, unsigned);

 int fstat(int fd, struct stat *st)
 {
+#ifdef __USE_TIME_BITS64
+       return __statx(fd, "", st, AT_EMPTY_PATH | AT_STATX_SYNC_AS_STAT);
+#else
        int ret = __syscall(SYS_fstat, fd, st);
        if (ret != -EBADF || __syscall(SYS_fcntl, fd, F_GETFD) < 0)
                return __syscall_ret(ret);
@@ -19,6 +23,7 @@ int fstat(int fd, struct stat *st)
 #else
        return syscall(SYS_fstatat, AT_FDCWD, buf, st, 0);
 #endif
+#endif
 }

 LFS64(fstat);
diff --git a/src/stat/fstatat.c b/src/stat/fstatat.c
index 863d526..80add64 100644
--- a/src/stat/fstatat.c
+++ b/src/stat/fstatat.c
@@ -1,10 +1,53 @@
+#define _BSD_SOURCE
 #include <sys/stat.h>
+#include <statx.h>
+#include <fcntl.h>
+#include <errno.h>
 #include "syscall.h"
 #include "libc.h"

+#ifdef __USE_TIME_BITS64
+
+#define AT_FLAGS (AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT | AT_EMPTY_PATH)
+
+int __statx(int fd, const char *restrict path, struct stat *restrict
buf, int flag)
+{
+       struct statx stx;
+       int ret;
+
+       ret = syscall(SYS_statx, fd, path, flag, STATX_BASIC_STATS, &stx);
+
+       buf->st_dev = (dev_t)stx.stx_dev_major << 32 | stx.stx_dev_minor;
+       buf->st_ino = stx.stx_ino;
+       buf->st_mode = stx.stx_mode;
+       buf->st_nlink = stx.stx_nlink;
+       buf->st_uid = stx.stx_uid;
+       buf->st_gid = stx.stx_gid;
+       buf->st_rdev = (dev_t)stx.stx_rdev_major << 32 | stx.stx_rdev_minor;
+       buf->st_size = stx.stx_size;
+       buf->st_blksize = stx.stx_blksize;
+       buf->st_blocks = stx.stx_blocks;
+       buf->st_atim.tv_sec = stx.stx_atime.tv_sec;
+       buf->st_mtim.tv_sec = stx.stx_atime.tv_sec;
+       buf->st_ctim.tv_sec = stx.stx_atime.tv_sec;
+       buf->st_atim.tv_nsec = stx.stx_atime.tv_nsec;
+       buf->st_mtim.tv_nsec = stx.stx_atime.tv_nsec;
+       buf->st_ctim.tv_nsec = stx.stx_atime.tv_nsec;
+
+       return ret;
+}
+#endif
+
 int fstatat(int fd, const char *restrict path, struct stat *restrict
buf, int flag)
 {
+#ifdef __USE_TIME_BITS64
+       if (flag & ~AT_FLAGS)
+               return __syscall_ret(-EINVAL);
+
+       return __statx(fd, path, buf, flag);
+#else
        return syscall(SYS_fstatat, fd, path, buf, flag);
+#endif
 }

 LFS64(fstatat);
diff --git a/src/stat/lstat.c b/src/stat/lstat.c
index 5e8b84f..ad2bddd 100644
--- a/src/stat/lstat.c
+++ b/src/stat/lstat.c
@@ -1,3 +1,4 @@
+#define _BSD_SOURCE
 #include <sys/stat.h>
 #include <fcntl.h>
 #include "syscall.h"
@@ -5,7 +6,9 @@

 int lstat(const char *restrict path, struct stat *restrict buf)
 {
-#ifdef SYS_lstat
+#ifdef __USE_TIME_BITS64
+       return __statx(AT_FDCWD, path, buf, AT_SYMLINK_NOFOLLOW |
AT_STATX_SYNC_AS_STAT);
+#elif defined(SYS_lstat)
        return syscall(SYS_lstat, path, buf);
 #else
        return syscall(SYS_fstatat, AT_FDCWD, path, buf, AT_SYMLINK_NOFOLLOW);
diff --git a/src/stat/stat.c b/src/stat/stat.c
index b4433a0..599903a 100644
--- a/src/stat/stat.c
+++ b/src/stat/stat.c
@@ -1,3 +1,4 @@
+#define _BSD_SOURCE
 #include <sys/stat.h>
 #include <fcntl.h>
 #include "syscall.h"
@@ -5,7 +6,9 @@

 int stat(const char *restrict path, struct stat *restrict buf)
 {
-#ifdef SYS_stat
+#ifdef __USE_TIME_BITS64
+       return __statx(AT_FDCWD, path, buf, AT_STATX_SYNC_AS_STAT);
+#elif defined(SYS_stat)
        return syscall(SYS_stat, path, buf);
 #else
        return syscall(SYS_fstatat, AT_FDCWD, path, buf, 0);
