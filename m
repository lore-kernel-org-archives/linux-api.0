From: =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
Subject: [PATCH] prctl: add PR_{GET,SET}_KILL_DESCENDANTS_ON_EXIT
Date: Tue, 27 Nov 2018 22:54:08 +0000
Message-ID: <20181127225408.7553-2-j@bitron.ch>
References: <20181127225408.7553-1-j@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181127225408.7553-1-j@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
List-Id: linux-api@vger.kernel.org

This introduces a new thread group flag that can be set by calling

    prctl(PR_SET_KILL_DESCENDANTS_ON_EXIT, 1, 0, 0, 0)

When a thread group exits with this flag set, it will send SIGKILL to
all descendant processes.  This can be used to prevent stray child
processes.

This flag is cleared on privilege gaining execve(2) to ensure an
unprivileged process cannot get a privileged process to send SIGKILL.

Descendants that are orphaned and reparented to an ancestor of the
current process before the current process exits, will not be killed.
PR_SET_CHILD_SUBREAPER can be used to contain orphaned processes.

If a descendant gained privileges, the current process may not be
allowed to kill it, and the descendant process will survive.
PR_SET_NO_NEW_PRIVS can be used to prevent descendant processes from
gaining privileges.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jürg Billeter <j@bitron.ch>
---
 fs/exec.c                    |  6 ++++++
 include/linux/sched/signal.h |  3 +++
 include/uapi/linux/prctl.h   |  4 ++++
 kernel/exit.c                | 12 ++++++++++++
 kernel/sys.c                 | 11 +++++++++++
 security/apparmor/lsm.c      |  1 +
 security/selinux/hooks.c     |  3 +++
 7 files changed, 40 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 1ebf6e5a521d..f48ff4333393 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1339,6 +1339,12 @@ void setup_new_exec(struct linux_binprm * bprm)
 		/* Make sure parent cannot signal privileged process. */
 		current->pdeath_signal = 0;
 
+		/*
+		 * Do not send SIGKILL from privileged process as it may
+		 * have been requested by an unprivileged process.
+		 */
+		current->signal->kill_descendants_on_exit = 0;
+
 		/*
 		 * For secureexec, reset the stack limit to sane default to
 		 * avoid bad behavior from the prior rlimits. This has to
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 1be35729c2c5..3bfb71701488 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -124,6 +124,9 @@ struct signal_struct {
 	unsigned int		is_child_subreaper:1;
 	unsigned int		has_child_subreaper:1;
 
+	/* Send SIGKILL to descendant processes on exit */
+	unsigned int		kill_descendants_on_exit:1;
+
 #ifdef CONFIG_POSIX_TIMERS
 
 	/* POSIX.1b Interval Timers */
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index c0d7ea0bf5b6..2ac4da1f282b 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -198,6 +198,10 @@ struct prctl_mm_map {
 # define PR_CAP_AMBIENT_LOWER		3
 # define PR_CAP_AMBIENT_CLEAR_ALL	4
 
+/* Send SIGKILL to descendant processes on exit */
+#define PR_SET_KILL_DESCENDANTS_ON_EXIT	48
+#define PR_GET_KILL_DESCENDANTS_ON_EXIT	49
+
 /* arm64 Scalable Vector Extension controls */
 /* Flag values must be kept in sync with ptrace NT_ARM_SVE interface */
 #define PR_SVE_SET_VL			50	/* set task vector length */
diff --git a/kernel/exit.c b/kernel/exit.c
index 0e21e6d21f35..7fe0c694685a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -694,6 +694,15 @@ static void forget_original_parent(struct task_struct *father,
 	list_splice_tail_init(&father->children, &reaper->children);
 }
 
+static int kill_descendant_visitor(struct task_struct *p, void *data)
+{
+	/* This may fail, e.g., when a descendant process gained privileges. */
+	group_send_sig_info(SIGKILL, SEND_SIG_NOINFO, p, PIDTYPE_TGID);
+
+	/* Always continue walking the process tree. */
+	return 1;
+}
+
 /*
  * Send signals to all our closest relatives so that they know
  * to properly mourn us..
@@ -704,6 +713,9 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	struct task_struct *p, *n;
 	LIST_HEAD(dead);
 
+	if (group_dead && tsk->signal->kill_descendants_on_exit)
+		walk_process_tree(tsk, kill_descendant_visitor, NULL);
+
 	write_lock_irq(&tasklist_lock);
 	forget_original_parent(tsk, &dead);
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 123bd73046ec..8d9af81da093 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2476,6 +2476,17 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			return -EINVAL;
 		error = arch_prctl_spec_ctrl_set(me, arg2, arg3);
 		break;
+	case PR_SET_KILL_DESCENDANTS_ON_EXIT:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		me->signal->kill_descendants_on_exit = !!arg2;
+		break;
+	case PR_GET_KILL_DESCENDANTS_ON_EXIT:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = put_user(me->signal->kill_descendants_on_exit,
+				 (int __user *)arg2);
+		break;
 	default:
 		error = -EINVAL;
 		break;
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 8b8b70620bbe..d0d8f88130fb 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -695,6 +695,7 @@ static void apparmor_bprm_committing_creds(struct linux_binprm *bprm)
 	aa_inherit_files(bprm->cred, current->files);
 
 	current->pdeath_signal = 0;
+	current->signal->kill_descendants_on_exit = 0;
 
 	/* reset soft limits and set hard limits for the new label */
 	__aa_transition_rlimits(label, new_label);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ad9a9b8e9979..313a7be43a98 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2653,6 +2653,9 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 	/* Always clear parent death signal on SID transitions. */
 	current->pdeath_signal = 0;
 
+	/* Disable SIGKILL requested from before the SID transition. */
+	current->signal->kill_descendants_on_exit = 0;
+
 	/* Check whether the new SID can inherit resource limits from the old
 	 * SID.  If not, reset all soft limits to the lower of the current
 	 * task's hard limit and the init task's soft limit.
-- 
2.19.2
