From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 06/13] vfs: new helper: vfs_parse_ro_rw()
Date: Wed, 19 Jun 2019 14:30:12 +0200
Message-ID: <20190619123019.30032-6-mszeredi@redhat.com>
References: <20190619123019.30032-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190619123019.30032-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This just parses the "ro" and "rw" options and sets sb_flags accordingly.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fs_context.c            | 18 ++++++++++++++++++
 include/linux/fs_context.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/fs/fs_context.c b/fs/fs_context.c
index c26b353aa858..5012ab7650ec 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -77,6 +77,24 @@ int vfs_parse_sb_flag(struct fs_context *fc, struct fs_parameter *param)
 }
 EXPORT_SYMBOL(vfs_parse_sb_flag);
 
+int vfs_parse_ro_rw(struct fs_context *fc, struct fs_parameter *param)
+{
+	if (strcmp(param->key, "ro") == 0)
+		fc->sb_flags |= SB_RDONLY;
+	else if (strcmp(param->key, "rw") == 0)
+		fc->sb_flags &= ~SB_RDONLY;
+	else
+		return -ENOPARAM;
+
+	if (param->type != fs_value_is_flag)
+		return invalf(fc, "%s: Unexpected value for '%s'",
+			      fc->fs_type->name, param->key);
+
+	fc->sb_flags_mask |= SB_RDONLY;
+	return 0;
+}
+EXPORT_SYMBOL(vfs_parse_ro_rw);
+
 /**
  * vfs_parse_fs_param - Add a single parameter to a superblock config
  * @fc: The filesystem context to modify
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 39f4d8b0a390..bff6796a89ef 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -128,6 +128,7 @@ extern struct fs_context *fs_context_for_submount(struct file_system_type *fs_ty
 
 extern struct fs_context *vfs_dup_fs_context(struct fs_context *fc);
 extern int vfs_parse_sb_flag(struct fs_context *fc, struct fs_parameter *param);
+extern int vfs_parse_ro_rw(struct fs_context *fc, struct fs_parameter *param);
 extern int vfs_parse_fs_param(struct fs_context *fc, struct fs_parameter *param);
 extern int vfs_parse_fs_string(struct fs_context *fc, const char *key,
 			       const char *value, size_t v_size);
-- 
2.21.0
