From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 1/2] mm: Allow small allocations to fail
Date: Wed, 11 Mar 2015 16:54:53 -0400
Message-ID: <1426107294-21551-2-git-send-email-mhocko@suse.cz>
References: <1426107294-21551-1-git-send-email-mhocko@suse.cz>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426107294-21551-1-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

It's been ages since small allocations basically imply __GFP_NOFAIL
behavior (with some nuance - e.g. allocation might fail if the current
task is an OOM victim). The idea at the time was that the OOM killer
will make sufficient progress so the small allocation will succeed in
the end.
This assumption is flawed, though, because the retrying allocation might
be blocking a resource (e.g. a lock) which might prevent the OOM killer
victim from making progress and so the system is basically deadlocked.

Another aspect is that this behavior makes it extremely hard to make any
allocation failure policy implementation at the allocation caller. Most
of the allocation paths already check the for the allocation failure and
handle it properly.

There are some places which BUG_ON failure (mostly early boot code) and
they do not have to be changed. It is better to see a panic rather than
a silent freeze of the machine which is the case now.

Finally, if a non-failing allocation is unavoidable then __GFP_NOFAIL
flag is there to express this strong requirement. It is much better to
have a simple way to check all those places and come up with a solution
which will guarantee a forward progress for them.

As this behavior is established for many years we cannot change it
immediately. This patch instead exports a new sysctl/proc knob which
tells allocator how much to retry. The higher the number the longer will
the allocator loop and try to trigger OOM killer when the memory is too
low. This implementation counts only those retries which involved OOM
killer because we do not want to be too eager to fail the request.

I have tested it on a small machine (100M RAM + 128M swap, 2 CPUs) and
hammering it with anon consumers (10x 100M anon mapping per process and
10 processing running in parallel):
$ grep "Out of memory" anon-oom-1-retry| wc -l
8
$ grep "allocation failure" anon-oom-1-retry| wc -l
39

$ grep "Out of memory" anon-oom-10-retry| wc -l
10
$ grep "allocation failure" anon-oom-10-retry| wc -l
32

$ grep "Out of memory" anon-oom-100-retry| wc -l
10
$ grep "allocation failure" anon-oom-100-retry| wc -l
0

The default value is ULONG_MAX which basically preserves the current
behavior (endless retries). The idea is that we start with testing
systems first and lower the value to catch potential fallouts (crashes
due to unchecked failures or other misbehavior like FS ro-remounts
etc...). Allocation failures are already reported by warn_alloc_failed
so we should be able to catch the allocation path before an issue is
triggered.
.
We will try to encourage distributions to change the default in the
second step so that we get a much bigger exposure.

And finally we can change the default in the kernel while still keeping
the knob for conservative configurations. This will be long run but
let's start.

Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 Documentation/sysctl/vm.txt | 24 ++++++++++++++++++++++++
 include/linux/mm.h          |  2 ++
 kernel/sysctl.c             |  8 ++++++++
 mm/page_alloc.c             | 28 ++++++++++++++++++++++------
 4 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index e9c706e4627a..09f352ef8c3c 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -53,6 +53,7 @@ Currently, these files are in /proc/sys/vm:
 - page-cluster
 - panic_on_oom
 - percpu_pagelist_fraction
+- retry_allocation_attempts
 - stat_interval
 - swappiness
 - user_reserve_kbytes
@@ -707,6 +708,29 @@ sysctl, it will revert to this default behavior.
 
 ==============================================================
 
