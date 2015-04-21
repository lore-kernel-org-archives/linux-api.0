From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [v13 2/5] ext4: adds project ID support
Date: Tue, 21 Apr 2015 14:19:46 +0200
Message-ID: <20150421121946.GH24278@quack.suse.cz>
References: <1429493988-16819-1-git-send-email-lixi@ddn.com>
 <1429493988-16819-3-git-send-email-lixi@ddn.com>
 <60E980ED-C4CF-4558-B0A2-5E5671388BE1@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <60E980ED-C4CF-4558-B0A2-5E5671388BE1-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon 20-04-15 17:25:51, Andreas Dilger wrote:
> On Apr 19, 2015, at 7:39 PM, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > 
> > This patch adds a new internal field of ext4 inode to save project
> > identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
> > inheriting project ID from parent directory.
> > 
> 
> > @@ -3930,12 +3939,18 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> > 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
> > 	i_uid = (uid_t)le16_to_cpu(raw_inode->i_uid_low);
> > 	i_gid = (gid_t)le16_to_cpu(raw_inode->i_gid_low);
> > +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
> > +		i_projid = (projid_t)le32_to_cpu(raw_inode->i_projid);
> 
> This needs to check if EXT4_PROJID_INHERIT_FL is set, and if i_projid
> fits in i_extra_isize, otherwise it could be accessing a garbage value
> beyond i_extra_isize.
  We don't need to check EXT4_PROJID_INHERIT_FL. That is completely
independent of whether project ID is stored or not. We should check whether
project ID fits into the inode in this place, that is correct.
	
								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
