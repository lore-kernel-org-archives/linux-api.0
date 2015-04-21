From: Jan Kara <jack@suse.cz>
Subject: Re: [v13 3/5] ext4: adds project quota support
Date: Tue, 21 Apr 2015 14:35:00 +0200
Message-ID: <20150421123500.GI24278@quack.suse.cz>
References: <1429493988-16819-1-git-send-email-lixi@ddn.com>
 <1429493988-16819-4-git-send-email-lixi@ddn.com>
 <000EC725-2B59-42E8-811E-0E41E6EBB306@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000EC725-2B59-42E8-811E-0E41E6EBB306@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Mon 20-04-15 17:27:20, Andreas Dilger wrote:
> On Apr 19, 2015, at 7:39 PM, Li Xi <pkuelelixi@gmail.com> wrote:
...
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 1446c4f..a7acf10 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -1169,7 +1169,8 @@ struct ext4_super_block {
> > 	__le32	s_overhead_clusters;	/* overhead blocks/clusters in fs */
> > 	__le32	s_backup_bgs[2];	/* groups with sparse_super2 SBs */
> > 	__u8	s_encrypt_algos[4];	/* Encryption algorithms in use  */
> > -	__le32	s_reserved[105];	/* Padding to the end of the block */
> > +	__le32  s_prj_quota_inum;       /* inode for tracking project quota */
> > +	__le32	s_reserved[104];	/* Padding to the end of the block */
> > 	__le32	s_checksum;		/* crc32c(superblock) */
> > };
> > 
> > @@ -1184,7 +1185,7 @@ struct ext4_super_block {
> > #define EXT4_MF_FS_ABORTED	0x0002	/* Fatal error detected */
> > 
> > /* Number of quota types we support */
> > -#define EXT4_MAXQUOTAS 2
> > +#define EXT4_MAXQUOTAS 3
> > 
> > /*
> >  * fourth extended-fs super-block data in memory
> > @@ -1376,6 +1377,7 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
> > 		ino == EXT4_BOOT_LOADER_INO ||
> > 		ino == EXT4_JOURNAL_INO ||
> > 		ino == EXT4_RESIZE_INO ||
> > +		ino == le32_to_cpu(EXT4_SB(sb)->s_es->s_prj_quota_inum) ||
> 
> This extra check isn't needed, since s_proj_quota_inum will be a regular
> inode number and handled by the checks below.
  So I think this needs a final decision from Ted how we handle new system
files and use it consistently among all features - project quotas, orphan
file, etc. Ted, can you share your thoughts please? Options are:

1) We allocate inodes from normal inode pool and just store their inode
   numbers in superblock.
+ no need to increase number of special inodes
- slightly less robust since inode can be anywhere
- needs special treatment from fsck to know inode isn't just some lost inode
- consumes space in sb for inode numbers

2) Like 1) but also create special "system" directory and attach system
   inodes there
+ fsck just needs to know about the system directory, not about every
  special file
+ no wasted space in sb for every special inode
- more code in kernel to implement this
- even less robust than 1) - when system directory gets corrupt, we are in
  trouble

3) Increase number of special inodes
+ consistent with what we did upto now
+ somewhat more robust since inode is in fixed place
- tune2fs needs to do quite some work to reserve more inodes
- wastes unused special inodes

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
