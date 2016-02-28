From: Stas Sergeev <stsp@list.ru>
Subject: [PATCH 2/2] selftests: Add test for sigaltstack(SS_AUTODISARM)
Date: Mon, 29 Feb 2016 00:13:20 +0300
Message-ID: <1456694000-16395-3-git-send-email-stsp@list.ru>
References: <1456694000-16395-1-git-send-email-stsp@list.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456694000-16395-1-git-send-email-stsp@list.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: stsp@list.ru
Cc: Stas Sergeev <stsp@users.sourceforge.net>, Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

From: Stas Sergeev <stsp@users.sourceforge.net>

sigaltstack needs to be disabled before the signal handler can
safely use swapcontext().
This patch adds the SS_AUTODISARM flag.
This flag disables the sigaltstack when entering the signal handler.
When returning from signal handler, the sigaltstack is restored by
uc_stack.

CC: Shuah Khan <shuahkh@osg.samsung.com>
CC: linux-kernel@vger.kernel.org
CC: linux-api@vger.kernel.org
CC: Andy Lutomirski <luto@amacapital.net>

Signed-off-by: Stas Sergeev <stsp@users.sourceforge.net>
---
 tools/testing/selftests/Makefile             |   1 +
 tools/testing/selftests/sigaltstack/Makefile |   8 ++
 tools/testing/selftests/sigaltstack/sas.c    | 151 +++++++++++++++++++++++++++
 3 files changed, 160 insertions(+)
 create mode 100644 tools/testing/selftests/sigaltstack/Makefile
 create mode 100644 tools/testing/selftests/sigaltstack/sas.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index b04afc3..ff9e5f2 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -19,6 +19,7 @@ TARGETS += powerpc
 TARGETS += pstore
 TARGETS += ptrace
 TARGETS += seccomp
+TARGETS += sigaltstack
 TARGETS += size
 TARGETS += static_keys
 TARGETS += sysctl
