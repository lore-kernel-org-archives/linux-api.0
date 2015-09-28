From: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 14/15] power: bq24257: Add platform data based
 initialization
Date: Mon, 28 Sep 2015 19:58:12 +0200
Message-ID: <20150928175811.GG3660@earth>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
 <1443196460-26156-15-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="I3tAPq1Rm2pUxvsp"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443196460-26156-15-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--I3tAPq1Rm2pUxvsp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 25, 2015 at 10:54:19AM -0500, Andreas Dannenberg wrote:
> The patch adds a way to setup and initialize the device through the use
> of platform data with configuration options equivalent to when using
> device firmware (DT or ACPI) for systems where this is not available.

Which board is this btw? Looks like most arm board code is going
away in the next few kernel releases, so I wonder if this patch
will just increase maintainence without any proper user.

> Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
> ---
>  drivers/power/bq24257_charger.c       | 39 +++++++++++++++++++++++++++++=
++++--
>  include/linux/power/bq24257_charger.h | 25 ++++++++++++++++++++++
>  2 files changed, 62 insertions(+), 2 deletions(-)
>  create mode 100644 include/linux/power/bq24257_charger.h
>=20
> diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_char=
ger.c
> index 19a0962..3b1a3b6 100644
> --- a/drivers/power/bq24257_charger.c
> +++ b/drivers/power/bq24257_charger.c
> @@ -27,10 +27,13 @@
>  #include <linux/gpio/consumer.h>
>  #include <linux/interrupt.h>
>  #include <linux/delay.h>
> +#include <linux/gpio.h>

You can drop this include. It's not needed with gpiod_*().

-- Sebastian

--I3tAPq1Rm2pUxvsp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWCX+wAAoJENju1/PIO/qaiToQAJ+Zi2x4A6pECjdfQbVA7Pfu
SAgyuV8ELRSs4C+xFgrc6UOadLyJyknM09cDDyhnEy4dIUK626jiE6AxSH3OQZPM
wJT4nYF/q7IjiO5BWIb3lcVOqppXTtW9e/lisMmDvNTmQuXaRGSAXZULcSctHzXG
4YU33vNofKOH7FmJc3Q5JzCGzX3AWanputgqmrDhDUNi+EYxRxv6PE9DN59T0eX4
SiP/eUlGUzCy3SBjoiB9hBj6ziz/cU41R8yF36nrpO+pZpSfCEJ+bTme/GTitH/4
bLWkrBD9vqekfidtukJohzGH5Z6bt6nfn55wTPjTKkzHwVWsfDNZDCP6GZ9GbL3j
RmInaRH5GZaVISQhBbaukYdsAK9W4QkGgtqWytPJEW72lBZRhwAyJ3QWpvURAVcA
YebN+XBmqd/Cjio0sdlxYMBPQteYwJmji56JfTIqZX3IP4xcBYhESYbQIY9yJO++
kwyZpxVzMhBrABjQ855diBzFaNm3pqDhnBAJL18F4MweZZV3XPlcbAqLAA10OXGN
NIYXi1Tw67Zk1D6805r+4AqEOdf+/OG49IAxrE1641lEEU19RV55DNXnhQp21W8b
FuyjRLCFgtPVPO/cJaxuWdoIWCOnVIcnFGyVp3MPaYsH9zVZNUlonRXCvqZSpUu9
PTPrnta1wDw6vlxrdJwj
=nqN4
-----END PGP SIGNATURE-----

--I3tAPq1Rm2pUxvsp--
