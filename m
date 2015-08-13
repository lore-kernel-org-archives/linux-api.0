From: David Drysdale <drysdale@google.com>
Subject: [PATCHv4 2/3] selftests: Add test of O_BENEATH & openat(2)
Date: Thu, 13 Aug 2015 10:32:45 +0100
Message-ID: <1439458366-8223-3-git-send-email-drysdale@google.com>
References: <1439458366-8223-1-git-send-email-drysdale@google.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1439458366-8223-1-git-send-email-drysdale@google.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Meredydd Luff <meredydd@senatehouse.org>, Will Drewry <wad@chromium.org>, Jorge Lucangeli Obes <jorgelo@google.com>, Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>, Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Dave Chinner <david@fromorbit.com>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Add simple tests of openat(2) variations, including examples that
check the new O_BENEATH flag.

Signed-off-by: David Drysdale <drysdale@google.com>
---
 tools/testing/selftests/Makefile          |   1 +
 tools/testing/selftests/openat/.gitignore |   4 +
 tools/testing/selftests/openat/Makefile   |  29 ++++
 tools/testing/selftests/openat/openat.c   | 258 ++++++++++++++++++++++++++++++
 4 files changed, 292 insertions(+)
 create mode 100644 tools/testing/selftests/openat/.gitignore
 create mode 100644 tools/testing/selftests/openat/Makefile
 create mode 100644 tools/testing/selftests/openat/openat.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 24ae9e829e9a..606f8df5c8aa 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -11,6 +11,7 @@ TARGETS += memory-hotplug
 TARGETS += mount
 TARGETS += mqueue
 TARGETS += net
+TARGETS += openat
 TARGETS += powerpc
 TARGETS += ptrace
 TARGETS += seccomp
