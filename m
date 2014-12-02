From: Richard Yao <ryao-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: Why not make kdbus use CUSE?
Date: Tue, 02 Dec 2014 00:40:09 -0500
Message-ID: <547D50B9.9040909@gentoo.org>
References: <20141129063416.GE32286@woodpecker.gentoo.org> <20141129175947.GB32510@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="STK3BHiRXUgRmPR62WrntVDKaMrx13JPF"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141129175947.GB32510-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--STK3BHiRXUgRmPR62WrntVDKaMrx13JPF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/29/2014 12:59 PM, Greg Kroah-Hartman wrote:
> On Sat, Nov 29, 2014 at 06:34:16AM +0000, Richard Yao wrote:
>> I had the opportunity at LinuxCon Europe to chat with Greg and some ot=
her kdbus
>> developers. A few things stood out from our conversation that I though=
t I would
>> bring to the list for discussion.
>=20
> Any reason why you didn't respond to the kdbus patches themselves?
> Critiquing the specific code is much better than random discussions.

I am not subscribed to the list because of the enormous volume of email
that I would need to process when I am already at my limit from various
mailing lists. Consequently, I did not have the message-id to use
in-reply-to. In hindsight, I should have fetched them from an online
archive. I will make an effort to send additional emails with the proper
message ids under in-reply-to.

However, I might not have time to dedicate to that until the weekend. My
employer was good enough to allow me to work remotely from Shanghai so
that I could visit family. Unfortunately, the Internet connectivity here
leaves something to be desired. The only way to get Internet
connectivity for a short stay is via the mobile network and conventional
4G is not deployed. What I suspect is a bug in the network stack causes
the last mile to randomly die on me with no helpful messages printed to
dmesg or the system log.

Things like patch review for the linux kernel and debugging the network
stack are things that I get to do on my time. So far, I have not found
time to debug it beyond verifying that different 3G radios from
different manufacturers (Huawei E261 and Ericsson F5521gw) exhibit the
same behavior. Additionally, all traffic appears to be routed through
the national firewall in Beijing, where the peering links between China
and the US have degraded to the point where connections are worse than
US  dial-up connections from the 1990s. I have managed to use VM hosts
to route traffic over less congested links, but the latencies and packet
loss ave combined to make TCP congestion control extraordinarily painful.=


>> They regard a userland compatibility shim in the systemd repostory to =
provide
>> backward compatibility for applications. Unfortunately, this is insuff=
icient to
>> ensure compatibility because dependency trees have multiple levels. If=
 cross
>> platform package A depends on cross platform library B, which depends =
on dbus,
>> and cross platform library B decides to switch to kdbus, then it cease=
s to be
>> cross platform and cross platform package A is now dependent on Linux =
kernels
>> with kdbus. Not only does that affect other POSIX systems, but it also=
 affects
>> LTS versions of Linux.
>=20
> What does LTS versions have anything to do here?  And what specific
> dependancies are you worried about?

Lets say that you have a Linux 3.10 system and you want some package
that indirectly depends on the new API due to library dependencies. You
will have a problem. You could probably install an older version of the
library, but if the older version has a CVE, most end users will end up
between a rock and a hard place. This situation should merit some
consideration because you are taking something that lived previously in
userland, modifying it so that anything depending on the modifications
is no longer backward compatible and then tying it to new kernels.

I think trying to use existing APIs to implement this in userspace is
worth consideration. I recall that you were very enthusiastic about CUSE
enabling people to move drivers out of the kernel. If statements about
kdbus' reduction in context-switch overhead not being a significant
benefit are to be believed, I would think that we could reuse CUSE.

>> It is somewhat tempting to think that being in the kernel is necessary=
 for
>> performance, this does not appear to be true from my discussion with G=
reg and
>> others. In specific, a key advantage of being in the kernel is a reduc=
tion in
>> context switches and consequently, one would expect programs using the=
 old API
>> to benefit, but they were quite clear to me that programs using the ol=
d API do
>> not benefit. At the same time, we had a similar situation where people=
 thought
>> that the httpd server had to be inside the kernel until Linux 2.6, whe=
n our
>> userland APIs improved to the point where we were able to get similar =
if not
>> better performance in userland compared to the implementation of khttp=
d in Linux
>> 2.4.y.
>=20
> Again, please see the kernel patches for lots of detail as to why this
> should be in the kernel.  If you disagree with the specific statements =
I
> have listed there, please respond with specifics.

I have some broader architectural concerns:

1. Debugging kernel code is a pain while debugging user code is
relatively easy.

