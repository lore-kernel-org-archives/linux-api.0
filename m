From: David Howells <dhowells@redhat.com>
Subject: [PATCH 16/25] fsinfo: Support Smack superblock parameter retrieval
 [ver #14]
Date: Mon, 24 Jun 2019 15:11:14 +0100
Message-ID: <156138547413.25627.9827414528195932042.stgit@warthog.procyon.org.uk>
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

Add support to Smack for retrieval of the superblock parameters.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/smack/smack_lsm.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0de725f88bed..0a1e88d50ad3 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -45,6 +45,7 @@
 #include <linux/parser.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
+#include <linux/fsinfo.h>
 #include "smack.h"
 
 #define TRANS_TRUE	"TRUE"
@@ -893,6 +894,45 @@ static int smack_sb_statfs(struct dentry *dentry)
 	return rc;
 }
 
+#ifdef CONFIG_FSINFO
+/*
+ * Retrieve the Smack filesystem information, including mount parameters.
+ */
+static int smack_sb_fsinfo(struct path *path, struct fsinfo_kparams *params)
+{
+	struct superblock_smack *sp = path->dentry->d_sb->s_security;
+
+	switch (params->request) {
+	case FSINFO_ATTR_LSM_PARAMETERS: {
+		struct dentry *root = path->dentry->d_sb->s_root;
+		struct inode *inode = d_backing_inode(root);
+		struct inode_smack *isp = inode->i_security;
+
+		if (sp->smk_flags & SMK_SB_INITIALIZED)
+			return 0;
+		if (sp->smk_floor)
+			fsinfo_note_param(params, "fsfloor", sp->smk_floor->smk_known);
+		if (sp->smk_hat)
+			fsinfo_note_param(params, "fshat", sp->smk_hat->smk_known);
+		if (sp->smk_default)
+			fsinfo_note_param(params, "fsdefault", sp->smk_default->smk_known);
+
+		if (sp->smk_root) {
+			if (isp && isp->smk_flags & SMK_INODE_TRANSMUTE)
+				fsinfo_note_param(params, "fstransmute", sp->smk_root->smk_known);
+			else
+				fsinfo_note_param(params, "fsroot", sp->smk_root->smk_known);
+		}
+		return params->usage;
+	}
+
+	default:
+		return -ENODATA;
+	}
+	return 0;
+}
+#endif
+
 /*
  * BPRM hooks
  */
@@ -4606,6 +4646,9 @@ static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(sb_free_mnt_opts, smack_free_mnt_opts),
 	LSM_HOOK_INIT(sb_eat_lsm_opts, smack_sb_eat_lsm_opts),
 	LSM_HOOK_INIT(sb_statfs, smack_sb_statfs),
+#ifdef CONFIG_FSINFO
+	LSM_HOOK_INIT(sb_fsinfo, smack_sb_fsinfo),
+#endif
 	LSM_HOOK_INIT(sb_set_mnt_opts, smack_set_mnt_opts),
 
 	LSM_HOOK_INIT(bprm_set_creds, smack_bprm_set_creds),
