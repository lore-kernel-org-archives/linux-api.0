Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A092147206E
	for <linux-api@vger.kernel.org>; Fri, 16 Oct 2026 14:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161463; cv=none; b=BC+igkgDS8oNEhxq1G1g4T211MfbH0fgBBmqM9TOD3wm3aiXtpzDH6YQiOj4BINcPd7O4KwwbNlROEjj8dr8CJEHk3ImzvZ6ZrAVbM/8et0quunrYhvSgxg5ZX1oaVxg6aBNDG0nA+tS+tHbPPKXD9B78W7QOaBwwTL3S1WWFA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161463; c=relaxed/simple;
	bh=lmfFMn5de2KCLlPrZP7BXR7qsrpeQFr9Uh/jHhGQ7v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqXmfMhZWXDXVD0rvz6T38E11FqDqzrbUUQn/o/ayjmPBrJacQiO0rApfFWaEedkKMZ3hI6tI2O2/ZAQ7YA+MshTaxtNZYaAys8sYKKMS+tFIjPNuf3DQudPtI+zze7hByz7UknpSZeOW4yGoqTq/psaTdn4dW9qFCuqxacWhf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=faxDXe2k; arc=none smtp.client-ip=195.121.94.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="faxDXe2k"
X-KPN-MessageId: 1ffe74b9-c96f-11f1-9e93-005056999439
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 1ffe74b9-c96f-11f1-9e93-005056999439;
	Fri, 16 Oct 2026 16:37:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=aw5ZkgvRWmR3rgCKWzWni5WXiqE4Fso1FvzyiuNbdAY=;
	b=faxDXe2k/xY8A6CNkKFm+ETCYBPYRy32JQQzJUtwqf50QFiQFRa/TpTR9OHP2i5eMpi8NRFebst72
	 ozh/0v7i2bBomAtmExda3GznAGIgsrMoggFM6lZZP0J6viqLfXkzhcdETxZP7s16pS8sCEVQMJpBs6
	 SUg7mwWX2+qIJ4rfJ4zmNqupbg0BnU2nRB767zc3ZXqp+t/+vi4FJgZE8gv8VegMVzjDVaekOMY/pn
	 dIpTOKYcg8JaQOJM2BeKZZPTHh8av6iEunp1liTGP9LcJAN0OXbwCZzoFOK1WvqhSLZM1JK/elPRTx
	 WrOlbnsZxZKc+i2B805qq5rRBnZhmcg==
X-KPN-MID: 33|xlv5iEb5glfuUkRxv+lmY9sPpBuw9AF7t46N9kKemedtjw2rx++7BQ/JuZH+DFX
 h3+sKTx/ox/MVew6pPFm1PNuih8kacqBR+LsQujUiPyc=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|uqZQask+wRj4xByH0/GajlahHIl69VsqaNiAxK5wFNk2+U18f5l0Iwbb30vnQIw
 cczvD5vD/oUdyL/22kl/l9Q==
Received: from daedalus.home (unknown [178.228.137.172])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 1fb75f97-c96f-11f1-a202-00505699b758;
	Fri, 16 Oct 2026 16:37:33 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Amir Goldstein <amir73il@gmail.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Jori Koolstra <jkoolstra@xs4all.nl>
Subject: [PATCH v7 12/12] selftest: add tests for open*(O_CREAT|O_DIRECTORY)
Date: Fri, 16 Oct 2026 16:38:06 +0200
Message-ID: <20261016143806.2946578-13-jkoolstra@xs4all.nl>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261016143806.2946578-1-jkoolstra@xs4all.nl>
References: <20261016143806.2946578-1-jkoolstra@xs4all.nl>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some tests for the new valid O_CREAT|O_DIRECTORY flag combination for
open*(2) to test compliance and to showcase its behaviour.

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 .../testing/selftests/filesystems/.gitignore  |   1 +
 tools/testing/selftests/filesystems/Makefile  |   2 +-
 .../filesystems/open_o_creat_o_dir.c          | 346 ++++++++++++++++++
 .../testing/selftests/filesystems/wrappers.h  |  11 +
 4 files changed, 359 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/filesystems/open_o_creat_o_dir.c

