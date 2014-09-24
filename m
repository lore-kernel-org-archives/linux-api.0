From: Li Xi <pkuelelixi@gmail.com>
Subject: [PATCH 2/4] Adds project ID support for ext4
Date: Wed, 24 Sep 2014 22:04:28 +0800
Message-ID: <1411567470-31799-3-git-send-email-lixi@ddn.com>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <1411567470-31799-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

This patch adds a new internal field of ext4 inode to save project
identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
inheriting project ID from parent directory.

Signed-off-by: Li Xi <lixi@ddn.com>
---
 fs/ext4/ext4.h   |   21 +++++++++++++++++----
 fs/ext4/ialloc.c |    6 ++++++
 fs/ext4/inode.c  |   29 ++++++++++++++++++++++++++++-
 fs/ext4/namei.c  |   10 ++++++++++
 fs/ext4/super.c  |    1 +
 5 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1eb5b7b..092f60c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -386,16 +386,18 @@ struct flex_groups {
 #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
 #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
 #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data. */
+#define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
 #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
 
-#define EXT4_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
-#define EXT4_FL_USER_MODIFIABLE		0x004380FF /* User modifiable flags */
+#define EXT4_FL_USER_VISIBLE		0x204BDFFF /* User visible flags */
+#define EXT4_FL_USER_MODIFIABLE		0x204380FF /* User modifiable flags */
 
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
 			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
 			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
-			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
+			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL |\
+			   EXT4_PROJINHERIT_FL)
 
 /* Flags that are appropriate for regular files (all but dir-specific ones). */
 #define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
@@ -443,6 +445,7 @@ enum {
 	EXT4_INODE_EA_INODE	= 21,	/* Inode used for large EA */
 	EXT4_INODE_EOFBLOCKS	= 22,	/* Blocks allocated beyond EOF */
 	EXT4_INODE_INLINE_DATA	= 28,	/* Data in inode. */
+	EXT4_INODE_PROJINHERIT	= 29,	/* Create with parents projid */
 	EXT4_INODE_RESERVED	= 31,	/* reserved for ext4 lib */
 };
 
@@ -694,6 +697,7 @@ struct ext4_inode {
 	__le32  i_crtime;       /* File Creation time */
 	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
 	__le32  i_version_hi;	/* high 32 bits for 64-bit version */
+	__le32  i_projid;	/* Project ID */
 };
 
 struct move_extent {
@@ -943,6 +947,7 @@ struct ext4_inode_info {
 
 	/* Precomputed uuid+inum+igen checksum for seeding inode checksums */
 	__u32 i_csum_seed;
+	kprojid_t i_projid;
 };
 
 /*
@@ -1526,6 +1531,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
  * GDT_CSUM bits are mutually exclusive.
  */
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
+#define EXT4_FEATURE_RO_COMPAT_PROJECT		0x1000 /* Project quota */
 
 #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
@@ -1575,7 +1581,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
 					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_QUOTA)
