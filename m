From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/11] selftests: Add test of O_BENEATH_ONLY & openat(2)
Date: Mon, 30 Jun 2014 11:28:02 +0100
Message-ID: <1404124096-21445-3-git-send-email-drysdale@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404124096-21445-1-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

At simple tests of openat(2) variations, including examples that
check the new O_BENEATH_ONLY flag.

Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/openat/.gitignore |   3 +
 tools/testing/selftests/openat/Makefile   |  24 +++++
 tools/testing/selftests/openat/openat.c   | 146 ++++++++++++++++++++++++++++++
 3 files changed, 173 insertions(+)
 create mode 100644 tools/testing/selftests/openat/.gitignore
 create mode 100644 tools/testing/selftests/openat/Makefile
 create mode 100644 tools/testing/selftests/openat/openat.c

diff --git a/tools/testing/selftests/openat/.gitignore b/tools/testing/selftests/openat/.gitignore
new file mode 100644
index 000000000000..0a2446e89ad5
--- /dev/null
+++ b/tools/testing/selftests/openat/.gitignore
@@ -0,0 +1,3 @@
+openat
+subdir
+topfile
\ No newline at end of file
diff --git a/tools/testing/selftests/openat/Makefile b/tools/testing/selftests/openat/Makefile
new file mode 100644
index 000000000000..dc28ce943edf
--- /dev/null
+++ b/tools/testing/selftests/openat/Makefile
@@ -0,0 +1,24 @@
+CC = $(CROSS_COMPILE)gcc
+CFLAGS = -Wall
+BINARIES = openat
+DEPS = subdir topfile subdir/bottomfile subdir/symlinkup subdir/symlinkout
+all: $(BINARIES) $(DEPS)
+
+subdir:
+	mkdir -p subdir
+topfile:
+	echo 0123456789 > $@
+subdir/bottomfile: | subdir
+	echo 0123456789 > $@
+subdir/symlinkup:
+	ln -s ../topfile $@
+subdir/symlinkout:
+	ln -s /etc/passwd $@
+%: %.c
+	$(CC) $(CFLAGS) -o $@ $^
+
+run_tests: all
+	./openat
+
+clean:
+	rm -rf $(BINARIES) $(DEPS)
diff --git a/tools/testing/selftests/openat/openat.c b/tools/testing/selftests/openat/openat.c
new file mode 100644
index 000000000000..6171af6001c7
--- /dev/null
+++ b/tools/testing/selftests/openat/openat.c
@@ -0,0 +1,146 @@
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <errno.h>
+
+#include <linux/fcntl.h>
+
+/* Bypass glibc */
+static int openat_(int dirfd, const char *pathname, int flags)
+{
+	return syscall(__NR_openat, dirfd, pathname, flags);
+}
+
+static int openat_or_die(int dfd, const char *path, int flags)
+{
+	int fd = openat_(dfd, path, flags);
+	if (fd < 0) {
+		printf("Failed to openat(%d, '%s'); "
+			"check prerequisites are available\n", dfd, path);
+		exit(1);
+	}
+	return fd;
+}
+
+static int check_openat(int dfd, const char *path, int flags)
+{
+	int rc;
+	int fd;
+	char buffer[4];
+
+	errno = 0;
+	printf("Check success of openat(%d, '%s', %x)... ",
+	       dfd, path?:"(null)", flags);
+	fd = openat_(dfd, path, flags);
+	if (fd < 0) {
+		printf("[FAIL]: openat() failed, rc=%d errno=%d (%s)\n",
+			fd, errno, strerror(errno));
+		return 1;
+	}
+	errno = 0;
+	rc = read(fd, buffer, sizeof(buffer));
+	if (rc < 0) {
+		printf("[FAIL]: read() failed, rc=%d errno=%d (%s)\n",
+			rc, errno, strerror(errno));
+		return 1;
+	}
+	close(fd);
+	printf("[OK]\n");
+	return 0;
+}
+
+#define check_openat_fail(dfd, path, flags, errno)	\
+	_check_openat_fail(dfd, path, flags, errno, #errno)
+static int _check_openat_fail(int dfd, const char *path, int flags,
+			      int expected_errno, const char *errno_str)
+{
+	errno = 0;
+	printf("Check failure of openat(%d, '%s', %x) with %s... ",
+		dfd, path?:"(null)", flags, errno_str);
+	int rc = openat_(dfd, path, flags);
+	if (rc > 0) {
+		printf("[FAIL] (unexpected success from openat(2))\n");
+		close(rc);
+		return 1;
+	}
+	if (errno != expected_errno) {
+		printf("[FAIL] (expected errno %d (%s) not %d (%s)\n",
+			expected_errno, strerror(expected_errno),
+			errno, strerror(errno));
+		return 1;
+	}
+	printf("[OK]\n");
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int fail = 0;
+	int dot_dfd = openat_or_die(AT_FDCWD, ".", O_RDONLY);
+	int subdir_dfd = openat_or_die(AT_FDCWD, "subdir", O_RDONLY);
+	int file_fd = openat_or_die(AT_FDCWD, "topfile", O_RDONLY);
+
+	/* Sanity check normal behavior */
+	fail |= check_openat(AT_FDCWD, "topfile", O_RDONLY);
+	fail |= check_openat(AT_FDCWD, "subdir/bottomfile", O_RDONLY);
+
+	fail |= check_openat(dot_dfd, "topfile", O_RDONLY);
+	fail |= check_openat(dot_dfd, "subdir/bottomfile", O_RDONLY);
+	fail |= check_openat(dot_dfd, "subdir/../topfile", O_RDONLY);
+
+	fail |= check_openat(subdir_dfd, "../topfile", O_RDONLY);
+	fail |= check_openat(subdir_dfd, "bottomfile", O_RDONLY);
+	fail |= check_openat(subdir_dfd, "../subdir/bottomfile", O_RDONLY);
+	fail |= check_openat(subdir_dfd, "symlinkup", O_RDONLY);
+	fail |= check_openat(subdir_dfd, "symlinkout", O_RDONLY);
+
+	fail |= check_openat(AT_FDCWD, "/etc/passwd", O_RDONLY);
+	fail |= check_openat(dot_dfd, "/etc/passwd", O_RDONLY);
+	fail |= check_openat(subdir_dfd, "/etc/passwd", O_RDONLY);
+
+	fail |= check_openat_fail(AT_FDCWD, "bogus", O_RDONLY, ENOENT);
+	fail |= check_openat_fail(dot_dfd, "bogus", O_RDONLY, ENOENT);
+	fail |= check_openat_fail(999, "bogus", O_RDONLY, EBADF);
+	fail |= check_openat_fail(file_fd, "bogus", O_RDONLY, ENOTDIR);
+
+#ifdef O_BENEATH_ONLY
+	/* Test out O_BENEATH_ONLY */
+	fail |= check_openat(AT_FDCWD, "topfile", O_RDONLY|O_BENEATH_ONLY);
+	fail |= check_openat(AT_FDCWD, "subdir/bottomfile",
+			     O_RDONLY|O_BENEATH_ONLY);
+
+	fail |= check_openat(dot_dfd, "topfile", O_RDONLY|O_BENEATH_ONLY);
+	fail |= check_openat(dot_dfd, "subdir/bottomfile",
+			     O_RDONLY|O_BENEATH_ONLY);
+	fail |= check_openat(subdir_dfd, "bottomfile", O_RDONLY|O_BENEATH_ONLY);
+
+	/* Can't open paths with ".." in them */
+	fail |= check_openat_fail(dot_dfd, "subdir/../topfile",
+				O_RDONLY|O_BENEATH_ONLY, EACCES);
+	fail |= check_openat_fail(subdir_dfd, "../topfile",
+				  O_RDONLY|O_BENEATH_ONLY, EACCES);
+	fail |= check_openat_fail(subdir_dfd, "../subdir/bottomfile",
+				O_RDONLY|O_BENEATH_ONLY, EACCES);
+
+	/* Can't open paths starting with "/" */
+	fail |= check_openat_fail(AT_FDCWD, "/etc/passwd",
+				  O_RDONLY|O_BENEATH_ONLY, EACCES);
+	fail |= check_openat_fail(dot_dfd, "/etc/passwd",
+				  O_RDONLY|O_BENEATH_ONLY, EACCES);
+	fail |= check_openat_fail(subdir_dfd, "/etc/passwd",
+				  O_RDONLY|O_BENEATH_ONLY, EACCES);
+	/* Can't sneak around constraints with symlinks */
+	fail |= check_openat_fail(subdir_dfd, "symlinkup",
+				  O_RDONLY|O_BENEATH_ONLY, EACCES);
+	fail |= check_openat_fail(subdir_dfd, "symlinkout",
+				  O_RDONLY|O_BENEATH_ONLY, EACCES);
+#else
+	printf("Skipping O_BENEATH_ONLY tests due to missing #define\n");
+#endif
+
+	return fail ? -1 : 0;
+}
-- 
2.0.0.526.g5318336
