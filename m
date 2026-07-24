Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32324399E3;
	Fri, 24 Jul 2026 13:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900510; cv=none; b=V0PqUu8sgrUa8nxonuuN6yTo8b1SuTwMhYkNHYVen2AEww6rwdITp6TnZxs/DDag5tJyi4t2PIAGoWQxaLcpl61W3jWM+THF9cW/n3y16fAF4biz/W730Tv1nwYiQrbCzfFH0HWc/H7oK1mEe6+Jks1Sf7/zx50cdD5LkbPMjho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900510; c=relaxed/simple;
	bh=CITidaIMWahx5lVp0xMydd68/8kaGjS2CH95QkgRuXI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=k1FrahAvzr+ZFZmWSRtVHjgcawEtvKcGfqrmY4Td7XhgcqMF1mDHn/Zey/Y018SYcKYYH83U787BVb6SIjW0qh4MpeljAaJ1Pqb91QKq+v74x6eOCLpyp/92DVCp56lvdjq8Hxtqv2zmU3EoQ/srdtVs0ZNfQitHNJutPPysI6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uq/Jdnmx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uq/Jdnmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8331F00A3D;
	Fri, 24 Jul 2026 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784900508;
	bh=a1fNVH9it3FnhdyCL3L48qk+7z8DhW4kqeSE8dRCUpY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Uq/JdnmxE8MoRFZimPdWupA1cj7o7G/helil3LZSUbWpYRI7Phjo3eU+d6bwIpGmS
	 aX/24f7UUAx8sXEISHRGFkX+eIrV+rat62f/3M4WJsd9s9wxjmHYKmHxDLVDlswF8r
	 zIFT3e+31yNx75A+u51IZ9uIi8Q4rYUYqqEC35stCQ5x9lDCOHCt8pt+W39cGkxVcM
	 hJX6yUcUKZOjkjUkSsw/fkksKK0gjzx7X6dSDO5UMx9W43aynl92VftOEbqvj49sl+
	 QTGX8N98u2GVC55NKAbj3Sug3PINElZSAPgyTvXEpReW71LEhSof6Y63a/STk03h7W
	 tZMgyVbffMVWg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 24 Jul 2026 15:41:22 +0200
Subject: [PATCH v2 6/7] selftests/filesystems: add failfs selftests
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260724-work-failfs-v2-6-485dabbae185@kernel.org>
References: <20260724-work-failfs-v2-0-485dabbae185@kernel.org>
In-Reply-To: <20260724-work-failfs-v2-0-485dabbae185@kernel.org>
To: linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, 
 Jann Horn <jannh@google.com>
Cc: John Ericson <mail@johnericson.me>, linux-api@vger.kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
 linux-doc@vger.kernel.org
X-Mailer: b4 0.16-dev-401aa
X-Developer-Signature: v=1; a=openpgp-sha256; l=20035; i=brauner@kernel.org;
 h=from:subject:message-id; bh=CITidaIMWahx5lVp0xMydd68/8kaGjS2CH95QkgRuXI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlZze7L53zgePpxynHsrp01198kPRQyH92ZY16SEUpc
 /Lns0sYO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYyV5XhN+vWmWnHlma8+vJ+
 0sn1yfker0OczdQYuzZ/kWWM+vedq4mRYanYzXksh+/mh11Qd1zFZlm0acaEp3Z1xzsKf25zyXd
 eyAYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Test the failfs semantics and both new entry points:

- fchdir(FD_FAILFS_ROOT):

  * working directory lookups and getcwd() fail
  * other sentinels are rejected
  * the state is recoverable while the root is untouched

- fchroot() with regular fds:
  * chroot parity
  * CAP_SYS_CHROOT required
  * ENOTDIR/EBADF/EINVAL checks

- fchroot(FD_FAILFS_ROOT):

  * absolute lookups, stat, statfs and opens of the root including O_PATH fail with EOPNOTSUPP
  * dirfd-anchored I/O keeps working
  * ".." walks clamp at the top of the mount tree
  * /proc magic links resolve but can't be stat through
  * absolute symlinks fail while relative symlinks keep resolving

