From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v1 4/6] eeprom: sunxi: Move the SID driver to the eeprom
 framework
Date: Thu, 5 Mar 2015 19:36:06 +0100
Message-ID: <20150305183606.GC4911@lukather>
References: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1425548775-13067-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1425550515.24292.212.camel@x220>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NxDiCysn+RCvdoZt"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1425550515.24292.212.camel@x220>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, andrew-g2DYL2Zd6BY@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--NxDiCysn+RCvdoZt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Thu, Mar 05, 2015 at 11:15:15AM +0100, Paul Bolle wrote:
> >  endif
> > diff --git a/drivers/eeprom/Makefile b/drivers/eeprom/Makefile
> > index e130079..661422c 100644
> > --- a/drivers/eeprom/Makefile
> > +++ b/drivers/eeprom/Makefile
> > @@ -7,3 +7,4 @@ ccflags-$(CONFIG_EEPROM_DEBUG) +=3D -DDEBUG
> >  obj-$(CONFIG_EEPROM)		+=3D core.o
> > =20
> >  # Devices
> > +obj-$(CONFIG_EEPROM_SUNXI_SID)	+=3D eeprom-sunxi-sid.o
> > diff --git a/drivers/eeprom/eeprom-sunxi-sid.c b/drivers/eeprom/eeprom-=
sunxi-sid.c
> > new file mode 100644
> > index 0000000..eb32afb
> > --- /dev/null
> > +++ b/drivers/eeprom/eeprom-sunxi-sid.c
> > @@ -0,0 +1,129 @@
> > +/*
> > + * Allwinner sunXi SoCs Security ID support.
> > + *
> > + * Copyright (c) 2013 Oliver Schinagl <oliver-dxLnbx3+1qmEVqv0pETR8A@public.gmane.org>
> > + * Copyright (C) 2014 Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> > + *
> > + * This file is licensed under the terms of the GNU General Public
> > + * License version 2.  This program is licensed "as is" without any
> > + * warranty of any kind, whether express or implied.
> > + */
>=20
> So the license is GPL v2.
>=20
> > +MODULE_LICENSE("GPL");
>=20
> Which means you probably want
>     MODULE_LICENSE("GPL v2");
>=20
> > --- a/drivers/misc/eeprom/sunxi_sid.c
> > +++ /dev/null
> > @@ -1,156 +0,0 @@
> > -/*
> > - * Copyright (c) 2013 Oliver Schinagl <oliver-dxLnbx3+1qmEVqv0pETR8A@public.gmane.org>
> > - * http://www.linux-sunxi.org
> > - *
> > - * This program is free software; you can redistribute it and/or modify
> > - * it under the terms of the GNU General Public License as published by
> > - * the Free Software Foundation; either version 2 of the License, or
> > - * (at your option) any later version.
>=20
> But the previous driver was GPL v2 or later.
>=20
> > -MODULE_LICENSE("GPL");
>=20
> And this matches that.
>=20
> Was it intended to re-license this, or is the code basically new? (I
> haven't compared the before and after code, to be honest.)

That was unintentional, especially since this driver is not new at
all, and is barely a conversion to that framework.

Thanks for catching this!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--NxDiCysn+RCvdoZt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJU+KIWAAoJEBx+YmzsjxAgcTYP/1qxSRvmBep+ESoxiyCnzFXq
2q5fYloEnh3tbRnmwyIoVUkotNMq+CtT+Y7loUdyXrc32Vl7hbc01H+VvmsfIZDn
TF53wZoHguO8OPSW97ep0kTArZrZsOMEG2RCzV7vcS1h/YeCOzROY3qHg3j6g/yZ
TzhUv7kjgZo59ptr8lzuDi+X0VD0L6LaTfBJ2U9MRFC58yN0bX40pL861U+bA71n
rg/V8vcFdVAvsVnXZ33ELtHND00l7gasrz71YlTKL2xaK9FOjpEUb6+mtE+3v9lw
fhveWFPcIDZd9iAux95Jv10cyzYqNDFJzhPbsQ8EYhecorG2TxX1BVrfMgBioVpg
Q3iD9+O3o2vHhEh5KXh67OcqhisAerKsx1HmW+1/7zFtT/SLDw9JEfl7U7nDz17B
2WwZ6Kz+1gAWdrSr4izeAC02PAuzEYL/fG2wfvn/xfG1JkpfO+4Vvm2C3NdvFaXQ
P0UmE/ahp9iXiVA3gPVNIPDS2ZQoZq78s6K3b/EZ2IzBOiY9iD/U2ExP+DOpYHuz
Fr6v+OBgVlLgNon3B34q4/iltcai82REASPl2WJIar7Je/f84fmsw2KHLrzZ0RCd
eqRWT2iUUj2FfVbRPJeaDy499Gnz05rrOUoXbOOj0xOqWAfdojcIAog65Cte/tS6
eWG+rijDp8mOzOsRjFiv
=rrF3
-----END PGP SIGNATURE-----

--NxDiCysn+RCvdoZt--
