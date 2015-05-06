From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 14/19] y2038: use __kernel_timespec for sys_mq_timed{send,receive}
Date: Wed,  6 May 2015 18:30:21 +0200
Message-ID: <1430929826-318934-15-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, tglx@linutronix.de, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

This performs a complete conversion of the ipc/mqueue code to
use 64-bit time_t both internally and on the user-facing side
of 32-bit architectures that use CONFIG_COMPAT_TIME. For
compatibility with existing user space, these now use
compat_sys_mq_timed{send,receive}.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/audit.h    |  4 ++--
 include/linux/syscalls.h |  4 ++--
 ipc/mqueue.c             | 16 ++++++++--------
 kernel/audit.h           |  2 +-
 kernel/auditsc.c         | 14 +++++++-------
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index c2e7e3a83965..ab696322bb72 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -242,7 +242,7 @@ extern int __audit_socketcall(int nargs, unsigned long *args);
 extern int __audit_sockaddr(int len, void *addr);
 extern void __audit_fd_pair(int fd1, int fd2);
 extern void __audit_mq_open(int oflag, umode_t mode, struct mq_attr *attr);
-extern void __audit_mq_sendrecv(mqd_t mqdes, size_t msg_len, unsigned int msg_prio, const struct timespec *abs_timeout);
+extern void __audit_mq_sendrecv(mqd_t mqdes, size_t msg_len, unsigned int msg_prio, const struct timespec64 *abs_timeout);
 extern void __audit_mq_notify(mqd_t mqdes, const struct sigevent *notification);
 extern void __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat);
 extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
@@ -288,7 +288,7 @@ static inline void audit_mq_open(int oflag, umode_t mode, struct mq_attr *attr)
 	if (unlikely(!audit_dummy_context()))
 		__audit_mq_open(oflag, mode, attr);
 }
