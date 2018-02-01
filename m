From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v3 16/21] fpga: dfl: add fpga region platform driver for
 FME
Date: Thu, 1 Feb 2018 16:13:50 +0100
Message-ID: <20180201151350.ijbryvpmpuiv2rxu@insfl13.etec.uni-karlsruhe.de>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-17-git-send-email-hao.wu@intel.com>
 <CANk1AXTBprjzr71xa=YD5jR77822xugVEQMboxhzAJFY8YFMxw@mail.gmail.com>
 <20180201052345.GA10393@hao-dev>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oqm7cbdnri4usvmy"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180201052345.GA10393@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Alan Tull <atull@kernel.org>, Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>
List-Id: linux-api@vger.kernel.org


--oqm7cbdnri4usvmy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 01, 2018 at 01:23:45PM +0800, Wu Hao wrote:
> On Wed, Jan 31, 2018 at 02:46:28PM -0600, Alan Tull wrote:
> > On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu@intel.com> wrote:
> >=20
> > Hi Hao,
> >=20
> > Just fix the SPDX, otherwise it looks good.
>=20
> Sure, will fix it. Thanks for the review. :)
>=20
> Thanks
> Hao
>=20
> >=20
> > > This patch adds fpga region platform driver for FPGA Management Engin=
e.
> > > It register an fpga region with given fpga manager / bridge device.
> > >
> > > Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> > > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> > > Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> > > Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> > > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > Acked-by: Alan Tull <atull@kernel.org>
Acked-by: Moritz Fischer <mdf@kernel.org>
> >=20
> >=20
> > > diff --git a/drivers/fpga/fpga-dfl-fme-region.c b/drivers/fpga/fpga-d=
fl-fme-region.c
> > > new file mode 100644
> > > index 0000000..0b988ab
> > > --- /dev/null
> > > +++ b/drivers/fpga/fpga-dfl-fme-region.c
> > > @@ -0,0 +1,92 @@
> > > +/*
> > > + * FPGA Region Driver for FPGA Management Engine (FME)
> > > + *
> > > + * Copyright (C) 2017 Intel Corporation, Inc.
> > > + *
> > > + * Authors:
> > > + *   Wu Hao <hao.wu@intel.com>
> > > + *   Joseph Grecco <joe.grecco@intel.com>
> > > + *   Enno Luebbers <enno.luebbers@intel.com>
> > > + *   Tim Whisonant <tim.whisonant@intel.com>
> > > + *   Ananda Ravuri <ananda.ravuri@intel.com>
> > > + *   Henry Mitchel <henry.mitchel@intel.com>
> > > + *
> > > + * This work is licensed under the terms of the GNU GPL version 2.
> > > + * SPDX-License-Identifier: GPL-2.0
> > > + */
> > > +
> > > +#include <linux/module.h>
> >=20
> > Thanks,
> > Alan

Thanks,
Moritz

--oqm7cbdnri4usvmy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEowQ4eJSlIZpNWnl2UVwKRFcJcNgFAlpzLqoACgkQUVwKRFcJ
cNibgQf/bkWTtCXm9nLqQmYlQdXq1ri3DQNzr/aZsdyWEbHTUipMENsf6kW0/YgI
huPBMqU8uWUANBZotm7/qtoWnine6G3CTNogjdiLExvf8TJhtFCu5cfyKAmO9xu0
6t4TJYfPp0ZhtpDSJPml4Y1JJQb8ZBIjyS7x4A0NoR1aUr15Hzt1ry1+URM4anT+
Ij4pGpcZValSvyZtKE0gyUWg+p2E6SZATuMhxJWMENYhB2pfm7bOmSK+TgVixiXX
o7kqqSBgj//IlSG0hB+qM+DXuqzrQXODg+GWX2/bxCj5vVfgkoICti9+R2Vs+Wbj
u26xPUlT/u9CMumzHSJorcDz3L2s6Q==
=yXQy
-----END PGP SIGNATURE-----

--oqm7cbdnri4usvmy--
