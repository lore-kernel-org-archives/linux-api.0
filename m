From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 21/26] wait: Optmize waitpid
Date: Tue,  6 Jun 2017 14:03:33 -0500
Message-ID: <20170606190338.28347-21-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606190338.28347-1-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Now that which list a task is found on does not matter there is no
reason to walk the child lists for waitpid when task_pid can directly
find the child.

Add a new helper do_wait_pid that finds the target task via pid_task
and verifies it is on one of the lists for the thread we are
reaping.

This is more efficient in two ways.  It skips the list traversal
so uninteresting tasks don't slow things down.  It guarantees
a task will only be visited once if p->parent == p->real_parent.

Except for the increase in efficiency this results in no user
visible behavioral differences.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/exit.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index c783d5fb5ab3..2f01b75e3b2e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1438,6 +1438,18 @@ static int ptrace_do_wait(struct wait_opts *wo, struct task_struct *tsk)
 	return 0;
 }
 
+static int do_wait_pid(struct wait_opts *wo, struct task_struct *tsk)
+{
+	struct task_struct *p = pid_task(wo->wo_pid, wo->wo_type);
+
+	/* Not on one of this tasks child lists? */
+	if ((tsk != p->parent) &&
+	    ((tsk != p->real_parent) || !thread_group_leader(p)))
+		return 0;
+
+	return wait_consider_task(wo, p);
+}
+
 static int child_wait_callback(wait_queue_t *wait, unsigned mode,
 				int sync, void *key)
 {
@@ -1486,11 +1498,15 @@ static long do_wait(struct wait_opts *wo)
 	read_lock(&tasklist_lock);
 	tsk = current;
 	do {
-		retval = do_wait_thread(wo, tsk);
-		if (retval)
-			goto end;
+		if (wo->wo_type == PIDTYPE_PID) {
+			retval = do_wait_pid(wo, tsk);
+		} else {
+			retval = do_wait_thread(wo, tsk);
+			if (retval)
+				goto end;
 
-		retval = ptrace_do_wait(wo, tsk);
+			retval = ptrace_do_wait(wo, tsk);
+		}
 		if (retval)
 			goto end;
 
-- 
2.10.1
