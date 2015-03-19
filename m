From: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V6] Allow compaction of unevictable pages
Date: Thu, 19 Mar 2015 09:57:10 -0400
Message-ID: <1426773430-31052-1-git-send-email-emunson@akamai.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Currently, pages which are marked as unevictable are protected from
compaction, but not from other types of migration.  The POSIX real time
extension explicitly states that mlock() will prevent a major page
fault, but the spirit of is is that mlock() should give a process the
ability to control sources of latency, including minor page faults.
However, the mlock manpage only explicitly says that a locked page will
not be written to swap and this can cause some confusion.  The
compaction code today, does not give a developer who wants to avoid swap
but wants to have large contiguous areas available any method to achieve
this state.  This patch introduces a sysctl for controlling compaction
behavoir with respect to the unevictable lru.  Users that demand no page
faults after a page is present can set compact_unevictable to 0 and
users who need the large contiguous areas can enable compaction on
locked memory by leaving the default value of 1.

To illustrate this problem I wrote a quick test program that mmaps a
large number of 1MB files filled with random data.  These maps are
created locked and read only.  Then every other mmap is unmapped and I
attempt to allocate huge pages to the static huge page pool.  When the
compact_unevictable sysctl is 0, I cannot allocate hugepages after
fragmenting memory.  When the value is set to 1, allocations succeed.

Signed-off-by: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
Changes from V5:
* Default sysctl value is now 1
* Used more descriptive sysctl name
* documentation calss out default value

 Documentation/sysctl/vm.txt |   11 +++++++++++
 include/linux/compaction.h  |    1 +
 kernel/sysctl.c             |    9 +++++++++
 mm/compaction.c             |    7 +++++++
 4 files changed, 28 insertions(+)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 902b457..9832ec5 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -21,6 +21,7 @@ Currently, these files are in /proc/sys/vm:
 - admin_reserve_kbytes
 - block_dump
 - compact_memory
+- compact_unevictable_allowed
 - dirty_background_bytes
 - dirty_background_ratio
 - dirty_bytes
@@ -106,6 +107,16 @@ huge pages although processes will also directly compact memory as required.
 
 ==============================================================
 
+compact_unevictable_allowed
+
+Available only when CONFIG_COMPACTION is set. When set to 1, compaction is
+allowed to examine the unevictable lru (mlocked pages) for pages to compact.
+This should be used on systems where stalls for minor page faults are an
+acceptable trade for large contiguous free memory.  Set to 0 to prevent
+compaction from moving pages that are unevictable.  Default value is 1.
+
+==============================================================
+
 dirty_background_bytes
 
 Contains the amount of dirty memory at which the background kernel
diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index a014559..aa8f61c 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -34,6 +34,7 @@ extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 extern int sysctl_extfrag_threshold;
 extern int sysctl_extfrag_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
+extern int sysctl_compact_unevictable_allowed;
 
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 88ea2d6..2f6c880 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1313,6 +1313,15 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &min_extfrag_threshold,
 		.extra2		= &max_extfrag_threshold,
 	},
+	{
+		.procname	= "compact_unevictable_allowed",
+		.data		= &sysctl_compact_unevictable_allowed,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 
 #endif /* CONFIG_COMPACTION */
 	{
diff --git a/mm/compaction.c b/mm/compaction.c
index 8c0d945..ad88a8c 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1047,6 +1047,12 @@ typedef enum {
 } isolate_migrate_t;
 
 /*
+ * Allow userspace to control policy on scanning the unevictable LRU for
+ * compactable pages.
+ */
+int sysctl_compact_unevictable_allowed __read_mostly = 1;
+
+/*
  * Isolate all pages that can be migrated from the first suitable block,
  * starting at the block pointed to by the migrate scanner pfn within
  * compact_control.
@@ -1057,6 +1063,7 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 	unsigned long low_pfn, end_pfn;
 	struct page *page;
 	const isolate_mode_t isolate_mode =
+		(sysctl_compact_unevictable_allowed ? ISOLATE_UNEVICTABLE : 0) |
 		(cc->mode == MIGRATE_ASYNC ? ISOLATE_ASYNC_MIGRATE : 0);
 
 	/*
-- 
1.7.9.5
