From: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [v15 2/4] ext4: adds project quota support
Date: Sun, 13 Sep 2015 21:20:31 +0900
Message-ID: <1442146833-13652-3-git-send-email-lixi@ddn.com>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442146833-13652-1-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch adds mount options for enabling/disabling project quota
accounting and enforcement. A new specific inode is also used for
project quota accounting.

Signed-off-by: Li Xi <lixi-LfVdkaOWEx8@public.gmane.org>
Signed-off-by: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Reviewed-by: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/ext4/ext4.h  |    5 ++-
 fs/ext4/super.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 96d6e4c..9efbb4b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1184,7 +1184,8 @@ struct ext4_super_block {
 	__u8	s_encrypt_algos[4];	/* Encryption algorithms in use  */
 	__u8	s_encrypt_pw_salt[16];	/* Salt used for string2key algorithm */
 	__le32	s_lpf_ino;		/* Location of the lost+found inode */
-	__le32	s_reserved[100];	/* Padding to the end of the block */
+	__le32	s_prj_quota_inum;	/* inode for tracking project quota */
+	__le32	s_reserved[99];		/* Padding to the end of the block */
 	__le32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -1207,7 +1208,7 @@ struct ext4_super_block {
 #endif
 
 /* Number of quota types we support */
-#define EXT4_MAXQUOTAS 2
+#define EXT4_MAXQUOTAS 3
 
 /*
  * fourth extended-fs super-block data in memory
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d07445e..4040263 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1063,8 +1063,8 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
 }
 
 #ifdef CONFIG_QUOTA
-#define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
-#define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
+static char *quotatypes[] = INITQFNAMES;
+#define QTYPE2NAME(t) (quotatypes[t])
 
 static int ext4_write_dquot(struct dquot *dquot);
 static int ext4_acquire_dquot(struct dquot *dquot);
@@ -4012,7 +4012,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_qcop = &dquot_quotactl_sysfile_ops;
 	else
 		sb->s_qcop = &ext4_qctl_operations;
-	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
+	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
 #endif
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 
@@ -5145,6 +5145,46 @@ restore_opts:
 	return err;
 }
 
+static int ext4_statfs_project(struct super_block *sb,
+			       kprojid_t projid, struct kstatfs *buf)
+{
+	struct kqid qid;
+	struct dquot *dquot;
+	u64 limit;
+	u64 curblock;
+
+	qid = make_kqid_projid(projid);
+	dquot = dqget(sb, qid);
+	if (!dquot)
+		return -ESRCH;
+	spin_lock(&dq_data_lock);
+
+	limit = dquot->dq_dqb.dqb_bsoftlimit ?
+		dquot->dq_dqb.dqb_bsoftlimit :
+		dquot->dq_dqb.dqb_bhardlimit;
+	if (limit && buf->f_blocks * buf->f_bsize > limit) {
+		curblock = dquot->dq_dqb.dqb_curspace / buf->f_bsize;
+		buf->f_blocks = limit / buf->f_bsize;
+		buf->f_bfree = buf->f_bavail =
+			(buf->f_blocks > curblock) ?
+			 (buf->f_blocks - curblock) : 0;
+	}
+
+	limit = dquot->dq_dqb.dqb_isoftlimit ?
+		dquot->dq_dqb.dqb_isoftlimit :
+		dquot->dq_dqb.dqb_ihardlimit;
+	if (limit && buf->f_files > limit) {
+		buf->f_files = limit;
+		buf->f_ffree =
+			(buf->f_files > dquot->dq_dqb.dqb_curinodes) ?
+			 (buf->f_files - dquot->dq_dqb.dqb_curinodes) : 0;
+	}
+
+	spin_unlock(&dq_data_lock);
+	dqput(dquot);
+	return 0;
+}
+
 static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
@@ -5153,6 +5193,7 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	ext4_fsblk_t overhead = 0, resv_blocks;
 	u64 fsid;
 	s64 bfree;
+	struct inode *inode = dentry->d_inode;
 	resv_blocks = EXT4_C2B(sbi, atomic64_read(&sbi->s_resv_clusters));
 
 	if (!test_opt(sb, MINIX_DF))
@@ -5177,6 +5218,9 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
 
+	if (ext4_test_inode_flag(inode, EXT4_INODE_PROJINHERIT) &&
+	    sb_has_quota_limits_enabled(sb, PRJQUOTA))
+		ext4_statfs_project(sb, EXT4_I(inode)->i_projid, buf);
 	return 0;
 }
 
@@ -5341,7 +5385,8 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 	struct inode *qf_inode;
 	unsigned long qf_inums[EXT4_MAXQUOTAS] = {
 		le32_to_cpu(EXT4_SB(sb)->s_es->s_usr_quota_inum),
-		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum)
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum),
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum)
 	};
 
 	BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA));
@@ -5369,7 +5414,8 @@ static int ext4_enable_quotas(struct super_block *sb)
 	int type, err = 0;
 	unsigned long qf_inums[EXT4_MAXQUOTAS] = {
 		le32_to_cpu(EXT4_SB(sb)->s_es->s_usr_quota_inum),
-		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum)
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum),
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum)
 	};
 
 	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE;
-- 
1.7.1
