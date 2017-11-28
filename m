From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Tue, 28 Nov 2017 16:26:20 +0000
Message-ID: <20171128162620.levmpcgaixilwq3n@sirena.org.uk>
References: <1509983985-20950-1-git-send-email-benjamin.gaignard@linaro.org>
 <1509983985-20950-3-git-send-email-benjamin.gaignard@linaro.org>
 <20171128133217.GA29995@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4ymeqh6frfbjbna7"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171128133217.GA29995-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, riandrews-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--4ymeqh6frfbjbna7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 28, 2017 at 02:32:17PM +0100, Greg KH wrote:

> Where is the documentation for the new sysfs files and the new ioctl

Didn't see any sysfs files in there?

> call you added?  What did you do to test this out?  Where are the AOSP
> patches to use this?  Happen to have a VTS test for it?

Do we need to convert Android for this to be accepted?  The single
device is being kept around for it and the use case was from non-Android
users wasn't it?

--4ymeqh6frfbjbna7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlodjiwACgkQJNaLcl1U
h9AXCgf/ZDKANJ8CKPNiJo90cxLnLuA5wCkNst7MoBklEXDpbg2+3jZJS4fB9mvH
eYl0NjnFPLcwbjfD4MtXCYtPP6K/2vatjxZOaWNz9/jO8rn1Annw526K2ILlnEEA
QCilyhGFq/jkGnpihOzeBH3cVpGAQf8LvUEZL+Zf37H5zegdh5/d1WrecB5HZqE3
+gH9M6MampCBqWEXVVbMu8Ke8nlibavM4QDuHyeOTOHUhyoYw9RCzMz9LF8nOZGX
F9VUr94lp0L+uWJlikJlHE6Lqe1xJ8BKFJ6csnHp74o4wOVxc8TVwulQDF2rI2WV
ayOcUET4jfBlK8wGwEjnImNQEym+Ng==
=Dvf7
-----END PGP SIGNATURE-----

--4ymeqh6frfbjbna7--
