From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: Introspecting userns relationships to other namespaces?
Date: Thu, 7 Jul 2016 23:16:36 -0700
Message-ID: <20160708061636.GA5528@odin.tremily.us>
References: <20160706141348.GB20728@mail.hallyn.com>
 <CAKgNAkhtQNg0mVv6ei_JigNz3njo_G3opE+rzd4OtKpa2hQe9g@mail.gmail.com>
 <20160707133631.GA2994@mail.hallyn.com>
 <1467903712.2347.16.camel@HansenPartnership.com>
 <CAKgNAkg+OiBngdFsdVR0gsSnVhMppuH2DxMBLCNAx8in5C0-zQ@mail.gmail.com>
 <1467919055.2322.36.camel@HansenPartnership.com>
 <20160708021617.GB10512@outlook.office365.com>
 <20160708030055.GC10512@outlook.office365.com>
 <1467948407.2322.88.camel@HansenPartnership.com>
 <20160708052650.GM4916@odin.tremily.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160708052650.GM4916-q4NCUed9G3sTnwFZoN752g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 07, 2016 at 10:26:50PM -0700, W. Trevor King wrote:
> And if you want to put that whole ancestor tree in fdinfo, you have
> to come up with some way to handle the two-parent branching.

Going towards the roots is nice, because you know a given namespace
will only have two parents, but it leaks information about the system
into the container.  It's probably better to follow the NStgid,
etc. example and only walk toward the leaves.  So a (privileged?)
process in the root namespace could see the whole tree, while a
process in non-root namespaces could only see their namespaces and
descendants.  In situations where you were part of a namespace that
belonged to an external user namespace (e.g. you nsenter a child user
namespace but are still in the root PID namespace), you'd want an
=E2=80=9Cunknown=E2=80=9D entry for the parent you couldn't see.

Cheers,
Trevor

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXf0VCAAoJEBBpoQVgXJg1fGcP/iRnyqEZccP9QWm9ikR+akfH
Vv6ogCP2nGiuXBGDr2B42A15iVkFk1iyLTS+nrNJQD56qz8brebUyRMx3PXrUSqe
n+eBy12r9dGStlOlf95BKf5HC3QRSJ2+5YdC4+iES8YnSIz6izJPMA/eBFNooUAc
IV3c0egcz6l+e8cAZpDhWZSkFy9i4A4pSIyZQfmd1SV24AdKIAjx1J3Ee8LXO31v
mF3SqPxcH7BaMmxG3R7rrmsgct+NSJWiXqahxuj44XDpTmRS2BMlPiq/jp9hM/04
q+o2g+aWBBKnENvxWk2skgwtRxSPmrf6rckh2K50/1jM6n+o5NUdbsz2U8DbR5w8
P7Tt64RT6B7YUVqlFucHQeS2M+6Uv7+topOAYOriMZA8m1Sik2C9AoxwxMPZg73z
Y5KYa59TcjlQK9mWLWY3JnRU1W/c3KAUZNa1oOHJzujHoIZX145LvI0E53wa00ce
tFttrDfNvk2EFNkFVmxQKGl/8pUtS5wkBss490oXwcNRtFO1/4ASrQDMUMhDCaeI
ttvlYy64OAFS8BQdNRa99ryTUhu/rFjUzfLLTP1plEr15wi3TTWa5b0vS3FuhuQj
Qpl6xnyNFfii3/yxJ5ud9xBYRPqBHG0EvZw3PBAFgq14y4p7C12HCFjtee3m4XhJ
kfLh5QBsYb7ECH3I3Vyq
=4BmL
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
