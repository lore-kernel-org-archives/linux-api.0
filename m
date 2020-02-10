From: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v8 06/11] proc: support mounting procfs instances inside same pid namespace
Date: Mon, 10 Feb 2020 16:05:14 +0100
Message-ID: <20200210150519.538333-7-gladkov.alexey@gmail.com>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200210150519.538333-1-gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Security Module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Dmitry V . Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J . Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Solar Designer <solar-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch allows to have multiple procfs instances inside the
same pid namespace. The aim here is lightweight sandboxes, and to allow
that we have to modernize procfs internals.

1) The main aim of this work is to have on embedded systems one
supervisor for apps. Right now we have some lightweight sandbox support,
however if we create pid namespacess we have to manages all the
processes inside too, where our goal is to be able to run a bunch of
apps each one inside its own mount namespace without being able to
notice each other. We only want to use mount namespaces, and we want
procfs to behave more like a real mount point.

2) Linux Security Modules have multiple ptrace paths inside some
subsystems, however inside procfs, the implementation does not guarantee
that the ptrace() check which triggers the security_ptrace_check() hook
will always run. We have the 'hidepid' mount option that can be used to
force the ptrace_may_access() check inside has_pid_permissions() to run.
The problem is that 'hidepid' is per pid namespace and not attached to
the mount point, any remount or modification of 'hidepid' will propagate
to all other procfs mounts.

This also does not allow to support Yama LSM easily in desktop and user
sessions. Yama ptrace scope which restricts ptrace and some other
syscalls to be allowed only on inferiors, can be updated to have a
per-task context, where the context will be inherited during fork(),
clone() and preserved across execve(). If we support multiple private
procfs instances, then we may force the ptrace_may_access() on
/proc/<pids>/ to always run inside that new procfs instances. This will
allow to specifiy on user sessions if we should populate procfs with
pids that the user can ptrace or not.

By using Yama ptrace scope, some restricted users will only be able to see
inferiors inside /proc, they won't even be able to see their other
processes. Some software like Chromium, Firefox's crash handler, Wine
and others are already using Yama to restrict which processes can be
ptracable. With this change this will give the possibility to restrict
/proc/<pids>/ but more importantly this will give desktop users a
generic and usuable way to specifiy which users should see all processes
and which users can not.

Side notes:
* This covers the lack of seccomp where it is not able to parse
arguments, it is easy to install a seccomp filter on direct syscalls
that operate on pids, however /proc/<pid>/ is a Linux ABI using
filesystem syscalls. With this change LSMs should be able to analyze
open/read/write/close...

In the new patchset version I removed the 'newinstance' option
as Eric W. Biederman suggested.

Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/proc/root.c | 41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index efd76c004e86..5d5cba4c899b 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -82,7 +82,7 @@ static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	return 0;
 }
 
-static void proc_apply_options(struct super_block *s,
+static void proc_apply_options(struct proc_fs_info *fs_info,
 			       struct fs_context *fc,
 			       struct pid_namespace *pid_ns,
 			       struct user_namespace *user_ns)
@@ -90,15 +90,17 @@ static void proc_apply_options(struct super_block *s,
 	struct proc_fs_context *ctx = fc->fs_private;
 
 	if (pid_ns->proc_mnt) {
-		struct proc_fs_info *fs_info = proc_sb_info(pid_ns->proc_mnt->mnt_sb);
-		proc_fs_set_pid_gid(ctx->fs_info, proc_fs_pid_gid(fs_info));
-		proc_fs_set_hide_pid(ctx->fs_info, proc_fs_hide_pid(fs_info));
+		struct proc_fs_info *pidns_fs_info = proc_sb_info(pid_ns->proc_mnt->mnt_sb);
+
+		proc_fs_set_pid_gid(fs_info, proc_fs_pid_gid(pidns_fs_info));
+		proc_fs_set_hide_pid(fs_info, proc_fs_hide_pid(pidns_fs_info));
 	}
 
 	if (ctx->mask & (1 << Opt_gid))
-		proc_fs_set_pid_gid(ctx->fs_info, make_kgid(user_ns, ctx->gid));
+		proc_fs_set_pid_gid(fs_info, make_kgid(user_ns, ctx->gid));
+
 	if (ctx->mask & (1 << Opt_hidepid))
-		proc_fs_set_hide_pid(ctx->fs_info, ctx->hidepid);
+		proc_fs_set_hide_pid(fs_info, ctx->hidepid);
 }
 
 static int proc_fill_super(struct super_block *s, struct fs_context *fc)
@@ -108,7 +110,7 @@ static int proc_fill_super(struct super_block *s, struct fs_context *fc)
 	struct inode *root_inode;
 	int ret;
 
-	proc_apply_options(s, fc, pid_ns, current_user_ns());
+	proc_apply_options(ctx->fs_info, fc, pid_ns, current_user_ns());
 
 	/* User space would break if executables or devices appear on proc */
 	s->s_iflags |= SB_I_USERNS_VISIBLE | SB_I_NOEXEC | SB_I_NODEV;
@@ -118,6 +120,7 @@ static int proc_fill_super(struct super_block *s, struct fs_context *fc)
 	s->s_magic = PROC_SUPER_MAGIC;
 	s->s_op = &proc_sops;
 	s->s_time_gran = 1;
+	s->s_fs_info = ctx->fs_info;
 
 	/*
 	 * procfs isn't actually a stacking filesystem; however, there is
@@ -157,15 +160,13 @@ static int proc_reconfigure(struct fs_context *fc)
 
 	sync_filesystem(sb);
 
-	proc_apply_options(sb, fc, pid, current_user_ns());
+	proc_apply_options(fs_info, fc, pid, current_user_ns());
 	return 0;
 }
 
 static int proc_get_tree(struct fs_context *fc)
 {
-	struct proc_fs_context *ctx = fc->fs_private;
-
-	return get_tree_keyed(fc, proc_fill_super, ctx->fs_info);
+	return get_tree_nodev(fc, proc_fill_super);
 }
 
 static void proc_fs_context_free(struct fs_context *fc)
@@ -186,25 +187,19 @@ static const struct fs_context_operations proc_fs_context_ops = {
 static int proc_init_fs_context(struct fs_context *fc)
 {
 	struct proc_fs_context *ctx;
-	struct pid_namespace *pid_ns;
 
 	ctx = kzalloc(sizeof(struct proc_fs_context), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-	pid_ns = get_pid_ns(task_active_pid_ns(current));
-
-	if (!pid_ns->proc_mnt) {
-		ctx->fs_info = kzalloc(sizeof(struct proc_fs_info), GFP_KERNEL);
-		if (!ctx->fs_info) {
-			kfree(ctx);
-			return -ENOMEM;
-		}
-		ctx->fs_info->pid_ns = pid_ns;
-	} else {
-		ctx->fs_info = proc_sb_info(pid_ns->proc_mnt->mnt_sb);
+	ctx->fs_info = kzalloc(sizeof(struct proc_fs_info), GFP_KERNEL);
+	if (!ctx->fs_info) {
+		kfree(ctx);
+		return -ENOMEM;
 	}
 
+	ctx->fs_info->pid_ns = get_pid_ns(task_active_pid_ns(current));
+
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(ctx->fs_info->pid_ns->user_ns);
 	fc->fs_private = ctx;
-- 
2.24.1
