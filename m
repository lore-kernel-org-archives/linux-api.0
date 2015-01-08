From: Jan Kara <jack@suse.cz>
Subject: Re: [v8 2/5] ext4: adds project ID support
Date: Thu, 8 Jan 2015 09:51:05 +0100
Message-ID: <20150108085105.GC14705@quack.suse.cz>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com>
 <1418102548-5469-3-git-send-email-lixi@ddn.com>
 <0F8FAF43-54EB-4202-8120-C1D70CF330F0@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0F8FAF43-54EB-4202-8120-C1D70CF330F0@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

On Wed 07-01-15 16:11:16, Andreas Dilger wrote:
> On Dec 8, 2014, at 10:22 PM, Li Xi <pkuelelixi@gmail.com> wrote:
> > This patch adds a new internal field of ext4 inode to save project
> > identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
> > inheriting project ID from parent directory.
> > 
> > Signed-off-by: Li Xi <lixi@ddn.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > ---
...
> > @@ -4249,6 +4266,18 @@ static int ext4_do_update_inode(handle_t *handle,
> > 		}
> > 	}
> > 
> > +	BUG_ON(!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> > +			EXT4_FEATURE_RO_COMPAT_PROJECT) &&
> > +	       i_projid != EXT4_DEF_PROJID);
> > +	if (i_projid != EXT4_DEF_PROJID &&
> > +	    (EXT4_INODE_SIZE(inode->i_sb) <= EXT4_GOOD_OLD_INODE_SIZE ||
> > +	     (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid)))) {
> > +		spin_unlock(&ei->i_raw_lock);
> > +		err = -EFBIG;
> 
> I'm not sure if -EFBIG is the best error case, since that is a common
> filesystem error.  Maybe -EOVERFLOW would be better?
  So my thought has been that this is mostly a sanity check and we would
check in tune2fs whether all inodes have enough space when setting
EXT4_FEATURE_RO_COMPAT_PROJECT feature... Because sudden errors (regardless
whether it will be EFBIG or EOVERFLOW) when renaming files will be hard to
understand for sysadmins IMHO.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
