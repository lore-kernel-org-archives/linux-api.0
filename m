From: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
Subject: [RFC PATCH 1/1] seccomp: provide information about the previous syscall
Date: Fri, 22 Jan 2016 15:30:00 +0900
Message-ID: <1453444200-8604-2-git-send-email-daniel.sangorrin@toshiba.co.jp>
References: <1453444200-8604-1-git-send-email-daniel.sangorrin@toshiba.co.jp>
Reply-To: kernel-hardening@lists.openwall.com
Content-Transfer-Encoding: 7bit
Return-path: <kernel-hardening-return-2420-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1453444200-8604-1-git-send-email-daniel.sangorrin@toshiba.co.jp>
To: keescook@chromium.org
Cc: luto@amacapital.net, wad@chromium.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

This patch allows applications to restrict the order in which
its system calls may be requested. In order to do that, we
provide seccomp-BPF scripts with information about the
previous system call requested.

An example use case consists of detecting (and stopping) return
oriented attacks that disturb the normal execution flow of
a user program.

Signed-off-by: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
---
 include/linux/seccomp.h      |   2 +
 include/uapi/linux/seccomp.h |   2 +
 kernel/seccomp.c             |  10 +++
 samples/seccomp/.gitignore   |   1 +
 samples/seccomp/Makefile     |   9 ++-
 samples/seccomp/bpf-prev.c   | 160 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 183 insertions(+), 1 deletion(-)
 create mode 100644 samples/seccomp/bpf-prev.c

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 2296e6b..8c6de6d 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -16,6 +16,7 @@ struct seccomp_filter;
  *
  * @mode:  indicates one of the valid values above for controlled
  *         system calls available to a process.
+ * @prev_nr: stores the previous system call number.
  * @filter: must always point to a valid seccomp-filter or NULL as it is
  *          accessed without locking during system call entry.
  *
@@ -24,6 +25,7 @@ struct seccomp_filter;
  */
 struct seccomp {
 	int mode;
+	int prev_nr;
 	struct seccomp_filter *filter;
 };
 
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 0f238a4..42775dc 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -38,6 +38,7 @@
 /**
  * struct seccomp_data - the format the BPF program executes over.
  * @nr: the system call number
+ * @prev_nr: the previous system call number
  * @arch: indicates system call convention as an AUDIT_ARCH_* value
  *        as defined in <linux/audit.h>.
  * @instruction_pointer: at the time of the system call.
@@ -46,6 +47,7 @@
  */
 struct seccomp_data {
 	int nr;
+	int prev_nr;
 	__u32 arch;
 	__u64 instruction_pointer;
 	__u64 args[6];
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 580ac2d..98b2c9d3 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -190,6 +190,8 @@ static u32 seccomp_run_filters(struct seccomp_data *sd)
 		sd = &sd_local;
 	}
 
+	sd->prev_nr = current->seccomp.prev_nr;
+
 	/*
 	 * All filters in the list are evaluated and the lowest BPF return
 	 * value always takes priority (ignoring the DATA).
@@ -200,6 +202,9 @@ static u32 seccomp_run_filters(struct seccomp_data *sd)
 		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
 			ret = cur_ret;
 	}
+
+	current->seccomp.prev_nr = sd->nr;
+
 	return ret;
 }
 #endif /* CONFIG_SECCOMP_FILTER */
@@ -443,6 +448,11 @@ static long seccomp_attach_filter(unsigned int flags,
 			return ret;
 	}
 
