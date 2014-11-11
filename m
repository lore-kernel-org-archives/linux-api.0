From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [v6 3/4] ext4: adds project quota support
Date: Tue, 11 Nov 2014 21:34:26 +0100
Message-ID: <20141111203426.GD32298@quack.suse.cz>
References: <1415468619-31851-1-git-send-email-lixi@ddn.com>
 <1415468619-31851-4-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1415468619-31851-4-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun 09-11-14 01:43:38, Li Xi wrote:
> This patch adds mount options for enabling/disabling project quota
> accounting and enforcement. A new specific inode is also used for
> project quota accounting.
> 
> Signed-off-by: Li Xi <lixi-LfVdkaOWEx8@public.gmane.org>
> Signed-off-by: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  fs/ext4/ext4.h  |    8 +++-
>  fs/ext4/super.c |   95 ++++++++++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 90 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index d30dfa6..4c797da 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -217,6 +217,7 @@ struct ext4_io_submit {
>  #define EXT4_UNDEL_DIR_INO	 6	/* Undelete directory inode */
>  #define EXT4_RESIZE_INO		 7	/* Reserved group descriptors inode */
>  #define EXT4_JOURNAL_INO	 8	/* Journal inode */
> +#define EXT4_PRJ_QUOTA_INO	 9	/* Project quota inode */
>  
>  /* First non-reserved inode for old ext4 filesystems */
>  #define EXT4_GOOD_OLD_FIRST_INO	11
> @@ -991,6 +992,7 @@ struct ext4_inode_info {
>  #define EXT4_MOUNT_DIOREAD_NOLOCK	0x400000 /* Enable support for dio read nolocking */
>  #define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
>  #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
> +#define EXT4_MOUNT_PRJQUOTA		0x2000000 /* Project quota support */
>  #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
>  #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
>  #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
> @@ -1166,7 +1168,8 @@ struct ext4_super_block {
>  	__le32	s_grp_quota_inum;	/* inode for tracking group quota */
>  	__le32	s_overhead_clusters;	/* overhead blocks/clusters in fs */
>  	__le32	s_backup_bgs[2];	/* groups with sparse_super2 SBs */
> -	__le32	s_reserved[106];	/* Padding to the end of the block */
> +	__le32	s_prj_quota_inum;	/* inode for tracking project quota */
> +	__le32	s_reserved[105];	/* Padding to the end of the block */
>  	__le32	s_checksum;		/* crc32c(superblock) */
>  };
>  
> @@ -1181,7 +1184,7 @@ struct ext4_super_block {
>  #define EXT4_MF_FS_ABORTED	0x0002	/* Fatal error detected */
>  
>  /* Number of quota types we support */
> -#define EXT4_MAXQUOTAS 2
> +#define EXT4_MAXQUOTAS 3
>  
>  /*
>   * fourth extended-fs super-block data in memory
> @@ -1372,6 +1375,7 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
>  		ino == EXT4_BOOT_LOADER_INO ||
>  		ino == EXT4_JOURNAL_INO ||
>  		ino == EXT4_RESIZE_INO ||
> +		ino == EXT4_PRJ_QUOTA_INO ||
>  		(ino >= EXT4_FIRST_INO(sb) &&
>  		 ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
>  }
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index d8a348d..564fbd7 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1045,8 +1045,8 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
>  }
>  
>  #ifdef CONFIG_QUOTA
> -#define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
> -#define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
> +static char *quotatypes[] = INITQFNAMES;
> +#define QTYPE2NAME(t) (quotatypes[t])
>  
>  static int ext4_write_dquot(struct dquot *dquot);
>  static int ext4_acquire_dquot(struct dquot *dquot);
> @@ -1138,10 +1138,11 @@ enum {
>  	Opt_journal_path, Opt_journal_checksum, Opt_journal_async_commit,
>  	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
>  	Opt_data_err_abort, Opt_data_err_ignore,
> -	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
> +	Opt_usrjquota, Opt_grpjquota, Opt_prjjquota,
> +	Opt_offusrjquota, Opt_offgrpjquota, Opt_offprjjquota,
>  	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
>  	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
> -	Opt_usrquota, Opt_grpquota, Opt_i_version,
> +	Opt_usrquota, Opt_grpquota, Opt_prjquota, Opt_i_version,
>  	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
>  	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
>  	Opt_inode_readahead_blks, Opt_journal_ioprio,
> @@ -1192,6 +1193,8 @@ static const match_table_t tokens = {
>  	{Opt_usrjquota, "usrjquota=%s"},
>  	{Opt_offgrpjquota, "grpjquota="},
>  	{Opt_grpjquota, "grpjquota=%s"},
> +	{Opt_offprjjquota, "prjjquota="},
> +	{Opt_prjjquota, "prjjquota=%s"},
>  	{Opt_jqfmt_vfsold, "jqfmt=vfsold"},
>  	{Opt_jqfmt_vfsv0, "jqfmt=vfsv0"},
>  	{Opt_jqfmt_vfsv1, "jqfmt=vfsv1"},
> @@ -1199,6 +1202,7 @@ static const match_table_t tokens = {
>  	{Opt_noquota, "noquota"},
>  	{Opt_quota, "quota"},
>  	{Opt_usrquota, "usrquota"},
> +	{Opt_prjquota, "prjquota"},
>  	{Opt_barrier, "barrier=%u"},
>  	{Opt_barrier, "barrier"},
>  	{Opt_nobarrier, "nobarrier"},
> @@ -1411,12 +1415,17 @@ static const struct mount_opts {
>  							MOPT_SET | MOPT_Q},
>  	{Opt_grpquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_GRPQUOTA,
>  							MOPT_SET | MOPT_Q},
> +	{Opt_prjquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_PRJQUOTA,
> +							MOPT_SET | MOPT_Q},
>  	{Opt_noquota, (EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA |
> -		       EXT4_MOUNT_GRPQUOTA), MOPT_CLEAR | MOPT_Q},
> +		       EXT4_MOUNT_GRPQUOTA | EXT4_MOUNT_PRJQUOTA),
> +							MOPT_CLEAR | MOPT_Q},
>  	{Opt_usrjquota, 0, MOPT_Q},
>  	{Opt_grpjquota, 0, MOPT_Q},
> +	{Opt_prjjquota, 0, MOPT_Q},
>  	{Opt_offusrjquota, 0, MOPT_Q},
>  	{Opt_offgrpjquota, 0, MOPT_Q},
> +	{Opt_offprjjquota, 0, MOPT_Q},
>  	{Opt_jqfmt_vfsold, QFMT_VFS_OLD, MOPT_QFMT},
>  	{Opt_jqfmt_vfsv0, QFMT_VFS_V0, MOPT_QFMT},
>  	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
> @@ -1439,10 +1448,14 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>  		return set_qf_name(sb, USRQUOTA, &args[0]);
>  	else if (token == Opt_grpjquota)
>  		return set_qf_name(sb, GRPQUOTA, &args[0]);
> +	else if (token == Opt_prjjquota)
> +		return set_qf_name(sb, PRJQUOTA, &args[0]);
>  	else if (token == Opt_offusrjquota)
>  		return clear_qf_name(sb, USRQUOTA);
>  	else if (token == Opt_offgrpjquota)
>  		return clear_qf_name(sb, GRPQUOTA);
> +	else if (token == Opt_offprjjquota)
> +		return clear_qf_name(sb, PRJQUOTA);
>  #endif
>  	switch (token) {
>  	case Opt_noacl:
> @@ -1668,19 +1681,28 @@ static int parse_options(char *options, struct super_block *sb,
>  	}
>  #ifdef CONFIG_QUOTA
>  	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) &&
> -	    (test_opt(sb, USRQUOTA) || test_opt(sb, GRPQUOTA))) {
> +	    (test_opt(sb, USRQUOTA) ||
> +	     test_opt(sb, GRPQUOTA) ||
> +	     test_opt(sb, PRJQUOTA))) {
>  		ext4_msg(sb, KERN_ERR, "Cannot set quota options when QUOTA "
>  			 "feature is enabled");
>  		return 0;
>  	}
> -	if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
> +	if (sbi->s_qf_names[USRQUOTA] ||
> +	    sbi->s_qf_names[GRPQUOTA] ||
> +	    sbi->s_qf_names[PRJQUOTA]) {
>  		if (test_opt(sb, USRQUOTA) && sbi->s_qf_names[USRQUOTA])
>  			clear_opt(sb, USRQUOTA);
>  
>  		if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
>  			clear_opt(sb, GRPQUOTA);
>  
> -		if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA)) {
> +		if (test_opt(sb, PRJQUOTA) && sbi->s_qf_names[PRJQUOTA])
> +			clear_opt(sb, PRJQUOTA);
> +
> +		if (test_opt(sb, GRPQUOTA) ||
> +		    test_opt(sb, USRQUOTA) ||
> +		    test_opt(sb, PRJQUOTA)) {
>  			ext4_msg(sb, KERN_ERR, "old and new quota "
>  					"format mixing");
>  			return 0;
> @@ -1734,6 +1756,9 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
>  
>  	if (sbi->s_qf_names[GRPQUOTA])
>  		seq_printf(seq, ",grpjquota=%s", sbi->s_qf_names[GRPQUOTA]);
> +
> +	if (sbi->s_qf_names[PRJQUOTA])
> +		seq_printf(seq, ",prjjquota=%s", sbi->s_qf_names[PRJQUOTA]);
>  #endif
>  }
>  
> @@ -5030,6 +5055,46 @@ restore_opts:
>  	return err;
>  }
>  
> +static int ext4_statfs_project(struct super_block *sb,
> +			       kprojid_t projid, struct kstatfs *buf)
> +{
> +	struct kqid qid;
> +	struct dquot *dquot;
> +	u64 limit;
> +	u64 curblock;
> +
> +	qid = make_kqid_projid(projid);
> +	dquot = dqget(sb, qid);
> +	if (!dquot)
> +		return -ESRCH;
> +	spin_lock(&dq_data_lock);
> +
> +	limit = dquot->dq_dqb.dqb_bsoftlimit ?
> +		dquot->dq_dqb.dqb_bsoftlimit :
> +		dquot->dq_dqb.dqb_bhardlimit;
> +	if (limit && buf->f_blocks * buf->f_bsize > limit) {
> +		curblock = dquot->dq_dqb.dqb_curspace / buf->f_bsize;
> +		buf->f_blocks = limit / buf->f_bsize;
> +		buf->f_bfree = buf->f_bavail =
> +			(buf->f_blocks > curblock) ?
> +			 (buf->f_blocks - curblock) : 0;
> +	}
> +
> +	limit = dquot->dq_dqb.dqb_isoftlimit ?
> +		dquot->dq_dqb.dqb_isoftlimit :
> +		dquot->dq_dqb.dqb_ihardlimit;
> +	if (limit && buf->f_files > limit) {
> +		buf->f_files = limit;
> +		buf->f_ffree =
> +			(buf->f_files > dquot->dq_dqb.dqb_curinodes) ?
> +			 (buf->f_files - dquot->dq_dqb.dqb_curinodes) : 0;
> +	}
> +
> +	spin_unlock(&dq_data_lock);
> +	dqput(dquot);
> +	return 0;
> +}
> +
>  static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  {
>  	struct super_block *sb = dentry->d_sb;
> @@ -5038,6 +5103,7 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	ext4_fsblk_t overhead = 0, resv_blocks;
>  	u64 fsid;
>  	s64 bfree;
> +	struct inode *inode = dentry->d_inode;
>  	resv_blocks = EXT4_C2B(sbi, atomic64_read(&sbi->s_resv_clusters));
>  
>  	if (!test_opt(sb, MINIX_DF))
> @@ -5062,6 +5128,9 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
>  	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
>  
> +	if (ext4_test_inode_flag(inode, EXT4_INODE_PROJINHERIT) &&
> +	    sb_has_quota_limits_enabled(sb, PRJQUOTA))
> +		ext4_statfs_project(sb, EXT4_I(inode)->i_projid, buf);
>  	return 0;
>  }
>  
> @@ -5142,7 +5211,9 @@ static int ext4_mark_dquot_dirty(struct dquot *dquot)
>  
>  	/* Are we journaling quotas? */
>  	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA) ||
> -	    sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
> +	    sbi->s_qf_names[USRQUOTA] ||
> +	    sbi->s_qf_names[GRPQUOTA] ||
> +	    sbi->s_qf_names[PRJQUOTA]) {
>  		dquot_mark_dquot_dirty(dquot);
>  		return ext4_write_dquot(dquot);
>  	} else {
> @@ -5226,7 +5297,8 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
>  	struct inode *qf_inode;
>  	unsigned long qf_inums[EXT4_MAXQUOTAS] = {
>  		le32_to_cpu(EXT4_SB(sb)->s_es->s_usr_quota_inum),
> -		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum)
> +		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum),
> +		le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum)
>  	};
>  
>  	BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA));
> @@ -5254,7 +5326,8 @@ static int ext4_enable_quotas(struct super_block *sb)
>  	int type, err = 0;
>  	unsigned long qf_inums[EXT4_MAXQUOTAS] = {
>  		le32_to_cpu(EXT4_SB(sb)->s_es->s_usr_quota_inum),
> -		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum)
> +		le32_to_cpu(EXT4_SB(sb)->s_es->s_grp_quota_inum),
> +		le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum)
>  	};
>  
>  	sb_dqopt(sb)->flags |= DQUOT_QUOTA_SYS_FILE;
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
