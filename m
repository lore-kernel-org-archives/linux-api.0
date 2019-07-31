From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH v4 3/3] f2fs: Support case-insensitive file name lookups
Date: Wed, 31 Jul 2019 10:57:48 -0700
Message-ID: <20190731175748.GA48637@archlinux-threadripper>
References: <20190723230529.251659-1-drosen@google.com>
 <20190723230529.251659-4-drosen@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190723230529.251659-4-drosen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Rosenberg <drosen@google.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, Jonathan Corbet <corbet@lwn.net>, linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@android.com
List-Id: linux-api@vger.kernel.org

Hi all,

<snip>

> diff --git a/fs/f2fs/hash.c b/fs/f2fs/hash.c
> index cc82f142f811f..99e79934f5088 100644
> --- a/fs/f2fs/hash.c
> +++ b/fs/f2fs/hash.c
> @@ -14,6 +14,7 @@
>  #include <linux/f2fs_fs.h>
>  #include <linux/cryptohash.h>
>  #include <linux/pagemap.h>
> +#include <linux/unicode.h>
>  
>  #include "f2fs.h"
>  
> @@ -67,7 +68,7 @@ static void str2hashbuf(const unsigned char *msg, size_t len,
>  		*buf++ = pad;
>  }
>  
> -f2fs_hash_t f2fs_dentry_hash(const struct qstr *name_info,
> +static f2fs_hash_t __f2fs_dentry_hash(const struct qstr *name_info,
>  				struct fscrypt_name *fname)
>  {
>  	__u32 hash;
> @@ -103,3 +104,35 @@ f2fs_hash_t f2fs_dentry_hash(const struct qstr *name_info,
>  	f2fs_hash = cpu_to_le32(hash & ~F2FS_HASH_COL_BIT);
>  	return f2fs_hash;
>  }
> +
> +f2fs_hash_t f2fs_dentry_hash(const struct inode *dir,
> +		const struct qstr *name_info, struct fscrypt_name *fname)
> +{
> +#ifdef CONFIG_UNICODE
> +	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
> +	const struct unicode_map *um = sbi->s_encoding;
> +	int r, dlen;
> +	unsigned char *buff;
> +	struct qstr *folded;
> +
> +	if (name_info->len && IS_CASEFOLDED(dir)) {
> +		buff = f2fs_kzalloc(sbi, sizeof(char) * PATH_MAX, GFP_KERNEL);
> +		if (!buff)
> +			return -ENOMEM;
> +
> +		dlen = utf8_casefold(um, name_info, buff, PATH_MAX);
> +		if (dlen < 0) {
> +			kvfree(buff);
> +			goto opaque_seq;
> +		}
> +		folded->name = buff;
> +		folded->len = dlen;
> +		r = __f2fs_dentry_hash(folded, fname);
> +
> +		kvfree(buff);
> +		return r;
> +	}
> +opaque_seq:
> +#endif
> +	return __f2fs_dentry_hash(name_info, fname);
> +}

Clang now warns:

fs/f2fs/hash.c:128:3: warning: variable 'folded' is uninitialized when used here [-Wuninitialized]
                folded->name = buff;
                ^~~~~~
fs/f2fs/hash.c:116:21: note: initialize the variable 'folded' to silence this warning
        struct qstr *folded;
                           ^
                            = NULL
1 warning generated.

I assume that it wants to be initialized with f2fs_kzalloc as well but
I am not familiar with this code and what it expects to do.

Please look into this when you get a chance!
Nathan
