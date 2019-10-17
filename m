From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v3 4/5] exit: use pid_has_task() in do_wait()
Date: Thu, 17 Oct 2019 12:18:31 +0200
Message-ID: <20191017101832.5985-4-christian.brauner@ubuntu.com>
References: <20191016153606.2326-1-christian.brauner@ubuntu.com>
 <20191017101832.5985-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191017101832.5985-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: oleg@redhat.com, linux-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org, christian@kellner.me, cyphar@cyphar.com, elena.reshetova@intel.com, guro@fb.com, jannh@google.com, ldv@altlinux.org, linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org, mhocko@suse.com, mingo@kernel.org, peterz@infradead.org, shuah@kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Replace hlist_empty() with the new pid_has_task() helper which is more
idiomatic, easier to grep for, and unifies how callers perform this check.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
/* pidfd selftests */
passed

/* v1 */
patch not present

/* v2 */
Link: https://lore.kernel.org/r/20191016153606.2326-4-christian.brauner@ubuntu.com
patch introduced

/* v3 */
- Oleg Nesterov <oleg@redhat.com>:
  - s/task_alive/pid_has_task/
---
 kernel/exit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index a46a50d67002..f2d20ab74422 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1457,7 +1457,7 @@ static long do_wait(struct wait_opts *wo)
 	 */
 	wo->notask_error = -ECHILD;
 	if ((wo->wo_type < PIDTYPE_MAX) &&
-	   (!wo->wo_pid || hlist_empty(&wo->wo_pid->tasks[wo->wo_type])))
+	   (!wo->wo_pid || !pid_has_task(wo->wo_pid, wo->wo_type)))
 		goto notask;
 
 	set_current_state(TASK_INTERRUPTIBLE);
-- 
2.23.0
