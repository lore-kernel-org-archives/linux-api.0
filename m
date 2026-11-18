Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030596;
	b=quOiLVTDruSUgeHwyriQQ53sPNnAbqXUYh4vcYd/+IEDngsjo65YK59RT9wjvGA+lyFs
	 BddW9zId7N4rAUWmggHgtzu+3Jey/7dr9slS7xNiJEC/JxXmznPkqprCd9rrXiLonqfvm
	 E6eOa1dTGSGwOgrJiJEop0zPoz4/TxPs7jHGEL+KV9LycUKz8E47uqqbGTkFP1iSSccZr
	 OhUvhrrTow97yWIulGDl4IHaQCozZEDlVUV93+UkPp20wBaLb+uHU4NHUJlVKxi81HpS2
	 Azc/ldeSeSy/TwsU4PCzfWuWLFwf2fwJPU/HDp1a3zeEPmv9PvnmTjJbAyz/DY/Wjiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=lEVlnbrhAjlEg9BhFZj3lSjqPIMbXbX0YtdccuwzBtA=;
	b=xslBCUZOC7Dr17KgElNGuA0aAzR2ykk9re/3szX5bDlYnDlLWbz+NjSSs5P18oQZdsX0
	 pCWgViLOE850qcRvXLIQhPiiVaTxDy2w1WeW/O40cniUFIoPDSF/GO6dUpHv0AFq6erCJ
	 tG6KGNrSxwGYYyiuQBDxnejd9+ZZQoBgq3R0+5jh8TdQgEZJjmKQ8XGY3LzxbSEC+kWtX
	 g0FTKI0qAj3yzfb1zoYcYxeyfrORprktfZxSpNHXF2mpvi9yrg7MOSpQaUwSY2NrELWQl
	 RAeiJ904XW6jdLqb7yYDk9QGCcyxXYN9chUtDmM6Dl3OrWS3rEyLZlE5IIvIkp+fOYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n7ZAIhk5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C9AD7606DD23;
	Wed, 18 Nov 2026 19:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n7ZAIhk5
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 71D5D1F000C6;
	Wed, 18 Nov 2026 19:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030596;
	bh=lEVlnbrhAjlEg9BhFZj3lSjqPIMbXbX0YtdccuwzBtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7ZAIhk5uCfQojcSc9nbsxR528vtP6BvnA9C2n3AZtjFoCALrZyNfN5XCLHKKu7zH
	 G1XH4Leu++SBEgJzWMRvYq5mbINbKb+34M81JRr4pu5RlAX4YTOxKcAvty8M8SnNqL
	 O6atNnBLOaYxE9NJxtQcN+JnZyxVSeIM9Sdjx20PwuFU/bFReGID7Aznt30ahNS+P0
	 lqbMnIkZO7PNUDOGG4TlTM8mUw5H4mcdL5oERzG0x+35Eh8LWTJuGbWHvlJBUPUG0A
	 gQEmg/vXFGYYfoaM4NbDX7BFtDSOeuzy3rw6505aIq7+14cS7ofsZWFYlplj30jFWu
	 ycJdg6Jv72NQA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 12/13] selftests/rootns: Add root namespace test suite
Date: Wed, 18 Nov 2026 21:35:38 +0200
Message-ID: <20261118193539.240065-13-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
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

Verify the root namespace and mount-namespace configuration uAPI and
security invariants across privileged, unprivileged, and edge-case
scenarios.

