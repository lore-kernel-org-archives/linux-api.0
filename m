From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: [PATCH 1/4] selftests: Add test for sigaltstack(SS_DISABLE) inside
 sighandler
Date: Sun, 31 Jan 2016 22:12:30 +0300
Message-ID: <56AE5C9E.30608@list.ru>
References: <56AE5C08.6010403@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56AE5C08.6010403-cmBhpYW9OiY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org


sigaltstack needs to be disabled before the signal handler can
safely use swapcontext(). Unfortunately linux implementation of
sigaltstack() returns EPERM in that case.
Re-enabling is also needed and tested.

CC: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>

Signed-off-by: Stas Sergeev <stsp-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
  tools/testing/selftests/Makefile             |   1 +
  tools/testing/selftests/sigaltstack/Makefile |   8 ++
  tools/testing/selftests/sigaltstack/sas.c    | 132 
+++++++++++++++++++++++++++
  3 files changed, 141 insertions(+)
  create mode 100644 tools/testing/selftests/sigaltstack/Makefile
  create mode 100644 tools/testing/selftests/sigaltstack/sas.c

diff --git a/tools/testing/selftests/Makefile 
b/tools/testing/selftests/Makefile
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
diff --git a/tools/testing/selftests/sigaltstack/Makefile 
b/tools/testing/selftests/sigaltstack/Makefile
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
+    rm -rf $(BINARIES)
diff --git a/tools/testing/selftests/sigaltstack/sas.c 
b/tools/testing/selftests/sigaltstack/sas.c
new file mode 100644
index 0000000..5d9aabd
--- /dev/null
+++ b/tools/testing/selftests/sigaltstack/sas.c
@@ -0,0 +1,132 @@
+/*
+ * Stas Sergeev <stsp-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
+ *
+ * test sigcontext(SS_DISABLE) inside signal handler
+ * If that succeeds, then swapcontext() can be used safely.
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
+static void *sstack, *ustack;
+static ucontext_t uc, sc;
+static const char *msg = "[OK]\tStack preserved";
+static const char *msg2 = "[FAIL]\tStack corrupted";
+
+void my_usr1(int sig)
+{
+    char *aa, *p;
+    int *i, err;
+    stack_t stk = { };
+
+    aa = alloca(1024);
+    assert(aa);
+    p = aa + 512;
+    strcpy(p, msg);
+    i = (int *) (p + 128);
+    *i = 1;
+    printf("[RUN]\tsignal USR1\n");
+    stk.ss_flags = SS_DISABLE;
+    err = sigaltstack(&stk, &stk);
+    if (err) {
+        perror("[FAIL]\tsigaltstack(SS_DISABLE)");
+        /* don't exit to demonstrate the breakage */
+        /* exit(EXIT_FAILURE); */
+    }
+    swapcontext(&sc, &uc);
+    printf("%s\n", p);
+    if (!*i) {
+        printf("[RUN]\tAborting\n");
+        exit(EXIT_FAILURE);
+    }
+
+    if (stk.ss_flags != SS_ONSTACK) {
+        printf("[FAIL]\tsigaltstack() returned wrong ss_flags %i\n",
+                stk.ss_flags);
+        stk.ss_flags = SS_ONSTACK;
+    }
+    err = sigaltstack(&stk, NULL);
+    if (err)
+        printf("[OK]\tsigaltstack(SS_ONSTACK) failed for non_zero "
+                "size\n");
+        /* but don't fail otherwise, as this is unspecified */
+    stk.ss_size = 0;
+    err = sigaltstack(&stk, NULL);
+    if (err)
+        perror("[FAIL]\tsigaltstack(SS_ONSTACK)");
+}
+
+void my_usr2(int sig)
+{
+    char *aa, *p;
+    int *i;
+
+    printf("[RUN]\tsignal USR2\n");
+    aa = alloca(1024);
+    /* dont run valgrind on this */
+    p = memmem(aa, 1024, msg, strlen(msg));
+    if (p) {
+        printf("[FAIL]\tsigaltstack re-used\n");
+        strcpy(p, msg2);
+        i = (int *) (p + 128);
+        *i = 0;
+    }
+}
+
+static void switch_fn(void)
+{
+    printf("[RUN]\tswitched to user ctx\n");
+    raise(SIGUSR2);
+    setcontext(&sc);
+}
+
+int main(void)
+{
+    struct sigaction act;
+    stack_t stk;
+    int err;
+
+    sigemptyset(&act.sa_mask);
+    act.sa_flags = SA_ONSTACK;
+    act.sa_handler = my_usr1;
+    sigaction(SIGUSR1, &act, NULL);
+    act.sa_handler = my_usr2;
+    sigaction(SIGUSR2, &act, NULL);
+    sstack = mmap(NULL, SIGSTKSZ, PROT_READ | PROT_WRITE,
+              MAP_PRIVATE | MAP_ANONYMOUS | MAP_STACK, -1, 0);
+    if (sstack == MAP_FAILED) {
+        perror("mmap()");
+        return EXIT_FAILURE;
+    }
+    stk.ss_sp = sstack;
+    stk.ss_size = SIGSTKSZ;
+    stk.ss_flags = SS_ONSTACK;
+    err = sigaltstack(&stk, NULL);
+    if (err) {
+        perror("sigaltstack()");
+        return EXIT_FAILURE;
+    }
+
+    ustack = mmap(NULL, SIGSTKSZ, PROT_READ | PROT_WRITE,
+              MAP_PRIVATE | MAP_ANONYMOUS | MAP_STACK, -1, 0);
+    if (ustack == MAP_FAILED) {
+        perror("mmap()");
+        return EXIT_FAILURE;
+    }
+    getcontext(&uc);
+    uc.uc_link = NULL;
+    uc.uc_stack.ss_sp = ustack;
+    uc.uc_stack.ss_size = SIGSTKSZ;
+    makecontext(&uc, switch_fn, 0);
+    raise(SIGUSR1);
+    printf("[OK]\tTest passed\n");
+    return 0;
+}
-- 
2.5.0
