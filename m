From: Li Xi <pkuelelixi@gmail.com>
Subject: [v12 1/5] vfs: adds general codes to enforces project quota limits
Date: Fri, 10 Apr 2015 00:14:33 +0900
Message-ID: <1428592477-8212-2-git-send-email-lixi@ddn.com>
References: <1428592477-8212-1-git-send-email-lixi@ddn.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1428592477-8212-1-git-send-email-lixi@ddn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

This patch adds support for a new quota type PRJQUOTA for project quota
enforcement. Also a new method get_projid() is added into dquot_operations
structure.

Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c           |   35 ++++++++++++++++++++++++++++++-----
 fs/quota/quota.c           |    5 ++++-
 fs/quota/quotaio_v2.h      |    6 ++++--
 include/linux/quota.h      |    2 ++
 include/uapi/linux/quota.h |    6 ++++--
 5 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 8f0acef..a02bb68 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1159,8 +1159,8 @@ static int need_print_warning(struct dquot_warn *warn)
 			return uid_eq(current_fsuid(), warn->w_dq_id.uid);
 		case GRPQUOTA:
 			return in_group_p(warn->w_dq_id.gid);
-		case PRJQUOTA:	/* Never taken... Just make gcc happy */
-			return 0;
+		case PRJQUOTA:
+			return 1;
 	}
 	return 0;
 }
@@ -1399,6 +1399,9 @@ static void __dquot_initialize(struct inode *inode, int type)
 	/* First get references to structures we might need. */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		struct kqid qid;
+		kprojid_t projid;
+		int rc;
+
 		got[cnt] = NULL;
 		if (type != -1 && cnt != type)
 			continue;
@@ -1409,6 +1412,10 @@ static void __dquot_initialize(struct inode *inode, int type)
 		 */
 		if (i_dquot(inode)[cnt])
 			continue;
+
+		if (!sb_has_quota_active(sb, cnt))
+			continue;
+
 		init_needed = 1;
 
 		switch (cnt) {
@@ -1418,6 +1425,12 @@ static void __dquot_initialize(struct inode *inode, int type)
 		case GRPQUOTA:
 			qid = make_kqid_gid(inode->i_gid);
 			break;
+		case PRJQUOTA:
+			rc = inode->i_sb->dq_op->get_projid(inode, &projid);
+			if (rc)
+				continue;
+			qid = make_kqid_projid(projid);
+			break;
 		}
 		got[cnt] = dqget(sb, qid);
 	}
@@ -2161,7 +2174,8 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		error = -EROFS;
 		goto out_fmt;
 	}
-	if (!sb->s_op->quota_write || !sb->s_op->quota_read) {
+	if (!sb->s_op->quota_write || !sb->s_op->quota_read ||
+	    (type == PRJQUOTA && sb->dq_op->get_projid == NULL)) {
 		error = -EINVAL;
 		goto out_fmt;
 	}
@@ -2402,8 +2416,19 @@ static void do_get_dqblk(struct dquot *dquot, struct fs_disk_quota *di)
 
 	memset(di, 0, sizeof(*di));
 	di->d_version = FS_DQUOT_VERSION;
-	di->d_flags = dquot->dq_id.type == USRQUOTA ?
-			FS_USER_QUOTA : FS_GROUP_QUOTA;
+	switch (dquot->dq_id.type) {
+	case USRQUOTA:
+		di->d_flags = FS_USER_QUOTA;
+		break;
+	case GRPQUOTA:
+		di->d_flags = FS_GROUP_QUOTA;
+		break;
+	case PRJQUOTA:
+		di->d_flags = FS_PROJ_QUOTA;
+		break;
+	default:
+		BUG();
+	}
 	di->d_id = from_kqid_munged(current_user_ns(), dquot->dq_id);
 
 	spin_lock(&dq_data_lock);
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 2aa4151..33b30b1 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -30,7 +30,10 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
 	case Q_XGETQSTATV:
 	case Q_XQUOTASYNC:
 		break;
-	/* allow to query information for dquots we "own" */
+	/*
+	 * allow to query information for dquots we "own"
+	 * always allow querying project quota
+	 */
 	case Q_GETQUOTA:
 	case Q_XGETQUOTA:
 		if ((type == USRQUOTA && uid_eq(current_euid(), make_kuid(current_user_ns(), id))) ||
diff --git a/fs/quota/quotaio_v2.h b/fs/quota/quotaio_v2.h
index f1966b4..4e95430 100644
--- a/fs/quota/quotaio_v2.h
+++ b/fs/quota/quotaio_v2.h
@@ -13,12 +13,14 @@
  */
 #define V2_INITQMAGICS {\
 	0xd9c01f11,	/* USRQUOTA */\
-	0xd9c01927	/* GRPQUOTA */\
+	0xd9c01927,	/* GRPQUOTA */\
+	0xd9c03f14,	/* PRJQUOTA */\
 }
 
 #define V2_INITQVERSIONS {\
 	1,		/* USRQUOTA */\
-	1		/* GRPQUOTA */\
+	1,		/* GRPQUOTA */\
+	1,		/* PRJQUOTA */\
 }
 
 /* First generic header */
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 50978b7..ba51f7e 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -50,6 +50,7 @@
 
 #undef USRQUOTA
 #undef GRPQUOTA
+#undef PRJQUOTA
 enum quota_type {
 	USRQUOTA = 0,		/* element used for user quotas */
 	GRPQUOTA = 1,		/* element used for group quotas */
@@ -317,6 +318,7 @@ struct dquot_operations {
 	/* get reserved quota for delayed alloc, value returned is managed by
 	 * quota code only */
 	qsize_t *(*get_reserved_space) (struct inode *);
+	int (*get_projid) (struct inode *, kprojid_t *);/* Get project ID */
 };
 
 struct path;
diff --git a/include/uapi/linux/quota.h b/include/uapi/linux/quota.h
index 3b6cfbe..b2d9486 100644
--- a/include/uapi/linux/quota.h
+++ b/include/uapi/linux/quota.h
@@ -36,11 +36,12 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 
-#define __DQUOT_VERSION__	"dquot_6.5.2"
+#define __DQUOT_VERSION__	"dquot_6.6.0"
 
-#define MAXQUOTAS 2
+#define MAXQUOTAS 3
 #define USRQUOTA  0		/* element used for user quotas */
 #define GRPQUOTA  1		/* element used for group quotas */
+#define PRJQUOTA  2		/* element used for project quotas */
 
 /*
  * Definitions for the default names of the quotas files.
@@ -48,6 +49,7 @@
 #define INITQFNAMES { \
 	"user",    /* USRQUOTA */ \
 	"group",   /* GRPQUOTA */ \
+	"project", /* PRJQUOTA */ \
 	"undefined", \
 };
 
-- 
1.7.1

