From: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Subject: [PATCH v3] fadvise: introduce POSIX_FADV_DONTNEED_FS
Date: Fri, 29 Apr 2011 18:19:40 +0200
Message-ID: <1304093980-12877-1-git-send-email-andrea@betterlinux.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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

NOTE #1: to avoid potential DoS in the system the rate of calls to
fadvise(POSIX_FADV_DONTNEED_FS) from non-privileged users are limited
according to these settings:

 - /proc/sys/vm/drop_pagecache_ratelimit: the minimum length of time
   allowed beetween two different bursts of fadvise(POSIX_FADV_DONTNEED_FS)

 - /proc/sys/vm/drop_pagecache_ratelimit_burst: the number of calls to
   fadvise(POSIX_FADV_DONTNEED_FS) that can be issued before enforcing
   the rate limiting

When the rate limit is exceeded the function returns -EPERM.

NOTE #2: for a regular file, drops the pages of the superblock it
references; for a block device, drops the pages of the superblock
corresponding to the device (if mounted).

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
  $ ./drop-pagecache /mnt/sda/
  $ grep ^Cached /proc/meminfo
  Cached:            22440 kB
  $ ./drop-pagecache /mnt/sdb/
  $ grep ^Cached /proc/meminfo
  Cached:             5056 kB

A previous RFC about this topic can be found here:
  http://marc.info/?l=linux-kernel&m=130385374902114&w=2

ChangeLog (v2 -> v3):

 * limit the rate of POSIX_FADV_DONTNEED_FS if executed by a
   non-privileged user
 * if fadvise() is called on a block devices (i.e. /dev/sda) drop the
   pages of the superblock corresponding to this device (if mounted)

Signed-off-by: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
---
 Documentation/sysctl/vm.txt |   22 ++++++++++++++++++++++
 fs/drop_caches.c            |    2 +-
 include/linux/fadvise.h     |    1 +
 include/linux/mm.h          |    4 ++++
 kernel/sysctl.c             |   14 ++++++++++++++
 mm/fadvise.c                |   37 +++++++++++++++++++++++++++++++++++++
 6 files changed, 79 insertions(+), 1 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 30289fa..39aa7e3 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -27,6 +27,8 @@ Currently, these files are in /proc/sys/vm:
 - dirty_ratio
 - dirty_writeback_centisecs
 - drop_caches
+- drop_pagecache_ratelimit
+- drop_pagecache_ratelimit_burst
 - extfrag_threshold
 - hugepages_treat_as_movable
 - hugetlb_shm_group
