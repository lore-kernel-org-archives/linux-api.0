From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH bpf-next v8 10/11] bpf,landlock: Add tests for Landlock
Date: Tue, 27 Feb 2018 01:41:20 +0100
Message-ID: <20180227004121.3633-11-mic@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180227004121.3633-1-mic@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>
List-Id: linux-api@vger.kernel.org

Test basic context access, ptrace protection and filesystem hooks and
Landlock program chaining with multiple cases.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
---

Changes since v7:
* update tests and add new ones for filesystem hierarchy and Landlock
  chains.

Changes since v6:
* use the new kselftest_harness.h
* use const variables
* replace ASSERT_STEP with ASSERT_*
* rename BPF_PROG_TYPE_LANDLOCK to BPF_PROG_TYPE_LANDLOCK_RULE
* force sample library rebuild
* fix install target

Changes since v5:
* add subtype test
* add ptrace tests
* split and rename files
* cleanup and rebase
---
 tools/testing/selftests/Makefile               |   1 +
 tools/testing/selftests/bpf/bpf_helpers.h      |   7 +
 tools/testing/selftests/bpf/test_verifier.c    |  84 +++++
 tools/testing/selftests/landlock/.gitignore    |   5 +
 tools/testing/selftests/landlock/Makefile      |  35 ++
 tools/testing/selftests/landlock/test.h        |  31 ++
 tools/testing/selftests/landlock/test_base.c   |  27 ++
 tools/testing/selftests/landlock/test_chain.c  | 249 +++++++++++++
 tools/testing/selftests/landlock/test_fs.c     | 492 +++++++++++++++++++++++++
 tools/testing/selftests/landlock/test_ptrace.c | 158 ++++++++
 10 files changed, 1089 insertions(+)
 create mode 100644 tools/testing/selftests/landlock/.gitignore
 create mode 100644 tools/testing/selftests/landlock/Makefile
 create mode 100644 tools/testing/selftests/landlock/test.h
 create mode 100644 tools/testing/selftests/landlock/test_base.c
 create mode 100644 tools/testing/selftests/landlock/test_chain.c
 create mode 100644 tools/testing/selftests/landlock/test_fs.c
 create mode 100644 tools/testing/selftests/landlock/test_ptrace.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 7442dfb73b7f..5d00deb3cab6 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -14,6 +14,7 @@ TARGETS += gpio
 TARGETS += intel_pstate
 TARGETS += ipc
 TARGETS += kcmp
+TARGETS += landlock
 TARGETS += lib
 TARGETS += membarrier
 TARGETS += memfd
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index dde2c11d7771..414e267491f7 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -86,6 +86,13 @@ static int (*bpf_perf_prog_read_value)(void *ctx, void *buf,
 	(void *) BPF_FUNC_perf_prog_read_value;
 static int (*bpf_override_return)(void *ctx, unsigned long rc) =
 	(void *) BPF_FUNC_override_return;
+static unsigned long long (*bpf_inode_map_lookup)(void *map, void *key) =
+	(void *) BPF_FUNC_inode_map_lookup;
+static unsigned long long (*bpf_inode_get_tag)(void *inode, void *chain) =
+	(void *) BPF_FUNC_inode_get_tag;
+static unsigned long long (*bpf_landlock_set_tag)(void *tag_obj, void *chain,
+						  unsigned long long value) =
+	(void *) BPF_FUNC_landlock_set_tag;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 3c24a5a7bafc..5f68b95187fe 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -31,6 +31,7 @@
 #include <linux/bpf_perf_event.h>
 #include <linux/bpf.h>
 #include <linux/if_ether.h>
+#include <linux/landlock.h>
 
 #include <bpf/bpf.h>
 
@@ -11240,6 +11241,89 @@ static struct bpf_test tests[] = {
 		.result = REJECT,
 		.has_prog_subtype = true,
 	},
+	{
+		"missing subtype",
+		.insns = {
+			BPF_MOV32_IMM(BPF_REG_0, 0),
+			BPF_EXIT_INSN(),
+		},
+		.errstr = "",
+		.result = REJECT,
+		.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK,
+	},
+	{
+		"landlock/fs_pick: always accept",
+		.insns = {
+			BPF_MOV32_IMM(BPF_REG_0, 0),
+			BPF_EXIT_INSN(),
+		},
+		.result = ACCEPT,
+		.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK,
+		.has_prog_subtype = true,
+		.prog_subtype = {
+			.landlock_hook = {
+				.type = LANDLOCK_HOOK_FS_PICK,
+				.triggers = LANDLOCK_TRIGGER_FS_PICK_READ,
+			}
+		},
+	},
+	{
+		"landlock/fs_pick: read context",
+		.insns = {
+			BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_7, BPF_REG_6,
+				offsetof(struct landlock_ctx_fs_pick, cookie)),
+			/* test operations on raw values */
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_7, 1),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_7, BPF_REG_6,
+				offsetof(struct landlock_ctx_fs_pick, inode)),
+			BPF_MOV32_IMM(BPF_REG_0, 0),
+			BPF_EXIT_INSN(),
+		},
+		.result = ACCEPT,
+		.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK,
+		.has_prog_subtype = true,
+		.prog_subtype = {
+			.landlock_hook = {
+				.type = LANDLOCK_HOOK_FS_PICK,
+				.triggers = LANDLOCK_TRIGGER_FS_PICK_READ,
+			}
+		},
+	},
+	{
+		"landlock/fs_pick: no option for previous program",
+		.insns = {
+			BPF_MOV32_IMM(BPF_REG_0, 0),
+			BPF_EXIT_INSN(),
+		},
+		.errstr = "",
+		.result = REJECT,
+		.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK,
+		.prog_subtype = {
+			.landlock_hook = {
+				.type = LANDLOCK_HOOK_FS_PICK,
+				.previous = 1,
+			}
+		},
+	},
+	{
+		"landlock/fs_pick: bad previous program FD",
+		.insns = {
+			BPF_MOV32_IMM(BPF_REG_0, 0),
+			BPF_EXIT_INSN(),
+		},
+		.errstr = "",
+		.result = REJECT,
+		.prog_type = BPF_PROG_TYPE_LANDLOCK_HOOK,
+		.prog_subtype = {
+			.landlock_hook = {
+				.type = LANDLOCK_HOOK_FS_PICK,
+				.options = LANDLOCK_OPTION_PREVIOUS,
+				/* assume FD 0 is a TTY or a pipe */
+				.previous = 0,
+			}
+		},
+	},
 };
 
 static int probe_filter_length(const struct bpf_insn *fp)
