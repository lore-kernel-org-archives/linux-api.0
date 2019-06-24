From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/25] fsinfo: debugfs - add sb operation fsinfo() [ver #14]
Date: Mon, 24 Jun 2019 15:12:11 +0100
Message-ID: <156138553103.25627.1921281542367616884.stgit@warthog.procyon.org.uk>
References: <156138532485.25627.7459410522109581052.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <156138532485.25627.7459410522109581052.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, raven@themaw.net, mszeredi@redhat.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Ian Kent <raven@themaw.net>

The new fsinfo() system call adds a new super block operation
->fsinfo() which is used by file systems to provide file
system specific information for fsinfo() requests.

The fsinfo() request FSINFO_ATTR_PARAMETERS provides the same
function as sb operation ->show_options() so it needs to be
implemented by any file system that provides ->show_options()
as a minimum.

Also add a simple FSINFO_ATTR_CAPABILITIES implementation.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/debugfs/inode.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 24354ccdc968..a5ef136addbb 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -24,6 +24,7 @@
 #include <linux/seq_file.h>
 #include <linux/magic.h>
 #include <linux/slab.h>
+#include <linux/fsinfo.h>
 
 #include "internal.h"
 
@@ -143,6 +144,40 @@ static int debugfs_show_options(struct seq_file *m, struct dentry *root)
 	return 0;
 }
 
+#ifdef CONFIG_FSINFO
+/*
+ * Get filesystem information.
+ */
+static int debugfs_fsinfo(struct path *path, struct fsinfo_kparams *params)
+{
+	struct debugfs_fs_info *fsi = path->dentry->d_sb->s_fs_info;
+	struct fsinfo_capabilities *caps;
+
+	switch (params->request) {
+	case FSINFO_ATTR_CAPABILITIES:
+		caps = params->buffer;
+		fsinfo_set_cap(caps, FSINFO_CAP_IS_KERNEL_FS);
+		fsinfo_set_cap(caps, FSINFO_CAP_NOT_PERSISTENT);
+		return sizeof(*caps);
+
+	case FSINFO_ATTR_PARAMETERS:
+		fsinfo_note_sb_params(params, path->dentry->d_sb->s_flags);
+		if (!uid_eq(fsi->uid, GLOBAL_ROOT_UID))
+			fsinfo_note_paramf(params, "uid", "%u",
+				   from_kuid_munged(&init_user_ns, fsi->uid));
+		if (!gid_eq(fsi->gid, GLOBAL_ROOT_GID))
+			fsinfo_note_paramf(params, "gid", "%u",
+				   from_kgid_munged(&init_user_ns, fsi->gid));
+		if (fsi->mode != DEBUGFS_DEFAULT_MODE)
+			fsinfo_note_paramf(params, "mode", "%o", fsi->mode);
+		return params->usage;
+
+	default:
+		return generic_fsinfo(path, params);
+	}
+}
+#endif /* CONFIG_FSINFO */
+
 static void debugfs_free_inode(struct inode *inode)
 {
 	if (S_ISLNK(inode->i_mode))
@@ -154,6 +189,9 @@ static const struct super_operations debugfs_super_operations = {
 	.statfs		= simple_statfs,
 	.show_options	= debugfs_show_options,
 	.free_inode	= debugfs_free_inode,
+#ifdef CONFIG_FSINFO
+	.fsinfo		= debugfs_fsinfo,
+#endif
 };
 
 static void debugfs_release_dentry(struct dentry *dentry)
