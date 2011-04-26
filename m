From: Andrea Righi <andrea@betterlinux.com>
Subject: [RFC] [PATCH] drop_pagecache syscall
Date: Tue, 26 Apr 2011 23:35:27 +0200
Message-ID: <1303853727-21444-1-git-send-email-andrea@betterlinux.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Introduce sys_drop_pagecache() system call to drop the page cache pages of
a single filesystem.

This new system call takes a file descriptor as argument and drops only
the page cache pages of the file system it references.

At the moment it is possible to drop page cache pages via
/proc/sys/vm/drop_pagecache or via posix_fadvise(POSIX_FADV_DONTNEED).

The first method drops the whole page cache while the second can be used
to drop page cache pages of a single file descriptor. But there's not a
simple way to drop all the pages of a filesystem (we could scan all the
file descriptors and use posix_fadvise(), but this solution doesn't scale
very well in some cases).

This functionality can be used by all the applications that want to have a
better control over the page cache management (for example to immediately drop
pages that for sure will not be reused in the near future, without calling
posix_fadvise() for all the files they've touched), or to provide a more fine
grained debugging feature usable by the filesystem benchmarks.

The system call does not require root privileges and it can be called by any
unprivileged application. For example, we can write a userspace tool to run
something like this:

  $ drop-pagecache /path/file_or_dir

A practical example:

  $ ls -lh /mnt/sda/zero /mnt/sdb/zero
  -rw-r--r-- 1 root   root   16M 2011-04-20 10:20 /mnt/sda/zero
  -rw-r--r-- 1 root   root   16M 2011-04-20 10:20 /mnt/sdb/zero

  $ grep ^Cached /proc/meminfo
  Cached:             5660 kB
  $ md5sum /mnt/sda/zero /mnt/sdb/zero
  2c7ab85a893283e98c931e9511add182  /mnt/sda/zero
  2c7ab85a893283e98c931e9511add182  /mnt/sdb/zero
  $ grep ^Cached /proc/meminfo
  Cached:            38544 kB
  $ ./drop-pagecache /mnt/sda/
  $ grep ^Cached /proc/meminfo
  Cached:            22440 kB
  $ ./drop-pagecache /mnt/sdb/
  $ grep ^Cached /proc/meminfo
  Cached:             5056 kB

TODO:
 - provide support also for the architectures different than x86/x86_64

Signed-off-by: Andrea Righi <andrea@betterlinux.com>
---
 arch/x86/ia32/ia32entry.S          |    1 +
 arch/x86/include/asm/unistd_32.h   |    3 ++-
 arch/x86/include/asm/unistd_64.h   |    2 ++
 arch/x86/kernel/syscall_table_32.S |    1 +
 fs/drop_caches.c                   |   24 ++++++++++++++++++++++++
 include/asm-generic/unistd.h       |    4 +++-
 include/linux/syscalls.h           |    1 +
 7 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 849a9d2..d32f67c 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -848,4 +848,5 @@ ia32_sys_call_table:
 	.quad compat_sys_open_by_handle_at
 	.quad compat_sys_clock_adjtime
 	.quad sys_syncfs
+	.quad sys_drop_pagecache	/* 345 */
 ia32_syscall_end:
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index a755ef5..1c6630b 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -350,10 +350,11 @@
 #define __NR_open_by_handle_at  342
 #define __NR_clock_adjtime	343
 #define __NR_syncfs             344
+#define __NR_drop_pagecache	345
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 345
+#define NR_syscalls 346
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 160fa76..3234734 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -677,6 +677,8 @@ __SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
 __SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
 #define __NR_syncfs                             306
 __SYSCALL(__NR_syncfs, sys_syncfs)
+#define __NR_drop_pagecache			307
+__SYSCALL(__NR_drop_pagecache, sys_drop_pagecache)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index abce34d..6355af6 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -344,3 +344,4 @@ ENTRY(sys_call_table)
 	.long sys_open_by_handle_at
 	.long sys_clock_adjtime
 	.long sys_syncfs
+	.long sys_drop_pagecache	/* 345 */
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 98b77c8..ac043c7 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -6,6 +6,8 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/writeback.h>
+#include <linux/file.h>
+#include <linux/syscalls.h>
 #include <linux/sysctl.h>
 #include <linux/gfp.h>
 #include "internal.h"
@@ -37,6 +39,28 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
 	iput(toput_inode);
 }
 
+/*
+ * Drop page cache of a single superblock
+ */
+SYSCALL_DEFINE1(drop_pagecache, int, fd)
+{
+	struct file *file;
+	struct super_block *sb;
+	int fput_needed;
+
+	file = fget_light(fd, &fput_needed);
+	if (!file)
+		return -EBADF;
+	sb = file->f_dentry->d_sb;
+
+	down_read(&sb->s_umount);
+	drop_pagecache_sb(sb, NULL);
+	up_read(&sb->s_umount);
+
+	fput_light(file, fput_needed);
+	return 0;
+}
+
 static void drop_slab(void)
 {
 	int nr_objects;
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 07c40d5..088ff08 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -654,9 +654,11 @@ __SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
 __SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
 #define __NR_syncfs 267
 __SYSCALL(__NR_syncfs, sys_syncfs)
+#define __NR_drop_pagecache 268
+__SYSCALL(__NR_drop_pagecache, sys_drop_pagecache)
 
 #undef __NR_syscalls
-#define __NR_syscalls 268
+#define __NR_syscalls 269
 
 /*
  * All syscalls below here should go away really,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 83ecc17..af2a5c7 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -826,6 +826,7 @@ asmlinkage long sys_fanotify_mark(int fanotify_fd, unsigned int flags,
 				  u64 mask, int fd,
 				  const char  __user *pathname);
 asmlinkage long sys_syncfs(int fd);
+asmlinkage long sys_drop_pagecache(int fd);
 
 int kernel_execve(const char *filename, const char *const argv[], const char *const envp[]);
 
-- 
1.7.1