diff --git a/tools/testing/selftests/filesystems/.gitignore b/tools/testing/selftests/filesystems/.gitignore
index 62f7b1c46649..e0ae02a5d2d1 100644
--- a/tools/testing/selftests/filesystems/.gitignore
+++ b/tools/testing/selftests/filesystems/.gitignore
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+open_o_creat_o_dir
 dnotify_test
 devpts_pts
 fclog
diff --git a/tools/testing/selftests/filesystems/Makefile b/tools/testing/selftests/filesystems/Makefile
index 93e2cc9123b0..a8b48cb6afd6 100644
--- a/tools/testing/selftests/filesystems/Makefile
+++ b/tools/testing/selftests/filesystems/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 CFLAGS += $(KHDR_INCLUDES)
-TEST_GEN_PROGS := devpts_pts file_stressor anon_inode_test kernfs_test fclog ustat_test rw_hint_test
+TEST_GEN_PROGS := open_o_creat_o_dir devpts_pts file_stressor anon_inode_test kernfs_test fclog ustat_test rw_hint_test
 TEST_GEN_PROGS += idmapped_tmpfile
 TEST_GEN_PROGS_EXTENDED := dnotify_test
 
diff --git a/tools/testing/selftests/filesystems/open_o_creat_o_dir.c b/tools/testing/selftests/filesystems/open_o_creat_o_dir.c
new file mode 100644
index 000000000000..93c0f4dea266
--- /dev/null
+++ b/tools/testing/selftests/filesystems/open_o_creat_o_dir.c
@@ -0,0 +1,346 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <sys/stat.h>
+#include <sys/vfs.h>
+#include <errno.h>
+#include <limits.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <linux/magic.h>
+
+#include "kselftest_harness.h"
+#include "wrappers.h"
+
+#define openat_o_mkdir_checked_flags(dfd, pathname, flags) ({	\
+	struct stat __st;						\
+	int __fd = openat_o_mkdir(dfd, pathname, flags, S_IRWXU);	\
+	ASSERT_GE(__fd, 0);						\
+	ASSERT_EQ(fstat(__fd, &__st), 0);				\
+	EXPECT_TRUE(S_ISDIR(__st.st_mode));				\
+	__fd;								\
+})
+
+#define openat_o_mkdir_checked(dfd, pathname) \
+	openat_o_mkdir_checked_flags(dfd, pathname, O_RDONLY)
+
+FIXTURE(open_o_creat_o_dir) {
+	char dirpath[PATH_MAX];
+	int dfd;
+};
+
+FIXTURE_SETUP(open_o_creat_o_dir)
+{
+	strcpy(self->dirpath, "/tmp/open_o_creat_o_dir_test.XXXXXX");
+	ASSERT_NE(mkdtemp(self->dirpath), NULL);
+	self->dfd = open(self->dirpath, O_DIRECTORY);
+	ASSERT_GE(self->dfd, 0);
+}
+
+FIXTURE_TEARDOWN(open_o_creat_o_dir)
+{
+	close(self->dfd);
+	rmdir(self->dirpath);
+}
+
+/* Does open_o_creat_o_dir return a fd at all? */
+TEST_F(open_o_creat_o_dir, returns_fd)
+{
+	int fd = openat_o_mkdir_checked(self->dfd, "newdir");
+	EXPECT_EQ(close(fd), 0);
+	EXPECT_EQ(unlinkat(self->dfd, "newdir", AT_REMOVEDIR), 0);
+}
+
+/* The fd must refer to the directory that was just created. */
+TEST_F(open_o_creat_o_dir, fd_is_created_dir)
+{
+	int fd;
+	struct stat st_via_fd, st_via_path;
+	char path[PATH_MAX];
+
+	fd = openat_o_mkdir_checked(self->dfd, "checkdir");
+
+	ASSERT_EQ(fstat(fd, &st_via_fd), 0);
+
+	snprintf(path, sizeof(path), "%s/checkdir", self->dirpath);
+	ASSERT_EQ(stat(path, &st_via_path), 0);
+
+	EXPECT_EQ(st_via_fd.st_ino, st_via_path.st_ino);
+	EXPECT_EQ(st_via_fd.st_dev, st_via_path.st_dev);
+
+	EXPECT_EQ(close(fd), 0);
+	EXPECT_EQ(rmdir(path), 0);
+}
+
+/* Missing parent component must fail with ENOENT. */
+TEST_F(open_o_creat_o_dir, enoent_missing_parent)
+{
+	EXPECT_EQ(openat_o_mkdir(self->dfd, "nonexistent/child", O_RDONLY, S_IRWXU), -1);
+	EXPECT_EQ(errno, ENOENT);
+}
+
+/* An invalid dfd must fail with EBADF. */
+TEST_F(open_o_creat_o_dir, ebadf)
+{
+	EXPECT_EQ(openat_o_mkdir(FD_INVALID, "badfdir", O_RDONLY, S_IRWXU), -1);
+	EXPECT_EQ(errno, EBADF);
+}
+
+/* A dfd that points to a file (not a directory) must fail with ENOTDIR. */
+TEST_F(open_o_creat_o_dir, enotdir_dfd)
+{
+	int file_fd;
+
+	file_fd = openat(self->dfd, "file",
+			 O_CREAT | O_RDONLY, S_IRWXU);
+	ASSERT_GE(file_fd, 0);
+
+	EXPECT_EQ(openat_o_mkdir(file_fd, "subdir", O_RDONLY, S_IRWXU), -1);
+	EXPECT_EQ(errno, ENOTDIR);
+
+	EXPECT_EQ(close(file_fd), 0);
+	EXPECT_EQ(unlinkat(self->dfd, "file", 0), 0);
+}
+
+/*
+ * O_CREAT|O_DIRECTORY without O_EXCL must fail with EINVAL and must not
+ * create anything at the path.
+ */
+TEST_F(open_o_creat_o_dir, requires_o_excl)
+{
+	struct stat st;
+
+	EXPECT_EQ(openat(self->dfd, "noexcl", O_CREAT | O_DIRECTORY | O_RDONLY,
+			 S_IRWXU), -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	EXPECT_EQ(fstatat(self->dfd, "noexcl", &st, 0), -1);
+	EXPECT_EQ(errno, ENOENT);
+}
+
+/*
+ * Once the directory exists, repeating O_CREAT|O_DIRECTORY|O_EXCL must
+ * fail with EEXIST.
+ */
+TEST_F(open_o_creat_o_dir, existing_dir_eexist)
+{
+	int excldir_fd;
+
+	excldir_fd = openat_o_mkdir_checked(self->dfd, "excldir");
+
+	EXPECT_EQ(openat_o_mkdir(self->dfd, "excldir", O_RDONLY, S_IRWXU), -1);
+	EXPECT_EQ(errno, EEXIST);
+
+	EXPECT_EQ(close(excldir_fd), 0);
+	EXPECT_EQ(unlinkat(self->dfd, "excldir", AT_REMOVEDIR), 0);
+}
+
+/*
+ * O_CREAT|O_DIRECTORY combined with a writable access mode must be
+ * rejected: a directory cannot be opened for writing.
+ */
+TEST_F(open_o_creat_o_dir, rejects_writable_acc_mode)
+{
+	EXPECT_EQ(openat_o_mkdir(self->dfd, "rdwrdir", O_RDWR, S_IRWXU), -1);
+	EXPECT_EQ(errno, ENOTDIR);
+}
+
+/*
+ * openat(O_CREAT|O_DIRECTORY) with a trailing slash should work.
+ */
+TEST_F(open_o_creat_o_dir, trailing_slash)
+{
+	int fd = openat_o_mkdir_checked(self->dfd, "newdir/");
+	EXPECT_EQ(close(fd), 0);
+	EXPECT_EQ(unlinkat(self->dfd, "newdir", AT_REMOVEDIR), 0);
+}
+
+/*
+ * openat(O_CREAT) with a trailing slash but without O_DIRECTORY
+ * must fail with EISDIR and must not create anything at the path.
+ */
+TEST_F(open_o_creat_o_dir, trailing_slash_no_o_dir)
+{
+	int fd;
+	struct stat st;
+
+	fd = openat(self->dfd, "trailing/", O_CREAT | O_RDONLY, S_IRWXU);
+	EXPECT_EQ(fd, -1);
+	EXPECT_EQ(errno, EISDIR);
+
+	EXPECT_EQ(fstatat(self->dfd, "trailing", &st, 0), -1);
+	EXPECT_EQ(errno, ENOENT);
+}
+
+/*
+ * The returned fd must be usable as a dfd for further *at() calls.
+ */
+TEST_F(open_o_creat_o_dir, fd_usable_as_dfd)
+{
+	int parent_fd, child_fd;
+	char path[PATH_MAX];
+
+	parent_fd = openat_o_mkdir_checked(self->dfd, "parent");
+	child_fd = openat_o_mkdir_checked(parent_fd, "child");
+
+	EXPECT_EQ(close(child_fd), 0);
+	EXPECT_EQ(close(parent_fd), 0);
+
+	snprintf(path, sizeof(path), "%s/parent/child", self->dirpath);
+	EXPECT_EQ(rmdir(path), 0);
+	snprintf(path, sizeof(path), "%s/parent", self->dirpath);
+	EXPECT_EQ(rmdir(path), 0);
+}
+
+/*
+ * O_EXCL means a trailing symlink is never followed, so O_CREAT|O_DIRECTORY
+ * must refuse to create through a dangling one, and must not create
+ * anything at the symlink target.
+ */
+TEST_F(open_o_creat_o_dir, dangling_symlink_eexist)
+{
+	struct stat st;
+
+	ASSERT_EQ(symlinkat("danglink_target", self->dfd, "danglink"), 0);
+
+	EXPECT_EQ(openat_o_mkdir(self->dfd, "danglink", O_RDONLY, S_IRWXU), -1);
+	EXPECT_EQ(errno, EEXIST);
+
+	/* Nothing must have been created at the target. */
+	EXPECT_EQ(fstatat(self->dfd, "danglink_target", &st, 0), -1);
+	EXPECT_EQ(errno, ENOENT);
+
+	EXPECT_EQ(unlinkat(self->dfd, "danglink", 0), 0);
+}
+
+/*
+ * A trailing symlink is an existing entry, even if it resolves to a
+ * directory, so O_CREAT|O_DIRECTORY must fail with EEXIST.
+ */
+TEST_F(open_o_creat_o_dir, symlink_to_dir_eexist)
+{
+	ASSERT_EQ(mkdirat(self->dfd, "realdir", 0700), 0);
+	ASSERT_EQ(symlinkat("realdir", self->dfd, "dirlink"), 0);
+
+	EXPECT_EQ(openat_o_mkdir(self->dfd, "dirlink", O_RDONLY, S_IRWXU), -1);
+	EXPECT_EQ(errno, EEXIST);
+
+	EXPECT_EQ(unlinkat(self->dfd, "dirlink", 0), 0);
+	EXPECT_EQ(unlinkat(self->dfd, "realdir", AT_REMOVEDIR), 0);
+}
+
+/*
+ * O_TMPFILE is encoded as __O_TMPFILE|O_DIRECTORY.  Now that O_CREAT is no
+ * longer rejected alongside O_DIRECTORY, O_TMPFILE|O_CREAT must still be
+ * rejected explicitly so that it cannot create a persistent file on kernels
+ * that predate O_TMPFILE.
+ */
+TEST_F(open_o_creat_o_dir, tmpfile_with_o_creat_einval)
+{
+	EXPECT_EQ(openat(self->dfd, ".", O_TMPFILE | O_CREAT | O_RDWR, S_IRWXU),
+		  -1);
+	EXPECT_EQ(errno, EINVAL);
+}
+
+/*
+ * Open the first of @paths that is a mounted filesystem of type @magic.
+ * Returns -1 if there is none.
+ */
+static int open_fs_root(const char *const *paths, long magic)
+{
+	for (; *paths; paths++) {
+		struct statfs sfs;
+		int fd;
+
+		fd = open(*paths, O_DIRECTORY | O_RDONLY);
+		if (fd < 0)
+			continue;
+		if (!fstatfs(fd, &sfs) && sfs.f_type == magic)
+			return fd;
+		close(fd);
+	}
+	return -1;
+}
+
+/*
+ * kernfs: O_CREAT|O_DIRECTORY on cgroup2 must create a cgroup and return a
+ * fd to that very cgroup.
+ */
+TEST(kernfs_cgroup2)
+{
+	static const char *const paths[] = {
+		"/sys/fs/cgroup", "/sys/fs/cgroup/unified", NULL
+	};
+	struct stat st_fd, st_path;
+	int root_fd, fd, procs_fd;
+	char name[64];
+
+	if (geteuid() != 0)
+		SKIP(return, "needs root to create a cgroup");
+	root_fd = open_fs_root(paths, CGROUP2_SUPER_MAGIC);
+	if (root_fd < 0)
+		SKIP(return, "cgroup2 is not mounted");
+
+	snprintf(name, sizeof(name), "open_o_creat_o_dir.%d", getpid());
+
+	fd = openat_o_mkdir_checked(root_fd, name);
+
+	/* The fd refers to the cgroup that is now visible at the name. */
+	ASSERT_EQ(fstat(fd, &st_fd), 0);
+	ASSERT_EQ(fstatat(root_fd, name, &st_path, 0), 0);
+	EXPECT_EQ(st_fd.st_ino, st_path.st_ino);
+	EXPECT_EQ(st_fd.st_dev, st_path.st_dev);
+
+	/* It is a populated cgroup, not just an empty directory. */
+	procs_fd = openat(fd, "cgroup.procs", O_RDONLY);
+	EXPECT_GE(procs_fd, 0);
+	if (procs_fd >= 0)
+		EXPECT_EQ(close(procs_fd), 0);
+
+	EXPECT_EQ(close(fd), 0);
+	EXPECT_EQ(unlinkat(root_fd, name, AT_REMOVEDIR), 0);
+	EXPECT_EQ(close(root_fd), 0);
+}
+
+/*
+ * tracefs sets SB_I_NO_ATOMIC_MKDIR: O_CREAT|O_DIRECTORY is refused with
+ * EOPNOTSUPP before any lookup, whether or not the name exists, and
+ * creates nothing.
+ */
+TEST(tracefs_eopnotsupp)
+{
+	static const char *const paths[] = {
+		"/sys/kernel/tracing", "/sys/kernel/debug/tracing", NULL
+	};
+	int tracing_fd, inst_fd;
+	char name[64];
+	struct stat st;
+
+	if (geteuid() != 0)
+		SKIP(return, "needs root to access tracefs");
+	tracing_fd = open_fs_root(paths, TRACEFS_MAGIC);
+	if (tracing_fd < 0)
+		SKIP(return, "tracefs is not mounted");
+	inst_fd = openat(tracing_fd, "instances", O_DIRECTORY | O_RDONLY);
+	if (inst_fd < 0) {
+		close(tracing_fd);
+		SKIP(return, "no tracefs instances directory");
+	}
+
+	snprintf(name, sizeof(name), "open_o_creat_o_dir.%d", getpid());
+
+	/* Nonexistent name, where mkdir(2) would create an instance */
+	EXPECT_EQ(openat_o_mkdir(inst_fd, name, O_RDONLY, S_IRWXU), -1);
+	EXPECT_EQ(errno, EOPNOTSUPP);
+	EXPECT_EQ(fstatat(inst_fd, name, &st, 0), -1);
+	EXPECT_EQ(errno, ENOENT);
+
+	/* Existing name */
+	EXPECT_EQ(openat_o_mkdir(tracing_fd, "instances", O_RDONLY, S_IRWXU), -1);
+	EXPECT_EQ(errno, EOPNOTSUPP);
+
+	EXPECT_EQ(close(inst_fd), 0);
+	EXPECT_EQ(close(tracing_fd), 0);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/filesystems/wrappers.h b/tools/testing/selftests/filesystems/wrappers.h
index 420ae4f908cf..bc58bdb80063 100644
--- a/tools/testing/selftests/filesystems/wrappers.h
+++ b/tools/testing/selftests/filesystems/wrappers.h
@@ -13,6 +13,10 @@
 #define STATX_MNT_ID_UNIQUE 0x00004000U /* Want/got extended stx_mount_id */
 #endif
 
+#ifndef FD_INVALID
+#define FD_INVALID -10009
+#endif
+
 static inline int sys_fsopen(const char *fsname, unsigned int flags)
 {
 	return syscall(__NR_fsopen, fsname, flags);
@@ -105,4 +109,11 @@ static inline int sys_open_tree(int dfd, const char *filename, unsigned int flag
 	return syscall(__NR_open_tree, dfd, filename, flags);
 }
 
+static inline int openat_o_mkdir(int dfd, const char *pathname,
+				 unsigned int flags, mode_t mode)
+{
+	return syscall(__NR_openat, dfd, pathname,
+		       flags | O_DIRECTORY | O_CREAT | O_EXCL, mode);
+}
+
 #endif
-- 
2.56.0

