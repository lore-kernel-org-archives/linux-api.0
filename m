From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Fri, 7 Jul 2017 11:03:40 +0100
Message-ID: <20170707100340.kgks5aykbnwtc6om@sirena.org.uk>
References: <20170705084528.67499f8c@gandalf.local.home>
 <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home>
 <20170705140607.GA30187@kroah.com>
 <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net>
 <20170705112707.54d7f345@gandalf.local.home>
 <c782a15a-4e73-7373-ca66-5b55e9406059@roeck-us.net>
 <20170705130200.7c653f61@gandalf.local.home>
 <20170706092836.ifcnc2qqwufndhdl@sirena.org.uk>
 <1499352485.2765.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="attlk64ykvabgczj"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499352485.2765.14.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--attlk64ykvabgczj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 06, 2017 at 07:48:05AM -0700, James Bottomley wrote:
> On Thu, 2017-07-06 at 10:28 +0100, Mark Brown wrote:

> > I think before anything like that is viable we need to show a
> > concerted and visible interest in actually running the tests we
> > already have and paying attention to the results - if people can see
> > that they're just checking a checkbox that will often result in low
> > quality tests which can do more harm than good.

> it depends what you mean by "we". =A0I used to run a battery of tests
> over every SCSI commit. =A0It was time consuming and slowed down the

We as a community, I think something viable needs to be central services
like kernelci that's automated and allows multiple people to be involved
with the analysis.  Hand running tests at scale just doesn't.

> The corollary I take away from this is that the less intrusive the test
> infrastructure is (at least to my process) the happier I am. =A0The 0day
> quantum leap for me was going from testing my tree and telling me of
> problems after I've added the patch to testing patches posted to the
> mailing list, which tells me of problems *before* the commit gets added
> to the tree.

I think we'd get a long way just by looking at what's ending up in -next
- it's not as good as detecting things before they go in but it's
workable if people keep on top of things.

--attlk64ykvabgczj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAllfXHsACgkQJNaLcl1U
h9CIagf/We9o3cz3RguWNDRdF+cqAUlVet+sULv+7LpwQmvBbeKkLKFgXwd8iRN6
nNSE6FQxjg7NkhkrGvuRCZAmF+u2gx/IhMNpCwSsYltH3oecP0yfzCvU5IXev3R5
slIgKIglkMBVpKKpe2db+JaKKrXxfKZLtkTA2q8NACzHDrtBniW/ixIVnS5mK2CC
y1XH3weBDJWYn+An35e9OKmYgsA4OKae+tuKpRtvdbP9Y1rQkOC4geLse2+95ZX9
u4Hh8pcIXiyJC6IddgaI+zuqAnptdPm9jlVGh5AUGAwPMouZ2uIN/edpovcUuhyV
0aCB5BZP9I4hYWxwKHGyqvcYh1OYxQ==
=JrOG
-----END PGP SIGNATURE-----

--attlk64ykvabgczj--