diff --git a/tools/testing/selftests/sigaltstack/Makefile b/tools/testing/selftests/sigaltstack/Makefile
new file mode 100644
index 0000000..56af56e
--- /dev/null
+++ b/tools/testing/selftests/sigaltstack/Makefile
@@ -0,0 +1,8 @@
+CFLAGS = -Wall
+BINARIES = sas
+all: $(BINARIES)
+
+include ../lib.mk
+
+clean:
+	rm -rf $(BINARIES)
diff --git a/tools/testing/selftests/sigaltstack/sas.c b/tools/testing/selftests/sigaltstack/sas.c
new file mode 100644
index 0000000..bba149a
--- /dev/null
+++ b/tools/testing/selftests/sigaltstack/sas.c
@@ -0,0 +1,151 @@
+/*
+ * Stas Sergeev <stsp@users.sourceforge.net>
+ *
+ * test sigaltstack(SS_AUTODISARM)
+ * If that succeeds, then swapcontext() can be used inside sighandler safely.
+ *
+ */
+
+#define _GNU_SOURCE
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <ucontext.h>
+#include <alloca.h>
+#include <string.h>
+#include <assert.h>
+
+#ifndef SS_AUTODISARM
+#define SS_AUTODISARM  (1 << 4)
+#endif
+
+static void *sstack, *ustack;
+static ucontext_t uc, sc;
+static const char *msg = "[OK]\tStack preserved";
+static const char *msg2 = "[FAIL]\tStack corrupted";
+struct stk_data {
+	char msg[128];
+	int flag;
+};
+
+void my_usr1(int sig, siginfo_t *si, void *u)
+{
+	char *aa;
+	int err;
+	stack_t stk;
+	struct stk_data *p;
+
+	register unsigned long sp asm("sp");
+
+	if (sp < (unsigned long)sstack ||
+			sp >= (unsigned long)sstack + SIGSTKSZ) {
+		printf("[FAIL]\tSP is not on sigaltstack\n");
+		exit(EXIT_FAILURE);
+	}
+	/* put some data on stack. other sighandler will try to overwrite it */
+	aa = alloca(1024);
+	assert(aa);
+	p = (struct stk_data *)(aa + 512);
+	strcpy(p->msg, msg);
+	p->flag = 1;
+	printf("[RUN]\tsignal USR1\n");
+	err = sigaltstack(NULL, &stk);
+	if (err) {
+		perror("[FAIL]\tsigaltstack()");
+		exit(EXIT_FAILURE);
+	}
+	if (stk.ss_flags != SS_DISABLE)
+		printf("[FAIL]\tss_flags=%i, should be SS_DISABLE\n",
+				stk.ss_flags);
+	else
+		printf("[OK]\tsigaltstack is disabled in sighandler\n");
+	swapcontext(&sc, &uc);
+	printf("%s\n", p->msg);
+	if (!p->flag) {
+		printf("[RUN]\tAborting\n");
+		exit(EXIT_FAILURE);
+	}
+}
+
+void my_usr2(int sig, siginfo_t *si, void *u)
+{
+	char *aa;
+	struct stk_data *p;
+
+	printf("[RUN]\tsignal USR2\n");
+	aa = alloca(1024);
+	/* dont run valgrind on this */
+	/* try to find the data stored by previous sighandler */
+	p = memmem(aa, 1024, msg, strlen(msg));
+	if (p) {
+		printf("[FAIL]\tsigaltstack re-used\n");
+		/* corrupt the data */
+		strcpy(p->msg, msg2);
+		/* tell other sighandler that his data is corrupted */
+		p->flag = 0;
+	}
+}
+
+static void switch_fn(void)
+{
+	printf("[RUN]\tswitched to user ctx\n");
+	raise(SIGUSR2);
+	setcontext(&sc);
+}
+
+int main(void)
+{
+	struct sigaction act;
+	stack_t stk;
+	int err;
+
+	sigemptyset(&act.sa_mask);
+	act.sa_flags = SA_ONSTACK | SA_SIGINFO;
+	act.sa_sigaction = my_usr1;
+	sigaction(SIGUSR1, &act, NULL);
+	act.sa_sigaction = my_usr2;
+	sigaction(SIGUSR2, &act, NULL);
+	sstack = mmap(NULL, SIGSTKSZ, PROT_READ | PROT_WRITE,
+		      MAP_PRIVATE | MAP_ANONYMOUS | MAP_STACK, -1, 0);
+	if (sstack == MAP_FAILED) {
+		perror("mmap()");
+		return EXIT_FAILURE;
+	}
+	stk.ss_sp = sstack;
+	stk.ss_size = SIGSTKSZ;
+	stk.ss_flags = SS_ONSTACK | SS_AUTODISARM;
+	err = sigaltstack(&stk, NULL);
+	if (err) {
+		perror("sigaltstack()");
+		return EXIT_FAILURE;
+	}
+
+	ustack = mmap(NULL, SIGSTKSZ, PROT_READ | PROT_WRITE,
+		      MAP_PRIVATE | MAP_ANONYMOUS | MAP_STACK, -1, 0);
+	if (ustack == MAP_FAILED) {
+		perror("mmap()");
+		return EXIT_FAILURE;
+	}
+	getcontext(&uc);
+	uc.uc_link = NULL;
+	uc.uc_stack.ss_sp = ustack;
+	uc.uc_stack.ss_size = SIGSTKSZ;
+	makecontext(&uc, switch_fn, 0);
+	raise(SIGUSR1);
+
+	err = sigaltstack(NULL, &stk);
+	if (err) {
+		perror("[FAIL]\tsigaltstack()");
+		exit(EXIT_FAILURE);
+	}
+	if (stk.ss_flags != 0) {
+		printf("[FAIL]\tss_flags=%i, should be 0\n",
+				stk.ss_flags);
+		exit(EXIT_FAILURE);
+	}
+	printf("[OK]\tsigaltstack is enabled after signal\n");
+
+	printf("[OK]\tTest passed\n");
+	return 0;
+}
-- 
2.7.2
