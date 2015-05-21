From: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [RFC] fs, proc: don't guard /proc/<pid>/task/<tid>/children on CONFIG_CHECKPOINT_RESTORE
Date: Thu, 21 May 2015 12:30:21 +0200
Message-ID: <1432204221-1933-1-git-send-email-alban@endocode.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>, Iago Lopez Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>

commit 818411616baf ("fs, proc: introduce
/proc/<pid>/task/<tid>/children entry") introduced the children entry
for checkpoint restore and the file is only available on kernels
configured with CONFIG_EXPERT and CONFIG_CHECKPOINT_RESTORE.

This is available in most distributions (Fedora, Debian, Ubuntu, CoreOS)
because they usually enable CONFIG_EXPERT and CONFIG_CHECKPOINT_RESTORE.
But Arch does not enable CONFIG_EXPERT or CONFIG_CHECKPOINT_RESTORE.

However, the children proc file is useful outside of checkpoint restore.
I would like to use it in rkt. The rkt process exec() another program it
does not control, and that other program will fork()+exec() a child
process. I would like to find the pid of the child process from an
external tool without iterating in /proc over all processes to find
which one has a parent pid equal to rkt.

Since the children proc file is useful outside of checkpoint-restore,
I am removing the guard on CONFIG_CHECKPOINT_RESTORE.

Signed-off-by: Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
Cc: Iago Lopez Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
---
 fs/proc/array.c | 2 --
 fs/proc/base.c  | 2 --
 2 files changed, 4 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index fd02a9e..6edec57 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -569,7 +569,6 @@ int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 	return 0;
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
 static struct pid *
 get_children_pid(struct inode *inode, struct pid *pid_prev, loff_t pos)
 {
@@ -692,4 +691,3 @@ const struct file_operations proc_tid_children_operations = {
 	.llseek  = seq_lseek,
 	.release = children_seq_release,
 };
-#endif /* CONFIG_CHECKPOINT_RESTORE */
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 093ca14..b743007 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2922,9 +2922,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_tid_maps_operations),
-#ifdef CONFIG_CHECKPOINT_RESTORE
 	REG("children",  S_IRUGO, proc_tid_children_operations),
-#endif
 #ifdef CONFIG_NUMA
 	REG("numa_maps", S_IRUGO, proc_tid_numa_maps_operations),
 #endif
-- 
2.1.4
