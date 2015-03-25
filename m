From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v3 5/9] eeprom: Add bindings for simple eeprom framework
Date: Wed, 25 Mar 2015 09:40:42 -0700
Message-ID: <20150325164042.GK23664@lukather>
References: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1427236230-18751-1-git-send-email-srinivas.kandagatla@linaro.org>
 <20150325071006.GC4946@pengutronix.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBYU9MM4gf8jKg2V"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150325071006.GC4946@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org
List-Id: linux-api@vger.kernel.org


--gBYU9MM4gf8jKg2V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 25, 2015 at 08:10:06AM +0100, Sascha Hauer wrote:
> On Tue, Mar 24, 2015 at 10:30:30PM +0000, Srinivas Kandagatla wrote:
> > This patch adds bindings for simple eeprom framework which allows eeprom
> > consumers to talk to eeprom providers to get access to eeprom cell data.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > [Maxime Ripard: intial version of eeprom framework]
> > Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> > ---
> >  .../devicetree/bindings/eeprom/eeprom.txt          | 70 ++++++++++++++=
++++++++
> >  1 file changed, 70 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/eeprom/eeprom.txt
> >=20
> > diff --git a/Documentation/devicetree/bindings/eeprom/eeprom.txt b/Docu=
mentation/devicetree/bindings/eeprom/eeprom.txt
> > new file mode 100644
> > index 0000000..8348d18
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/eeprom/eeprom.txt
> > @@ -0,0 +1,70 @@
> > +=3D EEPROM Data Device Tree Bindings =3D
> > +
> > +This binding is intended to represent the location of hardware
> > +configuration data stored in EEPROMs.
> > +
> > +On a significant proportion of boards, the manufacturer has stored
> > +some data on an EEPROM-like device, for the OS to be able to retrieve
> > +these information and act upon it. Obviously, the OS has to know
> > +about where to retrieve these data from, and where they are stored on
> > +the storage device.
> > +
> > +This document is here to document this.
> > +
> > +=3D Data providers =3D
> > +Contains bindings specific to provider drivers and data cells as child=
ren
> > +to this node.
> > +
> > +=3D Data cells =3D
> > +These are the child nodes of the provider which contain data cell
> > +information like offset and size in eeprom provider.
> > +
> > +Required properties:
> > +reg:	specifies the offset in byte within that storage device, and the =
length
> > +	in bytes of the data we care about.
> > +	There could be more then one offset-length pairs in this property.
> > +
> > +Optional properties:
> > +As required by specific data parsers/interpreters.
> > +
> > +For example:
> > +
> > +	/* Provider */
> > +	qfprom: qfprom@00700000 {
> > +		compatible 	=3D "qcom,qfprom";
> > +		reg		=3D <0x00700000 0x1000>;
> > +		...
> > +
> > +		/* Data cells */
> > +		tsens_calibration: calib@404 {
> > +			reg =3D <0x404 0x10>;
> > +		};
> > +
> > +		serial_number: sn {
> > +			reg =3D <0x104 0x4>, <0x204 0x4>, <0x30c 0x4>;
> > +
> > +		};
> > +		...
> > +	};
> > +
> > +=3D Data consumers =3D
> > +Are device nodes which consume eeprom data cells.
> > +
> > +Required properties:
> > +
> > +eeproms: List of phandle and data cell the device might be interested =
in.
> > +
> > +Optional properties:
> > +
> > +eeprom-names: List of data cell name strings sorted in the same order
> > +	      as the eeproms property. Consumers drivers will use
> > +	      eeprom-names to differentiate between multiple cells,
> > +	      and hence being able to know what these cells are for.
> > +
> > +For example:
> > +
> > +	tsens {
> > +		...
> > +		eeproms =3D <&tsens_calibration>;
> > +		eeprom-names =3D "calibration";
> > +	};
>=20
> This is somewhat complicated. Also having 'eeprom' in the binding is not
> nice since it could be FRAM or something else. How about:
>=20
> 	tsens {
> 		calibration =3D <&tsens_calibration>;
> 	};

A similar property was suggested the first time we discussed it, and
it turned out eventually that the construct you commented about was
actually preferred.

I guess we can always change the property name to something more
generic though.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--gBYU9MM4gf8jKg2V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVEuUKAAoJEBx+YmzsjxAg/xAQAJihpv80j8CNYMOgOlu0nkM0
puCPzn8giIo8TUZRWd4FzKOyo+pCYXgWkldJGs+6e/Q5snaqBT2H8iwD9/aDw+Za
l0iQif7fzjsios2Fnbm/8/uGdOtvSaJ88iOzrprle47geEgGzn02cgBAc1VLpwt8
oEe9qw2yskBp1Ha4qAqxT5WVIqrxYe9bMiPDCVxtiPJMN2Jhs759pIzJON+S9cmx
EcbzsuOyXrXivemDAdw9EE1s0X1FhJZdgfirimQ1MMhKljLCx6I0HzK958b4Gg9l
65hLFV+CpBwEOu+9DFaDVXMOe/+qyKUYdESUBRk1S9rHC8WjyO8w/Wgxa/+dy6Fj
R9I6ROf/qlik0X/QWrmrHkOqh4zLWXCJoPQofKcbotTHrb6uBQQV0GcpUH4Awyxr
vwYfCmts1tUvCYL0UQ4EvzJajdCsukVZ0p67KvywavAD1tVdivgC4B8GvlyilqfT
ZGw3jEEkxrsVUbTV1OTS9Im+EX2udytijNXvmwj4VckQi1ImL7KHOO+xkkLDsSV1
oLW7ng1UmuYm1OoR5QhdsohsoM0emtyAIlgAsejjv0Lys3bG7UnPXqxYx73XYDhy
WAkbl02FQZT1Ggl0CN+mUVjnajMthemy94I6o7SrNXWZ+98HzYEGdSryYq3eRrxt
/0DOisNifUeCfR30agWk
=LH6z
-----END PGP SIGNATURE-----

--gBYU9MM4gf8jKg2V--
