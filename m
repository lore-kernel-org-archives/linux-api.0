From: Sargun Dhillon <sargun@sargun.me>
Subject: [PATCH v4 3/5] samples: split generalized user-trap code into helper
 file
Date: Wed, 18 Dec 2019 23:55:11 +0000
Message-ID: <20191218235508.GA17277@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: tycho@tycho.ws, jannh@google.com, cyphar@cyphar.com, christian.brauner@ubuntu.com, oleg@redhat.com, luto@amacapital.net, viro@zeniv.linux.org.uk, gpascutto@mozilla.com, ealvarez@mozilla.com, fweimer@redhat.com, jld@mozilla.com, arnd@arndb.de
List-Id: linux-api@vger.kernel.org

This moves the code for setting up a syscall interceptor with user
notification and sending the user notification file descriptor over a
socket using SCM_RIGHTS into a file that can be shared between multiple
samples.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 samples/seccomp/Makefile           |  6 ++-
 samples/seccomp/user-trap-helper.c | 84 +++++++++++++++++++++++++++++
 samples/seccomp/user-trap-helper.h | 13 +++++
 samples/seccomp/user-trap.c        | 85 +-----------------------------
 4 files changed, 103 insertions(+), 85 deletions(-)
 create mode 100644 samples/seccomp/user-trap-helper.c
 create mode 100644 samples/seccomp/user-trap-helper.h

diff --git a/samples/seccomp/Makefile b/samples/seccomp/Makefile
index 009775b52538..82b7347318d1 100644
--- a/samples/seccomp/Makefile
+++ b/samples/seccomp/Makefile
@@ -16,9 +16,13 @@ HOSTCFLAGS_bpf-direct.o += -I$(objtree)/usr/include
 HOSTCFLAGS_bpf-direct.o += -idirafter $(objtree)/include
 bpf-direct-objs := bpf-direct.o
 
+
+HOSTCFLAGS_user-trap-helper.o += -I$(objtree)/usr/include
+HOSTCFLAGS_user-trap-helper.o += -idirafter $(objtree)/include
+
 HOSTCFLAGS_user-trap.o += -I$(objtree)/usr/include
 HOSTCFLAGS_user-trap.o += -idirafter $(objtree)/include
-user-trap-objs := user-trap.o
+user-trap-objs := user-trap.o user-trap-helper.o
 
 # Try to match the kernel target.
 ifndef CONFIG_64BIT
diff --git a/samples/seccomp/user-trap-helper.c b/samples/seccomp/user-trap-helper.c
new file mode 100644
index 000000000000..f91ae9d947c5
--- /dev/null
+++ b/samples/seccomp/user-trap-helper.c
@@ -0,0 +1,84 @@
+#include <linux/seccomp.h>
+#include <linux/filter.h>
+#include <unistd.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stddef.h>
+#include <sys/types.h>
+#include <sys/syscall.h>
+#include <sys/socket.h>
+#include "user-trap-helper.h"
+
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
+
+int user_trap_syscall(int nr, unsigned int flags)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD+BPF_W+BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, nr, 0, 1),
+		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_USER_NOTIF),
+		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
+	};
+
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+
+	return seccomp(SECCOMP_SET_MODE_FILTER, flags, &prog);
+}
+
+int send_fd(int sock, int fd)
+{
+	struct msghdr msg = {};
+	struct cmsghdr *cmsg;
+	char buf[CMSG_SPACE(sizeof(int))] = {0}, c = 'c';
+	struct iovec io = {
+		.iov_base = &c,
+		.iov_len = 1,
+	};
+
+	msg.msg_iov = &io;
+	msg.msg_iovlen = 1;
+	msg.msg_control = buf;
+	msg.msg_controllen = sizeof(buf);
+	cmsg = CMSG_FIRSTHDR(&msg);
+	cmsg->cmsg_level = SOL_SOCKET;
+	cmsg->cmsg_type = SCM_RIGHTS;
+	cmsg->cmsg_len = CMSG_LEN(sizeof(int));
+	*((int *)CMSG_DATA(cmsg)) = fd;
+	msg.msg_controllen = cmsg->cmsg_len;
+
+	if (sendmsg(sock, &msg, 0) < 0) {
+		perror("sendmsg");
+		return -1;
+	}
+
+	return 0;
+}
+
+int recv_fd(int sock)
+{
+	struct msghdr msg = {};
+	struct cmsghdr *cmsg;
+	char buf[CMSG_SPACE(sizeof(int))] = {0}, c = 'c';
+	struct iovec io = {
+		.iov_base = &c,
+		.iov_len = 1,
+	};
+
+	msg.msg_iov = &io;
+	msg.msg_iovlen = 1;
+	msg.msg_control = buf;
+	msg.msg_controllen = sizeof(buf);
+
+	if (recvmsg(sock, &msg, 0) < 0) {
+		perror("recvmsg");
+		return -1;
+	}
+
+	cmsg = CMSG_FIRSTHDR(&msg);
+
+	return *((int *)CMSG_DATA(cmsg));
+}
diff --git a/samples/seccomp/user-trap-helper.h b/samples/seccomp/user-trap-helper.h
new file mode 100644
index 000000000000..a5ebda25fdfe
--- /dev/null
+++ b/samples/seccomp/user-trap-helper.h
@@ -0,0 +1,13 @@
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <errno.h>
+
+static inline int seccomp(unsigned int op, unsigned int flags, void *args)
+{
+	errno = 0;
+	return syscall(__NR_seccomp, op, flags, args);
+}
+
+int user_trap_syscall(int nr, unsigned int flags);
+int send_fd(int sock, int fd);
+int recv_fd(int sock);
diff --git a/samples/seccomp/user-trap.c b/samples/seccomp/user-trap.c
index 6d0125ca8af7..1b6526587456 100644
--- a/samples/seccomp/user-trap.c
+++ b/samples/seccomp/user-trap.c
@@ -5,101 +5,18 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <string.h>
-#include <stddef.h>
 #include <sys/sysmacros.h>
 #include <sys/types.h>
 #include <sys/wait.h>
 #include <sys/socket.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
