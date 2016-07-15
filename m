From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 5/5] tools/testing: add a test to check nsfs ioctl-s
Date: Thu, 14 Jul 2016 19:12:22 -0700
Message-ID: <1468548742-32136-5-git-send-email-avagin@openvz.org>
References: <CANaxB-xw_xBUq=0uT14ANv-jfg2NsGaPy=jyDO9=yF03_7toSw@mail.gmail.com>
 <1468548742-32136-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468548742-32136-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, containers@lists.linux-foundation.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "W. Trevor King" <wking@tremily.us>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Andrey Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

There are two new ioctl-s:
One ioctl for the user namespace that owns a file descriptor.
One ioctl for the parent namespace of a namespace file descriptor.

The test checks that these ioctl-s works and that they handle a case
when a target namespace is outside of the current process namespace.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 tools/testing/selftests/Makefile      |  1 +
 tools/testing/selftests/nsfs/Makefile | 12 +++++
 tools/testing/selftests/nsfs/owner.c  | 91 +++++++++++++++++++++++++++++++++++
 tools/testing/selftests/nsfs/pidns.c  | 74 ++++++++++++++++++++++++++++
 4 files changed, 178 insertions(+)
 create mode 100644 tools/testing/selftests/nsfs/Makefile
 create mode 100644 tools/testing/selftests/nsfs/owner.c
 create mode 100644 tools/testing/selftests/nsfs/pidns.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index ff9e5f2..f770dba 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -15,6 +15,7 @@ TARGETS += memory-hotplug
 TARGETS += mount
 TARGETS += mqueue
 TARGETS += net
+TARGETS += nsfs
 TARGETS += powerpc
 TARGETS += pstore
 TARGETS += ptrace