2. Security vulnerabilities in kernel code give complete access to
everything while security vulnerabilities in userspace code can be
limited in scope by SELinux.

3. Integration with things like LXC should be easier from userspace,
where each container can have its own daemon.

We do not put everything into one address space so that we can limit the
potential for things to go wrong and enable us to debug them when they
do. If implementing this via FUSE/CUSE is an option, we should try it
first. Moving it into the kernel is always possible afterward. However,
moving it into userspace is not because the kernel will need to support
the new API *indefinitely*. The statements made at LinuxCon Europe
strongly suggest to me that the API design is what enables higher
performance, not a reduction in context switch overhead. If that is the
case, context switch performance does not seem to be the reason for
being in the kernel and consequently, using CUSE/FUSE to keep it in
userspace should be doable.

>> I started to think that we probably ought to design a way to put kdbus=
 into
>> userland and then I realized that we already have one in the form of C=
USE. This
>> would not only makes kdbus play nicely with SELinux and lxc, but also =
other
>> POSIX systems that currently share dbus with Linux systems, which incl=
udes older
>> Linux kernels. Greg claimed that the kdbus code was fairly self contai=
ned and
>> was just a character device, so I assume this is possible and I am cur=
ious why
>> it is not done.
>=20
> The latest version is a filesystem not a character device, your
> information is out of date :)

CUSE is an extension of FUSE, so roughly the same APIs would be used in
either case.

>> P.S. I also mentioned my concern that having the shim in the systemd r=
epository
>> would have a negative effect on distributons that use alterntaive libc=
 libraries
>> because the systemd developers refuse to support alternative libc libr=
aries. I
>> mentioned this to one of the people to whom Greg introduced me (and wh=
ose name
>> escapes me) as we were walking to Michael Kerrisk's talk on API design=
=2E I was
>> told quite plainly that such distributions are not worth consideration=
=2E If kdbus
>> is merged despite concerns about security and backward compatibility, =
could we
>> at least have the shim moved to libc netural place, like Linus' tree?
>=20
> Take that up on the systemd mailing list, it's not a kernel issue.

It became a kernel issue the moment that you proposed a kernel API with
corresponding library code in the systemd repository. Not that long ago,
the firmware loading code was moved into the kernel because there were
problems with systemd's stewardship over that mechanism in udev. Giving
the systemd developers the responsibility of maintaining the only
library for a proprosed kernel API so soon afterward seems unwise to me.
If the library is small, there is no reason why it cannot be part of the
mainline tree, much like other small things that are bound to kernel
APIs, like perf.


--STK3BHiRXUgRmPR62WrntVDKaMrx13JPF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJUfVDKAAoJECDuEZm+6ExkL/sQAImgwApeuFiMyW49uei9mwsp
19jrL1Ce3cIPjuLnOzKCV9FA3UFct3inlxr0XPhGgJCyfVpGC+yRE2ZEmxdLCFo9
lJRLCv8UvA3o8KakCIzWauq9FGm+Mm1kZsRkZAhEOzwabBMWOKZXY96WQzLZZYGA
Njie1T6wFRkV17GtT6FEnLfPpGPhHfcMKxRpBRXYwjNpkqaw1yVOKw5pG+3azyV4
wpS8I3c/xpIPAMEnYd7YrbReAO8kXOtOcU5CslJtPNB9WqKXzCQV4dMcvO/URJLC
yODjWkzfPCbZOgiyqVtEQyIWvwns3UOLH/7VEBAsVoGY56aXlt90YC7zj2/Pxudh
x9+50HB7d9pOMypy3zC8go8A5tFqJrvpnZP5Qjd2DSN3UWX1Chnno3bh25OJ2fSE
WgZ8dsT9iIaMQwR+XyYru9zHNoLWipGv5WjF6p+hPqo0uXwweIiQOc4qO/zwct/W
PSHcGK5cl6groa1ofH0bhsR7Mu3eE3iNrIyz4eRNBQZFu7dy7SKk9Vt1qGSwnj4A
am6UgO5VzZ8Fi6o8pPL4smAw5hCoyFshFho0w8DYeL58QakQZr5ywYKqclRQ/1HM
E5j/dFhp9EOsnGxAcm59NuK+nsLBadixP50x+GEkGUSS20Yz5ht1u1TDCXf5SiaC
b70A5I7fLN5tDdjEz95X
=zAe9
-----END PGP SIGNATURE-----

--STK3BHiRXUgRmPR62WrntVDKaMrx13JPF--
