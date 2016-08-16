From: robert.foss@collabora.com
Subject: [PACTH v3 1/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Tue, 16 Aug 2016 13:34:14 -0400
Message-ID: <1471368856-11455-2-git-send-email-robert.foss@collabora.com>
References: <1471368856-11455-1-git-send-email-robert.foss@collabora.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471368856-11455-1-git-send-email-robert.foss@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: corbet@lwn.net, akpm@linux-foundation.org, vbabka@suse.cz, mhocko@suse.com, koct9i@gmail.com, hughd@google.com, robert.foss@collabora.com, n-horiguchi@ah.jp.nec.com, john.stultz@linaro.org, minchan@kernel.org, ross.zwisler@linux.intel.com, jmarchan@redhat.com, hannes@cmpxchg.org, mingo@kernel.org, keescook@chromium.org, viro@zeniv.linux.org.uk, gorcunov@openvz.org, sonnyrao@chromium.org, plaguedbypenguins@gmail.com, eric.engestrom@imgtec.com, rientjes@google.com, jdanis@google.com, calvinowens@fb.com, adobriyan@gmail.com, jann@thejh.net, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Ben Zhang <benzh@chromium.org>, Bryan Freed <bfreed@chromium.org>, Filipe Brandenburger <filbranden@chromium.org>, Mateusz Guzik <mguzik@redhat.com>, Michal Hocko <mhocko@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Robert Foss <robert.foss@collabora.com>

This is based on earlier work by Thiago Goncales. It implements a new
per process proc file which summarizes the contents of the smaps file
but doesn't display any addresses.  It gives more detailed information
than statm like the PSS (proprotional set size).  It differs from the
original implementation in that it doesn't use the full blown set of
seq operations, uses a different termination condition, and doesn't
displayed "Locked" as that was broken on the original implemenation.

This new proc file provides information faster than parsing the potentially
huge smaps file.

Tested-by: Robert Foss <robert.foss@collabora.com>
Signed-off-by: Robert Foss <robert.foss@collabora.com>

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
---
 fs/proc/base.c     |   1 +
 fs/proc/internal.h |   2 +
 fs/proc/task_mmu.c | 129 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 132 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index a11eb71..de3acdf 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2855,6 +2855,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
 	REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
 	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
+	REG("totmaps",    S_IRUGO, proc_totmaps_operations),
 #endif
 #ifdef CONFIG_SECURITY
 	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index aa27810..99f97d7 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -297,6 +297,8 @@ extern const struct file_operations proc_pid_smaps_operations;
 extern const struct file_operations proc_tid_smaps_operations;
 extern const struct file_operations proc_clear_refs_operations;
 extern const struct file_operations proc_pagemap_operations;
+extern const struct file_operations proc_totmaps_operations;
+
 
 extern unsigned long task_vsize(struct mm_struct *);
 extern unsigned long task_statm(struct mm_struct *,
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4648c7f..fe692cb 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -802,6 +802,75 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 	return 0;
 }
 
+static void add_smaps_sum(struct mem_size_stats *mss,
+		struct mem_size_stats *mss_sum)
+{
+	mss_sum->resident += mss->resident;
+	mss_sum->pss += mss->pss;
+	mss_sum->shared_clean += mss->shared_clean;
+	mss_sum->shared_dirty += mss->shared_dirty;
+	mss_sum->private_clean += mss->private_clean;
+	mss_sum->private_dirty += mss->private_dirty;
+	mss_sum->referenced += mss->referenced;
+	mss_sum->anonymous += mss->anonymous;
+	mss_sum->anonymous_thp += mss->anonymous_thp;
+	mss_sum->swap += mss->swap;
+}
+
+static int totmaps_proc_show(struct seq_file *m, void *data)
+{
+	struct proc_maps_private *priv = m->private;
+	struct mm_struct *mm = priv->mm;
+	struct vm_area_struct *vma;
+	struct mem_size_stats mss_sum;
+
+	memset(&mss_sum, 0, sizeof(mss_sum));
+	down_read(&mm->mmap_sem);
+	hold_task_mempolicy(priv);
+
+	for (vma = mm->mmap; vma != priv->tail_vma; vma = vma->vm_next) {
+		struct mem_size_stats mss;
+		struct mm_walk smaps_walk = {
+			.pmd_entry = smaps_pte_range,
+			.mm = vma->vm_mm,
+			.private = &mss,
+		};
+
+		if (vma->vm_mm && !is_vm_hugetlb_page(vma)) {
+			memset(&mss, 0, sizeof(mss));
+			walk_page_vma(vma, &smaps_walk);
+			add_smaps_sum(&mss, &mss_sum);
+		}
+	}
+
+	release_task_mempolicy(priv);
+	up_read(&mm->mmap_sem);
+
+	seq_printf(m,
+		   "Rss:            %8lu kB\n"
+		   "Pss:            %8lu kB\n"
+		   "Shared_Clean:   %8lu kB\n"
+		   "Shared_Dirty:   %8lu kB\n"
+		   "Private_Clean:  %8lu kB\n"
+		   "Private_Dirty:  %8lu kB\n"
+		   "Referenced:     %8lu kB\n"
+		   "Anonymous:      %8lu kB\n"
+		   "AnonHugePages:  %8lu kB\n"
+		   "Swap:           %8lu kB\n",
+		   mss_sum.resident >> 10,
+		   (unsigned long)(mss_sum.pss >> (10 + PSS_SHIFT)),
+		   mss_sum.shared_clean  >> 10,
+		   mss_sum.shared_dirty  >> 10,
+		   mss_sum.private_clean >> 10,
+		   mss_sum.private_dirty >> 10,
+		   mss_sum.referenced >> 10,
+		   mss_sum.anonymous >> 10,
+		   mss_sum.anonymous_thp >> 10,
+		   mss_sum.swap >> 10);
+
+	return 0;
+}
+
 static int show_pid_smap(struct seq_file *m, void *v)
 {
 	return show_smap(m, v, 1);
@@ -812,6 +881,28 @@ static int show_tid_smap(struct seq_file *m, void *v)
 	return show_smap(m, v, 0);
 }
 
+static void *m_totmaps_start(struct seq_file *p, loff_t *pos)
+{
+	return NULL + (*pos == 0);
+}
+
+static void *m_totmaps_next(struct seq_file *p, void *v, loff_t *pos)
+{
+	++*pos;
+	return NULL;
+}
+
+static void m_totmaps_stop(struct seq_file *p, void *v)
+{
+}
+
+static const struct seq_operations proc_totmaps_op = {
+	.start	= m_totmaps_start,
+	.next	= m_totmaps_next,
+	.stop	= m_totmaps_stop,
+	.show	= totmaps_proc_show
+};
+
 static const struct seq_operations proc_pid_smaps_op = {
 	.start	= m_start,
 	.next	= m_next,
@@ -836,6 +927,37 @@ static int tid_smaps_open(struct inode *inode, struct file *file)
 	return do_maps_open(inode, file, &proc_tid_smaps_op);
 }
 
+static int totmaps_open(struct inode *inode, struct file *file)
+{
+	struct proc_maps_private *priv = NULL;
+	struct seq_file *seq;
+	int ret;
+
+	ret = do_maps_open(inode, file, &proc_totmaps_op);
+	if (ret)
+		goto error;
+
+	/*
+	 * We need to grab references to the task_struct
+	 * at open time, because there's a potential information
+	 * leak where the totmaps file is opened and held open
+	 * while the underlying pid to task mapping changes
+	 * underneath it
+	 */
+	seq = file->private_data;
+	priv = seq->private;
+	priv->task = get_proc_task(inode);
+	if (!priv->task) {
+		ret = -ESRCH;
+		goto error;
+	}
+
+	return 0;
+
+error:
+	return ret;
+}
+
 const struct file_operations proc_pid_smaps_operations = {
 	.open		= pid_smaps_open,
 	.read		= seq_read,
@@ -850,6 +972,13 @@ const struct file_operations proc_tid_smaps_operations = {
 	.release	= proc_map_release,
 };
 
+const struct file_operations proc_totmaps_operations = {
+	.open		= totmaps_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= proc_map_release,
+};
+
 enum clear_refs_types {
 	CLEAR_REFS_ALL = 1,
 	CLEAR_REFS_ANON,
-- 
2.7.4
