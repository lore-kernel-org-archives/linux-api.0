From: Chao Yu <chao@kernel.org>
Subject: Re: [PATCH v4 3/3] f2fs: Support case-insensitive file
 name lookups
Date: Sun, 28 Jul 2019 08:55:30 +0800
Message-ID: <9362e4ed-2be8-39f5-b4d9-9c86e37ab993@kernel.org>
References: <20190723230529.251659-1-drosen@google.com>
 <20190723230529.251659-4-drosen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190723230529.251659-4-drosen@google.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Daniel Rosenberg <drosen@google.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, Jonathan Corbet <corbet@lwn.net>, linux-f2fs-devel@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@android.com, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2019-7-24 7:05, Daniel Rosenberg via Linux-f2fs-devel wrote:
>  /* Flags that are appropriate for regular files (all but dir-specific ones). */
>  #define F2FS_REG_FLMASK		(~(F2FS_DIRSYNC_FL | F2FS_PROJINHERIT_FL))

We missed to add F2FS_CASEFOLD_FL here to exclude it in F2FS_REG_FLMASK.

> @@ -1660,7 +1660,16 @@ static int f2fs_setflags_common(struct inode *inode, u32 iflags, u32 mask)
>  		return -EPERM;
>  
>  	oldflags = fi->i_flags;
> +	if ((iflags ^ oldflags) & F2FS_CASEFOLD_FL) {
> +		if (!f2fs_sb_has_casefold(F2FS_I_SB(inode)))
> +			return -EOPNOTSUPP;
> +
> +		if (!S_ISDIR(inode->i_mode))
> +			return -ENOTDIR;
>  
> +		if (!f2fs_empty_dir(inode))
> +			return -ENOTEMPTY;
> +	}

I applied the patches based on last Jaegeuk's dev branch, it seems we needs to
adjust above code a bit. Otherwise it looks good to me.

BTW, it looks the patchset works fine with generic/556 testcase.

Thanks,
