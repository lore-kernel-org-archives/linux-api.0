From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH v7 3/6] seccomp: add a way to get a listener fd from ptrace
Date: Thu, 27 Sep 2018 09:11:16 -0600
Message-ID: <20180927151119.9989-4-tycho@tycho.ws>
References: <20180927151119.9989-1-tycho@tycho.ws>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927151119.9989-1-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>, linux-fsdevel@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

As an alternative to SECCOMP_FILTER_FLAG_GET_LISTENER, perhaps a ptrace()
version which can acquire filters is useful. There are at least two reasons
this is preferable, even though it uses ptrace:

1. You can control tasks that aren't cooperating with you
2. You can control tasks whose filters block sendmsg() and socket(); if the
   task installs a filter which blocks these calls, there's no way with
   SECCOMP_FILTER_FLAG_GET_LISTENER to get the fd out to the privileged task.

v2: fix a bug where listener mode was not unset when an unused fd was not
    available
v3: fix refcounting bug (Oleg)
v4: * change the listener's fd flags to be 0
    * rename GET_LISTENER to NEW_LISTENER (Matthew)
v5: * add capable(CAP_SYS_ADMIN) requirement
v7: * point the new listener at the right filter (Jann)

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
CC: Kees Cook <keescook@chromium.org>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Eric W. Biederman <ebiederm@xmission.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>
CC: Christian Brauner <christian.brauner@ubuntu.com>
CC: Tyler Hicks <tyhicks@canonical.com>
CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
---
 include/linux/seccomp.h                       |  7 ++
 include/uapi/linux/ptrace.h                   |  2 +
 kernel/ptrace.c                               |  4 ++
 kernel/seccomp.c                              | 31 +++++++++
 tools/testing/selftests/seccomp/seccomp_bpf.c | 68 +++++++++++++++++++
 5 files changed, 112 insertions(+)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 017444b5efed..234c61b37405 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -83,6 +83,8 @@ static inline int seccomp_mode(struct seccomp *s)
 #ifdef CONFIG_SECCOMP_FILTER
 extern void put_seccomp_filter(struct task_struct *tsk);
 extern void get_seccomp_filter(struct task_struct *tsk);
+extern long seccomp_new_listener(struct task_struct *task,
+				 unsigned long filter_off);
 #else  /* CONFIG_SECCOMP_FILTER */
 static inline void put_seccomp_filter(struct task_struct *tsk)
 {
@@ -92,6 +94,11 @@ static inline void get_seccomp_filter(struct task_struct *tsk)
 {
 	return;
 }
+static inline long seccomp_new_listener(struct task_struct *task,
+					unsigned long filter_off)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_SECCOMP_FILTER */
 
 #if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index d5a1b8a492b9..e80ecb1bd427 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -73,6 +73,8 @@ struct seccomp_metadata {
 	__u64 flags;		/* Output: filter's flags */
 };
 
+#define PTRACE_SECCOMP_NEW_LISTENER	0x420e
+
 /* Read signals from a shared (process wide) queue */
 #define PTRACE_PEEKSIGINFO_SHARED	(1 << 0)
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 21fec73d45d4..289960ac181b 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1096,6 +1096,10 @@ int ptrace_request(struct task_struct *child, long request,
 		ret = seccomp_get_metadata(child, addr, datavp);
 		break;
 
+	case PTRACE_SECCOMP_NEW_LISTENER:
+		ret = seccomp_new_listener(child, addr);
+		break;
+
 	default:
 		break;
 	}
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 44a31ac8373a..17685803a2af 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1777,4 +1777,35 @@ static struct file *init_listener(struct task_struct *task,
 
 	return ret;
 }
+
+long seccomp_new_listener(struct task_struct *task,
+			  unsigned long filter_off)
+{
+	struct seccomp_filter *filter;
+	struct file *listener;
+	int fd;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	filter = get_nth_filter(task, filter_off);
+	if (IS_ERR(filter))
+		return PTR_ERR(filter);
+
+	fd = get_unused_fd_flags(0);
+	if (fd < 0) {
+		__put_seccomp_filter(filter);
+		return fd;
+	}
+
+	listener = init_listener(task, filter);
+	__put_seccomp_filter(filter);
+	if (IS_ERR(listener)) {
+		put_unused_fd(fd);
+		return PTR_ERR(listener);
+	}
+
+	fd_install(fd, listener);
+	return fd;
+}
 #endif
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 5f4b836a6792..c6ba3ed5392e 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -193,6 +193,10 @@ int seccomp(unsigned int op, unsigned int flags, void *args)
 }
 #endif
 
+#ifndef PTRACE_SECCOMP_NEW_LISTENER
+#define PTRACE_SECCOMP_NEW_LISTENER 0x420e
+#endif
+
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 #define syscall_arg(_n) (offsetof(struct seccomp_data, args[_n]))
 #elif __BYTE_ORDER == __BIG_ENDIAN
@@ -3175,6 +3179,70 @@ TEST(get_user_notification_syscall)
 	EXPECT_EQ(0, WEXITSTATUS(status));
 }
 
+TEST(get_user_notification_ptrace)
+{
+	pid_t pid;
+	int status, listener;
+	int sk_pair[2];
+	char c;
+	struct seccomp_notif req = {};
+	struct seccomp_notif_resp resp = {};
+
+	ASSERT_EQ(socketpair(PF_LOCAL, SOCK_SEQPACKET, 0, sk_pair), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		EXPECT_EQ(user_trap_syscall(__NR_getpid, 0), 0);
+
+		/* Test that we get ENOSYS while not attached */
+		EXPECT_EQ(syscall(__NR_getpid), -1);
+		EXPECT_EQ(errno, ENOSYS);
+
+		/* Signal we're ready and have installed the filter. */
+		EXPECT_EQ(write(sk_pair[1], "J", 1), 1);
+
+		EXPECT_EQ(read(sk_pair[1], &c, 1), 1);
+		EXPECT_EQ(c, 'H');
+
+		exit(syscall(__NR_getpid) != USER_NOTIF_MAGIC);
+	}
+
+	EXPECT_EQ(read(sk_pair[0], &c, 1), 1);
+	EXPECT_EQ(c, 'J');
+
+	EXPECT_EQ(ptrace(PTRACE_ATTACH, pid), 0);
+	EXPECT_EQ(waitpid(pid, NULL, 0), pid);
+	listener = ptrace(PTRACE_SECCOMP_NEW_LISTENER, pid, 0);
+	EXPECT_GE(listener, 0);
+
+	/* EBUSY for second listener */
+	EXPECT_EQ(ptrace(PTRACE_SECCOMP_NEW_LISTENER, pid, 0), -1);
+	EXPECT_EQ(errno, EBUSY);
+
+	EXPECT_EQ(ptrace(PTRACE_DETACH, pid, NULL, 0), 0);
+
+	/* Now signal we are done and respond with magic */
+	EXPECT_EQ(write(sk_pair[0], "H", 1), 1);
+
+	req.len = sizeof(req);
+	EXPECT_EQ(ioctl(listener, SECCOMP_NOTIF_RECV, &req), sizeof(req));
+
+	resp.len = sizeof(resp);
+	resp.id = req.id;
+	resp.error = 0;
+	resp.val = USER_NOTIF_MAGIC;
+
+	EXPECT_EQ(ioctl(listener, SECCOMP_NOTIF_SEND, &resp), sizeof(resp));
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+
+	close(listener);
+}
+
 /*
  * Check that a pid in a child namespace still shows up as valid in ours.
  */
-- 
2.17.1
