From: Jan Kara <jack@suse.cz>
Subject: Re: [v15 1/4] ext4: adds project ID support
Date: Wed, 23 Sep 2015 20:17:42 +0200
Message-ID: <20150923181742.GD16334@quack.suse.cz>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
 <1442146833-13652-2-git-send-email-lixi@ddn.com>
 <87io71titt.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87io71titt.fsf@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org
List-Id: linux-api@vger.kernel.org

On Wed 23-09-15 15:34:54, Dmitry Monakhov wrote:
> > @@ -692,6 +695,7 @@ struct ext4_inode {
> >  	__le32  i_crtime;       /* File Creation time */
> >  	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
> >  	__le32  i_version_hi;	/* high 32 bits for 64-bit version */
> > +	__le32  i_projid;	/* Project ID */
> So you are about to extend dist_inode structure(not xattr). I do understand that
> his is ridiculous question for 15'th version of the patch, but still.
> Personally I think that his is good idea, but can not find a
> confirmation from Theodore and Jan that they are agree with that.
> Guys please ACK that statement explicitly,so later we can  refer on this mail as decision made.

Yes, I agree with this.

								Honza

> >  };
> >  
> >  struct move_extent {
> > @@ -952,6 +956,7 @@ struct ext4_inode_info {
> >  	/* Encryption params */
> >  	struct ext4_crypt_info *i_crypt_info;
> >  #endif
> > +	kprojid_t i_projid;
> >  };
> >  
> >  /*
> > @@ -1566,6 +1571,7 @@ static inline int ext4_encrypted_inode(struct inode *inode)
> >   */
> >  #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
> >  #define EXT4_FEATURE_RO_COMPAT_READONLY		0x1000
> > +#define EXT4_FEATURE_RO_COMPAT_PROJECT		0x2000
> >  
> >  #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
> >  #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
> > @@ -1617,7 +1623,8 @@ static inline int ext4_encrypted_inode(struct inode *inode)
> >  					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
> >  					 EXT4_FEATURE_RO_COMPAT_BIGALLOC |\
> >  					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
> > -					 EXT4_FEATURE_RO_COMPAT_QUOTA)
> > +					 EXT4_FEATURE_RO_COMPAT_QUOTA |\
> > +					 EXT4_FEATURE_RO_COMPAT_PROJECT)
> >  
> >  /*
> >   * Default values for user and/or group using reserved blocks
> > @@ -1625,6 +1632,11 @@ static inline int ext4_encrypted_inode(struct inode *inode)
> >  #define	EXT4_DEF_RESUID		0
> >  #define	EXT4_DEF_RESGID		0
> >  
> > +/*
> > + * Default project ID
> > + */
> > +#define	EXT4_DEF_PROJID		0
> > +
> >  #define EXT4_DEF_INODE_READAHEAD_BLKS	32
> >  
> >  /*
> > @@ -2317,6 +2329,7 @@ extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
> >  			     loff_t lstart, loff_t lend);
> >  extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
> >  extern qsize_t *ext4_get_reserved_space(struct inode *inode);
> > +extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
> >  extern void ext4_da_update_reserve_space(struct inode *inode,
> >  					int used, int quota_claim);
> >  
> > diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> > index 619bfc1..692b50f 100644
> > --- a/fs/ext4/ialloc.c
> > +++ b/fs/ext4/ialloc.c
> > @@ -769,6 +769,13 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
> >  		inode->i_gid = dir->i_gid;
> >  	} else
> >  		inode_init_owner(inode, dir, mode);
> > +
> > +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> > +	    ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT))
> > +		ei->i_projid = EXT4_I(dir)->i_projid;
> > +	else
> > +		ei->i_projid = make_kprojid(&init_user_ns, EXT4_DEF_PROJID);
> > +
> >  	err = dquot_initialize(inode);
> >  	if (err)
> >  		goto out;
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 612fbcf..5836a3d 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -4035,6 +4035,14 @@ static inline void ext4_iget_extra_inode(struct inode *inode,
> >  		EXT4_I(inode)->i_inline_off = 0;
> >  }
> >  
> > +int ext4_get_projid(struct inode *inode, kprojid_t *projid)
> > +{
> > +	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
> > +		return -EOPNOTSUPP;
> > +	*projid = EXT4_I(inode)->i_projid;
> > +	return 0;
> > +}
> > +
> >  struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> >  {
> >  	struct ext4_iloc iloc;
> > @@ -4046,6 +4054,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> >  	int block;
> >  	uid_t i_uid;
> >  	gid_t i_gid;
> > +	projid_t i_projid;
> >  
> >  	inode = iget_locked(sb, ino);
> >  	if (!inode)
> > @@ -4095,12 +4104,20 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> >  	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
> >  	i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
> >  	i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
> > +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> > +	    EXT4_INODE_SIZE(sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> > +	    EXT4_FITS_IN_INODE(raw_inode, ei, i_projid))
> > +		i_projid = (projid_t)le32_to_cpu(raw_inode->i_projid);
> > +	else
> > +		i_projid = EXT4_DEF_PROJID;
> > +
> >  	if (!(test_opt(inode->i_sb, NO_UID32))) {
> >  		i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
> >  		i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
> >  	}
> >  	i_uid_write(inode, i_uid);
> >  	i_gid_write(inode, i_gid);
> > +	ei->i_projid = make_kprojid(&init_user_ns, i_projid);
> >  	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
> >  
> >  	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
> > @@ -4398,6 +4415,7 @@ static int ext4_do_update_inode(handle_t *handle,
> >  	int need_datasync = 0, set_large_file = 0;
> >  	uid_t i_uid;
> >  	gid_t i_gid;
> > +	projid_t i_projid;
> >  
> >  	spin_lock(&ei->i_raw_lock);
> >  
> > @@ -4410,6 +4428,7 @@ static int ext4_do_update_inode(handle_t *handle,
> >  	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
> >  	i_uid = i_uid_read(inode);
> >  	i_gid = i_gid_read(inode);
> > +	i_projid = from_kprojid(&init_user_ns, ei->i_projid);
> >  	if (!(test_opt(inode->i_sb, NO_UID32))) {
> >  		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(i_uid));
> >  		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(i_gid));
> > @@ -4488,6 +4507,15 @@ static int ext4_do_update_inode(handle_t *handle,
> >  				cpu_to_le16(ei->i_extra_isize);
> >  		}
> >  	}
> > +
> > +	BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> > +			EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> > +	       i_projid != EXT4_DEF_PROJID);
> > +
> > +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> > +	    EXT4_FITS_IN_INODE(raw_inode, ei, i_projid))
> > +		raw_inode->i_projid = cpu_to_le32(i_projid);
> > +
> >  	ext4_inode_csum_set(inode, raw_inode, ei);
> >  	spin_unlock(&ei->i_raw_lock);
> >  	if (inode->i_sb->s_flags & MS_LAZYTIME)
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index 9f61e76..61694ad 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -3215,6 +3215,12 @@ static int ext4_link(struct dentry *old_dentry,
> >  	if (ext4_encrypted_inode(dir) &&
> >  	    !ext4_is_child_context_consistent_with_parent(dir, inode))
> >  		return -EPERM;
> > +
> > +       if ((ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) &&
> > +	   (!projid_eq(EXT4_I(dir)->i_projid,
> > +		       EXT4_I(old_dentry->d_inode)->i_projid)))
> > +		return -EXDEV;
> > +
> >  	err = dquot_initialize(dir);
> >  	if (err)
> >  		return err;
> > @@ -3496,6 +3502,11 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
> >  	int credits;
> >  	u8 old_file_type;
> >  
> > +	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT)) &&
> > +	    (!projid_eq(EXT4_I(new_dir)->i_projid,
> > +			EXT4_I(old_dentry->d_inode)->i_projid)))
> > +		return -EXDEV;
> > +
> >  	retval = dquot_initialize(old.dir);
> >  	if (retval)
> >  		return retval;
> > @@ -3705,6 +3716,14 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
> >  							   new.inode)))
> >  		return -EPERM;
> >  
> > +	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT) &&
> > +	     !projid_eq(EXT4_I(new_dir)->i_projid,
> > +			EXT4_I(old_dentry->d_inode)->i_projid)) ||
> > +	    (ext4_test_inode_flag(old_dir, EXT4_INODE_PROJINHERIT) &&
> > +	     !projid_eq(EXT4_I(old_dir)->i_projid,
> > +			EXT4_I(new_dentry->d_inode)->i_projid)))
> > +		return -EXDEV;
> > +
> >  	retval = dquot_initialize(old.dir);
> >  	if (retval)
> >  		return retval;
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index a63c7b0..d07445e 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -1097,6 +1097,7 @@ static const struct dquot_operations ext4_quota_operations = {
> >  	.write_info	= ext4_write_info,
> >  	.alloc_dquot	= dquot_alloc,
> >  	.destroy_dquot	= dquot_destroy,
> > +	.get_projid	= ext4_get_projid,
> >  };
> >  
> >  static const struct quotactl_ops ext4_qctl_operations = {
> > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > index 9b964a5..f15d980 100644
> > --- a/include/uapi/linux/fs.h
> > +++ b/include/uapi/linux/fs.h
> > @@ -197,6 +197,7 @@ struct inodes_stat_t {
> >  #define FS_EXTENT_FL			0x00080000 /* Extents */
> >  #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
> >  #define FS_NOCOW_FL			0x00800000 /* Do not cow file */
> > +#define FS_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
> >  #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */
> >  
> >  #define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
> > -- 
> > 1.7.1


-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