-static inline void audit_mq_sendrecv(mqd_t mqdes, size_t msg_len, unsigned int msg_prio, const struct timespec *abs_timeout)
+static inline void audit_mq_sendrecv(mqd_t mqdes, size_t msg_len, unsigned int msg_prio, const struct timespec64 *abs_timeout)
 {
 	if (unlikely(!audit_dummy_context()))
 		__audit_mq_sendrecv(mqdes, msg_len, msg_prio, abs_timeout);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index c2a70a8f907d..c3f15b5a9b79 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -675,8 +675,8 @@ asmlinkage long sys_ipc(unsigned int call, int first, unsigned long second,
 
 asmlinkage long sys_mq_open(const char __user *name, int oflag, umode_t mode, struct mq_attr __user *attr);
 asmlinkage long sys_mq_unlink(const char __user *name);
-asmlinkage long sys_mq_timedsend(mqd_t mqdes, const char __user *msg_ptr, size_t msg_len, unsigned int msg_prio, const struct timespec __user *abs_timeout);
-asmlinkage long sys_mq_timedreceive(mqd_t mqdes, char __user *msg_ptr, size_t msg_len, unsigned int __user *msg_prio, const struct timespec __user *abs_timeout);
+asmlinkage long sys_mq_timedsend(mqd_t mqdes, const char __user *msg_ptr, size_t msg_len, unsigned int msg_prio, const struct __kernel_timespec __user *abs_timeout);
+asmlinkage long sys_mq_timedreceive(mqd_t mqdes, char __user *msg_ptr, size_t msg_len, unsigned int __user *msg_prio, const struct __kernel_timespec __user *abs_timeout);
 asmlinkage long sys_mq_notify(mqd_t mqdes, const struct sigevent __user *notification);
 asmlinkage long sys_mq_getsetattr(mqd_t mqdes, const struct mq_attr __user *mqstat, struct mq_attr __user *omqstat);
 
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 3aaea7ffd077..f3f27ad1ca44 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -672,15 +672,15 @@ static void __do_notify(struct mqueue_inode_info *info)
 	wake_up(&info->wait_q);
 }
 
-static int prepare_timeout(const struct timespec __user *u_abs_timeout,
-			   ktime_t *expires, struct timespec *ts)
+static int prepare_timeout(const struct __kernel_timespec __user *u_abs_timeout,
+			   ktime_t *expires, struct timespec64 *ts)
 {
-	if (copy_from_user(ts, u_abs_timeout, sizeof(struct timespec)))
+	if (get_timespec64(ts, u_abs_timeout))
 		return -EFAULT;
 	if (!timespec_valid(ts))
 		return -EINVAL;
 
-	*expires = timespec_to_ktime(*ts);
+	*expires = timespec64_to_ktime(*ts);
 	return 0;
 }
 
@@ -953,7 +953,7 @@ static inline void pipelined_receive(struct mqueue_inode_info *info)
 
 SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 		size_t, msg_len, unsigned int, msg_prio,
-		const struct timespec __user *, u_abs_timeout)
+		const struct __kernel_timespec __user *, u_abs_timeout)
 {
 	struct fd f;
 	struct inode *inode;
@@ -962,7 +962,7 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 	struct msg_msg *msg_ptr;
 	struct mqueue_inode_info *info;
 	ktime_t expires, *timeout = NULL;
-	struct timespec ts;
+	struct timespec64 ts;
 	struct posix_msg_tree_node *new_leaf = NULL;
 	int ret = 0;
 
@@ -1073,7 +1073,7 @@ out:
 
 SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 		size_t, msg_len, unsigned int __user *, u_msg_prio,
-		const struct timespec __user *, u_abs_timeout)
+		const struct __kernel_timespec __user *, u_abs_timeout)
 {
 	ssize_t ret;
 	struct msg_msg *msg_ptr;
@@ -1082,7 +1082,7 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 	struct mqueue_inode_info *info;
 	struct ext_wait_queue wait;
 	ktime_t expires, *timeout = NULL;
-	struct timespec ts;
+	struct timespec64 ts;
 	struct posix_msg_tree_node *new_leaf = NULL;
 
 	if (u_abs_timeout) {
diff --git a/kernel/audit.h b/kernel/audit.h
index d641f9bb3ed0..b83e7aaca647 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -179,7 +179,7 @@ struct audit_context {
 			mqd_t			mqdes;
 			size_t			msg_len;
 			unsigned int		msg_prio;
-			struct timespec		abs_timeout;
+			struct timespec64	abs_timeout;
 		} mq_sendrecv;
 		struct {
 			int			oflag;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 9fb9d1cb83ce..6af873dcad55 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1230,12 +1230,12 @@ static void show_special(struct audit_context *context, int *call_panic)
 	case AUDIT_MQ_SENDRECV: {
 		audit_log_format(ab,
 			"mqdes=%d msg_len=%zd msg_prio=%u "
-			"abs_timeout_sec=%ld abs_timeout_nsec=%ld",
+			"abs_timeout_sec=%lld abs_timeout_nsec=%lld",
 			context->mq_sendrecv.mqdes,
 			context->mq_sendrecv.msg_len,
 			context->mq_sendrecv.msg_prio,
-			context->mq_sendrecv.abs_timeout.tv_sec,
-			context->mq_sendrecv.abs_timeout.tv_nsec);
+			(s64)context->mq_sendrecv.abs_timeout.tv_sec,
+			(s64)context->mq_sendrecv.abs_timeout.tv_nsec);
 		break; }
 	case AUDIT_MQ_NOTIFY: {
 		audit_log_format(ab, "mqdes=%d sigev_signo=%d",
@@ -2062,15 +2062,15 @@ void __audit_mq_open(int oflag, umode_t mode, struct mq_attr *attr)
  *
  */
 void __audit_mq_sendrecv(mqd_t mqdes, size_t msg_len, unsigned int msg_prio,
-			const struct timespec *abs_timeout)
+			const struct timespec64 *abs_timeout)
 {
 	struct audit_context *context = current->audit_context;
-	struct timespec *p = &context->mq_sendrecv.abs_timeout;
+	struct timespec64 *p = &context->mq_sendrecv.abs_timeout;
 
 	if (abs_timeout)
-		memcpy(p, abs_timeout, sizeof(struct timespec));
+		memcpy(p, abs_timeout, sizeof(struct timespec64));
 	else
-		memset(p, 0, sizeof(struct timespec));
+		memset(p, 0, sizeof(struct timespec64));
 
 	context->mq_sendrecv.mqdes = mqdes;
 	context->mq_sendrecv.msg_len = msg_len;
-- 
2.1.0.rc2
