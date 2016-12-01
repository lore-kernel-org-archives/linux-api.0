From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v2 4/5] generic: test encrypted file access
Date: Wed, 30 Nov 2016 16:30:58 -0800
Message-ID: <20161201003058.GB14029@google.com>
References: <1480371402-12204-1-git-send-email-ebiggers@google.com>
 <1480371402-12204-5-git-send-email-ebiggers@google.com>
 <efa324fb-6d0b-aad0-1916-cdf12f0072c0@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <efa324fb-6d0b-aad0-1916-cdf12f0072c0@nod.at>
Sender: fstests-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: fstests@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, David Gstir <david@sigma-star.at>, Michael Halcrow <mhalcrow@google.com>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 29, 2016 at 09:52:10PM +0100, Richard Weinberger wrote:
> Eric,
> 
> On 28.11.2016 23:16, Eric Biggers wrote:
> > +# Also, there are some inconsistencies in which error codes are returned on
> > +# different kernel versions and filesystems when trying to create a file or
> > +# subdirectory without access to the parent directory's encryption key.  For now
> > +# we just accept multiple error codes.
> 
> This is something I wanted to ask about some time ago but forgot.
> Can we please agree on a clear set of fscrypt related error codes
> and document them in the Linux man pages?
> 
> Thanks,
> //richard

Agreed.  Let's break down what kinds of "fscrypt related error codes" codes we
currently use:

Errors for FS_IOC_GET_ENCRYPTION_POLICY:
	* ENOTTY: filesystem doesn't implement ioctl
	* ENODATA/ENOENT: file is not encrypted.  Currently ENOENT for ext4 but
			  ENODATA for f2fs.  I prefer ENODATA.
	* ENODATA: encryption context has unrecognized size (maybe should be
		   EINVAL like below?)
	* EINVAL: version of encryption context not recognized

Errors for FS_IOC_SET_ENCRYPTION_POLICY:
	* ENOTTY: filesystem doesn't implement ioctl
	* EOPNOTSUPP: filesystem doesn't support encryption
	* EACCES: user doesn't have permission to set the encryption policy
	* EROFS: filesystem is readonly
	* EINVAL: encryption modes, flags, or policy version not recognized
	* EINVAL: file already has an encryption policy, but it's not the same
		  as the one requested
	* EINVAL: file is not a directory (maybe this should be ENOTDIR?)
	* ENOTEMPTY: directory is not empty

Errors for FS_IOC_GET_ENCRYPTION_PWSALT:
	* EOPNOTSUPP: filesystem doesn't support encryption
	* EROFS: filesystem is readonly

Errors for opening/creating files:
	* ENOKEY: without the key, tried to open an encrypted regular file
	* ENOENT/EACCES/EPERM: without the key, tried to create a file in an
			       encrypted directory.  (Maybe we should make this
			       always ENOKEY, like above?)
	* EPERM: with the key, tried to create, in an encrypted directory, a
	  hard link to a file that doesn't have a compatible encryption policy.
	  (Note: I forgot to test this in my xfstests patches)

I probably missed some.  There are also miscellaneous errors like ones that get
returned when something is corrupted, but I think it's not worth worrying a lot
about those in general.

For the ioctls the error codes are not the main problem for documentation, since
AFAICS we don't have man pages for them at all yet.

For the errors with opening/creating files I don't know whether they should be
documented places like open(2) and mkdir(2), but at least we do need to agree on
the error codes.

Eric
