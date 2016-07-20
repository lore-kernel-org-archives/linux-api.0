From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/3] selftests: check O_ATROOT and AT_FDROOT flags
Date: Wed, 20 Jul 2016 13:42:57 -0700
Message-ID: <1469047377-13128-4-git-send-email-avagin@openvz.org>
References: <1469047377-13128-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1469047377-13128-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

These flags mean that the first argument "dirfd" of *at syscall-s set as
root for the current operation.

With these flags absolute symlinks have to be resolved relative to
dirfd.

This test create a file and an absolute symlink on it, which can be
resoled only if a proper root is set.

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 tools/testing/selftests/Makefile                |  1 +
 tools/testing/selftests/lookup/.gitignore       |  1 +
 tools/testing/selftests/lookup/Makefile         |  8 +++
 tools/testing/selftests/lookup/lookup_at_root.c | 71 +++++++++++++++++++++++++
 tools/testing/selftests/lookup/run.sh           | 14 +++++
 5 files changed, 95 insertions(+)
 create mode 100644 tools/testing/selftests/lookup/.gitignore
 create mode 100644 tools/testing/selftests/lookup/Makefile
 create mode 100644 tools/testing/selftests/lookup/lookup_at_root.c
 create mode 100755 tools/testing/selftests/lookup/run.sh

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index ff9e5f2..72555c8 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -9,6 +9,7 @@ TARGETS += futex
 TARGETS += ipc
 TARGETS += kcmp
 TARGETS += lib
+TARGETS += lookup
 TARGETS += membarrier
 TARGETS += memfd
 TARGETS += memory-hotplug
diff --git a/tools/testing/selftests/lookup/.gitignore b/tools/testing/selftests/lookup/.gitignore
new file mode 100644
index 0000000..c9a963f
--- /dev/null
+++ b/tools/testing/selftests/lookup/.gitignore
@@ -0,0 +1 @@
+lookup_at_root
diff --git a/tools/testing/selftests/lookup/Makefile b/tools/testing/selftests/lookup/Makefile
new file mode 100644
index 0000000..042b26f
--- /dev/null
+++ b/tools/testing/selftests/lookup/Makefile
@@ -0,0 +1,8 @@
+TEST_PROGS := run.sh
+
+all: lookup_at_root
+
+clean:
+	$(RM) lookup_at_root
+include ../lib.mk
+
diff --git a/tools/testing/selftests/lookup/lookup_at_root.c b/tools/testing/selftests/lookup/lookup_at_root.c
new file mode 100644
index 0000000..6723dc8
--- /dev/null
+++ b/tools/testing/selftests/lookup/lookup_at_root.c
@@ -0,0 +1,71 @@
+#include <unistd.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <signal.h>
+#include <sys/prctl.h>
+#include <linux/limits.h>
+
+#define pr_err(fmt, ...) \
+		({ \
+			fprintf(stderr, "%s:%d:" fmt ": %m\n", \
+				__func__, __LINE__, ##__VA_ARGS__); \
+			1; \
+		})
+
+#ifndef O_ATROOT
+#define O_ATROOT       040000000        /* dfd is a root */
+#endif
+#ifndef AT_FDROOT
+#define AT_FDROOT      0x2000		/* Resolve a path as if dirfd is root */
+#endif
+
+int main(int argc, char **argv)
+{
+	struct stat st;
+	int fd, dfd;
+	char path[PATH_MAX];
+
+	dfd = open(argv[1], O_RDONLY);
+	if (dfd < 0)
+		return pr_err("open");
+
+	snprintf(path, sizeof(path), "%s/test", argv[1]);
+	if (mkdir(path, 755))
+		return pr_err("mkdir");
+
+	if (symlinkat("/test", dfd, "./test.link"))
+		return pr_err("symlinkat");
+
+	fd = openat(dfd, "test.link", O_RDONLY | O_ATROOT);
+	if (fd < 0)
+		return pr_err("open");
+
+	if (fchdir(dfd))
+		return pr_err("fchdir");
+
+	fd = openat(AT_FDCWD, "test.link", O_RDONLY | O_ATROOT);
+	if (fd < 0)
+		return pr_err("open");
+	close(fd);
+
+	fd = openat(AT_FDCWD, "/test.link", O_RDONLY | O_ATROOT);
+	if (fd < 0)
+		return pr_err("open");
+	close(fd);
+
+	if (fstatat(AT_FDCWD, "test.link", &st, AT_FDROOT))
+		return pr_err("fstatat");
+	if (fstatat(dfd, "test.link", &st, AT_FDROOT))
+		return pr_err("fstatat");
+	if (mknodat(dfd, "./test/test.file", 0644 | S_IFREG, 0))
+		return pr_err("mknod");
+	if (linkat(dfd, "./test.link/test.file",
+			dfd, "./test.link/test.file.link", AT_FDROOT))
+		return pr_err("linkat");
+	if (unlinkat(dfd, "./test.link/test.file.link", AT_FDROOT))
+		return pr_err("unlinkat");
+
+	return 0;
+}
diff --git a/tools/testing/selftests/lookup/run.sh b/tools/testing/selftests/lookup/run.sh
new file mode 100755
index 0000000..86cc51b
--- /dev/null
+++ b/tools/testing/selftests/lookup/run.sh
@@ -0,0 +1,14 @@
+#!/bin/sh
+
+set -e
+
+test_dir=`mktemp -d /tmp/lookup_test.XXXXXX`
+mount -t tmpfs lookup_at_root $test_dir
+
+ret=0
+./lookup_at_root $test_dir || ret=$?
+
+umount $test_dir
+rmdir $test_dir
+
+exit $ret
-- 
2.5.5
