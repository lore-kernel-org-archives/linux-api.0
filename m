Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C50433E73;
	Fri, 24 Jul 2026 13:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900495; cv=none; b=LrcN3BpUwwjtIyG/3FrpUtrtaQXhRzZAam61T5CwIBXPMhc6UdlneIlpZX83S6SxEY7GmPUdzUO1Y/fIqohF40ZLBJYR6gvc+bcEBSv+SWLKJ5tskunFuac6Fv4CE/pcDLolf3WS/LYr1MNmj+K/FKkYa6Rw64Ag/dhUQC1rrzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900495; c=relaxed/simple;
	bh=YmIJxhHp0eHNnAJj2/En2zWodvQxj7v0+QFVA/CVZrA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aM1qdIodAd7IDWuoU/lGqUQ9/xO2STuvOtkNx1lowwHuI/tFAfwoLMAAcZrdrfJjlLK7azSYdlRqj6UancPsj8JUexo2s24UnICLkAdOqjboaETpMvJ9E980ngjnFa9HvnZ4jlB9G2xON4a4c0iI5OX5T37Laflg44XcN/iQm0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bUc90F67; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bUc90F67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193031F000E9;
	Fri, 24 Jul 2026 13:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784900494;
	bh=2HSNBPyH8jhy8LlAl6XW15FyikFGFtQMPGouVz7ybkg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bUc90F67OF6EtwJlcBN3CrrFbmvCORcvIV6cPmls7vACl6xS3ryT1JfuVRDBEGkjw
	 zU/IMgbNq0VfbZzWPEQfUrOvATN7MS/H7P3oZ2UI1i29V3jBvSDNNLufGqtNb0VnbL
	 Uf2fqYPJPfzMSD7T53GbdsLUWMU9cjzjN0T3hKP2NfivXzJsK0ssBUWA05t9EuwWYB
	 i7yXc4JhN91pQ7YhfIzE3p5p4Cy6Al7q3Xc+Izz9qgu2Y+RkWwx0DdOspliaaTcVGx
	 kdLNFK3R77i7rEv8D6lCMLF+pEO94Rzie5CrLOZ4wwKEbp5a3ZgI1Am0dQ6BFIY4Ka
	 ocPvNjQJ3vaeg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 24 Jul 2026 15:41:18 +0200
Subject: [PATCH v2 2/7] fs: support FD_FAILFS_ROOT in fchdir()
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260724-work-failfs-v2-2-485dabbae185@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3237; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YmIJxhHp0eHNnAJj2/En2zWodvQxj7v0+QFVA/CVZrA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlZzfz821Lc5894UPYvF8qmQqa703F3ESWigQbu2Z2l
 PF2n6vtKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmEitGsP/iqIYsZTWJj2/onNs
 t6tVr+c9m9Hkzd8+zXnR5A/rxdN6Gf7HOVyIaD7UFShj8yb9QEILe+hJRSNpza2x7S66KSrnzVg A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add a new file descriptor sentinel FD_FAILFS_ROOT following
FD_PIDFS_ROOT and FD_NSFS_ROOT and teach fchdir() to accept it. A
process calling fchdir(FD_FAILFS_ROOT) moves its working directory
into failfs. Every AT_FDCWD-relative lookup afterwards fails with
EOPNOTSUPP including "." and ".." and getcwd() reports the working
directory as unreachable from the process root by returning a path
prefixed with "(unreachable)". Lookups relative to explicit directory
file descriptors are unaffected.

The sentinel is the only way in. No privilege or gating is required.
Setting the working directory to a directory in which every operation
fails grants nothing and loses nothing that closing file descriptors
couldn't lose. An unlinked working directory behaves the same way today
modulo errno. The working directory also plays no role in confining ".."
resolution so no boundary is weakened.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/failfs.c                | 11 +++++++++++
 fs/internal.h              |  1 +
 fs/open.c                  |  5 ++++-
 include/uapi/linux/fcntl.h |  1 +
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/failfs.c b/fs/failfs.c
index d0ca1fc6c459..66a36da3d236 100644
--- a/fs/failfs.c
+++ b/fs/failfs.c
@@ -3,6 +3,7 @@
 #include <linux/fs.h>
 #include <linux/fs/super_types.h>
 #include <linux/fs_context.h>
+#include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/mount.h>
 
@@ -135,6 +136,16 @@ static int failfs_init_fs_context(struct fs_context *fc)
 	return 0;
 }
 
+int failfs_current_chdir(void)
+{
+	struct path path;
+
+	failfs_get_root(&path);
+	set_fs_pwd(current->fs, &path);
+	path_put(&path);
+	return 0;
+}
+
 static struct file_system_type failfs_fs_type = {
 	.name			= "failfs",
 	.init_fs_context	= failfs_init_fs_context,
diff --git a/fs/internal.h b/fs/internal.h
index ce7f12c5a65b..67aa0444351b 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -365,3 +365,4 @@ void nsfs_get_root(struct path *path);
 void failfs_get_root(struct path *path);
 void __init failfs_init(void);
 bool failfs_mnt(const struct vfsmount *mnt);
+int failfs_current_chdir(void);
diff --git a/fs/open.c b/fs/open.c
index 408925d7bd0b..56b6032d4d81 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -570,9 +570,12 @@ SYSCALL_DEFINE1(chdir, const char __user *, filename)
 
 SYSCALL_DEFINE1(fchdir, unsigned int, fd)
 {
-	CLASS(fd_raw, f)(fd);
 	int error;
 
+	if ((int)fd == FD_FAILFS_ROOT)
+		return failfs_current_chdir();
+
+	CLASS(fd_raw, f)(fd);
 	if (fd_empty(f))
 		return -EBADF;
 
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index aadfbf6e0cb3..e43e3de3e9ee 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -124,6 +124,7 @@ struct delegation {
 
 #define FD_PIDFS_ROOT			-10002 /* Root of the pidfs filesystem */
 #define FD_NSFS_ROOT			-10003 /* Root of the nsfs filesystem */
+#define FD_FAILFS_ROOT			-10004 /* Root of the failfs filesystem */
 #define FD_INVALID			-10009 /* Invalid file descriptor: -10000 - EBADF = -10009 */
 
 /* Generic flags for the *at(2) family of syscalls. */

-- 
2.53.0

