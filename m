From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 15:52:20 +0100
Message-ID: <20170705145220.5u3qpxs45sbbpzpx@sirena.org.uk>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home>
 <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home>
 <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home>
 <20170705140607.GA30187@kroah.com>
 <20170705103335.0cbd9984@gandalf.local.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="a3t5jrkhyxb7pr6h"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170705103335.0cbd9984-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--a3t5jrkhyxb7pr6h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 05, 2017 at 10:33:35AM -0400, Steven Rostedt wrote:

> That is, Thorsten this is more for you, how much real regressions are in
> hardware? A bug that's been there forever is not a regression. It's a
> feature ;-)  A regression is something that use to work and now does
> not. Is that number still as high with hardware? Those probably could
> be where tests can be focused on.

A relatively common case IME is things that were always bugs but depend
on some external thing to become visible, like someone trying to use a
device in a slightly different way, doing more detailed testing of some
kind or some subsystem change.

--a3t5jrkhyxb7pr6h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAllc/SQACgkQJNaLcl1U
h9DDKAf+IROjxxFTVkAZxbs8ff5gq9x9iYzNIluUBjgp/JEXQvsiIQhZgp2wtlTf
2k+FvNncfPCbQzqie7TBUj2jEOKJHfLsf8LgINPzhZxEHZZlFO1ltNXG7tbQ26JW
fFH1bVL0FNeU82VdP7ibVHOGZPvRCLubVzaAYv5ucNikw8elapdGnl18eXFDWfvo
7TuAziUM1eRiK+6jgewCEZunSzBqIel4QSPfTrE0yGbaz6tykIHwdNixX7A/sbBZ
OHXaOEfrO7+bkDYpprtQMSsh/w14U7l9+UWoCPfLDwmg5ixTxBA8bSsAeR9iSOCE
JFdEZ2CRvxyYPhsS0aL+8WJJ7tjwSw==
=N3HG
-----END PGP SIGNATURE-----

--a3t5jrkhyxb7pr6h--
