From: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/14] Enhance twl4030_charger functionality. - V2
Date: Fri, 24 Jul 2015 16:44:06 +0200
Message-ID: <20150724144406.GD27569@earth>
References: <20150322231635.23789.70149.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JwB53PgKC5A7+0Ej"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150322231635.23789.70149.stgit-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, GTA04 owners <gta04-owner-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org>, inux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--JwB53PgKC5A7+0Ej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Neil,

On Mon, Mar 23, 2015 at 10:20:28AM +1100, NeilBrown wrote:
> here is V2 of my patches to improve the twl4030 charger.
> They include improved documentation and removal of changes
> to the CVENAC bit which I didn't properly understand.

I rebased and queued patches 1 and 2. Can you rebase the
other patches and take care of the remaining comments?

-- Sebastian

--JwB53PgKC5A7+0Ej
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVsk82AAoJENju1/PIO/qaDwAP/2Eyx7ABCxW6wlmd1cLDb9bT
zqdN/dHDKirTb0bcYpM5FCDvv/UydHpfoiv8iAuiTGXztKcLkXF+Q7Tne+/LXq40
TDusJDMQSWBw2Fu6xnCdhFb5UG7gc5/v9u9HAc5/4pEABxIhgZ5vN0IV9EV8Cfcu
NIaRArKfOsTazO3unKyvwODOQcGj6YmNIPovCCXcNlw93MQmiIlI42fL08O8+1pm
m+Wrrm/G0YiGpj6TS+JL1wNg9Fl9RD14/KbFqwY6EPXYBNDueEHpkHjuCqTQJRa6
U/IR1MvM9kUz8Lsjfvroio+X78UPy+R5NyVIJlnntGoJ6G/vGiW8kUFhdygV0S//
AE3TSffaOhR+2/X3eps6AtNqmYtqLWyjho0fg+u8Z25rQVaul8/dxgqsUKxYePI9
IJJNd4jlPW9XeMtfC+76xWPqGr0YvoT0z9xp7S/4804wBjGM3jS5oGgxcMHfBd5v
O8PUlPpREAWqSGyn7wmcgLR1O7XXwb7lflyCYDBspa7bairccgMqqrDEVh93tRp9
HYNf75qSXutv7yU5Lpw3vpKQjZgUP+FfMoBQnbtaGvxa7sqq7hwTbCwtTk4QDFPE
JQafapja6F09eiVnPsFfnLO6NbsPaqcrrVFnD7s3AfgqOQ+e65eMiO1zWRUkmLQ1
JqG1shoeO5s37NsMhanL
=+/gr
-----END PGP SIGNATURE-----

--JwB53PgKC5A7+0Ej--