diff --git a/tools/testing/selftests/nsfs/Makefile b/tools/testing/selftests/nsfs/Makefile
new file mode 100644
index 0000000..2306054
--- /dev/null
+++ b/tools/testing/selftests/nsfs/Makefile
@@ -0,0 +1,12 @@
+TEST_PROGS := owner pidns
+
+CFLAGS := -Wall -Werror
+
+all: owner pidns
+owner: owner.c
+pidns: pidns.c
+
+clean:
+	$(RM) owner pidns
+
+include ../lib.mk
diff --git a/tools/testing/selftests/nsfs/owner.c b/tools/testing/selftests/nsfs/owner.c
new file mode 100644
index 0000000..c97aa50
--- /dev/null
+++ b/tools/testing/selftests/nsfs/owner.c
@@ -0,0 +1,91 @@
+#define _GNU_SOURCE
+#include <sched.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+
+#define NSIO    0xb7
+#define NS_GET_USERNS   _IO(NSIO, 0x1)
+
+#define pr_err(fmt, ...) \
+		({ \
+			fprintf(stderr, "%s:%d:" fmt ": %m\n", \
+				__func__, __LINE__, ##__VA_ARGS__); \
+			1; \
+		})
+
+int main(int argc, char *argvp[])
+{
+	int pfd[2], ns, uns, init_uns;
+	struct stat st1, st2;
+	char path[128];
+	pid_t pid;
+	char c;
+
+	if (pipe(pfd))
+		return 1;
+
+	pid = fork();
+	if (pid < 0)
+		return pr_err("fork");
+	if (pid == 0) {
+		prctl(PR_SET_PDEATHSIG, SIGKILL);
+		if (unshare(CLONE_NEWUTS | CLONE_NEWUSER))
+			return pr_err("unshare");
+		close(pfd[0]);
+		close(pfd[1]);
+		while (1)
+			sleep(1);
+		return 0;
+	}
+	close(pfd[1]);
+	if (read(pfd[0], &c, 1) != 0)
+		return pr_err("Unable to read from pipe");
+	close(pfd[0]);
+
+	snprintf(path, sizeof(path), "/proc/%d/ns/uts", pid);
+	ns = open(path, O_RDONLY);
+	if (ns < 0)
+		return pr_err("Unable to open %s", path);
+
+	uns = ioctl(ns, NS_GET_USERNS);
+	if (uns < 0)
+		return pr_err("Unable to get an owning user namespace");
+
+	if (fstat(uns, &st1))
+		return pr_err("fstat");
+
+	snprintf(path, sizeof(path), "/proc/%d/ns/user", pid);
+	if (stat(path, &st2))
+		return pr_err("stat");
+
+	if (st1.st_ino != st2.st_ino)
+		return pr_err("NS_GET_USERNS returned a wrong namespace");
+
+	init_uns = ioctl(uns, NS_GET_USERNS);
+	if (uns < 0)
+		return pr_err("Unable to get an owning user namespace");
+
+	if (ioctl(init_uns, NS_GET_USERNS) >= 0 || errno != ENOENT)
+		return pr_err("Don't get ENOENT");
+
+	if (unshare(CLONE_NEWUSER))
+		return pr_err("unshare");
+
+	if (ioctl(ns, NS_GET_USERNS) >= 0 || errno != EPERM)
+		return pr_err("Don't get EPERM");
+	if (ioctl(init_uns, NS_GET_USERNS) >= 0 || errno != EPERM)
+		return pr_err("Don't get EPERM");
+
+	kill(pid, SIGKILL);
+	wait(NULL);
+	return 0;
+}
diff --git a/tools/testing/selftests/nsfs/pidns.c b/tools/testing/selftests/nsfs/pidns.c
new file mode 100644
index 0000000..99b1131
--- /dev/null
+++ b/tools/testing/selftests/nsfs/pidns.c
@@ -0,0 +1,74 @@
+#define _GNU_SOURCE
+#include <sched.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+
+#define pr_err(fmt, ...) \
+		({ \
+			fprintf(stderr, "%s:%d:" fmt ": %m\n", \
+				__func__, __LINE__, ##__VA_ARGS__); \
+			1; \
+		})
+
+#define NSIO	0xb7
+#define NS_GET_USERNS   _IO(NSIO, 0x1)
+#define NS_GET_PARENT   _IO(NSIO, 0x2)
+
+#define __stack_aligned__	__attribute__((aligned(16)))
+struct cr_clone_arg {
+	char stack[128] __stack_aligned__;
+	char stack_ptr[0];
+};
+
+static int child(void *args)
+{
+	prctl(PR_SET_PDEATHSIG, SIGKILL);
+	while (1)
+		sleep(1);
+	exit(0);
+}
+
+int main(int argc, char *argv[])
+{
+	char path[] = "/proc/0123456789/ns/pid";
+	struct cr_clone_arg ca;
+	struct stat st1, st2;
+	int ns, pns;
+	pid_t pid;
+
+	pid = clone(child, ca.stack_ptr, CLONE_NEWPID | SIGCLD, NULL);
+	if (pid < 0)
+		return pr_err("clone");
+
+	snprintf(path, sizeof(path), "/proc/%d/ns/pid", pid);
+	ns = open(path, O_RDONLY);
+	if (ns < 0)
+		return pr_err("Unable to open %s", path);
+
+	pns = ioctl(ns, NS_GET_PARENT);
+	if (pns < 0)
+		return pr_err("Unable to get a parent pidns");
+
+	if (stat("/proc/self/ns/pid", &st2))
+		return pr_err("Unable to stat %s", path);
+	if (fstat(pns, &st1))
+		return pr_err("Unable to stat the parent pidns");
+	if (st1.st_ino != st2.st_ino)
+		return pr_err("NS_GET_PARENT returned a wrong namespace");
+
+	if (ioctl(pns, NS_GET_PARENT) >= 0 || errno != ENOENT)
+		return pr_err("Don't get ENOENT");;
+
+	kill(pid, SIGKILL);
+	wait(NULL);
+	return 0;
+}
-- 
2.5.5
