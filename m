From: Michael Halcrow <mhalcrow-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 07/25] fs/inode.c: export inode_lru_list_del()
Date: Fri, 27 Oct 2017 13:28:28 -0700
Message-ID: <20171027202828.GA10022@google.com>
References: <20171023214058.128121-1-ebiggers3@gmail.com>
 <20171023214058.128121-8-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171023214058.128121-8-ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Theodore Y . Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Ryo Hashimoto <hashimoto-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Sarthak Kukreti <sarthakkukreti-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Nick Desaulniers <ndesaulniers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 23, 2017 at 02:40:40PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> When a filesystem encryption key is removed, we need all files which had
> been "unlocked" (had ->i_crypt_info set up) with it to appear "locked"
> again.  This is most easily done by evicting the inodes.  This can
> currently be done using 'echo 2 > /proc/sys/vm/drop_caches'; however,
> that is overkill and not usable by non-root users.  In preparation for
> allowing fs/crypto/ to evict just the needed inodes, export
> inode_lru_list_del() to modules.
> 
> Signed-off-by: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Michael Halcrow <mhalcrow-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
>  fs/inode.c         | 5 ++---
>  include/linux/fs.h | 1 +
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index d1e35b53bb23..30ce98956801 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -420,13 +420,12 @@ void inode_add_lru(struct inode *inode)
>  		inode_lru_list_add(inode);
>  }
>  
> -
> -static void inode_lru_list_del(struct inode *inode)
> +void inode_lru_list_del(struct inode *inode)
>  {
> -
>  	if (list_lru_del(&inode->i_sb->s_inode_lru, &inode->i_lru))
>  		this_cpu_dec(nr_unused);
>  }
> +EXPORT_SYMBOL_GPL(inode_lru_list_del);
>  
>  /**
>   * inode_sb_list_add - add inode to the superblock list of inodes
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8cfb0877d32c..2833ace2f01d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2879,6 +2879,7 @@ static inline void lockdep_annotate_inode_mutex_key(struct inode *inode) { };
>  extern void unlock_new_inode(struct inode *);
>  extern unsigned int get_next_ino(void);
>  extern void evict_inodes(struct super_block *sb);
> +extern void inode_lru_list_del(struct inode *inode);
>  
>  extern void __iget(struct inode * inode);
>  extern void iget_failed(struct inode *);
> -- 
> 2.15.0.rc0.271.g36b669edcc-goog
> 
