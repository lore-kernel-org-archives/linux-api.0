From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v7 06/16] fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY ioctl
Date: Sun, 28 Jul 2019 14:50:03 -0400
Message-ID: <20190728185003.GF6088@mit.edu>
References: <20190726224141.14044-1-ebiggers@kernel.org>
 <20190726224141.14044-7-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190726224141.14044-7-ebiggers@kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 26, 2019 at 03:41:31PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a new fscrypt ioctl, FS_IOC_ADD_ENCRYPTION_KEY.  This ioctl adds an
> encryption key to the filesystem's fscrypt keyring ->s_master_keys,
> making any files encrypted with that key appear "unlocked".

Note: it think it's going to be useful to make the keyring id
available someplace like /sys/fs/<fs>/<blkdev>/keyring, or preferably
in the new fsinfo system call.  Yes, the system administrator can paw
through /proc/keys and try to figure it out, but it will be nicer if
there's a direct way to do that.

For that matter, we could just add a new ioctl which returns the file
system's keyring id.  That way an application program won't have to
try to figure out what a file's underlying sb->s_id happens to be.
(Especially if things like overlayfs are involved.)

> diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
> index 29a945d165def..93d6eabaa7de4 100644
> --- a/include/uapi/linux/fscrypt.h
> +++ b/include/uapi/linux/fscrypt.h
> +
> +struct fscrypt_key_specifier {
> +#define FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR	1
> +	__u32 type;
> +	__u32 __reserved;

Can you move the definition of FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR
outside of the structure definition, and then add a comment about what
is a "descriptor" key spec?  (And then in a later patch, please add a
comment about what is an "identifier" key type.)  There's an
explanation in Documentation/filesystems/fscrypt.rst, I know, but a
one or two line comment plus a pointer to
Documentation/filesystems/fscrypt.rst in the header file would be
really helpful.

Otherwise, it looks good.   Feel free to add:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

						- Ted

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
