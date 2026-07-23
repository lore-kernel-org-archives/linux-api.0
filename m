Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41B7471404;
	Thu, 23 Jul 2026 11:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806243; cv=none; b=QC3UjomjVDk+VhEV5clMYeh01E5zhU3vQXOK4sl8EaakJq9YyJkcJ9kDU9kjmfJFIhxiF9ySBisFt563ODsa76cHyBvJXGGdj8DgdP1iBa7cl896gkppS8nKWAjnC9Aey9/OnYx76iTAPoMRIvIj55p3V/SAajCqf3KAtKuWMzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806243; c=relaxed/simple;
	bh=tC3xgOSMixqGYj7WJSGU1GS+MJM6f45b2gdvWBDSnRM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gq8N3xqxheT9vrp6wURzMwhvJ5H6x0fGRGO95Eu1arB13EeyYqc2dYeuPeHJbDUtd4ZivDdhvk6pxyg9hVoHqZn+xlsYbk/ELZZH/AjDoPyGu9eHl0dkRmhsWOVs2qASjZ6GObYMNM5WZv36e14hDRJy5ZfVdXmFX8EC8cTT9jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRG07n0w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRG07n0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FD81F000E9;
	Thu, 23 Jul 2026 11:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784806242;
	bh=pVI7AJeinyX5LZhsfwQWEU7lkoMKsXW0aPkqO59bTGQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LRG07n0wokP0EWSSv6KuVJBY1x+0s9JzCmepZxiSYdP+GQf5cCUtkKCePyM+LsJDr
	 6TtVzU3QNXNUlDhvnW4l/Zctay5ELCX0X6i3v2pkjjRQe6h9bUIqxu+dPyb8YGZ4ic
	 II8fgFpGSVCt88SdQNjltK/2iIZhU1PdSm3dDvluNFeidLXDC413543diL9LdnX8gL
	 Em8EAEY0mdL8QHJMItSl/+nkMzEVvVk73vSJAq7Qr9yvKYwwkldJEmnuistn505i/V
	 yPhIj5Xb52nVnGiZhkwmzTWBzPJBorJXTF9sc2H6HY7gf+zUvwFXAIRVjl1bCv1McG
	 ua581oHVTZfdA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 23 Jul 2026 13:30:21 +0200
Subject: [PATCH RFC 2/7] fs: add FD_FAILFS_ROOT and support it in fchdir()
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-work-failfs-v1-2-3f69b9a9e958@kernel.org>
References: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
In-Reply-To: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
To: linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, 
 Jann Horn <jannh@google.com>
Cc: John Ericson <mail@johnericson.me>, linux-api@vger.kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
 linux-doc@vger.kernel.org
X-Mailer: b4 0.16-dev-0e65f
X-Developer-Signature: v=1; a=openpgp-sha256; l=3232; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tC3xgOSMixqGYj7WJSGU1GS+MJM6f45b2gdvWBDSnRM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQl/g7/ufmR0v+f/x0+7uafMGP16efzfqd4HQhZddYk2
 Y0rZpm3YUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBE0hIZGc6WLfh0zlvl2AsN
 8SZt0VmGM0vymxo9zp1mP7eY1UFxkiXD/6pTr780/ZOMnqlV+bpUaWVyhCiPwqrTvMF/5ubdlTQ
 0ZQIA
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
index f9d4ba791928..f37e6af9c03c 100644
--- a/fs/failfs.c
+++ b/fs/failfs.c
@@ -3,6 +3,7 @@
 #include <linux/fs.h>
 #include <linux/fs/super_types.h>
 #include <linux/fs_context.h>
+#include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/mount.h>
 
@@ -124,6 +125,16 @@ static int failfs_init_fs_context(struct fs_context *fc)
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
index b6d38a5794eb..b3c88d999dec 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -364,3 +364,4 @@ void pidfs_get_root(struct path *path);
 void nsfs_get_root(struct path *path);
 void failfs_get_root(struct path *path);
 void __init failfs_init(void);
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