+					 EXT4_FEATURE_RO_COMPAT_QUOTA |\
+					 EXT4_FEATURE_RO_COMPAT_PROJECT)
 
 /*
  * Default values for user and/or group using reserved blocks
@@ -1583,6 +1590,11 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define	EXT4_DEF_RESUID		0
 #define	EXT4_DEF_RESGID		0
 
+/*
+ * Default project ID
+ */
+#define	EXT4_DEF_PROJID		0
+
 #define EXT4_DEF_INODE_READAHEAD_BLKS	32
 
 /*
@@ -2134,6 +2146,7 @@ extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t lend);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
+extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
 extern void ext4_da_update_reserve_space(struct inode *inode,
 					int used, int quota_claim);
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 5b87fc3..b6b7284 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -756,6 +756,12 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 		inode->i_gid = dir->i_gid;
 	} else
 		inode_init_owner(inode, dir, mode);
+	if (ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) {
+		ei->i_projid = EXT4_I(dir)->i_projid;
+	} else {
+		ei->i_projid =
+			make_kprojid(&init_user_ns, EXT4_DEF_PROJID);
+	}
 	dquot_initialize(inode);
 
 	if (!goal)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d5dd7d4..8c641eb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3874,6 +3874,24 @@ static inline void ext4_iget_extra_inode(struct inode *inode,
 		EXT4_I(inode)->i_inline_off = 0;
 }
 
+static projid_t ext4_inode_projid_get(struct inode *inode, struct ext4_inode *raw,
+				 struct ext4_inode_info *ei)
+{
+	return (projid_t)le32_to_cpu(raw->i_projid);
+}
+
+static void ext4_inode_projid_set(struct inode *inode, struct ext4_inode *raw,
+				 struct ext4_inode_info *ei, projid_t projid)
+{
+	raw->i_projid = cpu_to_le32(projid);
+}
+
+int ext4_get_projid(struct inode *inode, kprojid_t *projid)
+{
+	*projid = EXT4_I(inode)->i_projid;
+	return 0;
+}
+
 struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 {
 	struct ext4_iloc iloc;
@@ -3885,6 +3903,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	int block;
 	uid_t i_uid;
 	gid_t i_gid;
+	projid_t i_projid;
 
 	inode = iget_locked(sb, ino);
 	if (!inode)
@@ -3935,12 +3954,15 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
 	i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
 	i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
+	i_projid = ext4_inode_projid_get(inode, raw_inode, ei);
+
 	if (!(test_opt(inode->i_sb, NO_UID32))) {
 		i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
 		i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
 	i_uid_write(inode, i_uid);
 	i_gid_write(inode, i_gid);
+	ei->i_projid = make_kprojid(&init_user_ns, i_projid);;
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 
 	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
@@ -4163,6 +4185,7 @@ static int ext4_do_update_inode(handle_t *handle,
 	int need_datasync = 0, set_large_file = 0;
 	uid_t i_uid;
 	gid_t i_gid;
+	projid_t i_projid;
 
 	spin_lock(&ei->i_raw_lock);
 
@@ -4175,6 +4198,7 @@ static int ext4_do_update_inode(handle_t *handle,
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	i_uid = i_uid_read(inode);
 	i_gid = i_gid_read(inode);
+	i_projid = from_kprojid(&init_user_ns, ei->i_projid);
 	if (!(test_opt(inode->i_sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(i_uid));
 		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(i_gid));
@@ -4204,7 +4228,8 @@ static int ext4_do_update_inode(handle_t *handle,
 	EXT4_INODE_SET_XTIME(i_atime, inode, raw_inode);
 	EXT4_EINODE_SET_XTIME(i_crtime, ei, raw_inode);
 
-	if (ext4_inode_blocks_set(handle, raw_inode, ei)) {
+	err = ext4_inode_blocks_set(handle, raw_inode, ei);
+	if (err) {
 		spin_unlock(&ei->i_raw_lock);
 		goto out_brelse;
 	}
@@ -4255,6 +4280,8 @@ static int ext4_do_update_inode(handle_t *handle,
 
 	ext4_inode_csum_set(inode, raw_inode, ei);
 
+	ext4_inode_projid_set(inode, raw_inode, ei, i_projid);
+
 	spin_unlock(&ei->i_raw_lock);
 
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 51705f8..1a9e557 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2944,6 +2944,11 @@ static int ext4_link(struct dentry *old_dentry,
 	if (inode->i_nlink >= EXT4_LINK_MAX)
 		return -EMLINK;
 
+	if ((ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) &&
+	    (!projid_eq(EXT4_I(dir)->i_projid,
+			EXT4_I(old_dentry->d_inode)->i_projid)))
+		return -EXDEV;
+
 	dquot_initialize(dir);
 
 retry:
@@ -3186,6 +3191,11 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int force_reread;
 	int retval;
 
+	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT)) &&
+	    (!projid_eq(EXT4_I(new_dir)->i_projid,
+		EXT4_I(old_dentry->d_inode)->i_projid)))
+		return -EXDEV;
+
 	dquot_initialize(old.dir);
 	dquot_initialize(new.dir);
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2632017..8c3e87b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1080,6 +1080,7 @@ static const struct dquot_operations ext4_quota_operations = {
 	.write_info	= ext4_write_info,
 	.alloc_dquot	= dquot_alloc,
 	.destroy_dquot	= dquot_destroy,
+	.get_projid	= ext4_get_projid,
 };
 
 static const struct quotactl_ops ext4_qctl_operations = {
-- 
1.7.1

