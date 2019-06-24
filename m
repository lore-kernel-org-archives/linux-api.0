From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/25] fsinfo: bpf - add sb operation fsinfo() [ver #14]
Date: Mon, 24 Jun 2019 15:12:18 +0100
Message-ID: <156138553835.25627.17552849634696580641.stgit@warthog.procyon.org.uk>
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

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/bpf/inode.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 6e22363054b1..8c3575eca976 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -23,6 +23,7 @@
 #include <linux/filter.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <linux/fsinfo.h>
 
 enum bpf_type {
 	BPF_TYPE_UNSPEC	= 0,
@@ -567,6 +568,27 @@ static int bpf_show_options(struct seq_file *m, struct dentry *root)
 	return 0;
 }
 
+#ifdef CONFIG_FSINFO
+/*
+ * Get filesystem information.
+ */
+static int bpf_fsinfo(struct path *path, struct fsinfo_kparams *params)
+{
+	umode_t mode = d_inode(path->dentry)->i_mode & S_IALLUGO & ~S_ISVTX;
+
+	switch (params->request) {
+	case FSINFO_ATTR_PARAMETERS:
+		fsinfo_note_sb_params(params, path->dentry->d_sb->s_flags);
+		if (mode != S_IRWXUGO)
+			fsinfo_note_paramf(params, "mode", "%o", mode);
+		return params->usage;
+
+	default:
+		return generic_fsinfo(path, params);
+	}
+}
+#endif /* CONFIG_FSINFO */
+
 static void bpf_free_inode(struct inode *inode)
 {
 	enum bpf_type type;
@@ -583,6 +605,9 @@ static const struct super_operations bpf_super_ops = {
 	.drop_inode	= generic_delete_inode,
 	.show_options	= bpf_show_options,
 	.free_inode	= bpf_free_inode,
+#ifdef CONFIG_FSINFO
+	.fsinfo		= bpf_fsinfo,
+#endif
 };
 
 enum {