Add a kselftest harness suite under tools/testing/selftests/rootns
exercising rootns creation, ROOTNS_GET_NSFD, clone3(CLONE_INTO_ROOTNS)
init and concurrent bootstrap lifecycle, poll(EPOLLHUP) and
WNOHANG/rusage reporting, unprivileged external FSCONFIG_SET_ROOTNS and
MOVE_MOUNT_T_MNTNS setup without entering a user namespace, hot-mounting
into existing mount namespaces, pivot_root(), and setns() isolation.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 tools/testing/selftests/Makefile          |    1 +
 tools/testing/selftests/rootns/.gitignore |    2 +
 tools/testing/selftests/rootns/Makefile   |    5 +
 tools/testing/selftests/rootns/config     |   10 +
 tools/testing/selftests/rootns/smoke.c    | 1934 +++++++++++++++++++++
 5 files changed, 1952 insertions(+)
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
index 000000000000..21b1aecc003b
--- /dev/null
+++ b/tools/testing/selftests/rootns/config
@@ -0,0 +1,10 @@
+CONFIG_CGROUPS=y
+CONFIG_IPC_NS=y
+CONFIG_NET_NS=y
+CONFIG_PID_NS=y
+CONFIG_PROC_FS=y
+CONFIG_ROOTNS=y
+CONFIG_TIME_NS=y
+CONFIG_TMPFS=y
+CONFIG_USER_NS=y
+CONFIG_UTS_NS=y
diff --git a/tools/testing/selftests/rootns/smoke.c b/tools/testing/selftests/rootns/smoke.c
new file mode 100644
index 000000000000..f0e3158ea4be
--- /dev/null
+++ b/tools/testing/selftests/rootns/smoke.c
@@ -0,0 +1,1934 @@
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
+#include <sys/ioctl.h>
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
+#include <linux/nsfs.h>
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
+#if defined(__alpha__)
+#define __NR_rootns_create 583
+#define __NR_rootns_wait 584
+#define __NR_rootns_kill 585
+#elif defined(__mips__)
+#if defined(_MIPS_SIM) && defined(_MIPS_SIM_ABI32) && _MIPS_SIM == _MIPS_SIM_ABI32
+#define __NR_rootns_create (4000 + 473)
+#define __NR_rootns_wait (4000 + 474)
+#define __NR_rootns_kill (4000 + 475)
+#elif defined(_MIPS_SIM) && defined(_MIPS_SIM_NABI32) && _MIPS_SIM == _MIPS_SIM_NABI32
+#define __NR_rootns_create (6000 + 473)
+#define __NR_rootns_wait (6000 + 474)
+#define __NR_rootns_kill (6000 + 475)
+#else
+#define __NR_rootns_create (5000 + 473)
+#define __NR_rootns_wait (5000 + 474)
+#define __NR_rootns_kill (5000 + 475)
+#endif
+#else
+#define __NR_rootns_create 473
+#define __NR_rootns_wait 474
+#define __NR_rootns_kill 475
+#endif
+#endif
+
+#ifndef MNT_DETACH
+#define MNT_DETACH 2
+#endif
+
+#ifndef AT_RECURSIVE
+#define AT_RECURSIVE 0x8000
+#endif
+
+static int sys_umount2(const char *target, int flags)
+{
+	return syscall(__NR_umount2, target, flags);
+}
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
+static int rootns_get_nsfd(int cfd, unsigned long nstype)
+{
+	return ioctl(cfd, ROOTNS_GET_NSFD, nstype);
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
+	ssize_t n;
+
+	memset(control, 0, sizeof(control));
+	n = recvmsg(sockfd, &msg, 0);
+	if (n <= 0) {
+		if (n == 0)
+			errno = EPROTO;
+		return -1;
+	}
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
+	*cfd = -1;
+	if (socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, sv) < 0)
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
+	if (waitpid(pid, &status, 0) != pid) {
+		if (!err)
+			err = errno;
+	} else if (!err && (!WIFEXITED(status) || WEXITSTATUS(status))) {
+		err = ECHILD;
+	}
+
+	if (err && *cfd >= 0) {
+		close(*cfd);
+		*cfd = -1;
+	}
+
+	return err ? -err : 0;
+}
+
+static int mount_root_with_dirs(int cfd, bool make_dirs)
+{
+	static const char *const dirs[] = { "proc", "mnt", "tmp" };
+	int saved_errno;
+	int mntns_fd;
+	int rootfd;
+	int fsfd;
+	size_t i;
+
+	mntns_fd = rootns_get_nsfd(cfd, CLONE_NEWNS);
+	if (mntns_fd < 0)
+		return -1;
+
+	fsfd = sys_fsopen("tmpfs", 0);
+	if (fsfd < 0)
+		goto err_mntns;
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
+	if (make_dirs) {
+		for (i = 0; i < ARRAY_SIZE(dirs); i++) {
+			if (mkdirat(rootfd, dirs[i], 0755) < 0 &&
+			    errno != EEXIST)
+				goto err_rootfd;
+		}
+	}
+
+	if (sys_move_mount(rootfd, "", mntns_fd, "/",
+			   MOVE_MOUNT_F_EMPTY_PATH | MOVE_MOUNT_T_MNTNS) < 0)
+		goto err_rootfd;
+
+	close(rootfd);
+	close(fsfd);
+	close(mntns_fd);
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
+err_mntns:
+	saved_errno = errno;
+	close(mntns_fd);
+	errno = saved_errno;
+	return -1;
+}
+
+static int mount_root(int cfd)
+{
+	return mount_root_with_dirs(cfd, true);
+}
+
+static int mount_proc(int cfd, bool need_proc)
+{
+	const char *fstype = need_proc ? "proc" : "tmpfs";
+	int saved_errno;
+	int mntns_fd;
+	int fsfd;
+	int mfd;
+
+	mntns_fd = rootns_get_nsfd(cfd, CLONE_NEWNS);
+	if (mntns_fd < 0)
+		return -1;
+
+	fsfd = sys_fsopen(fstype, 0);
+	if (fsfd < 0)
+		goto err_mntns;
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
+	if (sys_move_mount(mfd, "", mntns_fd, "proc",
+			   MOVE_MOUNT_F_EMPTY_PATH | MOVE_MOUNT_T_MNTNS) < 0) {
+		saved_errno = errno;
+		close(mfd);
+		errno = saved_errno;
+		goto err_fsfd;
+	}
+
+	close(mfd);
+	close(fsfd);
+	close(mntns_fd);
+	return 0;
+
+err_fsfd:
+	saved_errno = errno;
+	close(fsfd);
+	errno = saved_errno;
+err_mntns:
+	saved_errno = errno;
+	close(mntns_fd);
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
+static int write_pid_id_maps(pid_t pid, uid_t uid, gid_t gid)
+{
+	char path[64];
+	char map[32];
+	int len;
+	int fd;
+
+	snprintf(path, sizeof(path), "/proc/%d/setgroups", (int)pid);
+	fd = open(path, O_WRONLY | O_CLOEXEC);
+	if (fd >= 0) {
+		(void)write(fd, "deny\n", 5);
+		close(fd);
+	}
+
+	snprintf(path, sizeof(path), "/proc/%d/uid_map", (int)pid);
+	fd = open(path, O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -errno;
+	len = snprintf(map, sizeof(map), "0 %u 1\n", (unsigned int)uid);
+	if (write(fd, map, (size_t)len) != len) {
+		close(fd);
+		return -EIO;
+	}
+	close(fd);
+
+	snprintf(path, sizeof(path), "/proc/%d/gid_map", (int)pid);
+	fd = open(path, O_WRONLY | O_CLOEXEC);
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
+static int drop_to_unpriv_uid(uid_t uid)
+{
+	if (geteuid() == 0) {
+		if (setresgid(uid, uid, uid) < 0 ||
+		    setresuid(uid, uid, uid) < 0 ||
+		    prctl(PR_SET_DUMPABLE, 1, 0, 0, 0) < 0)
+			return -errno;
+	}
+	return 0;
+}
+
+static int enter_unpriv_user_mntns(uid_t drop_uid)
+{
+	char map[32];
+	uid_t uid;
+	gid_t gid;
+	int ret;
+	int fd;
+	int len;
+
+	ret = drop_to_unpriv_uid(drop_uid);
+	if (ret < 0)
+		return ret;
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
+FIXTURE(rootns) {
+	int cfd;
+};
+
+FIXTURE_SETUP(rootns) {
+	self->cfd = create_test_rootns(false, ROOTNS_KILL_ON_CLOSE |
+				       ROOTNS_CLOSE_ON_EXEC);
+	if (self->cfd < 0 && geteuid() != 0 &&
+	    (errno == EPERM || errno == EACCES || errno == EINVAL ||
+	     errno == ENOSPC || errno == EOVERFLOW))
+		SKIP(return, "pre-idmap submount setup requires mapped userns");
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
+	ASSERT_EQ(sys_rootns_create(~ROOTNS_ALL_FLAGS), -1);
+	ASSERT_EQ(errno, EINVAL);
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
+	int go_pipe[2];
+	pid_t pid;
+	int nsfd;
+	int ret;
+
+	nsfd = open("/proc/self/ns/mnt", O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(nsfd, 0);
+	ASSERT_EQ(pipe2(go_pipe, O_CLOEXEC), 0);
+
+	pid = clone_into_rootns(self->cfd, 0);
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		char ch;
+
+		close(self->cfd);
+		close(go_pipe[1]);
+		if (read(go_pipe[0], &ch, 1) != 1)
+			_exit(6);
+		close(go_pipe[0]);
+
+		if (unshare(CLONE_NEWNS))
+			_exit(1);
+		if (clone_with_flags(CLONE_NEWNS))
+			_exit(2);
+		if (clone_with_flags(CLONE_NEWUSER))
+			_exit(3);
+		if (unshare(CLONE_NEWUSER))
+			_exit(4);
+		if (setns(nsfd, CLONE_NEWNS) != -1 || errno != EPERM)
+			_exit(5);
+
+		close(nsfd);
+		_exit(0);
+	}
+	close(go_pipe[0]);
+	close(nsfd);
+
+	ret = write_pid_id_maps(pid, geteuid(), getegid());
+	if (ret < 0) {
+		close(go_pipe[1]);
+		kill_and_reap_pid(pid);
+		ASSERT_EQ(ret, 0);
+	}
+	ASSERT_EQ(write(go_pipe[1], "g", 1), 1);
+	close(go_pipe[1]);
+	ASSERT_EQ(reap_child_exit_code(pid), 0);
+}
+
+TEST_F(rootns, setns_same) {
+	unsigned int flags = ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC;
+	ssize_t nwritten;
+	pid_t pid1;
+	pid_t pid2;
+	char ch;
+	int nsfd;
+	int cfd;
+	int sv[2];
+
+	cfd = create_test_rootns(true, flags);
+	ASSERT_GE(cfd, 0);
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, sv), 0);
+
+	pid1 = clone_into_rootns(cfd, 0);
+	ASSERT_GE(pid1, 0);
+	if (pid1 == 0) {
+		int ret;
+
+		close(self->cfd);
+		close(cfd);
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
+	pid2 = clone_into_rootns(cfd, 0);
+	ASSERT_GE(pid2, 0);
+	if (pid2 == 0) {
+		int ret;
+
+		close(self->cfd);
+		close(cfd);
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
+	close(cfd);
+}
+
+TEST_F(rootns, setns_foreign) {
+	unsigned int flags = ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC;
+	ssize_t nwritten;
+	int alpha_cfd;
+	int beta_cfd;
+	pid_t alpha_pid;
+	pid_t beta_pid;
+	char ch;
+	int nsfd;
+	int sv[2];
+
+	alpha_cfd = create_test_rootns(true, flags);
+	ASSERT_GE(alpha_cfd, 0);
+
+	beta_cfd = create_test_rootns(true, flags);
+	ASSERT_GE(beta_cfd, 0);
+
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, sv), 0);
+
+	beta_pid = clone_into_rootns(beta_cfd, 0);
+	ASSERT_GE(beta_pid, 0);
+	if (beta_pid == 0) {
+		int ret;
+
+		close(self->cfd);
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
+		close(self->cfd);
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
+	cfd = create_test_rootns(true, ROOTNS_KILL_ON_CLOSE |
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
+		close(self->cfd);
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
+	unsigned int flags = ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC;
+	int ready_pipe[2];
+	int hold_pipe[2];
+	int go_pipe[2];
+	pid_t pid2;
+	char ch;
+	int cfd;
+	pid_t pid;
+	int ret;
+
+	cfd = create_test_rootns(false, flags);
+	ASSERT_GE(cfd, 0);
+	ASSERT_EQ(pipe2(go_pipe, O_CLOEXEC), 0);
+	ASSERT_EQ(pipe2(ready_pipe, O_CLOEXEC), 0);
+	ASSERT_EQ(pipe2(hold_pipe, O_CLOEXEC), 0);
+
+	pid = clone_into_rootns(cfd, 0);
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		int marker_fd;
+		int fsfd;
+		int mfd;
+		int nsfd;
+
+		close(self->cfd);
+		close(cfd);
+		close(go_pipe[1]);
+		close(ready_pipe[0]);
+		close(hold_pipe[1]);
+
+		if (read(go_pipe[0], &ch, 1) != 1)
+			_exit(13);
+		close(go_pipe[0]);
+
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
+		marker_fd = openat(mfd, "pivoted",
+				   O_CREAT | O_WRONLY | O_CLOEXEC, 0644);
+		if (marker_fd < 0)
+			_exit(5);
+		close(marker_fd);
+		if (sys_move_mount(mfd, "", AT_FDCWD, "/mnt",
+				   MOVE_MOUNT_F_EMPTY_PATH) < 0)
+			_exit(6);
+		close(mfd);
+
+		if (chdir("/mnt") < 0)
+			_exit(7);
+		if (sys_pivot_root(".", "old") < 0)
+			_exit(8);
+		if (sys_umount2("/old", MNT_DETACH) < 0)
+			_exit(9);
+
+		nsfd = sys_open_tree(AT_FDCWD, "/",
+				     OPEN_TREE_NAMESPACE | OPEN_TREE_CLOEXEC);
+		if (nsfd < 0)
+			_exit(10);
+		if (setns(nsfd, CLONE_NEWNS) < 0)
+			_exit(11);
+		close(nsfd);
+
+		if (write(ready_pipe[1], "r", 1) != 1)
+			_exit(12);
+		close(ready_pipe[1]);
+		(void)read(hold_pipe[0], &ch, 1);
+		close(hold_pipe[0]);
+		_exit(0);
+	}
+	close(go_pipe[0]);
+	close(ready_pipe[1]);
+	close(hold_pipe[0]);
+
+	ret = write_pid_id_maps(pid, geteuid(), getegid());
+	if (ret < 0) {
+		close(go_pipe[1]);
+		close(ready_pipe[0]);
+		close(hold_pipe[1]);
+		kill_and_reap_pid(pid);
+		close(cfd);
+		ASSERT_EQ(ret, 0);
+	}
+	ASSERT_EQ(write(go_pipe[1], "g", 1), 1);
+	close(go_pipe[1]);
+
+	ASSERT_EQ(read(ready_pipe[0], &ch, 1), 1);
+	close(ready_pipe[0]);
+
+	pid2 = clone_into_rootns(cfd, 0);
+	ASSERT_GE(pid2, 0);
+	if (pid2 == 0) {
+		close(self->cfd);
+		close(cfd);
+		close(hold_pipe[1]);
+		if (access("/pivoted", F_OK) < 0)
+			_exit(1);
+		_exit(0);
+	}
+	ASSERT_EQ(reap_child_exit_code(pid2), 0);
+
+	close(hold_pipe[1]);
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
+	cfd = create_test_rootns(false, ROOTNS_KILL_ON_CLOSE);
+	ASSERT_GE(cfd, 0);
+
+	pid = clone_into_rootns(cfd, 0);
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		close(self->cfd);
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
+TEST_F(rootns, mount_perms) {
+	int mntns_fd = -1;
+	int cfd = -1;
+	int rootfsfd;
+	pid_t pid;
+	int mfd;
+	int ret;
+
+	ret = create_rootns_as_uid(1000, ROOTNS_CLOSE_ON_EXEC, &cfd);
+	if (ret == -EPERM || ret == -EACCES || ret == -EINVAL)
+		SKIP(return, "unprivileged rootns creation is unavailable");
+	ASSERT_EQ(ret, 0);
+
+	mntns_fd = rootns_get_nsfd(cfd, CLONE_NEWNS);
+	ASSERT_GE(mntns_fd, 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		int u_fsfd;
+		int u_mfd;
+
+		close(self->cfd);
+		ret = enter_unpriv_user_mntns(2000);
+		if (ret == -EPERM || ret == -EACCES || ret == -EINVAL ||
+		    ret == -ENOSPC)
+			_exit(0);
+		if (ret < 0)
+			_exit(1);
+
+		if (rootns_get_nsfd(cfd, CLONE_NEWNS) != -1 || errno != EPERM)
+			_exit(2);
+
+		u_fsfd = sys_fsopen("tmpfs", 0);
+		if (u_fsfd < 0)
+			_exit(3);
+		if (sys_fsconfig(u_fsfd, FSCONFIG_SET_ROOTNS, NULL, NULL,
+				 cfd) != -1 || errno != EPERM)
+			_exit(4);
+		if (sys_fsconfig(u_fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0) < 0)
+			_exit(5);
+
+		u_mfd = sys_fsmount(u_fsfd, 0, 0);
+		if (u_mfd < 0)
+			_exit(6);
+		if (sys_move_mount(u_mfd, "", mntns_fd, "/",
+				   MOVE_MOUNT_F_EMPTY_PATH |
+				   MOVE_MOUNT_T_MNTNS) != -1 ||
+		    errno != EPERM)
+			_exit(7);
+
+		close(u_mfd);
+		close(u_fsfd);
+		close(mntns_fd);
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
+			close(self->cfd);
+			if (setresgid(1000, 1000, 1000) < 0 ||
+			    setresuid(1000, 1000, 1000) < 0)
+				_exit(1);
+			if (sys_move_mount(mfd, "", mntns_fd, "/",
+					   MOVE_MOUNT_F_EMPTY_PATH |
+					   MOVE_MOUNT_T_MNTNS) < 0)
+				_exit(2);
+			close(mfd);
+			close(mntns_fd);
+			close(cfd);
+			_exit(0);
+		}
+		close(mfd);
+		ASSERT_EQ(reap_child_exit_code(pid), 0);
+	}
+
+	close(mntns_fd);
+	close(cfd);
+}
+
+TEST_F(rootns, mount_attached) {
+	int mntns_fd;
+	int cfd;
+
+	cfd = sys_rootns_create(ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC);
+	ASSERT_GE(cfd, 0);
+
+	mntns_fd = rootns_get_nsfd(cfd, CLONE_NEWNS);
+	ASSERT_GE(mntns_fd, 0);
+
+	ASSERT_EQ(sys_move_mount(AT_FDCWD, "/", mntns_fd, "/",
+				 MOVE_MOUNT_T_MNTNS), -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	/* Passing rootnsfd instead of mnt_ns fd must also be rejected. */
+	ASSERT_EQ(sys_move_mount(AT_FDCWD, "/", cfd, "/",
+				 MOVE_MOUNT_T_MNTNS), -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	close(mntns_fd);
+	close(cfd);
+}
+
+TEST_F(rootns, mount_empty_path) {
+	int mntns_fd;
+	int cfd;
+	int mfd;
+
+	cfd = sys_rootns_create(ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC);
+	ASSERT_GE(cfd, 0);
+
+	mntns_fd = rootns_get_nsfd(cfd, CLONE_NEWNS);
+	ASSERT_GE(mntns_fd, 0);
+
+	mfd = sys_open_tree(AT_FDCWD, "/", OPEN_TREE_CLONE | AT_RECURSIVE);
+	ASSERT_GE(mfd, 0);
+
+	ASSERT_EQ(sys_move_mount(mfd, "", mntns_fd, "",
+				 MOVE_MOUNT_F_EMPTY_PATH |
+				 MOVE_MOUNT_T_MNTNS), -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	close(mfd);
+	close(mntns_fd);
+	close(cfd);
+}
+
+TEST_F(rootns, clone_perms) {
+	pid_t pid;
+	int cfd;
+
+	cfd = sys_rootns_create(ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC);
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
+		int ret;
+
+		close(self->cfd);
+		ret = enter_unpriv_user_mntns(2000);
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
+		close(self->cfd);
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
+	cfd = sys_rootns_create(ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC);
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
+	cfd = sys_rootns_create(ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC);
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
+		int mfd;
+		int tfd;
+		int rfd;
+		int ret;
+
+		close(self->cfd);
+		ret = drop_to_unpriv_uid(1000);
+		if (ret == -EINVAL)
+			_exit(0);
+		if (ret < 0)
+			_exit(1);
+
+		ucfd = sys_rootns_create(ROOTNS_CLOSE_ON_EXEC);
+		if (ucfd < 0) {
+			if (errno == EPERM || errno == EACCES ||
+			    errno == EINVAL || errno == ENOSPC)
+				_exit(0);
+			_exit(2);
+		}
+
+		tfd = sys_fsopen("tmpfs", 0);
+		if (tfd < 0)
+			_exit(3);
+		if (sys_fsconfig(tfd, FSCONFIG_SET_ROOTNS, NULL, NULL, ucfd) < 0)
+			_exit(4);
+		if (sys_fsconfig(tfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0) < 0)
+			_exit(5);
+		mfd = sys_fsmount(tfd, 0, 0);
+		if (mfd < 0)
+			_exit(6);
+		close(mfd);
+		close(tfd);
+
+		rfd = sys_fsopen("devtmpfs", 0);
+		if (rfd < 0) {
+			if (errno == ENODEV || errno == EPERM) {
+				close(ucfd);
+				_exit(0);
+			}
+			_exit(7);
+		}
+		if (sys_fsconfig(rfd, FSCONFIG_SET_ROOTNS, NULL, NULL, ucfd) < 0)
+			_exit(8);
+		if (sys_fsconfig(rfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0) != -1 ||
+		    errno != EPERM)
+			_exit(9);
+
+		close(rfd);
+		close(ucfd);
+		_exit(0);
+	}
+
+	ASSERT_EQ(reap_child_exit_code(pid), 0);
+}
+
+TEST_F(rootns, clone_concurrent) {
+	unsigned int seen_mask = 0;
+	int init_hold_pipe[2];
+	int peer_hold_pipe[2];
+	int init_worker = -1;
+	int start_pipe[2];
+	int ready_pipe[2];
+	pid_t workers[4];
+	int status = 0;
+	int i;
+
+	ASSERT_EQ(pipe2(start_pipe, O_CLOEXEC), 0);
+	ASSERT_EQ(pipe2(ready_pipe, O_CLOEXEC), 0);
+	ASSERT_EQ(pipe2(init_hold_pipe, O_CLOEXEC), 0);
+	ASSERT_EQ(pipe2(peer_hold_pipe, O_CLOEXEC), 0);
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
+			close(init_hold_pipe[1]);
+			close(peer_hold_pipe[1]);
+
+			(void)read(start_pipe[0], &ch, 1);
+			close(start_pipe[0]);
+
+			ent_pid = clone_into_rootns(self->cfd, 0);
+			if (ent_pid < 0)
+				_exit(1);
+			if (ent_pid == 0) {
+				unsigned char msg[2] = {
+					(unsigned char)i,
+					(unsigned char)getpid(),
+				};
+				int hold_fd = (msg[1] == 1) ?
+					      init_hold_pipe[0] :
+					      peer_hold_pipe[0];
+
+				close(self->cfd);
+				if (write(ready_pipe[1], msg, sizeof(msg)) !=
+				    (ssize_t)sizeof(msg))
+					_exit(2);
+				close(ready_pipe[1]);
+				(void)read(hold_fd, &ch, 1);
+				close(init_hold_pipe[0]);
+				close(peer_hold_pipe[0]);
+				_exit(0);
+			}
+
+			close(ready_pipe[1]);
+			close(init_hold_pipe[0]);
+			close(peer_hold_pipe[0]);
+			close(self->cfd);
+			_exit(reap_child_exit_code(ent_pid) == 0 ? 0 : 3);
+		}
+	}
+
+	close(start_pipe[0]);
+	close(ready_pipe[1]);
+	close(init_hold_pipe[0]);
+	close(peer_hold_pipe[0]);
+	close(start_pipe[1]);
+
+	for (i = 0; i < 4; i++) {
+		unsigned char msg[2] = { 0, 0 };
+
+		ASSERT_EQ(read(ready_pipe[0], msg, sizeof(msg)),
+			  (ssize_t)sizeof(msg));
+		ASSERT_LT(msg[0], 4);
+		ASSERT_GE(msg[1], 1);
+		ASSERT_LE(msg[1], 4);
+		if (msg[1] == 1)
+			init_worker = (int)msg[0];
+		seen_mask |= 1U << msg[1];
+	}
+	close(ready_pipe[0]);
+	ASSERT_EQ(seen_mask, 0x1eU);
+	ASSERT_GE(init_worker, 0);
+
+	close(peer_hold_pipe[1]);
+	for (i = 0; i < 4; i++) {
+		if (i != init_worker)
+			ASSERT_EQ(reap_child_exit_code(workers[i]), 0);
+	}
+
+	close(init_hold_pipe[1]);
+	ASSERT_EQ(reap_child_exit_code(workers[init_worker]), 0);
+
+	ASSERT_GT(sys_rootns_wait(self->cfd, &status, 0, NULL), 0);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+}
+
+TEST_F(rootns, move_mount_existing_mntns) {
+	int ready_pipe[2];
+	int hold_pipe[2];
+	char path[64];
+	int marker_fd;
+	int mntns_fd;
+	char ch;
+	pid_t pid;
+	int fsfd;
+	int mfd;
+
+	ASSERT_EQ(pipe2(ready_pipe, O_CLOEXEC), 0);
+	ASSERT_EQ(pipe2(hold_pipe, O_CLOEXEC), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		struct statfs st;
+
+		close(self->cfd);
+		close(ready_pipe[0]);
+		close(hold_pipe[1]);
+
+		if (unshare(CLONE_NEWNS) < 0)
+			_exit(1);
+		if (write(ready_pipe[1], "r", 1) != 1)
+			_exit(2);
+		close(ready_pipe[1]);
+
+		if (read(hold_pipe[0], &ch, 1) != 1)
+			_exit(3);
+		close(hold_pipe[0]);
+
+		if (statfs("/tmp", &st) < 0)
+			_exit(4);
+		if ((unsigned long)st.f_type != (unsigned long)TMPFS_MAGIC)
+			_exit(5);
+		if (access("/tmp/hot_mounted", F_OK) < 0)
+			_exit(6);
+		_exit(0);
+	}
+	close(ready_pipe[1]);
+	close(hold_pipe[0]);
+
+	ASSERT_EQ(read(ready_pipe[0], &ch, 1), 1);
+	close(ready_pipe[0]);
+
+	snprintf(path, sizeof(path), "/proc/%d/ns/mnt", (int)pid);
+	mntns_fd = open(path, O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(mntns_fd, 0);
+
+	fsfd = sys_fsopen("tmpfs", 0);
+	ASSERT_GE(fsfd, 0);
+	ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0), 0);
+	mfd = sys_fsmount(fsfd, 0, 0);
+	close(fsfd);
+	ASSERT_GE(mfd, 0);
+
+	marker_fd = openat(mfd, "hot_mounted",
+			   O_CREAT | O_WRONLY | O_CLOEXEC, 0644);
+	ASSERT_GE(marker_fd, 0);
+	close(marker_fd);
+
+	/* Existing mnt_ns already has "/", so "/" must fail with EBUSY. */
+	ASSERT_EQ(sys_move_mount(mfd, "", mntns_fd, "/",
+				 MOVE_MOUNT_F_EMPTY_PATH |
+				 MOVE_MOUNT_T_MNTNS), -1);
+	ASSERT_EQ(errno, EBUSY);
+
+	/* Hot-mounting onto a relative path inside the live mnt_ns succeeds. */
+	ASSERT_EQ(sys_move_mount(mfd, "", mntns_fd, "tmp",
+				 MOVE_MOUNT_F_EMPTY_PATH |
+				 MOVE_MOUNT_T_MNTNS), 0);
+	close(mfd);
+	close(mntns_fd);
+
+	ASSERT_EQ(write(hold_pipe[1], "g", 1), 1);
+	close(hold_pipe[1]);
+	ASSERT_EQ(reap_child_exit_code(pid), 0);
+}
+
+TEST(get_nsfd) {
+	static const unsigned long nstypes[] = {
+		CLONE_NEWNS,
+		CLONE_NEWCGROUP,
+		CLONE_NEWUTS,
+		CLONE_NEWIPC,
+		CLONE_NEWUSER,
+		CLONE_NEWNET,
+		CLONE_NEWTIME,
+	};
+	int hold_pipe[2];
+	int nsfd;
+	pid_t pid;
+	size_t i;
+	int cfd;
+
+	cfd = sys_rootns_create(ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC);
+	if (cfd < 0 && geteuid() != 0 &&
+	    (errno == EPERM || errno == EACCES ||
+	     errno == EINVAL || errno == ENOSPC))
+		SKIP(return, "unprivileged rootns creation is unavailable");
+	ASSERT_GE(cfd, 0);
+
+	ASSERT_EQ(rootns_get_nsfd(cfd, 0), -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	/* CLONE_NEWPID requires init to be running. */
+	ASSERT_EQ(rootns_get_nsfd(cfd, CLONE_NEWPID), -1);
+	ASSERT_EQ(errno, ESRCH);
+
+	for (i = 0; i < ARRAY_SIZE(nstypes); i++) {
+		int type;
+
+		nsfd = rootns_get_nsfd(cfd, nstypes[i]);
+		if (nstypes[i] == CLONE_NEWTIME && nsfd < 0 &&
+		    errno == EOPNOTSUPP)
+			continue;
+		ASSERT_GE(nsfd, 0);
+		type = ioctl(nsfd, NS_GET_NSTYPE);
+		ASSERT_EQ((unsigned long)type, nstypes[i]);
+		close(nsfd);
+	}
+
+	ASSERT_EQ(mount_root_with_dirs(cfd, false), 0);
+	ASSERT_EQ(pipe2(hold_pipe, O_CLOEXEC), 0);
+
+	pid = clone_into_rootns(cfd, 0);
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		char ch;
+
+		close(cfd);
+		close(hold_pipe[1]);
+		(void)read(hold_pipe[0], &ch, 1);
+		close(hold_pipe[0]);
+		_exit(0);
+	}
+	close(hold_pipe[0]);
+
+	nsfd = rootns_get_nsfd(cfd, CLONE_NEWPID);
+	ASSERT_GE(nsfd, 0);
+	ASSERT_EQ(ioctl(nsfd, NS_GET_NSTYPE), CLONE_NEWPID);
+	close(nsfd);
+
+	close(hold_pipe[1]);
+	ASSERT_EQ(reap_child_exit_code(pid), 0);
+	close(cfd);
+}
+
+TEST(unpriv_no_userns) {
+	pid_t worker;
+
+	worker = fork();
+	ASSERT_GE(worker, 0);
+	if (worker == 0) {
+		int ready_pipe[2];
+		int go_pipe[2];
+		int status = 0;
+		pid_t pid;
+		char ch;
+		int tfd;
+		int cfd;
+		int ret;
+
+		ret = drop_to_unpriv_uid(1000);
+		if (ret == -EINVAL)
+			_exit(0);
+		if (ret < 0)
+			_exit(1);
+
+		/* Without FSCONFIG_SET_ROOTNS, unprivileged fsconfig fails. */
+		tfd = sys_fsopen("tmpfs", 0);
+		if (tfd >= 0) {
+			if (sys_fsconfig(tfd, FSCONFIG_CMD_CREATE, NULL, NULL,
+					 0) != -1 || errno != EPERM)
+				_exit(2);
+			close(tfd);
+		} else if (errno != EPERM) {
+			_exit(3);
+		}
+
+		cfd = sys_rootns_create(ROOTNS_KILL_ON_CLOSE |
+					ROOTNS_CLOSE_ON_EXEC);
+		if (cfd < 0) {
+			if (errno == EPERM || errno == EACCES ||
+			    errno == EINVAL || errno == ENOSPC)
+				_exit(0);
+			_exit(4);
+		}
+
+		if (mount_root_with_dirs(cfd, false) < 0)
+			_exit(5);
+
+		if (pipe2(go_pipe, O_CLOEXEC) < 0 ||
+		    pipe2(ready_pipe, O_CLOEXEC) < 0)
+			_exit(6);
+
+		pid = clone_into_rootns(cfd, 0);
+		if (pid < 0)
+			_exit(7);
+		if (pid == 0) {
+			struct statfs st;
+			char target[32];
+			ssize_t len;
+
+			close(cfd);
+			close(go_pipe[1]);
+			close(ready_pipe[0]);
+
+			if (read(go_pipe[0], &ch, 1) != 1)
+				_exit(1);
+			if (mkdir("/proc", 0755) < 0)
+				_exit(2);
+			if (write(ready_pipe[1], "m", 1) != 1)
+				_exit(3);
+			close(ready_pipe[1]);
+
+			if (read(go_pipe[0], &ch, 1) != 1)
+				_exit(4);
+			close(go_pipe[0]);
+
+			if (getpid() != 1 || geteuid() != 0)
+				_exit(5);
+			if (statfs("/proc", &st) < 0 ||
+			    (unsigned long)st.f_type !=
+			    (unsigned long)PROC_SUPER_MAGIC)
+				_exit(6);
+			len = readlink("/proc/self", target,
+				       sizeof(target) - 1);
+			if (len <= 0)
+				_exit(7);
+			target[len] = '\0';
+			if (strcmp(target, "1") != 0)
+				_exit(8);
+			_exit(0);
+		}
+		close(go_pipe[0]);
+		close(ready_pipe[1]);
+
+		if (write_pid_id_maps(pid, geteuid(), getegid()) < 0) {
+			kill_and_reap_pid(pid);
+			_exit(8);
+		}
+		if (write(go_pipe[1], "1", 1) != 1) {
+			kill_and_reap_pid(pid);
+			_exit(9);
+		}
+		if (read(ready_pipe[0], &ch, 1) != 1) {
+			kill_and_reap_pid(pid);
+			_exit(10);
+		}
+		close(ready_pipe[0]);
+
+		/* Hot-mount proc from unprivileged host process (no unshare). */
+		if (mount_proc(cfd, true) < 0) {
+			kill_and_reap_pid(pid);
+			_exit(11);
+		}
+
+		if (write(go_pipe[1], "2", 1) != 1) {
+			kill_and_reap_pid(pid);
+			_exit(12);
+		}
+		close(go_pipe[1]);
+
+		if (sys_rootns_wait(cfd, &status, 0, NULL) != pid ||
+		    !WIFEXITED(status) || WEXITSTATUS(status) != 0)
+			_exit(13);
+		if (reap_child_exit_code(pid) != 0)
+			_exit(14);
+
+		close(cfd);
+		_exit(0);
+	}
+
+	ASSERT_EQ(reap_child_exit_code(worker), 0);
+}
+
+TEST_HARNESS_MAIN
-- 
2.47.3

