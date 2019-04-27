From: Lukasz Majewski <lukma@denx.de>
Subject: Re: [PATCH 1/2] y2038: make CONFIG_64BIT_TIME unconditional
Date: Sat, 27 Apr 2019 17:06:13 +0200
Message-ID: <20190427170613.38bdfbbd@jawa>
References: <20190426142531.1378357-1-arnd@arndb.de>
        <20190427004653.3cecd1cb@jawa>
        <20190427095418.344yoomf5nwznatd@sghpc.golosunov.pp.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/NtOXQs_YE8e+5oiZUS+hS8k"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190427095418.344yoomf5nwznatd@sghpc.golosunov.pp.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Stepan Golosunov <stepan@golosunov.pp.ru>
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Joseph Myers <joseph@codesourcery.com>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>
List-Id: linux-api@vger.kernel.org

--Sig_/NtOXQs_YE8e+5oiZUS+hS8k
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Stepan,

> 27.04.2019 =D0=B2 00:46:53 +0200 Lukasz Majewski =D0=BD=D0=B0=D0=BF=D0=B8=
=D1=81=D0=B0=D0=BB:
> > Hi Arnd,
> >  =20
> > > As Stepan Golosunov points out, we made a small mistake in the
> > > get_timespec64() function in the kernel. It was originally added
> > > under the assumption that CONFIG_64BIT_TIME would get enabled on
> > > all 32-bit and 64-bit architectures, but when I did the
> > > conversion, I only turned it on for 32-bit ones.
> > >=20
> > > The effect is that the get_timespec64() function never clears the
> > > upper half of the tv_nsec field for 32-bit tasks in compat mode.
> > > Clearing this is required for POSIX compliant behavior of
> > > functions that pass a 'timespec' structure with a 64-bit tv_sec
> > > and a 32-bit tv_nsec, plus uninitialized padding. =20
>=20
> > At least for my setup (32bit ARM with 64 bit time support) this
> > patch is not fixing anything. =20
>=20
> The patch is not supposed to fix anything on 32-bit architectures as
> in-kernel struct timespec64 has 32-bit tv_nsec there.  Thus truncation
> should happen automatically.  I also missed that fact when I was
> reading get_timespec64 code.

Yes. You are right. The tv_nsec is 32 bit.

>=20
> (I am wondering whether such trucation is undefined behaviour in C

According to [1] - Chapter 6.3.1.3 - Point 3 it is
implementation-defined.

> and
> whether there should be sign-extension instead of zeroing-out for the
> in_compat_syscall() case though.)

What I've found is that "typically" the high order bits are discarded.

However, it is still "implementation dependent".

>=20
> > > The easiest fix for linux-5.1 is to just make the Kconfig symbol
> > > unconditional, as it was originally intended. As a follow-up,
> > > we should remove any #ifdef CONFIG_64BIT_TIME completely.
> > >=20
> > > Link:
> > > https://lore.kernel.org/lkml/20190422090710.bmxdhhankurhafxq@sghpc.go=
losunov.pp.ru/
> > > Cc: Lukasz Majewski <lukma@denx.de> Cc: Stepan Golosunov
> > > <stepan@golosunov.pp.ru> Signed-off-by: Arnd Bergmann
> > > <arnd@arndb.de> ---
> > > Please apply this one as a bugfix for 5.1
> > > ---
> > >  arch/Kconfig | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/arch/Kconfig b/arch/Kconfig
> > > index 33687dddd86a..9092e0ffe4d3 100644
> > > --- a/arch/Kconfig
> > > +++ b/arch/Kconfig
> > > @@ -764,7 +764,7 @@ config COMPAT_OLD_SIGACTION
> > >  	bool
> > > =20
> > >  config 64BIT_TIME
> > > -	def_bool ARCH_HAS_64BIT_TIME
> > > +	def_bool y
> > >  	help
> > >  	  This should be selected by all architectures that need
> > > to support new system calls with a 64-bit time_t. This is
> > > relevant on all 32-bit =20

Note:

[1] - http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/NtOXQs_YE8e+5oiZUS+hS8k
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAlzEb+UACgkQAR8vZIA0
zr2z8gf/Q3cd7NEt3lba9R3Jd4WtSGipupTihng+hzrCulnMN0bI9yi5uaIeHdUM
XU07EttxLTCyC1lI+AUCZq2pfds70EcWk4iLDlc8AYFoP7ANhidEIz6IMoDi2kRi
UoiCm9PR1HNZyhOgoeJ2CHKhCfcnNii7q9HLdmQss7hwNVPWlrPl62iTDztliy5m
CqVNYJT8ATPUxOPveaIZ8STf+bToip/xN6AwrHZLgXYZBeoDHRaJkOC4eI6tgrei
n8AWhiFFcTmGHkDQXPpcPVYHOthdQeIupW0afQAArtUDjr/vMINbRakLhkqFcFH6
eZ5TxS6lj+RT/ZkqtY08HY7GyjWhgg==
=XsUp
-----END PGP SIGNATURE-----

--Sig_/NtOXQs_YE8e+5oiZUS+hS8k--
