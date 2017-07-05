From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 16:47:47 +0100
Message-ID: <20170705154747.gtu6v5rrol2xrgbx@sirena.org.uk>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home>
 <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home>
 <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="km5cum4mgt3lypmc"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4080ecc7-1aa8-2940-f230-1b79d656cdb4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org
List-Id: linux-api@vger.kernel.org


--km5cum4mgt3lypmc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 05, 2017 at 09:09:51AM -0400, Carlos O'Donell wrote:

> This problem is a reflection of our own explicit or implicit priorities.
> The priorities of developers and reviewers needs to change to make an
> impact on the problem. This is a hard problem.

Take a look at the trajectory for the build and boot testing for a
concrete example of this - the failure rates go down over time but it's
not a quick process.

> As a concrete action item, glibc core developers took a harder stance on
> (a) all user-visible bugs need a bug # (forces people to think about the
> problem and file a coherent public bug about it) (b) all bugs needs a
> regression test if possible, (c) and if not possible we need to extend
> the testing framework to make it possible (we've started using kernel
> namespaces to create isolated test configurations).

One thing I'd really like to see here is an equivalent of the build and
boot testing we currently have that exercises some of the testsuites on
a regular basis so we can push on keeping them running cleanly.  As well
as just the intrisic value of the tests themselves I'd hope that a
visible practical interest would help push more activity in this area.

There's a couple of efforts I'm aware of in this area, hopefully one or
both of them will start delivering.

--km5cum4mgt3lypmc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlldCiIACgkQJNaLcl1U
h9B8CwgAgnnC5cB6fu+HQheb2rBEGKIFaDZ47QhL2u7WJ6xfcLG/zIBznZAVWmOm
e+7Mc4p/4gu1BdmYljt+4ihiBbj5RXUFkmJG70fqV6rlk+Ee5aRC5D/7g3C0QiUY
ByXSJzZvEhyELzrC/5FOm1ue/gtlq5CwaiQ5PZDQjcTmO2pNb3sfIi+SRvO/jgeE
famMPNmEp9Sk4eiewda71lmpOYwdEt4Ye1tzq+sf4Vu9931NcDN9tjqiQnbRLt20
bEidARUARMHOEjAx2aJsryCVq02/9Sd2WzYmeqzE0jJJpYh0Hx0DGWc4ACmPL4EF
Z0LbjBvk3HBrd/Wj7UE5gyDFC74a/w==
=mesX
-----END PGP SIGNATURE-----

--km5cum4mgt3lypmc--
