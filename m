From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 26/26] pidns: Ensure zap_pid_ns_processes always terminates
Date: Tue,  6 Jun 2017 14:03:38 -0500
Message-ID: <20170606190338.28347-26-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606190338.28347-1-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

The function zap_pid_processes terminates when the number of pids used
by processes in a pid namespace drops to just those pids used by the
last thread of the dying thread.

Don't allow an init process aka a child_reaper to call
setpgid(0, some_other_processes_pid).  That case is already broken today
as it would result in a pid namespace that will hang when the thread group
leader dies.  Thankfully I have not received that bug report so it
appears that no one cares and uses that case.

Limiting setpgid ensures that the only two pids in the pid namespace
on the init process that are worth worrying about are the pid and the
tgid.  The pgrp will now either match the tgid or it will be from
outside the pid namespace.  Likewise the sid will either match the
tgid or be from outside the pid namespace.

To make it clear what is being counted test if the task's tgid is the same
as the the task's pid.  In particular the code does not count the
number of processes in a pid namespace, just the number of pids those
processes use.  A subtle but important distinction for understanding
the code.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/pid_namespace.c | 2 +-
 kernel/sys.c           | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 74a5a7255b4d..bdda73768cc0 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -208,7 +208,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	int nr;
 	int rc;
 	struct task_struct *task, *me = current;
-	int init_pids = thread_group_leader(me) ? 1 : 2;
+	int init_pids = task_pid(me) != task_tgid(me) ? 2 : 1;
 
 	/* Don't allow any more processes into the pid namespace */
 	disable_pid_allocation(pid_ns);
diff --git a/kernel/sys.c b/kernel/sys.c
index 705f14b28134..775dea1e2e06 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -975,7 +975,8 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 
 		pgrp = find_vpid(pgid);
 		g = pid_task(pgrp, PIDTYPE_PGID);
-		if (!g || task_session(g) != task_session(group_leader))
+		if (!g || task_session(g) != task_session(group_leader) ||
+		    is_child_reaper(task_tgid(p)))
 			goto out;
 	}
 
-- 
2.10.1
