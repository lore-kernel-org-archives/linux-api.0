From: Dave Chinner <david@fromorbit.com>
Subject: Re: [v6 4/4] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Mon, 10 Nov 2014 11:05:07 +1100
Message-ID: <20141110000507.GL23575@dastard>
References: <1415468619-31851-1-git-send-email-lixi@ddn.com>
 <1415468619-31851-5-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1415468619-31851-5-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Sun, Nov 09, 2014 at 01:43:39AM +0800, Li Xi wrote:
> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
> support for ext4. The interface is kept consistent with
> XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.

OK, can you split the ext4 implementation from the change of
interface? i.e. the ioctl rename really needs to stand alone in it's
own patch, because I've got to dig through reams of ext4 code that I
don't care about to review the API change.

> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -617,6 +617,8 @@ enum {
>  #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
>  #define EXT4_IOC_SWAP_BOOT		_IO('f', 17)
>  #define EXT4_IOC_PRECACHE_EXTENTS	_IO('f', 18)
> +#define EXT4_IOC_FSGETXATTR		FS_IOC_FSGETXATTR
> +#define EXT4_IOC_FSSETXATTR		FS_IOC_FSSETXATTR

Don't obfuscate the new ext4 code like this - just use
FS_IOC_FSSETXATTR directly.

> +++ b/fs/xfs/xfs_fs.h
> @@ -36,19 +36,6 @@ struct dioattr {
>  #endif
>  
>  /*
> - * Structure for XFS_IOC_FSGETXATTR[A] and XFS_IOC_FSSETXATTR.
> - */
> -#ifndef HAVE_FSXATTR
> -struct fsxattr {
> -	__u32		fsx_xflags;	/* xflags field value (get/set) */
> -	__u32		fsx_extsize;	/* extsize field value (get/set)*/
> -	__u32		fsx_nextents;	/* nextents field value (get)	*/
> -	__u32		fsx_projid;	/* project identifier (get/set) */
> -	unsigned char	fsx_pad[12];
> -};
> -#endif
> -
> -/*
>   * Flags for the bs_xflags/fsx_xflags field
>   * There should be a one-to-one correspondence between these flags and the
>   * XFS_DIFLAG_s.
> @@ -503,8 +490,8 @@ typedef struct xfs_swapext
>  #define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
>  #define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
>  #define XFS_IOC_DIOINFO		_IOR ('X', 30, struct dioattr)
> -#define XFS_IOC_FSGETXATTR	_IOR ('X', 31, struct fsxattr)
> -#define XFS_IOC_FSSETXATTR	_IOW ('X', 32, struct fsxattr)
> +#define XFS_IOC_FSGETXATTR	FS_IOC_FSGETXATTR
> +#define XFS_IOC_FSSETXATTR	FS_IOC_FSSETXATTR

Please pull these defines up into the section above this that is
commented:

/*
 * ioctl commands that are used by Linux filesystems
 */
#define XFS_IOC_GETXFLAGS       FS_IOC_GETFLAGS
#define XFS_IOC_SETXFLAGS       FS_IOC_SETFLAGS
#define XFS_IOC_GETVERSION      FS_IOC_GETVERSION


>  #define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
>  #define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
>  #define XFS_IOC_GETBMAP		_IOWR('X', 38, struct getbmap)
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 3735fa0..78bcb2b 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -58,6 +58,25 @@ struct inodes_stat_t {
>  	long dummy[5];		/* padding for sysctl ABI compatibility */
>  };
>  
> +/*
> + * Extend attribute flags. These should be or-ed together to figure out what
> + * is valid.
> + */
> +#define FSX_XFLAGS	(1 << 0)
> +#define FSX_EXTSIZE	(1 << 1)
> +#define FSX_NEXTENTS	(1 << 2)
> +#define FSX_PROJID	(1 << 3)

No, these do not belong in  this header file - they are internal to
the XFS implementation. The *do not not define the contents of
fsx_xflags*. The flags defined in fsx_xflags are these:

/*
 * Flags for the bs_xflags/fsx_xflags field
 * There should be a one-to-one correspondence between these flags and the
 * XFS_DIFLAG_s.
 */
#define XFS_XFLAG_REALTIME      0x00000001      /* data in realtime volume */
#define XFS_XFLAG_PREALLOC      0x00000002      /* preallocated file extents */
#define XFS_XFLAG_IMMUTABLE     0x00000008      /* file cannot be modified */
#define XFS_XFLAG_APPEND        0x00000010      /* all writes append */
#define XFS_XFLAG_SYNC          0x00000020      /* all writes synchronous */
#define XFS_XFLAG_NOATIME       0x00000040      /* do not update access time */
#define XFS_XFLAG_NODUMP        0x00000080      /* do not include in backups */
#define XFS_XFLAG_RTINHERIT     0x00000100      /* create with rt bit set */
#define XFS_XFLAG_PROJINHERIT   0x00000200      /* create with parents projid */
#define XFS_XFLAG_NOSYMLINKS    0x00000400      /* disallow symlink creation */
#define XFS_XFLAG_EXTSIZE       0x00000800      /* extent size allocator hint */
#define XFS_XFLAG_EXTSZINHERIT  0x00001000      /* inherit inode extent size */
#define XFS_XFLAG_NODEFRAG      0x00002000      /* do not defragment */
#define XFS_XFLAG_FILESTREAM    0x00004000      /* use filestream allocator */
#define XFS_XFLAG_HASATTR       0x80000000      /* no DIFLAG for this   */

i.e. these are the flags that need to be promoted to
include/uapi/linux/fs.h, prefixed by s/XFS_XFLAG/FS_XFLAG/ and then
the definitions in fs/xfs/xfs_fs.h defined to the FS_XFLAG value.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
