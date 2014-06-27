From: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/4] drm/tegra: Implement more tiling modes
Date: Fri, 27 Jun 2014 12:45:25 +0200
Message-ID: <20140627104524.GA2797@ulmo>
References: <1403857706-15989-1-git-send-email-thierry.reding@gmail.com>
 <CAAVeFu+ja-PvqMyJuCPjkTu+e7jf4rgFLPsjFD3=7CmAEfjs5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAVeFu+ja-PvqMyJuCPjkTu+e7jf4rgFLPsjFD3=7CmAEfjs5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Erik Faye-Lund <kusmabite-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?utf-8?B?U3TDqXBoYW5l?= Marchesin <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, "linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2014 at 07:17:24PM +0900, Alexandre Courbot wrote:
> On Fri, Jun 27, 2014 at 5:28 PM, Thierry Reding
> <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > From: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> >
> > Tegra124 supports a block-linear mode in addition to the regular pitch
> > linear and tiled modes. Add support for these by moving the internal
> > representation into a structure rather than a simple flag.
>=20
> Tested-by: Alexandre Courbot <acourbot-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>=20
> For the 4 patches. The first one has a trivial conflict on drm.h when
> applied on today's -next.

That conflict is caused by another patch I have in my tree. I can easily
resolve that when pulling this patch to my drm/tegra/for-next branch.

Thanks for testing!
Thierry

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrUtEAAoJEN0jrNd/PrOhEcYP/2zDTz2l8qckplzMNEYjDkUe
vrVSlQoiTMb1q1RpT53L6B0AFSuDRUdwgSj3sNBhF+ZkfOXUjuV0w/RLdUq8LJmV
8lSevgtEwb66cE8XWk1yT3qjf0MOs2flZ90CqjtiWUZoj99cQj7Hqaiy7sBhS0GV
iYPH3psZTz9sJn5NQ/4Ti7IFPa6fG2tnrzDdXEnDM3DOBjFcSSA9l3Kx7Qicua8f
W/d5z2JDkSTf2+EoFkKnvazdYTmOxXM0s+DlQ1Ae3SPD65rTAI5Sa9TuYU1x875N
yknhN7ZagxIgtx6jplT/8U5jfZpZHjCZsl67nmXbT2NyQKsIj4k535SU9GOhGd7J
LHy9zzANTxqH8WaG/Z6Vs6ZTJe0XesVK0xqRhUliG0mi44aV4e3Sctf5QF6J2t76
Y0kIIivn48bQvdAIamOJFVEPO6dXWM0zLdeCOIUOr5RWAQyf2nO2ZQ3pqKMcPcoy
R18s+dGhUBwdn9ENbA/xtuduxL4VZvje99J3srXEDvHw4feaqeUcH408i7HK8ecn
4lmMCM8CBjQZhXZtQ3hmcsixqzSyoEq70Cs81zSrbyhERy+NFbSn+ruxYEd8Rkx+
PNBTeZJ6GUrbVjQ5/ueS51YiFlr5zGLIRZyZVLUvpjyewVxIqARZ0IXBrksOpI3k
gj7Mz0rn7KrWfGoXTXqx
=EQR8
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
