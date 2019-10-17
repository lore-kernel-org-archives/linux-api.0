From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v3 3/5] pid: use pid_has_task() in __change_pid()
Date: Thu, 17 Oct 2019 12:18:30 +0200
Message-ID: <20191017101832.5985-3-christian.brauner@ubuntu.com>
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
idiomatic, easier to grep for, and unifies how callers perform this
check.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
/* pidfd selftests */
passed

/* v1 */
patch not present

/* v2 */
Link: https://lore.kernel.org/r/20191016153606.2326-3-christian.brauner@ubuntu.com
patch introduced

/* v2 */
- Oleg Nesterov <oleg@redhat.com>:
  - s/task_alive/pid_has_task/g
---
 kernel/pid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 0a9f2e437217..124d40b239b1 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -299,7 +299,7 @@ static void __change_pid(struct task_struct *task, enum pid_type type,
 	*pid_ptr = new;
 
 	for (tmp = PIDTYPE_MAX; --tmp >= 0; )
-		if (!hlist_empty(&pid->tasks[tmp]))
+		if (pid_has_task(pid, tmp))
 			return;
 
 	free_pid(pid);
-- 
2.23.0
