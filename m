From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [RFC v2 2/3] proc: add kpagecgroup file
Date: Tue, 7 Apr 2015 14:55:12 +0300
Message-ID: <bef0901fe6b1307d4435718f211850c2c641ea00.1428401673.git.vdavydov@parallels.com>
References: <cover.1428401673.git.vdavydov@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1428401673.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

/proc/kpagecgroup contains a 64-bit inode number of the memory cgroup
each page is charged to, indexed by PFN. Having this information is
useful for estimating a cgroup working set size.

The file is present if CONFIG_PROC_PAGE_MONITOR && CONFIG_MEMCG.

Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 Documentation/vm/pagemap.txt |    6 ++++-
 fs/proc/Kconfig              |    5 ++--
 fs/proc/page.c               |   53 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/Documentation/vm/pagemap.txt b/Documentation/vm/pagemap.txt
index 6fbd55ef6b45..1ddfa1367b03 100644
--- a/Documentation/vm/pagemap.txt
+++ b/Documentation/vm/pagemap.txt
@@ -5,7 +5,7 @@ pagemap is a new (as of 2.6.25) set of interfaces in the kernel that allow
 userspace programs to examine the page tables and related information by
 reading files in /proc.
 
-There are three components to pagemap:
+There are four components to pagemap:
 
  * /proc/pid/pagemap.  This file lets a userspace process find out which
    physical frame each virtual page is mapped to.  It contains one 64-bit
@@ -65,6 +65,10 @@ There are three components to pagemap:
     23. BALLOON
     24. ZERO_PAGE
 
+ * /proc/kpagecgroup.  This file contains a 64-bit inode number of the
+   memory cgroup each page is charged to, indexed by PFN. Only available when
+   CONFIG_MEMCG is set.
+
 Short descriptions to the page flags:
 
  0. LOCKED
diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 2183fcf41d59..5021a2935bb9 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -69,5 +69,6 @@ config PROC_PAGE_MONITOR
  	help
 	  Various /proc files exist to monitor process memory utilization:
 	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
-	  /proc/kpagecount, and /proc/kpageflags. Disabling these
-          interfaces will reduce the size of the kernel by approximately 4kb.
+	  /proc/kpagecount, /proc/kpageflags, and /proc/kpagecgroup.
+	  Disabling these interfaces will reduce the size of the kernel
+	  by approximately 4kb.
diff --git a/fs/proc/page.c b/fs/proc/page.c
index 7eee2d8b97d9..70d23245dd43 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -9,6 +9,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/hugetlb.h>
+#include <linux/memcontrol.h>
 #include <linux/kernel-page-flags.h>
 #include <asm/uaccess.h>
 #include "internal.h"
@@ -225,10 +226,62 @@ static const struct file_operations proc_kpageflags_operations = {
 	.read = kpageflags_read,
 };
 
+#ifdef CONFIG_MEMCG
+static ssize_t kpagecgroup_read(struct file *file, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	u64 __user *out = (u64 __user *)buf;
+	struct page *ppage;
+	unsigned long src = *ppos;
+	unsigned long pfn;
+	ssize_t ret = 0;
+	u64 ino;
+
+	pfn = src / KPMSIZE;
+	count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);
+	if (src & KPMMASK || count & KPMMASK)
+		return -EINVAL;
+
+	while (count > 0) {
+		if (pfn_valid(pfn))
+			ppage = pfn_to_page(pfn);
+		else
+			ppage = NULL;
+
+		if (ppage)
+			ino = page_cgroup_ino(ppage);
+		else
+			ino = 0;
+
+		if (put_user(ino, out)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		pfn++;
+		out++;
+		count -= KPMSIZE;
+	}
+
+	*ppos += (char __user *)out - buf;
+	if (!ret)
+		ret = (char __user *)out - buf;
+	return ret;
+}
+
+static const struct file_operations proc_kpagecgroup_operations = {
+	.llseek = mem_lseek,
+	.read = kpagecgroup_read,
+};
+#endif /* CONFIG_MEMCG */
+
 static int __init proc_page_init(void)
 {
 	proc_create("kpagecount", S_IRUSR, NULL, &proc_kpagecount_operations);
 	proc_create("kpageflags", S_IRUSR, NULL, &proc_kpageflags_operations);
+#ifdef CONFIG_MEMCG
+	proc_create("kpagecgroup", S_IRUSR, NULL, &proc_kpagecgroup_operations);
+#endif
 	return 0;
 }
 fs_initcall(proc_page_init);
-- 
1.7.10.4
