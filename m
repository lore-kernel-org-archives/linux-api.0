From: Dave Chinner <david@fromorbit.com>
Subject: Re: [v8 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Wed, 10 Dec 2014 09:57:58 +1100
Message-ID: <20141209225758.GB9756@dastard>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com>
 <1418102548-5469-5-git-send-email-lixi@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1418102548-5469-5-git-send-email-lixi@ddn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 09, 2014 at 01:22:27PM +0800, Li Xi wrote:
> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
> support for ext4. The interface is kept consistent with
> XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.
> 
> Signed-off-by: Li Xi <lixi@ddn.com>
> ---
>  fs/ext4/ext4.h          |  111 ++++++++++++++++
>  fs/ext4/ioctl.c         |  330 +++++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_fs.h         |   47 +++-----
>  include/uapi/linux/fs.h |   58 ++++++++
>  4 files changed, 418 insertions(+), 128 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 136e18c..43a2a88 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -384,6 +384,115 @@ struct flex_groups {
>  #define EXT4_FL_USER_VISIBLE		0x204BDFFF /* User visible flags */
>  #define EXT4_FL_USER_MODIFIABLE		0x204380FF /* User modifiable flags */
>  
> +/* Transfer internal flags to xflags */
> +static inline __u32 ext4_iflags_to_xflags(unsigned long iflags)
> +{
> +	__u32 xflags = 0;
> +
> +	if (iflags & EXT4_SECRM_FL)
> +		xflags |= FS_XFLAG_SECRM;
> +	if (iflags & EXT4_UNRM_FL)
> +		xflags |= FS_XFLAG_UNRM;
> +	if (iflags & EXT4_COMPR_FL)
> +		xflags |= FS_XFLAG_COMPR;
....

NACK.

> +	if (iflags & EXT4_SYNC_FL)
> +		xflags |= FS_XFLAG_SYNC;
> +	if (iflags & EXT4_IMMUTABLE_FL)
> +		xflags |= FS_XFLAG_IMMUTABLE;
> +	if (iflags & EXT4_APPEND_FL)
> +		xflags |= FS_XFLAG_APPEND;
> +	if (iflags & EXT4_NODUMP_FL)
> +		xflags |= FS_XFLAG_NODUMP;
> +	if (iflags & EXT4_NOATIME_FL)
> +		xflags |= FS_XFLAG_NOATIME;

These are OK because they already exist in the interface, but all
the ext4 specific flags you've added have no place in this patchset.


> +
>  /* Flags that should be inherited by new inodes from their parent. */
>  #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
>  			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
> @@ -606,6 +715,8 @@ enum {
>  #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
>  #define EXT4_IOC_SWAP_BOOT		_IO('f', 17)
>  #define EXT4_IOC_PRECACHE_EXTENTS	_IO('f', 18)
> +#define EXT4_IOC_FSGETXATTR		FS_IOC_FSGETXATTR
> +#define EXT4_IOC_FSSETXATTR		FS_IOC_FSSETXATTR

NACK. Userspace only needs FS_IOC_FS[GS]ETXATTR so that it works across
all filesystems. We need to retain XFS_IOC_FS[GS]ETXATTR so we
don't break existing userspace tools, but we do not need new
filesystem specific definitions anywhere.

> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index fcbf647..872fed5 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -58,6 +58,62 @@ struct inodes_stat_t {
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

NACK.

I've said this more than once: these are *private to XFS's
implementation* and are not be part of the user interface. Do not
move them from their existing location.


> +
> +/*
> + * Structure for FS_IOC_FSGETXATTR and FS_IOC_FSSETXATTR.
> + */
> +struct fsxattr {
> +	__u32		fsx_xflags;	/* xflags field value (get/set) */
> +	__u32		fsx_extsize;	/* extsize field value (get/set)*/
> +	__u32		fsx_nextents;	/* nextents field value (get)	*/
> +	__u32		fsx_projid;	/* project identifier (get/set) */
> +	unsigned char	fsx_pad[12];
> +};
> +
> +/*
> + * Flags for the fsx_xflags field
> + */
> +#define FS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
> +#define FS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
> +#define FS_XFLAG_SECRM		0x00000004	/* secure deletion */

NACK - ext4 specific.

> +#define FS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
> +#define FS_XFLAG_APPEND		0x00000010	/* all writes append */
> +#define FS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
> +#define FS_XFLAG_NOATIME	0x00000040	/* do not update access time */
> +#define FS_XFLAG_NODUMP		0x00000080	/* do not include in backups */
> +#define FS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
> +#define FS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
> +#define FS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
> +#define FS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
> +#define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
> +#define FS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
> +#define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */

existing flags.

> +#define FS_XFLAG_UNRM		0x00008000	/* undelete */
> +#define FS_XFLAG_COMPR		0x00010000	/* compress file */
> +#define FS_XFLAG_COMPRBLK	0x00020000	/* one or more compressed clusters */
> +#define FS_XFLAG_NOCOMPR	0x00040000	/* don't compress */
> +#define FS_XFLAG_ECOMPR		0x00080000	/* compression error */
> +#define FS_XFLAG_INDEX		0x00100000	/* hash-indexed directory */
> +#define FS_XFLAG_IMAGIC		0x00200000	/* AFS directory */
> +#define FS_XFLAG_JOURNAL_DATA	0x00400000	/* file data should be journaled */
> +#define FS_XFLAG_NOTAIL		0x00800000	/* file tail should not be merged */
> +#define FS_XFLAG_DIRSYNC	0x01000000	/* dirsync behaviour (directories only) */
> +#define FS_XFLAG_TOPDIR		0x02000000	/* top of directory hierarchies*/
> +#define FS_XFLAG_HUGE_FILE	0x04000000	/* set to each huge file */
> +#define FS_XFLAG_EXTENTS	0x08000000	/* inode uses extents */
> +#define FS_XFLAG_EA_INODE	0x10000000	/* inode used for large EA */
> +#define FS_XFLAG_EOFBLOCKS	0x20000000	/* blocks allocated beyond EOF */
> +#define FS_XFLAG_INLINE_DATA	0x40000000	/* inode has inline data. */

And a bunch more ext4 specific flags that *uses all the remaining
flag space*.  At minimum, we need to keep space in this existing
flags field for flags to future indication of how the padding is
used, so that's yet another NACK.

Further, none of these have any relevance to project quotas so
should not be a part of this patchset. Nor are they relevant to any
other filesystem, and many are duplicated by information you can get
from FIEMAP and other interfaces. NACK, again.

Because I'm getting annoyed at being repeatedly ignored about what
needs to be done here, I'm now going to shout a bit. DO NOT CHANGE
THE INTERFACE.  DO NOT ADD any new flags to the interface. DO NOT
REDEFINE how the interface works. DO NOT "ext4-ise" the interface.

The only changes to the interface code should be moving the XFS
definitions and renaming them so as to provide the new generic
ioctl definition as well as the historic XFS definitions. The ext4
implementation needs to be done in a separate patch to the interface
rename, and it must only implement the functionality the interface
already provides. Anything else is outside the scope of this
patchset and requires separate discussion.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
