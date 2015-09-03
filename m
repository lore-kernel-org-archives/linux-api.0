From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] kselftest/inotify: add inotify_update_watch(2) test-cases
Date: Thu,  3 Sep 2015 17:10:27 +0200
Message-ID: <1441293027-3363-4-git-send-email-dh.herrmann@gmail.com>
References: <1441293027-3363-1-git-send-email-dh.herrmann@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441293027-3363-1-git-send-email-dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: John McCutchan <john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org>, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This adds inotify/ to the kselftests suite. It currently only includes a
test for the new inotify_update_watch(2) call, to make sure it actually
behaves like it should.

Signed-off-by: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 tools/testing/selftests/Makefile               |   1 +
 tools/testing/selftests/inotify/.gitignore     |   2 +
 tools/testing/selftests/inotify/Makefile       |  14 ++++
 tools/testing/selftests/inotify/test_inotify.c | 105 +++++++++++++++++++++++++
 4 files changed, 122 insertions(+)
 create mode 100644 tools/testing/selftests/inotify/.gitignore
 create mode 100644 tools/testing/selftests/inotify/Makefile
 create mode 100644 tools/testing/selftests/inotify/test_inotify.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 24ae9e8..9e9b9cf 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -5,6 +5,7 @@ TARGETS += exec
 TARGETS += firmware
 TARGETS += ftrace
 TARGETS += futex
+TARGETS += inotify
 TARGETS += kcmp
 TARGETS += memfd
 TARGETS += memory-hotplug
diff --git a/tools/testing/selftests/inotify/.gitignore b/tools/testing/selftests/inotify/.gitignore
new file mode 100644
index 0000000..ab7299d
--- /dev/null
+++ b/tools/testing/selftests/inotify/.gitignore
@@ -0,0 +1,2 @@
+test_inotify
+test_file
diff --git a/tools/testing/selftests/inotify/Makefile b/tools/testing/selftests/inotify/Makefile
new file mode 100644
index 0000000..c205abb
--- /dev/null
+++ b/tools/testing/selftests/inotify/Makefile
@@ -0,0 +1,14 @@
+CC = $(CROSS_COMPILE)gcc
+CFLAGS += -I../../../../include/uapi/
+CFLAGS += -I../../../../include/
+CFLAGS += -I../../../../usr/include/
+
+all:
+	$(CC) $(CFLAGS) test_inotify.c -o test_inotify
+
+TEST_PROGS := test_inotify
+
+include ../lib.mk
+
+clean:
+	$(RM) test_inotify test_file
diff --git a/tools/testing/selftests/inotify/test_inotify.c b/tools/testing/selftests/inotify/test_inotify.c
new file mode 100644
index 0000000..094420a
--- /dev/null
+++ b/tools/testing/selftests/inotify/test_inotify.c
@@ -0,0 +1,105 @@
+/*
+ * inotify tests
+ */
+
+#define _GNU_SOURCE
+#define __EXPORTED_HEADERS__
+
+#include <assert.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <inttypes.h>
+#include <limits.h>
+#include <linux/unistd.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/inotify.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#define TEST_FILE "./test_file"
+
+static int sys_inotify_update_watch(int fd, uint32_t wd, uint32_t mask)
+{
+	return syscall(__NR_inotify_update_watch, fd, wd, mask);
+}
+
+static int read_inotify(int fd, struct inotify_event **out)
+{
+	union {
+		struct inotify_event event;
+		char buffer[sizeof(struct inotify_event) + NAME_MAX + 1];
+	} buf;
+	int r;
+
+	r = read(fd, &buf, sizeof(buf));
+	if (r < 0)
+		return r;
+
+	assert(r >= sizeof(struct inotify_event) && r <= sizeof(buf));
+	*out = &buf.event;
+	return r;
+}
+
+/* test inotify_update_watch(2) */
+static void test_update(void)
+{
+	struct inotify_event *event;
+	int ifd, wd, fd, r;
+
+	ifd = inotify_init1(IN_CLOEXEC | IN_NONBLOCK);
+	assert(ifd >= 0);
+
+	unlink(TEST_FILE);
+
+	/* try adding watch on non-existant file */
+	wd = inotify_add_watch(ifd, TEST_FILE, IN_IGNORED);
+	assert(wd < 0 && errno == ENOENT);
+
+	/* create file */
+	fd = open(TEST_FILE, O_CREAT | O_CLOEXEC | O_EXCL, S_IRUSR);
+	assert(fd >= 0);
+
+	/* add watch descriptor without IN_CLOSE */
+	wd = inotify_add_watch(ifd, TEST_FILE, IN_IGNORED);
+	assert(wd > 0);
+
+	/* close file */
+	close(fd);
+
+	/* should not have gotten any event */
+	r = read_inotify(ifd, &event);
+	assert(r < 0 && errno == EAGAIN);
+
+	/* reopen file */
+	fd = open(TEST_FILE, O_CLOEXEC | O_EXCL);
+	assert(fd >= 0);
+
+	/* invalid flags must result in EINVAL */
+	r = sys_inotify_update_watch(ifd, wd, -1);
+	assert(r < 0 && errno == EINVAL);
+
+	/* update watch descriptor with IN_CLOSE */
+	r = sys_inotify_update_watch(ifd, wd, IN_MASK_ADD | IN_CLOSE);
+	assert(r >= 0);
+
+	/* close file */
+	close(fd);
+
+	/* now we should have seen the event */
+	r = read_inotify(ifd, &event);
+	assert(r >= 0);
+	assert(event->wd == wd);
+	assert(event->mask & IN_CLOSE);
+
+	unlink(TEST_FILE);
+	close(ifd);
+}
+
+int main(int argc, char **argv)
+{
+	test_update();
+	return 0;
+}
-- 
2.5.1
