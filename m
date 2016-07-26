From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: [PATCH 0/5 RFC] Add an interface to discover relationships
 between namespaces
Date: Tue, 26 Jul 2016 11:32:25 -0700
Message-ID: <20160726183224.GN24913@odin.tremily.us>
References: <20160721210650.GA10989@outlook.office365.com>
 <1515f5f2-5a49-fcab-61f4-8b627d3ba3e2@gmail.com>
 <CANaxB-w8H8Wo8FmtmBBZTpJX-ZDGRQx0rbm9E5c9WbduQ_Ukmw@mail.gmail.com>
 <e2811bf1-4b86-e115-bcdb-301d6f2546eb@gmail.com>
 <87lh0pg8jx.fsf@x220.int.ebiederm.org>
 <44ca0e41-dc92-45b1-2a6c-c41a048a072d@gmail.com>
 <87r3ahepb4.fsf@x220.int.ebiederm.org>
 <20160726025455.GC26206@outlook.office365.com>
 <3390535b-0660-757f-aeba-c03d936b3485@gmail.com>
 <20160726182524.GA328@outlook.office365.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9qSUuv1pKdnPyWmS"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160726182524.GA328-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--9qSUuv1pKdnPyWmS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 26, 2016 at 11:25:24AM -0700, Andrew Vagin wrote:
> Sure. If a process wants to compare two namespaces, it needs to get file
> descriptors for them (open /proc/PID/ns/XXX, use new ioctl-s, find a
> process which has them),
> and then it calls kcmp(pid1, pid2, KCMP_NSFD, ns_fd1, ns_fd2)

If you use the new ioctl-s to get ns_fd2, do you walk your local /proc
to find pid2?

Cheers,
Trevor

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--9qSUuv1pKdnPyWmS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXl6yyAAoJEBBpoQVgXJg14XQP/0mQqjIzdYwyZzqcx9UjMmor
KB795YEcFsDzw4kDaBM6MpGMcG7w/zdp8namR4Sq69F+51H0lepE6PQMtga7fFep
KQGhLD6k8bJETLmGvFbl6qAZ7nFUDMYORg7ZxN/VgGPdEykCrFa0wybrR7Lj3KF7
i1FDfos2QNqxoglSsEOCaINPPGG0yfyyYVYLakkFLz/Z1H+ExWyW5nF14vGk9O87
LLPlMpZLjrYWyLJt1LEKKPYFlIOBPCfVIYv2gbh61Gb45l5Sq6HoAZNvMs0E2gnG
HcscK4Ol2dUTqLK4SrAobOrpwIZnz9Avsk6Foo3gLBo2wwBqvwl4ORiXuPFiCoU0
+a6jaHPyGeRBpe/fL0E5TVsyt2m5QMm5SnxatW2FkLQl96F/lJDvtq4cUU3r254v
ShyCtyJgOPbGmW7X9adzOPjGQKfTQ26igv5axcYGjd2XdpeHyJvLb0xO26r8OQo5
GiZ8tYesOqPb4D6Dn3nczRWBzpyziF+MGNRTmD/bRCGMwzfxlOvu0OkJxnLy1dVJ
JK7RXZpSLCfxfFEAZoJ+NHW1n5CZkqNkNBrmW3mzh0C7ljCsB0QRW8Y+eaTBCtpD
8IWOF2waF9R4FFUwGxHYv0UEB5wXInL5tDwIaIuzVmthdNCaSS+m09fm2NSqt6gD
Ou1LDpBoMQByobYl3Y3g
=uvB6
-----END PGP SIGNATURE-----

--9qSUuv1pKdnPyWmS--
