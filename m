From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/4] statx: NFS: Return enhanced file attributes [ver #3]
Date: Wed, 23 Nov 2016 00:56:06 +0000
Message-ID: <147986256611.19139.1662089024935161714.stgit@warthog.procyon.org.uk>
References: <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Return enhanced file atrributes from the NFS filesystem.  This includes the
following:

 (1) STATX_ATTR_AUTOMOUNT is set on referral or submount directories that
     are automounted upon.  NFS shows one directory with a different FSID,
     but the local VFS has two: the mountpoint directory (fabricated) and
     the root of the filesystem mounted upon it.

Furthermore, what nfs_getattr() does can be controlled as follows:

 (1) If AT_STATX_DONT_SYNC is indicated then this will suppress the
     flushing of outstanding writes and the rereading of the inode's
     attributes with the server as detailed below.

 (2) Otherwise:

     (a) If AT_STATX_FORCE_SYNC is indicated, or mtime or ctime are
     	 requested then the outstanding writes will be written to the
     	 server first.

     (b) The inode's attributes will be reread from the server:

     	 (i) if AT_STATX_FORCE_SYNC is indicated;

        (ii) if atime is requested (and atime updating is not suppressed by
     	     a mount flag); or

       (iii) if the cached attributes have expired;

If the inode isn't synchronised, then the cached attributes will be used -
even if expired - without reference to the server.

Example output:

	[root@andromeda ~]# ./samples/statx/test-statx /warthog/
	statx(/warthog/) = 0
	results=17ff
	  Size: 4096            Blocks: 8          IO Block: 1048576  directory
	Device: 00:26           Inode: 2           Links: 21
	Access: (0555/dr-xr-xr-x)  Uid:     0   Gid:     0
	Access: 2016-11-14 11:49:14.582749262+0000
	Modify: 2016-09-08 20:39:46.785788707+0100
	Change: 2016-09-08 20:39:46.785788707+0100
	IO-blocksize: blksize=1048576

Note that the NFS4 protocol potentially provides a creation time that could
be passed through this interface and system, hidden and archive values that
could be passed as attributes.  There is also a backup time that could be
exposed.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/inode.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index bf4ec5ecc97e..3002350d4a84 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -656,12 +656,20 @@ static bool nfs_need_revalidate_inode(struct inode *inode)
 int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 {
 	struct inode *inode = d_inode(dentry);
-	int need_atime = NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATIME;
+	unsigned int sync_type = stat->query_flags & AT_STATX_SYNC_TYPE;
+	bool need_atime = NFS_I(inode)->cache_validity & NFS_INO_INVALID_ATIME;
 	int err = 0;
 
 	trace_nfs_getattr_enter(inode);
-	/* Flush out writes to the server in order to update c/mtime.  */
-	if (S_ISREG(inode->i_mode)) {
+
+	/* Flush out writes to the server in order to update c/mtime if the
+	 * user wants them.
+	 */
+	if (sync_type != AT_STATX_DONT_SYNC &&
+	    S_ISREG(inode->i_mode) &&
+	    (sync_type == AT_STATX_FORCE_SYNC ||
+	     (stat->request_mask & (STATX_MTIME | STATX_CTIME)))
+	    ) {
 		err = filemap_write_and_wait(inode->i_mapping);
 		if (err)
 			goto out;
@@ -676,11 +684,15 @@ int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	 *  - NFS never sets MS_NOATIME or MS_NODIRATIME so there is
 	 *    no point in checking those.
 	 */
- 	if ((mnt->mnt_flags & MNT_NOATIME) ||
- 	    ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode)))
-		need_atime = 0;
-
-	if (need_atime || nfs_need_revalidate_inode(inode)) {
+	if (!(stat->request_mask & STATX_ATIME) ||
+	    (mnt->mnt_flags & MNT_NOATIME) ||
+	    ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode)))
+		need_atime = false;
+
+	if (sync_type != AT_STATX_DONT_SYNC &&
+	    (sync_type == AT_STATX_FORCE_SYNC ||
+	     need_atime ||
+	     nfs_need_revalidate_inode(inode))) {
 		struct nfs_server *server = NFS_SERVER(inode);
 
 		if (server->caps & NFS_CAP_READDIRPLUS)
@@ -693,6 +705,10 @@ int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 		if (S_ISDIR(inode->i_mode))
 			stat->blksize = NFS_SERVER(inode)->dtsize;
 	}
+
+	generic_fillattr(inode, stat);
+	stat->ino = nfs_compat_user_ino64(NFS_FILEID(inode));
+
 out:
 	trace_nfs_getattr_exit(inode, err);
 	return err;
