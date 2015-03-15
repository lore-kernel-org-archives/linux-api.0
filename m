From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH v2 5/7] clone4: Add a CLONE_AUTOREAP flag to automatically
 reap the child process
Date: Sun, 15 Mar 2015 01:00:02 -0700
Message-ID: <6d002995485d446e659105f6931307f3e532ce89.1426376419.git.josh@joshtriplett.org>
References: <cover.1426376419.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1426376419.git.josh@joshtriplett.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Thiago Macieira <thiago.macieira@intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

If a process launches a child process with the notification signal set
to SIGCHLD (e.g. with fork()), and then the parent process either
ignores SIGCHLD or sets a handler with SA_NOCLDWAIT, the child process
will get automatically reaped without waiting for the parent to wait on
it.

However, there's currently no way to get the same autoreaping behavior
if the signal is not set to SIGCHLD, including in particular if the
signal is set to 0 to disable notification.  Furthermore, the code
launching the child process may not own process-wide signal handling for
the parent process.

Add a CLONE_AUTOREAP flag to request this behavior unconditionally,
regardless of the notification signal or the state of the parent
process's signal handling when the process exits.

This is particularly useful for libraries that want to launch unattended
child processes without interfering with the calling process's signal
handling or wait loop.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Thiago Macieira <thiago.macieira@intel.com>
---
 include/linux/sched.h      | 2 ++
 include/uapi/linux/sched.h | 7 ++++++-
 kernel/fork.c              | 2 ++
 kernel/signal.c            | 2 ++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9ec36fd..66feeb7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1372,6 +1372,8 @@ struct task_struct {
 	unsigned memcg_kmem_skip_account:1;
 #endif
 
+	unsigned autoreap:1; /* Do not become a zombie on exit */
+
 	unsigned long atomic_flags; /* Flags needing atomic access. */
 
 	struct restart_block restart_block;
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 7656152..f606c0a 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -37,13 +37,18 @@
 #define CLONE_DETACHED	0x00400000
 #define CLONE_STOPPED	0x02000000
 
+/*
+ * Flags that only work with clone4.
+ */
+#define CLONE_AUTOREAP	0x00001000	/* Automatically reap the process */
+
 #ifdef __KERNEL__
 /*
  * Valid flags for clone and for clone4. Kept in this file next to the flag
  * list above, but not exposed to userspace.
  */
 #define CLONE_VALID_FLAGS	(0xffffffffULL & ~(CLONE_PID | CLONE_DETACHED | CLONE_STOPPED))
-#define CLONE4_VALID_FLAGS	CLONE_VALID_FLAGS
+#define CLONE4_VALID_FLAGS	(CLONE_VALID_FLAGS | CLONE_AUTOREAP)
 #endif /* __KERNEL__ */
 
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index db9012a..c297e5e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1461,6 +1461,8 @@ static struct task_struct *copy_process(u64 clone_flags,
 		p->tgid = p->pid;
 	}
 
+	p->autoreap = !!(clone_flags & CLONE_AUTOREAP);
+
 	p->nr_dirtied = 0;
 	p->nr_dirtied_pause = 128 >> (PAGE_SHIFT - 10);
 	p->dirty_paused_when = 0;
diff --git a/kernel/signal.c b/kernel/signal.c
index a390499..c0011c0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1702,6 +1702,8 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 		if (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN)
 			sig = 0;
 	}
+	if (!tsk->ptrace && tsk->autoreap)
+		autoreap = true;
 	if (valid_signal(sig) && sig)
 		__group_send_sig_info(sig, &info, tsk->parent);
 	__wake_up_parent(tsk, tsk->parent);
-- 
2.1.4

