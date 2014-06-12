From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [PATCH 3/4] drm/tegra: Add SET/GET_FLAGS IOCTLs
Date: Thu, 12 Jun 2014 11:28:43 +0200
Message-ID: <20140612092843.GW5821@phenom.ffwll.local>
References: <1402398294-10252-1-git-send-email-thierry.reding@gmail.com>
 <1402398294-10252-3-git-send-email-thierry.reding@gmail.com>
 <CADMs+9Y+i7H9GGpMKJNs2kkxzyruOjiXEv2O1_SipudPGZW-8g@mail.gmail.com>
 <20140612071840.GB17027@ulmo>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140612071840.GB17027@ulmo>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 12, 2014 at 09:18:40AM +0200, Thierry Reding wrote:
> On Wed, Jun 11, 2014 at 09:21:21AM -0700, St=E9phane Marchesin wrote:
> > On Tue, Jun 10, 2014 at 4:04 AM, Thierry Reding
> > <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > > From: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > >
> > > The DRM_TEGRA_GEM_SET_FLAGS IOCTL can be used to set the flags of=
 a
> > > buffer object after it has been allocated or imported. Flags asso=
ciated
> > > with a buffer object can be queried using the DRM_TEGRA_GEM_GET_F=
LAGS
> > > IOCTL.
> > >
> > > Signed-off-by: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  drivers/gpu/drm/tegra/drm.c  | 48 ++++++++++++++++++++++++++++++=
++++++++++++++
> > >  include/uapi/drm/tegra_drm.h | 21 +++++++++++++++++++
> > >  2 files changed, 69 insertions(+)
> > >
> > > diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/=
drm.c
> > > index 5dca20982f3b..f292c29ef62f 100644
> > > --- a/drivers/gpu/drm/tegra/drm.c
> > > +++ b/drivers/gpu/drm/tegra/drm.c
> > > @@ -548,6 +548,52 @@ static int tegra_gem_get_tiling(struct drm_d=
evice *drm, void *data,
> > >
> > >         return err;
> > >  }
> > > +
> > > +static int tegra_gem_set_flags(struct drm_device *drm, void *dat=
a,
> > > +                              struct drm_file *file)
> > > +{
> > > +       struct drm_tegra_gem_set_flags *args =3D data;
> > > +       struct drm_tegra_bo *bo;
> > > +       unsigned long flags =3D 0;
> > > +
> > > +       if (args->flags & ~DRM_TEGRA_GEM_FLAGS)
> > > +               return -EINVAL;
> > > +
> > > +       gem =3D drm_gem_object_lookup(drm, file, args->handle);
> > > +       if (!gem)
> > > +               return -EINVAL;
> >=20
> > Usually -ENOENT is returned for unknown objects I think?
>=20
> We've had that discussion on IRC a little while back. I came across a
> few places where this was returned to userspace, and since I remember
> a particular email[0] about this error code so well I thought it shou=
ld
> be discussed, but I can't remember the outcome (if any). Quoting from
> that email:
>=20
> 	ENOENT is not a valid error return from an ioctl. Never has been,
> 	never will be. ENOENT means "No such file and directory", and is
> 	for path operations. ioctl's are done on files that have already
> 	been opened, there's no way in hell that ENOENT would ever be
> 	valid.
>=20
> Given that -ENOENT is used *a lot* in DRM (many, if not most, of the
> instances returning the error from an IOCTL), I wonder how this can b=
e
> resolved. Given that userspace may rely on this error code and that w=
e
> can't break userspace I don't see a way out.

Imo returning -ENOENT for lookup failures is perfectly ok, after all th=
e
error code spelled out means "No entity" or so. So might as well extend
the meaning. Without slight bending of error codes the only thing we'd
ever be able to return is -EINVAL for ioctls, which is completely
pointless.

So my approach is to throw the vfs experts opinion into the wind and
continue with the well-established rules we have in drm.
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
