From: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 15/21] fpga: dfl: add fpga bridge platform driver for
 FME
Date: Thu, 1 Feb 2018 16:11:08 +0100
Message-ID: <20180201151108.dyxzcpjagfmxgjgb@insfl13.etec.uni-karlsruhe.de>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-16-git-send-email-hao.wu@intel.com>
 <CANk1AXS-ioW2svMS3QwrQCF5TiHp_nwaongC=d2Z2MfT8BEMMw@mail.gmail.com>
 <20180201051543.GC10273@hao-dev>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aq7qqyqrth4x3dwg"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180201051543.GC10273@hao-dev>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--aq7qqyqrth4x3dwg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hao,

On Thu, Feb 01, 2018 at 01:15:43PM +0800, Wu Hao wrote:
> On Wed, Jan 31, 2018 at 09:16:58AM -0600, Alan Tull wrote:
> > On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >=20
> > Hi Hao,
> >=20
> > One fix below.  Besides that, please add my ack.
> >=20
> > > This patch adds fpga bridge platform driver for FPGA Management Engin=
e.
> > > It implements the enable_set call back for fpga bridge.
> > >
> > > Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >=20
> > Acked-by: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >=20
> > > diff --git a/drivers/fpga/fpga-dfl-fme-br.c b/drivers/fpga/fpga-dfl-f=
me-br.c
> > > new file mode 100644
> > > index 0000000..db2603b
> > > --- /dev/null
> > > +++ b/drivers/fpga/fpga-dfl-fme-br.c
> > > @@ -0,0 +1,87 @@
> > > +/*
> > > + * FPGA Bridge Driver for FPGA Management Engine (FME)
> > > + *
> > > + * Copyright (C) 2017 Intel Corporation, Inc.
> > > + *
> > > + * Authors:
> > > + *   Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > + *   Joseph Grecco <joe.grecco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > + *   Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > + *   Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > + *   Ananda Ravuri <ananda.ravuri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > + *   Henry Mitchel <henry.mitchel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > + *
> > > + * This work is licensed under the terms of the GNU GPL version 2.
> >=20
> > If we're using the SPDX, then please get rid of the above line.
> >=20
> > > + * SPDX-License-Identifier: GPL-2.0
> > > + */
> >=20
> > The SPDX line should be the first line of the file with a // (for .c
> > files), please see:
> >=20
> > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tre=
e/Documentation/process/license-rules.rst
> >=20
> > Same thing for other files.
>=20
> Thanks for the review.
>=20
> Sure, will fix this for all driver files in the next version.
>=20
> Thanks
> Hao
>=20
> >=20
> > Alan

Looks good, feel free to add my Acked-by: with fixes Alan requested,

Moritz

--aq7qqyqrth4x3dwg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEowQ4eJSlIZpNWnl2UVwKRFcJcNgFAlpzLgcACgkQUVwKRFcJ
cNjcmQf+OkmCQynZ0YYYDWjRGrfCVrI6Sa7ULCpgQnVNZoGaOfDRQQLZ8vguOgF0
UhX9SiH7bcykBPxJV8hefpdw29/iVP3+xCVO2TFlx/7N18TYmJZIjbWmBok20kLI
WJwU875j0gcJPkAuhPjWSlz50lxrsuH+o8Wp2l42EWaWbqHCIVvZks7zbb4ofZc9
TlHPvvgS7WLLAUrT9oVI2Uz17MOe+iGl4Xr9jDnS+xJ+Pbsn3Ob+ULDpn7lc6BLS
r4HuIzSWTAE2swMMUKt7/U1JhbAUKrwYrg8SNSZP/I75PBw1xMuO43Bxav/7+WJc
vVM4BWVM1TrB/2sfXi/9D11D+9r4Jw==
=ysIw
-----END PGP SIGNATURE-----

--aq7qqyqrth4x3dwg--
