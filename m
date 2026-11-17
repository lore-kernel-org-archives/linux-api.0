Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794957297;
	b=uDvO++EaykhDn0+OHBQj4fbdmYdjDaOBfcSWSZhSweEnvd4Fnibj8nYsFpbb+4DV66VR
	 m9nqH4i/HdPGIPZmHx0thlOeySSbs2OtKgHZXWtaHl9Ga9EqmjSFPRKaWj9CnX0ubcygD
	 lT9kkRdFH3BFoFjOB5bB2NpDLrtne1AeGdd/+lxtD9Z2wxw2PTFWbd79ye/E1Rhf86jOh
	 igcCfd91Ld2Yoj4saVcIe/Je5Q8t7utUGGb8mj3ynbLaLRz514ar8Z2vdm8prlNuc9k50
	 tPglcJTY7BkklFv/CMWLc7TbUVHK2w6KDSdbfI39flf60sMRwZN7bwOm6WJyYDLcoJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794957297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=j++JeqbZXhiGXuRgNGIrlkqsob0DKGmdcNjJIuxOefQ=;
	b=eK9ebflj/vJ3304YpABLWcUOyMXX6cWgwCuI2WPaZCBYHcWxBFUuB+VY9tBbtldOqXh3
	 PDr5voHSDNma4OrTfq9VZGdYCanPr7LD98aKUTWhuNueSfgYg93g27Tys7KE+9r5Qf6Sg
	 3IHdXN1cHdFmHDBAzHJpv+NRI54R9zBaZDtTie3tll3CT4CLb4I9UIX62lAPRqywfVp/i
	 1GKzFCAEofhaqlcrx8qlvAk7kAmPKqxMBCNEUoWjoWit3G3aX0hKI0uJt9kZ7n6wCJz5s
	 nsvigNWtnVtO/XT21takbUX6V4rSplk52Lqk3ZFBhLW59dEXoSb8Oqye8QWpFGMuViQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="f6kyY/Si";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id DCC55606A8B3;
	Tue, 17 Nov 2026 23:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f6kyY/Si
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8CF591F00932;
	Tue, 17 Nov 2026 23:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957297;
	bh=j++JeqbZXhiGXuRgNGIrlkqsob0DKGmdcNjJIuxOefQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6kyY/Si4qRn3v2R0lhpGfvAiOsmQTo3N/onJ2b9jgDFhMt9PvD4THDz9kBRY0RIu
	 qHy+dVOo376vdFujagV36NW3H5ZZk+J2SKOqKLSqgaL0XZ93eW12cfI4tzziXX/qUK
	 JGMxWN5ZeLipAPfXdbzdXGESTR1lc6zFxz4+mZheETnFbAPO3zRks53iDWHendT63V
	 uj/iLsTZG9k3WSFotkvTdhKsyrPvIGT7qC7vL9eF6sDmwvaShsRpkHHpREJ7bdU+G7
	 1xWx0Ajncgk/YJzV1T6juYhmDkMl6ulQLZwhQqSuHGOERTMX8VBw0YntE4Vcvf08eT
	 II2fBg26ZG5IA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 12/13] selftests/rootns: Add root namespace test suite
Date: Wed, 18 Nov 2026 01:13:51 +0200
Message-ID: <20261117231352.3816603-13-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Verify the root namespace uAPI and security invariants across
privileged, unprivileged, and edge-case scenarios.

Add a kselftest harness suite under tools/testing/selftests/rootns
exercising rootns creation, clone3(CLONE_INTO_ROOTNS) init and
concurrent bootstrap lifecycle, poll(EPOLLHUP) and WNOHANG/rusage
reporting, FSCONFIG_SET_ROOTNS and mount-tree installation, pivot_root()
and OPEN_TREE_NAMESPACE inside a rootns, and entry and setns()
permission enforcement.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 tools/testing/selftests/Makefile          |    1 +
 tools/testing/selftests/rootns/.gitignore |    2 +
 tools/testing/selftests/rootns/Makefile   |    5 +
 tools/testing/selftests/rootns/config     |    9 +
 tools/testing/selftests/rootns/smoke.c    | 1381 +++++++++++++++++++++
 5 files changed, 1398 insertions(+)
 create mode 100644 tools/testing/selftests/rootns/.gitignore
 create mode 100644 tools/testing/selftests/rootns/Makefile
 create mode 100644 tools/testing/selftests/rootns/config
 create mode 100644 tools/testing/selftests/rootns/smoke.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 07c3719f8b04..7c44f93e57a4 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -117,6 +117,7 @@ TARGETS += rdma
 TARGETS += resctrl
 TARGETS += riscv
 TARGETS += rlimits
+TARGETS += rootns
 TARGETS += rseq
 TARGETS += rtc
 TARGETS += rust
