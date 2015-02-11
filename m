From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC 2/6] quota: adds generic code for enforcing project
 quota limits
Date: Wed, 11 Feb 2015 18:11:48 +0300
Message-ID: <20150211151148.6717.23016.stgit@buzz>
References: <20150211151146.6717.62017.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150211151146.6717.62017.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Linux API <linux-api@vger.kernel.org>, containers@lists.linux-foundation.org, Dave Chinner <david@fromorbit.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>, Dmitry Monakhov <dmonakhov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Li Xi <pkuelelixi@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

This patch adds support for a new quota type PRJQUOTA for project quota.
[ Based on patch by Li Xi <lixi@ddn.com> ]

Permissions:
Q_GETQUOTA: allows to query all projects present in current user-namespace
Q_SETQUOTA: requires system-wide capability CAP_SYS_ADMIN

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Li Xi <lixi@ddn.com>
---
 fs/quota/dquot.c           |   37 +++++++++++++++++++++++++++++++++++--
 fs/quota/quota.c           |    8 ++++++--
 fs/quota/quotaio_v2.h      |    6 ++++--
 include/linux/quota.h      |    1 +
 include/linux/quotaops.h   |    1 +
 include/uapi/linux/quota.h |    6 ++++--
 6 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 0ccd4ba..afa5f67 100644
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
@@ -1399,6 +1399,8 @@ static void __dquot_initialize(struct inode *inode, int type)
 	/* First get references to structures we might need. */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		struct kqid qid;
+		kprojid_t projid;
+
 		got[cnt] = NULL;
 		if (type != -1 && cnt != type)
 			continue;
@@ -1409,6 +1411,10 @@ static void __dquot_initialize(struct inode *inode, int type)
 		 */
 		if (i_dquot(inode)[cnt])
 			continue;
+
+		if (!sb_has_quota_active(sb, cnt))
+			continue;
+
 		init_needed = 1;
 
 		switch (cnt) {
@@ -1418,6 +1424,13 @@ static void __dquot_initialize(struct inode *inode, int type)
 		case GRPQUOTA:
 			qid = make_kqid_gid(inode->i_gid);
 			break;
+		case PRJQUOTA:
+			if (!sb->s_op->get_projid)
+				continue;
+			if (sb->s_op->get_projid(inode, &projid))
+				continue;
+			qid = make_kqid_projid(projid);
+			break;
 		}
 		got[cnt] = dqget(sb, qid);
 	}
@@ -1951,6 +1964,22 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 EXPORT_SYMBOL(dquot_transfer);
 
 /*
+ * Helper function for transferring inode into another project.
+ */
+int dquot_transfer_project(struct inode *inode, kprojid_t projid)
+{
+	struct dquot *transfer_to[MAXQUOTAS] = {};
+	struct super_block *sb = inode->i_sb;
+	int ret;
+
+	transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(projid));
+	ret = __dquot_transfer(inode, transfer_to);
+	dqput_all(transfer_to);
+	return ret;
+}
+EXPORT_SYMBOL(dquot_transfer_project);
+
+/*
  * Write info of quota file to disk
  */
 int dquot_commit_info(struct super_block *sb, int type)
@@ -2165,6 +2194,10 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		error = -EINVAL;
 		goto out_fmt;
 	}
+	if (type == PRJQUOTA && !sb->s_op->get_projid) {
+		error = -EINVAL;
+		goto out_fmt;
+	}
 	/* Usage always has to be set... */
 	if (!(flags & DQUOT_USAGE_ENABLED)) {
 		error = -EINVAL;
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index d14a799..0acd1bb 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -30,11 +30,15 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
 	case Q_XGETQSTATV:
 	case Q_XQUOTASYNC:
 		break;
-	/* allow to query information for dquots we "own" */
+	/*
+	 * Allow to query information for user/group dquots we "own".
+	 * Allow querying project quota present in our user-namespace.
+	 */
 	case Q_GETQUOTA:
 	case Q_XGETQUOTA:
 		if ((type == USRQUOTA && uid_eq(current_euid(), make_kuid(current_user_ns(), id))) ||
-		    (type == GRPQUOTA && in_egroup_p(make_kgid(current_user_ns(), id))))
+		    (type == GRPQUOTA && in_egroup_p(make_kgid(current_user_ns(), id))) ||
+		    (type == PRJQUOTA && projid_valid(make_kprojid(current_user_ns(), id))))
 			break;
 		/*FALLTHROUGH*/
 	default:
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
index d534e8e..8bad159 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -50,6 +50,7 @@
 
 #undef USRQUOTA
 #undef GRPQUOTA
+#undef PRJQUOTA
 enum quota_type {
 	USRQUOTA = 0,		/* element used for user quotas */
 	GRPQUOTA = 1,		/* element used for group quotas */
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index df73258..ba54745 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -104,6 +104,7 @@ int dquot_set_dqblk(struct super_block *sb, struct kqid id,
 
 int __dquot_transfer(struct inode *inode, struct dquot **transfer_to);
 int dquot_transfer(struct inode *inode, struct iattr *iattr);
+int dquot_transfer_project(struct inode *inode, kprojid_t projid);
 
 static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
 {
diff --git a/include/uapi/linux/quota.h b/include/uapi/linux/quota.h
index 1f49b83..9c95b2c 100644
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
 
