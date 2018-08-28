From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH v5 4/5] seccomp: add support for passing fds via USER_NOTIF
Date: Tue, 28 Aug 2018 08:36:02 -0600
Message-ID: <20180828143603.8127-5-tycho@tycho.ws>
References: <20180828143603.8127-1-tycho@tycho.ws>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180828143603.8127-1-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

The idea here is that the userspace handler should be able to pass an fd
back to the trapped task, for example so it can be returned from socket().

I've proposed one API here, but I'm open to other options. In particular,
this only lets you return an fd from a syscall, which may not be enough in
all cases. For example, if an fd is written to an output parameter instead
of returned, the current API can't handle this. Another case is that
netlink takes as input fds sometimes (IFLA_NET_NS_FD, e.g.). If netlink
ever decides to install an fd and output it, we wouldn't be able to handle
this either.

Still, the vast majority of interesting cases are covered by this API, so
perhaps it is Enough.

I've left it as a separate commit for two reasons:
  * It illustrates the way in which we would grow struct seccomp_notif and
    struct seccomp_notif_resp without using netlink
  * It shows just how little code is needed to accomplish this :)

v2: new in v2
v3: no changes
v4: * pass fd flags back from userspace as well (Jann)
    * update same cgroup data on fd pass as SCM_RIGHTS (Alban)
    * only set the REPLIED state /after/ successful fdget (Alban)
    * reflect GET_LISTENER -> NEW_LISTENER changes
    * add to the new Documentation/ on user notifications about fd replies
v5: * fix documentation typo (O_EXCL -> O_CLOEXEC)

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
 .../userspace-api/seccomp_filter.rst          |  11 ++
 include/uapi/linux/seccomp.h                  |   3 +
 kernel/seccomp.c                              |  51 +++++++-
 tools/testing/selftests/seccomp/seccomp_bpf.c | 116 ++++++++++++++++++
 4 files changed, 179 insertions(+), 2 deletions(-)

diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
index 312472d8e9c5..668d93b425c1 100644
--- a/Documentation/userspace-api/seccomp_filter.rst
+++ b/Documentation/userspace-api/seccomp_filter.rst
@@ -233,6 +233,9 @@ The interface for a seccomp notification fd consists of two structures:
         __u64 id;
         __s32 error;
         __s64 val;
+        __u8 return_fd;
+        __u32 fd;
+        __u32 fd_flags;
     };
 
 Users can ``read()`` or ``poll()`` on a seccomp notification fd to receive a
@@ -252,6 +255,14 @@ mentioned above in this document: all arguments being read from the tracee's
 memory should be read into the tracer's memory before any policy decisions are
 made. This allows for an atomic decision on syscall arguments.
 
+Userspace can also return file descriptors. For example, one may decide to
+intercept ``socket()`` syscalls, and return some file descriptor from those
+based on some policy. To return a file descriptor, the ``return_fd`` member
+should be non-zero, the ``fd`` argument should be the fd in the listener's
+table to send to the tracee (similar to how ``SCM_RIGHTS`` works), and
+``fd_flags`` should be the flags that the fd in the tracee's table is opened
+with (e.g. ``O_CLOEXEC`` or similar).
+
 Sysctls
 =======
 
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index aa5878972128..93f1bd5c7cf0 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -75,6 +75,9 @@ struct seccomp_notif_resp {
 	__u64 id;
 	__s32 error;
 	__s64 val;
+	__u8 return_fd;
+	__u32 fd;
+	__u32 fd_flags;
 };
 
 #define SECCOMP_IOC_MAGIC		0xF7
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 580888785324..4a6db4076ec5 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -43,6 +43,7 @@
 
 #ifdef CONFIG_SECCOMP_USER_NOTIFICATION
 #include <linux/anon_inodes.h>
