From: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 07/24] fpga: dfl: add feature device infrastructure
Date: Thu, 15 Feb 2018 11:49:01 -0800
Message-ID: <20180215194901.GA4382@tyrael.ni.corp.natinst.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-8-git-send-email-hao.wu@intel.com>
 <20180214210319.GC25618@tyrael.ni.corp.natinst.com>
 <CANk1AXRksJum6s5yB5727136DBLHs4UPW7xaLn_dT5qMEfqm9A@mail.gmail.com>
 <BE8371DA886269458E0220A16DC1F8277E154EC0@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BE8371DA886269458E0220A16DC1F8277E154EC0-0J0gbvR4kTg/UvCtAeCM4rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kang, Luwei" <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zhang, Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Whisonant, Tim" <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Luebbers, Enno" <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rao, Shiva" <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rauer, Christopher" <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 15, 2018 at 10:05:20AM +0000, Wu, Hao wrote:
> > On Wed, Feb 14, 2018 at 3:03 PM, Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >=20
> > Hi Moritz,
> >=20
> > > HI Hao,
> > >
>=20
> Hi Alan and Moritz
>=20
> Thanks a lot for the code review and comments.
>=20
> > > On Tue, Feb 13, 2018 at 05:24:36PM +0800, Wu Hao wrote:
> > >> From: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > >>
> > >> This patch abstracts the common operations of the sub features, and =
defines
> > >> the feature_ops data structure, including init, uinit and ioctl func=
tion
> > >> pointers. And this patch adds some common helper functions for FME a=
nd
> > AFU
> > >> drivers, e.g feature_dev_use_begin/end which are used to ensure excl=
usive
> > >> usage of the feature device file.
> > >>
> > >> Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >> Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >> Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >> Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >> Signed-off-by: Kang Luwei <luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >> Signed-off-by: Zhang Yi <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >> Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > >> Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >> ---
> > >> v2: rebased
> > >> v3: use const for feature_ops.
> > >>     replace pci related function.
> > >> v4: rebase and add more comments in code.
> > >> ---
> > >>  drivers/fpga/dfl.c | 59 +++++++++++++++++++++++++++++++++++++
> > >>  drivers/fpga/dfl.h | 85
> > +++++++++++++++++++++++++++++++++++++++++++++++++++++-
> > >>  2 files changed, 143 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
> > >> index 38dc819..c0aad87 100644
> > >> --- a/drivers/fpga/dfl.c
> > >> +++ b/drivers/fpga/dfl.c
> > >> @@ -74,6 +74,65 @@ static enum fpga_id_type feature_dev_id_type(stru=
ct
> > platform_device *pdev)
> > >>       return FPGA_ID_MAX;
> > >>  }
> > >>
> > >> +void fpga_dev_feature_uinit(struct platform_device *pdev)
> > >> +{
> > >> +     struct feature *feature;
> > >> +     struct feature_platform_data *pdata =3D dev_get_platdata(&pdev=
->dev);
> > > See comment below w.r.t ordering declarations. Not a must for sure.
> > >> +
> > >> +     fpga_dev_for_each_feature(pdata, feature)
> > >> +             if (feature->ops) {
> > >> +                     feature->ops->uinit(pdev, feature);
> > >> +                     feature->ops =3D NULL;
> > >> +             }
> > >> +}
> > >> +EXPORT_SYMBOL_GPL(fpga_dev_feature_uinit);
> > >> +
> > >> +static int
> > >> +feature_instance_init(struct platform_device *pdev,
> > >> +                   struct feature_platform_data *pdata,
> > >> +                   struct feature *feature, struct feature_driver *=
drv)
> > >> +{
> > >> +     int ret;
> > >> +
> > >> +     WARN_ON(!feature->ioaddr);
> > >
> > > Not sure I understand correctly, is the !feature->ioaddr a use-case t=
hat
> > > happens? If not just return early.
>=20
> Actually this should never happen (init a feature without mapped mmio
> resource address). If this warning is seen, that means there should be
> critical issues somewhere in driver enumeration code. But sure, I can just
> use if () return instead. : )
>=20
> > >> +
> > >> +     ret =3D drv->ops->init(pdev, feature);
> > >> +     if (ret)
> > >> +             return ret;
> > >> +
> > >> +     feature->ops =3D drv->ops;
> > >> +
> > >> +     return ret;
> > >> +}
> > >> +
> > >> +int fpga_dev_feature_init(struct platform_device *pdev,
> > >> +                       struct feature_driver *feature_drvs)
> > >> +{
> > >> +     struct feature *feature;
> > >> +     struct feature_driver *drv =3D feature_drvs;
> > >> +     struct feature_platform_data *pdata =3D dev_get_platdata(&pdev=
->dev);
> > >> +     int ret;
> > > We don't have clear guidelines here, but some subsystems want reverse
> > > X-Mas tree declarations.
> >=20
> > Sounds good!  I agree.
>=20
> Do you mean we should reverse fpga_xxx definitions? If yes, then I can up=
date
> the code to use fpga_dfl_xxx or dfl_xxx instead. : )

More a stylistic thing, in the sense that you'd have the longest line
first:

+     struct feature_platform_data *pdata =3D dev_get_platdata(&pdev->dev);
+     struct feature_driver *drv =3D feature_drvs;
+     struct feature *feature;
+     int ret;

Instead of:

+     struct feature *feature;
+     struct feature_driver *drv =3D feature_drvs;
+     struct feature_platform_data *pdata =3D dev_get_platdata(&pdev->dev);
+     int ret;

as I said not a big deal, some subsystems want you to do this, I don't
think we made that a strict rule so far, but it makes it visually more
pleasing ;-)

Moritz

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEowQ4eJSlIZpNWnl2UVwKRFcJcNgFAlqF5CkACgkQUVwKRFcJ
cNhqqwf+Ibu/z4f0N3WBO4bAxe34nIx6p14BO4VSmsMKVOXdtzqbBc+wHnXqOcVK
JZwXBvn4+7dVHbCLHivj0pnYk78gCptUUFrZRvDNoDsF8wwx1jsKjOjrh100T4Dn
Tq8yG4LIi8A/85lt8CEcUDkXeu5M+7IMDAba2I/9fH/px0tUSThIXl6B8ERX+ev/
xC4WONYsmshDoq0x3l48Lgxh7KSZf92YsAeC4kHCitRa/e4LmV9dcKLQxWg9sgjl
I4z+W4V+56pOku7zqLb8LdU3lbHNSIc+pesw/lBInFWw+eyhCU7puTq9JEpmB8rK
0xBsFSh0B4wkWKTPIYnuUw2buQKvsA==
=MGvV
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
