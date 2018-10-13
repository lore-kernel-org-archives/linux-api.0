From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v3 1/3] namei: implement O_BENEATH-style AT_* flags
Date: Sat, 13 Oct 2018 08:33:19 +0100
Message-ID: <20181013073319.GS32577@ZenIV.linux.org.uk>
References: <20181009070230.12884-1-cyphar@cyphar.com>
 <20181009070230.12884-2-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181009070230.12884-2-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Eric Biederman <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 09, 2018 at 06:02:28PM +1100, Aleksa Sarai wrote:

First of all, dirfd_path_init() part should be in a separate commit.  And I'm
really not happy with the logics in there.  dirfd_path_init() itself is
kinda-sorta reasonable.  It is equivalent to setting the starting point for
relative pathnames + setting ->root for LOOKUP_BENEATH, right?

But the part in path_init() is too bloody convoluted for its own good.  Let me
try to translate:

> +	if (unlikely(flags & LOOKUP_XDEV)) {
> +		error = dirfd_path_init(nd);
> +		if (unlikely(error))
> +			return ERR_PTR(error);
> +	}

* if LOOKUP_XDEV is set, set the starting point as if it was a relative
  pathname.  If LOOKUP_BENEATH was set as well, set ->root to the same
  point.
* if it's an absolute pathname, 
>  	if (*s == '/') {
... and we hadn't come here with LOOKUP_XDEV + LOOKUP_BENEATH, set ->root.
> +		if (likely(!nd->root.mnt))
> +			set_root(nd);
* if it's an absolute pathname, set the starting point to ->root.  Note that
if we came here with LOOKUP_XDEV, we'll discard the starting point we'd
calculated.
> +		error = nd_jump_root(nd);
> +		if (unlikely(error))
> +			s = ERR_PTR(error);
>  		return s;
>  	}
> +	if (likely(!nd->path.mnt)) {
* if we didn't have LOOKUP_XDEV, set the starting point as if it was a relative
pathname (which it is) and, if LOOKUP_BENEATH is also there, set ->root there
as well.
> +		error = dirfd_path_init(nd);
> +		if (unlikely(error))
> +			return ERR_PTR(error);
> +	}
> +	return s;
>  }

Pardon me, but... huh?  The reason for your two calls of dirfd_path_init() is,
AFAICS, the combination of absolute pathname with both LOOKUP_XDEV and
LOOKUP_BENEATH at the same time.  That combination is treated as if the pathname
had been relative.  Note that LOOKUP_BENEATH alone is ignored for absolute ones
(and with a good reason - it's a no-op on path_init() level in that case).

What the hell?  It complicates your code and doesn't seem to provide any benefits
whatsoever -- you could bloody well have passed the relative pathname to start with.

IDGI...  Without that kludge it becomes simply "do as we currently do for absolute
pathnames, call dirfd_path_init() for relative ones".  And I would argue that
taking LOOKUP_BENEATH handling out of dirfd_path_init() into path_init() (relative)
case would be a good idea.

As it is, the logics is very hard to follow.
