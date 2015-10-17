From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] glibc: Remove CPU set size checking from affinity
 functions [BZ #19143]
Date: Sat, 17 Oct 2015 11:38:27 -0400
Message-ID: <20151017153827.GN28215@vapier.lan>
References: <5621126E.5080801@redhat.com>
 <20151017031003.GE28215@vapier.lan>
 <87io66kpux.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mkHYMT4O8DyWoHkb"
Return-path: <libc-alpha-return-64224-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <87io66kpux.fsf@mid.deneb.enyo.de>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: GNU C Library <libc-alpha@sourceware.org>, cgroups@vger.kernel.org, kosaki.motohiro@gmail.com, Linux API <linux-api@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
List-Id: linux-api@vger.kernel.org


--mkHYMT4O8DyWoHkb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17 Oct 2015 07:48, Florian Weimer wrote:
> * Mike Frysinger:
> > abort writes to stderr.
>=20
> I don't think so, =E2=80=9CAborted=E2=80=9D is printed by the shell.

err, i was thinking of assert.  nm me ;).
-mike

--mkHYMT4O8DyWoHkb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWImtzAAoJEEFjO5/oN/WBwwkQAKdsb4JOPw9J+DUftdebMSIB
cZIzDoyTY7ImAPgaYkETGlMnUcIJeHKcqxz/QK9LG0veqXJS9vcZRX8MKym4MB3d
HZ07cLhYF+0KIzSt1wYwWEq5+PNPiZHifTpz1gxkeKsjHXiD9XG61I1JPbakN/Tu
lXUV8zz6M6IMZs4XYlbtxshcz8lNCC+zWBOr283Wr4hYOZ/95PfaKhLOfHv2FMgE
qNe31KRQ0bIFn80BxKI+h5p+2iEkig1quScbP86dv8lHSYIhqOi5f4/2xihrgWer
Ehxxjs8hXz3BUEAvatD7xPJKB/Tu7RRsWC6dHAQSw+FnOvtKsroOyppQ6HHQbHgy
BGgw+CmDCLA73FmO+5A6GcmJu969NwyBtMl8TivGVZ3K98WrXRb7mMEkdQ0HQ+ex
GL0plcD2Z0lUa1t6jV9gNh4g9fLm7AkLQ4lbsEvU3Xf8ym54EVFDUEkb/FPVWXKn
R3GFrWb9UMcWnAbpOE91iTODLD6FcJ/BEyoKUc5kfBjazbd8amfPVPAEFacEr2fH
LspOs3NeiLhzdGsV8u0Qrs/ujshzanqRawmc4u1iJlAj3TUp1tC+T6ODzDu+Jda6
TCNHZEDW0XlwK2En/q9AzJsh/+iw0ndeMLjReiPm2Kf8sUB3XnpPIBZeBqQ6ErL7
8lZ0+NoqmiWFHxv2Y4se
=E9u+
-----END PGP SIGNATURE-----

--mkHYMT4O8DyWoHkb--
