From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/25] fsinfo: autofs - add sb operation fsinfo() [ver #14]
Date: Mon, 24 Jun 2019 15:11:40 +0100
Message-ID: <156138550021.25627.6768424880434079121.stgit@warthog.procyon.org.uk>
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

 fs/autofs/inode.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index 58457ec0ab27..53e794ee2aec 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -11,6 +11,7 @@
 #include <linux/pagemap.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
+#include <linux/fsinfo.h>
 
 #include "autofs_i.h"
 
@@ -101,6 +102,66 @@ static int autofs_show_options(struct seq_file *m, struct dentry *root)
 	return 0;
 }
 
+#ifdef CONFIG_FSINFO
+/*
+ * Get filesystem information.
+ */
+static int autofs_fsinfo(struct path *path, struct fsinfo_kparams *params)
+{
+	struct autofs_sb_info *sbi = autofs_sbi(path->dentry->d_sb);
+	struct inode *inode = d_inode(path->dentry->d_sb->s_root);
+	struct fsinfo_capabilities *caps;
+
+	switch (params->request) {
+	case FSINFO_ATTR_CAPABILITIES:
+		caps = params->buffer;
+		fsinfo_set_cap(caps, FSINFO_CAP_IS_AUTOMOUNTER_FS);
+		fsinfo_set_cap(caps, FSINFO_CAP_AUTOMOUNTS);
+		fsinfo_set_cap(caps, FSINFO_CAP_NOT_PERSISTENT);
+		return sizeof(*caps);
+
+	case FSINFO_ATTR_PARAMETERS:
+		fsinfo_note_sb_params(params, inode->i_sb->s_flags);
+		fsinfo_note_paramf(params, "fd", "%d", sbi->pipefd);
+		if (!uid_eq(inode->i_uid, GLOBAL_ROOT_UID))
+			fsinfo_note_paramf(params, "uid", "%u",
+				from_kuid_munged(&init_user_ns, inode->i_uid));
+		if (!gid_eq(inode->i_gid, GLOBAL_ROOT_GID))
+			fsinfo_note_paramf(params, "gid", "%u",
+				from_kgid_munged(&init_user_ns, inode->i_gid));
+		fsinfo_note_paramf(params, "pgrp", "%d",
+				   pid_vnr(sbi->oz_pgrp));
+		fsinfo_note_paramf(params, "timeout", "%lu",
+				   sbi->exp_timeout/HZ);
+		fsinfo_note_paramf(params, "minproto", "%d",
+				   sbi->min_proto);
+		fsinfo_note_paramf(params, "maxproto", "%d",
+				   sbi->max_proto);
+		if (autofs_type_offset(sbi->type))
+			fsinfo_note_param(params, "offset", NULL);
+		else if (autofs_type_direct(sbi->type))
+			fsinfo_note_param(params, "direct", NULL);
+		else
+			fsinfo_note_param(params, "indirect", NULL);
+		if (sbi->flags & AUTOFS_SBI_STRICTEXPIRE)
+			fsinfo_note_param(params, "strictexpire", NULL);
+		if (sbi->flags & AUTOFS_SBI_IGNORE)
+			fsinfo_note_param(params, "ignore", NULL);
+#ifdef CONFIG_CHECKPOINT_RESTORE
+		if (sbi->pipe)
+			fsinfo_note_paramf(params, "pipe_ino",
+					  "%ld", file_inode(sbi->pipe)->i_ino);
+		else
+			fsinfo_note_param(params, "pipe_ino", "-1");
+#endif
+		return params->usage;
+
+	default:
+		return generic_fsinfo(path, params);
+	}
+}
+#endif /* CONFIG_FSINFO */
+
 static void autofs_evict_inode(struct inode *inode)
 {
 	clear_inode(inode);
@@ -111,6 +172,9 @@ static const struct super_operations autofs_sops = {
 	.statfs		= simple_statfs,
 	.show_options	= autofs_show_options,
 	.evict_inode	= autofs_evict_inode,
+#ifdef CONFIG_FSINFO
+	.fsinfo		= autofs_fsinfo,
+#endif
 };
 
 struct autofs_fs_context {
