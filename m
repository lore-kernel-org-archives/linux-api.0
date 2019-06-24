From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/25] fsinfo: pstore - add sb operation fsinfo() [ver #14]
Date: Mon, 24 Jun 2019 15:12:02 +0100
Message-ID: <156138552215.25627.11849234966327633715.stgit@warthog.procyon.org.uk>
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

 fs/pstore/inode.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 4640debf8755..b2c1751a1c48 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -36,6 +36,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
+#include <linux/fsinfo.h>
 
 #include "internal.h"
 
@@ -281,6 +282,34 @@ static int pstore_show_options(struct seq_file *m, struct dentry *root)
 	return 0;
 }
 
+#ifdef CONFIG_FSINFO
+/*
+ * Get filesystem information.
+ */
+static int pstore_fsinfo(struct path *path, struct fsinfo_kparams *params)
+{
+	struct fsinfo_capabilities *caps;
+
+	switch (params->request) {
+	case FSINFO_ATTR_CAPABILITIES:
+		caps = params->buffer;
+		fsinfo_set_cap(caps, FSINFO_CAP_IS_FLASH_FS);
+		fsinfo_set_cap(caps, FSINFO_CAP_HAS_CTIME);
+		fsinfo_set_cap(caps, FSINFO_CAP_HAS_MTIME);
+		return sizeof(*caps);
+
+	case FSINFO_ATTR_PARAMETERS:
+		fsinfo_note_sb_params(params, path->dentry->d_sb->s_flags);
+		if (kmsg_bytes != PSTORE_DEFAULT_KMSG_BYTES)
+			fsinfo_note_paramf(params, "kmsg_bytes", "%lu", kmsg_bytes);
+		return params->usage;
+
+	default:
+		return generic_fsinfo(path, params);
+	}
+}
+#endif /* CONFIG_FSINFO */
+
 static int pstore_reconfigure(struct fs_context *fc)
 {
 	sync_filesystem(fc->root->d_sb);
@@ -293,6 +322,9 @@ static const struct super_operations pstore_ops = {
 	.drop_inode	= generic_delete_inode,
 	.evict_inode	= pstore_evict_inode,
 	.show_options	= pstore_show_options,
+#ifdef CONFIG_FSINFO
+	.fsinfo		= pstore_fsinfo,
+#endif
 };
 
 static struct super_block *pstore_sb;
