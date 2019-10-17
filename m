From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v3 5/5] pid: use pid_has_task() in pidfd_open()
Date: Thu, 17 Oct 2019 12:18:32 +0200
Message-ID: <20191017101832.5985-5-christian.brauner@ubuntu.com>
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

Use the new pid_has_task() helper in pidfd_open(). This simplifies the
code and avoids taking rcu_read_{lock,unlock}() and leads to overall
nicer code.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
/* pidfd selftests */
passed

/* v1 */
patch not present

/* v2 */
Link: https://lore.kernel.org/r/20191016153606.2326-5-christian.brauner@ubuntu.com
patch introduced

/* v3 */
- Oleg Nesterov <oleg@redhat.com>:
  - s/task_alive/pid_has_task/
---
 kernel/pid.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 124d40b239b1..7b5f6c963d72 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -497,7 +497,7 @@ static int pidfd_create(struct pid *pid)
  */
 SYSCALL_DEFINE2(pidfd_open, pid_t, pid, unsigned int, flags)
 {
-	int fd, ret;
+	int fd;
 	struct pid *p;
 
 	if (flags)
@@ -510,13 +510,11 @@ SYSCALL_DEFINE2(pidfd_open, pid_t, pid, unsigned int, flags)
 	if (!p)
 		return -ESRCH;
 
-	ret = 0;
-	rcu_read_lock();
-	if (!pid_task(p, PIDTYPE_TGID))
-		ret = -EINVAL;
-	rcu_read_unlock();
+	if (pid_has_task(p, PIDTYPE_TGID))
+		fd = pidfd_create(p);
+	else
+		fd = -EINVAL;
 
-	fd = ret ?: pidfd_create(p);
 	put_pid(p);
 	return fd;
 }
-- 
2.23.0
