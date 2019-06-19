From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 03/13] vfs: don't parse forbidden flags
Date: Wed, 19 Jun 2019 14:30:09 +0200
Message-ID: <20190619123019.30032-3-mszeredi@redhat.com>
References: <20190619123019.30032-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190619123019.30032-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Impossible to keep this blacklist properly synced with what mount(8) parses
and what it doesn't.  E.g. it has various forms of "*atime" options, but
not "atime"...

Other than being impossible to maintain, it also makes little sense.  So
just get rid of it.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fs_context.c | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/fs/fs_context.c b/fs/fs_context.c
index a9f314390b99..cbf89117a507 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -55,29 +55,6 @@ static const struct constant_table common_clear_sb_flag[] = {
 	{ "silent",	SB_SILENT },
 };
 
-static const char *const forbidden_sb_flag[] = {
-	"bind",
-	"dev",
-	"exec",
-	"move",
-	"noatime",
-	"nodev",
-	"nodiratime",
-	"noexec",
-	"norelatime",
-	"nostrictatime",
-	"nosuid",
-	"private",
-	"rec",
-	"relatime",
-	"remount",
-	"shared",
-	"slave",
-	"strictatime",
-	"suid",
-	"unbindable",
-};
-
 /*
  * Check for a common mount option that manipulates s_flags.
  */
@@ -85,11 +62,6 @@ int vfs_parse_sb_flag(struct fs_context *fc, struct fs_parameter *param)
 {
 	const char *key = param->key;
 	unsigned int set, clear;
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(forbidden_sb_flag); i++)
-		if (strcmp(key, forbidden_sb_flag[i]) == 0)
-			return -EINVAL;
 
 	set = lookup_constant(common_set_sb_flag, key, 0);
 	clear = lookup_constant(common_clear_sb_flag, key, 0);
-- 
2.21.0
