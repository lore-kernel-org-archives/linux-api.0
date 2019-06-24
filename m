From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/25] fsinfo: proc - add sb operation fsinfo() [ver #14]
Date: Mon, 24 Jun 2019 15:11:32 +0100
Message-ID: <156138549291.25627.9442017015199997555.stgit@warthog.procyon.org.uk>
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

 fs/proc/inode.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 5f8d215b3fd0..28c287aff6aa 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -24,6 +24,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/mount.h>
+#include <linux/fsinfo.h>
 
 #include <linux/uaccess.h>
 
@@ -115,6 +116,39 @@ static int proc_show_options(struct seq_file *seq, struct dentry *root)
 	return 0;
 }
 
+#ifdef CONFIG_FSINFO
+/*
+ * Get filesystem information.
+ */
+static int proc_fsinfo(struct path *path, struct fsinfo_kparams *params)
+{
+	struct super_block *sb = path->dentry->d_sb;
+	struct pid_namespace *pid = sb->s_fs_info;
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
+		fsinfo_note_sb_params(params, sb->s_flags);
+		if (!gid_eq(pid->pid_gid, GLOBAL_ROOT_GID))
+			fsinfo_note_paramf(params, "gid", "%u",
+				from_kgid_munged(&init_user_ns, pid->pid_gid));
+		if (pid->hide_pid != HIDEPID_OFF)
+			fsinfo_note_paramf(params, "hidepid",
+					  "%u", pid->hide_pid);
+		return params->usage;
+
+	default:
+		return generic_fsinfo(path, params);
+	}
+}
+#endif /* CONFIG_FSINFO */
+
 const struct super_operations proc_sops = {
 	.alloc_inode	= proc_alloc_inode,
 	.free_inode	= proc_free_inode,
@@ -122,6 +156,9 @@ const struct super_operations proc_sops = {
 	.evict_inode	= proc_evict_inode,
 	.statfs		= simple_statfs,
 	.show_options	= proc_show_options,
+#ifdef CONFIG_FSINFO
+	.fsinfo		= proc_fsinfo,
+#endif
 };
 
 enum {BIAS = -1U<<31};
