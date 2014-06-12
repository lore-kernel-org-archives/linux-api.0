From: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH 3/4] drm/tegra: Add SET/GET_FLAGS IOCTLs
Date: Thu, 12 Jun 2014 13:02:57 +0200
Message-ID: <20140612110256.GA27153@ulmo>
References: <1402398294-10252-1-git-send-email-thierry.reding@gmail.com>
 <1402398294-10252-3-git-send-email-thierry.reding@gmail.com>
 <CADMs+9Y+i7H9GGpMKJNs2kkxzyruOjiXEv2O1_SipudPGZW-8g@mail.gmail.com>
 <20140612071840.GB17027@ulmo>
 <20140612092843.GW5821@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1591903606=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20140612092843.GW5821@phenom.ffwll.local>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: linux-tegra@vger.kernel.org, =?utf-8?B?U3TDqXBoYW5l?= Marchesin <marcheu@chromium.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--===============1591903606==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2014 at 11:28:43AM +0200, Daniel Vetter wrote:
> On Thu, Jun 12, 2014 at 09:18:40AM +0200, Thierry Reding wrote:
> > On Wed, Jun 11, 2014 at 09:21:21AM -0700, St=C3=A9phane Marchesin wrote:
> > > On Tue, Jun 10, 2014 at 4:04 AM, Thierry Reding
> > > <thierry.reding@gmail.com> wrote:
> > > > From: Thierry Reding <treding@nvidia.com>
> > > >
> > > > The DRM_TEGRA_GEM_SET_FLAGS IOCTL can be used to set the flags of a
> > > > buffer object after it has been allocated or imported. Flags associ=
ated
> > > > with a buffer object can be queried using the DRM_TEGRA_GEM_GET_FLA=
GS
> > > > IOCTL.
> > > >
> > > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > > ---
> > > >  drivers/gpu/drm/tegra/drm.c  | 48 ++++++++++++++++++++++++++++++++=
++++++++++++
> > > >  include/uapi/drm/tegra_drm.h | 21 +++++++++++++++++++
> > > >  2 files changed, 69 insertions(+)
> > > >
> > > > diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/dr=
m.c
> > > > index 5dca20982f3b..f292c29ef62f 100644
> > > > --- a/drivers/gpu/drm/tegra/drm.c
> > > > +++ b/drivers/gpu/drm/tegra/drm.c
> > > > @@ -548,6 +548,52 @@ static int tegra_gem_get_tiling(struct drm_dev=
ice *drm, void *data,
> > > >
> > > >         return err;
> > > >  }
> > > > +
> > > > +static int tegra_gem_set_flags(struct drm_device *drm, void *data,
> > > > +                              struct drm_file *file)
> > > > +{
> > > > +       struct drm_tegra_gem_set_flags *args =3D data;
> > > > +       struct drm_tegra_bo *bo;
> > > > +       unsigned long flags =3D 0;
> > > > +
> > > > +       if (args->flags & ~DRM_TEGRA_GEM_FLAGS)
> > > > +               return -EINVAL;
> > > > +
> > > > +       gem =3D drm_gem_object_lookup(drm, file, args->handle);
> > > > +       if (!gem)
> > > > +               return -EINVAL;
> > >=20
> > > Usually -ENOENT is returned for unknown objects I think?
> >=20
> > We've had that discussion on IRC a little while back. I came across a
> > few places where this was returned to userspace, and since I remember
> > a particular email[0] about this error code so well I thought it should
> > be discussed, but I can't remember the outcome (if any). Quoting from
> > that email:
> >=20
> > 	ENOENT is not a valid error return from an ioctl. Never has been,
> > 	never will be. ENOENT means "No such file and directory", and is
> > 	for path operations. ioctl's are done on files that have already
> > 	been opened, there's no way in hell that ENOENT would ever be
> > 	valid.
> >=20
> > Given that -ENOENT is used *a lot* in DRM (many, if not most, of the
> > instances returning the error from an IOCTL), I wonder how this can be
> > resolved. Given that userspace may rely on this error code and that we
> > can't break userspace I don't see a way out.
>=20
> Imo returning -ENOENT for lookup failures is perfectly ok, after all the
> error code spelled out means "No entity" or so. So might as well extend
> the meaning. Without slight bending of error codes the only thing we'd
> ever be able to return is -EINVAL for ioctls, which is completely
> pointless.

I disagree. -EINVAL makes perfect sense because one of the arguments
passed into the IOCTL (the handle) is invalid.

> So my approach is to throw the vfs experts opinion into the wind and
> continue with the well-established rules we have in drm.

The quoted comments was from Linus himself and I didn't feel like being
shouted at. Given his above explanation it doesn't seem like the thing
that he'd consider subsystem specific. But then again, ENOENT usage has
gone unnoticed in DRM for some time, so maybe we'll get away with it.

I'll update the patch to make it consistent with the rest of DRM.

Thierry

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTmYjgAAoJEN0jrNd/PrOhK5AP/04BZDVa3uQT0C+jq3rjb7m5
ckpqnl+B/w/aKaPDThEzlHqE7FgNZ4d6CMP+wgrfuwGUBnAtBFmMOcYZnp3TLdh0
FkUKas7ozfnbIDqR1fDe1CTY3ykTOcETHA0xcyfjs5KGv9HxvLqbZRzmsUyM9s1v
48CE08Kd2hd/s2PmAErpsassk3huwk0Q352ZBcD2fH5EuzrbFv9jyHUHegpyz6Ti
vsuUbGKKj84HRX7Pea7YeCXJBx8O4jqRbk+DKe5eW9fcY/GApHIFBtepzzRl9S6u
e/ZNOWSyh8YAd0KckNPQi28XHUFPRLjWta3Y6vRgtF8SYoTHcaxTlC25o3bA6lCB
inRYk4mNeimwbQ45cn6rYQQ1qUTmZZJrF/WbWaNyfxNz4LcocPEtRZHwSWJxyXSd
478bLCZRQVgTCWodwHWqnLBfMRfmRiYOaJSR1LRqECfn6LVVl7BDwreNeUlw3Wze
lEfKlHbJlLS8x2gx27cpuOJy6VejepPjHj6AEHmOJcMPJobOha64n6UNtgajKW0H
nopX/HkOuOkubFnMukbEkYZQHjgzuV3bIagPOGeFLJz9o5fYd76NwXNBw67HGmID
jqwaDnbwrihd+xZ1pMlurPhB+1azFNGy3ZFH+UxfqWTN+HqN/RXM89NEngSkQA/W
KbXUpacsbWTYT4YQF5/G
=hFhd
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--

--===============1591903606==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
dri-devel mailing list
dri-devel@lists.freedesktop.org
http://lists.freedesktop.org/mailman/listinfo/dri-devel

--===============1591903606==--
