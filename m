From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [v2] fscrypt: Move key structure and constants to uapi
Date: Sun, 30 Apr 2017 02:16:33 -0400
Message-ID: <20170430061633.xb5i54g2ftxbwtij@thunk.org>
References: <20170406231405.153919-1-joerichey94@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170406231405.153919-1-joerichey94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Richey <joerichey94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fscrypt-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Halcrow <mhalcrow-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joe Richey <joerichey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 06, 2017 at 04:14:05PM -0700, Joe Richey wrote:
> From: Joe Richey <joerichey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
> Signed-off-by: Joe Richey <joerichey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thanks, applied.

					- Ted