+#include <net/cls_cgroup.h>
 
 enum notify_state {
 	SECCOMP_NOTIFY_INIT,
@@ -80,6 +81,8 @@ struct seccomp_knotif {
 	/* The return values, only valid when in SECCOMP_NOTIFY_REPLIED */
 	int error;
 	long val;
+	struct file *file;
+	unsigned int flags;
 
 	/* Signals when this has entered SECCOMP_NOTIFY_REPLIED */
 	struct completion ready;
@@ -800,10 +803,44 @@ static void seccomp_do_user_notification(int this_syscall,
 			goto remove_list;
 	}
 
-	ret = n.val;
-	err = n.error;
+	if (n.file) {
+		int fd;
+		struct socket *sock;
+
+		fd = get_unused_fd_flags(n.flags);
+		if (fd < 0) {
+			err = fd;
+			ret = -1;
+			goto remove_list;
+		}
+
+		/*
+		 * Similar to what SCM_RIGHTS does, let's re-set the cgroup
+		 * data to point ot the tracee's cgroups instead of the
+		 * listener's.
+		 */
+		sock = sock_from_file(n.file, &err);
+		if (sock) {
+			sock_update_netprioidx(&sock->sk->sk_cgrp_data);
+			sock_update_classid(&sock->sk->sk_cgrp_data);
+		}
+
+		ret = fd;
+		err = 0;
+
+		fd_install(fd, n.file);
+		/* Don't fput, since fd has a reference now */
+		n.file = NULL;
+	} else {
+		ret = n.val;
+		err = n.error;
+	}
+
 
 remove_list:
+	if (n.file)
+		fput(n.file);
+
 	list_del(&n.list);
 out:
 	mutex_unlock(&match->notify_lock);
@@ -1675,10 +1712,20 @@ static long seccomp_notify_send(struct seccomp_filter *filter,
 		goto out;
 	}
 
+	if (resp.return_fd) {
+		knotif->flags = resp.fd_flags;
+		knotif->file = fget(resp.fd);
+		if (!knotif->file) {
+			ret = -EBADF;
+			goto out;
+		}
+	}
+
 	ret = size;
 	knotif->state = SECCOMP_NOTIFY_REPLIED;
 	knotif->error = resp.error;
 	knotif->val = resp.val;
+
 	complete(&knotif->ready);
 out:
 	mutex_unlock(&filter->notify_lock);
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 61b8e3c5c06b..c756722faa88 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -182,6 +182,9 @@ struct seccomp_notif_resp {
 	__u64 id;
 	__s32 error;
 	__s64 val;
+	__u8 return_fd;
+	__u32 fd;
+	__u32 fd_flags;
 };
 #endif
 
@@ -3233,6 +3236,119 @@ TEST(get_user_notification_ptrace)
 	close(listener);
 }
 
+TEST(user_notification_pass_fd)
+{
+	pid_t pid;
+	int status, listener;
+	int sk_pair[2];
+	char c;
+	struct seccomp_notif req = {};
+	struct seccomp_notif_resp resp = {};
+	long ret;
+
+	ASSERT_EQ(socketpair(PF_LOCAL, SOCK_SEQPACKET, 0, sk_pair), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		int fd;
+		char buf[16];
+
+		EXPECT_EQ(user_trap_syscall(__NR_getpid, 0), 0);
+
+		/* Signal we're ready and have installed the filter. */
+		EXPECT_EQ(write(sk_pair[1], "J", 1), 1);
+
+		EXPECT_EQ(read(sk_pair[1], &c, 1), 1);
+		EXPECT_EQ(c, 'H');
+		close(sk_pair[1]);
+
+		/* An fd from getpid(). Let the games begin. */
+		fd = syscall(__NR_getpid);
+		EXPECT_GT(fd, 0);
+		EXPECT_EQ(read(fd, buf, sizeof(buf)), 12);
+		close(fd);
+
+		exit(strcmp("hello world", buf));
+	}
+
+	EXPECT_EQ(read(sk_pair[0], &c, 1), 1);
+	EXPECT_EQ(c, 'J');
+
+	EXPECT_EQ(ptrace(PTRACE_ATTACH, pid), 0);
+	EXPECT_EQ(waitpid(pid, NULL, 0), pid);
+	listener = ptrace(PTRACE_SECCOMP_NEW_LISTENER, pid, 0);
+	EXPECT_GE(listener, 0);
+	EXPECT_EQ(ptrace(PTRACE_DETACH, pid, NULL, 0), 0);
+
+	/* Now signal we are done installing so it can do a getpid */
+	EXPECT_EQ(write(sk_pair[0], "H", 1), 1);
+	close(sk_pair[0]);
+
+	/* Make a new socket pair so we can send half across */
+	EXPECT_EQ(socketpair(PF_LOCAL, SOCK_SEQPACKET, 0, sk_pair), 0);
+
+	ret = read_notif(listener, &req);
+	EXPECT_EQ(ret, sizeof(req));
+	EXPECT_EQ(errno, 0);
+
+	resp.len = sizeof(resp);
+	resp.id = req.id;
+	resp.return_fd = 1;
+	resp.fd = sk_pair[1];
+	resp.fd_flags = 0;
+	EXPECT_EQ(ioctl(listener, SECCOMP_NOTIF_SEND, &resp), sizeof(resp));
+	close(sk_pair[1]);
+
+	EXPECT_EQ(write(sk_pair[0], "hello world\0", 12), 12);
+	close(sk_pair[0]);
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+	close(listener);
+}
+
+TEST(user_notification_struct_size_mismatch)
+{
+	pid_t pid;
+	long ret;
+	int status, listener, len;
+	struct seccomp_notif req;
+	struct seccomp_notif_resp resp;
+
+	listener = user_trap_syscall(__NR_getpid,
+				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	EXPECT_GE(listener, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		ret = syscall(__NR_getpid);
+		exit(ret != USER_NOTIF_MAGIC);
+	}
+
+	req.len = sizeof(req);
+	EXPECT_EQ(ioctl(listener, SECCOMP_NOTIF_RECV, &req), sizeof(req));
+
+	/*
+	 * Only write a partial structure: this is what was available before we
+	 * had fd support.
+	 */
+	len = offsetof(struct seccomp_notif_resp, val) + sizeof(resp.val);
+	resp.len = len;
+	resp.id = req.id;
+	resp.error = 0;
+	resp.val = USER_NOTIF_MAGIC;
+	EXPECT_EQ(ioctl(listener, SECCOMP_NOTIF_SEND, &resp), len);
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
 /*
  * Check that a pid in a child namespace still shows up as valid in ours.
  */
-- 
2.17.1
