From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v4 04/10] eeprom: Add a simple EEPROM framework for
 eeprom consumers
Date: Fri, 10 Apr 2015 13:45:50 +0200
Message-ID: <20150410114550.GR26727@lukather>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1427752670-17219-1-git-send-email-srinivas.kandagatla@linaro.org>
 <20150407184533.GA10278@codeaurora.org>
 <55243982.7020907@linaro.org>
 <20150409144522.GB9663@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="foM9DbudB2CcldhH"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150409144522.GB9663@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de
List-Id: linux-api@vger.kernel.org


--foM9DbudB2CcldhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Thu, Apr 09, 2015 at 07:45:22AM -0700, Stephen Boyd wrote:
> > eeprom block array is just another way intended to get hold of
> > eeprom content for non-DT providers/consumers, but DT
> > consumers/providers can also use it. As of today SOC/mach level code
> > could use it as well.
> >=20
> > In eeprom_cell_get() case the lookup of provider is done based on
> > provider name, this provider name is generally supplied by all the
> > providers (both DT/non DT).
> >=20
> > for example in qfprom case,
> > provider is registered from DT with eeprom config containing a unique n=
ame:
> > static struct eeprom_config econfig =3D {
> > 	.name =3D "qfprom",
> > 	.id =3D 0,
> > };
> >=20
> > In the consumer case, the tsens driver could do some like in non DT way:
> >=20
> > 	struct eeprom_block blocks[4] =3D{
> > 		{
> > 		.offset =3D 0x404,
> > 		.count =3D 0x4,
> > 		},
> > 		{
> > 		.offset =3D 0x408,
> > 		.count =3D 0x4,
> > 		},
> > 		{
> > 		.offset =3D 0x40c,
> > 		.count =3D 0x4,
> > 		},
> > 		{
> > 		.offset =3D 0x410,
> > 		.count =3D 0x4,
> > 		},
> > 	};
> > 	calib_cell =3D eeprom_cell_get("qfprom0", blocks, 4);
> >=20
> >=20
> > Or in DT way
> > calib_cell  =3D of_eeprom_cell_get(np, "calib");
> >=20
>=20
> Ok. I guess I was hoping for a more device centric approach like
> we have for clks/regulators/etc. That way a driver doesn't need
> to know it's using DT or not to figure out which API to call.
> Also the global namespace is sort of worrying (qfprom0 part). How
> do we know it's qfprom0? What if it's qfprom1 sometimes?

Through platform_data?

Or maybe that could be done using a function that would attach a cell
to a struct device?

I'm not sure that would cover all cases though.

> Also, how are we supposed to encode certain bits inside the
> stream of bytes (blocks)? In some situations (e.g. the qcom CPR
> stuff) we have quite a few fuse bits we need to read that are
> packed into different bytes and may cross byte boundaries (i.e.
> bits 6 to 10 of a 32-bit word). The current API looks to be byte
> focused when I have bit based/non-byte aligned data.
>=20
> My current feeling is that I don't want to use any of the block
> stuff at all. I just want a simple byte-based API that allows me
> to read a number of contiguous bytes from the fuses. Then I'll
> need to shift that data down by a few bits and mask it with the
> width of the data I want to read to extract the data needed.

Except that this is highly dependent on the usage you're making of
this API.

It could be fine to expect that if your writing machine code, that for
one given SoC will always be true.

If you're writing driver code, that will just have to lookup one value
=66rom an EEPROM, the exact offset, size and device being completely
board dependant, it's not really practical.

> The only thing after that where I have a problem is figuring out
> which eeprom is present in the consumer driver.

Is that really necessary? I mean, the point of having an abstraction
layer is precisely to *not* care about the provider when you are the
consumer.

If we can't, then the abstraction layer is not good enough and we
should improve it, but we shouldn't need to hack around it.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--foM9DbudB2CcldhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVJ7fuAAoJEBx+YmzsjxAgaiQP/3i9NmguuibkO56JVHuDSIKn
eIfYWZ+iRQGUgrHLnrW4vrCkd8ymZn/I6feoOAlIl72oQtw5WrqJWDI38EU/51IB
sbVDa2EavUgrxOJDvq0ULKWbPcd8GRfqRZl4Jbr9NbOgjslpyROsHVI7a2uqLfJs
hJjf9t6RkLijwkC29caQXZeeNcZHpdt2hx1szx+fyUwaGkHoDz8pHuISwiCWsSSD
kJJyfYN3Y234jFxwd9930Br2QXIXN2APhgBuAkxzHAKMpaV8C+E1sEa7weVTBeBZ
twHybsyvCWpKlr7F58ScL0eV7bu3LSok1MnUpkjsG1RX61RqmnK8zhE1lS8z4gW+
eMcs0UzQ4AOjlTOoZKs5HqXOwszmAA/L1o5BXH9ik7Ol0ZeQj+WXpi3yAyoFjgOz
7XYxKAewvPV2DP/QlnrOoeM4zrXT95qyH80MIiLTdz7h+geGohLZcxjlAnY//hr3
PeuGArWxEQ+U8dIF2RDpRxd0+QCHbQNPxLgsf223pgxbVGXPw+d/sNrbGxyA6ydl
Dy5947+Bxv9ICQYzDMajIoWuuuQaukpCJWXDrbThbAm/ZoaJsXbGSjO6oWfOTcEv
l16eqlY0L29S7h3uWIekN3Xa2VYvT2EbdsB8vkAwVoOccabnzC40E+1SUejxLXb5
RQWwM7OgFLeHOx6qAXYq
=xdxJ
-----END PGP SIGNATURE-----

--foM9DbudB2CcldhH--
