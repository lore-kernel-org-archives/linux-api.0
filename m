From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 15:33:41 +0100
Message-ID: <20170705143341.oees22k2snhtmkxo@sirena.org.uk>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home>
 <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home>
 <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home>
 <20170705140607.GA30187@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q6le5hl6g3lkr77a"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170705140607.GA30187-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--q6le5hl6g3lkr77a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 05, 2017 at 04:06:07PM +0200, Greg KH wrote:

> I don't mean to poo-poo the idea, but please realize that around 75% of
> the kernel is hardware/arch support, so that means that 75% of the
> changes/fixes deal with hardware things (yes, change is in direct
> correlation to size of the codebase in the tree, strange but true).

Then add in all the fixes for concurrency/locking issues and so on
that're hard to reliably reproduce as well...

--q6le5hl6g3lkr77a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAllc+MQACgkQJNaLcl1U
h9BLnwf+Lo4LU25hXUY+PtHfu7wv1X2LqldLncDv2RU+ZAKB/nbxHd1PZX4XuCBk
2KZ+3qyJVDpBZHY9JdqqqZ7sCkSAe9rHfLLc6dmERVlMHyLjCZCCBhT2UX2Gs17j
7DQBiknmvnGws3YavJxvA+0NoqgQRwCBQ0jsWznb1jis4qHcw7zi+UBlsQ25RqbQ
qnsjtk583EOo1Xjfuhx1OmYqndkkmill0dwBe/xOFEBwY1WuX7kD4HChqix4S8ud
+Ks9rQcZDdRbyhzu5yLoicNm7teFeNPac7A4R/wDGSQmxIx8aW/FTkxLmKXn2hb/
2IK0q49bGxMvorK64No8Y6GJoMrUfQ==
=uPYx
-----END PGP SIGNATURE-----

--q6le5hl6g3lkr77a--