diff --git a/tools/testing/selftests/landlock/.gitignore b/tools/testing/selftests/landlock/.gitignore
new file mode 100644
index 000000000000..d4e365980c9c
--- /dev/null
+++ b/tools/testing/selftests/landlock/.gitignore
@@ -0,0 +1,5 @@
+/test_base
+/test_chain
+/test_fs
+/test_ptrace
+/tmp_*
diff --git a/tools/testing/selftests/landlock/Makefile b/tools/testing/selftests/landlock/Makefile
new file mode 100644
index 000000000000..9b2791ded1cc
--- /dev/null
+++ b/tools/testing/selftests/landlock/Makefile
@@ -0,0 +1,35 @@
+LIBDIR := ../../../lib
+OBJDIR := ../../../lib/bpf
+BPFOBJS := $(OBJDIR)/bpf.o $(OBJDIR)/nlattr.o
+LOADOBJ := ../../../../samples/bpf/bpf_load.o
+
+CFLAGS += -Wl,-no-as-needed -Wall -O2 -I../../../include/uapi -I$(LIBDIR)
+LDFLAGS += -lelf
+
+test_src = $(wildcard test_*.c)
+
+test_objs := $(test_src:.c=)
+
+TEST_PROGS := $(test_objs)
+
+.PHONY: all clean force
+
+all: $(test_objs)
+
+# force a rebuild of BPFOBJS when its dependencies are updated
+force:
+
+# rebuild bpf.o as a workaround for the samples/bpf bug
+$(BPFOBJS): $(LOADOBJ) force
+	$(MAKE) -C $(OBJDIR)
+
+$(LOADOBJ): force
+	$(MAKE) -C $(dir $(LOADOBJ))
+
+$(test_objs): $(BPFOBJS) $(LOADOBJ) ../kselftest_harness.h
+
+include ../lib.mk
+
+clean:
+	$(RM) $(test_objs)
+
diff --git a/tools/testing/selftests/landlock/test.h b/tools/testing/selftests/landlock/test.h
new file mode 100644
index 000000000000..3046516488d9
--- /dev/null
+++ b/tools/testing/selftests/landlock/test.h
@@ -0,0 +1,31 @@
+/*
+ * Landlock helpers
+ *
+ * Copyright © 2017 Mickaël Salaün <mic@digikod.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <errno.h>
+#include <linux/landlock.h>
+#include <linux/seccomp.h>
+#include <sys/prctl.h>
+#include <sys/syscall.h>
+
+#include "../kselftest_harness.h"
+#include "../../../../samples/bpf/bpf_load.h"
+
+#ifndef SECCOMP_PREPEND_LANDLOCK_PROG
+#define SECCOMP_PREPEND_LANDLOCK_PROG	3
+#endif
+
+#ifndef seccomp
+static int __attribute__((unused)) seccomp(unsigned int op, unsigned int flags,
+		void *args)
+{
+	errno = 0;
+	return syscall(__NR_seccomp, op, flags, args);
+}
+#endif
diff --git a/tools/testing/selftests/landlock/test_base.c b/tools/testing/selftests/landlock/test_base.c
new file mode 100644
index 000000000000..3ad18a779ecf
--- /dev/null
+++ b/tools/testing/selftests/landlock/test_base.c
@@ -0,0 +1,27 @@
+/*
+ * Landlock tests - base
+ *
+ * Copyright © 2017 Mickaël Salaün <mic@digikod.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#define _GNU_SOURCE
+#include <errno.h>
+
+#include "test.h"
+
+TEST(seccomp_landlock)
+{
+	int ret;
+
+	ret = seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, NULL);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(EFAULT, errno) {
+		TH_LOG("Kernel does not support CONFIG_SECURITY_LANDLOCK");
+	}
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/landlock/test_chain.c b/tools/testing/selftests/landlock/test_chain.c
new file mode 100644
index 000000000000..916e84802fd4
--- /dev/null
+++ b/tools/testing/selftests/landlock/test_chain.c
@@ -0,0 +1,249 @@
+/*
+ * Landlock tests - chain
+ *
+ * Copyright © 2018 Mickaël Salaün <mic@digikod.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <errno.h>
+
+#include "test.h"
+
+static int new_prog(struct __test_metadata *_metadata, int is_valid,
+		__u32 hook_type, int prev)
+{
+	const struct bpf_insn prog_accept[] = {
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+	union bpf_prog_subtype subtype = {
+		.landlock_hook = {
+			.type = hook_type,
+			.triggers = hook_type == LANDLOCK_HOOK_FS_PICK ?
+				LANDLOCK_TRIGGER_FS_PICK_OPEN : 0,
+		}
+	};
+	int prog;
+	char log[256] = "";
+
+	if (prev != -1) {
+		subtype.landlock_hook.options = LANDLOCK_OPTION_PREVIOUS;
+		subtype.landlock_hook.previous = prev;
+	}
+	prog = bpf_load_program(BPF_PROG_TYPE_LANDLOCK_HOOK,
+			(const struct bpf_insn *)&prog_accept,
+			sizeof(prog_accept) / sizeof(struct bpf_insn), "GPL",
+			0, log, sizeof(log), &subtype);
+	if (is_valid) {
+		ASSERT_NE(-1, prog) {
+			TH_LOG("Failed to load program: %s\n%s",
+					strerror(errno), log);
+		}
+	} else {
+		ASSERT_EQ(-1, prog) {
+			TH_LOG("Successfully loaded a wrong program\n");
+		}
+		ASSERT_EQ(errno, EINVAL);
+	}
+	return prog;
+}
+
+static void apply_chain(struct __test_metadata *_metadata, int is_valid,
+		int prog)
+{
+	if (is_valid) {
+		ASSERT_EQ(0, seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, &prog)) {
+			TH_LOG("Failed to apply chain: %s", strerror(errno));
+		}
+	} else {
+		ASSERT_NE(0, seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, &prog)) {
+			TH_LOG("Successfully applied a wrong chain");
+		}
+		ASSERT_EQ(errno, EINVAL);
+	}
+}
+
+TEST(chain_fs_good_walk_pick)
+{
+	/* fs_walk1 -> [fs_pick1] */
+	int fs_walk1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_WALK, -1);
+	int fs_pick1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_walk1);
+	apply_chain(_metadata, 1, fs_pick1);
+	EXPECT_EQ(0, close(fs_pick1));
+	EXPECT_EQ(0, close(fs_walk1));
+}
+
+TEST(chain_fs_good_pick_pick)
+{
+	/* fs_pick1 -> [fs_pick2] */
+	int fs_pick1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, -1);
+	int fs_pick2 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_pick1);
+	apply_chain(_metadata, 1, fs_pick2);
+	EXPECT_EQ(0, close(fs_pick2));
+	EXPECT_EQ(0, close(fs_pick1));
+}
+
+TEST(chain_fs_wrong_pick_walk)
+{
+	/* fs_pick1 -> fs_walk1 */
+	int fs_pick1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, -1);
+	new_prog(_metadata, 0, LANDLOCK_HOOK_FS_WALK, fs_pick1);
+	EXPECT_EQ(0, close(fs_pick1));
+}
+
+TEST(chain_fs_wrong_walk_walk)
+{
+	/* fs_walk1 -> fs_walk2 */
+	int fs_walk1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_WALK, -1);
+	new_prog(_metadata, 0, LANDLOCK_HOOK_FS_WALK, fs_walk1);
+	EXPECT_EQ(0, close(fs_walk1));
+}
+
+TEST(chain_fs_good_pick_get)
+{
+	/* fs_pick1 -> [fs_get1] */
+	int fs_pick1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, -1);
+	int fs_get1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_GET, fs_pick1);
+	apply_chain(_metadata, 1, fs_get1);
+	EXPECT_EQ(0, close(fs_get1));
+	EXPECT_EQ(0, close(fs_pick1));
+}
+
+TEST(chain_fs_wrong_get_get)
+{
+	/* fs_get1 -> [fs_get2] */
+	int fs_get1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_WALK, -1);
+	new_prog(_metadata, 0, LANDLOCK_HOOK_FS_GET, fs_get1);
+	EXPECT_EQ(0, close(fs_get1));
+}
+
+TEST(chain_fs_wrong_tree_1)
+{
+	/* [fs_walk1] -> { [fs_pick1] , [fs_pick2] } */
+	int fs_walk1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_WALK, -1);
+	apply_chain(_metadata, 1, fs_walk1);
+	int fs_pick1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_walk1);
+	apply_chain(_metadata, 0, fs_pick1);
+	int fs_pick2 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_walk1);
+	apply_chain(_metadata, 0, fs_pick2);
+	EXPECT_EQ(0, close(fs_pick2));
+	EXPECT_EQ(0, close(fs_pick1));
+	EXPECT_EQ(0, close(fs_walk1));
+}
+
+TEST(chain_fs_wrong_tree_2)
+{
+	/* fs_walk1 -> { [fs_pick1] , [fs_pick2] } */
+	int fs_walk1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_WALK, -1);
+	int fs_pick1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_walk1);
+	apply_chain(_metadata, 1, fs_pick1);
+	int fs_pick2 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_walk1);
+	apply_chain(_metadata, 0, fs_pick2);
+	EXPECT_EQ(0, close(fs_pick2));
+	EXPECT_EQ(0, close(fs_pick1));
+	EXPECT_EQ(0, close(fs_walk1));
+}
+
+TEST(chain_fs_wrong_tree_3)
+{
+	/* fs_walk1 -> [fs_pick1] -> [fs_pick2] */
+	int fs_walk1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_WALK, -1);
+	int fs_pick1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_walk1);
+	apply_chain(_metadata, 1, fs_pick1);
+	int fs_pick2 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_pick1);
+	apply_chain(_metadata, 0, fs_pick2);
+	EXPECT_EQ(0, close(fs_pick2));
+	EXPECT_EQ(0, close(fs_pick1));
+	EXPECT_EQ(0, close(fs_walk1));
+}
+
+TEST(chain_fs_wrong_tree_4)
+{
+	/* fs_walk1 -> fs_pick1 -> fs_pick2 -> { [fs_get1] , [fs_get2] } */
+	int fs_walk1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_WALK, -1);
+	int fs_pick1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_walk1);
+	int fs_pick2 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_pick1);
+	int fs_get1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_GET, fs_pick2);
+	apply_chain(_metadata, 1, fs_get1);
+	int fs_get2 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_GET, fs_pick2);
+	apply_chain(_metadata, 0, fs_get2);
+	EXPECT_EQ(0, close(fs_get2));
+	EXPECT_EQ(0, close(fs_get1));
+	EXPECT_EQ(0, close(fs_pick2));
+	EXPECT_EQ(0, close(fs_pick1));
+	EXPECT_EQ(0, close(fs_walk1));
+}
+
+TEST(chain_fs_wrong_tree_5)
+{
+	/* fs_walk1 -> fs_pick1 -> { [fs_pick2] , [fs_pick3] } */
+	int fs_walk1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_WALK, -1);
+	int fs_pick1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_walk1);
+	int fs_pick2 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_pick1);
+	apply_chain(_metadata, 1, fs_pick2);
+	int fs_pick3 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_pick1);
+	apply_chain(_metadata, 0, fs_pick3);
+	EXPECT_EQ(0, close(fs_pick3));
+	EXPECT_EQ(0, close(fs_pick2));
+	EXPECT_EQ(0, close(fs_pick1));
+	EXPECT_EQ(0, close(fs_walk1));
+}
+
+TEST(chain_fs_wrong_tree_6)
+{
+	/* thread 1: fs_walk1 -> fs_pick1 -> [fs_pick2] */
+	/* thread 2: fs_walk1 -> fs_pick1 -> [fs_pick2] -> [fs_get1] */
+	int child;
+	int fs_walk1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_WALK, -1);
+	int fs_pick1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_walk1);
+	int fs_pick2 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_pick1);
+	apply_chain(_metadata, 1, fs_pick2);
+	child = fork();
+	if (child) {
+		/* parent */
+		int status;
+		waitpid(child, &status, 0);
+		EXPECT_TRUE(WIFEXITED(status) && !WEXITSTATUS(status));
+	} else {
+		/* child */
+		int fs_get1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_GET,
+				fs_pick2);
+		apply_chain(_metadata, 0, fs_get1);
+		_exit(0);
+	}
+	EXPECT_EQ(0, close(fs_pick2));
+	EXPECT_EQ(0, close(fs_pick1));
+	EXPECT_EQ(0, close(fs_walk1));
+}
+
+TEST(chain_fs_good_tree_1)
+{
+	/* fs_walk1 -> fs_pick1 -> [fs_pick2] */
+	int fs_walk1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_WALK, -1);
+	int fs_pick1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_walk1);
+	int fs_pick2 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_pick1);
+	apply_chain(_metadata, 1, fs_pick2);
+	EXPECT_EQ(0, close(fs_pick2));
+	EXPECT_EQ(0, close(fs_pick1));
+	EXPECT_EQ(0, close(fs_walk1));
+}
+
+TEST(chain_fs_good_tree_2)
+{
+	/* fs_walk1 -> fs_pick1 -> [fs_pick2] -> [fs_get1] */
+	int fs_walk1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_WALK, -1);
+	int fs_pick1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_walk1);
+	int fs_pick2 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_PICK, fs_pick1);
+	apply_chain(_metadata, 1, fs_pick2);
+	int fs_get1 = new_prog(_metadata, 1, LANDLOCK_HOOK_FS_GET, fs_pick2);
+	apply_chain(_metadata, 1, fs_get1);
+	EXPECT_EQ(0, close(fs_get1));
+	EXPECT_EQ(0, close(fs_pick2));
+	EXPECT_EQ(0, close(fs_pick1));
+	EXPECT_EQ(0, close(fs_walk1));
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/landlock/test_fs.c b/tools/testing/selftests/landlock/test_fs.c
new file mode 100644
index 000000000000..54d85b16aafb
--- /dev/null
+++ b/tools/testing/selftests/landlock/test_fs.c
@@ -0,0 +1,492 @@
+/*
+ * Landlock tests - file system
+ *
+ * Copyright © 2018 Mickaël Salaün <mic@digikod.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <fcntl.h> /* O_DIRECTORY */
+#include <sys/stat.h> /* statbuf */
+#include <unistd.h> /* faccessat() */
+
+#include "test.h"
+
+#define TEST_PATH_TRIGGERS ( \
+		LANDLOCK_TRIGGER_FS_PICK_OPEN | \
+		LANDLOCK_TRIGGER_FS_PICK_READDIR | \
+		LANDLOCK_TRIGGER_FS_PICK_EXECUTE | \
+		LANDLOCK_TRIGGER_FS_PICK_GETATTR)
+
+static void enforce_depth(struct __test_metadata *_metadata, int depth)
+{
+	const struct bpf_insn prog_walk[] = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1,
+			offsetof(struct landlock_ctx_fs_walk, cookie)),
+		BPF_LDX_MEM(BPF_B, BPF_REG_7, BPF_REG_1,
+			offsetof(struct landlock_ctx_fs_walk, inode_lookup)),
+		BPF_JMP_IMM(BPF_JNE, BPF_REG_7,
+				LANDLOCK_CTX_FS_WALK_INODE_LOOKUP_DOTDOT, 3),
+		/* assume 1 is the root */
+		BPF_JMP_IMM(BPF_JEQ, BPF_REG_6, 1, 4),
+		BPF_ALU64_IMM(BPF_SUB, BPF_REG_6, 1),
+		BPF_JMP_IMM(BPF_JA, 0, 0, 2),
+		BPF_JMP_IMM(BPF_JEQ, BPF_REG_7,
+				LANDLOCK_CTX_FS_WALK_INODE_LOOKUP_DOT, 1),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, 1),
+		BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
+			offsetof(struct landlock_ctx_fs_walk, cookie)),
+		BPF_MOV32_IMM(BPF_REG_0, LANDLOCK_RET_ALLOW),
+		BPF_EXIT_INSN(),
+	};
+	const struct bpf_insn prog_pick[] = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1,
+			offsetof(struct landlock_ctx_fs_pick, cookie)),
+		/* allow without fs_walk */
+		BPF_JMP_IMM(BPF_JEQ, BPF_REG_6, 0, 11),
+		BPF_LDX_MEM(BPF_B, BPF_REG_7, BPF_REG_1,
+			offsetof(struct landlock_ctx_fs_walk, inode_lookup)),
+		BPF_JMP_IMM(BPF_JNE, BPF_REG_7,
+				LANDLOCK_CTX_FS_WALK_INODE_LOOKUP_DOTDOT, 3),
+		/* assume 1 is the root */
+		BPF_JMP_IMM(BPF_JEQ, BPF_REG_6, 1, 4),
+		BPF_ALU64_IMM(BPF_SUB, BPF_REG_6, 1),
+		BPF_JMP_IMM(BPF_JA, 0, 0, 2),
+		BPF_JMP_IMM(BPF_JEQ, BPF_REG_7,
+				LANDLOCK_CTX_FS_WALK_INODE_LOOKUP_DOT, 1),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_6, 1),
+		BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
+			offsetof(struct landlock_ctx_fs_walk, cookie)),
+		/* with fs_walk */
+		BPF_JMP_IMM(BPF_JEQ, BPF_REG_6, depth + 1, 2),
+		BPF_MOV32_IMM(BPF_REG_0, LANDLOCK_RET_DENY),
+		BPF_EXIT_INSN(),
+		BPF_MOV32_IMM(BPF_REG_0, LANDLOCK_RET_ALLOW),
+		BPF_EXIT_INSN(),
+	};
+	union bpf_prog_subtype subtype = {
+		.landlock_hook = {
+			.type = LANDLOCK_HOOK_FS_WALK,
+		}
+	};
+	int fd_walk, fd_pick;
+	char log[1030] = "";
+
+	fd_walk = bpf_load_program(BPF_PROG_TYPE_LANDLOCK_HOOK,
+			(const struct bpf_insn *)&prog_walk,
+			sizeof(prog_walk) / sizeof(struct bpf_insn), "GPL",
+			0, log, sizeof(log), &subtype);
+	ASSERT_NE(-1, fd_walk) {
+		TH_LOG("Failed to load fs_walk program: %s\n%s",
+				strerror(errno), log);
+	}
+
+	subtype.landlock_hook.type = LANDLOCK_HOOK_FS_PICK;
+	subtype.landlock_hook.options = LANDLOCK_OPTION_PREVIOUS;
+	subtype.landlock_hook.previous = fd_walk;
+	subtype.landlock_hook.triggers = TEST_PATH_TRIGGERS;
+	fd_pick = bpf_load_program(BPF_PROG_TYPE_LANDLOCK_HOOK,
+			(const struct bpf_insn *)&prog_pick,
+			sizeof(prog_pick) / sizeof(struct bpf_insn), "GPL",
+			0, log, sizeof(log), &subtype);
+	ASSERT_NE(-1, fd_pick) {
+		TH_LOG("Failed to load fs_pick program: %s\n%s",
+				strerror(errno), log);
+	}
+
+	ASSERT_EQ(0, seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, &fd_pick)) {
+		TH_LOG("Failed to apply Landlock chain: %s", strerror(errno));
+	}
+	EXPECT_EQ(0, close(fd_pick));
+	EXPECT_EQ(0, close(fd_walk));
+}
+
+static void test_path_rel(struct __test_metadata *_metadata, int dirfd,
+		const char *path, int ret)
+{
+	int fd;
+	struct stat statbuf;
+
+	ASSERT_EQ(ret, faccessat(dirfd, path, R_OK | X_OK, 0));
+	ASSERT_EQ(ret, fstatat(dirfd, path, &statbuf, 0));
+	fd = openat(dirfd, path, O_DIRECTORY);
+	if (ret) {
+		ASSERT_EQ(-1, fd);
+	} else {
+		ASSERT_NE(-1, fd);
+		EXPECT_EQ(0, close(fd));
+	}
+}
+
+static void test_path(struct __test_metadata *_metadata, const char *path,
+		int ret)
+{
+	return test_path_rel(_metadata, AT_FDCWD, path, ret);
+}
+
+const char d1[] = "/usr";
+const char d1_dotdot1[] = "/usr/share/..";
+const char d1_dotdot2[] = "/usr/../usr/share/..";
+const char d1_dotdot3[] = "/usr/../../usr/share/..";
+const char d1_dotdot4[] = "/usr/../../../usr/share/..";
+const char d1_dotdot5[] = "/usr/../../../usr/share/../.";
+const char d1_dotdot6[] = "/././usr/./share/..";
+const char d2[] = "/usr/share";
+const char d2_dotdot1[] = "/usr/share/doc/..";
+const char d2_dotdot2[] = "/usr/../usr/share";
+const char d3[] = "/usr/share/doc";
+const char d4[] = "/etc";
+
+TEST(fs_depth_free)
+{
+	test_path(_metadata, d1, 0);
+	test_path(_metadata, d2, 0);
+	test_path(_metadata, d3, 0);
+}
+
+TEST(fs_depth_1)
+{
+	enforce_depth(_metadata, 1);
+	test_path(_metadata, d1, 0);
+	test_path(_metadata, d1_dotdot1, 0);
+	test_path(_metadata, d1_dotdot2, 0);
+	test_path(_metadata, d1_dotdot3, 0);
+	test_path(_metadata, d1_dotdot4, 0);
+	test_path(_metadata, d1_dotdot5, 0);
+	test_path(_metadata, d1_dotdot6, 0);
+	test_path(_metadata, d2, -1);
+	test_path(_metadata, d2_dotdot1, -1);
+	test_path(_metadata, d2_dotdot2, -1);
+	test_path(_metadata, d3, -1);
+}
+
+TEST(fs_depth_2)
+{
+	enforce_depth(_metadata, 2);
+	test_path(_metadata, d1, -1);
+	test_path(_metadata, d1_dotdot1, -1);
+	test_path(_metadata, d1_dotdot2, -1);
+	test_path(_metadata, d1_dotdot3, -1);
+	test_path(_metadata, d1_dotdot4, -1);
+	test_path(_metadata, d1_dotdot5, -1);
+	test_path(_metadata, d1_dotdot6, -1);
+	test_path(_metadata, d2, 0);
+	test_path(_metadata, d2_dotdot2, 0);
+	test_path(_metadata, d2_dotdot1, 0);
+	test_path(_metadata, d3, -1);
+}
+
+#define MAP_VALUE_ALLOW 1
+#define COOKIE_VALUE_ALLOW 2
+
+static int create_inode_map(struct __test_metadata *_metadata,
+		const char *const dirs[])
+{
+	int map, key, i;
+	__u64 value = MAP_VALUE_ALLOW;
+
+	ASSERT_NE(NULL, dirs) {
+		TH_LOG("No directory list\n");
+	}
+	ASSERT_NE(NULL, dirs[0]) {
+		TH_LOG("Empty directory list\n");
+	}
+	for (i = 0; dirs[i]; i++);
+	map = bpf_create_map(BPF_MAP_TYPE_INODE, sizeof(key), sizeof(value),
+			i, 0);
+	ASSERT_NE(-1, map) {
+		TH_LOG("Failed to create a map of %d elements: %s\n", i,
+				strerror(errno));
+	}
+	for (i = 0; dirs[i]; i++) {
+		key = open(dirs[i], O_RDONLY | O_CLOEXEC | O_DIRECTORY);
+		ASSERT_NE(-1, key) {
+			TH_LOG("Failed to open directory \"%s\": %s\n", dirs[i],
+					strerror(errno));
+		}
+		ASSERT_EQ(0, bpf_map_update_elem(map, &key, &value, BPF_ANY)) {
+			TH_LOG("Failed to update the map with \"%s\": %s\n",
+					dirs[i], strerror(errno));
+		}
+		close(key);
+	}
+	return map;
+}
+
+#define TAG_VALUE_ALLOW 1
+
+static void enforce_map(struct __test_metadata *_metadata, int map,
+		bool subpath, bool tag)
+{
+	/* do not handle dot nor dotdot */
+	const struct bpf_insn prog_walk[] = {
+		BPF_ALU64_REG(BPF_MOV, BPF_REG_6, BPF_REG_1),
+		/* look at the inode's tag */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
+			offsetof(struct landlock_ctx_fs_walk, inode)),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_6,
+			offsetof(struct landlock_ctx_fs_walk, chain)),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+				BPF_FUNC_inode_get_tag),
+		BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, TAG_VALUE_ALLOW, 5),
+		/* look for the requested inode in the map */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_6,
+			offsetof(struct landlock_ctx_fs_walk, inode)),
+		BPF_LD_MAP_FD(BPF_REG_1, map), /* 2 instructions */
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+				BPF_FUNC_inode_map_lookup),
+		/* if it is there, then mark the session as such */
+		BPF_JMP_IMM(BPF_JNE, BPF_REG_0, MAP_VALUE_ALLOW, 2),
+		BPF_MOV64_IMM(BPF_REG_7, COOKIE_VALUE_ALLOW),
+		BPF_STX_MEM(BPF_DW, BPF_REG_6, BPF_REG_7,
+			offsetof(struct landlock_ctx_fs_walk, cookie)),
+		/* allow to walk anything... but not to pick anything */
+		BPF_MOV32_IMM(BPF_REG_0, LANDLOCK_RET_ALLOW),
+		BPF_EXIT_INSN(),
+	};
+	/* do not handle dot nor dotdot */
+	const struct bpf_insn prog_pick[] = {
+		BPF_ALU64_REG(BPF_MOV, BPF_REG_6, BPF_REG_1),
+		/* allow if the inode's tag is mark as such */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
+			offsetof(struct landlock_ctx_fs_pick, inode)),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_6,
+			offsetof(struct landlock_ctx_fs_pick, chain)),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+				BPF_FUNC_inode_get_tag),
+		BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, TAG_VALUE_ALLOW, 9),
+		/* look if the walk saw an inode in the whitelist */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_7, BPF_REG_6,
+			offsetof(struct landlock_ctx_fs_pick, cookie)),
+		/* if it was there, then allow access */
+		BPF_JMP_IMM(BPF_JEQ, BPF_REG_7, COOKIE_VALUE_ALLOW, 7),
+		/* otherwise, look for the requested inode in the map */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_6,
+			offsetof(struct landlock_ctx_fs_pick, inode)),
+		BPF_LD_MAP_FD(BPF_REG_1, map), /* 2 instructions */
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+				BPF_FUNC_inode_map_lookup),
+		/* if it is there, then allow access */
+		BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, MAP_VALUE_ALLOW, 2),
+		/* otherwise deny access */
+		BPF_MOV32_IMM(BPF_REG_0, LANDLOCK_RET_DENY),
+		BPF_EXIT_INSN(),
+		BPF_MOV32_IMM(BPF_REG_0, LANDLOCK_RET_ALLOW),
+		BPF_EXIT_INSN(),
+	};
+	const struct bpf_insn prog_get[] = {
+		BPF_ALU64_REG(BPF_MOV, BPF_REG_6, BPF_REG_1),
+		/* if prog_pick allowed this prog_get, then keep the state in
+		 * the inode's tag */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_6,
+			offsetof(struct landlock_ctx_fs_get, tag_object)),
+		BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_6,
+			offsetof(struct landlock_ctx_fs_get, chain)),
+		BPF_MOV64_IMM(BPF_REG_3, TAG_VALUE_ALLOW),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
+				BPF_FUNC_landlock_set_tag),
+		BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 2),
+		/* for this test, deny on error */
+		BPF_MOV32_IMM(BPF_REG_0, LANDLOCK_RET_DENY),
+		BPF_EXIT_INSN(),
+		/* the check was previously performed by prog_pick */
+		BPF_MOV32_IMM(BPF_REG_0, LANDLOCK_RET_ALLOW),
+		BPF_EXIT_INSN(),
+	};
+	union bpf_prog_subtype subtype = {};
+	int fd_walk = -1, fd_pick, fd_get, fd_last;
+	char log[1024] = "";
+
+	if (subpath) {
+		subtype.landlock_hook.type = LANDLOCK_HOOK_FS_WALK;
+		fd_walk = bpf_load_program(BPF_PROG_TYPE_LANDLOCK_HOOK,
+				(const struct bpf_insn *)&prog_walk,
+				sizeof(prog_walk) / sizeof(struct bpf_insn),
+				"GPL", 0, log, sizeof(log), &subtype);
+		ASSERT_NE(-1, fd_walk) {
+			TH_LOG("Failed to load fs_walk program: %s\n%s",
+					strerror(errno), log);
+		}
+		subtype.landlock_hook.options = LANDLOCK_OPTION_PREVIOUS;
+		subtype.landlock_hook.previous = fd_walk;
+	}
+
+	subtype.landlock_hook.type = LANDLOCK_HOOK_FS_PICK;
+	subtype.landlock_hook.triggers = TEST_PATH_TRIGGERS;
+	fd_pick = bpf_load_program(BPF_PROG_TYPE_LANDLOCK_HOOK,
+			(const struct bpf_insn *)&prog_pick,
+			sizeof(prog_pick) / sizeof(struct bpf_insn), "GPL", 0,
+			log, sizeof(log), &subtype);
+	ASSERT_NE(-1, fd_pick) {
+		TH_LOG("Failed to load fs_pick program: %s\n%s",
+				strerror(errno), log);
+	}
+	fd_last = fd_pick;
+
+	if (tag) {
+		subtype.landlock_hook.type = LANDLOCK_HOOK_FS_GET;
+		subtype.landlock_hook.triggers = 0;
+		subtype.landlock_hook.options = LANDLOCK_OPTION_PREVIOUS;
+		subtype.landlock_hook.previous = fd_pick;
+		fd_get = bpf_load_program(BPF_PROG_TYPE_LANDLOCK_HOOK,
+				(const struct bpf_insn *)&prog_get,
+				sizeof(prog_get) / sizeof(struct bpf_insn),
+				"GPL", 0, log, sizeof(log), &subtype);
+		ASSERT_NE(-1, fd_get) {
+			TH_LOG("Failed to load fs_get program: %s\n%s",
+					strerror(errno), log);
+		}
+		fd_last = fd_get;
+	}
+
+	ASSERT_EQ(0, seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, &fd_last)) {
+		TH_LOG("Failed to apply Landlock chain: %s", strerror(errno));
+	}
+	if (tag)
+		EXPECT_EQ(0, close(fd_get));
+	EXPECT_EQ(0, close(fd_pick));
+	if (subpath)
+		EXPECT_EQ(0, close(fd_walk));
+}
+
+/* do not handle dot nor dotdot */
+static void check_map_whitelist(struct __test_metadata *_metadata,
+		bool subpath)
+{
+	int map = create_inode_map(_metadata, (const char *const [])
+			{ d2, NULL });
+	ASSERT_NE(-1, map);
+	enforce_map(_metadata, map, subpath, false);
+	test_path(_metadata, d1, -1);
+	test_path(_metadata, d2, 0);
+	test_path(_metadata, d3, subpath ? 0 : -1);
+	EXPECT_EQ(0, close(map));
+}
+
+TEST(fs_map_whitelist_literal)
+{
+	check_map_whitelist(_metadata, false);
+}
+
+TEST(fs_map_whitelist_subpath)
+{
+	check_map_whitelist(_metadata, true);
+}
+
+const char r2[] = ".";
+const char r3[] = "./doc";
+
+enum relative_access {
+	REL_OPEN,
+	REL_CHDIR,
+	REL_CHROOT,
+};
+
+static void check_tag(struct __test_metadata *_metadata,
+		bool enforce, bool with_tag, enum relative_access rel)
+{
+	int dirfd;
+	int map = -1;
+	int access_beneath, access_absolute;
+
+	if (rel == REL_CHROOT) {
+		/* do not tag with the chdir, only with the chroot */
+		ASSERT_NE(-1, chdir(d2));
+	}
+	if (enforce) {
+		map = create_inode_map(_metadata, (const char *const [])
+				{ d1, NULL });
+		ASSERT_NE(-1, map);
+		enforce_map(_metadata, map, true, with_tag);
+	}
+	switch (rel) {
+	case REL_OPEN:
+		dirfd = open(d2, O_DIRECTORY);
+		ASSERT_NE(-1, dirfd);
+		break;
+	case REL_CHDIR:
+		ASSERT_NE(-1, chdir(d2));
+		dirfd = AT_FDCWD;
+		break;
+	case REL_CHROOT:
+		ASSERT_NE(-1, chroot(d2)) {
+			TH_LOG("Failed to chroot: %s\n", strerror(errno));
+		}
+		dirfd = AT_FDCWD;
+		break;
+	default:
+		ASSERT_TRUE(false);
+		return;
+	}
+
+	access_beneath = (!enforce || with_tag) ? 0 : -1;
+	test_path_rel(_metadata, dirfd, r2, access_beneath);
+	test_path_rel(_metadata, dirfd, r3, access_beneath);
+
+	access_absolute = (enforce || rel == REL_CHROOT) ? -1 : 0;
+	test_path(_metadata, d4, access_absolute);
+	test_path_rel(_metadata, dirfd, d4, access_absolute);
+
+	if (rel == REL_OPEN)
+		EXPECT_EQ(0, close(dirfd));
+	if (enforce)
+		EXPECT_EQ(0, close(map));
+}
+
+TEST(fs_notag_allow_open)
+{
+	/* no enforcement, via open */
+	check_tag(_metadata, false, false, REL_OPEN);
+}
+
+TEST(fs_notag_allow_chdir)
+{
+	/* no enforcement, via chdir */
+	check_tag(_metadata, false, false, REL_CHDIR);
+}
+
+TEST(fs_notag_allow_chroot)
+{
+	/* no enforcement, via chroot */
+	check_tag(_metadata, false, false, REL_CHROOT);
+}
+
+TEST(fs_notag_deny_open)
+{
+	/* enforcement without tag, via open */
+	check_tag(_metadata, true, false, REL_OPEN);
+}
+
+TEST(fs_notag_deny_chdir)
+{
+	/* enforcement without tag, via chdir */
+	check_tag(_metadata, true, false, REL_CHDIR);
+}
+
+TEST(fs_notag_deny_chroot)
+{
+	/* enforcement without tag, via chroot */
+	check_tag(_metadata, true, false, REL_CHROOT);
+}
+
+TEST(fs_tag_allow_open)
+{
+	/* enforcement with tag, via open */
+	check_tag(_metadata, true, true, REL_OPEN);
+}
+
+TEST(fs_tag_allow_chdir)
+{
+	/* enforcement with tag, via chdir */
+	check_tag(_metadata, true, true, REL_CHDIR);
+}
+
+TEST(fs_tag_allow_chroot)
+{
+	/* enforcement with tag, via chroot */
+	check_tag(_metadata, true, true, REL_CHROOT);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/landlock/test_ptrace.c b/tools/testing/selftests/landlock/test_ptrace.c
new file mode 100644
index 000000000000..1423a60b6e0a
--- /dev/null
+++ b/tools/testing/selftests/landlock/test_ptrace.c
@@ -0,0 +1,158 @@
+/*
+ * Landlock tests - ptrace
+ *
+ * Copyright © 2017 Mickaël Salaün <mic@digikod.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#define _GNU_SOURCE
+#include <signal.h> /* raise */
+#include <sys/ptrace.h>
+#include <sys/types.h> /* waitpid */
+#include <sys/wait.h> /* waitpid */
+#include <unistd.h> /* fork, pipe */
+
+#include "test.h"
+
+static void apply_null_sandbox(struct __test_metadata *_metadata)
+{
+	const struct bpf_insn prog_accept[] = {
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+	const union bpf_prog_subtype subtype = {
+		.landlock_hook = {
+			.type = LANDLOCK_HOOK_FS_PICK,
+			.triggers = LANDLOCK_TRIGGER_FS_PICK_OPEN,
+		}
+	};
+	int prog;
+	char log[256] = "";
+
+	prog = bpf_load_program(BPF_PROG_TYPE_LANDLOCK_HOOK,
+			(const struct bpf_insn *)&prog_accept,
+			sizeof(prog_accept) / sizeof(struct bpf_insn), "GPL",
+			0, log, sizeof(log), &subtype);
+	ASSERT_NE(-1, prog) {
+		TH_LOG("Failed to load minimal rule: %s\n%s",
+				strerror(errno), log);
+	}
+	ASSERT_EQ(0, seccomp(SECCOMP_PREPEND_LANDLOCK_PROG, 0, &prog)) {
+		TH_LOG("Failed to apply minimal rule: %s", strerror(errno));
+	}
+	EXPECT_EQ(0, close(prog));
+}
+
+/* PTRACE_TRACEME and PTRACE_ATTACH without Landlock rules effect */
+static void check_ptrace(struct __test_metadata *_metadata,
+		int sandbox_both, int sandbox_parent, int sandbox_child,
+		int expect_ptrace)
+{
+	pid_t child;
+	int status;
+	int pipefd[2];
+
+	ASSERT_EQ(0, pipe(pipefd));
+	if (sandbox_both)
+		apply_null_sandbox(_metadata);
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		char buf;
+
+		EXPECT_EQ(0, close(pipefd[1]));
+		if (sandbox_child)
+			apply_null_sandbox(_metadata);
+
+		/* test traceme */
+		ASSERT_EQ(expect_ptrace, ptrace(PTRACE_TRACEME));
+		if (expect_ptrace) {
+			ASSERT_EQ(EPERM, errno);
+		} else {
+			ASSERT_EQ(0, raise(SIGSTOP));
+		}
+
+		/* sync */
+		ASSERT_EQ(1, read(pipefd[0], &buf, 1)) {
+			TH_LOG("Failed to read() sync from parent");
+		}
+		ASSERT_EQ('.', buf);
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+	}
+
+	EXPECT_EQ(0, close(pipefd[0]));
+	if (sandbox_parent)
+		apply_null_sandbox(_metadata);
+
+	/* test traceme */
+	if (!expect_ptrace) {
+		ASSERT_EQ(child, waitpid(child, &status, 0));
+		ASSERT_EQ(1, WIFSTOPPED(status));
+		ASSERT_EQ(0, ptrace(PTRACE_DETACH, child, NULL, 0));
+	}
+	/* test attach */
+	ASSERT_EQ(expect_ptrace, ptrace(PTRACE_ATTACH, child, NULL, 0));
+	if (expect_ptrace) {
+		ASSERT_EQ(EPERM, errno);
+	} else {
+		ASSERT_EQ(child, waitpid(child, &status, 0));
+		ASSERT_EQ(1, WIFSTOPPED(status));
+		ASSERT_EQ(0, ptrace(PTRACE_CONT, child, NULL, 0));
+	}
+
+	/* sync */
+	ASSERT_EQ(1, write(pipefd[1], ".", 1)) {
+		TH_LOG("Failed to write() sync to child");
+	}
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	if (WIFSIGNALED(status) || WEXITSTATUS(status))
+		_metadata->passed = 0;
+}
+
+TEST(ptrace_allow_without_sandbox)
+{
+	/* no sandbox */
+	check_ptrace(_metadata, 0, 0, 0, 0);
+}
+
+TEST(ptrace_allow_with_one_sandbox)
+{
+	/* child sandbox */
+	check_ptrace(_metadata, 0, 0, 1, 0);
+}
+
+TEST(ptrace_allow_with_nested_sandbox)
+{
+	/* inherited and child sandbox */
+	check_ptrace(_metadata, 1, 0, 1, 0);
+}
+
+TEST(ptrace_deny_with_parent_sandbox)
+{
+	/* parent sandbox */
+	check_ptrace(_metadata, 0, 1, 0, -1);
+}
+
+TEST(ptrace_deny_with_nested_and_parent_sandbox)
+{
+	/* inherited and parent sandbox */
+	check_ptrace(_metadata, 1, 1, 0, -1);
+}
+
+TEST(ptrace_deny_with_forked_sandbox)
+{
+	/* inherited, parent and child sandbox */
+	check_ptrace(_metadata, 1, 1, 1, -1);
+}
+
+TEST(ptrace_deny_with_sibling_sandbox)
+{
+	/* parent and child sandbox */
+	check_ptrace(_metadata, 0, 1, 1, -1);
+}
+
+TEST_HARNESS_MAIN
-- 
2.16.2
