From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Tue, 24 Feb 2015 10:21:55 +0100
Message-ID: <20150224092155.GO25269@lukather>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org>
 <CAL_Jsq+SeuoojgTpv1y_aPJ_jzDr3HqZhYEBQ3_vYGBHvcccug@mail.gmail.com>
 <54E78A31.9020306@linaro.org>
 <CAL_Jsq+mvpRjYfL_8OseTDCB-6aBhwhNKLBQXXJeVQLDwWm8Nw@mail.gmail.com>
 <20150222143211.GX25269@lukather>
 <CAL_JsqLqqw5DyUqCaOTSKPwF-Ms5EU4f_OPoW9YVpMCo8A_bbw@mail.gmail.com>
 <54EBB3AC.30000@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V/YKEhZ4Pe4jxeTU"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54EBB3AC.30000@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org


--V/YKEhZ4Pe4jxeTU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2015 at 03:11:40PM -0800, Stephen Boyd wrote:
> >>> I would do something more simple that is just a list of keys and
> >>> their location like this:
> >>>
> >>> device-serial-number =3D <start size>;
> >>> key1 =3D <start size>;
> >>> key2 =3D <start size>;
> >> I'm sorry, but what's the difference?
> > It can describe the layout completely whether the fields are tied to a
> > h/w device or not.
> >
> > What I would like to see here is the entire layout described covering
> > both types of fields.
> >
>=20
> I was thinking the DT might be like this on the provider side:
>=20
>    qfprom@1000000 {
>       reg =3D <0x1000000 0x1000>;
>       ranges =3D <0 0x1000000 0x1000>;
>       compatible =3D "qcom,qfprom-msm8960"
>=20
>       pvs-data: pvs-data@40 {
>             compatible =3D "qcom,pvs-a";
>             reg =3D <0x40 0x20>,
> 	    #eeprom-cells =3D <0>;
>       };
>=20
>        tsens-data: tmdata@10 {
>             compatible =3D "qcom,tsens-data-msm8960";
>             reg =3D <0x10 4>, <0x16 4>;
> 	    #eeprom-cells =3D <0>;
>=20
>       };
>=20
>       serial-number: serial@50 {
>             compatible =3D "qcom,serial-msm8960";
>             reg =3D <0x50 4>, <0x60 4>;
> 	    #eeprom-cells =3D <0>;
>=20
>       };
>    };

I'm not sure the compatible is really needed.

A label of some sort, just like the MTD partitions do would do just
fine, and wouldn't have the implicit expectation that a driver will be
probed from that node.

> and then on the consumer side:
>=20
> 	device {
> 		eeproms =3D <&serial-number>;
> 		eeprom-names =3D "soc-rev-id";
> 	};
>=20
>=20
> This would solve a problem where the consumer device is some standard
> off-the-shelf IP block that needs to get some SoC specific calibration
> data from the eeprom. I may want to interpret the bits differently
> depending on which eeprom is connected to my SoC. Sometimes that data
> format may be the same across many variations of the SoC (e.g. the
> qcom,pvs-a node) or it may be completely different for a given SoC (e.g.
> qcom,serial-msm8960 node). I imagine for other SoCs out there it could
> be different depending on which eeprom the board manufacturer decides to
> wire onto their board and how they choose to program the data.

Oh, so you'd like to infer the data format it's stored in from the
compatible?

AFAICT, this format will be highly depending on the board itself,
rather than on the SoC, do you think it will scale enough?

> So this is where I think the eeprom-cells and offset + length starts to
> fall apart. It forces us to make up a bunch of different compatible
> strings for our consumer device just so that we can parse the eeprom
> that we decided to use for some SoC/board specific data. Instead I'd
> like to see some framework that expresses exactly which eeprom is on my
> board and how to interpret the bits in a way that doesn't require me to
> keep refining the compatible string for my generic IP block.

Hmmmm, apparently you don't :)

> I worry that if we put all those details in DT we'll end up having to
> describe individual bits like serial-number-bit-2, serial-number-bit-3,
> etc. because sometimes these pieces of data are scattered all around the
> eeprom and aren't contiguous or aligned on a byte boundary. It may be
> easier to just have a way to express that this is an eeprom with this
> specific layout and my device has data stored in there. Then the driver
> can be told what layout it is (via compatible or some other string based
> means if we're not using DT?) and match that up with some driver data if
> it needs to know how to understand the bits it can read with the
> eeprom_read() API.

I'm half convinced that the layout information will actually work for
more complex cases, like the linked list Rob described.

If such a structure is ever to be found, it would feel wrong to have
that in the EEPROM driver, but it would feel just as wrong to put that
in the client driver, that would have to handle the parsing of raw
data coming flashed by one single crazy board vendor.

Maybe we can have each cell carry a property that defines the format
it's stored in, and match that to some parsers plugins, starting with
the generic and trivial cases but still allowing for custom parsers to
be defined?

Something like

eeprom@42 {
	compatible =3D "atmel,at24something";
	reg =3D <0x42>;

	serial@0 {
		label =3D "board serial";
		reg =3D <0x0 0x10>;
		format =3D "packed";
	};

	opps@10 {
		label =3D "board serial";
		reg =3D <0x10 0x10>, <0x40 0x10>, <0x80 0x10>;
		format =3D "random-vendor,opp-linked-list";
	};
};

That would make eeprom_read always return the same format of data to
the client drivers, without cripling the generic EEPROM drivers
either.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--V/YKEhZ4Pe4jxeTU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJU7EKzAAoJEBx+YmzsjxAgzVcQALvbie+qtkNYMDaZSfgYyWHN
nWjpKQM153g5qCCdr/O+63da8n7xL3DhCLCWqj+xUvSCWlFz5bDkwYLF3+MVFdA0
2M+YxtxGAyd0FQC5shJbfZkqBeesf+nFLdJoOfbtJqn0rgJ2RFWR6o8b+PUfLMBM
BnzA3yfT7jsEKl/9LcB985UZ7wEEaQjtCITReMYVhvUhssqyt6ec1aq9cxOW8JP/
rCuWsNlZ/gQMMllFv3BhoUcX0gPjs8qxkFC3QHzuZTDDTLN+vbycxOjENqf/0M2i
jzPKDRzNpY7vQD2EPWvHQ4rODKHzXwloc9vfTNRwZatkxacQaL/Arbg6nXgK/XQU
5zZspsgiZhtWqWSxHS6kKQmaQyvGMEpSNeOCyG41Iwdrj7fx5z3XKOPZyS12u9c+
EXnWRfQ6w3JbgvyadoQA1yuRnndQvDD0mj2fJlkGk5P8rgtpAv7bNHNUsMLUtxmX
jC8FwouL16gkWn4ZGaYwLk2zylfjOBi6Sze1GOp0gooOUuLvH/3idIpdjBQPYC2C
pcXnRtpXzCGGXfGEVniwhV71FmISdsxnK00JLFpe7rENQElwBipcmUQAW2P4chb1
Vxstnff4BccJMJ25ZFQ6EcBMbB6mGw7XGZKc9LJ2Wu63uM3O3Ap8SrQbylXxy+n+
KD1qKf+xt1nqoCtsqozK
=O2a7
-----END PGP SIGNATURE-----

--V/YKEhZ4Pe4jxeTU--
