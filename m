From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC 5/6] ext4: adds project quota support
Date: Wed, 11 Feb 2015 18:11:52 +0300
Message-ID: <20150211151152.6717.27431.stgit@buzz>
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

This patch adds mount options for enabling/disabling project quota
accounting and enforcement. A new specific inode is also used for
project quota accounting.

[ Mostly unchanged patch from Li Xi <lixi@ddn.com> ]

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Li Xi <lixi@ddn.com>
---
 fs/ext4/ext4.h  |    8 ++++++--
 fs/ext4/inode.c |   12 +++++++++++-
 fs/ext4/super.c |   53 ++++++++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 59 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a3fdbb5..da153c3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -208,6 +208,7 @@ struct ext4_io_submit {
 #define EXT4_UNDEL_DIR_INO	 6	/* Undelete directory inode */
 #define EXT4_RESIZE_INO		 7	/* Reserved group descriptors inode */
 #define EXT4_JOURNAL_INO	 8	/* Journal inode */
+#define EXT4_PRJ_QUOTA_INO	 9	/* Project quota inode */
 
 /* First non-reserved inode for old ext4 filesystems */
 #define EXT4_GOOD_OLD_FIRST_INO	11
@@ -983,6 +984,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_DIOREAD_NOLOCK	0x400000 /* Enable support for dio read nolocking */
 #define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
+#define EXT4_MOUNT_PRJQUOTA		0x2000000 /* Project quota support */
 #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
 #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
 #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
@@ -1158,7 +1160,8 @@ struct ext4_super_block {
 	__le32	s_grp_quota_inum;	/* inode for tracking group quota */
 	__le32	s_overhead_clusters;	/* overhead blocks/clusters in fs */
 	__le32	s_backup_bgs[2];	/* groups with sparse_super2 SBs */
-	__le32	s_reserved[106];	/* Padding to the end of the block */
+	__le32	s_prj_quota_inum;	/* inode for tracking project quota */
+	__le32	s_reserved[105];	/* Padding to the end of the block */
 	__le32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -1173,7 +1176,7 @@ struct ext4_super_block {
 #define EXT4_MF_FS_ABORTED	0x0002	/* Fatal error detected */
 
 /* Number of quota types we support */
-#define EXT4_MAXQUOTAS 2
+#define EXT4_MAXQUOTAS 3
 
 /*
  * fourth extended-fs super-block data in memory
@@ -1365,6 +1368,7 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 		ino == EXT4_BOOT_LOADER_INO ||
 		ino == EXT4_JOURNAL_INO ||
 		ino == EXT4_RESIZE_INO ||
+		ino == EXT4_PRJ_QUOTA_INO ||
 		(ino >= EXT4_FIRST_INO(sb) &&
 		 ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0ae2c39..966bad1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3894,9 +3894,18 @@ int ext4_set_projid(struct inode *inode, kprojid_t projid)
 	if (projid_eq(EXT4_I(inode)->i_projid, projid))
 		return 0;
 
-	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
+	dquot_initialize(inode);
+
+	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1 +
+					EXT4_QUOTA_INIT_BLOCKS(sb) +
+					EXT4_QUOTA_DEL_BLOCKS(sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
+
+	err = dquot_transfer_project(inode, projid);
+	if (err)
+		goto out;
+
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
 	if (!err) {
 		inode->i_ctime = ext4_current_time(inode);
@@ -3905,6 +3914,7 @@ int ext4_set_projid(struct inode *inode, kprojid_t projid)
 	}
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
+out:
 	ext4_journal_stop(handle);
 
 	return err;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d656269..3637eef 100644
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
@@ -1123,10 +1123,11 @@ enum {
 	Opt_journal_path, Opt_journal_checksum, Opt_journal_async_commit,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
 	Opt_data_err_abort, Opt_data_err_ignore,
-	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
+	Opt_usrjquota, Opt_grpjquota, Opt_prjjquota,
+	Opt_offusrjquota, Opt_offgrpjquota, Opt_offprjjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
 	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
-	Opt_usrquota, Opt_grpquota, Opt_i_version,
+	Opt_usrquota, Opt_grpquota, Opt_prjquota, Opt_i_version,
 	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
 	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
@@ -1178,6 +1179,8 @@ static const match_table_t tokens = {
 	{Opt_usrjquota, "usrjquota=%s"},
 	{Opt_offgrpjquota, "grpjquota="},
 	{Opt_grpjquota, "grpjquota=%s"},
+	{Opt_offprjjquota, "prjjquota="},
+	{Opt_prjjquota, "prjjquota=%s"},
 	{Opt_jqfmt_vfsold, "jqfmt=vfsold"},
 	{Opt_jqfmt_vfsv0, "jqfmt=vfsv0"},
 	{Opt_jqfmt_vfsv1, "jqfmt=vfsv1"},
@@ -1185,6 +1188,7 @@ static const match_table_t tokens = {
 	{Opt_noquota, "noquota"},
 	{Opt_quota, "quota"},
 	{Opt_usrquota, "usrquota"},
+	{Opt_prjquota, "prjquota"},
 	{Opt_barrier, "barrier=%u"},
 	{Opt_barrier, "barrier"},
 	{Opt_nobarrier, "nobarrier"},
@@ -1399,12 +1403,17 @@ static const struct mount_opts {
 							MOPT_SET | MOPT_Q},
 	{Opt_grpquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_GRPQUOTA,
 							MOPT_SET | MOPT_Q},
+	{Opt_prjquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_PRJQUOTA,
+							MOPT_SET | MOPT_Q},
 	{Opt_noquota, (EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA |
-		       EXT4_MOUNT_GRPQUOTA), MOPT_CLEAR | MOPT_Q},
+		       EXT4_MOUNT_GRPQUOTA | EXT4_MOUNT_PRJQUOTA),
+							MOPT_CLEAR | MOPT_Q},
 	{Opt_usrjquota, 0, MOPT_Q},
 	{Opt_grpjquota, 0, MOPT_Q},
+	{Opt_prjjquota, 0, MOPT_Q},
 	{Opt_offusrjquota, 0, MOPT_Q},
 	{Opt_offgrpjquota, 0, MOPT_Q},
+	{Opt_offprjjquota, 0, MOPT_Q},
 	{Opt_jqfmt_vfsold, QFMT_VFS_OLD, MOPT_QFMT},
 	{Opt_jqfmt_vfsv0, QFMT_VFS_V0, MOPT_QFMT},
 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
@@ -1427,10 +1436,14 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		return set_qf_name(sb, USRQUOTA, &args[0]);
 	else if (token == Opt_grpjquota)
 		return set_qf_name(sb, GRPQUOTA, &args[0]);
+	else if (token == Opt_prjjquota)
+		return set_qf_name(sb, PRJQUOTA, &args[0]);
 	else if (token == Opt_offusrjquota)
 		return clear_qf_name(sb, USRQUOTA);
 	else if (token == Opt_offgrpjquota)
 		return clear_qf_name(sb, GRPQUOTA);
+	else if (token == Opt_offprjjquota)
+		return clear_qf_name(sb, PRJQUOTA);
 #endif
 	switch (token) {
 	case Opt_noacl:
@@ -1656,19 +1669,28 @@ static int parse_options(char *options, struct super_block *sb,
 	}
 #ifdef CONFIG_QUOTA
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
-	    (test_opt(sb, USRQUOTA) || test_opt(sb, GRPQUOTA))) {
+	    (test_opt(sb, USRQUOTA) ||
+	     test_opt(sb, GRPQUOTA) ||
+	     test_opt(sb, PRJQUOTA))) {
 		ext4_msg(sb, KERN_ERR, "Cannot set quota options when QUOTA "
 			 "feature is enabled");
 		return 0;
 	}
-	if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
+	if (sbi->s_qf_names[USRQUOTA] ||
+	    sbi->s_qf_names[GRPQUOTA] ||
+	    sbi->s_qf_names[PRJQUOTA]) {
 		if (test_opt(sb, USRQUOTA) && sbi->s_qf_names[USRQUOTA])
 			clear_opt(sb, USRQUOTA);
 
 		if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
 			clear_opt(sb, GRPQUOTA);
 
-		if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA)) {
+		if (test_opt(sb, PRJQUOTA) && sbi->s_qf_names[PRJQUOTA])
+			clear_opt(sb, PRJQUOTA);
+
+		if (test_opt(sb, GRPQUOTA) ||
+		    test_opt(sb, USRQUOTA) ||
+		    test_opt(sb, PRJQUOTA)) {
 			ext4_msg(sb, KERN_ERR, "old and new quota "
 					"format mixing");
 			return 0;
@@ -1728,6 +1750,9 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
 
 	if (sbi->s_qf_names[GRPQUOTA])
 		seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
+
+	if (sbi->s_qf_names[PRJQUOTA])
+		seq_printf(seq, ",prjjquota=%s", sbi->s_qf_names[PRJQUOTA]);
 #endif
 }
 
@@ -3928,6 +3953,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	else
 		sb->s_qcop = &ext4_qctl_operations;
 	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
+		sb->s_quota_types = QTYPE_MASK_PRJ;
 #endif
 	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 
@@ -5145,7 +5172,9 @@ static int ext4_mark_dquot_dirty(struct dquot *dquot)
 
 	/* Are we journaling quotas? */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) ||
-	    sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
+	    sbi->s_qf_names[USRQUOTA] ||
+	    sbi->s_qf_names[GRPQUOTA] ||
+	    sbi->s_qf_names[PRJQUOTA]) {
 		dquot_mark_dquot_dirty(dquot);
 		return ext4_write_dquot(dquot);
 	} else {
@@ -5229,7 +5258,8 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 	struct inode *qf_inode;
 	unsigned long qf_inums[EXT4_MAXQUOTAS] = {
 		le32_to_cpu(EXT4_SB(sb)->s_es->s_usr_quota_inum),
-		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum)
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum),
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum)
 	};
 
 	BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA));
@@ -5257,7 +5287,8 @@ static int ext4_enable_quotas(struct super_block *sb)
 	int type, err = 0;
 	unsigned long qf_inums[EXT4_MAXQUOTAS] = {
 		le32_to_cpu(EXT4_SB(sb)->s_es->s_usr_quota_inum),
-		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum)
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum),
+		le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum)
 	};
 
 	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE;
