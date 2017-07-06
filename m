From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Thu, 06 Jul 2017 07:48:05 -0700
Message-ID: <1499352485.2765.14.camel@HansenPartnership.com>
References: <20170703123025.7479702e@gandalf.local.home>
         <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
         <20170705084528.67499f8c@gandalf.local.home>
         <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
         <20170705092757.63dc2328@gandalf.local.home>
         <20170705140607.GA30187@kroah.com>
         <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net>
         <20170705112707.54d7f345@gandalf.local.home>
         <c782a15a-4e73-7373-ca66-5b55e9406059@roeck-us.net>
         <20170705130200.7c653f61@gandalf.local.home>
         <20170706092836.ifcnc2qqwufndhdl@sirena.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-2smHFfIwEV/LKJhyy71B"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170706092836.ifcnc2qqwufndhdl-GFdadSzt00ze9xe1eoZjHA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--=-2smHFfIwEV/LKJhyy71B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-07-06 at 10:28 +0100, Mark Brown wrote:
> On Wed, Jul 05, 2017 at 01:02:00PM -0400, Steven Rostedt wrote:
> >=20
> > Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org> wrote:
>=20
> >=20
> > >=20
> > > If a test to reproduce a problem exists, it might be more
> > > beneficial to suggest to the patch submitter that it would be
> > > great if that test would be submitted as unit test instead of
> > > shaming that person for not doing so. Acknowledging and
> > > praising kselftest submissions might help more than shaming for
> > > non-submissions.
>=20
> >=20
> > >=20
> > > My concern would be that once the shaming starts, it won't stop.
>=20
> >=20
> > I think this is a communication issue. My word for "shaming" was to
> > call out a developer for not submitting a test. It wasn't about
> > making fun of them, or anything like that. I was only making a
> > point about how to teach people that they need to be more aware of
> > the testing infrastructure. Not about actually demeaning people.
>=20
> I think before anything like that is viable we need to show a
> concerted and visible interest in actually running the tests we
> already have and paying attention to the results - if people can see
> that they're just checking a checkbox that will often result in low
> quality tests which can do more harm than good.

it depends what you mean by "we". =C2=A0I used to run a battery of tests
over every SCSI commit. =C2=A0It was time consuming and slowed down the
process, plus it was me who always got to diagnose failures. =C2=A0Nowadays
I don't bother: I rely on 0day to run its usual tests plus a couple of
extras I asked for it's a much more streamlined process (meaning less
work for me) and everyone is happy.

The corollary I take away from this is that the less intrusive the test
infrastructure is (at least to my process) the happier I am. =C2=A0The 0day
quantum leap for me was going from testing my tree and telling me of
problems after I've added the patch to testing patches posted to the
mailing list, which tells me of problems *before* the commit gets added
to the tree.

James

--=-2smHFfIwEV/LKJhyy71B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJZXk2pAAoJEAVr7HOZEZN4wB8P/j/H4/3FovOkSenV3F0+DC8t
7XA5MdfuaoJv/e9Ft+P9lc6lNl39WEX/wArYccRn2JLClISQ78uMIqvaRndjze75
sVWjx55PJ+pK1TiDbN39R5Sk/I6GELkIfeY7Wm/cjcrDLoDWmmB1HQTy/8WPXQ49
2FxX7Wut/9DTi+E0Yx2E+8AYJ+hEsYwTDdOsGe09LF4E5uiCF0AmLqwrwIG76Wq4
oLIku4tAzk3ijAJ+OvfGDQpFaVKD5TZqpZc718cS3CB/8I7tNNWI2AX/8JCrrV1D
ZuTBaPtOZwRS1WrFt7T/Gg+JmGLY82bAKjeCU/yZM47VvxaOOgHn35M0kxGp9Xki
kMKKh1AdPEHg1vgGUkUU7DX2SgVq1XRnyMN6VCNhdD9YY58n9aZfccp3/z0YdtVo
dFgt0oEt+R6GXLrPQSnZ1xE4/DvK0nHo7JVNcdcRNLmRkR2CJA1kQCmpvqKEcfVl
fd/k5TK2X1vwtmL+SIsSUm0eCwVJQdCBpY/BUtX3zS8T0bdHl4xA/FbZ0APZ+adc
PT+RmXY/u84J066IacaIqGhw8cxrF1LraczcKMjPTxDw053NWnhC/w3Ey9HasNue
l/oLA39Glon79bltrnlZFFxJ/Utowob6Mj52eXeX1v3IkjVwCOSVpfD8Kwr6aqdT
CADjZ3e9eq2Y+v87HmwV
=d5aR
-----END PGP SIGNATURE-----

--=-2smHFfIwEV/LKJhyy71B--