-#include <sys/syscall.h>
 #include <sys/user.h>
 #include <sys/ioctl.h>
-#include <sys/ptrace.h>
 #include <sys/mount.h>
 #include <linux/limits.h>
-#include <linux/filter.h>
 #include <linux/seccomp.h>
-
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
-
-static int seccomp(unsigned int op, unsigned int flags, void *args)
-{
-	errno = 0;
-	return syscall(__NR_seccomp, op, flags, args);
-}
-
-static int send_fd(int sock, int fd)
-{
-	struct msghdr msg = {};
-	struct cmsghdr *cmsg;
-	char buf[CMSG_SPACE(sizeof(int))] = {0}, c = 'c';
-	struct iovec io = {
-		.iov_base = &c,
-		.iov_len = 1,
-	};
-
-	msg.msg_iov = &io;
-	msg.msg_iovlen = 1;
-	msg.msg_control = buf;
-	msg.msg_controllen = sizeof(buf);
-	cmsg = CMSG_FIRSTHDR(&msg);
-	cmsg->cmsg_level = SOL_SOCKET;
-	cmsg->cmsg_type = SCM_RIGHTS;
-	cmsg->cmsg_len = CMSG_LEN(sizeof(int));
-	*((int *)CMSG_DATA(cmsg)) = fd;
-	msg.msg_controllen = cmsg->cmsg_len;
-
-	if (sendmsg(sock, &msg, 0) < 0) {
-		perror("sendmsg");
-		return -1;
-	}
-
-	return 0;
-}
-
-static int recv_fd(int sock)
-{
-	struct msghdr msg = {};
-	struct cmsghdr *cmsg;
-	char buf[CMSG_SPACE(sizeof(int))] = {0}, c = 'c';
-	struct iovec io = {
-		.iov_base = &c,
-		.iov_len = 1,
-	};
-
-	msg.msg_iov = &io;
-	msg.msg_iovlen = 1;
-	msg.msg_control = buf;
-	msg.msg_controllen = sizeof(buf);
-
-	if (recvmsg(sock, &msg, 0) < 0) {
-		perror("recvmsg");
-		return -1;
-	}
-
-	cmsg = CMSG_FIRSTHDR(&msg);
-
-	return *((int *)CMSG_DATA(cmsg));
-}
-
-static int user_trap_syscall(int nr, unsigned int flags)
-{
-	struct sock_filter filter[] = {
-		BPF_STMT(BPF_LD+BPF_W+BPF_ABS,
-			offsetof(struct seccomp_data, nr)),
-		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, nr, 0, 1),
-		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_USER_NOTIF),
-		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
-	};
-
-	struct sock_fprog prog = {
-		.len = (unsigned short)ARRAY_SIZE(filter),
-		.filter = filter,
-	};
-
-	return seccomp(SECCOMP_SET_MODE_FILTER, flags, &prog);
-}
+#include "user-trap-helper.h"
 
 static int handle_req(struct seccomp_notif *req,
 		      struct seccomp_notif_resp *resp, int listener)
-- 
2.20.1
