From: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC PATCH v4 3/4] Btrfs: fix inode reference count leak in btrfs_link() error path
Date: Wed, 29 Jan 2020 00:58:33 -0800
Message-ID: <885829e37b0cdf75e26f4605e34110a7b23fe162.1580251857.git.osandov__29984.3434871704$1580288344$gmane$org@fb.com>
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

If btrfs_update_inode() or btrfs_orphan_del() fails in btrfs_link(),
then we don't drop the reference we got with ihold(). This results in
the "VFS: Busy inodes after unmount" crash.

The reference is needed for the new dentry, so get it right before we
instantiate the dentry.

Fixes: 79787eaab461 ("btrfs: replace many BUG_ONs with proper error handling")
[Although d_instantiate() was moved further from ihold() before that, in
commit 08c422c27f85 ("Btrfs: call d_instantiate after all ops are setup")]
Signed-off-by: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
---
 fs/btrfs/inode.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bc7709c4f6eb..8c9a114f48f6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6801,7 +6801,6 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	inc_nlink(inode);
 	inode_inc_iversion(inode);
 	inode->i_ctime = current_time(inode);
-	ihold(inode);
 	set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
 
 	err = btrfs_add_nondir(trans, BTRFS_I(dir), dentry, BTRFS_I(inode),
@@ -6825,6 +6824,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 			if (err)
 				goto fail;
 		}
+		ihold(inode);
 		d_instantiate(dentry, inode);
 		ret = btrfs_log_new_name(trans, BTRFS_I(inode), NULL, parent,
 					 true, NULL);
@@ -6837,10 +6837,8 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 fail:
 	if (trans)
 		btrfs_end_transaction(trans);
-	if (drop_inode) {
+	if (drop_inode)
 		inode_dec_link_count(inode);
-		iput(inode);
-	}
 	btrfs_btree_balance_dirty(fs_info);
 	return err;
 }
-- 
2.25.0
