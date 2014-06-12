From: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH 3/4] drm/tegra: Add SET/GET_FLAGS IOCTLs
Date: Thu, 12 Jun 2014 09:18:40 +0200
Message-ID: <20140612071840.GB17027@ulmo>
References: <1402398294-10252-1-git-send-email-thierry.reding@gmail.com>
 <1402398294-10252-3-git-send-email-thierry.reding@gmail.com>
 <CADMs+9Y+i7H9GGpMKJNs2kkxzyruOjiXEv2O1_SipudPGZW-8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1659416127=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <CADMs+9Y+i7H9GGpMKJNs2kkxzyruOjiXEv2O1_SipudPGZW-8g@mail.gmail.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: =?utf-8?B?U3TDqXBoYW5l?= Marchesin <marcheu@chromium.org>
Cc: linux-tegra@vger.kernel.org, linux-api@vger.kernel.org, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
List-Id: linux-api@vger.kernel.org


--===============1659416127==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aM3YZ0Iwxop3KEKx"
Content-Disposition: inline


--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 09:21:21AM -0700, St=C3=A9phane Marchesin wrote:
> On Tue, Jun 10, 2014 at 4:04 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >
> > The DRM_TEGRA_GEM_SET_FLAGS IOCTL can be used to set the flags of a
> > buffer object after it has been allocated or imported. Flags associated
> > with a buffer object can be queried using the DRM_TEGRA_GEM_GET_FLAGS
> > IOCTL.
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/gpu/drm/tegra/drm.c  | 48 ++++++++++++++++++++++++++++++++++++=
++++++++
> >  include/uapi/drm/tegra_drm.h | 21 +++++++++++++++++++
> >  2 files changed, 69 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
> > index 5dca20982f3b..f292c29ef62f 100644
> > --- a/drivers/gpu/drm/tegra/drm.c
> > +++ b/drivers/gpu/drm/tegra/drm.c
> > @@ -548,6 +548,52 @@ static int tegra_gem_get_tiling(struct drm_device =
*drm, void *data,
> >
> >         return err;
> >  }
> > +
> > +static int tegra_gem_set_flags(struct drm_device *drm, void *data,
> > +                              struct drm_file *file)
> > +{
> > +       struct drm_tegra_gem_set_flags *args =3D data;
> > +       struct drm_tegra_bo *bo;
> > +       unsigned long flags =3D 0;
> > +
> > +       if (args->flags & ~DRM_TEGRA_GEM_FLAGS)
> > +               return -EINVAL;
> > +
> > +       gem =3D drm_gem_object_lookup(drm, file, args->handle);
> > +       if (!gem)
> > +               return -EINVAL;
>=20
> Usually -ENOENT is returned for unknown objects I think?

We've had that discussion on IRC a little while back. I came across a
few places where this was returned to userspace, and since I remember
a particular email[0] about this error code so well I thought it should
be discussed, but I can't remember the outcome (if any). Quoting from
that email:

	ENOENT is not a valid error return from an ioctl. Never has been,
	never will be. ENOENT means "No such file and directory", and is
	for path operations. ioctl's are done on files that have already
	been opened, there's no way in hell that ENOENT would ever be
	valid.

Given that -ENOENT is used *a lot* in DRM (many, if not most, of the
instances returning the error from an IOCTL), I wonder how this can be
resolved. Given that userspace may rely on this error code and that we
can't break userspace I don't see a way out.

Thierry

[0]: https://lkml.org/lkml/2012/12/23/75

--aM3YZ0Iwxop3KEKx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTmVRPAAoJEN0jrNd/PrOhuVAP/3PdhR331mb0E8kxjuP9BJWz
0ByUqTga54luHVMA3oiN6lVXxLicjSPa0VXEAa1nf8TWE0P5gTLhUp6EIwYvY5dN
oMvHk31+YrCHslgkEcvn+a44MLFBZZPv4ggUN0lko1J48XZ4KHj7WeoURcSgfIi4
KYUkgHn4MQb7zHlNIxKmXE/GcRgG/OdCY5UeF/7VwpLHjHzVblc1OP8VP9KVoCVs
RFKKi7OJZfLUpRN8nSnkq03mEtQxEaNC+0b4i1dsLk/K3dYGUVc/4d9HDMCgOP+u
M7sZVnN8knjt0FbuD1ISugT1Z7XBVGMl7ln6w2J908nkBLv5WfU3gzpcocMo0OVG
/uF5er9zcUOjjizAAxyATdPOUlbttcPxv5+4C3TV2pGjOpM5QFvfU+hdvI/elBOL
g8jB737jg50ls4HuT5/Vv0K4SH4CvTUxGi0qMWNy9n9qocuWGPAev2Tb8PW+LCS9
UGNTMuHOWrCMniHg8Vs5ULeTWX79tj80Cvvcz6blHkeKVisw8O/Jlm1/EfENHMOJ
SlDhdK+hSNVSIAFJgoq9NRblegjbjI2XqT4GeHANVtkUR56rOwiPhEVFHxjQiivq
S5TpKEtQ8xvqNFLeAKbaCsJFsGrqb1J7nlxz82CfGSx0CtXoyF83ED/XSxrXIqGk
5KiZyJ3vJG4yRejP7HXr
=3vZf
-----END PGP SIGNATURE-----

--aM3YZ0Iwxop3KEKx--

--===============1659416127==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
dri-devel mailing list
dri-devel@lists.freedesktop.org
http://lists.freedesktop.org/mailman/listinfo/dri-devel

--===============1659416127==--
