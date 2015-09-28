From: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 01/15] dt: power: bq24257-charger: Cover additional
 devices
Date: Mon, 28 Sep 2015 20:16:12 +0200
Message-ID: <20150928181611.GH3660@earth>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
 <1443196460-26156-2-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qVHblb/y9DPlgkHs"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443196460-26156-2-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--qVHblb/y9DPlgkHs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Fri, Sep 25, 2015 at 10:54:06AM -0500, Andreas Dannenberg wrote:
> Extend the bq24257 charger's device tree documentation to cover the
> bq24250 and bq24251 devices as well feature additions.
>
> [...]
>
> +- ti,current-limit: The maximum current to be drawn from the charger's input
> +    (in uA). If this property is not specified a USB D+/D- signal based charger
> +    type detection is used (if available) and the input limit current is set
> +    accordingly. If the D+/D- based detection is not available on a given device
> +    a default of 500,000 is used (=500mA).

I think this wording is a bit better:

- ti,current-limit: The maximum current to be drawn from the charger's input
    (in uA). If this property is not specified, the input limit current is
    set automatically using USB D+/D- signal based charger type detection.
    If the hardware does not support the D+/D- based detection, a default
    of 500,000 is used (=500mA) instead.

-- Sebastian

--qVHblb/y9DPlgkHs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWCYPpAAoJENju1/PIO/qaTDgP/i1IMAuOqLBe+m5slsMkRsPB
jciAT09Qo7381Hv69f8sofpHgMwSPA536y48yo/UHAb93lIng92SaMdmKt9GduqR
4a4FhGxRqg3LwA5vRbUQ+a0p6AWpqaDrLafyAwvLHR8nUXWZopziRfQMWYEmitYl
ion9vg15eSaXCC70YcmPfA3lQ53/wmtBAyhZRvjK44eqYXQn1zKrHdWye9/TAYFo
TyLHwoPAFn/oXockP0poLu9i93mGJLZNJmLG79tO/oOkxm+hC382x9RNvE9vbxai
DC3496/GnJqyY54JMSWPOIRfa0uMgVq2idxOe9FQGy514xaLnS4rjuQ1TmXmni8a
tgH08N1btZfpf+6Twp2l6f521Huyr69h0pxyzrz276IGFEgNG86mPgr087IwctQ6
08nMTickm5LZXF6HWycpabS5NzKdkr33Ar9raixyHkv7SVUafQ+cqb0TjMrr4NMT
k6ghn7S1wG8fnbaZkwwC5CJfidXj9GAKeV4bCSpiX3QamX22OgLfUUAfo/sVt3tM
rzPwq+LIqOwemWnFHiMw/enMA3oOFsbJR9xZCnaXH+fLvdlvX4fSi7lRSsm64qPb
mzQjWO8oAyMUXRDHnT/bK0df8JJQccs289aNeXHRmIHTfCTlKN735wJtOby1PrGQ
nLges2AySrach+QdATQC
=bZU1
-----END PGP SIGNATURE-----

--qVHblb/y9DPlgkHs--
