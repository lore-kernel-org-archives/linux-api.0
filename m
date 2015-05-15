From: Zach Brown <zab@zabbo.net>
Subject: [PATCH RFC v2 1/2] vfs: add generic nocmtime mount flag
Date: Fri, 15 May 2015 14:23:47 -0700
Message-ID: <1431725028-24071-2-git-send-email-zab@zabbo.net>
References: <1431725028-24071-1-git-send-email-zab@zabbo.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431725028-24071-1-git-send-email-zab@zabbo.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Sage Weil <sweil@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add the infrastructure to support a generic nocmtime mount flag.  Like
MS_NOATIME/MNT_NOATIME this can be used to support the mount option in
file systems without having to touch each file system.

This will be used to provide a priviledged indication that unpriviledged
apps can safely use O_NOCMTIME to prevent cmtime updates without harm.

Signed-off-by: Zach Brown <zab@zabbo.net>
---
 fs/namespace.c          | 2 ++
 fs/proc_namespace.c     | 1 +
 fs/statfs.c             | 2 ++
 include/linux/mount.h   | 1 +
 include/linux/statfs.h  | 1 +
 include/uapi/linux/fs.h | 1 +
 6 files changed, 8 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1b9e111..48be1f9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2652,6 +2652,8 @@ long do_mount(const char *dev_name, const char __user *dir_name,
 		mnt_flags |= MNT_NOEXEC;
 	if (flags & MS_NOATIME)
 		mnt_flags |= MNT_NOATIME;
+	if (flags & MS_NOCMTIME)
+		mnt_flags |= MNT_NOCMTIME;
 	if (flags & MS_NODIRATIME)
 		mnt_flags |= MNT_NODIRATIME;
 	if (flags & MS_STRICTATIME)
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 8db932d..49d7839 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -64,6 +64,7 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 		{ MNT_NODEV, ",nodev" },
 		{ MNT_NOEXEC, ",noexec" },
 		{ MNT_NOATIME, ",noatime" },
+		{ MNT_NOCMTIME, ",nocmtime" },
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
 		{ 0, NULL }
diff --git a/fs/statfs.c b/fs/statfs.c
index 083dc0a..43d3de2 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -23,6 +23,8 @@ static int flags_by_mnt(int mnt_flags)
 		flags |= ST_NOEXEC;
 	if (mnt_flags & MNT_NOATIME)
 		flags |= ST_NOATIME;
+	if (mnt_flags & MNT_NOCMTIME)
+		flags |= ST_NOCMTIME;
 	if (mnt_flags & MNT_NODIRATIME)
 		flags |= ST_NODIRATIME;
 	if (mnt_flags & MNT_RELATIME)
diff --git a/include/linux/mount.h b/include/linux/mount.h
index f822c3c..deb458f 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -28,6 +28,7 @@ struct mnt_namespace;
 #define MNT_NODIRATIME	0x10
 #define MNT_RELATIME	0x20
 #define MNT_READONLY	0x40	/* does the user want this to be r/o? */
+#define MNT_NOCMTIME	0x80	/* allow O_NOCMTIME to stop cmtime updates */
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_WRITE_HOLD	0x200
diff --git a/include/linux/statfs.h b/include/linux/statfs.h
index 0166d32..bde224e 100644
--- a/include/linux/statfs.h
+++ b/include/linux/statfs.h
@@ -39,5 +39,6 @@ struct kstatfs {
 #define ST_NOATIME	0x0400	/* do not update access times */
 #define ST_NODIRATIME	0x0800	/* do not update directory access times */
 #define ST_RELATIME	0x1000	/* update atime relative to mtime/ctime */
+#define ST_NOCMTIME	0x2000	/* allow O_NOCMTIME to stop cmtime updates */
 
 #endif
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 9b964a5..af1131e 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -91,6 +91,7 @@ struct inodes_stat_t {
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
 #define MS_LAZYTIME	(1<<25) /* Update the on-disk [acm]times lazily */
+#define MS_NOCMTIME	(1<<26) /* allow O_NOCMTIME to stop cmtime updates */
 
 /* These sb flags are internal to the kernel */
 #define MS_NOSEC	(1<<28)
-- 
2.1.0
