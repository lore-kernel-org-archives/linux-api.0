From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v7 06/16] fscrypt: add
 FS_IOC_ADD_ENCRYPTION_KEY ioctl
Date: Mon, 29 Jul 2019 12:46:45 -0700
Message-ID: <20190729194644.GE169027@gmail.com>
References: <20190726224141.14044-1-ebiggers@kernel.org>
 <20190726224141.14044-7-ebiggers@kernel.org>
 <20190728185003.GF6088@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190728185003.GF6088@mit.edu>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Satya Tangirala <satyat@google.com>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

On Sun, Jul 28, 2019 at 02:50:03PM -0400, Theodore Y. Ts'o wrote:
> On Fri, Jul 26, 2019 at 03:41:31PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add a new fscrypt ioctl, FS_IOC_ADD_ENCRYPTION_KEY.  This ioctl adds an
> > encryption key to the filesystem's fscrypt keyring ->s_master_keys,
> > making any files encrypted with that key appear "unlocked".
> 
> Note: it think it's going to be useful to make the keyring id
> available someplace like /sys/fs/<fs>/<blkdev>/keyring, or preferably
> in the new fsinfo system call.  Yes, the system administrator can paw
> through /proc/keys and try to figure it out, but it will be nicer if
> there's a direct way to do that.
> 
> For that matter, we could just add a new ioctl which returns the file
> system's keyring id.  That way an application program won't have to
> try to figure out what a file's underlying sb->s_id happens to be.
> (Especially if things like overlayfs are involved.)

Keep in mind that the new ioctls (FS_IOC_ADD_ENCRYPTION_KEY,
FS_IOC_REMOVE_ENCRYPTION_KEY, FS_IOC_GET_ENCRYPTION_KEY_STATUS) don't take the
keyring ID as a parameter, since it's already known from the filesystem the
ioctl is executed on.  So there actually isn't much that can be done with the
keyring ID.  But sure, if it's needed later we can add an API to get it.

> 
> > diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
> > index 29a945d165def..93d6eabaa7de4 100644
> > --- a/include/uapi/linux/fscrypt.h
> > +++ b/include/uapi/linux/fscrypt.h
> > +
> > +struct fscrypt_key_specifier {
> > +#define FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR	1
> > +	__u32 type;
> > +	__u32 __reserved;
> 
> Can you move the definition of FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR
> outside of the structure definition, and then add a comment about what
> is a "descriptor" key spec?  (And then in a later patch, please add a
> comment about what is an "identifier" key type.)  There's an
> explanation in Documentation/filesystems/fscrypt.rst, I know, but a
> one or two line comment plus a pointer to
> Documentation/filesystems/fscrypt.rst in the header file would be
> really helpful.

I'll add a brief comment that explains the key specifier.

I've already added a pointer to Documentation/filesystems/fscrypt.rst at the top
of the header (this was one of the cleanups in v6 => v7):

/*
 * fscrypt user API
 *
 * These ioctls can be used on filesystems that support fscrypt.  See the
 * "User API" section of Documentation/filesystems/fscrypt.rst.
 */

- Eric
