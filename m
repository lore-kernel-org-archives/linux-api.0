From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: [PATCH v5 5/7] proc: instantiate only pids that we can ptrace on
 'limit_pids=1' mount option
Date: Fri, 11 May 2018 11:36:14 +0200
Message-ID: <20180511093613.GA1330@comp-core-i7-2640m-0182e6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, aniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Stephen Rothwell <sfr@canb.auug.org.au>, solar@openwall.com, "Dmitry V. Levin" <ldv@altlinux.org>, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

From: Djalal Harouni <tixxdz@gmail.com>

If "limit_pids=1" mount option is set then do not instantiate pids that
we can not ptrace. "limit_pids=1" means that procfs should only contain
pids that the caller can ptrace.

Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 fs/proc/base.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6f084344..31baeef 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3187,6 +3187,7 @@ struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsign
 	unsigned tgid;
 	struct proc_fs_info *fs_info = proc_sb(dir->i_sb);
 	struct pid_namespace *ns = fs_info->pid_ns;
+	int limit_pids = proc_fs_limit_pids(fs_info);
 
 	tgid = name_to_int(&dentry->d_name);
 	if (tgid == ~0U)
@@ -3200,7 +3201,15 @@ struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, unsign
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
2.10.5
