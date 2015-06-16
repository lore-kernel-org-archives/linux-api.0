From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] selftests: add seccomp suite
Date: Tue, 16 Jun 2015 10:54:14 -0700
Message-ID: <20150616175414.GA24958@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, Shuah Khan <shuahkh@osg.samsung.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jingoo Han <jingoohan1@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This imports the existing seccomp test suite into the kernel's selftests
tree. It contains extensive testing of seccomp features and corner cases.
There remain additional tests to move into the kernel tree, but they have
not yet been ported to all the architectures seccomp supports:
https://github.com/redpig/seccomp/tree/master/tests

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 MAINTAINERS                                    |    1 +
 tools/testing/selftests/Makefile               |    1 +
 tools/testing/selftests/seccomp/.gitignore     |    1 +
 tools/testing/selftests/seccomp/Makefile       |   10 +
 tools/testing/selftests/seccomp/seccomp_bpf.c  | 2109 ++++++++++++++++++++++++
 tools/testing/selftests/seccomp/test_harness.h |  537 ++++++
 6 files changed, 2659 insertions(+)
 create mode 100644 tools/testing/selftests/seccomp/.gitignore
 create mode 100644 tools/testing/selftests/seccomp/Makefile
 create mode 100644 tools/testing/selftests/seccomp/seccomp_bpf.c
 create mode 100644 tools/testing/selftests/seccomp/test_harness.h

diff --git a/MAINTAINERS b/MAINTAINERS
index d8afd2953678..6b030c6251c2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8774,6 +8774,7 @@ S:	Supported
 F:	kernel/seccomp.c
 F:	include/uapi/linux/seccomp.h
 F:	include/linux/seccomp.h
