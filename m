From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC PATCH v4 4/4] Btrfs: add support for linkat() AT_REPLACE
Date: Wed, 29 Jan 2020 00:58:34 -0800
Message-ID: <55e3795a385177f13cde7041fe7a5e1644994879.1580251857.git.osandov__4266.88523018441$1580288349$gmane$org@fb.com>
References: <cover.1580251857.git.osandov@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1580251857.git.osandov-b10kYP2dOMg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: kernel-team-b10kYP2dOMg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xi Wang <xi-GmWTxIRN22iJaUV4rX00uodd74u8MsAO@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>

The implementation is fairly straightforward and looks a lot like
btrfs_rename(). The only tricky bit is that instead of playing games
with the dcache, we simply drop the dentry for it to be instantiated on
the next lookup. This can be improved in the future.

Signed-off-by: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
---
 fs/btrfs/inode.c | 63 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8c9a114f48f6..b489671d1b5d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6762,14 +6762,16 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		      struct dentry *dentry, int flags)
 {
 	struct btrfs_trans_handle *trans = NULL;
+	unsigned int trans_num_items;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct inode *inode = d_inode(old_dentry);
+	struct inode *new_inode = d_inode(dentry);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 index;
 	int err;
 	int drop_inode = 0;
 
-	if (flags)
+	if (flags & ~AT_LINK_REPLACE)
 		return -EINVAL;
 
 	/* do not allow sys_link's with other subvols of the same device */
@@ -6779,17 +6781,50 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	if (inode->i_nlink >= BTRFS_LINK_MAX)
 		return -EMLINK;
 
+	/* check for collisions, even if the name isn't there */
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
 	err = btrfs_set_inode_index(BTRFS_I(dir), &index);
 	if (err)
 		goto fail;
 
 	/*
+	 * For the source:
 	 * 2 items for inode and inode ref
 	 * 2 items for dir items
 	 * 1 item for parent inode
 	 * 1 item for orphan item deletion if O_TMPFILE
+	 *
+	 * For the target:
+	 * 1 for the possible orphan item
+	 * 1 for the dir item
+	 * 1 for the dir index
+	 * 1 for the inode ref
+	 * 1 for the inode
 	 */
-	trans = btrfs_start_transaction(root, inode->i_nlink ? 5 : 6);
+	trans_num_items = 5;
+	if (!inode->i_nlink)
+		trans_num_items++;
+	if (new_inode)
+		trans_num_items += 5;
+	trans = btrfs_start_transaction(root, trans_num_items);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
 		trans = NULL;
@@ -6801,6 +6836,22 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	inc_nlink(inode);
 	inode_inc_iversion(inode);
 	inode->i_ctime = current_time(inode);
+
+	if (new_inode) {
+		inode_inc_iversion(new_inode);
+		new_inode->i_ctime = current_time(new_inode);
+		err = btrfs_unlink_inode(trans, root, BTRFS_I(dir),
+					 BTRFS_I(new_inode),
+					 dentry->d_name.name,
+					 dentry->d_name.len);
+		if (!err && new_inode->i_nlink == 0)
+			err = btrfs_orphan_add(trans, BTRFS_I(new_inode));
+		if (err) {
+			btrfs_abort_transaction(trans, err);
+			goto fail;
+		}
+	}
+
 	set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
 
 	err = btrfs_add_nondir(trans, BTRFS_I(dir), dentry, BTRFS_I(inode),
@@ -6824,8 +6875,12 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 			if (err)
 				goto fail;
 		}
-		ihold(inode);
-		d_instantiate(dentry, inode);
+		if (new_inode) {
+			d_drop(dentry);
+		} else {
+			ihold(inode);
+			d_instantiate(dentry, inode);
+		}
 		ret = btrfs_log_new_name(trans, BTRFS_I(inode), NULL, parent,
 					 true, NULL);
 		if (ret == BTRFS_NEED_TRANS_COMMIT) {
-- 
2.25.0
