From: Kazimierz Krosman <k.krosman@samsung.com>
Subject: [PATCH v6 8/8] kmsg: selftests
Date: Wed, 24 Feb 2016 12:53:21 +0100
Message-ID: <1456314801-32738-9-git-send-email-k.krosman@samsung.com>
References: <1456314801-32738-1-git-send-email-k.krosman@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1456314801-32738-1-git-send-email-k.krosman@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, peter@hurleysoftware.com, tj@kernel.org, vvs@virtuozzo.com, corbet@lwn.net, arnd@arndb.de, pmladek@suse.cz, gregkh@linuxfoundation.org, daniel@zonque.org, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: k.lewandowsk@samsung.com, k.krosman@samsung.com, m.niesluchow@samsung.com, richard.weinberger@gmail.com, b.zolnierkie@samsung.com, luto@amacapital.net, knhoon.baik@samsung.com
List-Id: linux-api@vger.kernel.org

From: Paul Osmialowski <p.osmialowsk@samsung.com>

This patch adds selftests framework and four test scenarios for kmsg.

The framework shape and code was inspired by similar selftests framework
for kdbus.

Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
[Fixed multithreaded test bug: buffer size > LOG_LINE_MAX]
Signed-off-by: Kazimierz Krosman <k.krosman@samsung.com>
---
 samples/kmsg/kmsg-api.h                            |  44 +++
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/kmsg/.gitignore            |   1 +
 tools/testing/selftests/kmsg/Makefile              |  30 ++
 tools/testing/selftests/kmsg/kmsg-test.c           | 344 +++++++++++++++++++++
 tools/testing/selftests/kmsg/kmsg-test.h           |  28 ++
 tools/testing/selftests/kmsg/test-buffer-add-del.c |  78 +++++
 .../kmsg/test-buffer-add-write-read-del.c          | 163 ++++++++++
 .../kmsg/test-buffer-buf-multithreaded-torture.c   | 201 ++++++++++++
 .../selftests/kmsg/test-buffer-buf-torture.c       | 141 +++++++++
 10 files changed, 1031 insertions(+)
 create mode 100644 samples/kmsg/kmsg-api.h
 create mode 100644 tools/testing/selftests/kmsg/.gitignore
 create mode 100644 tools/testing/selftests/kmsg/Makefile
 create mode 100644 tools/testing/selftests/kmsg/kmsg-test.c
 create mode 100644 tools/testing/selftests/kmsg/kmsg-test.h
 create mode 100644 tools/testing/selftests/kmsg/test-buffer-add-del.c
 create mode 100644 tools/testing/selftests/kmsg/test-buffer-add-write-read-del.c
 create mode 100644 tools/testing/selftests/kmsg/test-buffer-buf-multithreaded-torture.c
 create mode 100644 tools/testing/selftests/kmsg/test-buffer-buf-torture.c

diff --git a/samples/kmsg/kmsg-api.h b/samples/kmsg/kmsg-api.h
new file mode 100644
index 0000000..9004acd
--- /dev/null
+++ b/samples/kmsg/kmsg-api.h
@@ -0,0 +1,44 @@
+#ifndef KMSG_API_H
+#define KMSG_API_H
+
+#include <stdint.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+#include <linux/kmsg_ioctl.h>
+
+static inline int kmsg_cmd_buffer_add(int fd, struct kmsg_cmd_buffer_add *cmd)
+{
+	int ret = ioctl(fd, KMSG_CMD_BUFFER_ADD, cmd);
+
+	return (ret < 0) ? (errno > 0 ? -errno : -EINVAL) : 0;
+}
+
+static inline int kmsg_cmd_buffer_del(int fd, int *minor)
+{
+	int ret = ioctl(fd, KMSG_CMD_BUFFER_DEL, minor);
+
+	return (ret < 0) ? (errno > 0 ? -errno : -EINVAL) : 0;
+}
+
+static inline int kmsg_cmd_get_buf_size(int fd, uint32_t *size)
+{
+	int ret = ioctl(fd, KMSG_CMD_GET_BUF_SIZE, size);
+
+	return (ret < 0) ? (errno > 0 ? -errno : -EINVAL) : 0;
+}
+
+static inline int kmsg_cmd_get_read_size_max(int fd, uint32_t *max_size)
+{
+	int ret = ioctl(fd, KMSG_CMD_GET_READ_SIZE_MAX, max_size);
+
+	return (ret < 0) ? (errno > 0 ? -errno : -EINVAL) : 0;
+}
+
+static inline int kmsg_cmd_clear(int fd)
+{
+	int ret = ioctl(fd, KMSG_CMD_CLEAR);
+
+	return (ret < 0) ? (errno > 0 ? -errno : -EINVAL) : 0;
+}
+
+#endif /* KMSG_API_H */
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index b04afc3..52b32da 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -8,6 +8,7 @@ TARGETS += ftrace
 TARGETS += futex
 TARGETS += ipc
 TARGETS += kcmp
