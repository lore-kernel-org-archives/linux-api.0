From: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/3] fbcon: use the cursor blink interval provided by
 vt
Date: Fri, 22 May 2015 13:49:58 +0200
Message-ID: <20150522114957.GF16507@ulmo>
References: <alpine.DEB.2.11.1503261354550.2411@local>
 <20150522020031.GA3516@kroah.com>
 <20150522100002.GB16507@ulmo>
 <3661627.JqpS87pBks@wuerfel>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8JPrznbw0YAQ/KXy"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3661627.JqpS87pBks@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Scot Doyle <lkml14-enLWO88E2pdl57MIdRCFDg@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tyler Baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Daniel Stone <daniel-rLtY4a/8tF1rovVCs/uTlw@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--8JPrznbw0YAQ/KXy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 22, 2015 at 12:33:42PM +0200, Arnd Bergmann wrote:
> On Friday 22 May 2015 12:00:03 Thierry Reding wrote:
> >=20
> > > Remember, if I have to hand-edit, or do something special with your
> > > patch, I will not do it, you need to do it correctly to make
> > > maintainer's lives easier, not harder, given that maintainers are the
> > > limited resouce, not developers.
> >=20
> > I understand. I'll make a mental note to never send you patches as
> > attachment again.
> >=20
>=20
> Better make that a general rule. My workflow is different from Greg's
> but also doesn't cope well with attachments. A lot of people in turn
> have problems quoting from an attachment when replying to the patch,
> which happens to work for me.

Okay. Any hints on how to simplify sending out such patches with the
same list of recipients? I find it very annoying to have to manually
copy each recipient into the git send-email command-line, but I don't
know of a better way to do it. Replying to an email from the MUA will
at least do that automatically.

Thierry

--8JPrznbw0YAQ/KXy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVXxflAAoJEN0jrNd/PrOhWzoQAJv/UI7tq5y7crlXaWLpHuwl
7z+SSaEKaa85682WzMxoPtXRobwQRNHu6UyU9SpmbYRLth9cBsrtXF43ihq1fz1V
cfhfgOzUirPjFPU8pzrLNGBwnEgzpuYTeUW0b3vOL6z+B9y1/5nYsHihssoXWUb3
NoaF4KsjZcyktIRUbSsSgWZglkF8LOpDLASq1PinozVSKeOBdxsP3ylMDvkWyQT2
kmYWtCR16UDkbLnn7NnPUholdXVW8aGK/pmYXPoQ0deB3hrtddbgwe9H6bWjMwX4
vkXkYw7+X5Zr6OGICtXN0u1DPsGsp4BHkEBFDbl/49x/EF6A8MB0kcEjUCetzzC4
dsFIY+Uwtk0rrwlQR7ebqx0p4O7cQI0eAK0h+DuRue3qAdqk3nZIKBmDTBohArg/
I+YDkOqcmxdvs39QOnyiwf2mfNHhbKxPth5sH7MEYeo2Er2LTVHe1Wk/KBqq6n9d
MRIl2KbmDadctYske7ake8vp6yro6KA3RDqluaPRnMCnu/itLS/7FOXy4nS34vEt
HHT3fc38sxwLIm4MfyLCk8xMWej1jXza+F03kPsl/p2wX85MsE5hrnpjghVFUtx+
isRwMZsxfnhg0C5ZSLlZiR/zixSvIpyZSlyLylOhLq205LBuhEUX1WoT09mk0cIO
6aBWkGSRhnbGgHKDZrzo
=7yuE
-----END PGP SIGNATURE-----

--8JPrznbw0YAQ/KXy--
