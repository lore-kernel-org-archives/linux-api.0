From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v06 14/36] arm uapi asm/signal.h: include <stddef.h> for
 size_t in userspace
Date: Wed, 9 Aug 2017 15:52:35 +0300
Message-ID: <20170809125235.GA19386@altlinux.org>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-15-mikko.rapeli@iki.fi>
 <20170808225739.GF10552@altlinux.org>
 <CAK8P3a30Vd2JquMvZ88tTO4jFAUMJGtUpvLuDmDPp2UFBYXDLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a30Vd2JquMvZ88tTO4jFAUMJGtUpvLuDmDPp2UFBYXDLQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 09, 2017 at 02:41:59PM +0200, Arnd Bergmann wrote:
> On Wed, Aug 9, 2017 at 12:57 AM, Dmitry V. Levin <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org> wrote:
> > On Sun, Aug 06, 2017 at 06:44:05PM +0200, Mikko Rapeli wrote:
> >> Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> doubts that __kernel_size_t could be use=
d here
> >> so trying to fall back to gcc's <stddef.h>.
> >
> > The only architecture where you cannot do this safely is x86 family
> > because of x32 exception.  If there is no chance that the change will
> > affect x32, feel free to replace size_t with __kernel_size_t like I did
> > some time ago, see
> > http://lkml.kernel.org/r/20170302002022.GB27097-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org
>=20
> There is another problem: on some 32-bit architectures, size_t is
> defined as 'unsigned int', while '__kernel_size_t' is defined as 'unsigned
> long'. These obviously have the same size, but the man page
> explicitly defines it as 'size_t ss_size'.
>=20
> If a user space program accesses the field in a way requires an
> exact type match, it gets a warning or error, e.g.
>=20
> 1. printf("signal with %zd bytes\n", stack->ss_size);
> 2. size_t *pointer_to_size_t =3D &stack->ss_size;
> 3. assert(__builtin_types_compatible_p(size_t, typeof(stack->ss_size)))
>=20
> Not sure how important those are, but I think there is at least a risk
> of any of those showing up in user space.

Agreed, one has to take this issue into consideration when replacing
size_t with __kernel_size_t.


--=20
ldv

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZiwWTAAoJEAVFT+BVnCUIP5cP/iX8EH5ez/QeMACD+wlbmkPH
wJf+cqhkFcV5lgXJJ75RtD9mIPOgO40DNtj1yMqGLtCWKVbR6XBD5bZcEFl3qY53
hAXPD+rjts4fH8NM7jSz06Z305NEB78hP0mP59QVsMt43NNblQm+HWi+8OCmsCt2
807xlf8QzvN1F4CZ1zHXl2rEIQXb1LtlBgXWcPdSTu3viLWQR5bD7eibrWTyDa8/
0XDPewGPlLZpeN3sMtU9H2EBt01QmLt0+FINYWgeVmPRj7ndQVne68QEGyC0uGmh
hRFDNkroVJgCz/A1lkll1FTqKBZ5y3aF3ZVDAIL1uphty7OUYHruEsSuHTFki5rA
sxQ8UXkfZU2Gr/BS4YgvgxystymNDCQCVIeLcUQP6czEMAGTnlAzPWPYoMvmH+sr
pg51f/JZyg6e34UOdBZwVaV7LhgtIn3kJdUhNCWtF4vco8QHgE6GOjcTHHuEOFk0
VD9cZtvuIRxtg+VwgWblPrc3t3DulCtO2h2uH2fgxAEh2mrOoZCI+eKPAAusZauh
l5uk8bQRdmuGfEXp8DvnvTeTqRkMAOVyYwyzfGqwlZ2zJhGC19HAhSyjK0ZBeBLK
nI/YkUYxxuWUyE5945oYHOreXAsa83iUPujtWh01Gcw2IpHbrw1A2uQJ7A8gSSxY
41CR4HNrHN0bYgvcPPxJ
=l1Kg
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
