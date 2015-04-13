From: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [v12 2/5] ext4: adds project ID support
Date: Mon, 13 Apr 2015 10:33:30 -0600
Message-ID: <CAPTn0cBHV9gc=16d+NXa161MS706KTim16CnLf3obRxEs0B7QQ@mail.gmail.com>
References: <1428592477-8212-1-git-send-email-lixi@ddn.com>
	<1428592477-8212-3-git-send-email-lixi@ddn.com>
	<C5339F6B-2DAE-4984-86CF-B2990CEC3550@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C5339F6B-2DAE-4984-86CF-B2990CEC3550-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Sorry Andreas, I will update the patch soon.

On Fri, Apr 10, 2015 at 5:37 PM, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:
> On Apr 9, 2015, at 9:14 AM, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> This patch adds a new internal field of ext4 inode to save project
>> identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
>> inheriting project ID from parent directory.
>>
>> Signed-off-by: Li Xi <lixi-LfVdkaOWEx8@public.gmane.org>
>> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
>> ---
>> fs/ext4/ext4.h          |   21 +++++++++++++++++----
>> fs/ext4/ialloc.c        |    5 +++++
>> fs/ext4/inode.c         |   29 +++++++++++++++++++++++++++++
>> fs/ext4/namei.c         |   18 ++++++++++++++++++
>> fs/ext4/super.c         |    1 +
>> include/uapi/linux/fs.h |    1 +
>> 6 files changed, 71 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 7fec2ef..7acb2da 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -378,16 +378,18 @@ struct flex_groups {
>> #define EXT4_EA_INODE_FL              0x00200000 /* Inode used for large EA */
>> #define EXT4_EOFBLOCKS_FL             0x00400000 /* Blocks allocated beyond EOF */
>> #define EXT4_INLINE_DATA_FL           0x10000000 /* Inode has inline data. */
>> +#define EXT4_PROJINHERIT_FL          0x20000000 /* Create with parents projid */
>> #define EXT4_RESERVED_FL              0x80000000 /* reserved for ext4 lib */
>>
>> -#define EXT4_FL_USER_VISIBLE         0x004BDFFF /* User visible flags */
>> -#define EXT4_FL_USER_MODIFIABLE              0x004380FF /* User modifiable flags */
>> +#define EXT4_FL_USER_VISIBLE         0x204BDFFF /* User visible flags */
>> +#define EXT4_FL_USER_MODIFIABLE              0x204380FF /* User modifiable flags */
>
> I just noticed that EXT4_INLINE_DATA_FL isn't in EXT4_FL_USER_VISIBLE,
> but it probably should be.  If this patch is refreshed it wouldn't hurt
> to add that flag also.
>
>> /* Flags that should be inherited by new inodes from their parent. */
>> #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
>>                          EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
>>                          EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
>> -                        EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
>> +                        EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL |\
>> +                        EXT4_PROJINHERIT_FL)
>>
>> /* Flags that are appropriate for regular files (all but dir-specific ones). */
>> #define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
>> @@ -435,6 +437,7 @@ enum {
>>       EXT4_INODE_EA_INODE     = 21,   /* Inode used for large EA */
>>       EXT4_INODE_EOFBLOCKS    = 22,   /* Blocks allocated beyond EOF */
>>       EXT4_INODE_INLINE_DATA  = 28,   /* Data in inode. */
>> +     EXT4_INODE_PROJINHERIT  = 29,   /* Create with parents projid */
>>       EXT4_INODE_RESERVED     = 31,   /* reserved for ext4 lib */
>> };
>>
>> @@ -684,6 +687,7 @@ struct ext4_inode {
>>       __le32  i_crtime;       /* File Creation time */
>>       __le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
>>       __le32  i_version_hi;   /* high 32 bits for 64-bit version */
>> +     __le32  i_projid;       /* Project ID */
>> };
>>
>> struct move_extent {
>> @@ -939,6 +943,7 @@ struct ext4_inode_info {
>>
>>       /* Precomputed uuid+inum+igen checksum for seeding inode checksums */
>>       __u32 i_csum_seed;
>> +     kprojid_t i_projid;
>> };
>>
>> /*
>> @@ -1531,6 +1536,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
>>  */
>> #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM  0x0400
>> #define EXT4_FEATURE_RO_COMPAT_READONLY               0x1000
>> +#define EXT4_FEATURE_RO_COMPAT_PROJECT               0x2000
>>
>> #define EXT4_FEATURE_INCOMPAT_COMPRESSION     0x0001
>> #define EXT4_FEATURE_INCOMPAT_FILETYPE                0x0002
>> @@ -1581,7 +1587,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
>>                                        EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
>>                                        EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
>>                                        EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
>> -                                      EXT4_FEATURE_RO_COMPAT_QUOTA)
>> +                                      EXT4_FEATURE_RO_COMPAT_QUOTA |\
>> +                                      EXT4_FEATURE_RO_COMPAT_PROJECT)
>>
>> /*
>>  * Default values for user and/or group using reserved blocks
>> @@ -1589,6 +1596,11 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
>> #define       EXT4_DEF_RESUID         0
>> #define       EXT4_DEF_RESGID         0
>>
>> +/*
>> + * Default project ID
>> + */
>> +#define      EXT4_DEF_PROJID         0
>> +
>> #define EXT4_DEF_INODE_READAHEAD_BLKS 32
>>
>> /*
>> @@ -2141,6 +2153,7 @@ extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
>>                            loff_t lstart, loff_t lend);
>> extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
>> extern qsize_t *ext4_get_reserved_space(struct inode *inode);
>> +extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
>> extern void ext4_da_update_reserve_space(struct inode *inode,
>>                                       int used, int quota_claim);
>>
>> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
>> index ac644c3..10ca9dd 100644
>> --- a/fs/ext4/ialloc.c
>> +++ b/fs/ext4/ialloc.c
>> @@ -756,6 +756,11 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
>>               inode->i_gid = dir->i_gid;
>>       } else
>>               inode_init_owner(inode, dir, mode);
>> +     if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT) &&
>> +         ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT))
>> +             ei->i_projid = EXT4_I(dir)->i_projid;
>> +     else
>> +             ei->i_projid = make_kprojid(&init_user_ns, EXT4_DEF_PROJID);
>>       dquot_initialize(inode);
>>
>>       if (!goal)
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 4df6d01..6e4833f 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -3870,6 +3870,14 @@ static inline void ext4_iget_extra_inode(struct inode *inode,
>>               EXT4_I(inode)->i_inline_off = 0;
>> }
>>
>> +int ext4_get_projid(struct inode *inode, kprojid_t *projid)
>> +{
>> +     if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
>> +             return -EOPNOTSUPP;
>> +     *projid = EXT4_I(inode)->i_projid;
>> +     return 0;
>> +}
>> +
>> struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>> {
>>       struct ext4_iloc iloc;
>> @@ -3881,6 +3889,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>>       int block;
>>       uid_t i_uid;
>>       gid_t i_gid;
>> +     projid_t i_projid;
>>
>>       inode = iget_locked(sb, ino);
>>       if (!inode)
>> @@ -3930,12 +3939,18 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>>       inode->i_mode = le16_to_cpu(raw_inode->i_mode);
>>       i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
>>       i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
>> +     if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
>> +             i_projid = (projid_t)le32_to_cpu(raw_inode->i_projid);
>> +     else
>> +             i_projid = EXT4_DEF_PROJID;
>> +
>>       if (!(test_opt(inode->i_sb, NO_UID32))) {
>>               i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
>>               i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
>>       }
>>       i_uid_write(inode, i_uid);
>>       i_gid_write(inode, i_gid);
>> +     ei->i_projid = make_kprojid(&init_user_ns, i_projid);;
>>       set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
>>
>>       ext4_clear_state_flags(ei);     /* Only relevant on 32-bit archs */
>> @@ -4165,6 +4180,7 @@ static int ext4_do_update_inode(handle_t *handle,
>>       int need_datasync = 0, set_large_file = 0;
>>       uid_t i_uid;
>>       gid_t i_gid;
>> +     projid_t i_projid;
>>
>>       spin_lock(&ei->i_raw_lock);
>>
>> @@ -4177,6 +4193,7 @@ static int ext4_do_update_inode(handle_t *handle,
>>       raw_inode->i_mode = cpu_to_le16(inode->i_mode);
>>       i_uid = i_uid_read(inode);
>>       i_gid = i_gid_read(inode);
>> +     i_projid = from_kprojid(&init_user_ns, ei->i_projid);
>>       if (!(test_opt(inode->i_sb, NO_UID32))) {
>>               raw_inode->i_uid_low = cpu_to_le16(low_16_bits(i_uid));
>>               raw_inode->i_gid_low = cpu_to_le16(low_16_bits(i_gid));
>> @@ -4256,6 +4273,18 @@ static int ext4_do_update_inode(handle_t *handle,
>>               }
>>       }
>>
>> +     BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
>> +                     EXT4_FEATURE_RO_COMPAT_PROJECT) &&
>> +            i_projid != EXT4_DEF_PROJID);
>> +     if (i_projid != EXT4_DEF_PROJID &&
>> +         (EXT4_INODE_SIZE(inode->i_sb) <= EXT4_GOOD_OLD_INODE_SIZE ||
>> +          (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)))) {
>> +             spin_unlock(&ei->i_raw_lock);
>> +             err = -EFBIG;
>
> I mentioned the following back on v8 of the patch, but I'll write it again:
>
> I don't think -EFBIG "File too large" is a good error here.  Better would
> be -EOPNOTSUPP for EXT4_INODE_SIZE() <= EXT4_GOOD_OLD_INODE_SIZE, since
> this will never work for this filesystem.  For the !EXT4_FITS_IN_INODE()
> case -EOVERFLOW would be better?
>
> Also, returning the error from ext4_mark_iloc_dirty->ext4_do_update_inode()
> is a bit late in the game, since the inode has already been modified at
> this point.  That callpath typically only returned an error if the disk
> was bad or the journal aborted (again normally because the disk was bad),
> so at that point the dirty in-memory data was lost anyway.
>
> It would be better to check this in the caller before the inode is changed
> so that an error can be returned without (essentially) corrupting the
> in-memory state.  Since the projid should only be set for new inodes (which
> will always have enough space, assuming RO_COMPAT_PROJECT cannot be set on
> filesystems with 128-byte inodes), or in case of rename into a project
> directory, it shouldn't be too big a change.
>
>> +             goto out_brelse;
>> +     }
>> +     raw_inode->i_projid = cpu_to_le32(i_projid);
>> +
>>       ext4_inode_csum_set(inode, raw_inode, ei);
>>
>>       spin_unlock(&ei->i_raw_lock);
>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
>> index 2291923..63a9623 100644
>> --- a/fs/ext4/namei.c
>> +++ b/fs/ext4/namei.c
>> @@ -2938,6 +2938,11 @@ static int ext4_link(struct dentry *old_dentry,
>>       if (inode->i_nlink >= EXT4_LINK_MAX)
>>               return -EMLINK;
>>
>> +     if ((ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) &&
>> +         (!projid_eq(EXT4_I(dir)->i_projid,
>> +                     EXT4_I(old_dentry->d_inode)->i_projid)))
>> +             return -EXDEV;
>> +
>>       dquot_initialize(dir);
>>
>> retry:
>> @@ -3217,6 +3222,11 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
>>       int credits;
>>       u8 old_file_type;
>>
>> +     if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT)) &&
>> +         (!projid_eq(EXT4_I(new_dir)->i_projid,
>> +                     EXT4_I(old_dentry->d_inode)->i_projid)))
>> +             return -EXDEV;
>> +
>>       dquot_initialize(old.dir);
>>       dquot_initialize(new.dir);
>>
>> @@ -3395,6 +3405,14 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
>>       u8 new_file_type;
>>       int retval;
>>
>> +     if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT) &&
>> +          !projid_eq(EXT4_I(new_dir)->i_projid,
>> +                     EXT4_I(old_dentry->d_inode)->i_projid)) ||
>> +         (ext4_test_inode_flag(old_dir, EXT4_INODE_PROJINHERIT) &&
>> +          !projid_eq(EXT4_I(old_dir)->i_projid,
>> +                     EXT4_I(new_dentry->d_inode)->i_projid)))
>> +             return -EXDEV;
>> +
>>       dquot_initialize(old.dir);
>>       dquot_initialize(new.dir);
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index bff3427..04c6cc3 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -1073,6 +1073,7 @@ static const struct dquot_operations ext4_quota_operations = {
>>       .write_info     = ext4_write_info,
>>       .alloc_dquot    = dquot_alloc,
>>       .destroy_dquot  = dquot_destroy,
>> +     .get_projid     = ext4_get_projid,
>> };
>>
>> static const struct quotactl_ops ext4_qctl_operations = {
>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>> index 3735fa0..fcbf647 100644
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -195,6 +195,7 @@ struct inodes_stat_t {
>> #define FS_EXTENT_FL                  0x00080000 /* Extents */
>> #define FS_DIRECTIO_FL                        0x00100000 /* Use direct i/o */
>> #define FS_NOCOW_FL                   0x00800000 /* Do not cow file */
>> +#define FS_PROJINHERIT_FL            0x20000000 /* Create with parents projid */
>> #define FS_RESERVED_FL                        0x80000000 /* reserved for ext2 lib */
>>
>> #define FS_FL_USER_VISIBLE            0x0003DFFF /* User visible flags */
>> --
>> 1.7.1
>>
>
>
> Cheers, Andreas
>
>
>
>
>
