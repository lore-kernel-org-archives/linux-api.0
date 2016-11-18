From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/4] statx: AFS: Return enhanced file attributes [ver #2]
Date: Fri, 18 Nov 2016 16:20:59 +0000
Message-ID: <147948605950.5122.17364831884946902464.stgit@warthog.procyon.org.uk>
References: <147948603103.5122.1043337990092830185.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147948603103.5122.1043337990092830185.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
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

Signed-off-by: David Howells <dhowells@redhat.com>
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
 
