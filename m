From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [RFC PATCH v1 4/5] selftest/yama: Add tests for O_MAYEXEC enforcing
Date: Wed, 12 Dec 2018 09:17:11 +0100
Message-ID: <20181212081712.32347-5-mic@digikod.net>
References: <20181212081712.32347-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-14683-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20181212081712.32347-1-mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, =?UTF-8?q?Philippe=20Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Test propagation of noexec mount points or file executability through
files open with or without O_MAYEXEC.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mickaël Salaün <mickael.salaun@ssi.gouv.fr>
Cc: Shuah Khan <shuah@kernel.org>
---
 MAINTAINERS                                  |   1 +
 tools/testing/selftests/Makefile             |   1 +
 tools/testing/selftests/yama/.gitignore      |   1 +
 tools/testing/selftests/yama/Makefile        |  19 ++
 tools/testing/selftests/yama/config          |   2 +
 tools/testing/selftests/yama/test_omayexec.c | 276 +++++++++++++++++++
 6 files changed, 300 insertions(+)
 create mode 100644 tools/testing/selftests/yama/.gitignore
 create mode 100644 tools/testing/selftests/yama/Makefile
 create mode 100644 tools/testing/selftests/yama/config
 create mode 100644 tools/testing/selftests/yama/test_omayexec.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8119141a926f..a1d01a81b283 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16591,6 +16591,7 @@ M:	Kees Cook <keescook@chromium.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git yama/tip
 S:	Supported
 F:	security/yama/
+F:	tools/testing/selftests/yama/
 F:	Documentation/admin-guide/LSM/Yama.rst
 
 YEALINK PHONE DRIVER
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index f0017c831e57..608f31167aa6 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -46,6 +46,7 @@ endif
 TARGETS += user
 TARGETS += vm
 TARGETS += x86
+TARGETS += yama
 TARGETS += zram
 #Please keep the TARGETS list alphabetically sorted
 # Run "make quicktest=1 run_tests" or
