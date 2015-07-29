From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 01/11] stm class: Introduce an abstraction for System
 Trace Module devices
Date: Wed, 29 Jul 2015 14:35:29 +0100
Message-ID: <20150729133529.GI20130@sirena.org.uk>
References: <1436177344-16751-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1436177344-16751-2-git-send-email-alexander.shishkin@linux.intel.com>
 <CAAfSe-vOgnMXCy6fb8yuQ0O_5x1L1QtCmGjNjH+OtGAg6KJHrg@mail.gmail.com>
 <877fpjkseh.fsf@ashishki-desk.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gJNQRAHI5jiYqw2y"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <877fpjkseh.fsf-qxRn5AmX6ZD9BXuAQUXR0fooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Chunyan Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--gJNQRAHI5jiYqw2y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 29, 2015 at 04:25:10PM +0300, Alexander Shishkin wrote:

> There has to be a way to defer stm_probe(), although a quick look at
> amba code suggests it's not implemented.

What makes you say this?  Probe deferral is implemented in the driver
core rather than individual buses, the buses don't need to know anything
about it.

--gJNQRAHI5jiYqw2y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVuNagAAoJECTWi3JdVIfQw0sH/3ad8iDSPkZnRFkbIjZeK/VN
eL1svk9aStmJSNmpQSkzN7CNMqyzg4PWnA3xF8LC1+3CbeGV3klBdCqhxHJrVHJF
QxF9cLtdg0nboavoguA4lT4HIgJ6EQNp32n6dFvXom3az2wvu628AyLh+sIxBCk1
b0+svoQ7HMtv8tiGyWJJBNKCnwfC2fq5F3FBX18LkUuEX5/dRWU0G3mW0QqdpeIC
tFrOCL1zUbkn+oBi/sP86JGBvJTwUThi4ZRMI9Jame0hZnFqAWbuAFE3wZl3fbLf
hd4YLUb/rUswkINoUe6MDqtOfzd+VOdNdTNpxlIs7AJSp0ONxAhHCrCDBp4OvJk=
=2a6D
-----END PGP SIGNATURE-----

--gJNQRAHI5jiYqw2y--
