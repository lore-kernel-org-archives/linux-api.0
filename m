From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC v2 5/6] proc: instantiate only pids that we can ptrace on 'limit_pids=1' mount option
Date: Tue, 25 Apr 2017 14:23:57 +0200
Message-ID: <1493123038-30590-6-git-send-email-tixxdz@gmail.com>
References: <1493123038-30590-1-git-send-email-tixxdz@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493123038-30590-1-git-send-email-tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

If "limit_pids=1" mount option is set then do not instantiate pids that
we can not ptrace. "limit_pids=1" means that procfs should only contain
pids that the caller can ptrace.

Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/proc/base.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2e0f661..a663284 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3149,6 +3149,7 @@ struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsign
 	unsigned tgid;
 	struct proc_fs_info *fs_info = proc_sb(dir->i_sb);
 	struct pid_namespace *ns = fs_info->pid_ns;
+	int limit_pids = proc_fs_limit_pids(fs_info);
 
 	tgid = name_to_int(&dentry->d_name);
 	if (tgid == ~0U)
@@ -3162,7 +3163,15 @@ struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsign
 	if (!task)
 		goto out;
 
+	/* Limit procfs to only ptracable tasks */
+	if (limit_pids == PROC_LIMIT_PIDS_PTRACE) {
+		cond_resched();
+		if (!has_pid_permissions(fs_info, task, HIDEPID_NO_ACCESS))
+			goto out_put_task;
+	}
+
 	result = proc_pid_instantiate(dir, dentry, task, NULL);
+out_put_task:
 	put_task_struct(task);
 out:
 	return ERR_PTR(result);
-- 
2.10.2
