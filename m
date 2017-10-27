From: Michael Halcrow <mhalcrow@google.com>
Subject: Re: [RFC PATCH 01/25] fs, fscrypt: move uapi definitions to new
 header <linux/fscrypt.h>
Date: Fri, 27 Oct 2017 11:01:41 -0700
Message-ID: <20171027180141.GA10611@google.com>
References: <20171023214058.128121-1-ebiggers3@gmail.com>
 <20171023214058.128121-2-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171023214058.128121-2-ebiggers3@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, linux-api@vger.kernel.org, keyrings@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Gwendal Grignou <gwendal@chromium.org>, Ryo Hashimoto <hashimoto@chromium.org>, Sarthak Kukreti <sarthakkukreti@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, Eric Biggers <ebiggers@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 23, 2017 at 02:40:34PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> There are going to be more filesystem encryption definitions added, and
> we don't want to use a disproportionate amount of space in <linux/fs.h>
> for filesystem encryption stuff.  So move the fscrypt definitions to a
> new header <linux/fscrypt.h>.
> 
> For compatibility with existing userspace programs which may be
> including <linux/fs.h>, <linux/fs.h> still includes the new header.
> (It's debatable whether we really need this, though; the filesystem
> encryption API is new enough that most if not all programs that are
> using it have to declare it themselves anyway.)
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Michael Halcrow <mhalcrow@google.com>

