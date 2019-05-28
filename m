From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/25] vfs: Allow fsinfo() to query what's in an fs_context
 [ver #13]
Date: Tue, 28 May 2019 16:11:19 +0100
Message-ID: <155905627927.1662.13276277442207649583.stgit@warthog.procyon.org.uk>
References: <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, raven@themaw.net, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

Allow fsinfo() to be used to query the filesystem attached to an fs_context
once a superblock has been created or if it comes from fspick().

This is done with something like:

	fd = fsopen("ext4", 0);
	...
	fsconfig(fd, fsconfig_cmd_create, ...);
	fsinfo(fd, NULL, ...);

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fsinfo.c |   30 +++++++++++++++++++++++++++++-
 fs/statfs.c |    2 +-
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/fsinfo.c b/fs/fsinfo.c
index f9a63410e9a2..14db881dd02d 100644
--- a/fs/fsinfo.c
+++ b/fs/fsinfo.c
@@ -8,6 +8,7 @@
 #include <linux/security.h>
 #include <linux/uaccess.h>
 #include <linux/fsinfo.h>
+#include <linux/fs_context.h>
 #include <uapi/linux/mount.h>
 #include "internal.h"
 
@@ -315,13 +316,40 @@ static int vfs_fsinfo_path(int dfd, const char __user *filename,
 	return ret;
 }
 
+static int vfs_fsinfo_fscontext(struct fs_context *fc,
+				struct fsinfo_kparams *params)
+{
+	int ret;
+
+	if (fc->ops == &legacy_fs_context_ops)
+		return -EOPNOTSUPP;
+
+	ret = mutex_lock_interruptible(&fc->uapi_mutex);
+	if (ret < 0)
+		return ret;
+
+	ret = -EIO;
+	if (fc->root) {
+		struct path path = { .dentry = fc->root };
+
+		ret = vfs_fsinfo(&path, params);
+	}
+
+	mutex_unlock(&fc->uapi_mutex);
+	return ret;
+}
+
 static int vfs_fsinfo_fd(unsigned int fd, struct fsinfo_kparams *params)
 {
 	struct fd f = fdget_raw(fd);
 	int ret = -EBADF;
 
 	if (f.file) {
-		ret = vfs_fsinfo(&f.file->f_path, params);
+		if (f.file->f_op == &fscontext_fops)
+			ret = vfs_fsinfo_fscontext(f.file->private_data,
+						   params);
+		else
+			ret = vfs_fsinfo(&f.file->f_path, params);
 		fdput(f);
 	}
 	return ret;
diff --git a/fs/statfs.c b/fs/statfs.c
index eea7af6f2f22..b9b63d9f4f24 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -86,7 +86,7 @@ int vfs_statfs(const struct path *path, struct kstatfs *buf)
 	int error;
 
 	error = statfs_by_dentry(path->dentry, buf);
-	if (!error)
+	if (!error && path->mnt)
 		buf->f_flags = calculate_f_flags(path->mnt);
 	return error;
 }
