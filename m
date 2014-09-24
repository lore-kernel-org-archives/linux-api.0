From: Li Xi <pkuelelixi@gmail.com>
Subject: [PATCH 1/4] Adds general codes to enforces project quota limits
Date: Wed, 24 Sep 2014 22:04:27 +0800
Message-ID: <1411567470-31799-2-git-send-email-lixi@ddn.com>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1411567470-31799-1-git-send-email-lixi@ddn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

This patch adds support for a new quota type PRJQUOTA for project quota
enforcement. Also a new method get_projid() is added into dquot_operations
structure.

Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/quota/dquot.c           |   16 ++++++++++++++--
 fs/quota/quota.c           |    5 ++++-
 fs/quota/quotaio_v2.h      |    6 ++++--
 include/linux/quota.h      |    2 ++
 include/uapi/linux/quota.h |    6 ++++--
 5 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index f2d0eee..8d0c270 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1154,8 +1154,8 @@ static int need_print_warning(struct dquot_warn *warn)
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
@@ -1394,6 +1394,9 @@ static void __dquot_initialize(struct inode *inode, int type)
 	/* First get references to structures we might need. */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		struct kqid qid;
+		kprojid_t projid;
+		int rc;
+
 		got[cnt] = NULL;
 		if (type != -1 && cnt != type)
 			continue;
@@ -1413,6 +1416,15 @@ static void __dquot_initialize(struct inode *inode, int type)
 		case GRPQUOTA:
 			qid = make_kqid_gid(inode->i_gid);
 			break;
+		case PRJQUOTA:
+			/* Project ID is not supported */
+			if (!inode->i_sb->dq_op->get_projid)
+				continue;
+			rc = inode->i_sb->dq_op->get_projid(inode, &projid);
+			if (rc)
+				continue;
+			qid = make_kqid_projid(projid);
+			break;
 		}
 		got[cnt] = dqget(sb, qid);
 	}
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 7562164..cce7371 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -30,7 +30,10 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
 	case Q_XGETQSTATV:
 	case Q_XQUOTASYNC:
 		break;
-	/* allow to query information for dquots we "own" */
+	/*
+	 * allow to query information for dquots we "own"
+	 * always allow quota check for project quota
+	 */
 	case Q_GETQUOTA:
 	case Q_XGETQUOTA:
 		if ((type == USRQUOTA && uid_eq(current_euid(), make_kuid(current_user_ns(), id))) ||
diff --git a/fs/quota/quotaio_v2.h b/fs/quota/quotaio_v2.h
index f1966b4..b17af05 100644
--- a/fs/quota/quotaio_v2.h
+++ b/fs/quota/quotaio_v2.h
@@ -13,12 +13,14 @@
  */
 #define V2_INITQMAGICS {\
 	0xd9c01f11,	/* USRQUOTA */\
-	0xd9c01927	/* GRPQUOTA */\
+	0xd9c01927,	/* GRPQUOTA */\
+	0xd9c03f14	/* PRJQUOTA */\
 }
 
 #define V2_INITQVERSIONS {\
 	1,		/* USRQUOTA */\
-	1		/* GRPQUOTA */\
+	1,		/* GRPQUOTA */\
+	1		/* PRJQUOTA */\
 }
 
 /* First generic header */
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 80d345a..f1b25f8 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -50,6 +50,7 @@
 
 #undef USRQUOTA
 #undef GRPQUOTA
+#undef PRJQUOTA
 enum quota_type {
 	USRQUOTA = 0,		/* element used for user quotas */
 	GRPQUOTA = 1,		/* element used for group quotas */
@@ -312,6 +313,7 @@ struct dquot_operations {
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

