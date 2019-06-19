From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 01/13] vfs: verify param type in vfs_parse_sb_flag()
Date: Wed, 19 Jun 2019 14:30:07 +0200
Message-ID: <20190619123019.30032-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

vfs_parse_sb_flag() accepted any kind of param with a matching key, not
just a flag.  This is wrong, only allow flag type and return -EINVAL
otherwise.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fs_context.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/fs_context.c b/fs/fs_context.c
index 103643c68e3f..e56310fd8c75 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -81,30 +81,29 @@ static const char *const forbidden_sb_flag[] = {
 /*
  * Check for a common mount option that manipulates s_flags.
  */
-static int vfs_parse_sb_flag(struct fs_context *fc, const char *key)
+static int vfs_parse_sb_flag(struct fs_context *fc, struct fs_parameter *param)
 {
-	unsigned int token;
+	const char *key = param->key;
+	unsigned int set, clear;
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(forbidden_sb_flag); i++)
 		if (strcmp(key, forbidden_sb_flag[i]) == 0)
 			return -EINVAL;
 
-	token = lookup_constant(common_set_sb_flag, key, 0);
-	if (token) {
-		fc->sb_flags |= token;
-		fc->sb_flags_mask |= token;
-		return 0;
-	}
+	set = lookup_constant(common_set_sb_flag, key, 0);
+	clear = lookup_constant(common_clear_sb_flag, key, 0);
+	if (!set && !clear)
+		return -ENOPARAM;
 
-	token = lookup_constant(common_clear_sb_flag, key, 0);
-	if (token) {
-		fc->sb_flags &= ~token;
-		fc->sb_flags_mask |= token;
-		return 0;
-	}
+	if (param->type != fs_value_is_flag)
+		return invalf(fc, "%s: Unexpected value for '%s'",
+			      fc->fs_type->name, param->key);
 
-	return -ENOPARAM;
+	fc->sb_flags |= set;
+	fc->sb_flags &= ~clear;
+	fc->sb_flags_mask |= set | clear;
+	return 0;
 }
 
 /**
@@ -130,7 +129,7 @@ int vfs_parse_fs_param(struct fs_context *fc, struct fs_parameter *param)
 	if (!param->key)
 		return invalf(fc, "Unnamed parameter\n");
 
-	ret = vfs_parse_sb_flag(fc, param->key);
+	ret = vfs_parse_sb_flag(fc, param);
 	if (ret != -ENOPARAM)
 		return ret;
 
-- 
2.21.0
