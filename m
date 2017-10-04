From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 2/2] staging: ion: create one device entry per heap
Date: Wed, 4 Oct 2017 11:17:20 +0100
Message-ID: <20171004101720.ob5f467tro7agpcz@sirena.co.uk>
References: <1506518409-16887-1-git-send-email-benjamin.gaignard@linaro.org>
 <1506518409-16887-3-git-send-email-benjamin.gaignard@linaro.org>
 <2e15edc2-a17f-3930-7d5b-4b5b7d2e0a4d@redhat.com>
 <20171003164849.rcdgez6lbpmq5llt@sirena.org.uk>
 <2417c969-357f-d5d9-153a-2180d09b0dc6@redhat.com>
 <20171003230830.GA132839@sspatil-desktop.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="exh2ffqqp2s7yg46"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171003230830.GA132839-MgWQydg8T0mvj1b/ULB3ZwqCisvMvsWYTsK6IJ4gZTFBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sandeep Patil <sspatil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, riandrews-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--exh2ffqqp2s7yg46
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 03, 2017 at 04:08:30PM -0700, Sandeep Patil wrote:

> It is entirely possible and easy in android/ueventd to create those nodes
> under "/dev/ion/".  (assuming the heap 'subsystem' for these new devices will
> point to 'ion').

The reason I didn't say /dev/ion/foo initially is that if people want to
keep the existing /dev/ion around for compatibility reasons then the
/dev/ion name isn't available which might cause issues.  Otherwise just
dumping everything under a directory (perhaps with a different name) was
my first thought as well.

> (Also FWIW, the SELinux permissions are also possible with the current ion
> implementation by adding rules to disallow specific ioctls instead of adding
> permissions to access device node as this change would do)

AIUI the request is to limit access to specific heaps, and obviously not
everyone wants to deal with SELinux at all.

--exh2ffqqp2s7yg46
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlnUtS8ACgkQJNaLcl1U
h9CgIQf/Y1PSlNGnz7Bx3jLxyK9RIsm7WLjJIpRvt9AOqr1OawEQCj08kCtIli7A
sjaM9f/v2xozvoszlVABBqnwVlFcq3LWoxkCCN0Uzph2wwzlWvEIQOc1aqa72oyu
YJ6S5w4faqcXbWlGcz30wZwMjMrKRL/jbKsGB60I1P0IH76CDafbFzssqBt9EZLW
CwjSZNC6KMZ/PiGJHowtYFEQcSAyPGBDqWff/0L37/WhCkQqcSRAaxrI090o0lmD
MIOcA2iq4yDDDkh0YRhabqhD4PT84AsQr6deYzogHvggzMJMqMaY7RrR6EPlAy5o
9D/X6EXvBP46f3NZlOhkpn49YtrNTg==
=gJ2L
-----END PGP SIGNATURE-----

--exh2ffqqp2s7yg46--
