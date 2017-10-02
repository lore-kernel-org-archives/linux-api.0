From: akpm@linux-foundation.org
Subject: + prctl-add-pr_et_pdeathsig_proc.patch added to -mm tree
Date: Mon, 02 Oct 2017 16:20:55 -0700
Message-ID: <59d2c9d7.KoQqdLG+B0tDhGXl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
To: j@bitron.ch, alphaetapi@hotmail.com, davidvsthegiant@gmail.com, ebiederm@xmission.com, filbranden@google.com, hansecke@gmail.com, linux-api@vger.kernel.org, mtk.manpages@gmail.com, oleg@redhat.com, mm-commits@vger.kernel.org
List-Id: linux-api@vger.kernel.org


The patch titled
     From: Jürg Billeter <j@bitron.ch>
has been added to the -mm tree.  Its filename is
     prctl-add-pr_et_pdeathsig_proc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/prctl-add-pr_et_pdeathsig_proc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/prctl-add-pr_et_pdeathsig_proc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jürg Billeter <j@bitron.ch>
Subject: prctl: add PR_[GS]ET_PDEATHSIG_PROC

PR_SET_PDEATHSIG sets a parent death signal that the calling process will
get when its parent thread dies, even when the result of getppid() doesn't
change because the calling process is reparented to a different thread in
the same parent process.  When managing multiple processes, a
process-based parent death signal is much more useful.  E.g., to avoid
stray child processes.

PR_SET_PDEATHSIG_PROC sets a process-based death signal.  Unlike
PR_SET_PDEATHSIG, this is inherited across fork to allow killing a whole
subtree without race conditions.

This can be used for sandboxing when combined with a seccomp filter.

There have been previous attempts to support this by changing the behavior
of PR_SET_PDEATHSIG.  However, that would break existing applications. 
See https://marc.info/?l=linux-kernel&m=117621804801689 and
https://bugzilla.kernel.org/show_bug.cgi?id=43300

Link: http://lkml.kernel.org/r/20170929123058.48924-1-j@bitron.ch
Signed-off-by: Jürg Billeter <j@bitron.ch>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Filipe Brandenburger <filbranden@google.com>
Cc: David Wilcox <davidvsthegiant@gmail.com>
Cc: "Adam H . Peterson" <alphaetapi@hotmail.com>
Cc: <hansecke@gmail.com>
Cc: <linux-api@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                    |    1 +
 include/linux/sched/signal.h |    3 +++
 include/uapi/linux/prctl.h   |    4 ++++
 kernel/cred.c                |    1 +
 kernel/exit.c                |    4 ++++
 kernel/fork.c                |    2 ++
 kernel/sys.c                 |   11 +++++++++++
 security/apparmor/lsm.c      |    1 +
 security/selinux/hooks.c     |    1 +
 9 files changed, 28 insertions(+)

