From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH v2 1/5] orangefs: fix request_mask misuse
Date: Fri, 19 Oct 2018 14:20:45 +0200
Message-ID: <20181019122049.27121-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>, Mike Marshall <hubcap@omnibond.com>
List-Id: linux-api@vger.kernel.org

Orangefs only handles STATX_BASIC_STATS in its getattr implementation, so
mask off all other flags.  Not doing so results in statx(2) forcing a
refresh of cached attributes on any other requested flag (i.e. STATX_BTIME
currently) due to the following test in orangefs_inode_getattr():

  (request_mask & orangefs_inode->getattr_mask) == request_mask

Also clean up gratuitous uses of STATX_ALL.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Reviewed-by: Martin Brandenburg <martin@omnibond.com>
Cc: Mike Marshall <hubcap@omnibond.com>
---
 fs/orangefs/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 31932879b716..bd7f15a831dc 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -256,7 +256,8 @@ int orangefs_getattr(const struct path *path, struct kstat *stat,
 		     "orangefs_getattr: called on %pd\n",
 		     path->dentry);
 
-	ret = orangefs_inode_getattr(inode, 0, 0, request_mask);
+	ret = orangefs_inode_getattr(inode, 0, 0,
+				     request_mask & STATX_BASIC_STATS);
 	if (ret == 0) {
 		generic_fillattr(inode, stat);
 
@@ -408,7 +409,7 @@ struct inode *orangefs_iget(struct super_block *sb,
 	if (!inode || !(inode->i_state & I_NEW))
 		return inode;
 
-	error = orangefs_inode_getattr(inode, 1, 1, STATX_ALL);
+	error = orangefs_inode_getattr(inode, 1, 1, STATX_BASIC_STATS);
 	if (error) {
 		iget_failed(inode);
 		return ERR_PTR(error);
@@ -453,7 +454,7 @@ struct inode *orangefs_new_inode(struct super_block *sb, struct inode *dir,
 	orangefs_set_inode(inode, ref);
 	inode->i_ino = hash;	/* needed for stat etc */
 
-	error = orangefs_inode_getattr(inode, 1, 1, STATX_ALL);
+	error = orangefs_inode_getattr(inode, 1, 1, STATX_BASIC_STATS);
 	if (error)
 		goto out_iput;
 
-- 
2.14.3
