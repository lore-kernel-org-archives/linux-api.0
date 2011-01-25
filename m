From: Eric Blake <eblake@redhat.com>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Tue, 25 Jan 2011 13:31:04 -0700
Message-ID: <4D3F3308.1050305@redhat.com>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com> <20110125174515.C1DC2183C19@magilla.sf.frob.com> <201101251921.15184.arnd@arndb.de> <201101251352.03079.vapier@gentoo.org> <4D3F2AD9.8060000@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256; protocol="application/pgp-signature"; boundary="------------enigC65679483EDCD6DE644ED270"
Return-path: <libc-ports-return-1819-gclgp-libc-ports=m.gmane.org@sourceware.org>
In-Reply-To: <4D3F2AD9.8060000@redhat.com>
List-Unsubscribe: <mailto:libc-ports-unsubscribe-gclgp-libc-ports=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-ports-subscribe@sourceware.org>
List-Post: <mailto:libc-ports@sourceware.org>
List-Help: <mailto:libc-ports-help@sourceware.org>, <http://sourceware.org/lists.html#faqs>
Sender: libc-ports-owner@sourceware.org
Cc: Mike Frysinger <vapier@gentoo.org>, Arnd Bergmann <arnd@arndb.de>, Paul Eggert <eggert@cs.ucla.edu>, Roland McGrath <roland@redhat.com>, linasvepstas@gmail.com, Chris Metcalf <cmetcalf@tilera.com>, GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org, libc-ports@sourceware.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC65679483EDCD6DE644ED270
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/25/2011 12:56 PM, Eric Blake wrote:
>>> Treating the empty string special for AT_FDCWD is rather pointless, but
>>> at least consistent.
>=20
> No, treating an empty string name argument to a *at function as a
> synonym for AT_FDCWD is a violation of POSIX.
>=20
>> i dont know if the gnulib peeps are on these lists, but i think their=20
>> implementations of some of the *at funcs leverage the extended behavior =
that=20
>> is available under Linux.  or at least, i'm certain they'll have some in=
sight=20
>> into some of these nuances.
>=20
> Gnulib has code to explicitly work around bugs in earlier glibc/Linux
> implementations that mistakenly treated fd, "" the same as fd, "." (at
> least modern kernels get it right, and when glibc defers to the kernel,
> those workarounds in gnulib are not needed on newer systems).

One other thing to point out - this is not the first time glibc has
added code around *at kernel syscalls in order to provide POSIX
semantics where the Linux syscall does not.  Remember that both futimens
and utimensat are implemented on top of the same syscall, and that
futimens(AT_FDCWD, times) must fail rather than set the times on ".".
See glibc commit 4286fa41 where glibc had to add code to work around the
kernel's choice of the syscall utimensat(fd, NULL, times, 0) as being
the way to implement futimens, in response to
http://sourceware.org/bugzilla/show_bug.cgi?id=3D10992, which was raised
because gnulib detected the POSIX compliance bug, in much the same way
that gnulib is now detecting the chmod("") bug of not failing with
ENOENT when chmod is incorrectly implemented around the sys_fchmodat
syscall.

--=20
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org


--------------enigC65679483EDCD6DE644ED270
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJNPzMJAAoJEKeha0olJ0NqTYgH/1aR1ABvFAD3uF0JBQGwObjG
8tfV3Ju8nJIFeQcJaFrTvxFdcvTC5t54OYqSTkkSQIFtPZ9sJITQxdOVuw2YB18b
wRsGe3tsvKC6S31f0jfKDzTm26V5iSKcl+lChBG+H+gSJaBLKqeVyU/ZoHSZOLrQ
mwR+bNbdmlF2Z+sBY4rC4mYD7M1gYO43Ag8SmUi+flQJfJrxM+xTpvz9UPKXuPg/
SHlLuy4veJZHt0Zk0MHrCp8QwwxHVb2BmHjqZ/PmCf8gnebtyZveKp493DJ97A8j
+66XzjWOd7zljoCrn7/JdEl96z25/eKkunGD0swHNXdTqepYjj6C59T7QJogwb0=
=xcyY
-----END PGP SIGNATURE-----

--------------enigC65679483EDCD6DE644ED270--
