From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v06 30/36] uapi rdma/rdma_user_rxe.h: include in.h and
 in6.h
Date: Thu, 10 Aug 2017 05:47:48 +0300
Message-ID: <20170810024747.GA30198@altlinux.org>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-31-mikko.rapeli@iki.fi>
 <20170808231306.GH29372@obsidianresearch.com>
 <CAG9sBKP=NuSJzhg8rMBTsTuZkfzPDjxYgAGjiCnEMe=9xXB0xA@mail.gmail.com>
 <20170809155241.GB15586@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170809155241.GB15586-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 09, 2017 at 09:52:41AM -0600, Jason Gunthorpe wrote:
> On Wed, Aug 09, 2017 at 04:48:08PM +0300, Moni Shoua wrote:
> > >
> > > I'm not sure this is a good idea, linux/in.h should not be included in
> > > userspace users of this file, 'sockaddr_in' needs to come from glibc's
> > > 'netinet/in.h' instead..
>=20
> > Is it wrong to include include/uapi/linux/in.h from userspace?
>=20
> Generally speaking userspace should always use the glibc version of
> the headers and not headers from under linux/

Sorry?  Isn't the main idea of UAPI in providing the Linux interface for
userspace, unlike glibc headers that provide other more or less standard
interfaces like GNU, POSIX, etc?


--=20
ldv

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZi8lTAAoJEAVFT+BVnCUI/iMP/jm3ybCNJ7qYpb5FbRwBjKjZ
vXV7Ki83gh3vSDuh/5CJiO8NYMFHB7Zw3y80nGSsKswKeaRKFkx+GO4pO4N5UcE0
r5Y1ULAW37HCvmY0bwX2hqP9+X8txvwuggoEH9u+A9EGSvYzs9SEF44+UG5z1MBJ
34svqjkk/y6ui5YRIqaIQQ9zFkQZZnBJnqDvOGFXHlBADOwn17qRHnbiRqLRw6JZ
DzTep2uOEAuDOVTKwM7pyHILxz94Qf+OW7YYZYzi26SJvAExTD6qiZ273Hv5R9nS
gKa5Pb6aB/85RkzbuDrxKQL1ww0MBGVdJm3SVhC1sxiCQt6HdmcEsFAvsN1HUyXt
roHMj4LYtz+1iQTn8neRQYVI56t4gR9CspYnLXYMwX/6v/UtR9dixx6HghxsyQbp
FhRZxJMUUz+xCSlpRdVNUvJ3bqwta92etTSMtV7dso+pQ72Bo1mgUFMkbjuyXdAT
yFyTMDzOgQpLL1c67CCdE4uA8gdtJvOwaJQrNGlNAuJs+aGa54h4d6lY6gLNwW4J
rHde+XVFg4Yd8bEqOafQlETNBIdfFQBCMMr0/lMY75hvEcHSpnGclTjaPuAETJoX
LTzEQTZOINTAIpu0mIBe7rh9GWLjcN4AF9c2G+3xQe2h15cYlEp3WIK0xCxUgZ7w
g0jNVagGvPnuwob0VJUh
=4gVf
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
