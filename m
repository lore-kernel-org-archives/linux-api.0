From: Michael Halcrow <mhalcrow-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 03/25] fscrypt: use FSCRYPT_* definitions, not FS_*
Date: Fri, 27 Oct 2017 11:06:37 -0700
Message-ID: <20171027180637.GC10611@google.com>
References: <20171023214058.128121-1-ebiggers3@gmail.com>
 <20171023214058.128121-4-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171023214058.128121-4-ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Theodore Y . Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Gwendal Grignou <gwendal-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Ryo Hashimoto <hashimoto-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Sarthak Kukreti <sarthakkukreti-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Nick Desaulniers <ndesaulniers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 23, 2017 at 02:40:36PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Update the filesystem encryption kernel code to use the new names for
> the UAPI constants rather than the old names.
> 
> Signed-off-by: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Michael Halcrow <mhalcrow-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
>  fs/crypto/fname.c           |  4 ++--
>  fs/crypto/fscrypt_private.h |  4 ++--
>  fs/crypto/keyinfo.c         | 36 +++++++++++++++++-------------------
>  fs/crypto/policy.c          | 14 +++++++-------
>  include/linux/fscrypt.h     |  8 ++++----
>  5 files changed, 32 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
> index 2878289b3ed2..c91bcef65b9f 100644
> --- a/fs/crypto/fname.c
> +++ b/fs/crypto/fname.c
> @@ -46,7 +46,7 @@ static int fname_encrypt(struct inode *inode,
>  	int res = 0;
>  	char iv[FS_CRYPTO_BLOCK_SIZE];
>  	struct scatterlist sg;
> -	int padding = 4 << (ci->ci_flags & FS_POLICY_FLAGS_PAD_MASK);
> +	int padding = 4 << (ci->ci_flags & FSCRYPT_POLICY_FLAGS_PAD_MASK);
>  	unsigned int lim;
>  	unsigned int cryptlen;
>  
> @@ -217,7 +217,7 @@ u32 fscrypt_fname_encrypted_size(const struct inode *inode, u32 ilen)
>  	struct fscrypt_info *ci = inode->i_crypt_info;
>  
>  	if (ci)
> -		padding = 4 << (ci->ci_flags & FS_POLICY_FLAGS_PAD_MASK);
> +		padding = 4 << (ci->ci_flags & FSCRYPT_POLICY_FLAGS_PAD_MASK);
>  	ilen = max(ilen, (u32)FS_CRYPTO_BLOCK_SIZE);
>  	return round_up(ilen, padding);
>  }
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index a180981ee6d7..5cb80a2d39ea 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -43,7 +43,7 @@ struct fscrypt_context {
>  	u8 contents_encryption_mode;
>  	u8 filenames_encryption_mode;
>  	u8 flags;
> -	u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE];
> +	u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
>  	u8 nonce[FS_KEY_DERIVATION_NONCE_SIZE];
>  } __packed;
>  
> @@ -59,7 +59,7 @@ struct fscrypt_info {
>  	u8 ci_flags;
>  	struct crypto_skcipher *ci_ctfm;
>  	struct crypto_cipher *ci_essiv_tfm;
> -	u8 ci_master_key[FS_KEY_DESCRIPTOR_SIZE];
> +	u8 ci_master_key[FSCRYPT_KEY_DESCRIPTOR_SIZE];
>  };
>  
>  typedef enum {
> diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
> index 7aed93bcfb82..ac41f646e7b7 100644
> --- a/fs/crypto/keyinfo.c
> +++ b/fs/crypto/keyinfo.c
> @@ -38,7 +38,7 @@ static void derive_crypt_complete(struct crypto_async_request *req, int rc)
>   */
>  static int derive_key_aes(u8 deriving_key[FS_AES_128_ECB_KEY_SIZE],
>  				const struct fscrypt_key *source_key,
> -				u8 derived_raw_key[FS_MAX_KEY_SIZE])
> +				u8 derived_raw_key[FSCRYPT_MAX_KEY_SIZE])
>  {
>  	int res = 0;
>  	struct skcipher_request *req = NULL;
> @@ -91,7 +91,7 @@ static int validate_user_key(struct fscrypt_info *crypt_info,
>  	int res;
>  
>  	description = kasprintf(GFP_NOFS, "%s%*phN", prefix,
> -				FS_KEY_DESCRIPTOR_SIZE,
> +				FSCRYPT_KEY_DESCRIPTOR_SIZE,
>  				ctx->master_key_descriptor);
>  	if (!description)
>  		return -ENOMEM;
> @@ -121,7 +121,8 @@ static int validate_user_key(struct fscrypt_info *crypt_info,
>  	master_key = (struct fscrypt_key *)ukp->data;
>  	BUILD_BUG_ON(FS_AES_128_ECB_KEY_SIZE != FS_KEY_DERIVATION_NONCE_SIZE);
>  
> -	if (master_key->size < min_keysize || master_key->size > FS_MAX_KEY_SIZE
> +	if (master_key->size < min_keysize ||
> +	    master_key->size > FSCRYPT_MAX_KEY_SIZE
>  	    || master_key->size % AES_BLOCK_SIZE != 0) {

Format nit: This makes the placement of "||" inconsistent across lines
in this same expression.

>  		printk_once(KERN_WARNING
>  				"%s: key size incorrect: %d\n",
> @@ -140,14 +141,10 @@ static const struct {
>  	const char *cipher_str;
>  	int keysize;
>  } available_modes[] = {
> -	[FS_ENCRYPTION_MODE_AES_256_XTS] = { "xts(aes)",
> -					     FS_AES_256_XTS_KEY_SIZE },
> -	[FS_ENCRYPTION_MODE_AES_256_CTS] = { "cts(cbc(aes))",
> -					     FS_AES_256_CTS_KEY_SIZE },
> -	[FS_ENCRYPTION_MODE_AES_128_CBC] = { "cbc(aes)",
> -					     FS_AES_128_CBC_KEY_SIZE },
> -	[FS_ENCRYPTION_MODE_AES_128_CTS] = { "cts(cbc(aes))",
> -					     FS_AES_128_CTS_KEY_SIZE },
> +	[FSCRYPT_MODE_AES_256_XTS] = { "xts(aes)", FS_AES_256_XTS_KEY_SIZE },
> +	[FSCRYPT_MODE_AES_256_CTS] = { "cts(cbc(aes))", FS_AES_256_CTS_KEY_SIZE },
> +	[FSCRYPT_MODE_AES_128_CBC] = { "cbc(aes)", FS_AES_128_CBC_KEY_SIZE },
> +	[FSCRYPT_MODE_AES_128_CTS] = { "cts(cbc(aes))", FS_AES_128_CTS_KEY_SIZE },
>  };
>  
>  static int determine_cipher_type(struct fscrypt_info *ci, struct inode *inode,
> @@ -278,9 +275,10 @@ int fscrypt_get_encryption_info(struct inode *inode)
>  		/* Fake up a context for an unencrypted directory */
>  		memset(&ctx, 0, sizeof(ctx));
>  		ctx.format = FS_ENCRYPTION_CONTEXT_FORMAT_V1;
> -		ctx.contents_encryption_mode = FS_ENCRYPTION_MODE_AES_256_XTS;
> -		ctx.filenames_encryption_mode = FS_ENCRYPTION_MODE_AES_256_CTS;
> -		memset(ctx.master_key_descriptor, 0x42, FS_KEY_DESCRIPTOR_SIZE);
> +		ctx.contents_encryption_mode = FSCRYPT_MODE_AES_256_XTS;
> +		ctx.filenames_encryption_mode = FSCRYPT_MODE_AES_256_CTS;
> +		memset(ctx.master_key_descriptor, 0x42,
> +		       FSCRYPT_KEY_DESCRIPTOR_SIZE);
>  	} else if (res != sizeof(ctx)) {
>  		return -EINVAL;
>  	}
> @@ -288,7 +286,7 @@ int fscrypt_get_encryption_info(struct inode *inode)
>  	if (ctx.format != FS_ENCRYPTION_CONTEXT_FORMAT_V1)
>  		return -EINVAL;
>  
> -	if (ctx.flags & ~FS_POLICY_FLAGS_VALID)
> +	if (ctx.flags & ~FSCRYPT_POLICY_FLAGS_VALID)
>  		return -EINVAL;
>  
>  	crypt_info = kmem_cache_alloc(fscrypt_info_cachep, GFP_NOFS);
> @@ -312,12 +310,12 @@ int fscrypt_get_encryption_info(struct inode *inode)
>  	 * crypto API as part of key derivation.
>  	 */
>  	res = -ENOMEM;
> -	raw_key = kmalloc(FS_MAX_KEY_SIZE, GFP_NOFS);
> +	raw_key = kmalloc(FSCRYPT_MAX_KEY_SIZE, GFP_NOFS);
>  	if (!raw_key)
>  		goto out;
>  
> -	res = validate_user_key(crypt_info, &ctx, raw_key, FS_KEY_DESC_PREFIX,
> -				keysize);
> +	res = validate_user_key(crypt_info, &ctx, raw_key,
> +				FSCRYPT_KEY_DESC_PREFIX, keysize);
>  	if (res && inode->i_sb->s_cop->key_prefix) {
>  		int res2 = validate_user_key(crypt_info, &ctx, raw_key,
>  					     inode->i_sb->s_cop->key_prefix,
> @@ -349,7 +347,7 @@ int fscrypt_get_encryption_info(struct inode *inode)
>  		goto out;
>  
>  	if (S_ISREG(inode->i_mode) &&
> -	    crypt_info->ci_data_mode == FS_ENCRYPTION_MODE_AES_128_CBC) {
> +	    crypt_info->ci_data_mode == FSCRYPT_MODE_AES_128_CBC) {
>  		res = init_essiv_generator(crypt_info, raw_key, keysize);
>  		if (res) {
>  			pr_debug("%s: error %d (inode %lu) allocating essiv tfm\n",
> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> index 6a63b8a0d46c..19332a6fd52d 100644
> --- a/fs/crypto/policy.c
> +++ b/fs/crypto/policy.c
> @@ -21,7 +21,7 @@ static bool is_encryption_context_consistent_with_policy(
>  				const struct fscrypt_policy *policy)
>  {
>  	return memcmp(ctx->master_key_descriptor, policy->master_key_descriptor,
> -		      FS_KEY_DESCRIPTOR_SIZE) == 0 &&
> +		      FSCRYPT_KEY_DESCRIPTOR_SIZE) == 0 &&
>  		(ctx->flags == policy->flags) &&
>  		(ctx->contents_encryption_mode ==
>  		 policy->contents_encryption_mode) &&
> @@ -36,13 +36,13 @@ static int create_encryption_context_from_policy(struct inode *inode,
>  
>  	ctx.format = FS_ENCRYPTION_CONTEXT_FORMAT_V1;
>  	memcpy(ctx.master_key_descriptor, policy->master_key_descriptor,
> -					FS_KEY_DESCRIPTOR_SIZE);
> +					FSCRYPT_KEY_DESCRIPTOR_SIZE);
>  
>  	if (!fscrypt_valid_enc_modes(policy->contents_encryption_mode,
>  				     policy->filenames_encryption_mode))
>  		return -EINVAL;
>  
> -	if (policy->flags & ~FS_POLICY_FLAGS_VALID)
> +	if (policy->flags & ~FSCRYPT_POLICY_FLAGS_VALID)
>  		return -EINVAL;
>  
>  	ctx.contents_encryption_mode = policy->contents_encryption_mode;
> @@ -125,7 +125,7 @@ int fscrypt_ioctl_get_policy(struct file *filp, void __user *arg)
>  	policy.filenames_encryption_mode = ctx.filenames_encryption_mode;
>  	policy.flags = ctx.flags;
>  	memcpy(policy.master_key_descriptor, ctx.master_key_descriptor,
> -				FS_KEY_DESCRIPTOR_SIZE);
> +				FSCRYPT_KEY_DESCRIPTOR_SIZE);
>  
>  	if (copy_to_user(arg, &policy, sizeof(policy)))
>  		return -EFAULT;
> @@ -199,7 +199,7 @@ int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
>  
>  	if (parent_ci && child_ci) {
>  		return memcmp(parent_ci->ci_master_key, child_ci->ci_master_key,
> -			      FS_KEY_DESCRIPTOR_SIZE) == 0 &&
> +			      FSCRYPT_KEY_DESCRIPTOR_SIZE) == 0 &&
>  			(parent_ci->ci_data_mode == child_ci->ci_data_mode) &&
>  			(parent_ci->ci_filename_mode ==
>  			 child_ci->ci_filename_mode) &&
> @@ -216,7 +216,7 @@ int fscrypt_has_permitted_context(struct inode *parent, struct inode *child)
>  
>  	return memcmp(parent_ctx.master_key_descriptor,
>  		      child_ctx.master_key_descriptor,
> -		      FS_KEY_DESCRIPTOR_SIZE) == 0 &&
> +		      FSCRYPT_KEY_DESCRIPTOR_SIZE) == 0 &&
>  		(parent_ctx.contents_encryption_mode ==
>  		 child_ctx.contents_encryption_mode) &&
>  		(parent_ctx.filenames_encryption_mode ==
> @@ -254,7 +254,7 @@ int fscrypt_inherit_context(struct inode *parent, struct inode *child,
>  	ctx.filenames_encryption_mode = ci->ci_filename_mode;
>  	ctx.flags = ci->ci_flags;
>  	memcpy(ctx.master_key_descriptor, ci->ci_master_key,
> -	       FS_KEY_DESCRIPTOR_SIZE);
> +	       FSCRYPT_KEY_DESCRIPTOR_SIZE);
>  	get_random_bytes(ctx.nonce, FS_KEY_DERIVATION_NONCE_SIZE);
>  	BUILD_BUG_ON(sizeof(ctx) != FSCRYPT_SET_CONTEXT_MAX_SIZE);
>  	res = parent->i_sb->s_cop->set_context(child, &ctx,
> diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
> index f7aa7d62e235..671ce57e4673 100644
> --- a/include/linux/fscrypt.h
> +++ b/include/linux/fscrypt.h
> @@ -99,12 +99,12 @@ static inline bool fscrypt_dummy_context_enabled(struct inode *inode)
>  static inline bool fscrypt_valid_enc_modes(u32 contents_mode,
>  					u32 filenames_mode)
>  {
> -	if (contents_mode == FS_ENCRYPTION_MODE_AES_128_CBC &&
> -	    filenames_mode == FS_ENCRYPTION_MODE_AES_128_CTS)
> +	if (contents_mode == FSCRYPT_MODE_AES_128_CBC &&
> +	    filenames_mode == FSCRYPT_MODE_AES_128_CTS)
>  		return true;
>  
> -	if (contents_mode == FS_ENCRYPTION_MODE_AES_256_XTS &&
> -	    filenames_mode == FS_ENCRYPTION_MODE_AES_256_CTS)
> +	if (contents_mode == FSCRYPT_MODE_AES_256_XTS &&
> +	    filenames_mode == FSCRYPT_MODE_AES_256_CTS)
>  		return true;
>  
>  	return false;
> -- 
> 2.15.0.rc0.271.g36b669edcc-goog
> 
