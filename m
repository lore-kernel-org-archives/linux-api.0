From: Richard Yao <ryao-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: Why not make kdbus use CUSE?
Date: Wed, 03 Dec 2014 04:22:33 -0500
Message-ID: <547ED659.2040106@gentoo.org>
References: <20141129063416.GE32286@woodpecker.gentoo.org> <20141129175947.GB32510@kroah.com> <547D50B9.9040909@gentoo.org> <20141202054850.GA17043@kroah.com> <547D7159.2040900@gentoo.org> <547DAEF3.1090106@gentoo.org> <20141202172612.GA8958@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="wrqv7KhkfIg7j1r00SRnXqVnsCoECeWVF"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141202172612.GA8958-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wrqv7KhkfIg7j1r00SRnXqVnsCoECeWVF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/02/2014 12:26 PM, Greg Kroah-Hartman wrote:
> On Tue, Dec 02, 2014 at 07:22:11AM -0500, Richard Yao wrote:
>> Assuming that this dance succeeds, the FUSE process could then make a
>> readonly file in itself, open it read only, unlink it, put the data in=
to
>> the file and send the file descriptor via UNIX domain socket while
>> refusing further writes. If it has its own user/group, the file should=

>> be safe from prying eyes.
>>
>> This is not as good as a memfd and also suffers from the race that
>> O_TMPFILE was meant to close, but it should be able to function as a
>> decent fallback.
>=20
> We can't knowingly create and advocate for broken code, sorry.
>
>> This would preserve portability across not only
>> different versions of Linux, but also other POSIX systems.
>=20
> I honestly do not care about any other system than Linux, so I don't se=
e
> why this would ever be an issue.

If you tie your userland to the most recent kernel and then want to
bisect an old bug, you will have a problem. You could try to find
another userland that supports the older kernels, but it would be *much*
easier if you could just use your current userland with it because then
the bare minimum must change. Writing portable software is the way to do
that.

Why burn the bridges that allow us to look backward when we have such a
need?

>> Keeping the code in userspace would allow us to apply SELinux policies=

>> to it, which is something that we would lose if it were go to into the=

>> kernel.
>=20
> On the contrary, the kdbusfs implementation gives you better security
> model support than before, it ties directly into the LSM hooks, see the=

> add-on patches from some other developers that bring full support of LS=
M
> to the codebase.

If a bug in kdbusfs that allows arbitrary code execution is exploited in
the wild, would kdbus be more secure than a userland version?

>> That said, it is still not clear to me that dbus must be inside the
>> kernel to be able to perform multicast and zero copy using memfd.
>=20
> It seems you have yet to read my introductory email for the patch
> series.

Allow me to be more specific:

> - performance: fewer process context switches, fewer copies, fewer
>   syscalls, larger memory chunks via memfd.  This is really important
>   for a whole class of userspace programs that are ported from other
>   operating systems that are run on tiny ARM systems that rely on
>   hundreds of thousands of messages passed at boot time, and at
>   "critical" times in their user interaction loops.

What are some examples of these programs? Are any of them examples of
good software design?

> - security: the peers which communicate do not have to trust each other=
,
>   as the only trustworthy compoenent in the game is the kernel which
>   adds metadata and ensures that all data passed as payload is either
>   copied or sealed, so that the receiver can parse the data without
>   having to protect against changing memory while parsing buffers.

What keeps userspace from passing around memfds?

> - more metadata can be attached to messages than in userspace

How much metadata can be attached in either case? is there some inherit
aspect of the existing syscall API that prevents userspace from
attaching more? Why do we want to attach more?

> - being in the kernle closes a lot of races which can't be fixed with
>   the current userspace solutions.  For example, with kdbus, there is a=

>   way a client can disconnect from a bus, but do so only if no further
>   messages present in its queue, which is crucial for implementing
>   race-free "exit-on-idle" services

Is the current dbus daemon not supporting this this only thing
preventing us from doing it in userspace?

> Of course, some of the bits above could be implemented in userspace
> alone, for example with more sophisticated memory management APIs, but
> this is usually done by losing out on the other details.  For example,
> for many of the memory management APIs, it's hard to not require the
> communicating peers to fully trust each other.  And we _really_ don't
> want peers to have to trust each other.

Does being in the kernel solve this in a way that using memfds in
userspace does not?

> Another benefit of having this in the kernel, rather than as a userspac=
e
> daemon, is that you can now easily use the bus from the initrd, or up t=
o
> the very end when the system shuts down.  On current userspace D-Bus,
> this is not really possible, as this requires passing the bus instance
> around between initrd and the "real" system.  Such a transition of all
> fds also requires keeping full state of what has already been read from=

> the connection fds.  kdbus makes this much simpler, as we can change th=
e
> ownership of the bus, just by passing one fd over from one part to the
> other.

Why do we want to start D-Bus inside the initramfs?


--wrqv7KhkfIg7j1r00SRnXqVnsCoECeWVF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJUftZvAAoJECDuEZm+6ExkKM0P/ROJvFadqWx/VAhEMG1UfJcX
1Yb6ixH9gfm3/6fKz23zcxov/vY/eWn+ggQhq356vosoIEaX/SbYPerHzuESUiZw
eQIRM4VpcV4KcP48h+CFSFv3GZ4FtrhEaXmQmkv3n9av+jBkX+i56aF/BprbALr6
+BozipBpMN4aL6uxqSo31qenaH5azl5E5fBdTxsqQdBolq93/d8O/iAslpKn+pZ6
fxw4xgzWGRbjlRShG5D+PHyLyu5hcoMe9GuzxYZasAjCnuqUuliumA3cEWU5mnN3
v9HbJ10RTGJrQWoiqfyTbDYrTgtFjys/vij6lKUd6m8g8Ij7tSN3PEr49Ven+1V2
0Q4VbUZjOmtS3EfiJU1IQQyDU8JJNpMtPhmQGN7e9122etc+oQG9CTep0nVX0QNQ
8DlGhCx48tn4TuK/5CmvqxuJYyZ9ZRLie/WJ/8EsMMZWtwElRgM4yS1S6lt5z2fe
8IX6aVVv3PY1cOnIXsuz5uVerIcCFsnL2mivtc2WPNpa9ZBzdjlaa9Rphn+LmkQw
MpWCqXwdDIUh+CAYQO+J8PEyjkjkJgHe+qWt4Nx+jSSV7fBZ8XMtteimhTgXDfVF
05uvxau/lRFpMa0ouTeZxTrLkSoj7ag0gTkXPPfUp46SSWW1bmLVrtmWi+AN4tqj
HsC/+Jb3tDgkY/C7hGZa
=IQbC
-----END PGP SIGNATURE-----

--wrqv7KhkfIg7j1r00SRnXqVnsCoECeWVF--
