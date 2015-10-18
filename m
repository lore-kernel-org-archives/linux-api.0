From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [v15 0/4] ext4: add project quota support
Date: Sun, 18 Oct 2015 10:25:34 +0800
Message-ID: <CAPTn0cDL15EX_=2t4xrHPt-d=dekXYtzgFL_aHLTjvnN+RSK4g@mail.gmail.com>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
	<20151018010143.GE2678@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151018010143.GE2678@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "hch@infradead.org" <hch@infradead.org>, Dmitry Monakhov <dmonakhov@openvz.org>
List-Id: linux-api@vger.kernel.org

Hi Ted,

I checked it and didn't find anything missing or different.

Regards,
Li Xi

On Sun, Oct 18, 2015 at 9:01 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> This is a patch to reserve the code points used by the project quota
> feature.  It should be the no different from the ones used by the
> project quota patches; please let me know ASAP if you spot any
> discrepancies, or anything else that I might have missed.
>
> Cheers,
>
>                                         - Ted
>
>
> commit 8b4953e13f4c5d9a3c869f5fca7d51e1700e7db0
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sat Oct 17 16:15:18 2015 -0400
>
>     ext4: reserve code points for the project quota feature
>
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3f248c9..320f10e 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -374,6 +374,7 @@ struct flex_groups {
>  #define EXT4_EA_INODE_FL               0x00200000 /* Inode used for large EA */
>  #define EXT4_EOFBLOCKS_FL              0x00400000 /* Blocks allocated beyond EOF */
>  #define EXT4_INLINE_DATA_FL            0x10000000 /* Inode has inline data. */
> +#define EXT4_PROJINHERIT_FL            0x20000000 /* Create with parents projid */
>  #define EXT4_RESERVED_FL               0x80000000 /* reserved for ext4 lib */
>
>  #define EXT4_FL_USER_VISIBLE           0x004BDFFF /* User visible flags */
> @@ -431,6 +432,7 @@ enum {
>         EXT4_INODE_EA_INODE     = 21,   /* Inode used for large EA */
>         EXT4_INODE_EOFBLOCKS    = 22,   /* Blocks allocated beyond EOF */
>         EXT4_INODE_INLINE_DATA  = 28,   /* Data in inode. */
> +       EXT4_INODE_PROJINHERIT  = 29,   /* Create with parents projid */
>         EXT4_INODE_RESERVED     = 31,   /* reserved for ext4 lib */
>  };
>
> @@ -475,6 +477,7 @@ static inline void ext4_check_flag_values(void)
>         CHECK_FLAG_VALUE(EA_INODE);
>         CHECK_FLAG_VALUE(EOFBLOCKS);
>         CHECK_FLAG_VALUE(INLINE_DATA);
> +       CHECK_FLAG_VALUE(PROJINHERIT);
>         CHECK_FLAG_VALUE(RESERVED);
>  }
>
> @@ -692,6 +695,7 @@ struct ext4_inode {
>         __le32  i_crtime;       /* File Creation time */
>         __le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
>         __le32  i_version_hi;   /* high 32 bits for 64-bit version */
> +       __le32  i_projid;       /* Project ID */
>  };
>
>  struct move_extent {
> @@ -1179,7 +1183,8 @@ struct ext4_super_block {
>         __u8    s_encrypt_algos[4];     /* Encryption algorithms in use  */
>         __u8    s_encrypt_pw_salt[16];  /* Salt used for string2key algorithm */
>         __le32  s_lpf_ino;              /* Location of the lost+found inode */
> -       __le32  s_reserved[100];        /* Padding to the end of the block */
> +       __le32  s_prj_quota_inum;       /* inode for tracking project quota */
> +       __le32  s_reserved[99];         /* Padding to the end of the block */
>         __le32  s_checksum;             /* crc32c(superblock) */
>  };
>
> @@ -1566,6 +1571,7 @@ static inline int ext4_encrypted_inode(struct inode *inode)
>   */
>  #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM   0x0400
>  #define EXT4_FEATURE_RO_COMPAT_READONLY                0x1000
> +#define EXT4_FEATURE_RO_COMPAT_PROJECT         0x2000
>
>  #define EXT4_FEATURE_INCOMPAT_COMPRESSION      0x0001
>  #define EXT4_FEATURE_INCOMPAT_FILETYPE         0x0002
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 9b964a5..f15d980 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -197,6 +197,7 @@ struct inodes_stat_t {
>  #define FS_EXTENT_FL                   0x00080000 /* Extents */
>  #define FS_DIRECTIO_FL                 0x00100000 /* Use direct i/o */
>  #define FS_NOCOW_FL                    0x00800000 /* Do not cow file */
> +#define FS_PROJINHERIT_FL              0x20000000 /* Create with parents projid */
>  #define FS_RESERVED_FL                 0x80000000 /* reserved for ext2 lib */
>
>  #define FS_FL_USER_VISIBLE             0x0003DFFF /* User visible flags */
