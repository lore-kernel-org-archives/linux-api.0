From: Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Tue, 25 Jan 2011 12:56:09 -0700
Message-ID: <4D3F2AD9.8060000@redhat.com>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com> <20110125174515.C1DC2183C19@magilla.sf.frob.com> <201101251921.15184.arnd@arndb.de> <201101251352.03079.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig2D5DE2101AF40D904450289D"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201101251352.03079.vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Paul Eggert <eggert-764C0pRuGfqVc3sceRu5cw@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linasvepstas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Chris Metcalf <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>, GLIBC Devel <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-ports-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2D5DE2101AF40D904450289D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/25/2011 11:52 AM, Mike Frysinger wrote:
> On Tuesday, January 25, 2011 13:21:14 Arnd Bergmann wrote:
>> On Tuesday 25 January 2011 18:45:15 Roland McGrath wrote:
>>>  I know of no reason to
>>>
>>> think that the current treatment of the empty string was ever intende=
d at
>>> the creation of the *at interfaces.
>>
>> I always assumed that this was done so that the *at syscalls can repla=
ce
>> both the ones that take a file descriptor (e.g. fstat) and the ones th=
at
>> take a pathname (e.g. stat), which is sensible for the non-AT_FDCWD ca=
se,
>> although not documented in the man pages.

For futimesat, which is not specified by POSIX, gnulib already requires
the behavior of calling futimesat(fd, NULL, times) as a way to directly
modify the (possibly non-directory) fd, in contrast to futimesat(fd,
"name", times), which sets the times on "name" relative to the directory =
fd.

For all other *at interfaces, they are specified by POSIX as requiring
the same behavior as the non-*at interface when given arguments within
the bounds required by POSIX.  That is, fstatat(fd, "", buf, 0) SHALL
fail with ENOENT, just the same as stat("", buf).  However, since POSIX
requires that the second argument be a valid string, and NULL is not a
valid string, then passing NULL as the second argument means that you
are no longer bound by POSIX and that you could (if you wanted) make
fstatat(fd, NULL, buf, 0) behave the same as fstat(fd, buf).  Right now,
none of the other *at interfaces in Linux currently do this; futimesat
is the only interface explicitly documented as having this dual behavior.=


>>
>> Treating the empty string special for AT_FDCWD is rather pointless, bu=
t
>> at least consistent.

No, treating an empty string name argument to a *at function as a
synonym for AT_FDCWD is a violation of POSIX.

> i dont know if the gnulib peeps are on these lists, but i think their=20
> implementations of some of the *at funcs leverage the extended behavior=
 that=20
> is available under Linux.  or at least, i'm certain they'll have some i=
nsight=20
> into some of these nuances.

Gnulib has code to explicitly work around bugs in earlier glibc/Linux
implementations that mistakenly treated fd, "" the same as fd, "." (at
least modern kernels get it right, and when glibc defers to the kernel,
those workarounds in gnulib are not needed on newer systems).

--=20
Eric Blake   eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org    +1-801-349-2682
Libvirt virtualization library http://libvirt.org


--------------enig2D5DE2101AF40D904450289D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJNPyrZAAoJEKeha0olJ0Nq5bQH/29LIEO5FU5nkAqRbmdz+tzO
pce/CECUYOgPBnUuKRUCFusz5MkUmzpVxhZm8fDgdvzSXBTFK8Q7S3/jV86wuMwc
vkuTL9RbKHZu9F24f5d2O/4hWJlntJSFvthvNppVB5iEAuvaKbjlC5o9y2fTkrDm
dwlh/1LWvvOMeDZ8m7z8ZoEY7SEo47Jjx1gunjgFWlp4SehqUwyfnkdiCDmkYGP9
XIrQRNfMqI1YVXkQO1wSIDbvigZ02CcWv9VoDonR2kzSNAh4hXgxZKTJx/Z2wiy8
jD6OfPGtYmz9kATUet86ISdtt6IUJwpOQB3b8eJgEcyReIYOzauyhIhCIC36XNA=
=VUVd
-----END PGP SIGNATURE-----

--------------enig2D5DE2101AF40D904450289D--
