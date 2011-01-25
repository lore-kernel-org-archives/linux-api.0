From: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
Date: Tue, 25 Jan 2011 13:52:00 -0500
Message-ID: <201101251352.03079.vapier@gentoo.org>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com> <20110125174515.C1DC2183C19@magilla.sf.frob.com> <201101251921.15184.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6083298.yfAf693vRu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201101251921.15184.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Paul Eggert <eggert-764C0pRuGfqVc3sceRu5cw@public.gmane.org>, Eric Blake <ebb9-PGZyUNKar/Q@public.gmane.org>
Cc: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linasvepstas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Chris Metcalf <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>, GLIBC Devel <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-ports-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

--nextPart6083298.yfAf693vRu
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday, January 25, 2011 13:21:14 Arnd Bergmann wrote:
> On Tuesday 25 January 2011 18:45:15 Roland McGrath wrote:
> >  I know of no reason to
> >=20
> > think that the current treatment of the empty string was ever intended =
at
> > the creation of the *at interfaces.
>=20
> I always assumed that this was done so that the *at syscalls can replace
> both the ones that take a file descriptor (e.g. fstat) and the ones that
> take a pathname (e.g. stat), which is sensible for the non-AT_FDCWD case,
> although not documented in the man pages.
>=20
> Treating the empty string special for AT_FDCWD is rather pointless, but
> at least consistent.

i dont know if the gnulib peeps are on these lists, but i think their=20
implementations of some of the *at funcs leverage the extended behavior tha=
t=20
is available under Linux.  or at least, i'm certain they'll have some insig=
ht=20
into some of these nuances.
=2Dmike

--nextPart6083298.yfAf693vRu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJNPxvSAAoJEEFjO5/oN/WBK+sQAJwq0dJKP+rv3bXDv1qlq8BJ
MGeRFiJrahps+qkmGYc0C3hd8QvCtwf/6NwkKD9SbViW+81eI2R087egwZ5djsUQ
zlJLjj3A9DLuOaDqZPA7c6Y1Hhj4kbfYhmapA1hhVGaZBKbpFbzQsm4W08XeVVDk
eqekSCRzWehf+Yrc+XrX5rOTPJDSiqlTVfoSRaBSh62vALAHZyRVsg0FzHQr1xiC
ulh0mtym8n13UdAB9CVe49Vj/DQWP1hUb63iBmbkw6JJbZRJBr5gM6KfEjbHDaAm
igDqF4grZXGjjHOSfI6Mm4FvBgyjyOkPQBOCcqbob6vgCIA9ZF1k28bCfDnhhWIW
/wl2TmbBb21WpGgytqBlZjZw/vyPoT5kK9DUdbXnk4isLkpeJPWKgyeqzoqp/s9p
kvJLT+OylPRxP7k/B18kadesAcSxFmhTqsZE2V9pnUSmegiIOPjGEsBgGroWNW7K
YluXqd+/u0AjVin2OpOnR6rpQVBGp98vKDWncSHzs3qEsCsreVyFS9/flulRncwz
oyikPcQBXm0hozOOClxY9pAdSL3KrCMli9s3eXcWrh4ZNMqws3ZCIbPZW//fjwu/
4KUJqBh2P6gCoXg+oxd4enYDnXjBPUwvIyoeLsQ5rUo+Fknb22lgytxUc2N3dqLG
Ogp+zs3CTyVFef3z3kIA
=ZvLr
-----END PGP SIGNATURE-----

--nextPart6083298.yfAf693vRu--
