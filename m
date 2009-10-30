From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: F_SETOWN_EX and F_GETLK64 conflict
Date: Fri, 30 Oct 2009 16:13:20 +1100
Message-ID: <20091030161320.17d07dc9.sfr@canb.auug.org.au>
References: <Pine.LNX.4.64.0910041229300.20203@digraph.polyomino.org.uk>
	<1254691822.21044.9.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Oct_2009_16_13_20_+1100_D3NqZ+.Fp_O8cjYi"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1254691822.21044.9.camel@laptop>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oleg Nesterov <onestero-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephane Eranian <eranian-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--Signature=_Fri__30_Oct_2009_16_13_20_+1100_D3NqZ+.Fp_O8cjYi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Sun, 04 Oct 2009 23:30:22 +0200 Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org> =
wrote:
>
> On Sun, 2009-10-04 at 12:35 +0000, Joseph S. Myers wrote:
> > In asm-generic/fcntl.h, F_SETOWN_EX and F_GETLK64 both have value 12, a=
nd=20
> > F_GETOWN_EX and F_SETLK64 both have value 13.  I don't see how this is=
=20
> > going to work correctly.  See=20
> > <http://sourceware.org/ml/libc-ports/2009-10/msg00013.html>.
>=20
>=20
> Ugh,.. yeah, non obvious collision that.

This is why we have F_LINUX_SPECIFIC_BASE and use it in
include/linux/fcntl.h ... it should be used as a base for any new fcntl
types since they don't require backward compatibility.

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Oct_2009_16_13_20_+1100_D3NqZ+.Fp_O8cjYi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrqdfAACgkQjjKRsyhoI8wR6ACdEKs7znjR8nNcvA2ZaCLZNR0c
wmYAoI3XL92cSFc3MHyMDgsUo/nfpcEa
=813U
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Oct_2009_16_13_20_+1100_D3NqZ+.Fp_O8cjYi--
