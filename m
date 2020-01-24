From: Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH 3/4] seccomp: Add SECCOMP_USER_NOTIF_FLAG_PIDFD to get pidfd on listener trap
Date: Fri, 24 Jan 2020 01:17:42 -0800
Message-ID: <20200124091743.3357-4-sargun@sargun.me>
References: <20200124091743.3357-1-sargun@sargun.me>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200124091743.3357-1-sargun@sargun.me>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Sargun Dhillon <sargun@sargun.me>, tycho@tycho.ws, christian.brauner@ubuntu.com
List-Id: linux-api@vger.kernel.org

This introduces the capability for users of seccomp's listener behaviour
to be able to receive the pidfd of the process that triggered the event.
Currently, this just opens the group leader of the thread that triggere
the event, as pidfds (currently) are limited to group leaders.

For actions which do not act on the process outside of the pidfd, there
is then no need to check the cookie to ensure validity of the request
throughout the listener's handling of it.

This can be extended later on as well when pidfd capabilities are added
to be able to have the listener imbue the pidfd with certain capabilities
when it is delivered to userspace.

It is the responsibility of the user to close the pidfd.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 include/uapi/linux/seccomp.h |  4 +++
 kernel/seccomp.c             | 68 ++++++++++++++++++++++++++++++++----
 2 files changed, 66 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index be84d87f1f46..64f6fc5c95f1 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -69,11 +69,15 @@ struct seccomp_notif_sizes {
 	__u16 seccomp_data;
 };
 
+/* Valid flags for struct seccomp_notif */
+#define SECCOMP_USER_NOTIF_FLAG_PIDFD	(1UL << 0) /* populate pidfd */
+
 struct seccomp_notif {
 	__u64 id;
 	__u32 pid;
 	__u32 flags;
 	struct seccomp_data data;
+	__u32 pidfd;
 };
 
 /*
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index b6ea3dcb57bf..93f9cf45ce07 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1019,21 +1019,61 @@ static int seccomp_notify_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+
+static long __seccomp_notify_recv_pidfd(void __user *buf,
+					struct seccomp_notif *unotif,
+					struct task_struct *group_leader)
+{
+	struct file *pidfd_file;
+	struct pid *pid;
+	int fd;
+
+	pid = get_task_pid(group_leader, PIDTYPE_PID);
+	pidfd_file = pidfd_create_file(pid);
+	put_pid(pid);
+	if (IS_ERR(pidfd_file))
+		return PTR_ERR(pidfd_file);
+
+	fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+	if (fd < 0) {
+		fput(pidfd_file);
+		return fd;
+	}
+
+	unotif->pidfd = fd;
+
+	if (copy_to_user(buf, unotif, sizeof(*unotif))) {
+		put_unused_fd(fd);
+		fput(pidfd_file);
+		return -EFAULT;
+	}
+
+	fd_install(fd, pidfd_file);
+
+	return 0;
+}
+
 static long seccomp_notify_recv(struct seccomp_filter *filter,
 				void __user *buf)
 {
 	struct seccomp_knotif *knotif = NULL, *cur;
 	struct seccomp_notif unotif;
+	struct task_struct *group_leader;
+	bool send_pidfd;
 	ssize_t ret;
 
+	if (copy_from_user(&unotif, buf, sizeof(unotif)))
+		return -EFAULT;
 	/* Verify that we're not given garbage to keep struct extensible. */
-	ret = check_zeroed_user(buf, sizeof(unotif));
-	if (ret < 0)
-		return ret;
-	if (!ret)
+	if (unotif.id ||
+	    unotif.pid ||
+	    memchr_inv(&unotif.data, 0, sizeof(unotif.data)) ||
+	    unotif.pidfd)
+		return -EINVAL;
+	if (unotif.flags & ~(SECCOMP_USER_NOTIF_FLAG_PIDFD))
 		return -EINVAL;
 
-	memset(&unotif, 0, sizeof(unotif));
+	send_pidfd = unotif.flags & SECCOMP_USER_NOTIF_FLAG_PIDFD;
 
 	ret = down_interruptible(&filter->notif->request);
 	if (ret < 0)
@@ -1057,9 +1097,13 @@ static long seccomp_notify_recv(struct seccomp_filter *filter,
 		goto out;
 	}
 
+	memset(&unotif, 0, sizeof(unotif));
+
 	unotif.id = knotif->id;
 	unotif.pid = task_pid_vnr(knotif->task);
 	unotif.data = *(knotif->data);
+	if (send_pidfd)
+		group_leader = get_task_struct(knotif->task->group_leader);
 
 	knotif->state = SECCOMP_NOTIFY_SENT;
 	wake_up_poll(&filter->notif->wqh, EPOLLOUT | EPOLLWRNORM);
@@ -1067,9 +1111,21 @@ static long seccomp_notify_recv(struct seccomp_filter *filter,
 out:
 	mutex_unlock(&filter->notify_lock);
 
-	if (ret == 0 && copy_to_user(buf, &unotif, sizeof(unotif))) {
+	if (ret)
+		return ret;
+
+	/*
+	 * We've successfully received a notification, let's try to copy it to
+	 * userspace.
+	 */
+	if (send_pidfd) {
+		ret = __seccomp_notify_recv_pidfd(buf, &unotif, group_leader);
+		put_task_struct(group_leader);
+	} else if (copy_to_user(buf, &unotif, sizeof(unotif))) {
 		ret = -EFAULT;
+	}
 
+	if (ret) {
 		/*
 		 * Userspace screwed up. To make sure that we keep this
 		 * notification alive, let's reset it back to INIT. It
-- 
2.20.1
