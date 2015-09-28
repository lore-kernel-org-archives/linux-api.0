From: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 03/15] power: bq24257: Streamline input current limit
 setup
Date: Mon, 28 Sep 2015 18:53:38 +0200
Message-ID: <20150928165337.GE3660@earth>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
 <1443196460-26156-4-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EXKGNeO8l0xGFBjy"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443196460-26156-4-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--EXKGNeO8l0xGFBjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 25, 2015 at 10:54:08AM -0500, Andreas Dannenberg wrote:
> The maximum amount of input current the charger should draw is dependent
> on the power supply and should only be (re-)configured when the power
> supply gets connected and disconnected. However the driver was also
> lowering the bq24257's input current limit setting to 500mA when the
> battery was removed and restored the previous setting according to the
> power supply capabilities when the battery was reconnected although
> these events are not impacting the amount of power that can be drawn
> from the supply. Furthermore, a re-configuration of the input current
> limit to 500mA when the battery gets disconnected is actually dangerous
> if the limit was set higher previously and the system draws more than
> 500mA in which case the system voltage would be reduced in order to
> maintain 500mA which could result in the system getting too low of a
> supply to maintain operation. Last but not least the mechanism itself
> used for battery re-connection detection did not work in corner cases
> such as when the device's input current loop becomes active and the
> bq24257 device clears its battery fault error resulting in incorrectly
> reporting that the battery got reconnected.
>=20
> This patches removes the impact the battery removal/insertion has on the
> input current limit configured for the bq24257 and simplifies the
> associated handler routine.
>=20
> Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>

Thanks, queued.

-- Sebastian

--EXKGNeO8l0xGFBjy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWCXCOAAoJENju1/PIO/qaU1oP/iinOdqOdlnfZZdAoUWoKqh6
GsMN+h2Q414V+TCuFArg1GfmLdnPGJN4BqPQtbAAPYn8z0m5OE3RzBnkjcRLFR4e
NU6EYmxoPf1BRBiDVV1d6jV7txeVPnOFaVuPvmbGJv64ywa5EoKe/08/ZZV8wXtl
pG7kILDeKvlRC6i5J/UtyeMH95ZmLVLyejHXJr+8CrJC7U0g5zcKUmg73VV5w0vm
vZM69sprZ9X6kVZzOkFoNpeJJGAd+wThzCOGK2Xr+Ggw7TZvEOsKVsgilBpw2A3o
v2sZ72r4Xdj9OALDQecbrHmmm7LYsGcF+o0K2MyoKQYRWIpfgBRtPC31Qz29ADV5
O0FC5KkdyJjEB8nmesmEy6Jf1PVOIxFNnw5OQcpFsmXikA018o5TB80SF8iQby7y
0Zpqc49LXlJ/frfApJwSXqZZjW5NvZlK3R58D5i+o3+lQSORTwyo1I6S9N91c39h
I8PgDwDjOQ/UR9J6DQx+qQh4zofDm02YETLvrqTKO4HJsYmGz+mgNwc99DOYrcaW
h5sMLjKRSnfBoegbu5JxUMR3Tk+2rCfy1VBRZ/5ZHH0Fj4yUOYFglhi8z0aa/joU
8EBmoywwIcAQoz2uodSasI3vKtApb5lWIF1bRhaMXIfNdcFIJX18Oo6/f01PCGEU
zYOzv0SAoUMRAjjEpJa/
=SbCD
-----END PGP SIGNATURE-----

--EXKGNeO8l0xGFBjy--