@@ -154,6 +156,26 @@ user should run `sync' first.
 
 ==============================================================
 
+drop_pagecache_ratelimit
+
+To avoid potential DoS in the system the rate of calls to
+fadvise(POSIX_FADV_DONTNEED_FS) from non-privileged users are limited.
+
+This value defines the minimum length of time allowed beetween two different
+bursts of fadvise(POSIX_FADV_DONTNEED_FS).
+
+==============================================================
+
+drop_pagecache_ratelimit_burst
+
+To avoid potential DoS in the system the rate of calls to
+fadvise(POSIX_FADV_DONTNEED_FS) from non-privileged users are limited.
+
+This value defines the number of calls to fadvise(POSIX_FADV_DONTNEED_FS) that
+can be issued before enforcing the rate limiting.
+
+==============================================================
+
 extfrag_threshold
 
 This parameter affects whether the kernel will compact memory or direct
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
index e8e7471..ab39117 100644
--- a/include/linux/fadvise.h
+++ b/include/linux/fadvise.h
@@ -17,5 +17,6 @@
 #define POSIX_FADV_DONTNEED	4 /* Don't need these pages.  */
 #define POSIX_FADV_NOREUSE	5 /* Data will be accessed once.  */
 #endif
+#define POSIX_FADV_DONTNEED_FS	8 /* Don't need these filesystem pages.  */
 
 #endif	/* FADVISE_H_INCLUDED */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2348db2..2d57612 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -14,6 +14,7 @@
 #include <linux/mm_types.h>
 #include <linux/range.h>
 #include <linux/pfn.h>
+#include <linux/ratelimit.h>
 #include <linux/bit_spinlock.h>
 
 struct mempolicy;
@@ -21,6 +22,7 @@ struct anon_vma;
 struct file_ra_state;
 struct user_struct;
 struct writeback_control;
+struct super_block;
 
 #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
@@ -33,6 +35,7 @@ extern int page_cluster;
 
 #ifdef CONFIG_SYSCTL
 extern int sysctl_legacy_va_layout;
+extern struct ratelimit_state drop_pagecache_ratelimit_state;
 #else
 #define sysctl_legacy_va_layout 0
 #endif
@@ -1603,6 +1606,7 @@ int in_gate_area_no_mm(unsigned long addr);
 #define in_gate_area(mm, addr) ({(void)mm; in_gate_area_no_mm(addr);})
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
+void drop_pagecache_sb(struct super_block *sb, void *unused);
 int drop_caches_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c0bb324..4d404ae 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1145,6 +1145,20 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &one,
 		.extra2		= &three,
 	},
+	{
+		.procname	= "drop_pagecache_ratelimit",
+		.data		= &drop_pagecache_ratelimit_state.interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{
+		.procname	= "drop_pagecache_ratelimit_burst",
+		.data		= &drop_pagecache_ratelimit_state.burst,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 #ifdef CONFIG_COMPACTION
 	{
 		.procname	= "compact_memory",
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 8d723c9..8adf620 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -16,10 +16,39 @@
 #include <linux/pagevec.h>
 #include <linux/fadvise.h>
 #include <linux/writeback.h>
+#include <linux/ratelimit.h>
 #include <linux/syscalls.h>
 
 #include <asm/unistd.h>
 
+/* Limit the rate of the page cache drop */
+DEFINE_RATELIMIT_STATE(drop_pagecache_ratelimit_state,
+			DEFAULT_RATELIMIT_INTERVAL, DEFAULT_RATELIMIT_BURST);
+
+static inline struct super_block *file_to_sb(struct file *file)
+{
+	struct block_device *bdev = I_BDEV(file->f_mapping->host);
+
+	return bdev ? get_super(bdev) : NULL;
+}
+
+/*
+ * For a regular file, drop the pages of the superblock it references. For a
+ * block device, drop the pages of the superblock corresponding to this device
+ * (if mounted).
+ */
+static void fadvise_drop_pagecache(struct file *file)
+{
+	struct super_block *sb;
+
+	sb = file_to_sb(file);
+	if (sb) {
+		drop_pagecache_sb(sb, NULL);
+		drop_super(sb);
+	} else
+		drop_pagecache_sb(file->f_mapping->host->i_sb, NULL);
+}
+
 /*
  * POSIX_FADV_WILLNEED could set PG_Referenced, and POSIX_FADV_NOREUSE could
  * deactivate the pages and clear PG_Referenced.
@@ -57,6 +86,7 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 		case POSIX_FADV_WILLNEED:
 		case POSIX_FADV_NOREUSE:
 		case POSIX_FADV_DONTNEED:
+		case POSIX_FADV_DONTNEED_FS:
 			/* no bad return value, but ignore advice */
 			break;
 		default:
@@ -127,6 +157,13 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 			invalidate_mapping_pages(mapping, start_index,
 						end_index);
 		break;
+	case POSIX_FADV_DONTNEED_FS:
+		if (capable(CAP_SYS_ADMIN) ||
+				__ratelimit(&drop_pagecache_ratelimit_state))
+			fadvise_drop_pagecache(file);
+		else
+			ret = -EPERM;
+		break;
 	default:
 		ret = -EINVAL;
 	}
-- 
1.7.1
