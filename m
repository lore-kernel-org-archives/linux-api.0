From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: Why not make kdbus use CUSE?
Date: Mon, 1 Dec 2014 21:48:50 -0800
Message-ID: <20141202054850.GA17043@kroah.com>
References: <20141129063416.GE32286@woodpecker.gentoo.org>
 <20141129175947.GB32510@kroah.com>
 <547D50B9.9040909@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <547D50B9.9040909-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Yao <ryao-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 02, 2014 at 12:40:09AM -0500, Richard Yao wrote:
> >> They regard a userland compatibility shim in the systemd repostory to provide
> >> backward compatibility for applications. Unfortunately, this is insufficient to
> >> ensure compatibility because dependency trees have multiple levels. If cross
> >> platform package A depends on cross platform library B, which depends on dbus,
> >> and cross platform library B decides to switch to kdbus, then it ceases to be
> >> cross platform and cross platform package A is now dependent on Linux kernels
> >> with kdbus. Not only does that affect other POSIX systems, but it also affects
> >> LTS versions of Linux.
> > 
> > What does LTS versions have anything to do here?  And what specific
> > dependancies are you worried about?
> 
> Lets say that you have a Linux 3.10 system and you want some package
> that indirectly depends on the new API due to library dependencies. You
> will have a problem. You could probably install an older version of the
> library, but if the older version has a CVE, most end users will end up
> between a rock and a hard place. This situation should merit some
> consideration because you are taking something that lived previously in
> userland, modifying it so that anything depending on the modifications
> is no longer backward compatible and then tying it to new kernels.

Then you need to get a better distro, as any "well run" long-term
enterprise distro handles stuff like this for you.  Otherwise you need
to update systems properly.  There's nothing that I can do here to help
with that, nor do I ever want to, sorry.

> I think trying to use existing APIs to implement this in userspace is
> worth consideration. I recall that you were very enthusiastic about CUSE
> enabling people to move drivers out of the kernel. If statements about
> kdbus' reduction in context-switch overhead not being a significant
> benefit are to be believed, I would think that we could reuse CUSE.

I fail to understand how any of this relates to CUSE, please provide
specifics.

> 1. Debugging kernel code is a pain while debugging user code is
> relatively easy.

You have full access to a debugger, what more do you need?  :)

And why would you need to debug the kernel kdbus code?  Is something not
working properly in it?  Otherwise just use wireshark to read the kdbus
data stream and all should be fine.

> 2. Security vulnerabilities in kernel code give complete access to
> everything while security vulnerabilities in userspace code can be
> limited in scope by SELinux.

Kernel code is hard, security matters, yes I know this, we all have been
doing this for a very long time.  Of course bugs happen, but if you look
closely, your "attack surface" is now smaller using kdbus than it was
using old-style dbus.

> 3. Integration with things like LXC should be easier from userspace,
> where each container can have its own daemon.

How does the current implementation not work properly for this?  The
filesystem implementation makes this easier than ever, while sticking
with the character device made this quite difficult in different ways.

> >> I started to think that we probably ought to design a way to put kdbus into
> >> userland and then I realized that we already have one in the form of CUSE. This
> >> would not only makes kdbus play nicely with SELinux and lxc, but also other
> >> POSIX systems that currently share dbus with Linux systems, which includes older
> >> Linux kernels. Greg claimed that the kdbus code was fairly self contained and
> >> was just a character device, so I assume this is possible and I am curious why
> >> it is not done.
> > 
> > The latest version is a filesystem not a character device, your
> > information is out of date :)
> 
> CUSE is an extension of FUSE, so roughly the same APIs would be used in
> either case.

Not really, sorry, the specifics are quite different.

> >> P.S. I also mentioned my concern that having the shim in the systemd repository
> >> would have a negative effect on distributons that use alterntaive libc libraries
> >> because the systemd developers refuse to support alternative libc libraries. I
> >> mentioned this to one of the people to whom Greg introduced me (and whose name
> >> escapes me) as we were walking to Michael Kerrisk's talk on API design. I was
> >> told quite plainly that such distributions are not worth consideration. If kdbus
> >> is merged despite concerns about security and backward compatibility, could we
> >> at least have the shim moved to libc netural place, like Linus' tree?
> > 
> > Take that up on the systemd mailing list, it's not a kernel issue.
> 
> It became a kernel issue the moment that you proposed a kernel API with
> corresponding library code in the systemd repository.

One specific implementation of the library code is in the systemd repo.
There is nothing keeping anyone from forking it and putting it somewhere
else if you depend on it.  Odds are, you aren't going to need to do that
as your old-style dbus applications will work just fine, no changes
needed.

thanks,

greg k-h
