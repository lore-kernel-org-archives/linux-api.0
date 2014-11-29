From: Richard Yao <ryao-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Why not make kdbus use CUSE?
Date: Sat, 29 Nov 2014 06:34:16 +0000
Message-ID: <20141129063416.GE32286@woodpecker.gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

I had the opportunity at LinuxCon Europe to chat with Greg and some other kdbus
developers. A few things stood out from our conversation that I thought I would
bring to the list for discussion.

The first is that I asked them why we need to add yet another IPC mechanism (and
quite possibly another exploit target) to the kernel. Apparently, they want to
use dbus to do multicast and the existing dbus software is not peformant enough.
There was not much discussion of why the existing network stack is not usable
for this, but I was not terribly concerned about it, so the remainder of our
discussion focused on compatibility.

They regard a userland compatibility shim in the systemd repostory to provide
backward compatibility for applications. Unfortunately, this is insufficient to
ensure compatibility because dependency trees have multiple levels. If cross
platform package A depends on cross platform library B, which depends on dbus,
and cross platform library B decides to switch to kdbus, then it ceases to be
cross platform and cross platform package A is now dependent on Linux kernels
with kdbus. Not only does that affect other POSIX systems, but it also affects
LTS versions of Linux.

It is somewhat tempting to think that being in the kernel is necessary for
performance, this does not appear to be true from my discussion with Greg and
others. In specific, a key advantage of being in the kernel is a reduction in
context switches and consequently, one would expect programs using the old API
to benefit, but they were quite clear to me that programs using the old API do
not benefit. At the same time, we had a similar situation where people thought
that the httpd server had to be inside the kernel until Linux 2.6, when our
userland APIs improved to the point where we were able to get similar if not
better performance in userland compared to the implementation of khttpd in Linux
2.4.y.

Putting daemons in the kernel is always more performant than putting daemons
into userland, but it has the drawback of violating the principle of least
privilege. When code is in userland, we can apply security mechanisms to it via
things like SELinux and seccomp to limit the damage caused by compromise.  With
an in-kernel component, there is no way of doing that. One might be tempted to
think that controlling the IPC mechanism is as good as controlling the system,
but this is not true when we consider things like lxc, where compromise of dbus
in a container does not give full control over the system.

I started to think that we probably ought to design a way to put kdbus into
userland and then I realized that we already have one in the form of CUSE. This
would not only makes kdbus play nicely with SELinux and lxc, but also other
POSIX systems that currently share dbus with Linux systems, which includes older
Linux kernels. Greg claimed that the kdbus code was fairly self contained and
was just a character device, so I assume this is possible and I am curious why
it is not done.

I should probably mention one other thing that I recall from my discussion with
Greg and others, which is that the systemd project wants to depend on it. The
nature of controlling pid 1 means that systemd is more than capable of starting
dbus before anything that needs it and that includes its own components (aside
from its pid 1). The systemd project wanting the API is not a valid reason for
why it should be in the kernel, although it could be a reason to make a CUSE
version go into systemd's pid 1.

That said, why not make kdbus use CUSE?

P.S. I also mentioned my concern that having the shim in the systemd repository
would have a negative effect on distributons that use alterntaive libc libraries
because the systemd developers refuse to support alternative libc libraries. I
mentioned this to one of the people to whom Greg introduced me (and whose name
escapes me) as we were walking to Michael Kerrisk's talk on API design. I was
told quite plainly that such distributions are not worth consideration. If kdbus
is merged despite concerns about security and backward compatibility, could we
at least have the shim moved to libc netural place, like Linus' tree?
