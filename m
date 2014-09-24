From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 0/4] quota: add project quota support
Date: Wed, 24 Sep 2014 14:52:06 +0200
Message-ID: <20140924125206.GA26916@quack.suse.cz>
References: <CAPTn0cDFCj7AWjQpOF0brD82XJSSeem5_1aQCE=zQKiaLaeL1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPTn0cDFCj7AWjQpOF0brD82XJSSeem5_1aQCE=zQKiaLaeL1g@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-api@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "hch@infradead.org" <hch@infradead.org>, Dmitry Monakhov <dmonakhov@openvz.org>
List-Id: linux-api@vger.kernel.org

On Wed 24-09-14 20:14:35, Li Xi wrote:
> The following patches propose an implementation of project quota
> support for ext4. A project is an aggregate of unrelated inodes
> which might scatter in different directories. Inodes belongs to a
> project possesses a same identification i.e. 'project ID', just
> like every inode has its user/group identification. The following
> patches adds project quota as supplement to the former uer/group
> quota types.
> 
> The semantics of ext4 project quota is consistent with XFS. Each
> directory can have EXT4_INODE_PROJINHERIT flag set. When the
> EXT4_INODE_PROJINHERIT flag of a parent directory is not set, a
> newly created inode under that directory will have a default project
> ID (i.e. 0). And its EXT4_INODE_PROJINHERIT flag is not set either.
> When this flag is set on a directory, following rules will be kept:
> 
> 1) The newly created inode under that directory will inherit both
> the EXT4_INODE_PROJINHERIT flag and the project ID from its parent
> directory.
> 
> 2) Hard-linking a inode with different project ID into that directory
> will fail with errno EXDEV.
> 
> 3) Renaming a inode with different project ID into that directory
> will fail with errno EXDEV. However, 'mv' command will detect this
> failure and copy the renamed inode to a new inode in the directory.
> Thus, this new inode will inherit both the project ID and
> EXT4_INODE_PROJINHERIT flag.
> 
> 4) If the project quota of that ID is being enforced, statfs() on
> that directory will take the quotas as another upper limits along
> with the capacity of the file system, i.e. the total block/inode
> number will be the minimum of the quota limits and file system
> capacity.
> 
> Changelog:
> * v4 <- v3:
>  - Do not check project feature when set/get project ID;
>  - Use EXT4_MAXQUOTAS instead of MAXQUOTAS in ext4 patches;
>  - Remove unnecessary change of fs/quota/dquot.c;
>  - Remove CONFIG_QUOTA_PROJECT.
> * v3 <- v2:
>  - Add EXT4_INODE_PROJINHERIT semantics.
> * v2 <- v1:
>  - Add ioctl interface for setting/getting project;
>  - Add EXT4_FEATURE_RO_COMPAT_PROJECT;
>  - Add get_projid() method in struct dquot_operations;
>  - Add error check of ext4_inode_projid_set/get().
> 
> v3: http://www.spinics.net/lists/linux-ext4/msg45184.html
> v2: http://www.spinics.net/lists/linux-ext4/msg44695.html
> v1: http://article.gmane.org/gmane.comp.file-systems.ext4/45153
> 
> Any comments or feedbacks are appreciated.
  Whitespace got mangled in your patches so much they are hardly readable.
Please resend them so that it is properly preserved. I'm not sure how other
guys using gmail do this so you might need to ask them... Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
