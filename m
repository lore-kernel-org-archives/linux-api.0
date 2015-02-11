From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC 4/6] ext4: add project id support
Date: Wed, 11 Feb 2015 18:11:50 +0300
Message-ID: <20150211151150.6717.68740.stgit@buzz>
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

This patch adds a new internal field of ext4 inode to save project identifier.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 fs/ext4/ext4.h   |   13 ++++++++++-
 fs/ext4/ialloc.c |    6 +++++
 fs/ext4/inode.c  |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/namei.c  |   14 ++++++++++++
 fs/ext4/super.c  |    2 ++
 5 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a75fba6..a3fdbb5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -683,6 +683,7 @@ struct ext4_inode {
 	__le32  i_crtime;       /* File Creation time */
 	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
 	__le32  i_version_hi;	/* high 32 bits for 64-bit version */
+	__le32  i_projid;	/* Project ID */
 };
 
 struct move_extent {
@@ -938,6 +939,7 @@ struct ext4_inode_info {
 
 	/* Precomputed uuid+inum+igen checksum for seeding inode checksums */
 	__u32 i_csum_seed;
+	kprojid_t i_projid;
 };
 
 /*
@@ -1522,6 +1524,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
  * GDT_CSUM bits are mutually exclusive.
  */
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
+#define EXT4_FEATURE_RO_COMPAT_PROJECT		0x1000 /* Project ID */
 
 #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
@@ -1571,7 +1574,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
 					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_QUOTA)
+					 EXT4_FEATURE_RO_COMPAT_QUOTA |\
+					 EXT4_FEATURE_RO_COMPAT_PROJECT)
 
 /*
  * Default values for user and/or group using reserved blocks
@@ -1579,6 +1583,11 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define	EXT4_DEF_RESUID		0
 #define	EXT4_DEF_RESGID		0
 
+/*
+ * Default project ID
+ */
+#define	EXT4_DEF_PROJID		0
+
 #define EXT4_DEF_INODE_READAHEAD_BLKS	32
 
 /*
@@ -2131,6 +2140,8 @@ extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t lend);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
+extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
+extern int ext4_set_projid(struct inode *inode, kprojid_t projid);
 extern void ext4_da_update_reserve_space(struct inode *inode,
 					int used, int quota_claim);
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index ac644c3..d81a30d 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -756,6 +756,12 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 		inode->i_gid = dir->i_gid;
 	} else
 		inode_init_owner(inode, dir, mode);
+
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
+		ei->i_projid = EXT4_I(dir)->i_projid;
+	else
+		ei->i_projid = KPROJIDT_INIT(EXT4_DEF_PROJID);
+
 	dquot_initialize(inode);
 
 	if (!goal)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5653fa4..0ae2c39 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3863,6 +3863,53 @@ static inline void ext4_iget_extra_inode(struct inode *inode,
 		EXT4_I(inode)->i_inline_off = 0;
 }
 
+int ext4_get_projid(struct inode *inode, kprojid_t *projid)
+{
+	struct super_block *sb = inode->i_sb;
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
+		return -EOPNOTSUPP;
+
+	*projid = EXT4_I(inode)->i_projid;
+	return 0;
+}
+
+/* Called with inode->i_mutex locked. */
+int ext4_set_projid(struct inode *inode, kprojid_t projid)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ext4_inode *raw_inode;
+	struct ext4_iloc iloc;
+	handle_t *handle;
+	int err;
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
+		return -EOPNOTSUPP;
+
+	/* Sanity check */
+	if (EXT4_INODE_SIZE(sb) <= EXT4_GOOD_OLD_INODE_SIZE ||
+	    !EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), i_projid))
+		return -EOPNOTSUPP;
+
+	if (projid_eq(EXT4_I(inode)->i_projid, projid))
+		return 0;
+
+	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+	err = ext4_reserve_inode_write(handle, inode, &iloc);
+	if (!err) {
+		inode->i_ctime = ext4_current_time(inode);
+		EXT4_I(inode)->i_projid = projid;
+		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
+	}
+	if (IS_SYNC(inode))
+		ext4_handle_sync(handle);
+	ext4_journal_stop(handle);
+
+	return err;
+}
+
 struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 {
 	struct ext4_iloc iloc;
@@ -3874,6 +3921,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	int block;
 	uid_t i_uid;
 	gid_t i_gid;
+	projid_t i_projid;
 
 	inode = iget_locked(sb, ino);
 	if (!inode)
@@ -3923,12 +3971,20 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
 	i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
 	i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
+
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT) &&
+	    EXT4_FITS_IN_INODE(raw_inode, ei, i_projid))
+		i_projid = (projid_t)le32_to_cpu(raw_inode->i_projid);
+	else
+		i_projid = EXT4_DEF_PROJID;
+
 	if (!(test_opt(inode->i_sb, NO_UID32))) {
 		i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
 		i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
 	i_uid_write(inode, i_uid);
 	i_gid_write(inode, i_gid);
+	ei->i_projid = KPROJIDT_INIT(i_projid);
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 
 	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
@@ -4192,6 +4248,15 @@ static int ext4_do_update_inode(handle_t *handle,
 		raw_inode->i_uid_high = 0;
 		raw_inode->i_gid_high = 0;
 	}
+
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT) &&
+	    EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)) {
+		projid_t i_projid;
+
+		i_projid = from_kprojid(&init_user_ns, ei->i_projid);
+		raw_inode->i_projid = cpu_to_le32(i_projid);
+	}
+
 	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
 
 	EXT4_INODE_SET_XTIME(i_ctime, inode, raw_inode);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2291923..9337d81 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2938,6 +2938,10 @@ static int ext4_link(struct dentry *old_dentry,
 	if (inode->i_nlink >= EXT4_LINK_MAX)
 		return -EMLINK;
 
+	if (!capable_mix_inode_project(EXT4_I(dir)->i_projid,
+				       EXT4_I(inode)->i_projid))
+		return -EXDEV;
+
 	dquot_initialize(dir);
 
 retry:
@@ -3217,6 +3221,10 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int credits;
 	u8 old_file_type;
 
+	if (!capable_mix_inode_project(EXT4_I(new.dir)->i_projid,
+				       EXT4_I(old.inode)->i_projid))
+		return -EXDEV;
+
 	dquot_initialize(old.dir);
 	dquot_initialize(new.dir);
 
@@ -3395,6 +3403,12 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	u8 new_file_type;
 	int retval;
 
+	if (!capable_mix_inode_project(EXT4_I(new.dir)->i_projid,
+				       EXT4_I(old.inode)->i_projid) ||
+	    !capable_mix_inode_project(EXT4_I(old.dir)->i_projid,
+				       EXT4_I(new.inode)->i_projid))
+		return -EXDEV;
+
 	dquot_initialize(old.dir);
 	dquot_initialize(new.dir);
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ac64edb..d656269 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1103,6 +1103,8 @@ static const struct super_operations ext4_sops = {
 	.get_dquots	= ext4_get_dquots,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+	.get_projid	= ext4_get_projid,
+	.set_projid	= ext4_set_projid,
 };
 
 static const struct export_operations ext4_export_ops = {
