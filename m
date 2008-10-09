From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] proc: remove kernel.maps_protect sysctl
Date: Fri, 10 Oct 2008 03:34:06 +0400
Message-ID: <20081009233406.GA17625@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kees.cook-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

	[added to proc.git]

commit b8f3039ba6e44e04f5eca64435c4c6a61e2db59f
Author: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Fri Oct 10 03:27:16 2008 +0400

    proc: remove kernel.maps_protect
    
    After commit 831830b5a2b5d413407adf380ef62fe17d6fcbf2 aka
    "restrict reading from /proc/<pid>/maps to those who share ->mm or can ptrace"
    sysctl stopped being relevant because commit moved security checks from ->show
    time to ->start time (mm_for_maps()).
    
    Signed-off-by: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Acked-by: Kees Cook <kees.cook-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index f566ad9..63ed861 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1332,13 +1332,6 @@ determine whether or not they are still functioning properly.
 Because the NMI watchdog shares registers with oprofile, by disabling the NMI
 watchdog, oprofile may have more registers to utilize.
 
-maps_protect
-------------
-
-Enables/Disables the protection of the per-process proc entries "maps" and
-"smaps".  When enabled, the contents of these files are visible only to
-readers that are allowed to ptrace() the given process.
-
 msgmni
 ------
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index c1332dd..b5918ae 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -148,9 +148,6 @@ static unsigned int pid_entry_count_dirs(const struct pid_entry *entries,
 	return count;
 }
 
-int maps_protect;
-EXPORT_SYMBOL(maps_protect);
-
 static struct fs_struct *get_fs_struct(struct task_struct *task)
 {
 	struct fs_struct *fs;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 32e7c28..9413e78 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -45,8 +45,6 @@ do {						\
 extern int nommu_vma_show(struct seq_file *, struct vm_area_struct *);
 #endif
 
-extern int maps_protect;
-
 extern int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
 extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 73d1891..4806830 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -210,9 +210,6 @@ static int show_map(struct seq_file *m, void *v)
 	dev_t dev = 0;
 	int len;
 
-	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
-
 	if (file) {
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
@@ -742,22 +739,11 @@ const struct file_operations proc_pagemap_operations = {
 #ifdef CONFIG_NUMA
 extern int show_numa_map(struct seq_file *m, void *v);
 
-static int show_numa_map_checked(struct seq_file *m, void *v)
-{
-	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
-
-	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
-
-	return show_numa_map(m, v);
-}
-
 static const struct seq_operations proc_pid_numa_maps_op = {
         .start  = m_start,
         .next   = m_next,
         .stop   = m_stop,
-        .show   = show_numa_map_checked
+        .show   = show_numa_map,
 };
 
 static int numa_maps_open(struct inode *inode, struct file *file)
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 5d84e71..219bd79 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -110,11 +110,6 @@ int task_statm(struct mm_struct *mm, int *shared, int *text,
 static int show_map(struct seq_file *m, void *_vml)
 {
 	struct vm_list_struct *vml = _vml;
-	struct proc_maps_private *priv = m->private;
-	struct task_struct *task = priv->task;
-
-	if (maps_protect && !ptrace_may_access(task, PTRACE_MODE_READ))
-		return -EACCES;
 
 	return nommu_vma_show(m, vml->vma);
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 50ec088..cc3e0d7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -80,7 +80,6 @@ extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
-extern int maps_protect;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifdef CONFIG_RCU_TORTURE_TEST
@@ -810,16 +809,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_PROC_FS
-	{
-		.ctl_name       = CTL_UNNUMBERED,
-		.procname       = "maps_protect",
-		.data           = &maps_protect,
-		.maxlen         = sizeof(int),
-		.mode           = 0644,
-		.proc_handler   = &proc_dointvec,
-	},
-#endif
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "poweroff_cmd",
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