- Unprivileged entry requires no_new_privs and is rejected for
  chrooted callers and for a shared fs_struct

- entering makes the task count as chrooted so user namespace creation
  fails

- Nothing can be mounted on top of failfs and OPEN_TREE_CLONE is
  rejected; the overmount test runs in a private mount namespace so a
  regression cannot touch the host root

- setns() to a kept mount namespace fd restores root and working
  directory

- The failfs root is inherited across fork() and absolute exec fails

- Exec by fd of a dynamically linked binary fails on opening its
  absolute PT_INTERP interpreter

The exec tests run the exec in a child so a wrongly successful exec
cannot replace the test image and masquerade as a pass.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/Makefile                   |   1 +
 .../selftests/filesystems/failfs/.gitignore        |   2 +
 .../testing/selftests/filesystems/failfs/Makefile  |   5 +
 .../selftests/filesystems/failfs/failfs_test.c     | 581 +++++++++++++++++++++
 4 files changed, 589 insertions(+)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 8d4db2241cc2..f87167bcf582 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -33,6 +33,7 @@ TARGETS += fchmodat2
 TARGETS += filesystems
 TARGETS += filesystems/binderfs
 TARGETS += filesystems/epoll
+TARGETS += filesystems/failfs
 TARGETS += filesystems/fat
 TARGETS += filesystems/overlayfs
 TARGETS += filesystems/statmount
