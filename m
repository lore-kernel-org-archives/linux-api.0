From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 10/24] stat: handle fsid mappings
Date: Tue, 11 Feb 2020 17:57:39 +0100
Message-ID: <20200211165753.356508-11-christian.brauner@ubuntu.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>
Cc: smbarber@chromium.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Serge Hallyn <serge@hallyn.com>, James Morris <jmorris@namei.org>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

Switch attribute functions looking up fsids to them up in the fsid mappings. If
no fsid mappings are setup the behavior is unchanged, i.e. fsids are looked up
in the id mappings.

Filesystems that share a superblock in all user namespaces they are mounted in
will retain their old semantics even with the introduction of fsidmappings.

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/stat.c            | 48 +++++++++++++++++++++++++++++++++++---------
 include/linux/stat.h |  1 +
 2 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index c38e4c2e1221..1cced54e79d4 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/file.h>
 #include <linux/highuid.h>
+#include <linux/fsuidgid.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/security.h>
@@ -77,6 +78,8 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 	if (IS_AUTOMOUNT(inode))
 		stat->attributes |= STATX_ATTR_AUTOMOUNT;
 
+	stat->userns_visible = is_userns_visible(inode->i_sb->s_iflags);
+
 	if (inode->i_op->getattr)
 		return inode->i_op->getattr(path, stat, request_mask,
 					    query_flags);
@@ -229,8 +232,13 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
 	tmp.st_nlink = stat->nlink;
 	if (tmp.st_nlink != stat->nlink)
 		return -EOVERFLOW;
-	SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
-	SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
+	if (stat->userns_visible) {
+		SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
+		SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
+	} else {
+		SET_UID(tmp.st_uid, from_kfsuid_munged(current_user_ns(), stat->uid));
+		SET_GID(tmp.st_gid, from_kfsgid_munged(current_user_ns(), stat->gid));
+	}
 	tmp.st_rdev = old_encode_dev(stat->rdev);
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
@@ -317,8 +325,13 @@ static int cp_new_stat(struct kstat *stat, struct stat __user *statbuf)
 	tmp.st_nlink = stat->nlink;
 	if (tmp.st_nlink != stat->nlink)
 		return -EOVERFLOW;
-	SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
-	SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
+	if (stat->userns_visible) {
+		SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
+		SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
+	} else {
+		SET_UID(tmp.st_uid, from_kfsuid_munged(current_user_ns(), stat->uid));
+		SET_GID(tmp.st_gid, from_kfsgid_munged(current_user_ns(), stat->gid));
+	}
 	tmp.st_rdev = encode_dev(stat->rdev);
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
@@ -461,8 +474,13 @@ static long cp_new_stat64(struct kstat *stat, struct stat64 __user *statbuf)
 #endif
 	tmp.st_mode = stat->mode;
 	tmp.st_nlink = stat->nlink;
-	tmp.st_uid = from_kuid_munged(current_user_ns(), stat->uid);
-	tmp.st_gid = from_kgid_munged(current_user_ns(), stat->gid);
+	if (stat->userns_visible) {
+		tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid);
+		tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid);
+	} else {
+		tmp.st_uid, from_kfsuid_munged(current_user_ns(), stat->uid);
+		tmp.st_gid, from_kfsgid_munged(current_user_ns(), stat->gid);
+	}
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_atime_nsec = stat->atime.tv_nsec;
 	tmp.st_mtime = stat->mtime.tv_sec;
@@ -534,8 +552,13 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 	tmp.stx_blksize = stat->blksize;
 	tmp.stx_attributes = stat->attributes;
 	tmp.stx_nlink = stat->nlink;
-	tmp.stx_uid = from_kuid_munged(current_user_ns(), stat->uid);
-	tmp.stx_gid = from_kgid_munged(current_user_ns(), stat->gid);
+	if (stat->userns_visible) {
+		tmp.stx_uid = from_kuid_munged(current_user_ns(), stat->uid);
+		tmp.stx_gid = from_kgid_munged(current_user_ns(), stat->gid);
+	} else {
+		tmp.stx_uid = from_kfsuid_munged(current_user_ns(), stat->uid);
+		tmp.stx_gid = from_kfsgid_munged(current_user_ns(), stat->gid);
+	}
 	tmp.stx_mode = stat->mode;
 	tmp.stx_ino = stat->ino;
 	tmp.stx_size = stat->size;
@@ -605,8 +628,13 @@ static int cp_compat_stat(struct kstat *stat, struct compat_stat __user *ubuf)
 	tmp.st_nlink = stat->nlink;
 	if (tmp.st_nlink != stat->nlink)
 		return -EOVERFLOW;
-	SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
-	SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
+	if (stat->userns_visible) {
+		SET_UID(tmp.st_uid, from_kuid_munged(current_user_ns(), stat->uid));
+		SET_GID(tmp.st_gid, from_kgid_munged(current_user_ns(), stat->gid));
+	} else {
+		SET_UID(tmp.st_uid, from_kfsuid_munged(current_user_ns(), stat->uid));
+		SET_GID(tmp.st_gid, from_kfsgid_munged(current_user_ns(), stat->gid));
+	}
 	tmp.st_rdev = old_encode_dev(stat->rdev);
 	if ((u64) stat->size > MAX_NON_LFS)
 		return -EOVERFLOW;
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 528c4baad091..e6d4ba73a970 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -47,6 +47,7 @@ struct kstat {
 	struct timespec64 ctime;
 	struct timespec64 btime;			/* File creation time */
 	u64		blocks;
+	bool		userns_visible;
 };
 
 #endif
-- 
2.25.0
