From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [v15 4/4] ext4: cleanup inode flag definitions
Date: Mon, 28 Dec 2015 10:23:34 -0500
Message-ID: <20151228152334.GA31415@thunk.org>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
 <1442146833-13652-5-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442146833-13652-5-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Sep 13, 2015 at 09:20:33PM +0900, Li Xi wrote:
> The inode flags defined in uapi/linux/fs.h were migrated from
> ext4.h. This patch changes the inode flag definitions in ext4.h
> to VFS definitions to make the gaps between them clearer.
> 
> Signed-off-by: Li Xi <lixi-LfVdkaOWEx8@public.gmane.org>
> Reviewed-by: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>

Instead of doing things this way, I've decided to clean things up by
updating the flags in uapi/linux/fs.h.  That's because some people who
might want to assign new flags might not be ext4 developers, and so
they wouldn't look at fs/ext4/ext4.h.

At the same time, we really don't want people adding new flags by
default, unless there is a really good reason.  So I've added a
comment making the history of the interface and suggesting that people
not assign new flags without thinking twice (or checking with
linux-fsdevel and linux-api).

						- Ted

commit 6ac40c7b5597646ec4335f77ab79cac9663f4a1e
Author: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Date:   Mon Dec 28 10:21:43 2015 -0500

    fs: clean up the flags definition in uapi/linux/fs.h
    
    Add an explanation for the flags used by FS_IOC_[GS]ETFLAGS and remind
    people that changes should be revised by linux-fsdevel and linux-api.
    
    Add flags that are used on-disk for ext4, and remove FS_DIRECTIO_FL
    since it was used only by gfs2 and support was removed in 2008 in
    commit c9f6a6bbc28 ("The ability to mark files for direct i/o access
    when opened normally is both unused and pointless, so this patch
    removes support for that feature.")  Now we have _two_ remaining flags
    left.  But since we want to discourage people from assigning new
    flags, that's OK.
    
    Signed-off-by: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>

diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 627f58e..35d156f 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -2,8 +2,11 @@
 #define _UAPI_LINUX_FS_H
 
 /*
- * This file has definitions for some important file table
- * structures etc.
+ * This file has definitions for some important file table structures
+ * and constants and structures used by various generic file system
+ * ioctl's.  Please do not make any changes in this file before
+ * sending patches for review to linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org and
+ * linux-api-u79uwXL29TaiAVqoAR/hOA@public.gmane.org
  */
 
 #include <linux/limits.h>
@@ -204,6 +207,23 @@ struct fsxattr {
 
 /*
  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
+ *
+ * Note: for historical reasons, these flags were originally used and
+ * defined for use by ext2/ext3, and then other file systems started
+ * using these flags so they wouldn't need to write their own version
+ * of chattr/lsattr (which was shipped as part of e2fsprogs).  You
+ * should think twice before trying to use these flags in new
+ * contexts, or trying to assign these flags, since they are used both
+ * as the UAPI and the on-disk encoding for ext2/3/4.  Also, we are
+ * almost out of 32-bit flags.  :-)
+ *
+ * We have recently hoisted FS_IOC_FSGETXATTR / FS_IOC_FSSETXATTR from
+ * XFS to the generic FS level interface.  This uses a structure that
+ * has padding and hence has more room to grow, so it may be more
+ * appropriate for many new use cases.
+ *
+ * Please do not change these flags or interfaces before checking with
+ * linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org and linux-api-u79uwXL29TaiAVqoAR/hOA@public.gmane.org
  */
 #define	FS_SECRM_FL			0x00000001 /* Secure deletion */
 #define	FS_UNRM_FL			0x00000002 /* Undelete */
@@ -217,8 +237,8 @@ struct fsxattr {
 #define FS_DIRTY_FL			0x00000100
 #define FS_COMPRBLK_FL			0x00000200 /* One or more compressed clusters */
 #define FS_NOCOMP_FL			0x00000400 /* Don't compress */
-#define FS_ECOMPR_FL			0x00000800 /* Compression error */
 /* End compression flags --- maybe not all used */
+#define FS_ENCRYPT_FL			0x00000800 /* Encrypted file */
 #define FS_BTREE_FL			0x00001000 /* btree format dir */
 #define FS_INDEX_FL			0x00001000 /* hash-indexed directory */
 #define FS_IMAGIC_FL			0x00002000 /* AFS directory */
@@ -226,9 +246,12 @@ struct fsxattr {
 #define FS_NOTAIL_FL			0x00008000 /* file tail should not be merged */
 #define FS_DIRSYNC_FL			0x00010000 /* dirsync behaviour (directories only) */
 #define FS_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
+#define FS_HUGE_FILE_FL			0x00040000 /* Reserved for ext4 */
 #define FS_EXTENT_FL			0x00080000 /* Extents */
-#define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
+#define FS_EA_INODE_FL			0x00200000 /* Inode used for large EA */
+#define FS_EOFBLOCKS_FL			0x00400000 /* Reserved for ext4 */
 #define FS_NOCOW_FL			0x00800000 /* Do not cow file */
+#define FS_INLINE_DATA_FL		0x10000000 /* Reserved for ext4 */
 #define FS_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
 #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */
 