diff --git a/tools/testing/selftests/rootns/.gitignore b/tools/testing/selftests/rootns/.gitignore
new file mode 100644
index 000000000000..9a018c20d310
--- /dev/null
+++ b/tools/testing/selftests/rootns/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+/smoke
diff --git a/tools/testing/selftests/rootns/Makefile b/tools/testing/selftests/rootns/Makefile
new file mode 100644
index 000000000000..79162fba3c2b
--- /dev/null
+++ b/tools/testing/selftests/rootns/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+CFLAGS += -Wall -Wextra -O2 -g $(KHDR_INCLUDES)
+TEST_GEN_PROGS := smoke
+include ../lib.mk
diff --git a/tools/testing/selftests/rootns/config b/tools/testing/selftests/rootns/config
new file mode 100644
index 000000000000..715b0a1cf6a8
--- /dev/null
+++ b/tools/testing/selftests/rootns/config
@@ -0,0 +1,9 @@
+CONFIG_CGROUPS=y
+CONFIG_IPC_NS=y
+CONFIG_NET_NS=y
+CONFIG_PID_NS=y
+CONFIG_PROC_FS=y
+CONFIG_ROOTNS=y
+CONFIG_TMPFS=y
+CONFIG_USER_NS=y
+CONFIG_UTS_NS=y
diff --git a/tools/testing/selftests/rootns/smoke.c b/tools/testing/selftests/rootns/smoke.c
new file mode 100644
index 000000000000..350e6e8e2523
--- /dev/null
+++ b/tools/testing/selftests/rootns/smoke.c
@@ -0,0 +1,1381 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+
+#include <errno.h>
+#include <fcntl.h>
+#include <poll.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/prctl.h>
+#include <sys/resource.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <sys/vfs.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include <linux/magic.h>
+#include <linux/mount.h>
+#include <linux/rootns.h>
+#include <linux/sched.h>
+#include "kselftest_harness.h"
+
+#ifndef __NR_pidfd_open
+#define __NR_pidfd_open 434
+#endif
+
+#ifndef __NR_clone3
+#define __NR_clone3 435
+#endif
+
+#ifndef __NR_rootns_create
+#ifdef __alpha__
+#define __NR_rootns_create 583
+#define __NR_rootns_wait 584
+#define __NR_rootns_kill 585
+#else
+#define __NR_rootns_create 473
+#define __NR_rootns_wait 474
+#define __NR_rootns_kill 475
+#endif
+#endif
+
+static int sys_open_tree(int dfd, const char *path, unsigned int flags)
+{
+	return syscall(__NR_open_tree, dfd, path, flags);
+}
+
+static int sys_move_mount(int from_dfd, const char *from_path, int to_dfd,
+			  const char *to_path, unsigned int flags)
+{
+	return syscall(__NR_move_mount, from_dfd, from_path, to_dfd, to_path,
+		       flags);
+}
+
+static int sys_fsopen(const char *fsname, unsigned int flags)
+{
+	return syscall(__NR_fsopen, fsname, flags);
+}
+
+static int sys_fsconfig(int fsfd, unsigned int cmd, const char *key,
+			const void *value, int aux)
+{
+	return syscall(__NR_fsconfig, fsfd, cmd, key, value, aux);
+}
+
+static int sys_fsmount(int fsfd, unsigned int flags, unsigned int attr_flags)
+{
+	return syscall(__NR_fsmount, fsfd, flags, attr_flags);
+}
+
+static int sys_pidfd_open(pid_t pid, unsigned int flags)
+{
+	return syscall(__NR_pidfd_open, pid, flags);
+}
+
+static int sys_pivot_root(const char *new_root, const char *put_old)
+{
+	return syscall(__NR_pivot_root, new_root, put_old);
+}
+
+static int sys_rootns_create(unsigned int flags)
+{
+	return syscall(__NR_rootns_create, flags);
+}
+
+static pid_t sys_clone3(struct clone_args *args, size_t size)
+{
+	fflush(stdout);
+	fflush(stderr);
+	return syscall(__NR_clone3, args, size);
+}
+
+static pid_t clone_into_rootns(int cfd, __u64 extra_flags)
+{
+	struct clone_args args = {
+		.flags = CLONE_INTO_ROOTNS | extra_flags,
+		.exit_signal = SIGCHLD,
+		.rootns = (__u64)(unsigned int)cfd,
+	};
+
+	return sys_clone3(&args, sizeof(args));
+}
+
+static int sys_rootns_wait(int cfd, int *status, unsigned int options,
+			   struct rusage *ru)
+{
+	return syscall(__NR_rootns_wait, cfd, status, options, ru);
+}
+
+static int sys_rootns_kill(int cfd, int sig)
+{
+	return syscall(__NR_rootns_kill, cfd, sig);
+}
+
+static int wait_for_pid_exit(pid_t pid, int *status, int timeout_ms)
+{
+	struct pollfd pfd;
+	int pidfd;
+	int ret;
+
+	pidfd = sys_pidfd_open(pid, 0);
+	if (pidfd >= 0) {
+		pfd.fd = pidfd;
+		pfd.events = POLLIN;
+		do {
+			ret = poll(&pfd, 1, timeout_ms);
+		} while (ret < 0 && errno == EINTR);
+		close(pidfd);
+
+		if (ret == 0) {
+			errno = ETIMEDOUT;
+			return -1;
+		}
+		if (ret < 0)
+			return -1;
+	} else if (errno != ESRCH) {
+		return -1;
+	}
+
+	do {
+		ret = waitpid(pid, status, 0);
+	} while (ret < 0 && errno == EINTR);
+
+	return (ret == pid) ? 0 : -1;
+}
+
+static void kill_and_reap_pid(pid_t pid)
+{
+	int status;
+
+	if (pid <= 0)
+		return;
+	if (kill(pid, SIGKILL) < 0 && errno != ESRCH)
+		return;
+	(void)waitpid(pid, &status, 0);
+}
+
+static int reap_child_exit_code(pid_t pid)
+{
+	int status = 0;
+
+	if (wait_for_pid_exit(pid, &status, 5000) < 0) {
+		kill_and_reap_pid(pid);
+		return -1;
+	}
+	if (!WIFEXITED(status))
+		return -2;
+	return WEXITSTATUS(status);
+}
+
+static int clone_exit(void *arg)
+{
+	(void)arg;
+	return 0;
+}
+
+static int clone_with_flags(int flags)
+{
+	const size_t stack_size = 64 * 1024;
+	void *stack;
+	pid_t pid;
+	int status;
+	int ret;
+
+	stack = malloc(stack_size);
+	if (!stack)
+		return -ENOMEM;
+
+	pid = clone(clone_exit, (char *)stack + stack_size,
+		    SIGCHLD | flags, NULL);
+	if (pid < 0)
+		ret = -errno;
+	else if (waitpid(pid, &status, 0) < 0)
+		ret = -errno;
+	else if (!WIFEXITED(status) || WEXITSTATUS(status))
+		ret = -EIO;
+	else
+		ret = 0;
+
+	free(stack);
+	return ret;
+}
+
+static int send_fd(int sockfd, int fd)
+{
+	char control[CMSG_SPACE(sizeof(fd))];
+	char marker = 'R';
+	struct iovec iov = {
+		.iov_base = &marker,
+		.iov_len = sizeof(marker),
+	};
+	struct msghdr msg = {
+		.msg_iov = &iov,
+		.msg_iovlen = 1,
+		.msg_control = control,
+		.msg_controllen = sizeof(control),
+	};
+	struct cmsghdr *cmsg;
+
+	memset(control, 0, sizeof(control));
+	cmsg = CMSG_FIRSTHDR(&msg);
+	cmsg->cmsg_level = SOL_SOCKET;
+	cmsg->cmsg_type = SCM_RIGHTS;
+	cmsg->cmsg_len = CMSG_LEN(sizeof(fd));
+	memcpy(CMSG_DATA(cmsg), &fd, sizeof(fd));
+
+	return (sendmsg(sockfd, &msg, 0) < 0) ? -1 : 0;
+}
+
+static int recv_fd(int sockfd)
+{
+	char control[CMSG_SPACE(sizeof(int))];
+	char marker;
+	int fd;
+	struct iovec iov = {
+		.iov_base = &marker,
+		.iov_len = sizeof(marker),
+	};
+	struct msghdr msg = {
+		.msg_iov = &iov,
+		.msg_iovlen = 1,
+		.msg_control = control,
+		.msg_controllen = sizeof(control),
+	};
+	struct cmsghdr *cmsg;
+
+	memset(control, 0, sizeof(control));
+	if (recvmsg(sockfd, &msg, 0) < 0)
+		return -1;
+
+	cmsg = CMSG_FIRSTHDR(&msg);
+	if (!cmsg ||
+	    cmsg->cmsg_level != SOL_SOCKET ||
+	    cmsg->cmsg_type != SCM_RIGHTS ||
+	    cmsg->cmsg_len < CMSG_LEN(sizeof(fd))) {
+		errno = EPROTO;
+		return -1;
+	}
+
+	memcpy(&fd, CMSG_DATA(cmsg), sizeof(fd));
+	return fd;
+}
+
+static int send_unshared_mntns_and_wait(int sockfd)
+{
+	ssize_t nread;
+	char ch;
+	int nsfd;
+	int ret;
+
+	if (unshare(CLONE_NEWNS) < 0)
+		return 1;
+
+	nsfd = open("/proc/self/ns/mnt", O_RDONLY | O_CLOEXEC);
+	if (nsfd < 0)
+		return 2;
+
+	ret = send_fd(sockfd, nsfd);
+	close(nsfd);
+	if (ret < 0)
+		return 3;
+
+	nread = read(sockfd, &ch, sizeof(ch));
+	if (nread != (ssize_t)sizeof(ch))
+		return 4;
+
+	return 0;
+}
+
+static int create_rootns_as_uid(uid_t uid, unsigned int flags, int *cfd)
+{
+	int pipefd[2];
+	ssize_t nread;
+	int err = 0;
+	int status;
+	int sv[2];
+	pid_t pid;
+
+	if (socketpair(AF_UNIX, SOCK_DGRAM | SOCK_CLOEXEC, 0, sv) < 0)
+		return -errno;
+
+	if (pipe2(pipefd, O_CLOEXEC) < 0) {
+		err = -errno;
+		close(sv[0]);
+		close(sv[1]);
+		return err;
+	}
+
+	pid = fork();
+	if (pid < 0) {
+		err = -errno;
+		close(pipefd[0]);
+		close(pipefd[1]);
+		close(sv[0]);
+		close(sv[1]);
+		return err;
+	}
+
+	if (pid == 0) {
+		int child_fd = -1;
+
+		close(pipefd[0]);
+		close(sv[0]);
+
+		if (setresuid(uid, uid, uid) < 0) {
+			err = errno;
+			goto out_child;
+		}
+
+		child_fd = sys_rootns_create(flags);
+		if (child_fd < 0) {
+			err = errno;
+			goto out_child;
+		}
+
+		if (send_fd(sv[1], child_fd) < 0)
+			err = errno;
+
+out_child:
+		if (child_fd >= 0)
+			close(child_fd);
+		(void)write(pipefd[1], &err, sizeof(err));
+		close(pipefd[1]);
+		close(sv[1]);
+		_exit(err ? 1 : 0);
+	}
+
+	close(pipefd[1]);
+	close(sv[1]);
+
+	nread = read(pipefd[0], &err, sizeof(err));
+	close(pipefd[0]);
+	if (nread != (ssize_t)sizeof(err))
+		err = (nread < 0) ? errno : EPROTO;
+
+	if (!err) {
+		*cfd = recv_fd(sv[0]);
+		if (*cfd < 0)
+			err = errno;
+	}
+	close(sv[0]);
+
+	if (waitpid(pid, &status, 0) != pid && !err)
+		err = errno;
+	if (!err && (!WIFEXITED(status) || WEXITSTATUS(status)))
+		err = ECHILD;
+
+	return err ? -err : 0;
+}
+
+static int mount_root(int cfd)
+{
+	static const char *const dirs[] = { "proc", "mnt", "tmp" };
+	int saved_errno;
+	int rootfd;
+	int fsfd;
+	size_t i;
+
+	fsfd = sys_fsopen("tmpfs", 0);
+	if (fsfd < 0)
+		return -1;
+
+	if (sys_fsconfig(fsfd, FSCONFIG_SET_ROOTNS, NULL, NULL, cfd) < 0)
+		goto err_fsfd;
+	if (sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0) < 0)
+		goto err_fsfd;
+
+	rootfd = sys_fsmount(fsfd, 0, 0);
+	if (rootfd < 0)
+		goto err_fsfd;
+
+	for (i = 0; i < ARRAY_SIZE(dirs); i++) {
+		if (mkdirat(rootfd, dirs[i], 0755) < 0 && errno != EEXIST)
+			goto err_rootfd;
+	}
+
+	if (sys_move_mount(rootfd, "", cfd, "/",
+			   MOVE_MOUNT_F_EMPTY_PATH |
+			   MOVE_MOUNT_T_ROOTNS_ROOT) < 0)
+		goto err_rootfd;
+
+	close(rootfd);
+	close(fsfd);
+	return 0;
+
+err_rootfd:
+	saved_errno = errno;
+	close(rootfd);
+	errno = saved_errno;
+err_fsfd:
+	saved_errno = errno;
+	close(fsfd);
+	errno = saved_errno;
+	return -1;
+}
+
+static int mount_proc(int cfd, bool need_proc)
+{
+	const char *fstype = need_proc ? "proc" : "tmpfs";
+	int saved_errno;
+	int fsfd;
+	int mfd;
+
+	fsfd = sys_fsopen(fstype, 0);
+	if (fsfd < 0)
+		return -1;
+
+	if (sys_fsconfig(fsfd, FSCONFIG_SET_ROOTNS, NULL, NULL, cfd) < 0)
+		goto err_fsfd;
+	if (sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0) < 0)
+		goto err_fsfd;
+
+	mfd = sys_fsmount(fsfd, 0, 0);
+	if (mfd < 0)
+		goto err_fsfd;
+
+	if (sys_move_mount(mfd, "", cfd, "proc",
+			   MOVE_MOUNT_F_EMPTY_PATH |
+			   MOVE_MOUNT_T_ROOTNS_ROOT) < 0) {
+		saved_errno = errno;
+		close(mfd);
+		errno = saved_errno;
+		goto err_fsfd;
+	}
+
+	close(mfd);
+	close(fsfd);
+	return 0;
+
+err_fsfd:
+	saved_errno = errno;
+	close(fsfd);
+	errno = saved_errno;
+	return -1;
+}
+
+static int create_test_rootns(bool need_proc, unsigned int flags)
+{
+	int saved_errno;
+	int cfd;
+
+	cfd = sys_rootns_create(flags);
+	if (cfd < 0)
+		return -1;
+
+	if (mount_root(cfd) < 0 || mount_proc(cfd, need_proc) < 0) {
+		saved_errno = errno;
+		close(cfd);
+		errno = saved_errno;
+		return -1;
+	}
+
+	return cfd;
+}
+
+FIXTURE(rootns) {
+	int cfd;
+};
+
+FIXTURE_SETUP(rootns) {
+	self->cfd = create_test_rootns(false, ROOTNS_ALL_NAMESPACES |
+					ROOTNS_KILL_ON_CLOSE |
+					ROOTNS_CLOSE_ON_EXEC);
+	ASSERT_GE(self->cfd, 0);
+}
+
+FIXTURE_TEARDOWN(rootns) {
+	if (self->cfd >= 0)
+		close(self->cfd);
+}
+
+TEST_F(rootns, create) {
+	ASSERT_GE(self->cfd, 0);
+}
+
+TEST_F(rootns, kill) {
+	int ready_pipe[2];
+	int hold_pipe[2];
+	char ch;
+	int status;
+	pid_t pid1;
+	pid_t pid2;
+	int ret;
+
+	ASSERT_EQ(pipe2(ready_pipe, O_CLOEXEC), 0);
+	ASSERT_EQ(pipe2(hold_pipe, O_CLOEXEC), 0);
+
+	pid1 = clone_into_rootns(self->cfd, 0);
+	ASSERT_GE(pid1, 0);
+	if (pid1 == 0) {
+		close(self->cfd);
+		close(ready_pipe[0]);
+		close(ready_pipe[1]);
+		close(hold_pipe[0]);
+		close(hold_pipe[1]);
+		for (;;)
+			pause();
+	}
+
+	pid2 = clone_into_rootns(self->cfd, 0);
+	ASSERT_GE(pid2, 0);
+	if (pid2 == 0) {
+		pid_t child;
+
+		close(self->cfd);
+		close(ready_pipe[0]);
+		close(hold_pipe[0]);
+		child = fork();
+		if (child < 0)
+			_exit(1);
+		if (child == 0) {
+			ch = 'r';
+			(void)write(ready_pipe[1], &ch, 1);
+			close(ready_pipe[1]);
+			for (;;)
+				pause();
+		}
+		close(ready_pipe[1]);
+		close(hold_pipe[1]);
+		for (;;)
+			pause();
+	}
+	close(ready_pipe[1]);
+	close(hold_pipe[1]);
+
+	ASSERT_EQ(read(ready_pipe[0], &ch, 1), 1);
+	close(ready_pipe[0]);
+
+	ASSERT_EQ(sys_rootns_kill(self->cfd, SIGKILL), 0);
+	ASSERT_EQ(read(hold_pipe[0], &ch, 1), 0);
+	close(hold_pipe[0]);
+
+	ret = wait_for_pid_exit(pid2, &status, 5000);
+	if (ret < 0) {
+		kill_and_reap_pid(pid2);
+		kill_and_reap_pid(pid1);
+		ASSERT_EQ(ret, 0);
+	}
+	ASSERT_TRUE(WIFSIGNALED(status));
+	ASSERT_EQ(WTERMSIG(status), SIGKILL);
+
+	ret = wait_for_pid_exit(pid1, &status, 5000);
+	if (ret < 0) {
+		kill_and_reap_pid(pid1);
+		ASSERT_EQ(ret, 0);
+	}
+	ASSERT_TRUE(WIFSIGNALED(status));
+	ASSERT_EQ(WTERMSIG(status), SIGKILL);
+}
+
+TEST_F(rootns, wait) {
+	int status = 0;
+	pid_t pid;
+
+	pid = clone_into_rootns(self->cfd, 0);
+	ASSERT_GE(pid, 0);
+	if (pid == 0)
+		_exit(123);
+
+	ASSERT_EQ(sys_rootns_wait(self->cfd, &status, 0, NULL), pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 123);
+	ASSERT_EQ(reap_child_exit_code(pid), 123);
+}
+
+TEST_F(rootns, poll) {
+	struct pollfd pfd;
+	struct rusage ru;
+	int status = 0;
+	int pipefd[2];
+	pid_t pid;
+
+	ASSERT_EQ(pipe2(pipefd, O_CLOEXEC), 0);
+
+	pid = clone_into_rootns(self->cfd, 0);
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		char ch;
+
+		close(self->cfd);
+		close(pipefd[1]);
+		(void)read(pipefd[0], &ch, 1);
+		close(pipefd[0]);
+		_exit(42);
+	}
+	close(pipefd[0]);
+
+	ASSERT_EQ(sys_rootns_wait(self->cfd, &status, WNOHANG, NULL), 0);
+
+	pfd.fd = self->cfd;
+	pfd.events = POLLIN;
+	pfd.revents = 0;
+	ASSERT_EQ(poll(&pfd, 1, 0), 0);
+
+	close(pipefd[1]);
+
+	ASSERT_EQ(poll(&pfd, 1, 5000), 1);
+	ASSERT_NE(pfd.revents & POLLHUP, 0);
+
+	memset(&ru, 0xff, sizeof(ru));
+	ASSERT_EQ(sys_rootns_wait(self->cfd, &status, WNOHANG, &ru), pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 42);
+	ASSERT_GE(ru.ru_utime.tv_sec, 0);
+	ASSERT_GE(ru.ru_maxrss, 0);
+	ASSERT_EQ(reap_child_exit_code(pid), 42);
+}
+
+TEST_F(rootns, clone_dead) {
+	int status = 0;
+	pid_t pid;
+
+	pid = clone_into_rootns(self->cfd, 0);
+	ASSERT_GE(pid, 0);
+	if (pid == 0)
+		_exit(0);
+
+	ASSERT_EQ(sys_rootns_wait(self->cfd, &status, 0, NULL), pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(reap_child_exit_code(pid), 0);
+
+	ASSERT_EQ(clone_into_rootns(self->cfd, 0), -1);
+	ASSERT_EQ(errno, ESRCH);
+}
+
+TEST_F(rootns, nested_ns) {
+	pid_t pid;
+	int nsfd;
+
+	nsfd = open("/proc/self/ns/mnt", O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(nsfd, 0);
+
+	pid = clone_into_rootns(self->cfd, 0);
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		close(self->cfd);
+
+		if (unshare(CLONE_NEWNS))
+			_exit(1);
+		if (clone_with_flags(CLONE_NEWNS))
+			_exit(2);
+		if (unshare(CLONE_NEWUSER))
+			_exit(3);
+		if (clone_with_flags(CLONE_NEWUSER))
+			_exit(4);
+		if (setns(nsfd, CLONE_NEWNS) != -1 || errno != EPERM)
+			_exit(5);
+
+		close(nsfd);
+		_exit(0);
+	}
+
+	close(nsfd);
+	ASSERT_EQ(reap_child_exit_code(pid), 0);
+}
+
+TEST_F(rootns, setns_same) {
+	ssize_t nwritten;
+	pid_t pid1;
+	pid_t pid2;
+	char ch;
+	int nsfd;
+	int sv[2];
+
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_DGRAM | SOCK_CLOEXEC, 0, sv), 0);
+
+	pid1 = clone_into_rootns(self->cfd, 0);
+	ASSERT_GE(pid1, 0);
+	if (pid1 == 0) {
+		int ret;
+
+		close(self->cfd);
+		close(sv[0]);
+		ret = send_unshared_mntns_and_wait(sv[1]);
+		close(sv[1]);
+		_exit(ret);
+	}
+	close(sv[1]);
+
+	nsfd = recv_fd(sv[0]);
+	ASSERT_GE(nsfd, 0);
+
+	pid2 = clone_into_rootns(self->cfd, 0);
+	ASSERT_GE(pid2, 0);
+	if (pid2 == 0) {
+		int ret;
+
+		close(self->cfd);
+		close(sv[0]);
+		ret = setns(nsfd, CLONE_NEWNS);
+		close(nsfd);
+		_exit(ret ? 1 : 0);
+	}
+	close(nsfd);
+
+	ASSERT_EQ(reap_child_exit_code(pid2), 0);
+
+	ch = 'x';
+	nwritten = write(sv[0], &ch, sizeof(ch));
+	ASSERT_EQ(nwritten, (ssize_t)sizeof(ch));
+	close(sv[0]);
+
+	ASSERT_EQ(reap_child_exit_code(pid1), 0);
+}
+
+TEST_F(rootns, setns_foreign) {
+	unsigned int flags = ROOTNS_ALL_NAMESPACES |
+			     ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC;
+	ssize_t nwritten;
+	int alpha_cfd;
+	int beta_cfd;
+	pid_t alpha_pid;
+	pid_t beta_pid;
+	char ch;
+	int nsfd;
+	int sv[2];
+
+	alpha_cfd = create_test_rootns(false, flags);
+	ASSERT_GE(alpha_cfd, 0);
+
+	beta_cfd = create_test_rootns(false, flags);
+	ASSERT_GE(beta_cfd, 0);
+
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_DGRAM | SOCK_CLOEXEC, 0, sv), 0);
+
+	beta_pid = clone_into_rootns(beta_cfd, 0);
+	ASSERT_GE(beta_pid, 0);
+	if (beta_pid == 0) {
+		int ret;
+
+		close(alpha_cfd);
+		close(beta_cfd);
+		close(sv[0]);
+		ret = send_unshared_mntns_and_wait(sv[1]);
+		close(sv[1]);
+		_exit(ret);
+	}
+	close(sv[1]);
+
+	nsfd = recv_fd(sv[0]);
+	ASSERT_GE(nsfd, 0);
+
+	alpha_pid = clone_into_rootns(alpha_cfd, 0);
+	ASSERT_GE(alpha_pid, 0);
+	if (alpha_pid == 0) {
+		int ret;
+
+		close(alpha_cfd);
+		close(beta_cfd);
+		close(sv[0]);
+		ret = setns(nsfd, CLONE_NEWNS);
+		close(nsfd);
+		if (ret != -1 || errno != EPERM)
+			_exit(1);
+		_exit(0);
+	}
+	close(nsfd);
+
+	ASSERT_EQ(reap_child_exit_code(alpha_pid), 0);
+
+	ch = 'x';
+	nwritten = write(sv[0], &ch, sizeof(ch));
+	ASSERT_EQ(nwritten, (ssize_t)sizeof(ch));
+	close(sv[0]);
+
+	ASSERT_EQ(reap_child_exit_code(beta_pid), 0);
+
+	close(alpha_cfd);
+	close(beta_cfd);
+}
+
+TEST_F(rootns, submount) {
+	pid_t pid;
+
+	pid = clone_into_rootns(self->cfd, 0);
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		struct statfs st;
+
+		close(self->cfd);
+		if (statfs("/proc", &st) < 0)
+			_exit(1);
+		if ((unsigned long)st.f_type != (unsigned long)TMPFS_MAGIC)
+			_exit(2);
+		_exit(0);
+	}
+
+	ASSERT_EQ(reap_child_exit_code(pid), 0);
+}
+
+TEST_F(rootns, proc) {
+	int cfd;
+	pid_t pid;
+
+	cfd = create_test_rootns(true, ROOTNS_ALL_NAMESPACES |
+				 ROOTNS_KILL_ON_CLOSE |
+				 ROOTNS_CLOSE_ON_EXEC);
+	ASSERT_GE(cfd, 0);
+
+	pid = clone_into_rootns(cfd, 0);
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		struct statfs st;
+		char target[32];
+		ssize_t len;
+
+		close(cfd);
+		if (getpid() != 1)
+			_exit(1);
+		if (statfs("/proc", &st) < 0)
+			_exit(2);
+		if ((unsigned long)st.f_type != (unsigned long)PROC_SUPER_MAGIC)
+			_exit(3);
+		len = readlink("/proc/self", target, sizeof(target) - 1);
+		if (len <= 0)
+			_exit(4);
+		target[len] = '\0';
+		if (strcmp(target, "1") != 0)
+			_exit(5);
+		_exit(0);
+	}
+
+	ASSERT_EQ(reap_child_exit_code(pid), 0);
+	close(cfd);
+}
+
+TEST_F(rootns, pivot_root) {
+	unsigned int flags = (ROOTNS_ALL_NAMESPACES & ~ROOTNS_USER) |
+			     ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC;
+	int cfd;
+	pid_t pid;
+
+	cfd = create_test_rootns(false, flags);
+	ASSERT_GE(cfd, 0);
+
+	pid = clone_into_rootns(cfd, 0);
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		int fsfd;
+		int mfd;
+		int nsfd;
+
+		close(cfd);
+		fsfd = sys_fsopen("tmpfs", 0);
+		if (fsfd < 0)
+			_exit(1);
+		if (sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0) < 0)
+			_exit(2);
+		mfd = sys_fsmount(fsfd, 0, 0);
+		close(fsfd);
+		if (mfd < 0)
+			_exit(3);
+		if (mkdirat(mfd, "old", 0755) < 0)
+			_exit(4);
+		if (sys_move_mount(mfd, "", AT_FDCWD, "/mnt",
+				   MOVE_MOUNT_F_EMPTY_PATH) < 0)
+			_exit(5);
+		close(mfd);
+
+		if (chdir("/mnt") < 0)
+			_exit(6);
+		if (sys_pivot_root(".", "old") < 0)
+			_exit(7);
+
+		nsfd = sys_open_tree(AT_FDCWD, "/",
+				     OPEN_TREE_NAMESPACE | OPEN_TREE_CLOEXEC);
+		if (nsfd < 0)
+			_exit(8);
+		if (setns(nsfd, CLONE_NEWNS) < 0)
+			_exit(9);
+		close(nsfd);
+		_exit(0);
+	}
+
+	ASSERT_EQ(reap_child_exit_code(pid), 0);
+	close(cfd);
+}
+
+TEST_F(rootns, kill_on_close) {
+	int status;
+	pid_t pid;
+	int cfd;
+	int ret;
+
+	cfd = create_test_rootns(false, ROOTNS_ALL_NAMESPACES | ROOTNS_KILL_ON_CLOSE);
+	ASSERT_GE(cfd, 0);
+
+	pid = clone_into_rootns(cfd, 0);
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		close(cfd);
+		for (;;)
+			pause();
+	}
+
+	close(cfd);
+
+	ret = wait_for_pid_exit(pid, &status, 5000);
+	if (ret < 0) {
+		kill_and_reap_pid(pid);
+		ASSERT_EQ(ret, 0);
+	}
+	ASSERT_TRUE(WIFSIGNALED(status));
+	ASSERT_EQ(WTERMSIG(status), SIGKILL);
+}
+
+static int enter_unpriv_user_mntns(uid_t drop_uid)
+{
+	char map[32];
+	uid_t uid;
+	gid_t gid;
+	int fd;
+	int len;
+
+	if (geteuid() == 0 &&
+	    (setresgid(drop_uid, drop_uid, drop_uid) < 0 ||
+	     setresuid(drop_uid, drop_uid, drop_uid) < 0))
+		return -errno;
+
+	uid = geteuid();
+	gid = getegid();
+	if (unshare(CLONE_NEWUSER | CLONE_NEWNS) < 0)
+		return -errno;
+
+	fd = open("/proc/self/setgroups", O_WRONLY | O_CLOEXEC);
+	if (fd >= 0) {
+		(void)write(fd, "deny\n", 5);
+		close(fd);
+	}
+
+	fd = open("/proc/self/uid_map", O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -errno;
+	len = snprintf(map, sizeof(map), "0 %u 1\n", (unsigned int)uid);
+	if (write(fd, map, (size_t)len) != len) {
+		close(fd);
+		return -EIO;
+	}
+	close(fd);
+
+	fd = open("/proc/self/gid_map", O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -errno;
+	len = snprintf(map, sizeof(map), "0 %u 1\n", (unsigned int)gid);
+	if (write(fd, map, (size_t)len) != len) {
+		close(fd);
+		return -EIO;
+	}
+	close(fd);
+
+	return 0;
+}
+
+TEST_F(rootns, mount_perms) {
+	int cfd = -1;
+	int rootfsfd;
+	pid_t pid;
+	int mfd;
+	int ret;
+
+	ret = create_rootns_as_uid(1000, ROOTNS_ALL_NAMESPACES | ROOTNS_USER,
+				   &cfd);
+	if (ret == -EPERM || ret == -EACCES || ret == -EINVAL)
+		SKIP(return, "unprivileged ROOTNS_USER creation is unavailable");
+	ASSERT_EQ(ret, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		int u_fsfd;
+		int u_mfd;
+
+		ret = enter_unpriv_user_mntns(2000);
+		if (ret == -EPERM || ret == -EACCES || ret == -EINVAL ||
+		    ret == -ENOSPC)
+			_exit(0);
+		if (ret < 0)
+			_exit(1);
+
+		u_fsfd = sys_fsopen("tmpfs", 0);
+		if (u_fsfd < 0)
+			_exit(2);
+		if (sys_fsconfig(u_fsfd, FSCONFIG_SET_ROOTNS, NULL, NULL,
+				 cfd) != -1 || errno != EPERM)
+			_exit(3);
+		if (sys_fsconfig(u_fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0) < 0)
+			_exit(4);
+
+		u_mfd = sys_fsmount(u_fsfd, 0, 0);
+		if (u_mfd < 0)
+			_exit(5);
+		if (sys_move_mount(u_mfd, "", cfd, "/",
+				   MOVE_MOUNT_F_EMPTY_PATH |
+				   MOVE_MOUNT_T_ROOTNS_ROOT) != -1 ||
+		    errno != EPERM)
+			_exit(6);
+
+		close(u_mfd);
+		close(u_fsfd);
+		close(cfd);
+		_exit(0);
+	}
+	ASSERT_EQ(reap_child_exit_code(pid), 0);
+
+	if (geteuid() == 0) {
+		rootfsfd = sys_fsopen("tmpfs", 0);
+		ASSERT_GE(rootfsfd, 0);
+		ASSERT_EQ(sys_fsconfig(rootfsfd, FSCONFIG_SET_ROOTNS, NULL,
+				       NULL, cfd), 0);
+		ASSERT_EQ(sys_fsconfig(rootfsfd, FSCONFIG_CMD_CREATE, NULL,
+				       NULL, 0), 0);
+		mfd = sys_fsmount(rootfsfd, 0, 0);
+		ASSERT_GE(mfd, 0);
+		close(rootfsfd);
+
+		pid = fork();
+		ASSERT_GE(pid, 0);
+		if (pid == 0) {
+			if (setresgid(1000, 1000, 1000) < 0 ||
+			    setresuid(1000, 1000, 1000) < 0)
+				_exit(1);
+			if (sys_move_mount(mfd, "", cfd, "/",
+					   MOVE_MOUNT_F_EMPTY_PATH |
+					   MOVE_MOUNT_T_ROOTNS_ROOT) < 0)
+				_exit(2);
+			close(mfd);
+			close(cfd);
+			_exit(0);
+		}
+		close(mfd);
+		ASSERT_EQ(reap_child_exit_code(pid), 0);
+	}
+
+	close(cfd);
+}
+
+TEST_F(rootns, mount_attached) {
+	int cfd;
+
+	cfd = sys_rootns_create(ROOTNS_ALL_NAMESPACES |
+				ROOTNS_KILL_ON_CLOSE |
+				ROOTNS_CLOSE_ON_EXEC);
+	ASSERT_GE(cfd, 0);
+
+	ASSERT_EQ(sys_move_mount(AT_FDCWD, "/", cfd, "/",
+				 MOVE_MOUNT_T_ROOTNS_ROOT), -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	close(cfd);
+}
+
+TEST_F(rootns, mount_empty_path) {
+	int cfd;
+	int mfd;
+
+	cfd = sys_rootns_create(ROOTNS_ALL_NAMESPACES |
+				ROOTNS_KILL_ON_CLOSE |
+				ROOTNS_CLOSE_ON_EXEC);
+	ASSERT_GE(cfd, 0);
+
+	mfd = sys_open_tree(AT_FDCWD, "/", OPEN_TREE_CLONE);
+	ASSERT_GE(mfd, 0);
+
+	ASSERT_EQ(sys_move_mount(mfd, "", cfd, "",
+				 MOVE_MOUNT_F_EMPTY_PATH |
+				 MOVE_MOUNT_T_ROOTNS_ROOT), -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	close(mfd);
+	close(cfd);
+}
+
+TEST_F(rootns, clone_perms) {
+	pid_t pid;
+	int cfd;
+
+	cfd = sys_rootns_create(ROOTNS_ALL_NAMESPACES |
+				ROOTNS_KILL_ON_CLOSE |
+				ROOTNS_CLOSE_ON_EXEC);
+	ASSERT_GE(cfd, 0);
+
+	ASSERT_EQ(clone_into_rootns(cfd, 0), -1);
+	ASSERT_EQ(errno, ENOENT);
+
+	ASSERT_EQ(mount_root(cfd), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		int ret = enter_unpriv_user_mntns(2000);
+
+		if (ret == -EPERM || ret == -EACCES || ret == -EINVAL ||
+		    ret == -ENOSPC) {
+			close(cfd);
+			_exit(0);
+		}
+		if (ret < 0)
+			_exit(1);
+		if (clone_into_rootns(cfd, 0) != -1 || errno != EPERM)
+			_exit(2);
+		close(cfd);
+		_exit(0);
+	}
+	ASSERT_EQ(reap_child_exit_code(pid), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		pid_t ent_pid;
+
+		if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) < 0)
+			_exit(1);
+		ent_pid = clone_into_rootns(cfd, 0);
+		if (ent_pid < 0)
+			_exit(2);
+		if (ent_pid == 0) {
+			close(cfd);
+			if (getpid() != 1)
+				_exit(3);
+			if (prctl(PR_GET_NO_NEW_PRIVS, 0, 0, 0, 0) != 1)
+				_exit(4);
+			_exit(0);
+		}
+		close(cfd);
+		_exit(reap_child_exit_code(ent_pid) == 0 ? 0 : 5);
+	}
+	ASSERT_EQ(reap_child_exit_code(pid), 0);
+
+	close(cfd);
+}
+
+TEST_F(rootns, clone_flags) {
+	static const __u64 bad_flags[] = {
+		CLONE_NEWNS,
+		CLONE_NEWPID,
+		CLONE_NEWUSER,
+		CLONE_EMPTY_MNTNS,
+		CLONE_FS,
+		CLONE_THREAD | CLONE_SIGHAND | CLONE_VM,
+		CLONE_PARENT,
+		CLONE_SYSVSEM,
+		CLONE_VM,
+	};
+	struct clone_args args;
+	int pipefd[2];
+	int pidfd = -1;
+	int bad_fd;
+	pid_t pid;
+	size_t i;
+	int cfd;
+
+	memset(&args, 0, sizeof(args));
+	args.flags = CLONE_INTO_ROOTNS;
+	args.exit_signal = SIGCHLD;
+	args.rootns = (__u64)self->cfd;
+	ASSERT_EQ(sys_clone3(&args, CLONE_ARGS_SIZE_VER2), -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	args.rootns = (__u64)-1;
+	ASSERT_EQ(sys_clone3(&args, sizeof(args)), -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	ASSERT_EQ(pipe2(pipefd, O_CLOEXEC), 0);
+	ASSERT_EQ(clone_into_rootns(pipefd[0], 0), -1);
+	ASSERT_EQ(errno, EINVAL);
+	bad_fd = pipefd[0];
+	close(pipefd[0]);
+	close(pipefd[1]);
+
+	ASSERT_EQ(clone_into_rootns(bad_fd, 0), -1);
+	ASSERT_EQ(errno, EBADF);
+
+	for (i = 0; i < ARRAY_SIZE(bad_flags); i++) {
+		memset(&args, 0, sizeof(args));
+		args.flags = CLONE_INTO_ROOTNS | bad_flags[i];
+		args.rootns = (__u64)self->cfd;
+		if (!(bad_flags[i] & (CLONE_THREAD | CLONE_PARENT)))
+			args.exit_signal = SIGCHLD;
+		ASSERT_EQ(sys_clone3(&args, sizeof(args)), -1);
+		ASSERT_EQ(errno, EINVAL);
+	}
+
+	cfd = sys_rootns_create(ROOTNS_ALL_NAMESPACES |
+				ROOTNS_KILL_ON_CLOSE |
+				ROOTNS_CLOSE_ON_EXEC);
+	ASSERT_GE(cfd, 0);
+	ASSERT_EQ(clone_into_rootns(cfd, CLONE_VM | CLONE_VFORK), -1);
+	ASSERT_EQ(errno, ENOENT);
+	close(cfd);
+
+	memset(&args, 0, sizeof(args));
+	args.flags = CLONE_INTO_ROOTNS | CLONE_VFORK | CLONE_PIDFD |
+		     CLONE_CLEAR_SIGHAND | CLONE_NNP;
+	args.pidfd = (__u64)(uintptr_t)&pidfd;
+	args.exit_signal = SIGCHLD;
+	args.rootns = (__u64)self->cfd;
+	pid = sys_clone3(&args, sizeof(args));
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		close(self->cfd);
+		if (getpid() != 1)
+			_exit(1);
+		if (prctl(PR_GET_NO_NEW_PRIVS, 0, 0, 0, 0) != 1)
+			_exit(2);
+		_exit(0);
+	}
+	ASSERT_GE(pidfd, 0);
+	close(pidfd);
+	ASSERT_EQ(reap_child_exit_code(pid), 0);
+}
+
+TEST_F(rootns, fsconfig) {
+	pid_t pid;
+	int fsfd;
+	int cfd;
+
+	cfd = sys_rootns_create(ROOTNS_ALL_NAMESPACES |
+				ROOTNS_KILL_ON_CLOSE |
+				ROOTNS_CLOSE_ON_EXEC);
+	ASSERT_GE(cfd, 0);
+
+	fsfd = sys_fsopen("tmpfs", 0);
+	ASSERT_GE(fsfd, 0);
+	ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_ROOTNS, NULL, NULL, cfd), 0);
+	ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_ROOTNS, NULL, NULL, cfd), -1);
+	ASSERT_EQ(errno, EBUSY);
+	close(fsfd);
+	close(cfd);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		int ucfd;
+		int ret;
+		int sfd;
+
+		ret = enter_unpriv_user_mntns(1000);
+		if (ret == -EPERM || ret == -EACCES || ret == -EINVAL ||
+		    ret == -ENOSPC)
+			_exit(0);
+		if (ret < 0)
+			_exit(1);
+
+		ucfd = sys_rootns_create(ROOTNS_USER | ROOTNS_CLOSE_ON_EXEC);
+		if (ucfd < 0) {
+			if (errno == EPERM || errno == EACCES ||
+			    errno == EINVAL || errno == ENOSPC)
+				_exit(0);
+			_exit(2);
+		}
+
+		sfd = sys_fsopen("sysfs", 0);
+		if (sfd < 0) {
+			if (errno == ENODEV) {
+				close(ucfd);
+				_exit(0);
+			}
+			_exit(3);
+		}
+
+		if (sys_fsconfig(sfd, FSCONFIG_SET_ROOTNS, NULL, NULL, ucfd) < 0)
+			_exit(4);
+		if (sys_fsconfig(sfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0) != -1 ||
+		    errno != EPERM)
+			_exit(5);
+
+		close(sfd);
+		close(ucfd);
+		_exit(0);
+	}
+
+	ASSERT_EQ(reap_child_exit_code(pid), 0);
+}
+
+TEST_F(rootns, clone_concurrent) {
+	unsigned int seen_mask = 0;
+	int start_pipe[2];
+	int ready_pipe[2];
+	int hold_pipe[2];
+	pid_t workers[4];
+	int status = 0;
+	int i;
+
+	ASSERT_EQ(pipe2(start_pipe, O_CLOEXEC), 0);
+	ASSERT_EQ(pipe2(ready_pipe, O_CLOEXEC), 0);
+	ASSERT_EQ(pipe2(hold_pipe, O_CLOEXEC), 0);
+
+	for (i = 0; i < 4; i++) {
+		workers[i] = fork();
+		ASSERT_GE(workers[i], 0);
+		if (workers[i] == 0) {
+			pid_t ent_pid;
+			char ch;
+
+			close(start_pipe[1]);
+			close(ready_pipe[0]);
+			close(hold_pipe[1]);
+
+			(void)read(start_pipe[0], &ch, 1);
+			close(start_pipe[0]);
+
+			ent_pid = clone_into_rootns(self->cfd, 0);
+			if (ent_pid < 0)
+				_exit(1);
+			if (ent_pid == 0) {
+				unsigned char my_pid = (unsigned char)getpid();
+
+				if (write(ready_pipe[1], &my_pid, 1) != 1)
+					_exit(2);
+				close(ready_pipe[1]);
+				(void)read(hold_pipe[0], &ch, 1);
+				close(hold_pipe[0]);
+				_exit(0);
+			}
+
+			close(ready_pipe[1]);
+			close(hold_pipe[0]);
+			close(self->cfd);
+			_exit(reap_child_exit_code(ent_pid) == 0 ? 0 : 3);
+		}
+	}
+
+	close(start_pipe[0]);
+	close(ready_pipe[1]);
+	close(hold_pipe[0]);
+	close(start_pipe[1]);
+
+	for (i = 0; i < 4; i++) {
+		unsigned char pid_byte = 0;
+
+		ASSERT_EQ(read(ready_pipe[0], &pid_byte, 1), 1);
+		ASSERT_GE(pid_byte, 1);
+		ASSERT_LE(pid_byte, 4);
+		seen_mask |= 1U << pid_byte;
+	}
+	close(ready_pipe[0]);
+	close(hold_pipe[1]);
+
+	ASSERT_EQ(seen_mask, 0x1eU);
+
+	for (i = 0; i < 4; i++)
+		ASSERT_EQ(reap_child_exit_code(workers[i]), 0);
+
+	ASSERT_GT(sys_rootns_wait(self->cfd, &status, 0, NULL), 0);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+}
+
+TEST_HARNESS_MAIN
-- 
2.47.3

