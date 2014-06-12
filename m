From: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH 2/4] drm/tegra: Add SET/GET_TILING IOCTLs
Date: Thu, 12 Jun 2014 09:01:01 +0200
Message-ID: <20140612070100.GA17027@ulmo>
References: <1402398294-10252-1-git-send-email-thierry.reding@gmail.com>
 <1402398294-10252-2-git-send-email-thierry.reding@gmail.com>
 <CADMs+9YJgP7GqG0qhaTzd8QtANnTb4yFq2GkAYiS_U+HFw+e0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1125775350=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <CADMs+9YJgP7GqG0qhaTzd8QtANnTb4yFq2GkAYiS_U+HFw+e0w@mail.gmail.com>
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


--===============1125775350==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 10:43:30AM -0700, St=C3=A9phane Marchesin wrote:
> On Tue, Jun 10, 2014 at 4:04 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >
> > Currently the tiling parameters of buffer objects can only be set at
> > allocation time, and only a single tiled mode is supported. This new
> > DRM_TEGRA_GEM_SET_TILING IOCTL allows more modes to be set and also
> > allows the tiling mode to be changed after the allocation. This will
> > enable the Tegra DRM driver to import buffers from a GPU and directly
> > scan them out by configuring the display controller appropriately.
>=20
> I was wondering why not support the new tiling modes on creation as
> well, I guess because you don't have room for height in the creation
> ioctl?

Yes, back at the time when the GEM_CREATE IOCTL was added we only left
enough room for "flags", so it'll be difficult to add support for the
newer tiling modes.

One possibility that I see is to extend struct drm_tegra_gem_create in a
backwards-compatible way and make new fields dependent on some new flag,
somewhat like this:

	#define DRM_TEGRA_GEM_CREATE_BLOCK_LINEAR (1 << 3)

	struct drm_tegra_gem_create {
		__u64 size;
		__u32 flags;
		__u32 handle;
		__u32 height;
		__u32 pad;
	};

Then the DRM driver can parse the height field only if the BLOCK_LINEAR
flag is set.

To be honest, though, I'd prefer to deprecate the flags at creation if
these patches get merged so that we can have a standard way of setting
these rather than a few.

Do you see any particular advantages in specifying the tiling mode at
creation time?

> > diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_drm.h
> > index b75482112428..0829f75eb986 100644
> > --- a/include/uapi/drm/tegra_drm.h
> > +++ b/include/uapi/drm/tegra_drm.h
> > @@ -129,6 +129,27 @@ struct drm_tegra_submit {
> >         __u32 reserved[5];      /* future expansion */
> >  };
> >
> > +#define DRM_TEGRA_GEM_TILING_MODE_PITCH 0
> > +#define DRM_TEGRA_GEM_TILING_MODE_TILED 1
> > +#define DRM_TEGRA_GEM_TILING_MODE_BLOCK 2
> > +
> > +struct drm_tegra_gem_set_tiling {
> > +       /* input */
> > +       __u32 handle;
> > +       __u32 mode;
> > +       __u32 value;
>=20
> This seems to only be used for height, if so should it be called height?

The idea here was to have a generic name here so that it could be more
easily extended if/when newer tiling modes are introduced.

Thierry

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTmVArAAoJEN0jrNd/PrOh+QEP/1Zw85p1ZLyM2emGgEtIH7g8
kSP0oN8EF723vc7f1TOO3aU4mIoODEIlKHIA/YyNEQCHAEbTa/ZadHRQ3rAPekVs
RZxm8CV8/eW1JB3gvSmdPz0ZvKozCp89b89VDv1QFNRBsoTaZav8SKp3nusFoatI
a/BCGJOBlHTD3pPClInr6fFw89MaIQLWniW3RIpaOattiDEoX5zipTwE8EqloXkA
bAsD55HTNu6/1jspwLNDXqgYcKKTNlqpuV85y/f8Ae+CgE2ElHdRxU7TxtsvmBrW
XVWAeZjuyERCEQvbd5IWhqdT8YSXXBPQUnOLdN5OoE5KCsWtMotJPWhxGvbMdE8M
QIvSPfztFTUFYo3/VXziuo5eKdi3JI725y+4jf/uHncvncTPXAuY44VqbxquedCb
JpBSGnQXZPxbND04t5aRXldv1NgvTE7o3WeniPwMGCAhpYL5PdwiAT1vnsPHja02
jaJcI/NCgH35DyFCpzzva3M6dhdUcWSvQOmLbmIRpSpYI21pl2bcUIanT3xDA4YS
HbondaU0+Q2UObFN48ppPevEm/aZJ7EMNZRwGG0uq7cmsLYaatMtaCrAB8tZJp7P
dV9+MnRqX+KVpDSoFZnLXrfqsxJKuunEAKJIMucnbTXQGF6zIl/RhH+37Gz4A+do
4nZlfdnb6InkoxN9sMP7
=ALa2
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--

--===============1125775350==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
dri-devel mailing list
dri-devel@lists.freedesktop.org
http://lists.freedesktop.org/mailman/listinfo/dri-devel

--===============1125775350==--
