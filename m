From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/25] fsinfo: devpts - add sb operation fsinfo() [ver #14]
Date: Mon, 24 Jun 2019 15:11:54 +0100
Message-ID: <156138551486.25627.9996141646216300722.stgit@warthog.procyon.org.uk>
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

 fs/devpts/inode.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 3aa73a2ec2f1..6f0eb69f7cbb 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -28,6 +28,7 @@
 #include <linux/devpts_fs.h>
 #include <linux/fsnotify.h>
 #include <linux/seq_file.h>
+#include <linux/fsinfo.h>
 
 #define DEVPTS_DEFAULT_MODE 0600
 /*
@@ -401,9 +402,51 @@ static int devpts_show_options(struct seq_file *seq, struct dentry *root)
 	return 0;
 }
 
+#ifdef CONFIG_FSINFO
+/*
+ * Get filesystem information.
+ */
+static int devpts_fsinfo(struct path *path, struct fsinfo_kparams *params)
+{
+	struct pts_fs_info *fsi = DEVPTS_SB(path->dentry->d_sb);
+	struct pts_mount_opts *opts = &fsi->mount_opts;
+	struct fsinfo_capabilities *caps;
+
+	switch (params->request) {
+	case FSINFO_ATTR_CAPABILITIES:
+		caps = params->buffer;
+		fsinfo_set_cap(caps, FSINFO_CAP_IS_KERNEL_FS);
+		fsinfo_set_cap(caps, FSINFO_CAP_NOT_PERSISTENT);
+		fsinfo_set_cap(caps, FSINFO_CAP_UIDS);
+		fsinfo_set_cap(caps, FSINFO_CAP_GIDS);
+		return sizeof(*caps);
+
+	case FSINFO_ATTR_PARAMETERS:
+		fsinfo_note_sb_params(params, path->dentry->d_sb->s_flags);
+		if (opts->setuid)
+			fsinfo_note_paramf(params, "uid", "%u",
+				from_kuid_munged(&init_user_ns, opts->uid));
+		if (opts->setgid)
+			fsinfo_note_paramf(params, "gid", "%u",
+				from_kgid_munged(&init_user_ns, opts->gid));
+		fsinfo_note_paramf(params, "mode", "%03o", opts->mode);
+		fsinfo_note_paramf(params, "ptmxmode", "%03o", opts->ptmxmode);
+		if (opts->max < NR_UNIX98_PTY_MAX)
+			fsinfo_note_paramf(params, "max", "%d", opts->max);
+		return params->usage;
+
+	default:
+		return generic_fsinfo(path, params);
+	}
+}
+#endif /* CONFIG_FSINFO */
+
 static const struct super_operations devpts_sops = {
 	.statfs		= simple_statfs,
 	.show_options	= devpts_show_options,
+#ifdef CONFIG_FSINFO
+	.fsinfo		= devpts_fsinfo,
+#endif
 };
 
 static int devpts_fill_super(struct super_block *s, struct fs_context *fc)
