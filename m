From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC v2 4/4] btrfs: verify symlinks with append/immutable flags
Date: Thu, 10 May 2018 16:13:59 -0700
Message-ID: <20180510231359.16899-5-mcgrof@kernel.org>
References: <20180510231359.16899-1-mcgrof@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180510231359.16899-1-mcgrof@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, darrick.wong@oracle.com, tytso@mit.edu, adilger.kernel@dilger.ca, clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: sandeen@sandeen.net, dhowells@redhat.com, fliu@suse.com, jack@suse.cz, jeffm@suse.com, nborisov@suse.com, jake.norris@suse.com, mtk.manpages@gmail.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>
List-Id: linux-api@vger.kernel.org

The Linux VFS does not allow a way to set append/immuttable
attributes to symlinks, this is just not possible. If this is
detected inform the user as the filesystem must be corrupted.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 fs/btrfs/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c4bdb597b323..d9c786be408c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3933,6 +3933,15 @@ static int btrfs_read_locked_inode(struct inode *inode)
 		inode->i_op = &btrfs_dir_inode_operations;
 		break;
 	case S_IFLNK:
+		/* VFS does not allow setting these so must be corruption */
+		if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) {
+			ret = -EUCLEAN;
+			btrfs_crit(fs_info,
+				  "corrupt symlink with append/immutable ino=%llu root=%llu\n",
+				  btrfs_ino(BTRFS_I(inode)),
+				  root->root_key.objectid);
+			goto make_bad;
+		}
 		inode->i_op = &btrfs_symlink_inode_operations;
 		inode_nohighmem(inode);
 		inode->i_mapping->a_ops = &btrfs_symlink_aops;
-- 
2.17.0