+F:	tools/testing/selftests/seccomp/*
 K:	\bsecure_computing
 K:	\bTIF_SECCOMP\b
 
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 95abddcd7839..eb9f14d33c03 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -12,6 +12,7 @@ TARGETS += mqueue
 TARGETS += net
 TARGETS += powerpc
 TARGETS += ptrace
+TARGETS += seccomp
 TARGETS += size
 TARGETS += sysctl
 TARGETS += timers
diff --git a/tools/testing/selftests/seccomp/.gitignore b/tools/testing/selftests/seccomp/.gitignore
new file mode 100644
index 000000000000..346d83ca8069
--- /dev/null
+++ b/tools/testing/selftests/seccomp/.gitignore
@@ -0,0 +1 @@
+seccomp_bpf
diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
new file mode 100644
index 000000000000..8401e87e34e1
--- /dev/null
+++ b/tools/testing/selftests/seccomp/Makefile
@@ -0,0 +1,10 @@
+TEST_PROGS := seccomp_bpf
+CFLAGS += -Wl,-no-as-needed -Wall
+LDFLAGS += -lpthread
+
+all: $(TEST_PROGS)
+
+include ../lib.mk
+
+clean:
+	$(RM) $(TEST_PROGS)
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
new file mode 100644
index 000000000000..c5abe7fd7590
--- /dev/null
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -0,0 +1,2109 @@
+/*
+ * Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
+ * Use of this source code is governed by the GPLv2 license.
+ *
+ * Test code for seccomp bpf.
+ */
+
+#include <asm/siginfo.h>
+#define __have_siginfo_t 1
+#define __have_sigval_t 1
+#define __have_sigevent_t 1
+
+#include <errno.h>
+#include <linux/filter.h>
+#include <sys/prctl.h>
+#include <sys/ptrace.h>
+#include <sys/user.h>
+#include <linux/prctl.h>
+#include <linux/ptrace.h>
+#include <linux/seccomp.h>
+#include <poll.h>
+#include <pthread.h>
+#include <semaphore.h>
+#include <signal.h>
+#include <stddef.h>
+#include <stdbool.h>
+#include <string.h>
+#include <linux/elf.h>
+#include <sys/uio.h>
+
+#define _GNU_SOURCE
+#include <unistd.h>
+#include <sys/syscall.h>
+
+#include "test_harness.h"
+
+#ifndef PR_SET_PTRACER
+# define PR_SET_PTRACER 0x59616d61
+#endif
+
+#ifndef PR_SET_NO_NEW_PRIVS
+#define PR_SET_NO_NEW_PRIVS 38
+#define PR_GET_NO_NEW_PRIVS 39
+#endif
+
+#ifndef PR_SECCOMP_EXT
+#define PR_SECCOMP_EXT 43
+#endif
+
+#ifndef SECCOMP_EXT_ACT
+#define SECCOMP_EXT_ACT 1
+#endif
+
+#ifndef SECCOMP_EXT_ACT_TSYNC
+#define SECCOMP_EXT_ACT_TSYNC 1
+#endif
+
+#ifndef SECCOMP_MODE_STRICT
+#define SECCOMP_MODE_STRICT 1
+#endif
+
+#ifndef SECCOMP_MODE_FILTER
+#define SECCOMP_MODE_FILTER 2
+#endif
+
+#ifndef SECCOMP_RET_KILL
+#define SECCOMP_RET_KILL        0x00000000U /* kill the task immediately */
+#define SECCOMP_RET_TRAP        0x00030000U /* disallow and force a SIGSYS */
+#define SECCOMP_RET_ERRNO       0x00050000U /* returns an errno */
+#define SECCOMP_RET_TRACE       0x7ff00000U /* pass to a tracer or disallow */
+#define SECCOMP_RET_ALLOW       0x7fff0000U /* allow */
+
+/* Masks for the return value sections. */
+#define SECCOMP_RET_ACTION      0x7fff0000U
+#define SECCOMP_RET_DATA        0x0000ffffU
+
+struct seccomp_data {
+	int nr;
+	__u32 arch;
+	__u64 instruction_pointer;
+	__u64 args[6];
+};
+#endif
+
+#define syscall_arg(_n) (offsetof(struct seccomp_data, args[_n]))
+
+#define SIBLING_EXIT_UNKILLED	0xbadbeef
+#define SIBLING_EXIT_FAILURE	0xbadface
+#define SIBLING_EXIT_NEWPRIVS	0xbadfeed
+
+TEST(mode_strict_support)
+{
+	long ret;
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_STRICT, NULL, NULL, NULL);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support CONFIG_SECCOMP");
+	}
+	syscall(__NR_exit, 1);
+}
+
+TEST_SIGNAL(mode_strict_cannot_call_prctl, SIGKILL)
+{
+	long ret;
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_STRICT, NULL, NULL, NULL);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support CONFIG_SECCOMP");
+	}
+	syscall(__NR_prctl, PR_SET_SECCOMP, SECCOMP_MODE_FILTER,
+		NULL, NULL, NULL);
+	EXPECT_FALSE(true) {
+		TH_LOG("Unreachable!");
+	}
+}
+
+/* Note! This doesn't test no new privs behavior */
+TEST(no_new_privs_support)
+{
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	EXPECT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+}
+
+/* Tests kernel support by checking for a copy_from_user() fault on * NULL. */
+TEST(mode_filter_support)
+{
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, NULL, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, NULL, NULL, NULL);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(EFAULT, errno) {
+		TH_LOG("Kernel does not support CONFIG_SECCOMP_FILTER!");
+	}
+}
+
+TEST(mode_filter_without_nnp)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+
+	ret = prctl(PR_GET_NO_NEW_PRIVS, 0, NULL, 0, 0);
+	ASSERT_LE(0, ret) {
+		TH_LOG("Expected 0 or unsupported for NO_NEW_PRIVS");
+	}
+	errno = 0;
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog, 0, 0);
+	/* Succeeds with CAP_SYS_ADMIN, fails without */
+	/* TODO(wad) check caps not euid */
+	if (geteuid()) {
+		EXPECT_EQ(-1, ret);
+		EXPECT_EQ(EACCES, errno);
+	} else {
+		EXPECT_EQ(0, ret);
+	}
+}
+
+#define MAX_INSNS_PER_PATH 32768
+
+TEST(filter_size_limits)
+{
+	int i;
+	int count = BPF_MAXINSNS + 1;
+	struct sock_filter allow[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_filter *filter;
+	struct sock_fprog prog = { };
+	long ret;
+
+	filter = calloc(count, sizeof(*filter));
+	ASSERT_NE(NULL, filter);
+
+	for (i = 0; i < count; i++)
+		filter[i] = allow[0];
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	prog.filter = filter;
+	prog.len = count;
+
+	/* Too many filter instructions in a single filter. */
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog, 0, 0);
+	ASSERT_NE(0, ret) {
+		TH_LOG("Installing %d insn filter was allowed", prog.len);
+	}
+
+	/* One less is okay, though. */
+	prog.len -= 1;
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Installing %d insn filter wasn't allowed", prog.len);
+	}
+}
+
+TEST(filter_chain_limits)
+{
+	int i;
+	int count = BPF_MAXINSNS;
+	struct sock_filter allow[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_filter *filter;
+	struct sock_fprog prog = { };
+	long ret;
+
+	filter = calloc(count, sizeof(*filter));
+	ASSERT_NE(NULL, filter);
+
+	for (i = 0; i < count; i++)
+		filter[i] = allow[0];
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	prog.filter = filter;
+	prog.len = 1;
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	prog.len = count;
+
+	/* Too many total filter instructions. */
+	for (i = 0; i < MAX_INSNS_PER_PATH; i++) {
+		ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog, 0, 0);
+		if (ret != 0)
+			break;
+	}
+	ASSERT_NE(0, ret) {
+		TH_LOG("Allowed %d %d-insn filters (total with penalties:%d)",
+		       i, count, i * (count + 4));
+	}
+}
+
+TEST(mode_filter_cannot_move_to_strict)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_STRICT, NULL, 0, 0);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(EINVAL, errno);
+}
+
+
+TEST(mode_filter_get_seccomp)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_GET_SECCOMP, 0, 0, 0, 0);
+	EXPECT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_GET_SECCOMP, 0, 0, 0, 0);
+	EXPECT_EQ(2, ret);
+}
+
+
+TEST(ALLOW_all)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	ASSERT_EQ(0, ret);
+}
+
+TEST(empty_prog)
+{
+	struct sock_filter filter[] = {
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(EINVAL, errno);
+}
+
+TEST_SIGNAL(unknown_ret_is_kill_inside, SIGSYS)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_RET|BPF_K, 0x10000000U),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	ASSERT_EQ(0, ret);
+	EXPECT_EQ(0, syscall(__NR_getpid)) {
+		TH_LOG("getpid() shouldn't ever return");
+	}
+}
+
+/* return code >= 0x80000000 is unused. */
+TEST_SIGNAL(unknown_ret_is_kill_above_allow, SIGSYS)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_RET|BPF_K, 0x90000000U),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	ASSERT_EQ(0, ret);
+	EXPECT_EQ(0, syscall(__NR_getpid)) {
+		TH_LOG("getpid() shouldn't ever return");
+	}
+}
+
+TEST_SIGNAL(KILL_all, SIGSYS)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	ASSERT_EQ(0, ret);
+}
+
+TEST_SIGNAL(KILL_one, SIGSYS)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+	pid_t parent = getppid();
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	ASSERT_EQ(0, ret);
+
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	/* getpid() should never return. */
+	EXPECT_EQ(0, syscall(__NR_getpid));
+}
+
+TEST_SIGNAL(KILL_one_arg_one, SIGSYS)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 1, 0),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+		/* Only both with lower 32-bit for now. */
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS, syscall_arg(0)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0x0C0FFEE, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+	pid_t parent = getppid();
+	pid_t pid = getpid();
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	ASSERT_EQ(0, ret);
+
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	EXPECT_EQ(pid, syscall(__NR_getpid));
+	/* getpid() should never return. */
+	EXPECT_EQ(0, syscall(__NR_getpid, 0x0C0FFEE));
+}
+
+TEST_SIGNAL(KILL_one_arg_six, SIGSYS)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 1, 0),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+		/* Only both with lower 32-bit for now. */
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS, syscall_arg(5)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, 0x0C0FFEE, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+	pid_t parent = getppid();
+	pid_t pid = getpid();
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	ASSERT_EQ(0, ret);
+
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	EXPECT_EQ(pid, syscall(__NR_getpid));
+	/* getpid() should never return. */
+	EXPECT_EQ(0, syscall(__NR_getpid, 1, 2, 3, 4, 5, 0x0C0FFEE));
+}
+
+/* TODO(wad) add 64-bit versus 32-bit arg tests. */
+TEST(arg_out_of_range)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS, syscall_arg(6)),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(EINVAL, errno);
+}
+
+TEST(ERRNO_valid)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ERRNO | E2BIG),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+	pid_t parent = getppid();
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	ASSERT_EQ(0, ret);
+
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	EXPECT_EQ(-1, read(0, NULL, 0));
+	EXPECT_EQ(E2BIG, errno);
+}
+
+TEST(ERRNO_zero)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ERRNO | 0),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+	pid_t parent = getppid();
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	ASSERT_EQ(0, ret);
+
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	/* "errno" of 0 is ok. */
+	EXPECT_EQ(0, read(0, NULL, 0));
+}
+
+TEST(ERRNO_capped)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ERRNO | 4096),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+	pid_t parent = getppid();
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
+	ASSERT_EQ(0, ret);
+
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	EXPECT_EQ(-1, read(0, NULL, 0));
+	EXPECT_EQ(4095, errno);
+}
+
+FIXTURE_DATA(TRAP) {
+	struct sock_fprog prog;
+};
+
+FIXTURE_SETUP(TRAP)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRAP),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+
+	memset(&self->prog, 0, sizeof(self->prog));
+	self->prog.filter = malloc(sizeof(filter));
+	ASSERT_NE(NULL, self->prog.filter);
+	memcpy(self->prog.filter, filter, sizeof(filter));
+	self->prog.len = (unsigned short)ARRAY_SIZE(filter);
+}
+
+FIXTURE_TEARDOWN(TRAP)
+{
+	if (self->prog.filter)
+		free(self->prog.filter);
+}
+
+TEST_F_SIGNAL(TRAP, dfl, SIGSYS)
+{
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->prog);
+	ASSERT_EQ(0, ret);
+	syscall(__NR_getpid);
+}
+
+/* Ensure that SIGSYS overrides SIG_IGN */
+TEST_F_SIGNAL(TRAP, ign, SIGSYS)
+{
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	signal(SIGSYS, SIG_IGN);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->prog);
+	ASSERT_EQ(0, ret);
+	syscall(__NR_getpid);
+}
+
+static struct siginfo TRAP_info;
+static volatile int TRAP_nr;
+static void TRAP_action(int nr, siginfo_t *info, void *void_context)
+{
+	memcpy(&TRAP_info, info, sizeof(TRAP_info));
+	TRAP_nr = nr;
+}
+
+TEST_F(TRAP, handler)
+{
+	int ret, test;
+	struct sigaction act;
+	sigset_t mask;
+
+	memset(&act, 0, sizeof(act));
+	sigemptyset(&mask);
+	sigaddset(&mask, SIGSYS);
+
+	act.sa_sigaction = &TRAP_action;
+	act.sa_flags = SA_SIGINFO;
+	ret = sigaction(SIGSYS, &act, NULL);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("sigaction failed");
+	}
+	ret = sigprocmask(SIG_UNBLOCK, &mask, NULL);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("sigprocmask failed");
+	}
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->prog);
+	ASSERT_EQ(0, ret);
+	TRAP_nr = 0;
+	memset(&TRAP_info, 0, sizeof(TRAP_info));
+	/* Expect the registers to be rolled back. (nr = error) may vary
+	 * based on arch. */
+	ret = syscall(__NR_getpid);
+	/* Silence gcc warning about volatile. */
+	test = TRAP_nr;
+	EXPECT_EQ(SIGSYS, test);
+	struct local_sigsys {
+		void *_call_addr;	/* calling user insn */
+		int _syscall;		/* triggering system call number */
+		unsigned int _arch;	/* AUDIT_ARCH_* of syscall */
+	} *sigsys = (struct local_sigsys *)
+#ifdef si_syscall
+		&(TRAP_info.si_call_addr);
+#else
+		&TRAP_info.si_pid;
+#endif
+	EXPECT_EQ(__NR_getpid, sigsys->_syscall);
+	/* Make sure arch is non-zero. */
+	EXPECT_NE(0, sigsys->_arch);
+	EXPECT_NE(0, (unsigned long)sigsys->_call_addr);
+}
+
+FIXTURE_DATA(precedence) {
+	struct sock_fprog allow;
+	struct sock_fprog trace;
+	struct sock_fprog error;
+	struct sock_fprog trap;
+	struct sock_fprog kill;
+};
+
+FIXTURE_SETUP(precedence)
+{
+	struct sock_filter allow_insns[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_filter trace_insns[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 1, 0),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE),
+	};
+	struct sock_filter error_insns[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 1, 0),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ERRNO),
+	};
+	struct sock_filter trap_insns[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 1, 0),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRAP),
+	};
+	struct sock_filter kill_insns[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 1, 0),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL),
+	};
+
+	memset(self, 0, sizeof(*self));
+#define FILTER_ALLOC(_x) \
+	self->_x.filter = malloc(sizeof(_x##_insns)); \
+	ASSERT_NE(NULL, self->_x.filter); \
+	memcpy(self->_x.filter, &_x##_insns, sizeof(_x##_insns)); \
+	self->_x.len = (unsigned short)ARRAY_SIZE(_x##_insns)
+	FILTER_ALLOC(allow);
+	FILTER_ALLOC(trace);
+	FILTER_ALLOC(error);
+	FILTER_ALLOC(trap);
+	FILTER_ALLOC(kill);
+}
+
+FIXTURE_TEARDOWN(precedence)
+{
+#define FILTER_FREE(_x) if (self->_x.filter) free(self->_x.filter)
+	FILTER_FREE(allow);
+	FILTER_FREE(trace);
+	FILTER_FREE(error);
+	FILTER_FREE(trap);
+	FILTER_FREE(kill);
+}
+
+TEST_F(precedence, allow_ok)
+{
+	pid_t parent, res = 0;
+	long ret;
+
+	parent = getppid();
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trap);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->kill);
+	ASSERT_EQ(0, ret);
+	/* Should work just fine. */
+	res = syscall(__NR_getppid);
+	EXPECT_EQ(parent, res);
+}
+
+TEST_F_SIGNAL(precedence, kill_is_highest, SIGSYS)
+{
+	pid_t parent, res = 0;
+	long ret;
+
+	parent = getppid();
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trap);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->kill);
+	ASSERT_EQ(0, ret);
+	/* Should work just fine. */
+	res = syscall(__NR_getppid);
+	EXPECT_EQ(parent, res);
+	/* getpid() should never return. */
+	res = syscall(__NR_getpid);
+	EXPECT_EQ(0, res);
+}
+
+TEST_F_SIGNAL(precedence, kill_is_highest_in_any_order, SIGSYS)
+{
+	pid_t parent;
+	long ret;
+
+	parent = getppid();
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->kill);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trap);
+	ASSERT_EQ(0, ret);
+	/* Should work just fine. */
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	/* getpid() should never return. */
+	EXPECT_EQ(0, syscall(__NR_getpid));
+}
+
+TEST_F_SIGNAL(precedence, trap_is_second, SIGSYS)
+{
+	pid_t parent;
+	long ret;
+
+	parent = getppid();
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trap);
+	ASSERT_EQ(0, ret);
+	/* Should work just fine. */
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	/* getpid() should never return. */
+	EXPECT_EQ(0, syscall(__NR_getpid));
+}
+
+TEST_F_SIGNAL(precedence, trap_is_second_in_any_order, SIGSYS)
+{
+	pid_t parent;
+	long ret;
+
+	parent = getppid();
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trap);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
+	ASSERT_EQ(0, ret);
+	/* Should work just fine. */
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	/* getpid() should never return. */
+	EXPECT_EQ(0, syscall(__NR_getpid));
+}
+
+TEST_F(precedence, errno_is_third)
+{
+	pid_t parent;
+	long ret;
+
+	parent = getppid();
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
+	ASSERT_EQ(0, ret);
+	/* Should work just fine. */
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	EXPECT_EQ(0, syscall(__NR_getpid));
+}
+
+TEST_F(precedence, errno_is_third_in_any_order)
+{
+	pid_t parent;
+	long ret;
+
+	parent = getppid();
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->error);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
+	ASSERT_EQ(0, ret);
+	/* Should work just fine. */
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	EXPECT_EQ(0, syscall(__NR_getpid));
+}
+
+TEST_F(precedence, trace_is_fourth)
+{
+	pid_t parent;
+	long ret;
+
+	parent = getppid();
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
+	ASSERT_EQ(0, ret);
+	/* Should work just fine. */
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	/* No ptracer */
+	EXPECT_EQ(-1, syscall(__NR_getpid));
+}
+
+TEST_F(precedence, trace_is_fourth_in_any_order)
+{
+	pid_t parent;
+	long ret;
+
+	parent = getppid();
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trace);
+	ASSERT_EQ(0, ret);
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allow);
+	ASSERT_EQ(0, ret);
+	/* Should work just fine. */
+	EXPECT_EQ(parent, syscall(__NR_getppid));
+	/* No ptracer */
+	EXPECT_EQ(-1, syscall(__NR_getpid));
+}
+
+#ifndef PTRACE_O_TRACESECCOMP
+#define PTRACE_O_TRACESECCOMP	0x00000080
+#endif
+
+/* Catch the Ubuntu 12.04 value error. */
+#if PTRACE_EVENT_SECCOMP != 7
+#undef PTRACE_EVENT_SECCOMP
+#endif
+
+#ifndef PTRACE_EVENT_SECCOMP
+#define PTRACE_EVENT_SECCOMP 7
+#endif
+
+#define IS_SECCOMP_EVENT(status) ((status >> 16) == PTRACE_EVENT_SECCOMP)
+bool tracer_running;
+void tracer_stop(int sig)
+{
+	tracer_running = false;
+}
+
+typedef void tracer_func_t(struct __test_metadata *_metadata,
+			   pid_t tracee, int status, void *args);
+
+void tracer(struct __test_metadata *_metadata, int fd, pid_t tracee,
+	    tracer_func_t tracer_func, void *args)
+{
+	int ret = -1;
+	struct sigaction action = {
+		.sa_handler = tracer_stop,
+	};
+
+	/* Allow external shutdown. */
+	tracer_running = true;
+	ASSERT_EQ(0, sigaction(SIGUSR1, &action, NULL));
+
+	errno = 0;
+	while (ret == -1 && errno != EINVAL)
+		ret = ptrace(PTRACE_ATTACH, tracee, NULL, 0);
+	ASSERT_EQ(0, ret) {
+		kill(tracee, SIGKILL);
+	}
+	/* Wait for attach stop */
+	wait(NULL);
+
+	ret = ptrace(PTRACE_SETOPTIONS, tracee, NULL, PTRACE_O_TRACESECCOMP);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Failed to set PTRACE_O_TRACESECCOMP");
+		kill(tracee, SIGKILL);
+	}
+	ptrace(PTRACE_CONT, tracee, NULL, 0);
+
+	/* Unblock the tracee */
+	ASSERT_EQ(1, write(fd, "A", 1));
+	ASSERT_EQ(0, close(fd));
+
+	/* Run until we're shut down. Must assert to stop execution. */
+	while (tracer_running) {
+		int status;
+
+		if (wait(&status) != tracee)
+			continue;
+		if (WIFSIGNALED(status) || WIFEXITED(status))
+			/* Child is dead. Time to go. */
+			return;
+
+		/* Make sure this is a seccomp event. */
+		ASSERT_EQ(true, IS_SECCOMP_EVENT(status));
+
+		tracer_func(_metadata, tracee, status, args);
+
+		ret = ptrace(PTRACE_CONT, tracee, NULL, NULL);
+		ASSERT_EQ(0, ret);
+	}
+	/* Directly report the status of our test harness results. */
+	syscall(__NR_exit, _metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+}
+
+/* Common tracer setup/teardown functions. */
+void cont_handler(int num)
+{ }
+pid_t setup_trace_fixture(struct __test_metadata *_metadata,
+			  tracer_func_t func, void *args)
+{
+	char sync;
+	int pipefd[2];
+	pid_t tracer_pid;
+	pid_t tracee = getpid();
+
+	/* Setup a pipe for clean synchronization. */
+	ASSERT_EQ(0, pipe(pipefd));
+
+	/* Fork a child which we'll promote to tracer */
+	tracer_pid = fork();
+	ASSERT_LE(0, tracer_pid);
+	signal(SIGALRM, cont_handler);
+	if (tracer_pid == 0) {
+		close(pipefd[0]);
+		tracer(_metadata, pipefd[1], tracee, func, args);
+		syscall(__NR_exit, 0);
+	}
+	close(pipefd[1]);
+	prctl(PR_SET_PTRACER, tracer_pid, 0, 0, 0);
+	read(pipefd[0], &sync, 1);
+	close(pipefd[0]);
+
+	return tracer_pid;
+}
+void teardown_trace_fixture(struct __test_metadata *_metadata,
+			    pid_t tracer)
+{
+	if (tracer) {
+		int status;
+		/*
+		 * Extract the exit code from the other process and
+		 * adopt it for ourselves in case its asserts failed.
+		 */
+		ASSERT_EQ(0, kill(tracer, SIGUSR1));
+		ASSERT_EQ(tracer, waitpid(tracer, &status, 0));
+		if (WEXITSTATUS(status))
+			_metadata->passed = 0;
+	}
+}
+
+/* "poke" tracer arguments and function. */
+struct tracer_args_poke_t {
+	unsigned long poke_addr;
+};
+
+void tracer_poke(struct __test_metadata *_metadata, pid_t tracee, int status,
+		 void *args)
+{
+	int ret;
+	unsigned long msg;
+	struct tracer_args_poke_t *info = (struct tracer_args_poke_t *)args;
+
+	ret = ptrace(PTRACE_GETEVENTMSG, tracee, NULL, &msg);
+	EXPECT_EQ(0, ret);
+	/* If this fails, don't try to recover. */
+	ASSERT_EQ(0x1001, msg) {
+		kill(tracee, SIGKILL);
+	}
+	/*
+	 * Poke in the message.
+	 * Registers are not touched to try to keep this relatively arch
+	 * agnostic.
+	 */
+	ret = ptrace(PTRACE_POKEDATA, tracee, info->poke_addr, 0x1001);
+	EXPECT_EQ(0, ret);
+}
+
+FIXTURE_DATA(TRACE_poke) {
+	struct sock_fprog prog;
+	pid_t tracer;
+	long poked;
+	struct tracer_args_poke_t tracer_args;
+};
+
+FIXTURE_SETUP(TRACE_poke)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE | 0x1001),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+
+	self->poked = 0;
+	memset(&self->prog, 0, sizeof(self->prog));
+	self->prog.filter = malloc(sizeof(filter));
+	ASSERT_NE(NULL, self->prog.filter);
+	memcpy(self->prog.filter, filter, sizeof(filter));
+	self->prog.len = (unsigned short)ARRAY_SIZE(filter);
+
+	/* Set up tracer args. */
+	self->tracer_args.poke_addr = (unsigned long)&self->poked;
+
+	/* Launch tracer. */
+	self->tracer = setup_trace_fixture(_metadata, tracer_poke,
+					   &self->tracer_args);
+}
+
+FIXTURE_TEARDOWN(TRACE_poke)
+{
+	teardown_trace_fixture(_metadata, self->tracer);
+	if (self->prog.filter)
+		free(self->prog.filter);
+}
+
+TEST_F(TRACE_poke, read_has_side_effects)
+{
+	ssize_t ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->prog, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	EXPECT_EQ(0, self->poked);
+	ret = read(-1, NULL, 0);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(0x1001, self->poked);
+}
+
+TEST_F(TRACE_poke, getpid_runs_normally)
+{
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->prog, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	EXPECT_EQ(0, self->poked);
+	EXPECT_NE(0, syscall(__NR_getpid));
+	EXPECT_EQ(0, self->poked);
+}
+
+#if defined(__x86_64__)
+# define ARCH_REGS	struct user_regs_struct
+# define SYSCALL_NUM	orig_rax
+# define SYSCALL_RET	rax
+#elif defined(__i386__)
+# define ARCH_REGS	struct user_regs_struct
+# define SYSCALL_NUM	orig_eax
+# define SYSCALL_RET	eax
+#elif defined(__arm__)
+# define ARCH_REGS	struct pt_regs
+# define SYSCALL_NUM	ARM_r7
+# define SYSCALL_RET	ARM_r0
+#elif defined(__aarch64__)
+# define ARCH_REGS	struct user_pt_regs
+# define SYSCALL_NUM	regs[8]
+# define SYSCALL_RET	regs[0]
+#else
+# error "Do not know how to find your architecture's registers and syscalls"
+#endif
+
+/* Architecture-specific syscall fetching routine. */
+int get_syscall(struct __test_metadata *_metadata, pid_t tracee)
+{
+	struct iovec iov;
+	ARCH_REGS regs;
+
+	iov.iov_base = &regs;
+	iov.iov_len = sizeof(regs);
+	EXPECT_EQ(0, ptrace(PTRACE_GETREGSET, tracee, NT_PRSTATUS, &iov)) {
+		TH_LOG("PTRACE_GETREGSET failed");
+		return -1;
+	}
+
+	return regs.SYSCALL_NUM;
+}
+
+/* Architecture-specific syscall changing routine. */
+void change_syscall(struct __test_metadata *_metadata,
+		    pid_t tracee, int syscall)
+{
+	struct iovec iov;
+	int ret;
+	ARCH_REGS regs;
+
+	iov.iov_base = &regs;
+	iov.iov_len = sizeof(regs);
+	ret = ptrace(PTRACE_GETREGSET, tracee, NT_PRSTATUS, &iov);
+	EXPECT_EQ(0, ret);
+
+#if defined(__x86_64__) || defined(__i386__) || defined(__aarch64__)
+	{
+		regs.SYSCALL_NUM = syscall;
+	}
+
+#elif defined(__arm__)
+# ifndef PTRACE_SET_SYSCALL
+#  define PTRACE_SET_SYSCALL   23
+# endif
+	{
+		ret = ptrace(PTRACE_SET_SYSCALL, tracee, NULL, syscall);
+		EXPECT_EQ(0, ret);
+	}
+
+#else
+	ASSERT_EQ(1, 0) {
+		TH_LOG("How is the syscall changed on this architecture?");
+	}
+#endif
+
+	/* If syscall is skipped, change return value. */
+	if (syscall == -1)
+		regs.SYSCALL_RET = 1;
+
+	ret = ptrace(PTRACE_SETREGSET, tracee, NT_PRSTATUS, &iov);
+	EXPECT_EQ(0, ret);
+}
+
+void tracer_syscall(struct __test_metadata *_metadata, pid_t tracee,
+		    int status, void *args)
+{
+	int ret;
+	unsigned long msg;
+
+	/* Make sure we got the right message. */
+	ret = ptrace(PTRACE_GETEVENTMSG, tracee, NULL, &msg);
+	EXPECT_EQ(0, ret);
+
+	switch (msg) {
+	case 0x1002:
+		/* change getpid to getppid. */
+		change_syscall(_metadata, tracee, __NR_getppid);
+		break;
+	case 0x1003:
+		/* skip gettid. */
+		change_syscall(_metadata, tracee, -1);
+		break;
+	case 0x1004:
+		/* do nothing (allow getppid) */
+		break;
+	default:
+		EXPECT_EQ(0, msg) {
+			TH_LOG("Unknown PTRACE_GETEVENTMSG: 0x%lx", msg);
+			kill(tracee, SIGKILL);
+		}
+	}
+
+}
+
+FIXTURE_DATA(TRACE_syscall) {
+	struct sock_fprog prog;
+	pid_t tracer, mytid, mypid, parent;
+};
+
+FIXTURE_SETUP(TRACE_syscall)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE | 0x1002),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_gettid, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE | 0x1003),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getppid, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE | 0x1004),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+
+	memset(&self->prog, 0, sizeof(self->prog));
+	self->prog.filter = malloc(sizeof(filter));
+	ASSERT_NE(NULL, self->prog.filter);
+	memcpy(self->prog.filter, filter, sizeof(filter));
+	self->prog.len = (unsigned short)ARRAY_SIZE(filter);
+
+	/* Prepare some testable syscall results. */
+	self->mytid = syscall(__NR_gettid);
+	ASSERT_GT(self->mytid, 0);
+	ASSERT_NE(self->mytid, 1) {
+		TH_LOG("Running this test as init is not supported. :)");
+	}
+
+	self->mypid = getpid();
+	ASSERT_GT(self->mypid, 0);
+	ASSERT_EQ(self->mytid, self->mypid);
+
+	self->parent = getppid();
+	ASSERT_GT(self->parent, 0);
+	ASSERT_NE(self->parent, self->mypid);
+
+	/* Launch tracer. */
+	self->tracer = setup_trace_fixture(_metadata, tracer_syscall, NULL);
+}
+
+FIXTURE_TEARDOWN(TRACE_syscall)
+{
+	teardown_trace_fixture(_metadata, self->tracer);
+	if (self->prog.filter)
+		free(self->prog.filter);
+}
+
+TEST_F(TRACE_syscall, syscall_allowed)
+{
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->prog, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	/* getppid works as expected (no changes). */
+	EXPECT_EQ(self->parent, syscall(__NR_getppid));
+	EXPECT_NE(self->mypid, syscall(__NR_getppid));
+}
+
+TEST_F(TRACE_syscall, syscall_redirected)
+{
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->prog, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	/* getpid has been redirected to getppid as expected. */
+	EXPECT_EQ(self->parent, syscall(__NR_getpid));
+	EXPECT_NE(self->mypid, syscall(__NR_getpid));
+}
+
+TEST_F(TRACE_syscall, syscall_dropped)
+{
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->prog, 0, 0);
+	ASSERT_EQ(0, ret);
+
+	/* gettid has been skipped and an altered return value stored. */
+	EXPECT_EQ(1, syscall(__NR_gettid));
+	EXPECT_NE(self->mytid, syscall(__NR_gettid));
+}
+
+#ifndef __NR_seccomp
+# if defined(__i386__)
+#  define __NR_seccomp 354
+# elif defined(__x86_64__)
+#  define __NR_seccomp 317
+# elif defined(__arm__)
+#  define __NR_seccomp 383
+# elif defined(__aarch64__)
+#  define __NR_seccomp 277
+# else
+#  warning "seccomp syscall number unknown for this architecture"
+#  define __NR_seccomp 0xffff
+# endif
+#endif
+
+#ifndef SECCOMP_SET_MODE_STRICT
+#define SECCOMP_SET_MODE_STRICT 0
+#endif
+
+#ifndef SECCOMP_SET_MODE_FILTER
+#define SECCOMP_SET_MODE_FILTER 1
+#endif
+
+#ifndef SECCOMP_FLAG_FILTER_TSYNC
+#define SECCOMP_FLAG_FILTER_TSYNC 1
+#endif
+
+#ifndef seccomp
+int seccomp(unsigned int op, unsigned int flags, struct sock_fprog *filter)
+{
+	errno = 0;
+	return syscall(__NR_seccomp, op, flags, filter);
+}
+#endif
+
+TEST(seccomp_syscall)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	/* Reject insane operation. */
+	ret = seccomp(-1, 0, &prog);
+	EXPECT_EQ(EINVAL, errno) {
+		TH_LOG("Did not reject crazy op value!");
+	}
+
+	/* Reject strict with flags or pointer. */
+	ret = seccomp(SECCOMP_SET_MODE_STRICT, -1, NULL);
+	EXPECT_EQ(EINVAL, errno) {
+		TH_LOG("Did not reject mode strict with flags!");
+	}
+	ret = seccomp(SECCOMP_SET_MODE_STRICT, 0, &prog);
+	EXPECT_EQ(EINVAL, errno) {
+		TH_LOG("Did not reject mode strict with uargs!");
+	}
+
+	/* Reject insane args for filter. */
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, -1, &prog);
+	EXPECT_EQ(EINVAL, errno) {
+		TH_LOG("Did not reject crazy filter flags!");
+	}
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, 0, NULL);
+	EXPECT_EQ(EFAULT, errno) {
+		TH_LOG("Did not reject NULL filter!");
+	}
+
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog);
+	EXPECT_EQ(0, errno) {
+		TH_LOG("Kernel does not support SECCOMP_SET_MODE_FILTER: %s",
+			strerror(errno));
+	}
+}
+
+TEST(seccomp_syscall_mode_lock)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, NULL, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog);
+	EXPECT_EQ(0, ret) {
+		TH_LOG("Could not install filter!");
+	}
+
+	/* Make sure neither entry point will switch to strict. */
+	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_STRICT, 0, 0, 0);
+	EXPECT_EQ(EINVAL, errno) {
+		TH_LOG("Switched to mode strict!");
+	}
+
+	ret = seccomp(SECCOMP_SET_MODE_STRICT, 0, NULL);
+	EXPECT_EQ(EINVAL, errno) {
+		TH_LOG("Switched to mode strict!");
+	}
+}
+
+TEST(TSYNC_first)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+	long ret;
+
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, NULL, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYNC,
+		      &prog);
+	EXPECT_EQ(0, ret) {
+		TH_LOG("Could not install initial filter with TSYNC!");
+	}
+}
+
+#define TSYNC_SIBLINGS 2
+struct tsync_sibling {
+	pthread_t tid;
+	pid_t system_tid;
+	sem_t *started;
+	pthread_cond_t *cond;
+	pthread_mutex_t *mutex;
+	int diverge;
+	int num_waits;
+	struct sock_fprog *prog;
+	struct __test_metadata *metadata;
+};
+
+FIXTURE_DATA(TSYNC) {
+	struct sock_fprog root_prog, apply_prog;
+	struct tsync_sibling sibling[TSYNC_SIBLINGS];
+	sem_t started;
+	pthread_cond_t cond;
+	pthread_mutex_t mutex;
+	int sibling_count;
+};
+
+FIXTURE_SETUP(TSYNC)
+{
+	struct sock_filter root_filter[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_filter apply_filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+
+	memset(&self->root_prog, 0, sizeof(self->root_prog));
+	memset(&self->apply_prog, 0, sizeof(self->apply_prog));
+	memset(&self->sibling, 0, sizeof(self->sibling));
+	self->root_prog.filter = malloc(sizeof(root_filter));
+	ASSERT_NE(NULL, self->root_prog.filter);
+	memcpy(self->root_prog.filter, &root_filter, sizeof(root_filter));
+	self->root_prog.len = (unsigned short)ARRAY_SIZE(root_filter);
+
+	self->apply_prog.filter = malloc(sizeof(apply_filter));
+	ASSERT_NE(NULL, self->apply_prog.filter);
+	memcpy(self->apply_prog.filter, &apply_filter, sizeof(apply_filter));
+	self->apply_prog.len = (unsigned short)ARRAY_SIZE(apply_filter);
+
+	self->sibling_count = 0;
+	pthread_mutex_init(&self->mutex, NULL);
+	pthread_cond_init(&self->cond, NULL);
+	sem_init(&self->started, 0, 0);
+	self->sibling[0].tid = 0;
+	self->sibling[0].cond = &self->cond;
+	self->sibling[0].started = &self->started;
+	self->sibling[0].mutex = &self->mutex;
+	self->sibling[0].diverge = 0;
+	self->sibling[0].num_waits = 1;
+	self->sibling[0].prog = &self->root_prog;
+	self->sibling[0].metadata = _metadata;
+	self->sibling[1].tid = 0;
+	self->sibling[1].cond = &self->cond;
+	self->sibling[1].started = &self->started;
+	self->sibling[1].mutex = &self->mutex;
+	self->sibling[1].diverge = 0;
+	self->sibling[1].prog = &self->root_prog;
+	self->sibling[1].num_waits = 1;
+	self->sibling[1].metadata = _metadata;
+}
+
+FIXTURE_TEARDOWN(TSYNC)
+{
+	int sib = 0;
+
+	if (self->root_prog.filter)
+		free(self->root_prog.filter);
+	if (self->apply_prog.filter)
+		free(self->apply_prog.filter);
+
+	for ( ; sib < self->sibling_count; ++sib) {
+		struct tsync_sibling *s = &self->sibling[sib];
+		void *status;
+
+		if (!s->tid)
+			continue;
+		if (pthread_kill(s->tid, 0)) {
+			pthread_cancel(s->tid);
+			pthread_join(s->tid, &status);
+		}
+	}
+	pthread_mutex_destroy(&self->mutex);
+	pthread_cond_destroy(&self->cond);
+	sem_destroy(&self->started);
+}
+
+void *tsync_sibling(void *data)
+{
+	long ret = 0;
+	struct tsync_sibling *me = data;
+
+	me->system_tid = syscall(__NR_gettid);
+
+	pthread_mutex_lock(me->mutex);
+	if (me->diverge) {
+		/* Just re-apply the root prog to fork the tree */
+		ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER,
+				me->prog, 0, 0);
+	}
+	sem_post(me->started);
+	/* Return outside of started so parent notices failures. */
+	if (ret) {
+		pthread_mutex_unlock(me->mutex);
+		return (void *)SIBLING_EXIT_FAILURE;
+	}
+	do {
+		pthread_cond_wait(me->cond, me->mutex);
+		me->num_waits = me->num_waits - 1;
+	} while (me->num_waits);
+	pthread_mutex_unlock(me->mutex);
+
+	ret = prctl(PR_GET_NO_NEW_PRIVS, 0, 0, 0, 0);
+	if (!ret)
+		return (void *)SIBLING_EXIT_NEWPRIVS;
+	read(0, NULL, 0);
+	return (void *)SIBLING_EXIT_UNKILLED;
+}
+
+void tsync_start_sibling(struct tsync_sibling *sibling)
+{
+	pthread_create(&sibling->tid, NULL, tsync_sibling, (void *)sibling);
+}
+
+TEST_F(TSYNC, siblings_fail_prctl)
+{
+	long ret;
+	void *status;
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_prctl, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ERRNO | EINVAL),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	/* Check prctl failure detection by requesting sib 0 diverge. */
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("setting filter failed");
+	}
+
+	self->sibling[0].diverge = 1;
+	tsync_start_sibling(&self->sibling[0]);
+	tsync_start_sibling(&self->sibling[1]);
+
+	while (self->sibling_count < TSYNC_SIBLINGS) {
+		sem_wait(&self->started);
+		self->sibling_count++;
+	}
+
+	/* Signal the threads to clean up*/
+	pthread_mutex_lock(&self->mutex);
+	ASSERT_EQ(0, pthread_cond_broadcast(&self->cond)) {
+		TH_LOG("cond broadcast non-zero");
+	}
+	pthread_mutex_unlock(&self->mutex);
+
+	/* Ensure diverging sibling failed to call prctl. */
+	pthread_join(self->sibling[0].tid, &status);
+	EXPECT_EQ(SIBLING_EXIT_FAILURE, (long)status);
+	pthread_join(self->sibling[1].tid, &status);
+	EXPECT_EQ(SIBLING_EXIT_UNKILLED, (long)status);
+}
+
+TEST_F(TSYNC, two_siblings_with_ancestor)
+{
+	long ret;
+	void *status;
+
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, 0, &self->root_prog);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support SECCOMP_SET_MODE_FILTER!");
+	}
+	tsync_start_sibling(&self->sibling[0]);
+	tsync_start_sibling(&self->sibling[1]);
+
+	while (self->sibling_count < TSYNC_SIBLINGS) {
+		sem_wait(&self->started);
+		self->sibling_count++;
+	}
+
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYNC,
+		      &self->apply_prog);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Could install filter on all threads!");
+	}
+	/* Tell the siblings to test the policy */
+	pthread_mutex_lock(&self->mutex);
+	ASSERT_EQ(0, pthread_cond_broadcast(&self->cond)) {
+		TH_LOG("cond broadcast non-zero");
+	}
+	pthread_mutex_unlock(&self->mutex);
+	/* Ensure they are both killed and don't exit cleanly. */
+	pthread_join(self->sibling[0].tid, &status);
+	EXPECT_EQ(0x0, (long)status);
+	pthread_join(self->sibling[1].tid, &status);
+	EXPECT_EQ(0x0, (long)status);
+}
+
+TEST_F(TSYNC, two_sibling_want_nnp)
+{
+	void *status;
+
+	/* start siblings before any prctl() operations */
+	tsync_start_sibling(&self->sibling[0]);
+	tsync_start_sibling(&self->sibling[1]);
+	while (self->sibling_count < TSYNC_SIBLINGS) {
+		sem_wait(&self->started);
+		self->sibling_count++;
+	}
+
+	/* Tell the siblings to test no policy */
+	pthread_mutex_lock(&self->mutex);
+	ASSERT_EQ(0, pthread_cond_broadcast(&self->cond)) {
+		TH_LOG("cond broadcast non-zero");
+	}
+	pthread_mutex_unlock(&self->mutex);
+
+	/* Ensure they are both upset about lacking nnp. */
+	pthread_join(self->sibling[0].tid, &status);
+	EXPECT_EQ(SIBLING_EXIT_NEWPRIVS, (long)status);
+	pthread_join(self->sibling[1].tid, &status);
+	EXPECT_EQ(SIBLING_EXIT_NEWPRIVS, (long)status);
+}
+
+TEST_F(TSYNC, two_siblings_with_no_filter)
+{
+	long ret;
+	void *status;
+
+	/* start siblings before any prctl() operations */
+	tsync_start_sibling(&self->sibling[0]);
+	tsync_start_sibling(&self->sibling[1]);
+	while (self->sibling_count < TSYNC_SIBLINGS) {
+		sem_wait(&self->started);
+		self->sibling_count++;
+	}
+
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYNC,
+		      &self->apply_prog);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Could install filter on all threads!");
+	}
+
+	/* Tell the siblings to test the policy */
+	pthread_mutex_lock(&self->mutex);
+	ASSERT_EQ(0, pthread_cond_broadcast(&self->cond)) {
+		TH_LOG("cond broadcast non-zero");
+	}
+	pthread_mutex_unlock(&self->mutex);
+
+	/* Ensure they are both killed and don't exit cleanly. */
+	pthread_join(self->sibling[0].tid, &status);
+	EXPECT_EQ(0x0, (long)status);
+	pthread_join(self->sibling[1].tid, &status);
+	EXPECT_EQ(0x0, (long)status);
+}
+
+TEST_F(TSYNC, two_siblings_with_one_divergence)
+{
+	long ret;
+	void *status;
+
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, 0, &self->root_prog);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support SECCOMP_SET_MODE_FILTER!");
+	}
+	self->sibling[0].diverge = 1;
+	tsync_start_sibling(&self->sibling[0]);
+	tsync_start_sibling(&self->sibling[1]);
+
+	while (self->sibling_count < TSYNC_SIBLINGS) {
+		sem_wait(&self->started);
+		self->sibling_count++;
+	}
+
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYNC,
+		      &self->apply_prog);
+	ASSERT_EQ(self->sibling[0].system_tid, ret) {
+		TH_LOG("Did not fail on diverged sibling.");
+	}
+
+	/* Wake the threads */
+	pthread_mutex_lock(&self->mutex);
+	ASSERT_EQ(0, pthread_cond_broadcast(&self->cond)) {
+		TH_LOG("cond broadcast non-zero");
+	}
+	pthread_mutex_unlock(&self->mutex);
+
+	/* Ensure they are both unkilled. */
+	pthread_join(self->sibling[0].tid, &status);
+	EXPECT_EQ(SIBLING_EXIT_UNKILLED, (long)status);
+	pthread_join(self->sibling[1].tid, &status);
+	EXPECT_EQ(SIBLING_EXIT_UNKILLED, (long)status);
+}
+
+TEST_F(TSYNC, two_siblings_not_under_filter)
+{
+	long ret, sib;
+	void *status;
+
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
+	/*
+	 * Sibling 0 will have its own seccomp policy
+	 * and Sibling 1 will not be under seccomp at
+	 * all. Sibling 1 will enter seccomp and 0
+	 * will cause failure.
+	 */
+	self->sibling[0].diverge = 1;
+	tsync_start_sibling(&self->sibling[0]);
+	tsync_start_sibling(&self->sibling[1]);
+
+	while (self->sibling_count < TSYNC_SIBLINGS) {
+		sem_wait(&self->started);
+		self->sibling_count++;
+	}
+
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, 0, &self->root_prog);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support SECCOMP_SET_MODE_FILTER!");
+	}
+
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYNC,
+		      &self->apply_prog);
+	ASSERT_EQ(ret, self->sibling[0].system_tid) {
+		TH_LOG("Did not fail on diverged sibling.");
+	}
+	sib = 1;
+	if (ret == self->sibling[0].system_tid)
+		sib = 0;
+
+	pthread_mutex_lock(&self->mutex);
+
+	/* Increment the other siblings num_waits so we can clean up
+	 * the one we just saw.
+	 */
+	self->sibling[!sib].num_waits += 1;
+
+	/* Signal the thread to clean up*/
+	ASSERT_EQ(0, pthread_cond_broadcast(&self->cond)) {
+		TH_LOG("cond broadcast non-zero");
+	}
+	pthread_mutex_unlock(&self->mutex);
+	pthread_join(self->sibling[sib].tid, &status);
+	EXPECT_EQ(SIBLING_EXIT_UNKILLED, (long)status);
+	/* Poll for actual task death. pthread_join doesn't guarantee it. */
+	while (!kill(self->sibling[sib].system_tid, 0))
+		sleep(0.1);
+	/* Switch to the remaining sibling */
+	sib = !sib;
+
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYNC,
+		      &self->apply_prog);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Expected the remaining sibling to sync");
+	};
+
+	pthread_mutex_lock(&self->mutex);
+
+	/* If remaining sibling didn't have a chance to wake up during
+	 * the first broadcast, manually reduce the num_waits now.
+	 */
+	if (self->sibling[sib].num_waits > 1)
+		self->sibling[sib].num_waits = 1;
+	ASSERT_EQ(0, pthread_cond_broadcast(&self->cond)) {
+		TH_LOG("cond broadcast non-zero");
+	}
+	pthread_mutex_unlock(&self->mutex);
+	pthread_join(self->sibling[sib].tid, &status);
+	EXPECT_EQ(0, (long)status);
+	/* Poll for actual task death. pthread_join doesn't guarantee it. */
+	while (!kill(self->sibling[sib].system_tid, 0))
+		sleep(0.1);
+
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYNC,
+		      &self->apply_prog);
+	ASSERT_EQ(0, ret);  /* just us chickens */
+}
+
+/* Make sure restarted syscalls are seen directly as "restart_syscall". */
+TEST(syscall_restart)
+{
+	long ret;
+	unsigned long msg;
+	pid_t child_pid;
+	int pipefd[2];
+	int status;
+	siginfo_t info = { };
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
+			 offsetof(struct seccomp_data, nr)),
+
+#ifdef __NR_sigreturn
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_sigreturn, 6, 0),
+#endif
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_read, 5, 0),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_exit, 4, 0),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_rt_sigreturn, 3, 0),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_poll, 4, 0),
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_restart_syscall, 4, 0),
+
+		/* Allow __NR_write for easy logging. */
+		BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_write, 0, 1),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL),
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE|0x100), /* poll */
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_TRACE|0x200), /* restart */
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+
+	ASSERT_EQ(0, pipe(pipefd));
+
+	child_pid = fork();
+	ASSERT_LE(0, child_pid);
+	if (child_pid == 0) {
+		/* Child uses EXPECT not ASSERT to deliver status correctly. */
+		char buf = ' ';
+		struct pollfd fds = {
+			.fd = pipefd[0],
+			.events = POLLIN,
+		};
+
+		/* Attach parent as tracer and stop. */
+		EXPECT_EQ(0, ptrace(PTRACE_TRACEME));
+		EXPECT_EQ(0, raise(SIGSTOP));
+
+		EXPECT_EQ(0, close(pipefd[1]));
+
+		EXPECT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
+			TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+		}
+
+		ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog, 0, 0);
+		EXPECT_EQ(0, ret) {
+			TH_LOG("Failed to install filter!");
+		}
+
+		EXPECT_EQ(1, read(pipefd[0], &buf, 1)) {
+			TH_LOG("Failed to read() sync from parent");
+		}
+		EXPECT_EQ('.', buf) {
+			TH_LOG("Failed to get sync data from read()");
+		}
+
+		/* Start poll to be interrupted. */
+		errno = 0;
+		EXPECT_EQ(1, poll(&fds, 1, -1)) {
+			TH_LOG("Call to poll() failed (errno %d)", errno);
+		}
+
+		/* Read final sync from parent. */
+		EXPECT_EQ(1, read(pipefd[0], &buf, 1)) {
+			TH_LOG("Failed final read() from parent");
+		}
+		EXPECT_EQ('!', buf) {
+			TH_LOG("Failed to get final data from read()");
+		}
+
+		/* Directly report the status of our test harness results. */
+		syscall(__NR_exit, _metadata->passed ? EXIT_SUCCESS
+						     : EXIT_FAILURE);
+	}
+	EXPECT_EQ(0, close(pipefd[0]));
+
+	/* Attach to child, setup options, and release. */
+	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
+	ASSERT_EQ(true, WIFSTOPPED(status));
+	ASSERT_EQ(0, ptrace(PTRACE_SETOPTIONS, child_pid, NULL,
+			    PTRACE_O_TRACESECCOMP));
+	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
+	ASSERT_EQ(1, write(pipefd[1], ".", 1));
+
+	/* Wait for poll() to start. */
+	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
+	ASSERT_EQ(true, WIFSTOPPED(status));
+	ASSERT_EQ(SIGTRAP, WSTOPSIG(status));
+	ASSERT_EQ(PTRACE_EVENT_SECCOMP, (status >> 16));
+	ASSERT_EQ(0, ptrace(PTRACE_GETEVENTMSG, child_pid, NULL, &msg));
+	ASSERT_EQ(0x100, msg);
+	EXPECT_EQ(__NR_poll, get_syscall(_metadata, child_pid));
+
+	/* Might as well check siginfo for sanity while we're here. */
+	ASSERT_EQ(0, ptrace(PTRACE_GETSIGINFO, child_pid, NULL, &info));
+	ASSERT_EQ(SIGTRAP, info.si_signo);
+	ASSERT_EQ(SIGTRAP | (PTRACE_EVENT_SECCOMP << 8), info.si_code);
+	EXPECT_EQ(0, info.si_errno);
+	EXPECT_EQ(getuid(), info.si_uid);
+	/* Verify signal delivery came from child (seccomp-triggered). */
+	EXPECT_EQ(child_pid, info.si_pid);
+
+	/* Interrupt poll with SIGSTOP (which we'll need to handle). */
+	ASSERT_EQ(0, kill(child_pid, SIGSTOP));
+	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
+	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
+	ASSERT_EQ(true, WIFSTOPPED(status));
+	ASSERT_EQ(SIGSTOP, WSTOPSIG(status));
+	/* Verify signal delivery came from parent now. */
+	ASSERT_EQ(0, ptrace(PTRACE_GETSIGINFO, child_pid, NULL, &info));
+	EXPECT_EQ(getpid(), info.si_pid);
+
+	/* Restart poll with SIGCONT, which triggers restart_syscall. */
+	ASSERT_EQ(0, kill(child_pid, SIGCONT));
+	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
+	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
+	ASSERT_EQ(true, WIFSTOPPED(status));
+	ASSERT_EQ(SIGCONT, WSTOPSIG(status));
+	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
+
+	/* Wait for restart_syscall() to start. */
+	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
+	ASSERT_EQ(true, WIFSTOPPED(status));
+	ASSERT_EQ(SIGTRAP, WSTOPSIG(status));
+	ASSERT_EQ(PTRACE_EVENT_SECCOMP, (status >> 16));
+	ASSERT_EQ(0, ptrace(PTRACE_GETEVENTMSG, child_pid, NULL, &msg));
+	ASSERT_EQ(0x200, msg);
+	ret = get_syscall(_metadata, child_pid);
+#if defined(__arm__)
+	/* FIXME: ARM does not expose true syscall in registers. */
+	EXPECT_EQ(__NR_poll, ret);
+#else
+	EXPECT_EQ(__NR_restart_syscall, ret);
+#endif
+
+	/* Write again to end poll. */
+	ASSERT_EQ(0, ptrace(PTRACE_CONT, child_pid, NULL, 0));
+	ASSERT_EQ(1, write(pipefd[1], "!", 1));
+	EXPECT_EQ(0, close(pipefd[1]));
+
+	ASSERT_EQ(child_pid, waitpid(child_pid, &status, 0));
+	if (WIFSIGNALED(status) || WEXITSTATUS(status))
+		_metadata->passed = 0;
+}
+
+/*
+ * TODO:
+ * - add microbenchmarks
+ * - expand NNP testing
+ * - better arch-specific TRACE and TRAP handlers.
+ * - endianness checking when appropriate
+ * - 64-bit arg prodding
+ * - arch value testing (x86 modes especially)
+ * - ...
+ */
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/seccomp/test_harness.h b/tools/testing/selftests/seccomp/test_harness.h
new file mode 100644
index 000000000000..977a6afc4489
--- /dev/null
+++ b/tools/testing/selftests/seccomp/test_harness.h
@@ -0,0 +1,537 @@
+/*
+ * Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
+ * Use of this source code is governed by the GPLv2 license.
+ *
+ * test_harness.h: simple C unit test helper.
+ *
+ * Usage:
+ *   #include "test_harness.h"
+ *   TEST(standalone_test) {
+ *     do_some_stuff;
+ *     EXPECT_GT(10, stuff) {
+ *        stuff_state_t state;
+ *        enumerate_stuff_state(&state);
+ *        TH_LOG("expectation failed with state: %s", state.msg);
+ *     }
+ *     more_stuff;
+ *     ASSERT_NE(some_stuff, NULL) TH_LOG("how did it happen?!");
+ *     last_stuff;
+ *     EXPECT_EQ(0, last_stuff);
+ *   }
+ *
+ *   FIXTURE(my_fixture) {
+ *     mytype_t *data;
+ *     int awesomeness_level;
+ *   };
+ *   FIXTURE_SETUP(my_fixture) {
+ *     self->data = mytype_new();
+ *     ASSERT_NE(NULL, self->data);
+ *   }
+ *   FIXTURE_TEARDOWN(my_fixture) {
+ *     mytype_free(self->data);
+ *   }
+ *   TEST_F(my_fixture, data_is_good) {
+ *     EXPECT_EQ(1, is_my_data_good(self->data));
+ *   }
+ *
+ *   TEST_HARNESS_MAIN
+ *
+ * API inspired by code.google.com/p/googletest
+ */
+#ifndef TEST_HARNESS_H_
+#define TEST_HARNESS_H_
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+/* All exported functionality should be declared through this macro. */
+#define TEST_API(x) _##x
+
+/*
+ * Exported APIs
+ */
+
+/* TEST(name) { implementation }
+ * Defines a test by name.
+ * Names must be unique and tests must not be run in parallel.  The
+ * implementation containing block is a function and scoping should be treated
+ * as such.  Returning early may be performed with a bare "return;" statement.
+ *
+ * EXPECT_* and ASSERT_* are valid in a TEST() { } context.
+ */
+#define TEST TEST_API(TEST)
+
+/* TEST_SIGNAL(name, signal) { implementation }
+ * Defines a test by name and the expected term signal.
+ * Names must be unique and tests must not be run in parallel.  The
+ * implementation containing block is a function and scoping should be treated
+ * as such.  Returning early may be performed with a bare "return;" statement.
+ *
+ * EXPECT_* and ASSERT_* are valid in a TEST() { } context.
+ */
+#define TEST_SIGNAL TEST_API(TEST_SIGNAL)
+
+/* FIXTURE(datatype name) {
+ *   type property1;
+ *   ...
+ * };
+ * Defines the data provided to TEST_F()-defined tests as |self|.  It should be
+ * populated and cleaned up using FIXTURE_SETUP and FIXTURE_TEARDOWN.
+ */
+#define FIXTURE TEST_API(FIXTURE)
+
+/* FIXTURE_DATA(datatype name)
+ * This call may be used when the type of the fixture data
+ * is needed.  In general, this should not be needed unless
+ * the |self| is being passed to a helper directly.
+ */
+#define FIXTURE_DATA TEST_API(FIXTURE_DATA)
+
+/* FIXTURE_SETUP(fixture name) { implementation }
+ * Populates the required "setup" function for a fixture.  An instance of the
+ * datatype defined with _FIXTURE_DATA will be exposed as |self| for the
+ * implementation.
+ *
+ * ASSERT_* are valid for use in this context and will prempt the execution
+ * of any dependent fixture tests.
+ *
+ * A bare "return;" statement may be used to return early.
+ */
+#define FIXTURE_SETUP TEST_API(FIXTURE_SETUP)
+
+/* FIXTURE_TEARDOWN(fixture name) { implementation }
+ * Populates the required "teardown" function for a fixture.  An instance of the
+ * datatype defined with _FIXTURE_DATA will be exposed as |self| for the
+ * implementation to clean up.
+ *
+ * A bare "return;" statement may be used to return early.
+ */
+#define FIXTURE_TEARDOWN TEST_API(FIXTURE_TEARDOWN)
+
+/* TEST_F(fixture, name) { implementation }
+ * Defines a test that depends on a fixture (e.g., is part of a test case).
+ * Very similar to TEST() except that |self| is the setup instance of fixture's
+ * datatype exposed for use by the implementation.
+ */
+#define TEST_F TEST_API(TEST_F)
+
+#define TEST_F_SIGNAL TEST_API(TEST_F_SIGNAL)
+
+/* Use once to append a main() to the test file. E.g.,
+ *   TEST_HARNESS_MAIN
+ */
+#define TEST_HARNESS_MAIN TEST_API(TEST_HARNESS_MAIN)
+
+/*
+ * Operators for use in TEST and TEST_F.
+ * ASSERT_* calls will stop test execution immediately.
+ * EXPECT_* calls will emit a failure warning, note it, and continue.
+ */
+
+/* ASSERT_EQ(expected, measured): expected == measured */
+#define ASSERT_EQ TEST_API(ASSERT_EQ)
+/* ASSERT_NE(expected, measured): expected != measured */
+#define ASSERT_NE TEST_API(ASSERT_NE)
+/* ASSERT_LT(expected, measured): expected < measured */
+#define ASSERT_LT TEST_API(ASSERT_LT)
+/* ASSERT_LE(expected, measured): expected <= measured */
+#define ASSERT_LE TEST_API(ASSERT_LE)
+/* ASSERT_GT(expected, measured): expected > measured */
+#define ASSERT_GT TEST_API(ASSERT_GT)
+/* ASSERT_GE(expected, measured): expected >= measured */
+#define ASSERT_GE TEST_API(ASSERT_GE)
+/* ASSERT_NULL(measured): NULL == measured */
+#define ASSERT_NULL TEST_API(ASSERT_NULL)
+/* ASSERT_TRUE(measured): measured != 0 */
+#define ASSERT_TRUE TEST_API(ASSERT_TRUE)
+/* ASSERT_FALSE(measured): measured == 0 */
+#define ASSERT_FALSE TEST_API(ASSERT_FALSE)
+/* ASSERT_STREQ(expected, measured): !strcmp(expected, measured) */
+#define ASSERT_STREQ TEST_API(ASSERT_STREQ)
+/* ASSERT_STRNE(expected, measured): strcmp(expected, measured) */
+#define ASSERT_STRNE TEST_API(ASSERT_STRNE)
+/* EXPECT_EQ(expected, measured): expected == measured */
+#define EXPECT_EQ TEST_API(EXPECT_EQ)
+/* EXPECT_NE(expected, measured): expected != measured */
+#define EXPECT_NE TEST_API(EXPECT_NE)
+/* EXPECT_LT(expected, measured): expected < measured */
+#define EXPECT_LT TEST_API(EXPECT_LT)
+/* EXPECT_LE(expected, measured): expected <= measured */
+#define EXPECT_LE TEST_API(EXPECT_LE)
+/* EXPECT_GT(expected, measured): expected > measured */
+#define EXPECT_GT TEST_API(EXPECT_GT)
+/* EXPECT_GE(expected, measured): expected >= measured */
+#define EXPECT_GE TEST_API(EXPECT_GE)
+/* EXPECT_NULL(measured): NULL == measured */
+#define EXPECT_NULL TEST_API(EXPECT_NULL)
+/* EXPECT_TRUE(measured): 0 != measured */
+#define EXPECT_TRUE TEST_API(EXPECT_TRUE)
+/* EXPECT_FALSE(measured): 0 == measured */
+#define EXPECT_FALSE TEST_API(EXPECT_FALSE)
+/* EXPECT_STREQ(expected, measured): !strcmp(expected, measured) */
+#define EXPECT_STREQ TEST_API(EXPECT_STREQ)
+/* EXPECT_STRNE(expected, measured): strcmp(expected, measured) */
+#define EXPECT_STRNE TEST_API(EXPECT_STRNE)
+
+/* TH_LOG(format, ...)
+ * Optional debug logging function available for use in tests.
+ * Logging may be enabled or disabled by defining TH_LOG_ENABLED.
+ * E.g., #define TH_LOG_ENABLED 1
+ * If no definition is provided, logging is enabled by default.
+ */
+#define TH_LOG  TEST_API(TH_LOG)
+
+/*
+ * Internal implementation.
+ *
+ */
+
+/* Utilities exposed to the test definitions */
+#ifndef TH_LOG_STREAM
+#  define TH_LOG_STREAM stderr
+#endif
+
+#ifndef TH_LOG_ENABLED
+#  define TH_LOG_ENABLED 1
+#endif
+
+#define _TH_LOG(fmt, ...) do { \
+	if (TH_LOG_ENABLED) \
+		__TH_LOG(fmt, ##__VA_ARGS__); \
+} while (0)
+
+/* Unconditional logger for internal use. */
+#define __TH_LOG(fmt, ...) \
+		fprintf(TH_LOG_STREAM, "%s:%d:%s:" fmt "\n", \
+			__FILE__, __LINE__, _metadata->name, ##__VA_ARGS__)
+
+/* Defines the test function and creates the registration stub. */
+#define _TEST(test_name) __TEST_IMPL(test_name, -1)
+
+#define _TEST_SIGNAL(test_name, signal) __TEST_IMPL(test_name, signal)
+
+#define __TEST_IMPL(test_name, _signal) \
+	static void test_name(struct __test_metadata *_metadata); \
+	static struct __test_metadata _##test_name##_object = \
+		{ name: "global." #test_name, \
+		  fn: &test_name, termsig: _signal }; \
+	static void __attribute__((constructor)) _register_##test_name(void) \
+	{ \
+		__register_test(&_##test_name##_object); \
+	} \
+	static void test_name( \
+		struct __test_metadata __attribute__((unused)) *_metadata)
+
+/* Wraps the struct name so we have one less argument to pass around. */
+#define _FIXTURE_DATA(fixture_name) struct _test_data_##fixture_name
+
+/* Called once per fixture to setup the data and register. */
+#define _FIXTURE(fixture_name) \
+	static void __attribute__((constructor)) \
+	_register_##fixture_name##_data(void) \
+	{ \
+		__fixture_count++; \
+	} \
+	_FIXTURE_DATA(fixture_name)
+
+/* Prepares the setup function for the fixture.  |_metadata| is included
+ * so that ASSERT_* work as a convenience.
+ */
+#define _FIXTURE_SETUP(fixture_name) \
+	void fixture_name##_setup( \
+		struct __test_metadata __attribute__((unused)) *_metadata, \
+		_FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
+#define _FIXTURE_TEARDOWN(fixture_name) \
+	void fixture_name##_teardown( \
+		struct __test_metadata __attribute__((unused)) *_metadata, \
+		_FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
+
+/* Emits test registration and helpers for fixture-based test
+ * cases.
+ * TODO(wad) register fixtures on dedicated test lists.
+ */
+#define _TEST_F(fixture_name, test_name) \
+	__TEST_F_IMPL(fixture_name, test_name, -1)
+
+#define _TEST_F_SIGNAL(fixture_name, test_name, signal) \
+	__TEST_F_IMPL(fixture_name, test_name, signal)
+
+#define __TEST_F_IMPL(fixture_name, test_name, signal) \
+	static void fixture_name##_##test_name( \
+		struct __test_metadata *_metadata, \
+		_FIXTURE_DATA(fixture_name) *self); \
+	static inline void wrapper_##fixture_name##_##test_name( \
+		struct __test_metadata *_metadata) \
+	{ \
+		/* fixture data is alloced, setup, and torn down per call. */ \
+		_FIXTURE_DATA(fixture_name) self; \
+		memset(&self, 0, sizeof(_FIXTURE_DATA(fixture_name))); \
+		fixture_name##_setup(_metadata, &self); \
+		/* Let setup failure terminate early. */ \
+		if (!_metadata->passed) \
+			return; \
+		fixture_name##_##test_name(_metadata, &self); \
+		fixture_name##_teardown(_metadata, &self); \
+	} \
+	static struct __test_metadata \
+		      _##fixture_name##_##test_name##_object = { \
+		name: #fixture_name "." #test_name, \
+		fn: &wrapper_##fixture_name##_##test_name, \
+		termsig: signal, \
+	 }; \
+	static void __attribute__((constructor)) \
+			_register_##fixture_name##_##test_name(void) \
+	{ \
+		__register_test(&_##fixture_name##_##test_name##_object); \
+	} \
+	static void fixture_name##_##test_name( \
+		struct __test_metadata __attribute__((unused)) *_metadata, \
+		_FIXTURE_DATA(fixture_name) __attribute__((unused)) *self)
+
+/* Exports a simple wrapper to run the test harness. */
+#define _TEST_HARNESS_MAIN \
+	static void __attribute__((constructor)) \
+	__constructor_order_last(void) \
+	{ \
+		if (!__constructor_order) \
+			__constructor_order = _CONSTRUCTOR_ORDER_BACKWARD; \
+	} \
+	int main(int argc, char **argv) { \
+		return test_harness_run(argc, argv); \
+	}
+
+#define _ASSERT_EQ(_expected, _seen) \
+	__EXPECT(_expected, _seen, ==, 1)
+#define _ASSERT_NE(_expected, _seen) \
+	__EXPECT(_expected, _seen, !=, 1)
+#define _ASSERT_LT(_expected, _seen) \
+	__EXPECT(_expected, _seen, <, 1)
+#define _ASSERT_LE(_expected, _seen) \
+	__EXPECT(_expected, _seen, <=, 1)
+#define _ASSERT_GT(_expected, _seen) \
+	__EXPECT(_expected, _seen, >, 1)
+#define _ASSERT_GE(_expected, _seen) \
+	__EXPECT(_expected, _seen, >=, 1)
+#define _ASSERT_NULL(_seen) \
+	__EXPECT(NULL, _seen, ==, 1)
+
+#define _ASSERT_TRUE(_seen) \
+	_ASSERT_NE(0, _seen)
+#define _ASSERT_FALSE(_seen) \
+	_ASSERT_EQ(0, _seen)
+#define _ASSERT_STREQ(_expected, _seen) \
+	__EXPECT_STR(_expected, _seen, ==, 1)
+#define _ASSERT_STRNE(_expected, _seen) \
+	__EXPECT_STR(_expected, _seen, !=, 1)
+
+#define _EXPECT_EQ(_expected, _seen) \
+	__EXPECT(_expected, _seen, ==, 0)
+#define _EXPECT_NE(_expected, _seen) \
+	__EXPECT(_expected, _seen, !=, 0)
+#define _EXPECT_LT(_expected, _seen) \
+	__EXPECT(_expected, _seen, <, 0)
+#define _EXPECT_LE(_expected, _seen) \
+	__EXPECT(_expected, _seen, <=, 0)
+#define _EXPECT_GT(_expected, _seen) \
+	__EXPECT(_expected, _seen, >, 0)
+#define _EXPECT_GE(_expected, _seen) \
+	__EXPECT(_expected, _seen, >=, 0)
+
+#define _EXPECT_NULL(_seen) \
+	__EXPECT(NULL, _seen, ==, 0)
+#define _EXPECT_TRUE(_seen) \
+	_EXPECT_NE(0, _seen)
+#define _EXPECT_FALSE(_seen) \
+	_EXPECT_EQ(0, _seen)
+
+#define _EXPECT_STREQ(_expected, _seen) \
+	__EXPECT_STR(_expected, _seen, ==, 0)
+#define _EXPECT_STRNE(_expected, _seen) \
+	__EXPECT_STR(_expected, _seen, !=, 0)
+
+#define ARRAY_SIZE(a)	(sizeof(a) / sizeof(a[0]))
+
+/* Support an optional handler after and ASSERT_* or EXPECT_*.  The approach is
+ * not thread-safe, but it should be fine in most sane test scenarios.
+ *
+ * Using __bail(), which optionally abort()s, is the easiest way to early
+ * return while still providing an optional block to the API consumer.
+ */
+#define OPTIONAL_HANDLER(_assert) \
+	for (; _metadata->trigger;  _metadata->trigger = __bail(_assert))
+
+#define __EXPECT(_expected, _seen, _t, _assert) do { \
+	/* Avoid multiple evaluation of the cases */ \
+	__typeof__(_expected) __exp = (_expected); \
+	__typeof__(_seen) __seen = (_seen); \
+	if (!(__exp _t __seen)) { \
+		unsigned long long __exp_print = 0; \
+		unsigned long long __seen_print = 0; \
+		/* Avoid casting complaints the scariest way we can. */ \
+		memcpy(&__exp_print, &__exp, sizeof(__exp)); \
+		memcpy(&__seen_print, &__seen, sizeof(__seen)); \
+		__TH_LOG("Expected %s (%llu) %s %s (%llu)", \
+			 #_expected, __exp_print, #_t, \
+			 #_seen, __seen_print); \
+		_metadata->passed = 0; \
+		/* Ensure the optional handler is triggered */ \
+		_metadata->trigger = 1; \
+	} \
+} while (0); OPTIONAL_HANDLER(_assert)
+
+#define __EXPECT_STR(_expected, _seen, _t, _assert) do { \
+	const char *__exp = (_expected); \
+	const char *__seen = (_seen); \
+	if (!(strcmp(__exp, __seen) _t 0))  { \
+		__TH_LOG("Expected '%s' %s '%s'.", __exp, #_t, __seen); \
+		_metadata->passed = 0; \
+		_metadata->trigger = 1; \
+	} \
+} while (0); OPTIONAL_HANDLER(_assert)
+
+/* Contains all the information for test execution and status checking. */
+struct __test_metadata {
+	const char *name;
+	void (*fn)(struct __test_metadata *);
+	int termsig;
+	int passed;
+	int trigger; /* extra handler after the evaluation */
+	struct __test_metadata *prev, *next;
+};
+
+/* Storage for the (global) tests to be run. */
+static struct __test_metadata *__test_list;
+static unsigned int __test_count;
+static unsigned int __fixture_count;
+static int __constructor_order;
+
+#define _CONSTRUCTOR_ORDER_FORWARD   1
+#define _CONSTRUCTOR_ORDER_BACKWARD -1
+
+/*
+ * Since constructors are called in reverse order, reverse the test
+ * list so tests are run in source declaration order.
+ * https://gcc.gnu.org/onlinedocs/gccint/Initialization.html
+ * However, it seems not all toolchains do this correctly, so use
+ * __constructor_order to detect which direction is called first
+ * and adjust list building logic to get things running in the right
+ * direction.
+ */
+static inline void __register_test(struct __test_metadata *t)
+{
+	__test_count++;
+	/* Circular linked list where only prev is circular. */
+	if (__test_list == NULL) {
+		__test_list = t;
+		t->next = NULL;
+		t->prev = t;
+		return;
+	}
+	if (__constructor_order == _CONSTRUCTOR_ORDER_FORWARD) {
+		t->next = NULL;
+		t->prev = __test_list->prev;
+		t->prev->next = t;
+		__test_list->prev = t;
+	} else {
+		t->next = __test_list;
+		t->next->prev = t;
+		t->prev = t;
+		__test_list = t;
+	}
+}
+
+static inline int __bail(int for_realz)
+{
+	if (for_realz)
+		abort();
+	return 0;
+}
+
+void __run_test(struct __test_metadata *t)
+{
+	pid_t child_pid;
+	int status;
+
+	t->passed = 1;
+	t->trigger = 0;
+	printf("[ RUN      ] %s\n", t->name);
+	child_pid = fork();
+	if (child_pid < 0) {
+		printf("ERROR SPAWNING TEST CHILD\n");
+		t->passed = 0;
+	} else if (child_pid == 0) {
+		t->fn(t);
+		_exit(t->passed);
+	} else {
+		/* TODO(wad) add timeout support. */
+		waitpid(child_pid, &status, 0);
+		if (WIFEXITED(status)) {
+			t->passed = t->termsig == -1 ? WEXITSTATUS(status) : 0;
+			if (t->termsig != -1) {
+				fprintf(TH_LOG_STREAM,
+					"%s: Test exited normally "
+					"instead of by signal (code: %d)\n",
+					t->name,
+					WEXITSTATUS(status));
+			}
+		} else if (WIFSIGNALED(status)) {
+			t->passed = 0;
+			if (WTERMSIG(status) == SIGABRT) {
+				fprintf(TH_LOG_STREAM,
+					"%s: Test terminated by assertion\n",
+					t->name);
+			} else if (WTERMSIG(status) == t->termsig) {
+				t->passed = 1;
+			} else {
+				fprintf(TH_LOG_STREAM,
+					"%s: Test terminated unexpectedly "
+					"by signal %d\n",
+					t->name,
+					WTERMSIG(status));
+			}
+		} else {
+			fprintf(TH_LOG_STREAM,
+				"%s: Test ended in some other way [%u]\n",
+				t->name,
+				status);
+		}
+	}
+	printf("[     %4s ] %s\n", (t->passed ? "OK" : "FAIL"), t->name);
+}
+
+static int test_harness_run(int __attribute__((unused)) argc,
+			    char __attribute__((unused)) **argv)
+{
+	struct __test_metadata *t;
+	int ret = 0;
+	unsigned int count = 0;
+	unsigned int pass_count = 0;
+
+	/* TODO(wad) add optional arguments similar to gtest. */
+	printf("[==========] Running %u tests from %u test cases.\n",
+	       __test_count, __fixture_count + 1);
+	for (t = __test_list; t; t = t->next) {
+		count++;
+		__run_test(t);
+		if (t->passed)
+			pass_count++;
+		else
+			ret = 1;
+	}
+	printf("[==========] %u / %u tests passed.\n", pass_count, count);
+	printf("[  %s  ]\n", (ret ? "FAILED" : "PASSED"));
+	return ret;
+}
+
+static void __attribute__((constructor)) __constructor_order_first(void)
+{
+	if (!__constructor_order)
+		__constructor_order = _CONSTRUCTOR_ORDER_FORWARD;
+}
+
+#endif  /* TEST_HARNESS_H_ */
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