diff --git a/tools/testing/selftests/filesystems/failfs/.gitignore b/tools/testing/selftests/filesystems/failfs/.gitignore
new file mode 100644
index 000000000000..cd3b5d884d7e
--- /dev/null
+++ b/tools/testing/selftests/filesystems/failfs/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+failfs_test
diff --git a/tools/testing/selftests/filesystems/failfs/Makefile b/tools/testing/selftests/filesystems/failfs/Makefile
new file mode 100644
index 000000000000..3c5d98b4fe72
--- /dev/null
+++ b/tools/testing/selftests/filesystems/failfs/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+CFLAGS += -Wall -O2 -g $(KHDR_INCLUDES)
+TEST_GEN_PROGS := failfs_test
+
+include ../../lib.mk
diff --git a/tools/testing/selftests/filesystems/failfs/failfs_test.c b/tools/testing/selftests/filesystems/failfs/failfs_test.c
new file mode 100644
index 000000000000..cc461dc483a9
--- /dev/null
+++ b/tools/testing/selftests/filesystems/failfs/failfs_test.c
@@ -0,0 +1,581 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <link.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mount.h>
+#include <sys/prctl.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <sys/vfs.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "../../kselftest_harness.h"
+
+#ifndef __NR_fchroot
+#define __NR_fchroot 472
+#endif
+
+#ifndef FD_PIDFS_ROOT
+#define FD_PIDFS_ROOT -10002
+#endif
+
+#ifndef FD_NSFS_ROOT
+#define FD_NSFS_ROOT -10003
+#endif
+
+#ifndef FD_FAILFS_ROOT
+#define FD_FAILFS_ROOT -10004
+#endif
+
+#define NOBODY_UID 65534
+
+/* Child sentinel exit code: the exec was blocked as expected. */
+#define FAILFS_EXEC_BLOCKED 99
+
+/* Stack for the CLONE_FS helper in fchroot_sentinel_shared_fs_struct. */
+#define FAILFS_CLONE_STACK (64 * 1024)
+
+static int sys_fchroot(int fd, unsigned int flags)
+{
+	return syscall(__NR_fchroot, fd, flags);
+}
+
+/*
+ * Raw syscall: glibc's getcwd() rejects the kernel's "(unreachable)"
+ * result and falls back to a generic implementation.
+ */
+static long sys_getcwd(char *buf, size_t size)
+{
+	return syscall(__NR_getcwd, buf, size);
+}
+
+static int drop_to_nobody(void)
+{
+	return setresuid(NOBODY_UID, NOBODY_UID, NOBODY_UID);
+}
+
+/* Parked CLONE_FS child; dies with its parent so it never leaks. */
+static int failfs_park(void *arg)
+{
+	(void)arg;
+	prctl(PR_SET_PDEATHSIG, SIGKILL);
+	pause();
+	return 0;
+}
+
+/* Is fd a dynamically linked ELF with an absolute PT_INTERP interpreter? */
+static int elf_has_absolute_interp(int fd)
+{
+	ElfW(Ehdr) ehdr;
+	ElfW(Phdr) phdr;
+	char interp;
+	int i;
+
+	if (pread(fd, &ehdr, sizeof(ehdr), 0) != sizeof(ehdr))
+		return 0;
+	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0)
+		return 0;
+
+	for (i = 0; i < ehdr.e_phnum; i++) {
+		if (pread(fd, &phdr, sizeof(phdr),
+			  ehdr.e_phoff + i * sizeof(phdr)) != sizeof(phdr))
+			return 0;
+		if (phdr.p_type != PT_INTERP)
+			continue;
+		if (pread(fd, &interp, 1, phdr.p_offset) != 1)
+			return 0;
+		return interp == '/';
+	}
+
+	return 0;
+}
+
+TEST(fchdir_sentinel)
+{
+	char buf[PATH_MAX];
+	int fd;
+
+	ASSERT_EQ(fchdir(FD_FAILFS_ROOT), 0);
+
+	/* The working directory is unreachable from the process root. */
+	ASSERT_GT(sys_getcwd(buf, sizeof(buf)), 0);
+	ASSERT_EQ(strncmp(buf, "(unreachable)", 13), 0);
+
+	/* Every AT_FDCWD-relative lookup fails. */
+	ASSERT_EQ(openat(AT_FDCWD, "foo", O_RDONLY), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+	ASSERT_EQ(openat(AT_FDCWD, ".", O_RDONLY), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+	ASSERT_EQ(openat(AT_FDCWD, "..", O_RDONLY), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+	ASSERT_EQ(openat(AT_FDCWD, "foo", O_WRONLY | O_CREAT, 0600), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+
+	/* The cwd cannot be pinned by following /proc/self/cwd into it. */
+	ASSERT_EQ(open("/proc/self/cwd", O_PATH), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+
+	/* The root is untouched so absolute lookups keep working... */
+	fd = open("/", O_RDONLY | O_DIRECTORY);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(close(fd), 0);
+
+	/* ... and the working directory can be recovered. */
+	ASSERT_EQ(chdir("/"), 0);
+	ASSERT_GT(sys_getcwd(buf, sizeof(buf)), 0);
+	ASSERT_EQ(strcmp(buf, "/"), 0);
+}
+
+TEST(fchdir_rejects_other_sentinels)
+{
+	ASSERT_EQ(fchdir(FD_PIDFS_ROOT), -1);
+	ASSERT_EQ(errno, EBADF);
+	ASSERT_EQ(fchdir(FD_NSFS_ROOT), -1);
+	ASSERT_EQ(errno, EBADF);
+	ASSERT_EQ(fchdir(-10009), -1);
+	ASSERT_EQ(errno, EBADF);
+}
+
+TEST(fchroot_flags)
+{
+	int fd;
+
+	ASSERT_EQ(sys_fchroot(FD_FAILFS_ROOT, 1), -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	fd = open("/", O_PATH | O_DIRECTORY);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(sys_fchroot(fd, 1), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(fchroot_bad_fd)
+{
+	ASSERT_EQ(sys_fchroot(-1, 0), -1);
+	ASSERT_EQ(errno, EBADF);
+
+	/* Only FD_FAILFS_ROOT is a valid sentinel. */
+	ASSERT_EQ(sys_fchroot(FD_PIDFS_ROOT, 0), -1);
+	ASSERT_EQ(errno, EBADF);
+	ASSERT_EQ(sys_fchroot(FD_NSFS_ROOT, 0), -1);
+	ASSERT_EQ(errno, EBADF);
+}
+
+TEST(fchroot_notdir)
+{
+	int fd;
+
+	fd = open("/proc/self/status", O_RDONLY);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(sys_fchroot(fd, 0), -1);
+	ASSERT_EQ(errno, ENOTDIR);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(fchroot_realfd_requires_cap)
+{
+	int fd;
+
+	if (geteuid() == 0)
+		ASSERT_EQ(drop_to_nobody(), 0);
+
+	fd = open("/", O_PATH | O_DIRECTORY);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(sys_fchroot(fd, 0), -1);
+	ASSERT_EQ(errno, EPERM);
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST(fchroot_realfd)
+{
+	char template[] = "/tmp/failfs_test.XXXXXX";
+	char path[PATH_MAX];
+	struct stat st;
+	int tmpfd, dfd, fd;
+
+	if (geteuid() != 0)
+		SKIP(return, "fchroot() with a regular fd requires CAP_SYS_CHROOT");
+
+	tmpfd = open("/tmp", O_PATH | O_DIRECTORY);
+	ASSERT_GE(tmpfd, 0);
+
+	ASSERT_NE(mkdtemp(template), NULL);
+	snprintf(path, sizeof(path), "%s/canary", template);
+	fd = open(path, O_WRONLY | O_CREAT, 0600);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(close(fd), 0);
+
+	dfd = open(template, O_PATH | O_DIRECTORY);
+	ASSERT_GE(dfd, 0);
+	ASSERT_EQ(sys_fchroot(dfd, 0), 0);
+	ASSERT_EQ(close(dfd), 0);
+
+	ASSERT_EQ(stat("/canary", &st), 0);
+
+	/* Best-effort cleanup: dirfd-anchored I/O works with the new root. */
+	snprintf(path, sizeof(path), "%s/canary", template + strlen("/tmp/"));
+	unlinkat(tmpfd, path, 0);
+	unlinkat(tmpfd, template + strlen("/tmp/"), AT_REMOVEDIR);
+}
+
+TEST(fchroot_sentinel)
+{
+	char template[] = "/tmp/failfs_test.XXXXXX";
+	struct stat realroot, st;
+	struct statfs sfs;
+	char buf[PATH_MAX];
+	int procfd, tmpfd, dfd, fd;
+	struct {
+		struct file_handle handle;
+		unsigned char f_handle[MAX_HANDLE_SZ];
+	} fh;
+	int mntid;
+	ssize_t ret;
+
+	if (geteuid() != 0)
+		SKIP(return, "privileged fchroot(FD_FAILFS_ROOT) requires CAP_SYS_CHROOT");
+
+	ASSERT_EQ(stat("/", &realroot), 0);
+	procfd = open("/proc", O_PATH | O_DIRECTORY);
+	ASSERT_GE(procfd, 0);
+	tmpfd = open("/tmp", O_PATH | O_DIRECTORY);
+	ASSERT_GE(tmpfd, 0);
+	ASSERT_NE(mkdtemp(template), NULL);
+	dfd = open(template, O_RDONLY | O_DIRECTORY);
+	ASSERT_GE(dfd, 0);
+
+	ASSERT_EQ(sys_fchroot(FD_FAILFS_ROOT, 0), 0);
+
+	/* Absolute lookups fail. */
+	ASSERT_EQ(open("/etc/passwd", O_RDONLY), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+	ASSERT_EQ(mkdir("/foo", 0700), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+
+	/*
+	 * The root cannot be referenced at all - not even an O_PATH open,
+	 * which skips ->permission(), because it lands on the root as a
+	 * jumped walk terminal that ->d_weak_revalidate() refuses.
+	 */
+	ASSERT_EQ(open("/", O_RDONLY | O_DIRECTORY), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+	ASSERT_EQ(open("/", O_PATH), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+	ASSERT_EQ(statfs("/", &sfs), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+
+	/*
+	 * It cannot be pinned by following /proc/self/root into it either
+	 * (only the root is in failfs here, so self/cwd is still real).
+	 */
+	ASSERT_EQ(openat(procfd, "self/root", O_PATH), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+
+	/* Nor encoded into a file handle. */
+	fh.handle.handle_bytes = MAX_HANDLE_SZ;
+	ASSERT_EQ(name_to_handle_at(AT_FDCWD, "/", &fh.handle, &mntid, 0), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+
+	/* The working directory is now unreachable from the root. */
+	ASSERT_GT(sys_getcwd(buf, sizeof(buf)), 0);
+	ASSERT_EQ(strncmp(buf, "(unreachable)", 13), 0);
+
+	/* Lookups anchored at real directories keep working. */
+	fd = openat(AT_FDCWD, ".", O_RDONLY | O_DIRECTORY);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(close(fd), 0);
+	fd = openat(dfd, "canary", O_WRONLY | O_CREAT, 0600);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(write(fd, "x", 1), 1);
+	ASSERT_EQ(close(fd), 0);
+	fd = openat(dfd, "canary", O_RDONLY);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(close(fd), 0);
+
+	/* ".." walks clamp at the top of the mount tree, not at failfs. */
+	fd = openat(AT_FDCWD, "../../../../../../../../../..", O_PATH);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(fstat(fd, &st), 0);
+	ASSERT_EQ(st.st_dev, realroot.st_dev);
+	ASSERT_EQ(st.st_ino, realroot.st_ino);
+	ASSERT_EQ(close(fd), 0);
+
+	/* readlink of the magic link still works: it does not follow. */
+	ret = readlinkat(procfd, "self/root", buf, sizeof(buf) - 1);
+	ASSERT_GT(ret, 0);
+	buf[ret] = '\0';
+	TH_LOG("/proc/self/root points to '%s'", buf);
+	/* d_path() names the failfs root synthetically, never as a real path. */
+	ASSERT_EQ(strcmp(buf, "failfs:/"), 0);
+
+	/* But following it into failfs is refused. */
+	ASSERT_EQ(fstatat(procfd, "self/root", &st, 0), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+
+	/* Best-effort cleanup via the pre-opened dirfds. */
+	unlinkat(dfd, "canary", 0);
+	unlinkat(tmpfd, template + strlen("/tmp/"), AT_REMOVEDIR);
+}
+
+TEST(fchroot_sentinel_absolute_symlink)
+{
+	char template[] = "/tmp/failfs_test.XXXXXX";
+	int tmpfd, dfd, fd;
+
+	if (geteuid() != 0)
+		SKIP(return, "privileged fchroot(FD_FAILFS_ROOT) requires CAP_SYS_CHROOT");
+
+	tmpfd = open("/tmp", O_PATH | O_DIRECTORY);
+	ASSERT_GE(tmpfd, 0);
+	ASSERT_NE(mkdtemp(template), NULL);
+	dfd = open(template, O_RDONLY | O_DIRECTORY);
+	ASSERT_GE(dfd, 0);
+
+	fd = openat(dfd, "target", O_WRONLY | O_CREAT, 0600);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(close(fd), 0);
+	ASSERT_EQ(symlinkat("target", dfd, "rel"), 0);
+	ASSERT_EQ(symlinkat("/etc", dfd, "abs"), 0);
+
+	ASSERT_EQ(sys_fchroot(FD_FAILFS_ROOT, 0), 0);
+
+	/* Relative symlinks keep resolving within the dirfd-anchored walk... */
+	fd = openat(dfd, "rel", O_RDONLY);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(close(fd), 0);
+
+	/* ... absolute symlinks restart the walk at the failfs root. */
+	ASSERT_EQ(openat(dfd, "abs", O_RDONLY), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+
+	/* Best-effort cleanup via the pre-opened dirfds. */
+	unlinkat(dfd, "abs", 0);
+	unlinkat(dfd, "rel", 0);
+	unlinkat(dfd, "target", 0);
+	unlinkat(tmpfd, template + strlen("/tmp/"), AT_REMOVEDIR);
+}
+
+TEST(fchroot_sentinel_unprivileged)
+{
+	char buf[PATH_MAX];
+
+	if (geteuid() == 0)
+		ASSERT_EQ(drop_to_nobody(), 0);
+
+	/* Without no_new_privs entering failfs is not allowed... */
+	ASSERT_EQ(sys_fchroot(FD_FAILFS_ROOT, 0), -1);
+	ASSERT_EQ(errno, EPERM);
+
+	/* ... with no_new_privs set it is allowed. */
+	ASSERT_EQ(prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0), 0);
+	ASSERT_EQ(sys_fchroot(FD_FAILFS_ROOT, 0), 0);
+
+	ASSERT_EQ(open("/etc/passwd", O_RDONLY), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+
+	/* The task counts as chrooted: no user namespaces anymore. */
+	ASSERT_EQ(unshare(CLONE_NEWUSER), -1);
+	ASSERT_EQ(errno, EPERM);
+
+	/* With both root and cwd in failfs getcwd() reports "/". */
+	ASSERT_EQ(fchdir(FD_FAILFS_ROOT), 0);
+	ASSERT_GT(sys_getcwd(buf, sizeof(buf)), 0);
+	ASSERT_EQ(strcmp(buf, "/"), 0);
+}
+
+TEST(fchroot_sentinel_rejected_when_chrooted)
+{
+	char template[] = "/tmp/failfs_test.XXXXXX";
+	int tmpfd;
+
+	if (geteuid() != 0)
+		SKIP(return, "chroot() requires CAP_SYS_CHROOT");
+
+	tmpfd = open("/tmp", O_PATH | O_DIRECTORY);
+	ASSERT_GE(tmpfd, 0);
+	ASSERT_NE(mkdtemp(template), NULL);
+	ASSERT_EQ(chroot(template), 0);
+	ASSERT_EQ(chdir("/"), 0);
+
+	/* Remove the jail while still privileged; sticky /tmp blocks nobody. */
+	unlinkat(tmpfd, template + strlen("/tmp/"), AT_REMOVEDIR);
+
+	ASSERT_EQ(drop_to_nobody(), 0);
+	ASSERT_EQ(prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0), 0);
+
+	/* An unprivileged chrooted task must not lift its ".." barrier. */
+	ASSERT_EQ(sys_fchroot(FD_FAILFS_ROOT, 0), -1);
+	ASSERT_EQ(errno, EPERM);
+}
+
+TEST(fchroot_sentinel_shared_fs_struct)
+{
+	char stack[FAILFS_CLONE_STACK];
+	pid_t pid;
+
+	if (geteuid() == 0)
+		ASSERT_EQ(drop_to_nobody(), 0);
+
+	/* A CLONE_FS sibling shares the fs_struct: bump fs->users to 2. */
+	pid = clone(failfs_park, stack + sizeof(stack), CLONE_FS | SIGCHLD,
+		    NULL);
+	ASSERT_GE(pid, 0);
+
+	ASSERT_EQ(prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0), 0);
+
+	/*
+	 * A sibling without no_new_privs could exec a setuid binary with
+	 * the failfs root, so a shared fs_struct is refused even with
+	 * no_new_privs set.
+	 */
+	ASSERT_EQ(sys_fchroot(FD_FAILFS_ROOT, 0), -1);
+	ASSERT_EQ(errno, EINVAL);
+
+	ASSERT_EQ(kill(pid, SIGKILL), 0);
+	ASSERT_EQ(waitpid(pid, NULL, 0), pid);
+}
+
+TEST(fchroot_sentinel_no_overmount)
+{
+	if (geteuid() != 0)
+		SKIP(return, "mounting requires privileges");
+
+	/*
+	 * Contain the blast radius: if failfs ever regressed and "/"
+	 * resolved to the real root, the tmpfs mount below must not touch
+	 * the host. A private mount namespace keeps it local to this child.
+	 */
+	ASSERT_EQ(unshare(CLONE_NEWNS), 0);
+	ASSERT_EQ(mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL), 0);
+
+	ASSERT_EQ(sys_fchroot(FD_FAILFS_ROOT, 0), 0);
+
+	/*
+	 * Nothing can be mounted on top of the failfs root. It cannot even
+	 * be named as a mount target: resolving "/" is refused before the
+	 * mount machinery (which, failfs being in no mount namespace, would
+	 * reject it anyway) is ever reached. open_tree(OPEN_TREE_CLONE) is
+	 * likewise moot since no fd to the root can be obtained.
+	 */
+	ASSERT_EQ(mount("none", "/", "tmpfs", 0, NULL), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+}
+
+TEST(fchroot_sentinel_setns_escape)
+{
+	struct stat realroot, st;
+	int nsfd;
+
+	if (geteuid() != 0)
+		SKIP(return, "setns() to a mount namespace requires privileges");
+
+	ASSERT_EQ(stat("/", &realroot), 0);
+	nsfd = open("/proc/self/ns/mnt", O_RDONLY);
+	ASSERT_GE(nsfd, 0);
+
+	ASSERT_EQ(sys_fchroot(FD_FAILFS_ROOT, 0), 0);
+	ASSERT_EQ(open("/etc", O_PATH), -1);
+	ASSERT_EQ(errno, EOPNOTSUPP);
+
+	/* A mount namespace fd is the key out: it resets root and cwd. */
+	ASSERT_EQ(setns(nsfd, CLONE_NEWNS), 0);
+	ASSERT_EQ(close(nsfd), 0);
+
+	ASSERT_EQ(stat("/", &st), 0);
+	ASSERT_EQ(st.st_dev, realroot.st_dev);
+	ASSERT_EQ(st.st_ino, realroot.st_ino);
+}
+
+TEST(fchroot_sentinel_exec)
+{
+	pid_t pid;
+	int status;
+
+	if (geteuid() != 0)
+		SKIP(return, "privileged fchroot(FD_FAILFS_ROOT) requires CAP_SYS_CHROOT");
+
+	ASSERT_EQ(sys_fchroot(FD_FAILFS_ROOT, 0), 0);
+
+	/*
+	 * Exec in a child: a wrongly successful exec would replace the test
+	 * image and its exit code would not match the sentinel below.
+	 */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		execl("/bin/true", "true", NULL);
+		_exit(errno == EOPNOTSUPP ? FAILFS_EXEC_BLOCKED : 1);
+	}
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), FAILFS_EXEC_BLOCKED);
+}
+
+TEST(fchroot_sentinel_exec_interpreter)
+{
+	static const char * const argv[] = { "failfs_test", NULL };
+	static const char * const envp[] = { NULL };
+	pid_t pid;
+	int status, exefd;
+
+	if (geteuid() != 0)
+		SKIP(return, "privileged fchroot(FD_FAILFS_ROOT) requires CAP_SYS_CHROOT");
+
+	/* Exec ourselves: the one binary guaranteed to be around. */
+	exefd = open("/proc/self/exe", O_RDONLY);
+	ASSERT_GE(exefd, 0);
+	if (!elf_has_absolute_interp(exefd))
+		SKIP(return, "test binary has no absolute PT_INTERP interpreter");
+
+	ASSERT_EQ(sys_fchroot(FD_FAILFS_ROOT, 0), 0);
+
+	/*
+	 * The binary itself needs no path lookup - it is executed by fd -
+	 * but loading it fails on opening the absolute PT_INTERP
+	 * interpreter. Run it in a child so a wrongly successful exec does
+	 * not replace the test image and masquerade as a pass.
+	 */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		syscall(__NR_execveat, exefd, "", argv, envp, AT_EMPTY_PATH);
+		_exit(errno == EOPNOTSUPP ? FAILFS_EXEC_BLOCKED : 1);
+	}
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), FAILFS_EXEC_BLOCKED);
+}
+
+TEST(fchroot_sentinel_inherited)
+{
+	pid_t pid;
+	int status;
+
+	if (geteuid() != 0)
+		SKIP(return, "privileged fchroot(FD_FAILFS_ROOT) requires CAP_SYS_CHROOT");
+
+	ASSERT_EQ(sys_fchroot(FD_FAILFS_ROOT, 0), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		if (open("/etc", O_PATH) != -1 || errno != EOPNOTSUPP)
+			_exit(1);
+		_exit(0);
+	}
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 0);
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0

