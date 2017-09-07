From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH 1/2] pidmap(2)
Date: Thu, 7 Sep 2017 13:08:09 +0300
Message-ID: <20170907100809.GD27490@altlinux.org>
References: <20170905190500.GA13746@avx2>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hxkXGo8AKqTJ+9QI"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170905190500.GA13746@avx2>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, Tatsiana Brouka <Tatsiana_Brouka@epam.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1@epam.com>, Andrey Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org


--hxkXGo8AKqTJ+9QI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 05, 2017 at 10:05:00PM +0300, Alexey Dobriyan wrote:
> From: Tatsiana Brouka <Tatsiana_Brouka@epam.com>
>=20
> Implement system call for bulk retrieveing of pids in binary form.
>=20
> Using /proc is slower than necessary: 3 syscalls + another 3 for each thr=
ead +
> converting with atoi().
>=20
> /proc may be not mounted especially in containers. Natural extension of
> hidepid=3D2 efforts is to not mount /proc at all.
>=20
> It could be used by programs like ps, top or CRIU. Speed increase will
> become more drastic once combined with bulk retrieval of process statisti=
cs.

What could give a noticeable performance gain in a less ridiculous way
is an interface like task_diag, see https://lkml.org/lkml/2016/4/11/924 .


--=20
ldv

--hxkXGo8AKqTJ+9QI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZsRqIAAoJEAVFT+BVnCUIrU8P/R2+YZN7dlUVpp+JQGFe4hng
0LYozC83phSxXRZJGTPLsOU4+XWk+dwXf2PHVLT2jdxv+iSsGK+TYu8wrb0jqqhl
zwnzz99bnsCVv9pt4E3nheI9TXaMP6XKWyxAADbNbjIT9P+MfjL1ZuKg/UNZa1Wx
2HTpnyPEkw/4fOTWBLYeE45xNq1nJ0PK0tfJd5HQ/re8fHFfgGYr+UPIbt6V9gtV
10x7YCVY8qGouBwpMhuQNtfIp0RmmVNl58usoEUHlU7xLNNBaRKQVDFzQJHrGJho
b9aGxFVSrZDMkSYqrPfk3g0wFbEFI4O4djJVquNXK30lF5DH/MSa0LKBweREDfGw
mFSJkKTqYKsc3lL7aJsK/d5PCyK40RsCg0SUAyeE95RKcsBczpcpWuJlxJckZMc4
AfmKJncayayq9KGcMkvsLuxPE3sXtO4UXhumeSED4q2jryJjTxEfOTVTjEXUd6jC
A0X0z6qD1mO4NBQY2glN1wRT5Xa34QwSvzep/PsXcsN0PuXZO+e/qADO55MZwPlt
mz4DOOGXosHbWtPYAr5NffLidBVjgACfdKKW/rHEsADi3fps0B6J4w/POlCx0CpV
wWL6AvbKhEzivx4WpVquNfr+QaUFSXyZY/Yeof0CjIjTMbPNMazO55C8QJ5AvwjZ
NbcmI3TPLeIrVtcsL79f
=vrgx
-----END PGP SIGNATURE-----

--hxkXGo8AKqTJ+9QI--
