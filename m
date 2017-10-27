From: Michael Halcrow via Linux-f2fs-devel
 <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [RFC PATCH 02/25] fscrypt: use FSCRYPT_ prefix for
 uapi constants
Date: Fri, 27 Oct 2017 11:02:57 -0700
Message-ID: <20171027180257.GB10611@google.com>
References: <20171023214058.128121-1-ebiggers3@gmail.com>
 <20171023214058.128121-3-ebiggers3@gmail.com>
Reply-To: Michael Halcrow <mhalcrow@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20171023214058.128121-3-ebiggers3@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Eric Biggers <ebiggers3@gmail.com>
Cc: Ryo Hashimoto <hashimoto@chromium.org>, Gwendal Grignou <gwendal@chromium.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>, linux-api@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 23, 2017 at 02:40:35PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Prefix all filesystem encryption UAPI constants except the ioctl numbers
> with "FSCRYPT_" rather than with "FS_".  This namespaces the constants
> more appropriately and makes it clear that they are related specifically
> to the filesystem encryption feature, and to the 'fscrypt_*' structures.
> With some of the old names like "FS_POLICY_FLAGS_VALID", it was not
> immediately clear that the constant had anything to do with encryption.
> 
> This is also useful because we'll be adding more encryption-related
> constants, e.g. for the policy version, and we'd otherwise have to
> choose whether to use unclear names like FS_POLICY_VERSION_* or
> inconsistent names like FS_ENCRYPTION_POLICY_VERSION_*.
> 
> For source compatibility with older userspace programs, keep the old
> names defined as aliases to the new ones.  (It's debatable whether we
> really need this, though; the filesystem encryption API is new enough
> that most if not all programs that are using it have to declare it
> themselves anyway.)
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Michael Halcrow <mhalcrow@google.com>

