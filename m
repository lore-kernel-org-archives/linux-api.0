From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] statxat: AFS: Return enhanced basic attributes [ver #2]
Date: Tue, 12 Nov 2013 18:41:50 +0000
Message-ID: <20131112184150.2880.25803.stgit@warthog.procyon.org.uk>
References: <20131112184127.2880.24025.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20131112184127.2880.24025.stgit@warthog.procyon.org.uk>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
To: viro@ZenIV.linux.org.uk
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, libc-alpha@sourceware.org, linux-api@vger.kernel.org, andreas.gruenbacher@gmail.com, samba-technical@lists.samba.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Return enhanced basic attributes from the AFS filesystem.  This includes the
following:

 (1) The data version number as st_data_version.

 (2) STATX_INFO_AUTOMOUNT will be set on automount directories by virtue of
     S_AUTOMOUNT being set on the inode.  These are referrals to other volumes
     or other cells.

 (3) STATX_INFO_AUTODIR on a directory that does cell lookup for non-existent
     names and mounts them (typically mounted on /afs with -o autocell).  The
     resulting directories are marked STATX_INFO_FABRICATED as they do not
     actually exist in the mounted AFS directory.

 (4) Files, directories and symlinks accessed over AFS are marked
     STATX_INFO_REMOTE.  Local fake directories are marked
     STATX_INFO_FABRICATED.

 (5) STATX_INFO_NONSYSTEM_OWNERSHIP is set as the UID and GID retrieved from an
     AFS share may not be applicable on the system.

and also some auxiliary data:

 (6) The volume ID and type.

 (7) The volume name.

 (8) The cell name.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/inode.c |   46 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index ce25d755b7aa..5789f68abbea 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -71,9 +71,9 @@ static int afs_inode_map_status(struct afs_vnode *vnode, struct key *key)
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
@@ -374,16 +374,46 @@ error_unlock:
 /*
  * read the attributes of an inode
  */
-int afs_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		      struct kstat *stat)
+int afs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 {
-	struct inode *inode;
-
-	inode = dentry->d_inode;
+	struct inode *inode = dentry->d_inode;
 
 	_enter("{ ino=%lu v=%u }", inode->i_ino, inode->i_generation);
 
 	generic_fillattr(inode, stat);
+
+	stat->result_mask &= ~(STATX_ATIME | STATX_CTIME | STATX_BLOCKS);
+	stat->result_mask |= STATX_VERSION;
+	stat->version = inode->i_version;
+
+	if (test_bit(AFS_VNODE_AUTOCELL, &AFS_FS_I(inode)->flags))
+		stat->information |= STATX_INFO_AUTODIR;
+
+	if (test_bit(AFS_VNODE_PSEUDODIR, &AFS_FS_I(inode)->flags))
+		stat->information |= STATX_INFO_FABRICATED;
+	else
+		stat->information |= STATX_INFO_REMOTE;
+
+	stat->information |= STATX_INFO_NONSYSTEM_OWNERSHIP;
+
+	if (stat->auxinfo) {
+		struct afs_super_info *as = inode->i_sb->s_fs_info;
+		struct statx_auxinfo *aux = stat->auxinfo;
+
+		aux->sx_fsid = as->volume->vid;
+		/* construct a volume ID from the AFS volume ID and type */
+		aux->sx_volume_id[0] = as->volume->vid >> 24;
+		aux->sx_volume_id[1] = as->volume->vid >> 16;
+		aux->sx_volume_id[2] = as->volume->vid >> 8;
+		aux->sx_volume_id[3] = as->volume->vid >> 0;
+		aux->sx_volume_id[4] = as->volume->type;
+
+		strcpy(aux->sx_volume_name, as->volume->vlocation->vldb.name);
+		strcpy(aux->sx_domain_name, as->volume->cell->name);
+
+		aux->sx_mask = STATX_FSID | STATX_VOLUME_ID |
+			STATX_VOLUME_NAME | STATX_DOMAIN_NAME;
+	}
 	return 0;
 }
 
