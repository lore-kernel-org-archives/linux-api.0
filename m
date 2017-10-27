From: Michael Halcrow <mhalcrow@google.com>
Subject: Re: [RFC PATCH 06/25] fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY ioctl
Date: Fri, 27 Oct 2017 13:14:46 -0700
Message-ID: <20171027201446.GF10611@google.com>
References: <20171023214058.128121-1-ebiggers3@gmail.com>
 <20171023214058.128121-7-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171023214058.128121-7-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, linux-api@vger.kernel.org, keyrings@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Gwendal Grignou <gwendal@chromium.org>, Ryo Hashimoto <hashimoto@chromium.org>, Sarthak Kukreti <sarthakkukreti@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, Eric Biggers <ebiggers@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 23, 2017 at 02:40:39PM -0700, Eric Biggers wrote:
> By having an API to add a key to the *filesystem* we'll be able to
> eliminate all the above hacks and better express the intended semantics:
> the "locked/unlocked" status of an encrypted directory is global.  And
> orthogonally to encryption, existing mechanisms such as file permissions
> and LSMs can and should continue to be used for the purpose of *access
> control*.

At some point I'd like to try to tackle the problem of making the
encryption policy somehow *reflect* the access control policy.

For now this change cleans up a real mess and makes things much more
manageable and predictable.

> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Michael Halcrow <mhalcrow@google.com>

> ---
>  fs/crypto/crypto.c              |  12 +-
>  fs/crypto/fscrypt_private.h     |   3 +
>  fs/crypto/keyinfo.c             | 351 +++++++++++++++++++++++++++++++++++++++-
>  include/linux/fscrypt_notsupp.h |   5 +
>  include/linux/fscrypt_supp.h    |   1 +
>  include/uapi/linux/fscrypt.h    |  41 +++--
>  6 files changed, 397 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index 608f6bbe0f31..489c504ac20d 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -24,6 +24,7 @@
>  #include <linux/module.h>
>  #include <linux/scatterlist.h>
>  #include <linux/ratelimit.h>
> +#include <linux/key-type.h>
>  #include <linux/dcache.h>
>  #include <linux/namei.h>
>  #include <crypto/aes.h>
> @@ -449,6 +450,8 @@ int fscrypt_initialize(unsigned int cop_flags)
>   */
>  static int __init fscrypt_init(void)
>  {
> +	int err = -ENOMEM;
> +
>  	fscrypt_read_workqueue = alloc_workqueue("fscrypt_read_queue",
>  							WQ_HIGHPRI, 0);
>  	if (!fscrypt_read_workqueue)
> @@ -462,14 +465,20 @@ static int __init fscrypt_init(void)
>  	if (!fscrypt_info_cachep)
>  		goto fail_free_ctx;
>  
> +	err = register_key_type(&key_type_fscrypt_mk);
> +	if (err)
> +		goto fail_free_info;
> +
>  	return 0;
>  
> +fail_free_info:
> +	kmem_cache_destroy(fscrypt_info_cachep);
>  fail_free_ctx:
>  	kmem_cache_destroy(fscrypt_ctx_cachep);
>  fail_free_queue:
>  	destroy_workqueue(fscrypt_read_workqueue);
>  fail:
> -	return -ENOMEM;
> +	return err;
>  }
>  module_init(fscrypt_init)
>  
> @@ -484,6 +493,7 @@ static void __exit fscrypt_exit(void)
>  		destroy_workqueue(fscrypt_read_workqueue);
>  	kmem_cache_destroy(fscrypt_ctx_cachep);
>  	kmem_cache_destroy(fscrypt_info_cachep);
> +	unregister_key_type(&key_type_fscrypt_mk);
>  
>  	fscrypt_essiv_cleanup();
>  }
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 5cb80a2d39ea..b2fad12eeedb 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -27,6 +27,8 @@
>  
>  #define FS_KEY_DERIVATION_NONCE_SIZE		16
>  
> +#define FSCRYPT_MIN_KEY_SIZE		16
> +
>  /**
>   * Encryption context for inode
>   *
> @@ -93,6 +95,7 @@ extern struct page *fscrypt_alloc_bounce_page(struct fscrypt_ctx *ctx,
>  					      gfp_t gfp_flags);
>  
>  /* keyinfo.c */
> +extern struct key_type key_type_fscrypt_mk;
>  extern void __exit fscrypt_essiv_cleanup(void);
>  
>  #endif /* _FSCRYPT_PRIVATE_H */
> diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
> index d3a97c2cd4dd..3f1cb8bbc1e5 100644
> --- a/fs/crypto/keyinfo.c
> +++ b/fs/crypto/keyinfo.c
> @@ -9,14 +9,307 @@
>   */
>  
>  #include <keys/user-type.h>
> -#include <linux/scatterlist.h>
> +#include <linux/key-type.h>
>  #include <linux/ratelimit.h>
> +#include <linux/scatterlist.h>
> +#include <linux/seq_file.h>
>  #include <crypto/aes.h>
>  #include <crypto/sha.h>
>  #include "fscrypt_private.h"
>  
>  static struct crypto_shash *essiv_hash_tfm;
>  
> +/*
> + * fscrypt_master_key_secret - secret key material of an in-use master key
> + */
> +struct fscrypt_master_key_secret {
> +
> +	/* Size of the raw key in bytes */
> +	u32			size;
> +
> +	/* The raw key */
> +	u8			raw[FSCRYPT_MAX_KEY_SIZE];
> +};

With structs fscrypt introduces, I suggest __randomize_layout wherever
feasible.

> +#define FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE	\
> +	(sizeof("fscrypt-") - 1 + sizeof(((struct super_block
> *)0)->s_id) + 1)

What function do the " - 1" and " + 1" parts serve here?  Readability?

> +	key = find_master_key(inode->i_sb, &mk_spec);
> +	if (IS_ERR(key)) {
> +		if (key != ERR_PTR(-ENOKEY))
> +			return PTR_ERR(key);
> +		/*
> +		 * As a legacy fallback, we search the current task's subscribed
> +		 * keyrings in addition to ->s_master_keys.

Please add an explicit comment that it's important for security that
the ordering of these two searches be preserved.

> +		 */
> +		return find_and_derive_key_legacy(inode, ctx, derived_key,
> +						  derived_keysize);
> +	}
> +	mk = key->payload.data[0];
> +
> +	/*
> +	 * Require that the master key be at least as long as the derived key.
> +	 * Otherwise, the derived key cannot possibly contain as much entropy as
> +	 * that required by the encryption mode it will be used for.
> +	 */
> +	if (mk->mk_secret.size < derived_keysize) {

As I've mentioned in a previous patch in this set, if we're going to
get opinionated about source entropy, there's more we could
measure/estimate than just the length.
