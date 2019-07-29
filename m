From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v4 3/3] f2fs: Support case-insensitive file
 name lookups
Date: Sun, 28 Jul 2019 23:27:35 -0700
Message-ID: <20190729062735.GA98839@jaegeuk-macbookpro.roam.corp.google.com>
References: <20190723230529.251659-1-drosen@google.com>
 <20190723230529.251659-4-drosen@google.com>
 <9362e4ed-2be8-39f5-b4d9-9c86e37ab993@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9362e4ed-2be8-39f5-b4d9-9c86e37ab993@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Chao Yu <chao@kernel.org>
Cc: Daniel Rosenberg <drosen@google.com>, Chao Yu <yuchao0@huawei.com>, Jonathan Corbet <corbet@lwn.net>, linux-f2fs-devel@lists.sourceforge.net, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@android.com
List-Id: linux-api@vger.kernel.org

On 07/28, Chao Yu wrote:
> On 2019-7-24 7:05, Daniel Rosenberg via Linux-f2fs-devel wrote:
> >  /* Flags that are appropriate for regular files (all but dir-specific ones). */
> >  #define F2FS_REG_FLMASK		(~(F2FS_DIRSYNC_FL | F2FS_PROJINHERIT_FL))
> 
> We missed to add F2FS_CASEFOLD_FL here to exclude it in F2FS_REG_FLMASK.

Applied.

> 
> > @@ -1660,7 +1660,16 @@ static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
> >  		return -EPERM;
> >  
> >  	oldflags = fi->i_flags;
> > +	if ((iflags ^ oldflags) & F2FS_CASEFOLD_FL) {
> > +		if (!f2fs_sb_has_casefold(F2FS_I_SB(inode)))
> > +			return -EOPNOTSUPP;
> > +
> > +		if (!S_ISDIR(inode->i_mode))
> > +			return -ENOTDIR;
> >  
> > +		if (!f2fs_empty_dir(inode))
> > +			return -ENOTEMPTY;
> > +	}

Modified like this:
@@ -1665,6 +1665,13 @@ static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
        if (IS_NOQUOTA(inode))
                return -EPERM;

+       if ((iflags ^ fi->i_flags) & F2FS_CASEFOLD_FL) {
+               if (!f2fs_sb_has_casefold(F2FS_I_SB(inode)))
+                       return -EOPNOTSUPP;
+               if (!f2fs_empty_dir(inode))
+                       return -ENOTEMPTY;
+       }
+

Note that, directory is checked by above change.

I've uploaded in f2fs.git, so could you check it out and test a bit?

Thanks,

> 
> I applied the patches based on last Jaegeuk's dev branch, it seems we needs to
> adjust above code a bit. Otherwise it looks good to me.
> 
> BTW, it looks the patchset works fine with generic/556 testcase.
> 
> Thanks,