+retry_allocation_attempts
+
+Page allocator tries hard to not fail small allocations requests.
+Currently it retries indefinitely for small allocations requests (<= 32kB).
+This works mostly fine but under an extreme low memory conditions system
+might end up in deadlock situations because the looping allocation
+request might block further progress for OOM killer victims.
+
+Even though this hasn't turned out to be a huge problem for many years the
+long term plan is to move away from this default behavior but as this is
+a long established behavior we cannot change it immediately.
+
+This knob should help in the transition. It tells how many times should
+allocator retry when the system is OOM before the allocation fails.
+The default value (ULONG_MAX) preserves the old behavior. This is a safe
+default for production systems which cannot afford any unexpected
+downtimes. More experimental systems might set it to a small number
+(>=1), the higher the value the less probable would be allocation
+failures when OOM is transient and could be resolved without the
+particular allocation to fail.
+
+==============================================================
+
 stat_interval
 
 The time interval between which vm statistics are updated.  The default
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b720b5146a4e..e3b42f46e743 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -75,6 +75,8 @@ extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern unsigned long sysctl_overcommit_kbytes;
 
+extern unsigned long sysctl_nr_alloc_retry;
+
 extern int overcommit_ratio_handler(struct ctl_table *, int, void __user *,
 				    size_t *, loff_t *);
 extern int overcommit_kbytes_handler(struct ctl_table *, int, void __user *,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 88ea2d6e0031..4525f25e961b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1499,6 +1499,14 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
 	},
+	{
+		.procname	= "retry_allocation_attempts",
+		.data		= &sysctl_nr_alloc_retry,
+		.maxlen		= sizeof(sysctl_nr_alloc_retry),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &one_ul,
+	},
 	{ }
 };
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 58f6cf5bdde2..7ae07a5d08df 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -123,6 +123,17 @@ unsigned long dirty_balance_reserve __read_mostly;
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
+/*
+ * Number of allocation retries after the system is considered OOM.
+ * We have been retrying indefinitely for low order allocations for
+ * a very long time and this sysctl should help us to move away from
+ * this behavior because it complicates low memory conditions handling.
+ * The current default is preserving the behavior but non-critical
+ * environments are encouraged to lower the value to catch potential
+ * issues which should be fixed.
+ */
+unsigned long sysctl_nr_alloc_retry = ULONG_MAX;
+
 #ifdef CONFIG_PM_SLEEP
 /*
  * The following functions are used by the suspend/hibernate code to temporarily
@@ -2322,7 +2333,8 @@ void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...)
 static inline int
 should_alloc_retry(gfp_t gfp_mask, unsigned int order,
 				unsigned long did_some_progress,
-				unsigned long pages_reclaimed)
+				unsigned long pages_reclaimed,
+				unsigned long nr_retries)
 {
 	/* Do not loop if specifically requested */
 	if (gfp_mask & __GFP_NORETRY)
@@ -2342,11 +2354,12 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
 
 	/*
 	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
-	 * means __GFP_NOFAIL, but that may not be true in other
-	 * implementations.
+	 * retries allocations as per global configuration which might
+	 * also be indefinitely.
 	 */
-	if (order <= PAGE_ALLOC_COSTLY_ORDER)
-		return 1;
+	if (order <= PAGE_ALLOC_COSTLY_ORDER &&
+			nr_retries < sysctl_nr_alloc_retry)
+			return 1;
 
 	/*
 	 * For order > PAGE_ALLOC_COSTLY_ORDER, if __GFP_REPEAT is
@@ -2651,6 +2664,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	enum migrate_mode migration_mode = MIGRATE_ASYNC;
 	bool deferred_compaction = false;
 	int contended_compaction = COMPACT_CONTENDED_NONE;
+	unsigned long nr_retries = 0;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -2794,7 +2808,7 @@ retry:
 	/* Check if we should retry the allocation */
 	pages_reclaimed += did_some_progress;
 	if (should_alloc_retry(gfp_mask, order, did_some_progress,
-						pages_reclaimed)) {
+			       pages_reclaimed, nr_retries)) {
 		/*
 		 * If we fail to make progress by freeing individual
 		 * pages, but the allocation wants us to keep going,
@@ -2807,6 +2821,8 @@ retry:
 				goto got_pg;
 			if (!did_some_progress)
 				goto nopage;
+
+			nr_retries++;
 		}
 		/* Wait for some write requests to complete then retry */
 		wait_iff_congested(ac->preferred_zone, BLK_RW_ASYNC, HZ/50);
-- 
2.1.4
