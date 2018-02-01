From: Moritz Fischer <mdf@kernel.org>
Subject: Re: [PATCH v3 19/21] fpga: dfl: afu: add
 FPGA_GET_API_VERSION/CHECK_EXTENSION ioctls support
Date: Thu, 1 Feb 2018 16:13:09 +0100
Message-ID: <20180201151309.q3jjx42y6ldcrhc6@insfl13.etec.uni-karlsruhe.de>
References: <1511764948-20972-1-git-send-email-hao.wu@intel.com>
 <1511764948-20972-20-git-send-email-hao.wu@intel.com>
 <CANk1AXSfUfVbtbuREwG5Ck8TNZrqBg1fO5AuDDdFk-x=UjRTiw@mail.gmail.com>
 <20180201051625.GD10273@hao-dev>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lrqoflovbpuksoed"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180201051625.GD10273@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Alan Tull <atull@kernel.org>, Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, "Kang, Luwei" <luwei.kang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, Tim Whisonant <tim.whisonant@intel.com>, Enno Luebbers <enno.luebbers@intel.com>, Shiva Rao <shiva.rao@intel.com>, Christopher Rauer <christopher.rauer@intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-Id: linux-api@vger.kernel.org


--lrqoflovbpuksoed
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 01, 2018 at 01:16:25PM +0800, Wu Hao wrote:
> On Wed, Jan 31, 2018 at 08:52:36AM -0600, Alan Tull wrote:
> > On Mon, Nov 27, 2017 at 12:42 AM, Wu Hao <hao.wu@intel.com> wrote:
> >=20
> > Hi Hao,
> >=20
> > I'm adding my "Acked-by' below.  When you post v4, please add it so
> > that we can keep track of what got acked.
>=20
> Sure, thanks a lot for the code review. :)
>=20
> Hao
>=20
> >=20
> > Thanks,
> > Alan
> >=20
> > > FPGA_GET_API_VERSION and FPGA_CHECK_EXTENSION ioctls are common ones =
which
> > > need to be supported by all feature devices drivers including FME and=
 AFU.
> > > This patch implements above 2 ioctls in FPGA Accelerated Function Unit
> > > (AFU) driver.
> > >
> > > Signed-off-by: Tim Whisonant <tim.whisonant@intel.com>
> > > Signed-off-by: Enno Luebbers <enno.luebbers@intel.com>
> > > Signed-off-by: Shiva Rao <shiva.rao@intel.com>
> > > Signed-off-by: Christopher Rauer <christopher.rauer@intel.com>
> > > Signed-off-by: Xiao Guangrong <guangrong.xiao@linux.intel.com>
> > > Signed-off-by: Wu Hao <hao.wu@intel.com>
> > Acked-by: Alan Tull <atull@kernel.org>
Acked-by: Moritz Fischer <mdf@kernel.org>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fpga" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

Looks good,

Moritz

--lrqoflovbpuksoed
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEowQ4eJSlIZpNWnl2UVwKRFcJcNgFAlpzLoIACgkQUVwKRFcJ
cNiaKQgAxTIN45BIdHFBxrE4KKy+VhjXDUAAX/MfKSUieGYwJKRDfQu4xrc1VEKj
J64u1Ajahp1dleg5hZGdPZgfvjwmW4HPWVL+qPFBp3COqusmBdM90hPhpsMCaUEA
Kd4+QsGINKFreP1S3FprehjBt3k0/Yhut+B8uXxiLvAsR4My0/A2ih7gA4ZkUnPI
68rRWUC4EItMagUVxGC9u6JzWk1d18Fn2VKs7RjeRnp15ieN8OaTfZhjt2m6K5z4
Tn7Eb+j9wb/WOIo3pgUDqBLIS28/6H9mTl2wQdPNPgRiQXB0otrW8rmhcw2hzky4
XA/h7gpr7ODi8uWfcLdlTZ0LD2H/UA==
=fXxH
-----END PGP SIGNATURE-----

--lrqoflovbpuksoed--
