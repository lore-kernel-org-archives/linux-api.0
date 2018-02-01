From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v3 12/21] fpga: dfl: fme: add
 FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls support
Date: Thu, 1 Feb 2018 16:11:57 +0100
Message-ID: <20180201151157.44vecqprje6dqzjl@insfl13.etec.uni-karlsruhe.de>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-13-git-send-email-hao.wu@intel.com>
 <CANk1AXT4OiH=Wj3o5AjsS7DiUitudMetVu860Qz1RjodDfM18g@mail.gmail.com>
 <20180201051107.GB10273@hao-dev>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="judw2s4lxvqf55cu"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180201051107.GB10273@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Alan Tull <atull@kernel.org>, Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org


--judw2s4lxvqf55cu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 01, 2018 at 01:11:07PM +0800, Wu Hao wrote:
> On Wed, Jan 31, 2018 at 09:31:59AM -0600, Alan Tull wrote:
> > On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu@intel.com> wrote:
> >=20
> > Hi Hao,
> >=20
> > One fix again, otherwise please add my ack to subsequent versions.
>=20
> Sure. Thanks for the review.
>=20
> >=20
> > > FPGA_GET_API_VERSION and FPGA_CHECK_EXTENSION ioctls are common ones =
which
> > > need to be supported by all feature devices drivers including FME and=
 AFU.
> > > Userspace application can use these ioctl interfaces to get the API i=
nfo
> > > and check if specific extension is supported or not in current driver.
> > >
> > > This patch implements above 2 ioctls in FPGA Management Engine (FME)
> > > driver.
> > >
> > > Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> > > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> > > Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> > > Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> > > Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > > Signed-off-by: Wu Hao <hao.wu@intel.com>
> >=20
> > Acked-by: Alan Tull <atull@kernel.org>
Acked-by: Moritz Fischer <mdf@kernel.org>
> >=20
> > > diff --git a/include/uapi/linux/fpga-dfl.h b/include/uapi/linux/fpga-=
dfl.h
> > > new file mode 100644
> > > index 0000000..b46d124
> > > --- /dev/null
> > > +++ b/include/uapi/linux/fpga-dfl.h
> > > @@ -0,0 +1,50 @@
> > > +/*
> > > + * Header File for FPGA DFL User API
> > > + *
> > > + * Copyright (C) 2017 Intel Corporation, Inc.
> > > + *
> > > + * Authors:
> > > + *   Kang Luwei <luwei.kang@intel.com>
> > > + *   Zhang Yi <yi.z.zhang@intel.com>
> > > + *   Wu Hao <hao.wu@intel.com>
> > > + *   Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > > + *
> > > + * This work is licensed under the terms of the GNU GPL version 2.
> >=20
> > Please remove above line.  My understanding is that we are supposed to
> > not combine SPDX with other license statements.
> >=20
> > > + * SPDX-License-Identifier: GPL-2.0
> > > + */
> >=20
> > // SPDX-License-Identifier: GPL-2.0
> >=20
> > As first line of file.
>=20
> Sure, I will fix this in the next version.
>=20
> Thanks
> Hao
>=20
> >=20
> > Thanks,
> > Alan

Thanks,

Moritz

--judw2s4lxvqf55cu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEowQ4eJSlIZpNWnl2UVwKRFcJcNgFAlpzLjkACgkQUVwKRFcJ
cNj2rggAvchiYW0vY//rcKCT9Nt2yN6utat+EUipAIaDhRBS2Lpn5G+MAiHd+21o
EZhw7uJiGorwIUX1MlafsFhHznHnmo5/E6/PM87fclNcahPr3SxXVTOmHh5JDfrf
LFSwcw5iF1SKF8MMchOIKWdEFb2PVnKox9m6JV+JLHFnK2U7cZWTI7o2I1JoCS9q
x7OVYSKBsZ8Gjw6/H97l7wWTpWhnrbVXPQRH8MYeTZPGe+8y2swI0HXWO12NgMtH
eqxPS5VSLWF56yA9ZDCyXsrjgrUEETe47v1pv0eUvo1td2w/sQUqNPtVPlQwbOQE
7bCDLjjlaqjJwlF1wysa8LsC3rnpVw==
=ecPR
-----END PGP SIGNATURE-----

--judw2s4lxvqf55cu--
