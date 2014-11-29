From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: Why not make kdbus use CUSE?
Date: Sat, 29 Nov 2014 09:59:47 -0800
Message-ID: <20141129175947.GB32510@kroah.com>
References: <20141129063416.GE32286@woodpecker.gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141129063416.GE32286-WkJ4KB730YtOk+SH+krGketnjj8NnB7F@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Yao <ryao-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Nov 29, 2014 at 06:34:16AM +0000, Richard Yao wrote:
> I had the opportunity at LinuxCon Europe to chat with Greg and some other kdbus
> developers. A few things stood out from our conversation that I thought I would
> bring to the list for discussion.

Any reason why you didn't respond to the kdbus patches themselves?
Critiquing the specific code is much better than random discussions.

> They regard a userland compatibility shim in the systemd repostory to provide
> backward compatibility for applications. Unfortunately, this is insufficient to
> ensure compatibility because dependency trees have multiple levels. If cross
> platform package A depends on cross platform library B, which depends on dbus,
> and cross platform library B decides to switch to kdbus, then it ceases to be
> cross platform and cross platform package A is now dependent on Linux kernels
> with kdbus. Not only does that affect other POSIX systems, but it also affects
> LTS versions of Linux.

What does LTS versions have anything to do here?  And what specific
dependancies are you worried about?

> It is somewhat tempting to think that being in the kernel is necessary for
> performance, this does not appear to be true from my discussion with Greg and
> others. In specific, a key advantage of being in the kernel is a reduction in
> context switches and consequently, one would expect programs using the old API
> to benefit, but they were quite clear to me that programs using the old API do
> not benefit. At the same time, we had a similar situation where people thought
> that the httpd server had to be inside the kernel until Linux 2.6, when our
> userland APIs improved to the point where we were able to get similar if not
> better performance in userland compared to the implementation of khttpd in Linux
> 2.4.y.

Again, please see the kernel patches for lots of detail as to why this
should be in the kernel.  If you disagree with the specific statements I
have listed there, please respond with specifics.

> I started to think that we probably ought to design a way to put kdbus into
> userland and then I realized that we already have one in the form of CUSE. This
> would not only makes kdbus play nicely with SELinux and lxc, but also other
> POSIX systems that currently share dbus with Linux systems, which includes older
> Linux kernels. Greg claimed that the kdbus code was fairly self contained and
> was just a character device, so I assume this is possible and I am curious why
> it is not done.

The latest version is a filesystem not a character device, your
information is out of date :)

> P.S. I also mentioned my concern that having the shim in the systemd repository
> would have a negative effect on distributons that use alterntaive libc libraries
> because the systemd developers refuse to support alternative libc libraries. I
> mentioned this to one of the people to whom Greg introduced me (and whose name
> escapes me) as we were walking to Michael Kerrisk's talk on API design. I was
> told quite plainly that such distributions are not worth consideration. If kdbus
> is merged despite concerns about security and backward compatibility, could we
> at least have the shim moved to libc netural place, like Linus' tree?

Take that up on the systemd mailing list, it's not a kernel issue.

greg k-h