> ---
>  Documentation/filesystems/fscrypt.rst | 14 ++++-----
>  include/uapi/linux/fscrypt.h          | 59 ++++++++++++++++++++++++-----------
>  2 files changed, 47 insertions(+), 26 deletions(-)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 776ddc655f79..f12956f3f1f8 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -251,14 +251,14 @@ empty directory or verifies that a directory or regular file already
>  has the specified encryption policy.  It takes in a pointer to a
>  :c:type:`struct fscrypt_policy`, defined as follows::
>  
> -    #define FS_KEY_DESCRIPTOR_SIZE  8
> +    #define FSCRYPT_KEY_DESCRIPTOR_SIZE  8
>  
>      struct fscrypt_policy {
>              __u8 version;
>              __u8 contents_encryption_mode;
>              __u8 filenames_encryption_mode;
>              __u8 flags;
> -            __u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE];
> +            __u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
>      };
>  
>  This structure must be initialized as follows:
> @@ -274,7 +274,7 @@ This structure must be initialized as follows:
>  
>  - ``flags`` must be set to a value from ``<linux/fs.h>`` which
>    identifies the amount of NUL-padding to use when encrypting
> -  filenames.  If unsure, use FS_POLICY_FLAGS_PAD_32 (0x3).
> +  filenames.  If unsure, use FSCRYPT_POLICY_FLAGS_PAD_32 (0x3).
>  
>  - ``master_key_descriptor`` specifies how to find the master key in
>    the keyring; see `Adding keys`_.  It is up to userspace to choose a
> @@ -374,11 +374,11 @@ followed by the 16-character lower case hex representation of the
>  ``master_key_descriptor`` that was set in the encryption policy.  The
>  key payload must conform to the following structure::
>  
> -    #define FS_MAX_KEY_SIZE 64
> +    #define FSCRYPT_MAX_KEY_SIZE 64
>  
>      struct fscrypt_key {
>              u32 mode;
> -            u8 raw[FS_MAX_KEY_SIZE];
> +            u8 raw[FSCRYPT_MAX_KEY_SIZE];
>              u32 size;
>      };
>  
> @@ -533,7 +533,7 @@ much confusion if an encryption policy were to be added to or removed
>  from anything other than an empty directory.)  The struct is defined
>  as follows::
>  
> -    #define FS_KEY_DESCRIPTOR_SIZE  8
> +    #define FSCRYPT_KEY_DESCRIPTOR_SIZE  8
>      #define FS_KEY_DERIVATION_NONCE_SIZE 16
>  
>      struct fscrypt_context {
> @@ -541,7 +541,7 @@ as follows::
>              u8 contents_encryption_mode;
>              u8 filenames_encryption_mode;
>              u8 flags;
> -            u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE];
> +            u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
>              u8 nonce[FS_KEY_DERIVATION_NONCE_SIZE];
>      };
>  
> diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
> index c09209fc42ea..26c381a40279 100644
> --- a/include/uapi/linux/fscrypt.h
> +++ b/include/uapi/linux/fscrypt.h
> @@ -7,30 +7,31 @@
>   * File system encryption support
>   */
>  /* Policy provided via an ioctl on the topmost directory */
> -#define FS_KEY_DESCRIPTOR_SIZE	8
> +#define FSCRYPT_KEY_DESCRIPTOR_SIZE	8
>  
> -#define FS_POLICY_FLAGS_PAD_4		0x00
> -#define FS_POLICY_FLAGS_PAD_8		0x01
> -#define FS_POLICY_FLAGS_PAD_16		0x02
> -#define FS_POLICY_FLAGS_PAD_32		0x03
> -#define FS_POLICY_FLAGS_PAD_MASK	0x03
> -#define FS_POLICY_FLAGS_VALID		0x03
> +/* Encryption policy flags */
> +#define FSCRYPT_POLICY_FLAGS_PAD_4	0x00
> +#define FSCRYPT_POLICY_FLAGS_PAD_8	0x01
> +#define FSCRYPT_POLICY_FLAGS_PAD_16	0x02
> +#define FSCRYPT_POLICY_FLAGS_PAD_32	0x03
> +#define FSCRYPT_POLICY_FLAGS_PAD_MASK	0x03
> +#define FSCRYPT_POLICY_FLAGS_VALID	0x03
>  
>  /* Encryption algorithms */
> -#define FS_ENCRYPTION_MODE_INVALID		0
> -#define FS_ENCRYPTION_MODE_AES_256_XTS		1
> -#define FS_ENCRYPTION_MODE_AES_256_GCM		2
> -#define FS_ENCRYPTION_MODE_AES_256_CBC		3
> -#define FS_ENCRYPTION_MODE_AES_256_CTS		4
> -#define FS_ENCRYPTION_MODE_AES_128_CBC		5
> -#define FS_ENCRYPTION_MODE_AES_128_CTS		6
> +#define FSCRYPT_MODE_INVALID		0
> +#define FSCRYPT_MODE_AES_256_XTS	1
> +#define FSCRYPT_MODE_AES_256_GCM	2
> +#define FSCRYPT_MODE_AES_256_CBC	3
> +#define FSCRYPT_MODE_AES_256_CTS	4
> +#define FSCRYPT_MODE_AES_128_CBC	5
> +#define FSCRYPT_MODE_AES_128_CTS	6
>  
>  struct fscrypt_policy {
>  	__u8 version;
>  	__u8 contents_encryption_mode;
>  	__u8 filenames_encryption_mode;
>  	__u8 flags;
> -	__u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE];
> +	__u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
>  };
>  
>  #define FS_IOC_SET_ENCRYPTION_POLICY	_IOR('f', 19, struct fscrypt_policy)
> @@ -38,16 +39,36 @@ struct fscrypt_policy {
>  #define FS_IOC_GET_ENCRYPTION_POLICY	_IOW('f', 21, struct fscrypt_policy)
>  
>  /* Parameters for passing an encryption key into the kernel keyring */
> -#define FS_KEY_DESC_PREFIX		"fscrypt:"
> -#define FS_KEY_DESC_PREFIX_SIZE		8
> +#define FSCRYPT_KEY_DESC_PREFIX		"fscrypt:"
> +#define FSCRYPT_KEY_DESC_PREFIX_SIZE		8
>  
>  /* Structure that userspace passes to the kernel keyring */
> -#define FS_MAX_KEY_SIZE			64
> +#define FSCRYPT_MAX_KEY_SIZE			64
>  
>  struct fscrypt_key {
>  	__u32 mode;
> -	__u8 raw[FS_MAX_KEY_SIZE];
> +	__u8 raw[FSCRYPT_MAX_KEY_SIZE];
>  	__u32 size;
>  };
> +/**********************************************************************/
> +
> +/* old names; don't add anything new here! */
> +#define FS_POLICY_FLAGS_PAD_4		FSCRYPT_POLICY_FLAGS_PAD_4
> +#define FS_POLICY_FLAGS_PAD_8		FSCRYPT_POLICY_FLAGS_PAD_8
> +#define FS_POLICY_FLAGS_PAD_16		FSCRYPT_POLICY_FLAGS_PAD_16
> +#define FS_POLICY_FLAGS_PAD_32		FSCRYPT_POLICY_FLAGS_PAD_32
> +#define FS_POLICY_FLAGS_PAD_MASK	FSCRYPT_POLICY_FLAGS_PAD_MASK
> +#define FS_POLICY_FLAGS_VALID		FSCRYPT_POLICY_FLAGS_VALID
> +#define FS_KEY_DESCRIPTOR_SIZE		FSCRYPT_KEY_DESCRIPTOR_SIZE
> +#define FS_ENCRYPTION_MODE_INVALID	FSCRYPT_MODE_INVALID
> +#define FS_ENCRYPTION_MODE_AES_256_XTS	FSCRYPT_MODE_AES_256_XTS
> +#define FS_ENCRYPTION_MODE_AES_256_GCM	FSCRYPT_MODE_AES_256_GCM
> +#define FS_ENCRYPTION_MODE_AES_256_CBC	FSCRYPT_MODE_AES_256_CBC
> +#define FS_ENCRYPTION_MODE_AES_256_CTS	FSCRYPT_MODE_AES_256_CTS
> +#define FS_ENCRYPTION_MODE_AES_128_CBC	FSCRYPT_MODE_AES_128_CBC
> +#define FS_ENCRYPTION_MODE_AES_128_CTS	FSCRYPT_MODE_AES_128_CTS
> +#define FS_KEY_DESC_PREFIX		FSCRYPT_KEY_DESC_PREFIX
> +#define FS_KEY_DESC_PREFIX_SIZE		FSCRYPT_KEY_DESC_PREFIX_SIZE
> +#define FS_MAX_KEY_SIZE			FSCRYPT_MAX_KEY_SIZE
>  
>  #endif /* _UAPI_LINUX_FSCRYPT_H */
> -- 
> 2.15.0.rc0.271.g36b669edcc-goog
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
