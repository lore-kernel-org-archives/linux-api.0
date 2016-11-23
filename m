From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/4] statx: AFS: Return enhanced file attributes [ver #3]
Date: Wed, 23 Nov 2016 00:56:13 +0000
Message-ID: <147986257312.19139.10417237189956494459.stgit@warthog.procyon.org.uk>
References: <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <147986254484.19139.8038609825799670925.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Return enhanced file attributes from the AFS filesystem.  This includes the
following:

 (1) STATX_ATTR_AUTOMOUNT will be set on automount directories by virtue of
     S_AUTOMOUNT being set on the inode.  These are referrals to other
     volumes or other cells.

STATX_ATIME, STATX_CTIME and STATX_BLOCKS are cleared as AFS does not
support them.

Example output:

	[root@andromeda ~]# ./samples/statx/test-statx /afs
	statx(/afs) = 0
	results=7ef
	  Size: 2048            Blocks: 0          IO Block: 4096    directory
	Device: 00:25           Inode: 1           Links: 2
	Access: (0777/drwxrwxrwx)  Uid:     0   Gid:     0
	Access: 2006-05-07 00:21:15.000000000+0100
	Modify: 2006-05-07 00:21:15.000000000+0100
	Change: 2006-05-07 00:21:15.000000000+0100
	IO-blocksize: blksize=4096

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 fs/afs/inode.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 86cc7264c21c..99662045b6fb 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -72,9 +72,9 @@ static int afs_inode_map_status(struct afs_vnode *vnode, struct key *key)
 	inode->i_uid		= vnode->status.owner;
 	inode->i_gid		= GLOBAL_ROOT_GID;
 	inode->i_size		= vnode->status.size;
-	inode->i_ctime.tv_sec	= vnode->status.mtime_server;
-	inode->i_ctime.tv_nsec	= 0;
-	inode->i_atime		= inode->i_mtime = inode->i_ctime;
+	inode->i_mtime.tv_sec	= vnode->status.mtime_server;
+	inode->i_mtime.tv_nsec	= 0;
+	inode->i_atime		= inode->i_ctime = inode->i_mtime;
 	inode->i_blocks		= 0;
 	inode->i_generation	= vnode->fid.unique;
 	inode->i_version	= vnode->status.data_version;
@@ -375,8 +375,7 @@ int afs_validate(struct afs_vnode *vnode, struct key *key)
 /*
  * read the attributes of an inode
  */
-int afs_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		      struct kstat *stat)
+int afs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 {
 	struct inode *inode;
 
@@ -385,6 +384,8 @@ int afs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	_enter("{ ino=%lu v=%u }", inode->i_ino, inode->i_generation);
 
 	generic_fillattr(inode, stat);
+
+	stat->result_mask &= ~(STATX_ATIME | STATX_CTIME | STATX_BLOCKS);
 	return 0;
 }
 
