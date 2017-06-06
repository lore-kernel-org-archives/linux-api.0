From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 10/26] ptrace: Simplify ptrace_detach & exit_ptrace
Date: Tue,  6 Jun 2017 14:03:22 -0500
Message-ID: <20170606190338.28347-10-ebiederm@xmission.com>
References: <877f0pym71.fsf@xmission.com>
 <20170606190338.28347-1-ebiederm@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606190338.28347-1-ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, Roland McGrath <roland@hack.frob.com>, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

Call __ptrace_unlink not __ptrace_detach.  As it is guaranteed that
ptrace_detach will never be called on a process that has or may exit.

Rename __ptrace_detach __exit_ptrace as exit_ptrace is now it's only
caller and the corrected name is less confusing.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/ptrace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 266ddcc1d8bb..490333db9e21 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -495,7 +495,7 @@ static int ignoring_children(struct sighand_struct *sigh)
  * reap it now, in that case we must also wake up sub-threads sleeping in
  * do_wait().
  */
-static bool __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
+static bool __exit_ptrace(struct task_struct *tracer, struct task_struct *p)
 {
 	bool dead;
 
@@ -539,7 +539,7 @@ static int ptrace_detach(struct task_struct *child, unsigned int data)
 	 * the comment in ptrace_resume().
 	 */
 	child->exit_code = data;
-	__ptrace_detach(current, child);
+	__ptrace_unlink(child);
 	write_unlock_irq(&tasklist_lock);
 
 	proc_ptrace_connector(child, PTRACE_DETACH);
@@ -559,7 +559,7 @@ void exit_ptrace(struct task_struct *tracer, struct list_head *dead)
 		if (unlikely(p->ptrace & PT_EXITKILL))
 			send_sig_info(SIGKILL, SEND_SIG_FORCED, p);
 
-		if (__ptrace_detach(tracer, p))
+		if (__exit_ptrace(tracer, p))
 			list_add(&p->ptrace_entry, dead);
 	}
 }
-- 
2.10.1
