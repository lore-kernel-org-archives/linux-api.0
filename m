From: Li Xi <pkuelelixi@gmail.com>
Subject: [v13 3/5] ext4: adds project quota support
Date: Mon, 20 Apr 2015 10:39:46 +0900
Message-ID: <1429493988-16819-4-git-send-email-lixi@ddn.com>
References: <1429493988-16819-1-git-send-email-lixi@ddn.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1429493988-16819-1-git-send-email-lixi@ddn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

This patch adds mount options for enabling/disabling project quota
accounting and enforcement. A new specific inode is also used for
project quota accounting.

Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  |    6 +++-
 fs/ext4/super.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1446c4f..a7acf10 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1169,7 +1169,8 @@ struct ext4_super_block {
 	__le32	s_overhead_clusters;	/* overhead blocks/clusters in fs */
 	__le32	s_backup_bgs[2];	/* groups with sparse_super2 SBs */
 	__u8	s_encrypt_algos[4];	/* Encryption algorithms in use  */
-	__le32	s_reserved[105];	/* Padding to the end of the block */
+	__le32  s_prj_quota_inum;       /* inode for tracking project quota */
+	__le32	s_reserved[104];	/* Padding to the end of the block */
 	__le32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -1184,7 +1185,7 @@ struct ext4_super_block {
 #define EXT4_MF_FS_ABORTED	0x0002	/* Fatal error detected */
 
 /* Number of quota types we support */
-#define EXT4_MAXQUOTAS 2
+#define EXT4_MAXQUOTAS 3
 
 /*
  * fourth extended-fs super-block data in memory
@@ -1376,6 +1377,7 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 		ino == EXT4_BOOT_LOADER_INO ||
 		ino == EXT4_JOURNAL_INO ||
 		ino == EXT4_RESIZE_INO ||
+		ino == le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum) ||
 		(ino >= EXT4_FIRST_INO(sb) &&
 		 ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 04c6cc3..476e46f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1036,8 +1036,8 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
 }
 
 #ifdef CONFIG_QUOTA
-#define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
-#define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
+static char *quotatypes[] = INITQFNAMES;
+#define QTYPE2NAME(t) (quotatypes[t])
 
 static int ext4_write_dquot(struct dquot *dquot);
 static int ext4_acquire_dquot(struct dquot *dquot);
@@ -3944,7 +3944,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_qcop = &ext4_qctl_sysfile_operations;
 	else
 		sb->s_qcop = &ext4_qctl_operations;
-	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
+	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
 #endif
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 
@@ -5040,6 +5040,46 @@ restore_opts:
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
@@ -5048,6 +5088,7 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	ext4_fsblk_t overhead = 0, resv_blocks;
 	u64 fsid;
 	s64 bfree;
+	struct inode *inode = dentry->d_inode;
 	resv_blocks = EXT4_C2B(sbi, atomic64_read(&sbi->s_resv_clusters));
 
 	if (!test_opt(sb, MINIX_DF))
@@ -5072,6 +5113,9 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
 
+	if (ext4_test_inode_flag(inode, EXT4_INODE_PROJINHERIT) &&
+	    sb_has_quota_limits_enabled(sb, PRJQUOTA))
+		ext4_statfs_project(sb, EXT4_I(inode)->i_projid, buf);
 	return 0;
 }
 
@@ -5236,7 +5280,8 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 	struct inode *qf_inode;
 	unsigned long qf_inums[EXT4_MAXQUOTAS] = {
 		le32_to_cpu(EXT4_SB(sb)->s_es->s_usr_quota_inum),
-		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum)
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum),
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum)
 	};
 
 	BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA));
@@ -5264,7 +5309,8 @@ static int ext4_enable_quotas(struct super_block *sb)
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