diff --git a/tools/testing/selftests/yama/.gitignore b/tools/testing/selftests/yama/.gitignore
new file mode 100644
index 000000000000..6e8d5cfb48d0
--- /dev/null
+++ b/tools/testing/selftests/yama/.gitignore
@@ -0,0 +1 @@
+/test_omayexec
diff --git a/tools/testing/selftests/yama/Makefile b/tools/testing/selftests/yama/Makefile
new file mode 100644
index 000000000000..d411f1615b60
--- /dev/null
+++ b/tools/testing/selftests/yama/Makefile
@@ -0,0 +1,19 @@
+# SPDX-License-Identifier: GPL-2.0
+
+all:
+
+include ../lib.mk
+
+.PHONY: all clean
+
+BINARIES := test_omayexec
+CFLAGS += -Wl,-no-as-needed -Wall -Werror
+LDFLAGS += -lcap
+
+test_omayexec: test_omayexec.c ../kselftest_harness.h
+	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
+
+TEST_PROGS += $(BINARIES)
+EXTRA_CLEAN := $(BINARIES)
+
+all: $(BINARIES)
diff --git a/tools/testing/selftests/yama/config b/tools/testing/selftests/yama/config
new file mode 100644
index 000000000000..9d375bfc465b
--- /dev/null
+++ b/tools/testing/selftests/yama/config
@@ -0,0 +1,2 @@
+CONFIG_SECURITY=y
+CONFIG_SECURITY_YAMA=y
diff --git a/tools/testing/selftests/yama/test_omayexec.c b/tools/testing/selftests/yama/test_omayexec.c
new file mode 100644
index 000000000000..7d41097f0e89
--- /dev/null
+++ b/tools/testing/selftests/yama/test_omayexec.c
@@ -0,0 +1,276 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Yama tests - O_MAYEXEC
+ *
+ * Copyright © 2018 ANSSI
+ *
+ * Author: Mickaël Salaün <mickael.salaun@ssi.gouv.fr>
+ */
+
+#include <errno.h>
+#include <fcntl.h> /* O_CLOEXEC */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h> /* strlen */
+#include <sys/capability.h>
+#include <sys/mount.h>
+#include <sys/stat.h> /* mkdir */
+#include <unistd.h> /* unlink, rmdir */
+
+#include "../kselftest_harness.h"
+
+#ifndef O_MAYEXEC
+#define O_MAYEXEC      040000000
+#endif
+
+#define SYSCTL_MAYEXEC	"/proc/sys/kernel/yama/open_mayexec_enforce"
+
+#define BIN_DIR		"./test-mount"
+#define BIN_PATH	BIN_DIR "/file"
+#define DIR_PATH	BIN_DIR "/directory"
+
+#define ALLOWED		1
+#define DENIED		0
+
+static void test_omx(struct __test_metadata *_metadata,
+		const char *const path, const int exec_allowed)
+{
+	int fd;
+
+	/* without O_MAYEXEC */
+	fd = open(path, O_RDONLY | O_CLOEXEC);
+	ASSERT_NE(-1, fd);
+	EXPECT_FALSE(close(fd));
+
+	/* with O_MAYEXEC */
+	fd = open(path, O_RDONLY | O_CLOEXEC | O_MAYEXEC);
+	if (exec_allowed) {
+		/* open should succeed */
+		ASSERT_NE(-1, fd);
+		EXPECT_FALSE(close(fd));
+	} else {
+		/* open should return EACCES */
+		ASSERT_EQ(-1, fd);
+		ASSERT_EQ(EACCES, errno);
+	}
+}
+
+static void ignore_dac(struct __test_metadata *_metadata, int override)
+{
+	cap_t caps;
+	const cap_value_t cap_val[2] = {
+		CAP_DAC_OVERRIDE,
+		CAP_DAC_READ_SEARCH,
+	};
+
+	caps = cap_get_proc();
+	ASSERT_TRUE(!!caps);
+	ASSERT_FALSE(cap_set_flag(caps, CAP_EFFECTIVE, 2, cap_val,
+				override ? CAP_SET : CAP_CLEAR));
+	ASSERT_FALSE(cap_set_proc(caps));
+	EXPECT_FALSE(cap_free(caps));
+}
+
+static void test_dir_file(struct __test_metadata *_metadata,
+		const char *const dir_path, const char *const file_path,
+		const int exec_allowed, const int only_file_perm)
+{
+	if (only_file_perm) {
+		/* test as root */
+		ignore_dac(_metadata, 1);
+		/* always allowed because of generic_permission() use */
+		test_omx(_metadata, dir_path, ALLOWED);
+	}
+
+	/* without bypass */
+	ignore_dac(_metadata, 0);
+	test_omx(_metadata, dir_path, exec_allowed);
+	test_omx(_metadata, file_path, exec_allowed);
+}
+
+static void sysctl_write(struct __test_metadata *_metadata,
+		const char *path, const char *value)
+{
+	int fd;
+	size_t len_value;
+	ssize_t len_wrote;
+
+	fd = open(path, O_WRONLY | O_CLOEXEC);
+	ASSERT_NE(-1, fd);
+	len_value = strlen(value);
+	len_wrote = write(fd, value, len_value);
+	ASSERT_EQ(len_wrote, len_value);
+	EXPECT_FALSE(close(fd));
+}
+
+static void create_workspace(struct __test_metadata *_metadata,
+		int mount_exec, int file_exec)
+{
+	int fd;
+
+	/*
+	 * Cleanup previous workspace if any error previously happened (don't
+	 * check errors).
+	 */
+	umount(BIN_DIR);
+	rmdir(BIN_DIR);
+
+	/* create a clean mount point */
+	ASSERT_FALSE(mkdir(BIN_DIR, 00700));
+	ASSERT_FALSE(mount("test", BIN_DIR, "tmpfs",
+				MS_MGC_VAL | (mount_exec ? 0 : MS_NOEXEC),
+				"mode=0700,size=4k"));
+
+	/* create a test file */
+	fd = open(BIN_PATH, O_CREAT | O_RDONLY | O_CLOEXEC,
+			file_exec ? 00500 : 00400);
+	ASSERT_NE(-1, fd);
+	EXPECT_NE(-1, close(fd));
+
+	/* create a test directory */
+	ASSERT_FALSE(mkdir(DIR_PATH, file_exec ? 00500 : 00400));
+}
+
+static void delete_workspace(struct __test_metadata *_metadata)
+{
+	ignore_dac(_metadata, 1);
+	sysctl_write(_metadata, SYSCTL_MAYEXEC, "0");
+
+	/* no need to unlink BIN_PATH nor DIR_PATH */
+	ASSERT_FALSE(umount(BIN_DIR));
+	ASSERT_FALSE(rmdir(BIN_DIR));
+}
+
+FIXTURE_DATA(mount_exec_file_exec) { };
+
+FIXTURE_SETUP(mount_exec_file_exec)
+{
+	create_workspace(_metadata, 1, 1);
+}
+
+FIXTURE_TEARDOWN(mount_exec_file_exec)
+{
+	delete_workspace(_metadata);
+}
+
+TEST_F(mount_exec_file_exec, mount)
+{
+	/* enforce mount exec check */
+	sysctl_write(_metadata, SYSCTL_MAYEXEC, "1");
+	test_dir_file(_metadata, DIR_PATH, BIN_PATH, ALLOWED, 0);
+}
+
+TEST_F(mount_exec_file_exec, file)
+{
+	/* enforce file exec check */
+	sysctl_write(_metadata, SYSCTL_MAYEXEC, "2");
+	test_dir_file(_metadata, DIR_PATH, BIN_PATH, ALLOWED, 0);
+}
+
+TEST_F(mount_exec_file_exec, mount_file)
+{
+	/* enforce mount and file exec check */
+	sysctl_write(_metadata, SYSCTL_MAYEXEC, "3");
+	test_dir_file(_metadata, DIR_PATH, BIN_PATH, ALLOWED, 0);
+}
+
+FIXTURE_DATA(mount_exec_file_noexec) { };
+
+FIXTURE_SETUP(mount_exec_file_noexec)
+{
+	create_workspace(_metadata, 1, 0);
+}
+
+FIXTURE_TEARDOWN(mount_exec_file_noexec)
+{
+	delete_workspace(_metadata);
+}
+
+TEST_F(mount_exec_file_noexec, mount)
+{
+	/* enforce mount exec check */
+	sysctl_write(_metadata, SYSCTL_MAYEXEC, "1");
+	test_dir_file(_metadata, DIR_PATH, BIN_PATH, ALLOWED, 0);
+}
+
+TEST_F(mount_exec_file_noexec, file)
+{
+	/* enforce file exec check */
+	sysctl_write(_metadata, SYSCTL_MAYEXEC, "2");
+	test_dir_file(_metadata, DIR_PATH, BIN_PATH, DENIED, 1);
+}
+
+TEST_F(mount_exec_file_noexec, mount_file)
+{
+	/* enforce mount and file exec check */
+	sysctl_write(_metadata, SYSCTL_MAYEXEC, "3");
+	test_dir_file(_metadata, DIR_PATH, BIN_PATH, DENIED, 1);
+}
+
+FIXTURE_DATA(mount_noexec_file_exec) { };
+
+FIXTURE_SETUP(mount_noexec_file_exec)
+{
+	create_workspace(_metadata, 0, 1);
+}
+
+FIXTURE_TEARDOWN(mount_noexec_file_exec)
+{
+	delete_workspace(_metadata);
+}
+
+TEST_F(mount_noexec_file_exec, mount)
+{
+	/* enforce mount exec check */
+	sysctl_write(_metadata, SYSCTL_MAYEXEC, "1");
+	test_dir_file(_metadata, DIR_PATH, BIN_PATH, DENIED, 0);
+}
+
+TEST_F(mount_noexec_file_exec, file)
+{
+	/* enforce file exec check */
+	sysctl_write(_metadata, SYSCTL_MAYEXEC, "2");
+	test_dir_file(_metadata, DIR_PATH, BIN_PATH, ALLOWED, 0);
+}
+
+TEST_F(mount_noexec_file_exec, mount_file)
+{
+	/* enforce mount and file exec check */
+	sysctl_write(_metadata, SYSCTL_MAYEXEC, "3");
+	test_dir_file(_metadata, DIR_PATH, BIN_PATH, DENIED, 0);
+}
+
+FIXTURE_DATA(mount_noexec_file_noexec) { };
+
+FIXTURE_SETUP(mount_noexec_file_noexec)
+{
+	create_workspace(_metadata, 0, 0);
+}
+
+FIXTURE_TEARDOWN(mount_noexec_file_noexec)
+{
+	delete_workspace(_metadata);
+}
+
+TEST_F(mount_noexec_file_noexec, mount)
+{
+	/* enforce mount exec check */
+	sysctl_write(_metadata, SYSCTL_MAYEXEC, "1");
+	test_dir_file(_metadata, DIR_PATH, BIN_PATH, DENIED, 0);
+}
+
+TEST_F(mount_noexec_file_noexec, file)
+{
+	/* enforce file exec check */
+	sysctl_write(_metadata, SYSCTL_MAYEXEC, "2");
+	test_dir_file(_metadata, DIR_PATH, BIN_PATH, DENIED, 1);
+}
+
+TEST_F(mount_noexec_file_noexec, mount_file)
+{
+	/* enforce mount and file exec check */
+	sysctl_write(_metadata, SYSCTL_MAYEXEC, "3");
+	test_dir_file(_metadata, DIR_PATH, BIN_PATH, DENIED, 0);
+}
+
+TEST_HARNESS_MAIN
-- 
2.20.0.rc2