diff -puN fs/exec.c~prctl-add-pr_et_pdeathsig_proc fs/exec.c
--- a/fs/exec.c~prctl-add-pr_et_pdeathsig_proc
+++ a/fs/exec.c
@@ -1334,6 +1334,7 @@ void setup_new_exec(struct linux_binprm
 	if (bprm->secureexec) {
 		/* Make sure parent cannot signal privileged process. */
 		current->pdeath_signal = 0;
+		current->signal->pdeath_signal_proc = 0;
 
 		/*
 		 * For secureexec, reset the stack limit to sane default to
diff -puN include/linux/sched/signal.h~prctl-add-pr_et_pdeathsig_proc include/linux/sched/signal.h
--- a/include/linux/sched/signal.h~prctl-add-pr_et_pdeathsig_proc
+++ a/include/linux/sched/signal.h
@@ -103,6 +103,9 @@ struct signal_struct {
 	int			group_stop_count;
 	unsigned int		flags; /* see SIGNAL_* flags below */
 
+	/* The signal sent when the parent dies: */
+	int			pdeath_signal_proc;
+
 	/*
 	 * PR_SET_CHILD_SUBREAPER marks a process, like a service
 	 * manager, to re-parent orphan (double-forking) child processes
diff -puN include/uapi/linux/prctl.h~prctl-add-pr_et_pdeathsig_proc include/uapi/linux/prctl.h
--- a/include/uapi/linux/prctl.h~prctl-add-pr_et_pdeathsig_proc
+++ a/include/uapi/linux/prctl.h
@@ -197,4 +197,8 @@ struct prctl_mm_map {
 # define PR_CAP_AMBIENT_LOWER		3
 # define PR_CAP_AMBIENT_CLEAR_ALL	4
 
+/* Process-based variant of PDEATHSIG */
+#define PR_SET_PDEATHSIG_PROC		48
+#define PR_GET_PDEATHSIG_PROC		49
+
 #endif /* _LINUX_PRCTL_H */
diff -puN kernel/cred.c~prctl-add-pr_et_pdeathsig_proc kernel/cred.c
--- a/kernel/cred.c~prctl-add-pr_et_pdeathsig_proc
+++ a/kernel/cred.c
@@ -448,6 +448,7 @@ int commit_creds(struct cred *new)
 		if (task->mm)
 			set_dumpable(task->mm, suid_dumpable);
 		task->pdeath_signal = 0;
+		task->signal->pdeath_signal_proc = 0;
 		smp_wmb();
 	}
 
diff -puN kernel/exit.c~prctl-add-pr_et_pdeathsig_proc kernel/exit.c
--- a/kernel/exit.c~prctl-add-pr_et_pdeathsig_proc
+++ a/kernel/exit.c
@@ -635,6 +635,10 @@ static void reparent_leader(struct task_
 	if (unlikely(p->exit_state == EXIT_DEAD))
 		return;
 
+	if (p->signal->pdeath_signal_proc)
+		group_send_sig_info(p->signal->pdeath_signal_proc,
+				    SEND_SIG_NOINFO, p);
+
 	/* We don't want people slaying init. */
 	p->exit_signal = SIGCHLD;
 
diff -puN kernel/fork.c~prctl-add-pr_et_pdeathsig_proc kernel/fork.c
--- a/kernel/fork.c~prctl-add-pr_et_pdeathsig_proc
+++ a/kernel/fork.c
@@ -1433,6 +1433,8 @@ static int copy_signal(unsigned long clo
 
 	mutex_init(&sig->cred_guard_mutex);
 
+	sig->pdeath_signal_proc = current->signal->pdeath_signal_proc;
+
 	return 0;
 }
 
diff -puN kernel/sys.c~prctl-add-pr_et_pdeathsig_proc kernel/sys.c
--- a/kernel/sys.c~prctl-add-pr_et_pdeathsig_proc
+++ a/kernel/sys.c
@@ -2206,6 +2206,17 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 	case PR_GET_PDEATHSIG:
 		error = put_user(me->pdeath_signal, (int __user *)arg2);
 		break;
+	case PR_SET_PDEATHSIG_PROC:
+		if (!valid_signal(arg2)) {
+			error = -EINVAL;
+			break;
+		}
+		me->signal->pdeath_signal_proc = arg2;
+		break;
+	case PR_GET_PDEATHSIG_PROC:
+		error = put_user(me->signal->pdeath_signal_proc,
+				 (int __user *)arg2);
+		break;
 	case PR_GET_DUMPABLE:
 		error = get_dumpable(me->mm);
 		break;
diff -puN security/apparmor/lsm.c~prctl-add-pr_et_pdeathsig_proc security/apparmor/lsm.c
--- a/security/apparmor/lsm.c~prctl-add-pr_et_pdeathsig_proc
+++ a/security/apparmor/lsm.c
@@ -689,6 +689,7 @@ static void apparmor_bprm_committing_cre
 	aa_inherit_files(bprm->cred, current->files);
 
 	current->pdeath_signal = 0;
+	current->signal->pdeath_signal_proc = 0;
 
 	/* reset soft limits and set hard limits for the new label */
 	__aa_transition_rlimits(label, new_ctx->label);
diff -puN security/selinux/hooks.c~prctl-add-pr_et_pdeathsig_proc security/selinux/hooks.c
--- a/security/selinux/hooks.c~prctl-add-pr_et_pdeathsig_proc
+++ a/security/selinux/hooks.c
@@ -2547,6 +2547,7 @@ static void selinux_bprm_committing_cred
 
 	/* Always clear parent death signal on SID transitions. */
 	current->pdeath_signal = 0;
+	current->signal->pdeath_signal_proc = 0;
 
 	/* Check whether the new SID can inherit resource limits from the old
 	 * SID.  If not, reset all soft limits to the lower of the current
_

Patches currently in -mm which might be from j@bitron.ch are

prctl-add-pr_et_pdeathsig_proc.patch

