From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR promotion
Date: Mon, 4 Jan 2016 10:05:34 +1100
Message-ID: <20160103230534.GE6682@dastard>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
 <1442146833-13652-4-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442146833-13652-4-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Sun, Sep 13, 2015 at 09:20:32PM +0900, Li Xi wrote:
> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
> support for ext4. The interface is kept consistent with
> XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.
> 
> Signed-off-by: Li Xi <lixi@ddn.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Reviewed-by: Jan Kara <jack@suse.cz>

We need to split this into two patches - one to move the ioctl
definition to the VFS layer, the other for all the ext4 changes to
use it.

This is the way we've done such changes in the past because
it impacts on unrelated userspace code (e.g. xfsprogs shares
libxfs/xfs_fs.h) and so these changes have to be specificallly
propagated and handled in userspace as there will be systems that
have the new xfs_fs.h but the old uapi/linux/fs.h and so xfsprogs
compilation will break. Hence the UAPI change needs to be separate
to new users of the API.

Having a separate patch also means multiple dev trees can carry the
same API change - that will solve the problem that I have
conflicting patches in XFS that add new flags to this ioctl (e.g.
for per-inode DAX and per-inode lazytime).

I've attached a patch below that is just the UAPI change. If no-one
objects, I'll commit this to the XFS tree for the upcoming merge
window....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR promotion

From: Dave Chinner <dchinner@redhat.com>

Hoist the ioctl definitions for the XFS_IOC_FS[SG]SETXATTR API from
fs/xfs/libxfs/xfs_fs.h to include/uapi/linux/fs.h so that the ioctls
can be used by all filesystems, not just XFS. This enables
(initially) ext4 to use the ioctl to set project IDs on inodes.

Based-on-patch-from: Li Xi <lixi@ddn.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_fs.h  | 51 +++++++++++++++++--------------------------------
 include/uapi/linux/fs.h | 32 +++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b2b73a9..743d913 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -36,38 +36,23 @@ struct dioattr {
 #endif
 
 /*
- * Structure for XFS_IOC_FSGETXATTR[A] and XFS_IOC_FSSETXATTR.
+ * Flags for the bs_xflags/fsx_xflags field in FS_IOC_FS[GS]ETXATTR[A]
  */
-#ifndef HAVE_FSXATTR
-struct fsxattr {
-	__u32		fsx_xflags;	/* xflags field value (get/set) */
-	__u32		fsx_extsize;	/* extsize field value (get/set)*/
-	__u32		fsx_nextents;	/* nextents field value (get)	*/
-	__u32		fsx_projid;	/* project identifier (get/set) */
-	unsigned char	fsx_pad[12];
-};
-#endif
-
-/*
- * Flags for the bs_xflags/fsx_xflags field
- * There should be a one-to-one correspondence between these flags and the
- * XFS_DIFLAG_s.
- */
-#define XFS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
-#define XFS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
-#define XFS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
-#define XFS_XFLAG_APPEND	0x00000010	/* all writes append */
-#define XFS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
-#define XFS_XFLAG_NOATIME	0x00000040	/* do not update access time */
-#define XFS_XFLAG_NODUMP	0x00000080	/* do not include in backups */
-#define XFS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
-#define XFS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
-#define XFS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
-#define XFS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
-#define XFS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
-#define XFS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
-#define XFS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
-#define XFS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
+#define	XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME
+#define	XFS_XFLAG_PREALLOC	FS_XFLAG_PREALLOC
+#define	XFS_XFLAG_IMMUTABLE	FS_XFLAG_IMMUTABLE
+#define	XFS_XFLAG_APPEND	FS_XFLAG_APPEND
+#define	XFS_XFLAG_SYNC		FS_XFLAG_SYNC
+#define	XFS_XFLAG_NOATIME	FS_XFLAG_NOATIME
+#define	XFS_XFLAG_NODUMP	FS_XFLAG_NODUMP
+#define	XFS_XFLAG_RTINHERIT	FS_XFLAG_RTINHERIT
+#define	XFS_XFLAG_PROJINHERIT	FS_XFLAG_PROJINHERIT
+#define	XFS_XFLAG_NOSYMLINKS	FS_XFLAG_NOSYMLINKS
+#define	XFS_XFLAG_EXTSIZE	FS_XFLAG_EXTSIZE
+#define	XFS_XFLAG_EXTSZINHERIT	FS_XFLAG_EXTSZINHERIT
+#define	XFS_XFLAG_NODEFRAG	FS_XFLAG_NODEFRAG
+#define	XFS_XFLAG_FILESTREAM	FS_XFLAG_FILESTREAM
+#define	XFS_XFLAG_HASATTR	FS_XFLAG_HASATTR
 
 /*
  * Structure for XFS_IOC_GETBMAP.
@@ -514,8 +499,8 @@ typedef struct xfs_swapext
 #define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
 #define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
 #define XFS_IOC_DIOINFO		_IOR ('X', 30, struct dioattr)
-#define XFS_IOC_FSGETXATTR	_IOR ('X', 31, struct fsxattr)
-#define XFS_IOC_FSSETXATTR	_IOW ('X', 32, struct fsxattr)
+#define XFS_IOC_FSGETXATTR	FS_IOC_FSGETXATTR
+#define XFS_IOC_FSSETXATTR	FS_IOC_FSSETXATTR
 #define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
 #define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
 #define XFS_IOC_GETBMAP		_IOWR('X', 38, struct getbmap)
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index f15d980..880d52e 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -110,6 +110,36 @@ struct inodes_stat_t {
 #define MS_MGC_VAL 0xC0ED0000
 #define MS_MGC_MSK 0xffff0000
 
+/*
+ * Structure for FS_IOC_FSGETXATTR[A] and FS_IOC_FSSETXATTR.
+ */
+struct fsxattr {
+	__u32		fsx_xflags;	/* xflags field value (get/set) */
+	__u32		fsx_extsize;	/* extsize field value (get/set)*/
+	__u32		fsx_nextents;	/* nextents field value (get)	*/
+	__u32		fsx_projid;	/* project identifier (get/set) */
+	unsigned char	fsx_pad[12];
+};
+
+/*
+ * Flags for the fsx_xflags field
+ */
+#define	FS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
+#define	FS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
+#define	FS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
+#define	FS_XFLAG_APPEND		0x00000010	/* all writes append */
+#define	FS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
+#define	FS_XFLAG_NOATIME	0x00000040	/* do not update access time */
+#define	FS_XFLAG_NODUMP		0x00000080	/* do not include in backups */
+#define	FS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
+#define	FS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
+#define	FS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
+#define	FS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
+#define	FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
+#define	FS_XFLAG_NODEFRAG	0x00002000	/* do not defragment */
+#define	FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
+#define	FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
+
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
 
@@ -169,6 +199,8 @@ struct inodes_stat_t {
 #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
 #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
 #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
+#define FS_IOC_FSGETXATTR		_IOR ('X', 31, struct fsxattr)
+#define FS_IOC_FSSETXATTR		_IOW ('X', 32, struct fsxattr)
 
 /*
  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
