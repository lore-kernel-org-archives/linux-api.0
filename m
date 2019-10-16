From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v2 5/5] pid: use task_alive() in pidfd_open()
Date: Wed, 16 Oct 2019 17:36:06 +0200
Message-ID: <20191016153606.2326-5-christian.brauner@ubuntu.com>
References: <20191015141332.4055-1-christian.brauner@ubuntu.com>
 <20191016153606.2326-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191016153606.2326-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: oleg@redhat.com, linux-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org, christian@kellner.me, cyphar@cyphar.com, elena.reshetova@intel.com, guro@fb.com, jannh@google.com, ldv@altlinux.org, linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org, mhocko@suse.com, mingo@kernel.org, peterz@infradead.org, shuah@kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Use the new task_alive() helper in pidfd_open(). This simplifies the
code and avoids taking rcu_read_{lock,unlock}() and leads to overall
nicer code.

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v1 */
patch not present

/* v2 */
patch introduced
---
 kernel/pid.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 70ad4a9f728c..1f425b6c4c47 100644
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
+	if (task_alive(p, PIDTYPE_TGID))
+		fd = pidfd_create(p);
+	else
+		fd = -EINVAL;
 
-	fd = ret ?: pidfd_create(p);
 	put_pid(p);
 	return fd;
 }
-- 
2.23.0
