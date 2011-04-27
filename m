From: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Subject: [PATCH] fadvise: introduce POSIX_FADV_DONTNEED_FS
Date: Wed, 27 Apr 2011 16:29:05 +0200
Message-ID: <1303914545-15642-1-git-send-email-andrea@betterlinux.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Introduce a new fadvise flag to drop page cache pages of a single
filesystem.

At the moment it is possible to drop page cache pages via
/proc/sys/vm/drop_pagecache or via posix_fadvise(POSIX_FADV_DONTNEED).

The first method drops the whole page cache while the second can be used
to drop page cache pages of a single file descriptor. However, there's
not a simple way to drop all the pages of a filesystem (we could scan
all the file descriptors and use posix_fadvise(POSIX_FADV_DONTNEED), but
this solution obviously doesn't scale well).

This functionality requires root privilege to avoid potential DoS in the
system (i.e., a hard loop of posix_fadvise(POSIX_FADV_DONTNEED_FS) on
the root filesystem).

A practical example:

  # ls -lh /mnt/sda/zero /mnt/sdb/zero
  -rw-r--r-- 1 root   root   16M 2011-04-20 10:20 /mnt/sda/zero
  -rw-r--r-- 1 root   root   16M 2011-04-20 10:20 /mnt/sdb/zero

  $ grep ^Cached /proc/meminfo
  Cached:             5660 kB
  $ md5sum /mnt/sda/zero /mnt/sdb/zero
  2c7ab85a893283e98c931e9511add182  /mnt/sda/zero
  2c7ab85a893283e98c931e9511add182  /mnt/sdb/zero
  $ grep ^Cached /proc/meminfo
  Cached:            38544 kB
  $ sudo ./drop-pagecache /mnt/sda/
  $ grep ^Cached /proc/meminfo
  Cached:            22440 kB
  $ sudo ./drop-pagecache /mnt/sdb/
  $ grep ^Cached /proc/meminfo
  Cached:             5056 kB

A previous RFC about this topic can be found here:
  http://marc.info/?l=linux-kernel&m=130385374902114&w=2

Signed-off-by: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
---
 fs/drop_caches.c        |    2 +-
 include/linux/fadvise.h |    2 ++
 include/linux/mm.h      |    2 ++
 mm/fadvise.c            |    7 +++++++
 4 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 98b77c8..59d6caa 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -13,7 +13,7 @@
 /* A global variable is a bit ugly, but it keeps the code simple */
 int sysctl_drop_caches;
 
-static void drop_pagecache_sb(struct super_block *sb, void *unused)
+void drop_pagecache_sb(struct super_block *sb, void *unused)
 {
 	struct inode *inode, *toput_inode = NULL;
 
diff --git a/include/linux/fadvise.h b/include/linux/fadvise.h
index e8e7471..dc9ce98 100644
--- a/include/linux/fadvise.h
+++ b/include/linux/fadvise.h
@@ -13,9 +13,11 @@
 #if defined(__s390x__)
 #define POSIX_FADV_DONTNEED	6 /* Don't need these pages.  */
 #define POSIX_FADV_NOREUSE	7 /* Data will be accessed once.  */
+#define POSIX_FADV_DONTNEED_FS	8 /* Don't need these filesystem pages.  */
 #else
 #define POSIX_FADV_DONTNEED	4 /* Don't need these pages.  */
 #define POSIX_FADV_NOREUSE	5 /* Data will be accessed once.  */
+#define POSIX_FADV_DONTNEED_FS	6 /* Don't need these filesystem pages.  */
 #endif
 
 #endif	/* FADVISE_H_INCLUDED */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 692dbae..004cdbc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -21,6 +21,7 @@ struct anon_vma;
 struct file_ra_state;
 struct user_struct;
 struct writeback_control;
+struct super_block;
 
 #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
@@ -1602,6 +1603,7 @@ int in_gate_area_no_mm(unsigned long addr);
 #define in_gate_area(mm, addr) ({(void)mm; in_gate_area_no_mm(addr);})
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
+void drop_pagecache_sb(struct super_block *sb, void *unused);
 int drop_caches_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 8d723c9..4e31fe1 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -57,6 +57,7 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 		case POSIX_FADV_WILLNEED:
 		case POSIX_FADV_NOREUSE:
 		case POSIX_FADV_DONTNEED:
+		case POSIX_FADV_DONTNEED_FS:
 			/* no bad return value, but ignore advice */
 			break;
 		default:
@@ -127,6 +128,12 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 			invalidate_mapping_pages(mapping, start_index,
 						end_index);
 		break;
+	case POSIX_FADV_DONTNEED_FS:
+		if (!current_euid())
+			drop_pagecache_sb(file->f_dentry->d_sb, NULL);
+		else
+			ret = -EPERM;
+		break;
 	default:
 		ret = -EINVAL;
 	}
-- 
1.7.1
