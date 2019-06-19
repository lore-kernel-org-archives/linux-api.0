From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH v2 05/13] vfs: don't parse "silent" option
Date: Wed, 19 Jun 2019 14:54:52 +0200
Message-ID: <20190619125452.28303-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

While this is a standard option as documented in mount(8), it is ignored by
most filesystems.  So reject, unless filesystem explicitly wants to handle
it.

The exception is unconverted filesystems, where it is unknown if the
filesystem handles this or not.

Any implementation, such as mount(8) that needs to parse this option
without failing should simply ignore the return value from fsconfig().

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
Changes:
 - v1 didn't return on matching option in legacy_parse_param()
 
 fs/fs_context.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/fs_context.c b/fs/fs_context.c
index 49636e541293..bd8f8ab8358b 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -51,7 +51,6 @@ static const struct constant_table common_clear_sb_flag[] = {
 	{ "nolazytime",	SB_LAZYTIME },
 	{ "nomand",	SB_MANDLOCK },
 	{ "rw",		SB_RDONLY },
-	{ "silent",	SB_SILENT },
 };
 
 /*
@@ -535,6 +534,15 @@ static int legacy_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	if (ret != -ENOPARAM)
 		return ret;
 
+	if (strcmp(param->key, "silent") == 0) {
+		if (param->type != fs_value_is_flag)
+			return invalf(fc, "%s: Unexpected value for '%s'",
+				      fc->fs_type->name, param->key);
+
+		fc->sb_flags |= SB_SILENT;
+		return 0;
+	}
+
 	if (strcmp(param->key, "source") == 0) {
 		if (param->type != fs_value_is_string)
 			return invalf(fc, "VFS: Legacy: Non-string source");
-- 
2.21.0
