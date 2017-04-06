From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH] fscrypt: Move key structure and constants to uapi
Date: Thu, 6 Apr 2017 21:21:17 +0200
Message-ID: <CAFLxGvyy+W_PCxsBsMtZ7ox1CCNv9sTmQzsiKfeBh9yoMXGreA@mail.gmail.com>
References: <20170404223913.62817-1-joerichey94@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170404223913.62817-1-joerichey94@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Joe Richey <joerichey94@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-fscrypt@vger.kernel.org, "open list:ABI/API" <linux-api@vger.kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Michael Halcrow <mhalcrow@google.com>, Joe Richey <joerichey@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 5, 2017 at 12:39 AM, Joe Richey <joerichey94@gmail.com> wrote:
> From: Joe Richey <joerichey@google.com>
>
> This commit exposes the necessary constants and structures for a
> userspace program to pass filesystem encryption keys into the keyring.
> The fscrypt_key structure was already part of the kernel ABI, this
> change just makes it so programs no longer have to redeclare these
> structures (like e4crypt in e2fsprogs currently does).
>
> Note that we do not expose the other FS_*_KEY_SIZE constants as they are
> not necessary. Only XTS is supported for contents_encryption_mode, so
> currently FS_MAX_KEY_SIZE bytes of key material must always be passed to
> the kernel.
>
> This commit also removes __packed from fscrypt_key as it does not
> contain any implicit padding and does not refer to an on-disk structure.
>
> Change-Id: Iafc7d0f2127a5521a4566e59f2ed1ffc1526a62b

Same here. :)

> Signed-off-by: Joe Richey <joerichey@google.com>
> ---
>  fs/crypto/fscrypt_private.h | 11 -----------
>  include/uapi/linux/fs.h     | 13 +++++++++++++
>  2 files changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index e39696e64494..e08ca6d1ca0f 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -22,10 +22,6 @@
>  #define FS_AES_256_CBC_KEY_SIZE                32
>  #define FS_AES_256_CTS_KEY_SIZE                32
>  #define FS_AES_256_XTS_KEY_SIZE                64
> -#define FS_MAX_KEY_SIZE                        64
> -
> -#define FS_KEY_DESC_PREFIX             "fscrypt:"
> -#define FS_KEY_DESC_PREFIX_SIZE                8
>
>  #define FS_KEY_DERIVATION_NONCE_SIZE           16
>
> @@ -51,13 +47,6 @@ struct fscrypt_context {
>
>  #define FS_ENCRYPTION_CONTEXT_FORMAT_V1                1
>
> -/* This is passed in from userspace into the kernel keyring */
> -struct fscrypt_key {
> -       u32 mode;
> -       u8 raw[FS_MAX_KEY_SIZE];
> -       u32 size;
> -} __packed;
> -
>  /*
>   * A pointer to this structure is stored in the file system's in-core
>   * representation of an inode.
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 048a85e9f017..9691fda01245 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -285,6 +285,19 @@ struct fscrypt_policy {
>  #define FS_IOC_GET_ENCRYPTION_PWSALT   _IOW('f', 20, __u8[16])
>  #define FS_IOC_GET_ENCRYPTION_POLICY   _IOW('f', 21, struct fscrypt_policy)
>
> +/* Parameters for passing an encryption key into the kernel keyring */
> +#define FS_KEY_DESC_PREFIX             "fscrypt:"
> +#define FS_KEY_DESC_PREFIX_SIZE                8
> +
> +/* Structure that userspace passes to the kernel keyring */
> +#define FS_MAX_KEY_SIZE                        64
> +
> +struct fscrypt_key {
> +       __u32 mode;
> +       __u8 raw[FS_MAX_KEY_SIZE];
> +       __u32 size;
> +};
> +

Reviewed-by: Richard Weinberger <richard@nod.at>

-- 
Thanks,
//richard