> ---
>  include/linux/fscrypt.h      |  2 +-
>  include/uapi/linux/fs.h      | 50 +++--------------------------------------
>  include/uapi/linux/fscrypt.h | 53 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 57 insertions(+), 48 deletions(-)
>  create mode 100644 include/uapi/linux/fscrypt.h
> 
> diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
> index 53437bfdfcbc..f7aa7d62e235 100644
> --- a/include/linux/fscrypt.h
> +++ b/include/linux/fscrypt.h
> @@ -19,7 +19,7 @@
>  #include <linux/bio.h>
>  #include <linux/dcache.h>
>  #include <crypto/skcipher.h>
> -#include <uapi/linux/fs.h>
> +#include <uapi/linux/fscrypt.h>
>  
>  #define FS_CRYPTO_BLOCK_SIZE		16
>  
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 56235dddea7d..6ecd3ee9960c 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -12,6 +12,9 @@
>  #include <linux/limits.h>
>  #include <linux/ioctl.h>
>  #include <linux/types.h>
> +#ifndef __KERNEL__
> +#include <linux/fscrypt.h>
> +#endif
>  
>  /*
>   * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
> @@ -253,53 +256,6 @@ struct fsxattr {
>  #define FS_IOC_FSGETXATTR		_IOR ('X', 31, struct fsxattr)
>  #define FS_IOC_FSSETXATTR		_IOW ('X', 32, struct fsxattr)
>  
> -/*
> - * File system encryption support
> - */
> -/* Policy provided via an ioctl on the topmost directory */
> -#define FS_KEY_DESCRIPTOR_SIZE	8
> -
> -#define FS_POLICY_FLAGS_PAD_4		0x00
> -#define FS_POLICY_FLAGS_PAD_8		0x01
> -#define FS_POLICY_FLAGS_PAD_16		0x02
> -#define FS_POLICY_FLAGS_PAD_32		0x03
> -#define FS_POLICY_FLAGS_PAD_MASK	0x03
> -#define FS_POLICY_FLAGS_VALID		0x03
> -
> -/* Encryption algorithms */
> -#define FS_ENCRYPTION_MODE_INVALID		0
> -#define FS_ENCRYPTION_MODE_AES_256_XTS		1
> -#define FS_ENCRYPTION_MODE_AES_256_GCM		2
> -#define FS_ENCRYPTION_MODE_AES_256_CBC		3
> -#define FS_ENCRYPTION_MODE_AES_256_CTS		4
> -#define FS_ENCRYPTION_MODE_AES_128_CBC		5
> -#define FS_ENCRYPTION_MODE_AES_128_CTS		6
> -
> -struct fscrypt_policy {
> -	__u8 version;
> -	__u8 contents_encryption_mode;
> -	__u8 filenames_encryption_mode;
> -	__u8 flags;
> -	__u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE];
> -};
> -
> -#define FS_IOC_SET_ENCRYPTION_POLICY	_IOR('f', 19, struct fscrypt_policy)
> -#define FS_IOC_GET_ENCRYPTION_PWSALT	_IOW('f', 20, __u8[16])
> -#define FS_IOC_GET_ENCRYPTION_POLICY	_IOW('f', 21, struct fscrypt_policy)
> -
> -/* Parameters for passing an encryption key into the kernel keyring */
> -#define FS_KEY_DESC_PREFIX		"fscrypt:"
> -#define FS_KEY_DESC_PREFIX_SIZE		8
> -
> -/* Structure that userspace passes to the kernel keyring */
> -#define FS_MAX_KEY_SIZE			64
> -
> -struct fscrypt_key {
> -	__u32 mode;
> -	__u8 raw[FS_MAX_KEY_SIZE];
> -	__u32 size;
> -};
> -
>  /*
>   * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
>   *
> diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
> new file mode 100644
> index 000000000000..c09209fc42ea
> --- /dev/null
> +++ b/include/uapi/linux/fscrypt.h
> @@ -0,0 +1,53 @@
> +#ifndef _UAPI_LINUX_FSCRYPT_H
> +#define _UAPI_LINUX_FSCRYPT_H
> +
> +#include <linux/types.h>
> +
> +/*
> + * File system encryption support
> + */
> +/* Policy provided via an ioctl on the topmost directory */
> +#define FS_KEY_DESCRIPTOR_SIZE	8
> +
> +#define FS_POLICY_FLAGS_PAD_4		0x00
> +#define FS_POLICY_FLAGS_PAD_8		0x01
> +#define FS_POLICY_FLAGS_PAD_16		0x02
> +#define FS_POLICY_FLAGS_PAD_32		0x03
> +#define FS_POLICY_FLAGS_PAD_MASK	0x03
> +#define FS_POLICY_FLAGS_VALID		0x03
> +
> +/* Encryption algorithms */
> +#define FS_ENCRYPTION_MODE_INVALID		0
> +#define FS_ENCRYPTION_MODE_AES_256_XTS		1
> +#define FS_ENCRYPTION_MODE_AES_256_GCM		2
> +#define FS_ENCRYPTION_MODE_AES_256_CBC		3
> +#define FS_ENCRYPTION_MODE_AES_256_CTS		4
> +#define FS_ENCRYPTION_MODE_AES_128_CBC		5
> +#define FS_ENCRYPTION_MODE_AES_128_CTS		6
> +
> +struct fscrypt_policy {
> +	__u8 version;
> +	__u8 contents_encryption_mode;
> +	__u8 filenames_encryption_mode;
> +	__u8 flags;
> +	__u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE];
> +};
> +
> +#define FS_IOC_SET_ENCRYPTION_POLICY	_IOR('f', 19, struct fscrypt_policy)
> +#define FS_IOC_GET_ENCRYPTION_PWSALT	_IOW('f', 20, __u8[16])
> +#define FS_IOC_GET_ENCRYPTION_POLICY	_IOW('f', 21, struct fscrypt_policy)
> +
> +/* Parameters for passing an encryption key into the kernel keyring */
> +#define FS_KEY_DESC_PREFIX		"fscrypt:"
> +#define FS_KEY_DESC_PREFIX_SIZE		8
> +
> +/* Structure that userspace passes to the kernel keyring */
> +#define FS_MAX_KEY_SIZE			64
> +
> +struct fscrypt_key {
> +	__u32 mode;
> +	__u8 raw[FS_MAX_KEY_SIZE];
> +	__u32 size;
> +};
> +
> +#endif /* _UAPI_LINUX_FSCRYPT_H */
> -- 
> 2.15.0.rc0.271.g36b669edcc-goog
> 
