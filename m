From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Tue, 31 Oct 2017 19:11:53 +0000
Message-ID: <20171031191153.avolosp6n5gb3xao@sirena.co.uk>
References: <1508774137-13835-1-git-send-email-benjamin.gaignard@linaro.org>
 <1508774137-13835-3-git-send-email-benjamin.gaignard@linaro.org>
 <3e3af8e3-76c5-754c-caaa-3f8c9b54723f@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="urv4p3ijuufslxfd"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3e3af8e3-76c5-754c-caaa-3f8c9b54723f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, riandrews-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--urv4p3ijuufslxfd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 31, 2017 at 12:03:35PM -0700, Laura Abbott wrote:

> I'm not a fan of the platform bus but I have mixed feelings about
> creating a dedicated bus type. I guess if we really need a bus
> type we can do it later?

There was a discussion a while ago in the context of I2C/SPI MFDs
which concluded that if you need a bus and it's going to be effectively
noop then you should just use the platform bus as anything else will
consist almost entirely of cut'n'paste from the platform bus with some
light sed usage and code duplication is bad.  It's not super lovely as
it's not actually a memory mapped device but it's the best idea we've
got.

--urv4p3ijuufslxfd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAln4yvgACgkQJNaLcl1U
h9BbYQf/fEm+83xolZZH4dSgmBlEqJJFu1gk8BLP1sIS2+QCIHevPri/EYkgENnZ
5LvqDM9XNAHh3D0pot00cSuW8vT1uSgaTT2/v0cWcpvdD6/fZd9RIX8btSc6Mjt9
qf/0/xosu2ghgpbPsPv2TTt+7E3+kYxjlHThhGdLt3bx9+wlKlJvj8wahjcC74Vt
EUlXBBipUur4KDGuWjgXR7lu4e+K7elurB+ICiL1BQ0UhxgDbrzUtEh1JjjyHyne
NlvGfQQsWLPkjHLxDwBKxnCIzoopOdTcZQFK0QuB7qH3fpf8vpJKprsLeQ6sufmY
HHT07JRMJfDLBGnXwSQoPwVBG59cHg==
=yWmQ
-----END PGP SIGNATURE-----

--urv4p3ijuufslxfd--