+	/* Initialize the prev_nr field only once */
+	if (current->seccomp.filter == NULL)
+		current->seccomp.prev_nr =
+			syscall_get_nr(current, task_pt_regs(current));
+
 	/*
 	 * If there is an existing filter, make it the prev and don't drop its
 	 * task reference.
diff --git a/samples/seccomp/.gitignore b/samples/seccomp/.gitignore
index 78fb781..11dda7a 100644
--- a/samples/seccomp/.gitignore
+++ b/samples/seccomp/.gitignore
@@ -1,3 +1,4 @@
 bpf-direct
 bpf-fancy
 dropper
+bpf-prev
diff --git a/samples/seccomp/Makefile b/samples/seccomp/Makefile
index 1b4e4b8..b50821c 100644
--- a/samples/seccomp/Makefile
+++ b/samples/seccomp/Makefile
@@ -1,7 +1,7 @@
 # kbuild trick to avoid linker error. Can be omitted if a module is built.
 obj- := dummy.o
 
-hostprogs-$(CONFIG_SECCOMP_FILTER) := bpf-fancy dropper bpf-direct
+hostprogs-$(CONFIG_SECCOMP_FILTER) := bpf-fancy dropper bpf-direct bpf-prev
 
 HOSTCFLAGS_bpf-fancy.o += -I$(objtree)/usr/include
 HOSTCFLAGS_bpf-fancy.o += -idirafter $(objtree)/include
@@ -17,6 +17,11 @@ HOSTCFLAGS_bpf-direct.o += -I$(objtree)/usr/include
 HOSTCFLAGS_bpf-direct.o += -idirafter $(objtree)/include
 bpf-direct-objs := bpf-direct.o
 
+HOSTCFLAGS_bpf-prev.o += -I$(objtree)/usr/include
+HOSTCFLAGS_bpf-prev.o += -idirafter $(objtree)/include
+bpf-prev-objs := bpf-prev.o
+
+
 # Try to match the kernel target.
 ifndef CROSS_COMPILE
 ifndef CONFIG_64BIT
@@ -29,10 +34,12 @@ MFLAG = -m31
 endif
 
 HOSTCFLAGS_bpf-direct.o += $(MFLAG)
+HOSTCFLAGS_bpf-prev.o += $(MFLAG)
 HOSTCFLAGS_dropper.o += $(MFLAG)
 HOSTCFLAGS_bpf-helper.o += $(MFLAG)
 HOSTCFLAGS_bpf-fancy.o += $(MFLAG)
 HOSTLOADLIBES_bpf-direct += $(MFLAG)
+HOSTLOADLIBES_bpf-prev += $(MFLAG)
 HOSTLOADLIBES_bpf-fancy += $(MFLAG)
 HOSTLOADLIBES_dropper += $(MFLAG)
 endif
diff --git a/samples/seccomp/bpf-prev.c b/samples/seccomp/bpf-prev.c
new file mode 100644
index 0000000..138c584
--- /dev/null
+++ b/samples/seccomp/bpf-prev.c
@@ -0,0 +1,160 @@
+/*
+ * Seccomp BPF example that uses information about the previous syscall.
+ *
+ * Copyright (C) 2015 TOSHIBA corp.
+ * Author: Daniel Sangorrin <daniel.sangorrin@gmail.com>
+ *
+ * The code may be used by anyone for any purpose,
+ * and can serve as a starting point for developing
+ * applications using prctl or seccomp.
+ */
+#if defined(__x86_64__)
+#define SUPPORTED_ARCH 1
+#endif
+
+#if defined(SUPPORTED_ARCH)
+#define __USE_GNU 1
+#define _GNU_SOURCE 1
+
+#include <linux/filter.h>
+/* NOTE: make sure seccomp_data in /usr/include/linux/seccomp.h has prev_nr */
+#include <linux/seccomp.h>
+#include <linux/unistd.h>
+#include <stdio.h>
+#include <stddef.h>
+#include <sys/prctl.h>
+#include <unistd.h>
+#include <sys/msg.h>
+#include <assert.h>
+
+#define MSGPERM		0600
+#define MTEXTSIZE	128
+#define MTYPE		1
+
+struct msg_buf {
+	long mtype;
+	char mtext[MTEXTSIZE];
+};
+
+#define syscall_nr (offsetof(struct seccomp_data, nr))
+#define prev_nr (offsetof(struct seccomp_data, prev_nr))
+
+#define EXAMINE_SYSCALL \
+	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, syscall_nr)
+
+#define EXAMINE_PREV_SYSCALL \
+	BPF_STMT(BPF_LD+BPF_W+BPF_ABS, prev_nr)
+
+#define KILL_PROCESS \
+	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_KILL)
+
+#ifndef PR_SET_NO_NEW_PRIVS
+#define PR_SET_NO_NEW_PRIVS 38
+#endif
+
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+
+static int install_syscall_filter(void)
+{
+	/* allow __NR_msgrcv only if prev_nr is __NR_prctl or __NR_msgsnd */
+	struct sock_filter filter[] = {
+		EXAMINE_SYSCALL,
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, __NR_msgrcv, 1, 0),
+		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
+		EXAMINE_PREV_SYSCALL,
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, __NR_prctl, 0, 1),
+		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, __NR_msgsnd, 0, 1),
+		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, __NR_clone, 0, 1),
+		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
+		KILL_PROCESS,
+	};
+	struct sock_fprog prog = {
+		.len = ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+
+	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
+		perror("prctl(NO_NEW_PRIVS)");
+		return 1;
+	}
+
+	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog)) {
+		perror("prctl(SECCOMP)");
+		return 1;
+	}
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	long ret;
+	int id;
+	struct msg_buf send, recv;
+
+	id = syscall(__NR_msgget, IPC_PRIVATE, MSGPERM | IPC_CREAT | IPC_EXCL);
+	assert(id >= 0);
+
+	send.mtype = MTYPE;
+	snprintf(send.mtext, MTEXTSIZE, "hello");
+	printf("parent msgsnd: %s\n", send.mtext);
+	ret = syscall(__NR_msgsnd, id, &send, MTEXTSIZE, 0);
+	assert(ret == 0);
+
+	install_syscall_filter();
+
+	/* TEST 1: msgrcv can be executed after prctl */
+	ret = syscall(__NR_msgrcv, id, &recv, MTEXTSIZE, MTYPE, 0);
+	assert(ret == MTEXTSIZE);
+	printf("parent msgrcv after prctl: %s (%d bytes)\n", recv.mtext, ret);
+
+	snprintf(send.mtext, MTEXTSIZE, "world");
+	printf("parent msgsnd: %s\n", send.mtext);
+	ret = syscall(__NR_msgsnd, id, &send, MTEXTSIZE, 0);
+	assert(ret == 0);
+
+	/* TEST 2: msgrcv can be executed after msgsnd */
+	ret = syscall(__NR_msgrcv, id, &recv, MTEXTSIZE, MTYPE, 0);
+	assert(ret == MTEXTSIZE);
+	printf("parent msgrcv after msgsnd: %s (%d bytes)\n", recv.mtext, ret);
+
+	snprintf(send.mtext, MTEXTSIZE, "this is mars");
+	printf("parent msgsnd: %s\n", send.mtext);
+	ret = syscall(__NR_msgsnd, id, &send, MTEXTSIZE, 0);
+	assert(ret == 0);
+
+	pid_t pid = fork();
+
+	if (pid == 0) {
+		/* TEST 3a: msgrcv can be executed after clone */
+		ret = syscall(__NR_msgrcv, id, &recv, MTEXTSIZE, MTYPE, 0);
+		assert(ret == MTEXTSIZE);
+		printf("child msgrcv after clone: %s (%d bytes)\n",
+		       recv.mtext, ret);
+		_exit(0);
+	} else if (pid > 0) {
+		int status;
+
+		pid = wait(&status);
+		printf("parent: child %d exited with status %d\n", pid, status);
+		/* TEST 3b: msgrcv can NOT be executed after write (dmseg) */
+		syscall(__NR_write, STDOUT_FILENO, "Should fail: ", 14);
+		syscall(__NR_msgrcv, id, &recv, MTEXTSIZE, MTYPE, 0);
+		return 0;
+	}
+
+	assert(0); /* should never arrive here */
+
+	return 0;
+}
+#else	/* SUPPORTED_ARCH */
+/*
+ * This sample has been tested on x86_64. Other architectures will result in
+ * using only the main() below.
+ */
+int main(void)
+{
+	return 1;
+}
+#endif	/* SUPPORTED_ARCH */
-- 
2.1.4
