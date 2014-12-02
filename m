From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: Why not make kdbus use CUSE?
Date: Tue, 2 Dec 2014 09:26:12 -0800
Message-ID: <20141202172612.GA8958@kroah.com>
References: <20141129063416.GE32286@woodpecker.gentoo.org>
 <20141129175947.GB32510@kroah.com>
 <547D50B9.9040909@gentoo.org>
 <20141202054850.GA17043@kroah.com>
 <547D7159.2040900@gentoo.org>
 <547DAEF3.1090106@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <547DAEF3.1090106-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Yao <ryao-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 02, 2014 at 07:22:11AM -0500, Richard Yao wrote:
> Assuming that this dance succeeds, the FUSE process could then make a
> readonly file in itself, open it read only, unlink it, put the data into
> the file and send the file descriptor via UNIX domain socket while
> refusing further writes. If it has its own user/group, the file should
> be safe from prying eyes.
> 
> This is not as good as a memfd and also suffers from the race that
> O_TMPFILE was meant to close, but it should be able to function as a
> decent fallback.

We can't knowingly create and advocate for broken code, sorry.

> This would preserve portability across not only
> different versions of Linux, but also other POSIX systems.

I honestly do not care about any other system than Linux, so I don't see
why this would ever be an issue.

> Keeping the code in userspace would allow us to apply SELinux policies
> to it, which is something that we would lose if it were go to into the
> kernel.

On the contrary, the kdbusfs implementation gives you better security
model support than before, it ties directly into the LSM hooks, see the
add-on patches from some other developers that bring full support of LSM
to the codebase.

> That said, it is still not clear to me that dbus must be inside the
> kernel to be able to perform multicast and zero copy using memfd.

It seems you have yet to read my introductory email for the patch
series.

greg k-h