diff --git a/tools/testing/selftests/openat/.gitignore b/tools/testing/selftests/openat/.gitignore
new file mode 100644
index 000000000000..835b2dcd8678
--- /dev/null
+++ b/tools/testing/selftests/openat/.gitignore
@@ -0,0 +1,4 @@
+openat
+subdir
+topfile
+symlinkdown
\ No newline at end of file
diff --git a/tools/testing/selftests/openat/Makefile b/tools/testing/selftests/openat/Makefile
new file mode 100644
index 000000000000..73f80428b6a5
--- /dev/null
+++ b/tools/testing/selftests/openat/Makefile
@@ -0,0 +1,29 @@
+CFLAGS = -Wall
+BINARIES = openat
+DEPS = subdir topfile symlinkdown subdir/bottomfile subdir/symlinkup subdir/symlinkout subdir/symlinkin
+all: $(BINARIES) $(DEPS)
+
+subdir:
+	mkdir -p subdir
+topfile:
+	echo 0123456789 > $@
+subdir/bottomfile: | subdir
+	echo 0123456789 > $@
+subdir/symlinkup: | subdir
+	ln -s ../topfile $@
+subdir/symlinkout: | subdir
+	ln -s /etc/passwd $@
+subdir/symlinkin: | subdir
+	ln -s bottomfile $@
+symlinkdown:
+	ln -s subdir/bottomfile $@
+%: %.c
+	$(CC) $(CFLAGS) -o $@ $^
+
+TEST_PROGS := openat
+TEST_FILES := $(DEPS)
+
+include ../lib.mk
+
+clean:
+	rm -rf $(BINARIES) $(DEPS)
diff --git a/tools/testing/selftests/openat/openat.c b/tools/testing/selftests/openat/openat.c
new file mode 100644
index 000000000000..bc2c4b02a091
--- /dev/null
+++ b/tools/testing/selftests/openat/openat.c
@@ -0,0 +1,258 @@
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
+static int open_(const char *pathname, int flags)
+{
+	return syscall(__NR_open, pathname, flags);
+}
+
+static int openat_or_die(int dfd, const char *path, int flags)
+{
+	int fd = openat_(dfd, path, flags);
+
+	if (fd < 0) {
+		printf("Failed to openat(%d, '%s'); "
+			"check prerequisites are available\n", dfd, path);
+		exit(1);
+	}
+	return fd;
+}
+
+static int check_fd(int fd)
+{
+	int rc;
+	struct stat info;
+	char buffer[4];
+
+	if (fd < 0) {
+		printf("[FAIL]: openat() failed, rc=%d errno=%d (%s)\n",
+			fd, errno, strerror(errno));
+		return 1;
+	}
+	if (fstat(fd, &info) != 0) {
+		printf("[FAIL]: fstat() failed, rc=%d errno=%d (%s)\n",
+			fd, errno, strerror(errno));
+		return 1;
+	}
+	if (!S_ISDIR(info.st_mode)) {
+		errno = 0;
+		rc = read(fd, buffer, sizeof(buffer));
+		if (rc < 0) {
+			printf("[FAIL]: read() failed, rc=%d errno=%d (%s)\n",
+				rc, errno, strerror(errno));
+			return 1;
+		}
+	}
+	close(fd);
+	printf("[OK]\n");
+	return 0;
+}
+
+static int check_openat(int dfd, const char *path, int flags)
+{
+	int fd;
+
+	errno = 0;
+	printf("Check success of openat(%d, '%s', %x)... ",
+	       dfd, path?:"(null)", flags);
+	fd = openat_(dfd, path, flags);
+	return check_fd(fd);
+}
+
+static int check_open(const char *path, int flags)
+{
+	int fd;
+
+	errno = 0;
+	printf("Check success of open('%s', %x)... ", path?:"(null)", flags);
+	fd = open_(path, flags);
+	return check_fd(fd);
+}
+
+static int check_fail(int rc, int expected_errno, const char *errno_str)
+{
+	if (rc > 0) {
+		printf("[FAIL] (unexpected success from open operation)\n");
+		close(rc);
+		return 1;
+	}
+	if (errno != expected_errno) {
+		printf("[FAIL] (expected errno %d (%s) not %d (%s)\n",
+			expected_errno, strerror(expected_errno),
+			       errno, strerror(errno));
+		return 1;
+	}
+	printf("[OK]\n");
+	return 0;
+}
+
+#define check_openat_fail(dfd, path, flags, errno)	\
+	_check_openat_fail(dfd, path, flags, errno, #errno)
+static int _check_openat_fail(int dfd, const char *path, int flags,
+			      int expected_errno, const char *errno_str)
+{
+	int rc;
+
+	printf("Check failure of openat(%d, '%s', %x) with %s... ",
+		dfd, path?:"(null)", flags, errno_str);
+	errno = 0;
+	rc = openat_(dfd, path, flags);
+	return check_fail(rc, expected_errno, errno_str);
+}
+
+#define check_open_fail(path, flags, errno)	\
+	_check_open_fail(path, flags, errno, #errno)
+static int _check_open_fail(const char *path, int flags,
+			    int expected_errno, const char *errno_str)
+{
+	int rc;
+
+	printf("Check failure of open('%s', %x) with %s... ",
+	       path?:"(null)", flags, errno_str);
+	errno = 0;
+	rc = open_(path, flags);
+	return check_fail(rc, expected_errno, errno_str);
+}
+
+int check_proc(void)
+{
+	int root_dfd = openat_(AT_FDCWD, "/", O_RDONLY);
+	int proc_dfd = openat_(AT_FDCWD, "/proc/self", O_RDONLY);
+	int fail = 0;
+
+	if (proc_dfd < 0) {
+		printf("'/proc/self' unavailable (errno=%d '%s'), skipping\n",
+			errno, strerror(errno));
+		return 0;
+	}
+	fail += check_openat(proc_dfd, "root/etc/passwd", O_RDONLY);
+	fail += check_openat(root_dfd, "proc/self/root/etc/passwd", O_RDONLY);
+#ifdef O_BENEATH
+	fail += check_openat_fail(proc_dfd, "root/etc/passwd",
+				  O_RDONLY|O_BENEATH, EPERM);
+	fail += check_openat_fail(root_dfd, "proc/self/root/etc/passwd",
+				O_RDONLY|O_BENEATH, EPERM);
+#endif
+	return fail;
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
+	fail += check_open("topfile", O_RDONLY);
+	fail += check_open("subdir/bottomfile", O_RDONLY);
+	fail += check_openat(AT_FDCWD, "topfile", O_RDONLY);
+	fail += check_openat(AT_FDCWD, "subdir/bottomfile", O_RDONLY);
+
+	fail += check_openat(dot_dfd, "topfile", O_RDONLY);
+	fail += check_openat(dot_dfd, "subdir/bottomfile", O_RDONLY);
+	fail += check_openat(dot_dfd, "subdir/../topfile", O_RDONLY);
+	fail += check_open("subdir/../topfile", O_RDONLY);
+
+	fail += check_openat(subdir_dfd, "../topfile", O_RDONLY);
+	fail += check_openat(subdir_dfd, "bottomfile", O_RDONLY);
+	fail += check_openat(subdir_dfd, "../subdir/bottomfile", O_RDONLY);
+	fail += check_openat(subdir_dfd, "symlinkup", O_RDONLY);
+	fail += check_openat(subdir_dfd, "symlinkout", O_RDONLY);
+
+	fail += check_open("/etc/passwd", O_RDONLY);
+	fail += check_openat(AT_FDCWD, "/etc/passwd", O_RDONLY);
+	fail += check_openat(dot_dfd, "/etc/passwd", O_RDONLY);
+	fail += check_openat(subdir_dfd, "/etc/passwd", O_RDONLY);
+
+	fail += check_openat_fail(AT_FDCWD, "bogus", O_RDONLY, ENOENT);
+	fail += check_openat_fail(dot_dfd, "bogus", O_RDONLY, ENOENT);
+	fail += check_openat_fail(999, "bogus", O_RDONLY, EBADF);
+	fail += check_openat_fail(file_fd, "bogus", O_RDONLY, ENOTDIR);
+
+#ifdef O_BENEATH
+	/* Test out O_BENEATH */
+	fail += check_open("topfile", O_RDONLY|O_BENEATH);
+	fail += check_open("subdir/bottomfile", O_RDONLY|O_BENEATH);
+	fail += check_openat(AT_FDCWD, "topfile", O_RDONLY|O_BENEATH);
+	fail += check_openat(AT_FDCWD, "subdir/bottomfile",
+			     O_RDONLY|O_BENEATH);
+
+	fail += check_openat(dot_dfd, "topfile", O_RDONLY|O_BENEATH);
+	fail += check_openat(dot_dfd, "subdir/bottomfile",
+			     O_RDONLY|O_BENEATH);
+	fail += check_openat(dot_dfd, "subdir///bottomfile",
+			     O_RDONLY|O_BENEATH);
+	fail += check_openat(subdir_dfd, "bottomfile", O_RDONLY|O_BENEATH);
+	fail += check_openat(subdir_dfd, "./bottomfile", O_RDONLY|O_BENEATH);
+	fail += check_openat(subdir_dfd, ".", O_RDONLY|O_BENEATH);
+
+	/* Symlinks without .. or leading / are OK */
+	fail += check_open("symlinkdown", O_RDONLY|O_BENEATH);
+	fail += check_open("subdir/symlinkin", O_RDONLY|O_BENEATH);
+	fail += check_openat(dot_dfd, "symlinkdown", O_RDONLY|O_BENEATH);
+	fail += check_openat(dot_dfd, "subdir/symlinkin", O_RDONLY|O_BENEATH);
+	fail += check_openat(subdir_dfd, "symlinkin", O_RDONLY|O_BENEATH);
+	/* ... unless of course we specify O_NOFOLLOW */
+	fail += check_open_fail("symlinkdown",
+				O_RDONLY|O_BENEATH|O_NOFOLLOW, ELOOP);
+	fail += check_open_fail("subdir/symlinkin",
+				O_RDONLY|O_BENEATH|O_NOFOLLOW, ELOOP);
+	fail += check_openat_fail(dot_dfd, "symlinkdown",
+				  O_RDONLY|O_BENEATH|O_NOFOLLOW, ELOOP);
+	fail += check_openat_fail(dot_dfd, "subdir/symlinkin",
+				  O_RDONLY|O_BENEATH|O_NOFOLLOW, ELOOP);
+	fail += check_openat_fail(subdir_dfd, "symlinkin",
+				  O_RDONLY|O_BENEATH|O_NOFOLLOW, ELOOP);
+
+	/* Can't open paths with ".." in them */
+	fail += check_open_fail("subdir/../topfile",
+				O_RDONLY|O_BENEATH, EPERM);
+	fail += check_openat_fail(dot_dfd, "subdir/../topfile",
+				O_RDONLY|O_BENEATH, EPERM);
+	fail += check_openat_fail(subdir_dfd, "../topfile",
+				  O_RDONLY|O_BENEATH, EPERM);
+	fail += check_openat_fail(subdir_dfd, "../subdir/bottomfile",
+				O_RDONLY|O_BENEATH, EPERM);
+	fail += check_openat_fail(subdir_dfd, "..", O_RDONLY|O_BENEATH, EPERM);
+
+	/* Can't open paths starting with "/" */
+	fail += check_open_fail("/etc/passwd", O_RDONLY|O_BENEATH, EPERM);
+	fail += check_openat_fail(AT_FDCWD, "/etc/passwd",
+				  O_RDONLY|O_BENEATH, EPERM);
+	fail += check_openat_fail(dot_dfd, "/etc/passwd",
+				  O_RDONLY|O_BENEATH, EPERM);
+	fail += check_openat_fail(subdir_dfd, "/etc/passwd",
+				  O_RDONLY|O_BENEATH, EPERM);
+	/* Can't sneak around constraints with symlinks */
+	fail += check_openat_fail(subdir_dfd, "symlinkup",
+				  O_RDONLY|O_BENEATH, EPERM);
+	fail += check_openat_fail(subdir_dfd, "symlinkout",
+				  O_RDONLY|O_BENEATH, EPERM);
+	fail += check_openat_fail(subdir_dfd, "../symlinkdown",
+				  O_RDONLY|O_BENEATH, EPERM);
+	fail += check_openat_fail(dot_dfd, "subdir/symlinkup",
+				  O_RDONLY|O_BENEATH, EPERM);
+	fail += check_open_fail("subdir/symlinkup", O_RDONLY|O_BENEATH, EPERM);
+#else
+	printf("Skipping O_BENEATH tests due to missing #define\n");
+#endif
+	fail += check_proc();
+
+	if (fail > 0)
+		printf("%d tests failed\n", fail);
+	return fail;
+}
-- 
1.9.1
