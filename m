From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC PATCH 3/3] Btrfs: add support for linkat() AT_REPLACE
Date: Tue, 22 Nov 2016 00:25:03 -0800
Message-ID: <6695444541aecd7a9f2360d9c22293522e7df41d.1479802448.git.osandov@fb.com>
References: <cover.1479802448.git.osandov@fb.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1479802448.git.osandov-b10kYP2dOMg@public.gmane.org>
In-Reply-To: <cover.1479802448.git.osandov-b10kYP2dOMg@public.gmane.org>
References: <cover.1479802448.git.osandov-b10kYP2dOMg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>

The implementation is fairly straightforward and looks a lot like
btrfs_rename().

Signed-off-by: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
---
 fs/btrfs/inode.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8e3a5a2..c903f6d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6566,15 +6566,20 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 }
 
 static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
-		      struct dentry *dentry)
+		      struct dentry *dentry, unsigned int flags)
 {
 	struct btrfs_trans_handle *trans = NULL;
+	unsigned int trans_num_items;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct inode *inode = d_inode(old_dentry);
+	struct inode *new_inode = d_inode(dentry);
 	u64 index;
 	int err;
 	int drop_inode = 0;
 
+	if (flags & ~AT_REPLACE)
+		return -EINVAL;
+
 	/* do not allow sys_link's with other subvols of the same device */
 	if (root->objectid != BTRFS_I(inode)->root->objectid)
 		return -EXDEV;
@@ -6582,16 +6587,47 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (inode->i_nlink >= BTRFS_LINK_MAX)
 		return -EMLINK;
 
+	/* check for collisions, even if the  name isn't there */
+	err = btrfs_check_dir_item_collision(root, dir->i_ino,
+					     dentry->d_name.name,
+					     dentry->d_name.len);
+	if (err) {
+		if (err == -EEXIST) {
+			if (WARN_ON(!new_inode))
+				return err;
+		} else {
+			return err;
+		}
+	}
+
+	/*
+	 * we're using link to replace one file with another. Start IO on it now
+	 * so we don't add too much work to the end of the transaction
+	 */
+	if (new_inode && S_ISREG(inode->i_mode) && new_inode->i_size)
+		filemap_flush(inode->i_mapping);
+
 	err = btrfs_set_inode_index(dir, &index);
 	if (err)
 		goto fail;
 
 	/*
+	 * For the source:
 	 * 2 items for inode and inode ref
 	 * 2 items for dir items
 	 * 1 item for parent inode
+	 *
+	 * For the target:
+	 * 1 for the possible orphan item
+	 * 1 for the dir item
+	 * 1 for the dir index
+	 * 1 for the inode ref
+	 * 1 for the inode
 	 */
-	trans = btrfs_start_transaction(root, 5);
+	trans_num_items = 5;
+	if (new_inode)
+		trans_num_items += 5;
+	trans = btrfs_start_transaction(root, trans_num_items);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
 		trans = NULL;
@@ -6603,6 +6639,21 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	inc_nlink(inode);
 	inode_inc_iversion(inode);
 	inode->i_ctime = current_time(inode);
+
+	if (new_inode) {
+		inode_inc_iversion(new_inode);
+		new_inode->i_ctime = current_time(new_inode);
+		err = btrfs_unlink_inode(trans, root, dir, new_inode,
+					 dentry->d_name.name,
+					 dentry->d_name.len);
+		if (!err && new_inode->i_nlink == 0)
+			err = btrfs_orphan_add(trans, new_inode);
+		if (err) {
+			btrfs_abort_transaction(trans, err);
+			goto fail;
+		}
+	}
+
 	ihold(inode);
 	set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
 
@@ -6624,7 +6675,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 			if (err)
 				goto fail;
 		}
-		d_instantiate(dentry, inode);
+		d_replace(dentry, inode);
 		btrfs_log_new_name(trans, inode, NULL, parent);
 	}
 
@@ -10570,7 +10621,7 @@ static const struct inode_operations btrfs_dir_inode_operations = {
 	.lookup		= btrfs_lookup,
 	.create		= btrfs_create,
 	.unlink		= btrfs_unlink,
-	.link		= btrfs_link,
+	.link2		= btrfs_link,
 	.mkdir		= btrfs_mkdir,
 	.rmdir		= btrfs_rmdir,
 	.rename		= btrfs_rename2,
-- 
2.10.2