+TARGETS += kmsg
 TARGETS += lib
 TARGETS += membarrier
 TARGETS += memfd
diff --git a/tools/testing/selftests/kmsg/.gitignore b/tools/testing/selftests/kmsg/.gitignore
new file mode 100644
index 0000000..687d517
--- /dev/null
+++ b/tools/testing/selftests/kmsg/.gitignore
@@ -0,0 +1 @@
+kmsg-test
diff --git a/tools/testing/selftests/kmsg/Makefile b/tools/testing/selftests/kmsg/Makefile
new file mode 100644
index 0000000..cee2e2b
--- /dev/null
+++ b/tools/testing/selftests/kmsg/Makefile
@@ -0,0 +1,30 @@
+CFLAGS += -I../../../../usr/include/
+CFLAGS += -I../../../../samples/kmsg/
+CFLAGS += -I../../../../include/uapi/
+CFLAGS += -std=gnu99 -Wall
+CFLAGS += -DKBUILD_MODNAME=\"kmsg\" -D_GNU_SOURCE
+CFLAGS += -pthread
+LDLIBS += -pthread
+
+OBJS= \
+	kmsg-test.o				\
+	test-buffer-add-del.o			\
+	test-buffer-add-write-read-del.o	\
+	test-buffer-buf-torture.o		\
+	test-buffer-buf-multithreaded-torture.o
+
+all: kmsg-test
+
+include ../lib.mk
+
+%.o: %.c kmsg-test.h
+	$(CC) $(CFLAGS) -c $< -o $@
+
+kmsg-test: $(OBJS)
+	$(CC) $(CFLAGS) $^ $(LDLIBS) -o $@
+
+run_tests:
+	./kmsg-test
+
+clean:
+	rm -f *.o kmsg-test
diff --git a/tools/testing/selftests/kmsg/kmsg-test.c b/tools/testing/selftests/kmsg/kmsg-test.c
new file mode 100644
index 0000000..282ec1f
--- /dev/null
+++ b/tools/testing/selftests/kmsg/kmsg-test.c
@@ -0,0 +1,344 @@
+#include <stddef.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <getopt.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <sys/stat.h>
+
+#include "../kselftest.h"
+
+#include "kmsg-test.h"
+
+struct kmsg_test {
+	const char	*name;
+	const char	*desc;
+	int (*func)(const struct kmsg_test_args *args);
+};
+
+static const struct kmsg_test tests[] = {
+	{
+		.name	= "buffer-add-del",
+		.desc	= "create and delete kmsg devices",
+		.func	= kmsg_test_buffer_add_del,
+	}, {
+		.name	= "buffer-add-write-read-del",
+		.desc	= "create w/r and del kmsg device",
+		.func	= kmsg_test_buffer_add_write_read_del,
+	}, {
+		.name	= "buffer-buf-torture",
+		.desc	= "fill more than whole buffer can hold",
+		.func	= kmsg_test_buffer_buf_torture,
+	}, {
+		.name	= "buffer-buf-multithreaded-torture",
+		.desc	= "fill from many threads",
+		.func	= kmsg_test_buffer_buf_multithreaded_torture,
+	},
+};
+
+#define N_TESTS ARRAY_SIZE(tests)
+
+FILE *kmsg_get_device(int minor, const char *mode)
+{
+	char path[80] = "";
+	dev_t dev = makedev(1, minor);
+
+	if (minor < 0) {
+		printf("Invalid minor number %d\n", minor);
+		return NULL;
+	}
+
+	snprintf(path, sizeof(path), "/tmp/kmsg-%d", minor);
+
+	if (access(path, F_OK) < 0) {
+		if (mknod(path, S_IFCHR | 0600, dev)) {
+			printf("Cannot create device %s with minor %d\n",
+								path, minor);
+			return NULL;
+		}
+	}
+
+	if (access(path, F_OK) < 0) {
+		printf("Cannot access device %s\n", path);
+		return NULL;
+	}
+
+	return fopen(path, mode);
+}
+
+int kmsg_drop_device(int minor)
+{
+	char path[80] = "";
+
+	if (minor < 0) {
+		printf("Invalid minor number %d\n", minor);
+		return -1;
+	}
+
+	snprintf(path, sizeof(path), "/tmp/kmsg-%d", minor);
+
+	return unlink(path);
+}
+
+static void usage(const char *argv0)
+{
+	unsigned int i, j;
+
+	printf("Usage: %s [options]\n"
+	       "Options:\n"
+	       "\t-x, --loop		Run in a loop\n"
+	       "\t-f, --fork		Fork before running a test\n"
+	       "\t-h, --help		Print this help\n"
+	       "\t-t, --test <test-id>	Run one specific test only\n"
+	       "\t-w, --wait <secs>	Wait <secs> before actually starting test\n"
+	       "\n", argv0);
+
+	printf("By default, all test are run once, and a summary is printed.\n"
+	       "Available tests for --test:\n\n");
+
+	for (i = 0; i < N_TESTS; i++) {
+		const struct kmsg_test *t = tests + i;
+
+		printf("\t%s", t->name);
+
+		for (j = 0; j < 60 - strlen(t->name); j++)
+			printf(" ");
+
+		printf("Test %s\n", t->desc);
+	}
+
+	printf("\n");
+	printf("Note that some tests may, if run specifically by --test, ");
+	printf("behave differently, and not terminate by themselves.\n");
+}
+
+static void print_test_result(int ret)
+{
+	switch (ret) {
+	case KSFT_PASS:
+		printf("OK");
+		break;
+	case KSFT_SKIP:
+		printf("SKIPPED");
+		break;
+	case KSFT_FAIL:
+		printf("ERROR");
+		break;
+	}
+}
+
+static int test_run(const struct kmsg_test *t,
+		    const struct kmsg_test_args *kmsg_args,
+		    int wait)
+{
+	int ret;
+
+	if (wait > 0) {
+		printf("Sleeping %d seconds before running test ...\n", wait);
+		sleep(wait);
+	}
+
+	ret = t->func(kmsg_args);
+	return ret;
+}
+
+static int test_run_forked(const struct kmsg_test *t,
+			   const struct kmsg_test_args *kmsg_args,
+			   int wait)
+{
+	int ret;
+	pid_t pid;
+
+	pid = fork();
+	if (pid < 0) {
+		return KSFT_FAIL;
+	} else if (pid == 0) {
+		ret = test_run(t, kmsg_args, wait);
+		_exit(ret);
+	}
+
+	pid = waitpid(pid, &ret, 0);
+	if (pid <= 0)
+		return KSFT_FAIL;
+	else if (!WIFEXITED(ret))
+		return KSFT_FAIL;
+	else
+		return WEXITSTATUS(ret);
+}
+
+static int start_all_tests(const struct kmsg_test_args *kmsg_args)
+{
+	int retval;
+	int ret = KSFT_PASS;
+	unsigned int i, n;
+	const struct kmsg_test *t;
+
+	for (i = 0; i < N_TESTS; i++) {
+		t = tests + i;
+
+		printf("Testing %s (%s) ", t->desc, t->name);
+		for (n = 0; n < 60 - strlen(t->desc) - strlen(t->name); n++)
+			printf(".");
+		printf(" ");
+
+		retval = test_run_forked(t, kmsg_args, 0);
+		switch (retval) {
+		case KSFT_PASS:
+			ksft_inc_pass_cnt();
+			break;
+		case KSFT_SKIP:
+			ksft_inc_xskip_cnt();
+			break;
+		case KSFT_FAIL:
+		default:
+			ret = KSFT_FAIL;
+			ksft_inc_fail_cnt();
+			break;
+		}
+
+		print_test_result(retval);
+		printf("\n");
+	}
+
+	return ret;
+}
+
+static int start_one_test(const struct kmsg_test_args *kmsg_args)
+{
+	int i, ret = KSFT_PASS;
+	bool test_found = false;
+	const struct kmsg_test *t;
+
+	for (i = 0; i < N_TESTS; i++) {
+		t = tests + i;
+
+		if (strcmp(t->name, kmsg_args->test))
+			continue;
+
+		do {
+			test_found = true;
+			if (kmsg_args->fork)
+				ret = test_run_forked(t, kmsg_args,
+						      kmsg_args->wait);
+			else
+				ret = test_run(t, kmsg_args,
+					       kmsg_args->wait);
+
+			printf("Testing %s: ", t->desc);
+			print_test_result(ret);
+			printf("\n");
+
+			if ((ret != KSFT_PASS) && (ret != KSFT_SKIP))
+				break;
+		} while (kmsg_args->loop);
+
+		return ret;
+	}
+
+	if (!test_found) {
+		printf("Unknown test-id '%s'\n", kmsg_args->test);
+		return KSFT_FAIL;
+	}
+
+	return ret;
+}
+
+static int start_tests(const struct kmsg_test_args *kmsg_args)
+{
+	int retval;
+	int ret = KSFT_PASS;
+
+	if (kmsg_args->test) {
+		retval = start_one_test(kmsg_args);
+		switch (retval) {
+		case KSFT_PASS:
+			ksft_inc_pass_cnt();
+			break;
+		case KSFT_SKIP:
+			ksft_inc_xskip_cnt();
+			break;
+		case KSFT_FAIL:
+		default:
+			ret = KSFT_FAIL;
+			ksft_inc_fail_cnt();
+			break;
+		}
+	} else  {
+		do {
+			ret = start_all_tests(kmsg_args);
+			if ((ret != KSFT_PASS) && (ret != KSFT_SKIP))
+				break;
+		} while (kmsg_args->loop);
+	}
+
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	int t, ret = 0;
+	struct kmsg_test_args *kmsg_args;
+	char *exec = basename(argv[0]);
+
+	kmsg_args = malloc(sizeof(*kmsg_args));
+	if (!kmsg_args) {
+		printf("unable to malloc() kmsg_args\n");
+		return ksft_exit_fail();
+	}
+
+	memset(kmsg_args, 0, sizeof(*kmsg_args));
+
+	static const struct option options[] = {
+		{ "loop",	no_argument,		NULL, 'x' },
+		{ "help",	no_argument,		NULL, 'h' },
+		{ "test",	required_argument,	NULL, 't' },
+		{ "wait",	required_argument,	NULL, 'w' },
+		{ "fork",	no_argument,		NULL, 'f' },
+		{}
+	};
+
+	if (strcmp(exec, "kmsg-test") != 0)
+		kmsg_args->test = exec;
+
+	while ((t = getopt_long(argc, argv, "hxfm:r:t:b:w:a",
+						options, NULL)) >= 0) {
+		switch (t) {
+		case 'x':
+			kmsg_args->loop = 1;
+			break;
+
+		case 't':
+			kmsg_args->test = optarg;
+			break;
+
+		case 'w':
+			kmsg_args->wait = strtol(optarg, NULL, 10);
+			break;
+
+		case 'f':
+			kmsg_args->fork = 1;
+			break;
+
+		default:
+		case 'h':
+			usage(argv[0]);
+			return ksft_exit_fail();
+		}
+	}
+
+	ret = start_tests(kmsg_args);
+
+	free(kmsg_args);
+
+	ksft_print_cnts();
+
+	if ((ret != KSFT_PASS) && (ret != KSFT_SKIP))
+		return ksft_exit_fail();
+
+	return ksft_exit_pass();
+}
diff --git a/tools/testing/selftests/kmsg/kmsg-test.h b/tools/testing/selftests/kmsg/kmsg-test.h
new file mode 100644
index 0000000..d9f770c
--- /dev/null
+++ b/tools/testing/selftests/kmsg/kmsg-test.h
@@ -0,0 +1,28 @@
+#ifndef _KMSG_TEST_H_
+#define _KMSG_TEST_H_
+
+#include <stdio.h>
+
+#define DEV_KMSG "/dev/kmsg"
+
+#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))
+
+#define KMSG_REQUESTED_BUF_SIZE (1024 * 256)
+
+struct kmsg_test_args {
+	int loop;
+	int wait;
+	int fork;
+	const char *test;
+};
+
+FILE *kmsg_get_device(int minor, const char *mode);
+int kmsg_drop_device(int minor);
+
+int kmsg_test_buffer_add_del(const struct kmsg_test_args *args);
+int kmsg_test_buffer_add_write_read_del(const struct kmsg_test_args *args);
+int kmsg_test_buffer_buf_torture(const struct kmsg_test_args *args);
+int kmsg_test_buffer_buf_multithreaded_torture(
+					const struct kmsg_test_args *args);
+
+#endif /* _KMSG_TEST_H_ */
diff --git a/tools/testing/selftests/kmsg/test-buffer-add-del.c b/tools/testing/selftests/kmsg/test-buffer-add-del.c
new file mode 100644
index 0000000..4acef53
--- /dev/null
+++ b/tools/testing/selftests/kmsg/test-buffer-add-del.c
@@ -0,0 +1,78 @@
+#include <stddef.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <kmsg-api.h>
+
+#include "../kselftest.h"
+
+#include "kmsg-test.h"
+
+int kmsg_test_buffer_add_del(const struct kmsg_test_args *args)
+{
+	int i;
+	int fd = open(DEV_KMSG, O_RDWR);
+	struct kmsg_cmd_buffer_add cmd = { 0 };
+	int minors[] = { -1, -1, -1, -1 };
+	FILE *fds[ARRAY_SIZE(minors)];
+	int retval = KSFT_PASS;
+	uint32_t size;
+
+	if (fd < 0) {
+		printf("Failed: cannot open %s\n", DEV_KMSG);
+		return KSFT_FAIL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(minors); i++) {
+		fds[i] = NULL;
+		cmd.size = KMSG_REQUESTED_BUF_SIZE;
+		cmd.mode = 0662;
+		if (kmsg_cmd_buffer_add(fd, &cmd)) {
+			printf("Failed to add buffer\n");
+			goto error;
+		}
+		if (cmd.minor < 0) {
+			printf("Minor number < 0\n");
+			goto error;
+		}
+		minors[i] = cmd.minor;
+		fds[i] = kmsg_get_device(minors[i], "r");
+		if (!fds[i]) {
+			printf("Cannot get device %d\n", i);
+			goto error;
+		}
+		size = 0;
+		if (kmsg_cmd_get_buf_size(fileno(fds[i]), &size)) {
+			printf("Cannot get buf size on defice %d\n", i);
+			goto error;
+		}
+		if (size != KMSG_REQUESTED_BUF_SIZE) {
+			printf("Invalid buf size on device %d\n", i);
+			goto error;
+		}
+	}
+
+	goto cleanup;
+
+error:
+	retval = KSFT_FAIL;
+
+cleanup:
+	for (i = 0; i < ARRAY_SIZE(minors); i++) {
+		if (minors[i] < 0)
+			continue;
+		if (fds[i])
+			fclose(fds[i]);
+		if (kmsg_drop_device(minors[i])) {
+			printf("Failed to delete device file %d\n", i);
+			retval = KSFT_FAIL;
+		}
+		if (kmsg_cmd_buffer_del(fd, &minors[i])) {
+			printf("Failed to delete buffer %d\n", i);
+			retval = KSFT_FAIL;
+		}
+	}
+	close(fd);
+	return retval;
+}
diff --git a/tools/testing/selftests/kmsg/test-buffer-add-write-read-del.c b/tools/testing/selftests/kmsg/test-buffer-add-write-read-del.c
new file mode 100644
index 0000000..2f21bce
--- /dev/null
+++ b/tools/testing/selftests/kmsg/test-buffer-add-write-read-del.c
@@ -0,0 +1,163 @@
+#include <stddef.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <kmsg-api.h>
+
+#include "../kselftest.h"
+
+#include "kmsg-test.h"
+
+static const char *message(char *buff, size_t size, int i, int j)
+{
+	snprintf(buff, size, "Test message (%d, %d)", i, j);
+	return buff;
+}
+
+int kmsg_test_buffer_add_write_read_del(const struct kmsg_test_args *args)
+{
+	int i, j;
+	int fd = open(DEV_KMSG, O_RDWR);
+	struct kmsg_cmd_buffer_add cmd = { 0 };
+	int minors[] = { -1, -1, -1, -1 };
+	FILE *fds[ARRAY_SIZE(minors)];
+	FILE *log[ARRAY_SIZE(minors)];
+	int logfd;
+	int retval = KSFT_PASS;
+	uint32_t size;
+	char txt[80] = "";
+	char *buff = NULL;
+	const char *msg;
+	char *msgend;
+
+	if (fd < 0) {
+		printf("Failed: cannot open %s\n", DEV_KMSG);
+		return KSFT_FAIL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(minors); i++) {
+		fds[i] = NULL;
+		log[i] = NULL;
+		cmd.size = KMSG_REQUESTED_BUF_SIZE;
+		cmd.mode = 0662;
+		if (kmsg_cmd_buffer_add(fd, &cmd)) {
+			printf("Failed to add buffer\n");
+			goto error;
+		}
+		if (cmd.minor < 0) {
+			printf("Minor number < 0\n");
+			goto error;
+		}
+		minors[i] = cmd.minor;
+
+		fds[i] = kmsg_get_device(minors[i], "w");
+		if (!fds[i]) {
+			printf("Cannot get device %d for write\n", i);
+			goto error;
+		}
+		size = 0;
+		if (kmsg_cmd_get_buf_size(fileno(fds[i]), &size)) {
+			printf("Cannot get buf size on defice %d\n", i);
+			goto error;
+		}
+		if (size != KMSG_REQUESTED_BUF_SIZE) {
+			printf("Invalid buf size on device %d\n", i);
+			goto error;
+		}
+		log[i] = kmsg_get_device(minors[i], "r");
+		if (!log[i]) {
+			printf("Cannot get device %d for read\n", i);
+			goto error;
+		}
+		size = 0;
+		if (kmsg_cmd_get_buf_size(fileno(log[i]), &size)) {
+			printf("Cannot get buf size on defice %d\n", i);
+			goto error;
+		}
+		if (size != KMSG_REQUESTED_BUF_SIZE) {
+			printf("Invalid buf size on device %d\n", i);
+			goto error;
+		}
+
+		for (j = 0; j <= i; j++) {
+			if (kmsg_cmd_clear(fileno(fds[j]))) {
+				printf("Cannot clear buffer on device %d\n", j);
+				goto error;
+			}
+			fprintf(fds[j], "%s\n", message(txt, ARRAY_SIZE(txt),
+									i, j));
+			fflush(fds[j]);
+		}
+
+		for (j = 0; j <= i; j++) {
+			logfd = fileno(log[j]);
+			size = 0;
+			if (kmsg_cmd_get_read_size_max(logfd, &size)) {
+				printf("Cannot get buf size on device %d\n", j);
+				goto error;
+			}
+			if (!size) {
+				printf("Expected non-zero buf size on %d\n", j);
+				goto error;
+			}
+			buff = malloc(size);
+			if (!buff) {
+				printf("Out of memory\n");
+				goto error;
+			}
+			if (read(logfd, buff, size) <= 0) {
+				printf("Could not read from buffer %d\n", j);
+				goto error;
+			}
+			msg = strchr(buff, ';');
+			msgend = strchr(buff, '\n');
+			if ((!msg) || (!msgend)) {
+				printf("Could not read stored log on %d\n", j);
+				goto error;
+			}
+			msg++;
+			*msgend = 0;
+			if (strcmp(msg, message(txt, ARRAY_SIZE(txt), i, j))) {
+				printf("Messages do not match on %d\n", j);
+				goto error;
+			}
+			free(buff);
+			buff = NULL;
+		}
+	}
+
+	goto cleanup;
+
+error:
+	retval = KSFT_FAIL;
+
+cleanup:
+	for (i = 0; i < ARRAY_SIZE(minors); i++) {
+		if (minors[i] < 0)
+			continue;
+		if (fds[i])
+			fclose(fds[i]);
+		if (log[i]) {
+			if (kmsg_cmd_clear(fileno(log[i]))) {
+				printf("Failed to clear device %d\n", i);
+				retval = KSFT_FAIL;
+			}
+			fclose(log[i]);
+		}
+		if (kmsg_drop_device(minors[i])) {
+			printf("Failed to delete device file %d\n", i);
+			retval = KSFT_FAIL;
+		}
+		if (kmsg_cmd_buffer_del(fd, &minors[i])) {
+			printf("Failed to delete buffer %d\n", i);
+			retval = KSFT_FAIL;
+		}
+	}
+	close(fd);
+	if (buff)
+		free(buff);
+	return retval;
+}
diff --git a/tools/testing/selftests/kmsg/test-buffer-buf-multithreaded-torture.c b/tools/testing/selftests/kmsg/test-buffer-buf-multithreaded-torture.c
new file mode 100644
index 0000000..8223a67
--- /dev/null
+++ b/tools/testing/selftests/kmsg/test-buffer-buf-multithreaded-torture.c
@@ -0,0 +1,201 @@
+#include <stddef.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <pthread.h>
+#include <kmsg-api.h>
+
+#include "../kselftest.h"
+
+#include "kmsg-test.h"
+
+#define SOME_BUFF_SIZE (900)
+#define THREADS_PER_DEVICE 10
+
+static bool ok = true;
+static bool nok = !true;
+
+static void *kmsg_test_thread_func(void *data)
+{
+	char buff[SOME_BUFF_SIZE];
+	int minor = *((int *)data);
+	FILE *f = kmsg_get_device(minor, "w");
+	int fd;
+	void *retval = &ok;
+	int iter;
+	ssize_t s;
+	uint32_t size, done;
+	uint32_t max_size;
+
+	memset(buff, 'A', ARRAY_SIZE(buff));
+	buff[ARRAY_SIZE(buff) - 1] = 0;
+
+	if (!f) {
+		printf("Cannot get device for write\n");
+		return &nok;
+	}
+	fd = fileno(f);
+
+	size = 0;
+	if (kmsg_cmd_get_buf_size(fd, &size)) {
+		printf("Cannot get buf size\n");
+		goto error;
+	}
+	if (size != KMSG_REQUESTED_BUF_SIZE) {
+		printf("Invalid buf size\n");
+		goto error;
+	}
+
+	if (kmsg_cmd_clear(fd)) {
+		printf("Cannot clear buffer\n");
+		goto error;
+	}
+
+	iter = 0;
+	while (done < (KMSG_REQUESTED_BUF_SIZE * 2)) {
+		s = write(fd, buff, ARRAY_SIZE(buff));
+		if (s < 0) {
+			printf("Cannot write iteration %d\n", iter);
+			goto error;
+		}
+		done += s;
+
+		max_size = 0;
+		if (kmsg_cmd_get_read_size_max(fd, &max_size)) {
+			printf("Cannot get max_size\n");
+			goto error;
+		}
+		if (!max_size) {
+			printf("Expected non-zero max_size\n");
+			goto error;
+		}
+
+		iter++;
+	}
+
+	goto cleanup;
+
+error:
+	retval = &nok;
+
+cleanup:
+	fclose(f);
+
+	return retval;
+}
+
+int kmsg_test_buffer_buf_multithreaded_torture(
+					const struct kmsg_test_args *args)
+{
+	int i, j;
+	int fd = open(DEV_KMSG, O_RDWR);
+	struct kmsg_cmd_buffer_add cmd = { 0 };
+	int minors[] = { -1, -1, -1, -1 };
+	FILE *log[ARRAY_SIZE(minors)];
+	int retval = KSFT_PASS;
+	pthread_t threads[ARRAY_SIZE(minors)][THREADS_PER_DEVICE];
+	bool started[ARRAY_SIZE(minors)][THREADS_PER_DEVICE];
+	uint32_t size;
+	uint32_t max_size;
+	void *retptr;
+
+	for (i = 0; i < ARRAY_SIZE(minors); i++)
+		for (j = 0; j < THREADS_PER_DEVICE; j++)
+			started[i][j] = false;
+
+	if (fd < 0) {
+		printf("Failed: cannot open %s\n", DEV_KMSG);
+		return KSFT_FAIL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(minors); i++) {
+		log[i] = NULL;
+		cmd.size = KMSG_REQUESTED_BUF_SIZE;
+		cmd.mode = 0662;
+		if (kmsg_cmd_buffer_add(fd, &cmd)) {
+			printf("Failed to add buffer\n");
+			goto error;
+		}
+		if (cmd.minor < 0) {
+			printf("Minor number < 0\n");
+			goto error;
+		}
+		minors[i] = cmd.minor;
+
+		log[i] = kmsg_get_device(minors[i], "r");
+		if (!log[i]) {
+			printf("Cannot get device %d for read\n", i);
+			goto error;
+		}
+		size = 0;
+		if (kmsg_cmd_get_buf_size(fileno(log[i]), &size)) {
+			printf("Cannot get buf size on defice %d\n", i);
+			goto error;
+		}
+		if (size != KMSG_REQUESTED_BUF_SIZE) {
+			printf("Invalid buf size on device %d\n", i);
+			goto error;
+		}
+
+		for (j = 0; j < THREADS_PER_DEVICE; j++) {
+			if (pthread_create(&threads[i][j], NULL,
+					  kmsg_test_thread_func, &minors[i])) {
+				printf("Cannot create thread %d for dev %d\n",
+									j, i);
+				goto error;
+			}
+			started[i][j] = true;
+		}
+	}
+
+	goto cleanup;
+
+error:
+	retval = KSFT_FAIL;
+
+cleanup:
+	for (i = 0; i < ARRAY_SIZE(minors); i++) {
+		for (j = 0; j < THREADS_PER_DEVICE; j++)
+			if (started[i][j]) {
+				if (pthread_join(threads[i][j], &retptr)) {
+					printf("pthread_join() failed %d:%d\n",
+									i, j);
+					retval = KSFT_FAIL;
+				}
+				if (!(*((bool *)retptr)))
+					retval = KSFT_FAIL;
+			}
+		if (minors[i] < 0)
+			continue;
+		if (log[i]) {
+			max_size = 0;
+			if (kmsg_cmd_get_read_size_max(fileno(log[i]),
+								&max_size)) {
+				printf("Cannot get max_size\n");
+				retval = KSFT_FAIL;
+			}
+			if (!max_size) {
+				printf("Expected non-zero max_size\n");
+				retval = KSFT_FAIL;
+			}
+			if (kmsg_cmd_clear(fileno(log[i]))) {
+				printf("Failed to clear device %d\n", i);
+				retval = KSFT_FAIL;
+			}
+			fclose(log[i]);
+		}
+		if (kmsg_drop_device(minors[i])) {
+			printf("Failed to delete device file %d\n", i);
+			retval = KSFT_FAIL;
+		}
+		if (kmsg_cmd_buffer_del(fd, &minors[i])) {
+			printf("Failed to delete buffer %d\n", i);
+			retval = KSFT_FAIL;
+		}
+	}
+	close(fd);
+	return retval;
+}
diff --git a/tools/testing/selftests/kmsg/test-buffer-buf-torture.c b/tools/testing/selftests/kmsg/test-buffer-buf-torture.c
new file mode 100644
index 0000000..829b342
--- /dev/null
+++ b/tools/testing/selftests/kmsg/test-buffer-buf-torture.c
@@ -0,0 +1,141 @@
+#include <stddef.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <kmsg-api.h>
+
+#include "../kselftest.h"
+
+#include "kmsg-test.h"
+
+#define SOME_BUFF_SIZE 4096
+
+int kmsg_test_buffer_buf_torture(const struct kmsg_test_args *args)
+{
+	int i, iter;
+	int fd = open(DEV_KMSG, O_RDWR);
+	struct kmsg_cmd_buffer_add cmd = { 0 };
+	int minors[] = { -1, -1, -1, -1 };
+	FILE *fds[ARRAY_SIZE(minors)];
+	FILE *log[ARRAY_SIZE(minors)];
+	int retval = KSFT_PASS;
+	char buff[SOME_BUFF_SIZE];
+	ssize_t s;
+	int logfd;
+	uint32_t size, done;
+	uint32_t max_size;
+
+	memset(buff, 'A', ARRAY_SIZE(buff));
+	buff[ARRAY_SIZE(buff) - 1] = 0;
+
+	if (fd < 0) {
+		printf("Failed: cannot open %s\n", DEV_KMSG);
+		return KSFT_FAIL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(minors); i++) {
+		fds[i] = NULL;
+		log[i] = NULL;
+		cmd.size = KMSG_REQUESTED_BUF_SIZE;
+		cmd.mode = 0662;
+		if (kmsg_cmd_buffer_add(fd, &cmd)) {
+			printf("Failed to add buffer\n");
+			goto error;
+		}
+		if (cmd.minor < 0) {
+			printf("Minor number < 0\n");
+			goto error;
+		}
+		minors[i] = cmd.minor;
+
+		fds[i] = kmsg_get_device(minors[i], "w");
+		if (!fds[i]) {
+			printf("Cannot get device %d for write\n", i);
+			goto error;
+		}
+		size = 0;
+		if (kmsg_cmd_get_buf_size(fileno(fds[i]), &size)) {
+			printf("Cannot get buf size on defice %d\n", i);
+			goto error;
+		}
+		if (size != KMSG_REQUESTED_BUF_SIZE) {
+			printf("Invalid buf size on device %d\n", i);
+			goto error;
+		}
+		log[i] = kmsg_get_device(minors[i], "r");
+		if (!log[i]) {
+			printf("Cannot get device %d for read\n", i);
+			goto error;
+		}
+		size = 0;
+		if (kmsg_cmd_get_buf_size(fileno(log[i]), &size)) {
+			printf("Cannot get buf size on defice %d\n", i);
+			goto error;
+		}
+		if (size != KMSG_REQUESTED_BUF_SIZE) {
+			printf("Invalid buf size on device %d\n", i);
+			goto error;
+		}
+
+		logfd = fileno(fds[i]);
+		if (kmsg_cmd_clear(logfd)) {
+			printf("Cannot clear buffer on device %d\n", i);
+			goto error;
+		}
+
+		iter = 0;
+		while (done < (KMSG_REQUESTED_BUF_SIZE * 2)) {
+			s = write(logfd, buff, ARRAY_SIZE(buff));
+			if (s < 0) {
+				printf("Cannot write %d to device %d, %s\n",
+						    iter, i, strerror(errno));
+				goto error;
+			}
+			done += s;
+
+			max_size = 0;
+			if (kmsg_cmd_get_read_size_max(logfd, &max_size)) {
+				printf("Cannot get max_size on device %d\n", i);
+				goto error;
+			}
+			if (!max_size) {
+				printf("Expected non-zero max_size on %d\n", i);
+				goto error;
+			}
+
+			iter++;
+		}
+	}
+
+	goto cleanup;
+
+error:
+	retval = KSFT_FAIL;
+
+cleanup:
+	for (i = 0; i < ARRAY_SIZE(minors); i++) {
+		if (minors[i] < 0)
+			continue;
+		if (fds[i])
+			fclose(fds[i]);
+		if (log[i]) {
+			if (kmsg_cmd_clear(fileno(log[i]))) {
+				printf("Failed to clear device %d\n", i);
+				retval = KSFT_FAIL;
+			}
+			fclose(log[i]);
+		}
+		if (kmsg_drop_device(minors[i])) {
+			printf("Failed to delete device file %d\n", i);
+			retval = KSFT_FAIL;
+		}
+		if (kmsg_cmd_buffer_del(fd, &minors[i])) {
+			printf("Failed to delete buffer %d\n", i);
+			retval = KSFT_FAIL;
+		}
+	}
+	close(fd);
+	return retval;
+}
-- 
1.9.1
