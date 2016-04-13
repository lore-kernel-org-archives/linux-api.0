From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH v4 3/3] vfs: selftests: Add test for umask2 system call.
Date: Wed, 13 Apr 2016 20:05:36 +0100
Message-ID: <1460574336-18930-4-git-send-email-rjones@redhat.com>
References: <1460574336-18930-1-git-send-email-rjones@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460574336-18930-1-git-send-email-rjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, luto@kernel.org, viro@zeniv.linux.org.uk, mathieu.desnoyers@efficios.com, zab@redhat.com, emunson@akamai.com, paulmck@linux.vnet.ibm.com, aarcange@redhat.com, josh@joshtriplett.org, xemul@parallels.com, sfr@canb.auug.org.au, milosz@adfin.com, rostedt@goodmis.org, arnd@arndb.de, ebiederm@xmission.com, gorcunov@openvz.org, iulia.manda21@gmail.com, dave.hansen@linux.intel.com, mguzik@redhat.com, adobriyan@gmail.com, dave@stgolabs.net, linux-api@vger.kernel.org, gorcunov@gmail.com, fw@deneb.enyo.de, walters@verbum.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 tools/testing/selftests/Makefile          |  1 +
 tools/testing/selftests/fs/.gitignore     |  1 +
 tools/testing/selftests/fs/Makefile       |  9 ++++
 tools/testing/selftests/fs/umask2-tests.c | 77 +++++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+)
 create mode 100644 tools/testing/selftests/fs/.gitignore
 create mode 100644 tools/testing/selftests/fs/Makefile
 create mode 100644 tools/testing/selftests/fs/umask2-tests.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index b04afc3..9e2eb24 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -4,6 +4,7 @@ TARGETS += cpu-hotplug
 TARGETS += efivarfs
 TARGETS += exec
 TARGETS += firmware
+TARGETS += fs
 TARGETS += ftrace
 TARGETS += futex
 TARGETS += ipc
diff --git a/tools/testing/selftests/fs/.gitignore b/tools/testing/selftests/fs/.gitignore
new file mode 100644
index 0000000..057dced
--- /dev/null
+++ b/tools/testing/selftests/fs/.gitignore
@@ -0,0 +1 @@
+umask2-tests
diff --git a/tools/testing/selftests/fs/Makefile b/tools/testing/selftests/fs/Makefile
new file mode 100644
index 0000000..6f231d7
--- /dev/null
+++ b/tools/testing/selftests/fs/Makefile
@@ -0,0 +1,9 @@
+BINARIES := umask2-tests
+
+all: $(BINARIES)
+
+clean:
+	$(RM) $(BINARIES)
+
+include ../lib.mk
+
diff --git a/tools/testing/selftests/fs/umask2-tests.c b/tools/testing/selftests/fs/umask2-tests.c
new file mode 100644
index 0000000..3e01575
--- /dev/null
+++ b/tools/testing/selftests/fs/umask2-tests.c
@@ -0,0 +1,77 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <syscall.h>
+#include <linux/unistd.h>
+
+#ifndef UMASK_GET_MASK
+#define UMASK_GET_MASK 1
+#endif
+
+static int umask2_(int mask, int flags)
+{
+#ifdef __NR_umask2
+	return syscall(__NR_umask2, mask, flags);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
+
+int main(int argc, char **argv)
+{
+	int r;
+
+	/* umask2 available in current kernel? */
+	r = umask2_(0, UMASK_GET_MASK);
+	if (r == -1 && errno == ENOSYS) {
+		fprintf(stderr,
+			"umask2 not available in current kernel or headers, skipping test\n");
+		exit(0);
+	}
+
+	/* Check that old umask still works. */
+	r = umask(022);
+	if (r == -1) {
+		perror("umask");
+		exit(1);
+	}
+
+	/* Call umask2 to emulate old umask. */
+	r = umask2_(023, 0);
+	if (r == -1) {
+		perror("umask2");
+		exit(1);
+	}
+	if (r != 022) {
+		fprintf(stderr, "umask2: expected %o, got %o\n", 022, r);
+		exit(1);
+	}
+
+	/* Call umask2 to read current umask without modifying it. */
+	r = umask2_(0777, UMASK_GET_MASK);
+	if (r == -1) {
+		perror("umask2");
+		exit(1);
+	}
+	if (r != 023) {
+		fprintf(stderr, "umask2: expected %o, got %o\n", 023, r);
+		exit(1);
+	}
+
+	/* Call it again to make sure we didn't modify umask. */
+	r = umask2_(0777, UMASK_GET_MASK);
+	if (r == -1) {
+		perror("umask2");
+		exit(1);
+	}
+	if (r != 023) {
+		fprintf(stderr, "umask2: expected %o, got %o\n", 023, r);
+		exit(1);
+	}
+
+	exit(0);
+}
-- 
2.7.4
