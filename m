From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Thu, 26 Feb 2015 14:18:00 +0100
Message-ID: <20150226131800.GG29241@lukather>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org>
 <CAL_Jsq+SeuoojgTpv1y_aPJ_jzDr3HqZhYEBQ3_vYGBHvcccug@mail.gmail.com>
 <54E78A31.9020306@linaro.org>
 <CAL_Jsq+mvpRjYfL_8OseTDCB-6aBhwhNKLBQXXJeVQLDwWm8Nw@mail.gmail.com>
 <20150222143211.GX25269@lukather>
 <CAL_JsqLqqw5DyUqCaOTSKPwF-Ms5EU4f_OPoW9YVpMCo8A_bbw@mail.gmail.com>
 <54EBB3AC.30000@codeaurora.org>
 <20150224092155.GO25269@lukather>
 <20150225013049.GJ24928@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Zw+/jwnNHcBRYYu"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150225013049.GJ24928-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--/Zw+/jwnNHcBRYYu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 24, 2015 at 05:30:49PM -0800, Stephen Boyd wrote:
> On 02/24, Maxime Ripard wrote:
> > On Mon, Feb 23, 2015 at 03:11:40PM -0800, Stephen Boyd wrote:
> > > >>> I would do something more simple that is just a list of keys and
> > > >>> their location like this:
> > > >>>
> > > >>> device-serial-number =3D <start size>;
> > > >>> key1 =3D <start size>;
> > > >>> key2 =3D <start size>;
> > > >> I'm sorry, but what's the difference?
> > > > It can describe the layout completely whether the fields are tied t=
o a
> > > > h/w device or not.
> > > >
> > > > What I would like to see here is the entire layout described coveri=
ng
> > > > both types of fields.
> > > >
> > >=20
> > > I was thinking the DT might be like this on the provider side:
> > >=20
> > >    qfprom@1000000 {
> > >       reg =3D <0x1000000 0x1000>;
> > >       ranges =3D <0 0x1000000 0x1000>;
> > >       compatible =3D "qcom,qfprom-msm8960"
> > >=20
> > >       pvs-data: pvs-data@40 {
> > >             compatible =3D "qcom,pvs-a";
> > >             reg =3D <0x40 0x20>,
> > > 	    #eeprom-cells =3D <0>;
> > >       };
> > >=20
> > >        tsens-data: tmdata@10 {
> > >             compatible =3D "qcom,tsens-data-msm8960";
> > >             reg =3D <0x10 4>, <0x16 4>;
> > > 	    #eeprom-cells =3D <0>;
> > >=20
> > >       };
> > >=20
> > >       serial-number: serial@50 {
> > >             compatible =3D "qcom,serial-msm8960";
> > >             reg =3D <0x50 4>, <0x60 4>;
> > > 	    #eeprom-cells =3D <0>;
> > >=20
> > >       };
> > >    };
> >=20
> > I'm not sure the compatible is really needed.
> >=20
> > A label of some sort, just like the MTD partitions do would do just
> > fine, and wouldn't have the implicit expectation that a driver will be
> > probed from that node.
>=20
> I wasn't aware that compatible meant driver probe. I thought
> compatible just meant some software entity can understand what
> I've described within this node. For example, compatible for
> reserved-memory nodes doesn't mean we're going to probe a device.

Maybe it's just me then :)

> > > and then on the consumer side:
> > >=20
> > > 	device {
> > > 		eeproms =3D <&serial-number>;
> > > 		eeprom-names =3D "soc-rev-id";
> > > 	};
> > >=20
> > >=20
> > > This would solve a problem where the consumer device is some standard
> > > off-the-shelf IP block that needs to get some SoC specific calibration
> > > data from the eeprom. I may want to interpret the bits differently
> > > depending on which eeprom is connected to my SoC. Sometimes that data
> > > format may be the same across many variations of the SoC (e.g. the
> > > qcom,pvs-a node) or it may be completely different for a given SoC (e=
=2Eg.
> > > qcom,serial-msm8960 node). I imagine for other SoCs out there it could
> > > be different depending on which eeprom the board manufacturer decides=
 to
> > > wire onto their board and how they choose to program the data.
> >=20
> > Oh, so you'd like to infer the data format it's stored in from the
> > compatible?
> >=20
> > AFAICT, this format will be highly depending on the board itself,
> > rather than on the SoC, do you think it will scale enough?
> >=20
> > > So this is where I think the eeprom-cells and offset + length starts =
to
> > > fall apart. It forces us to make up a bunch of different compatible
> > > strings for our consumer device just so that we can parse the eeprom
> > > that we decided to use for some SoC/board specific data. Instead I'd
> > > like to see some framework that expresses exactly which eeprom is on =
my
> > > board and how to interpret the bits in a way that doesn't require me =
to
> > > keep refining the compatible string for my generic IP block.
> >=20
> > Hmmmm, apparently you don't :)
> >=20
> > > I worry that if we put all those details in DT we'll end up having to
> > > describe individual bits like serial-number-bit-2, serial-number-bit-=
3,
> > > etc. because sometimes these pieces of data are scattered all around =
the
> > > eeprom and aren't contiguous or aligned on a byte boundary. It may be
> > > easier to just have a way to express that this is an eeprom with this
> > > specific layout and my device has data stored in there. Then the driv=
er
> > > can be told what layout it is (via compatible or some other string ba=
sed
> > > means if we're not using DT?) and match that up with some driver data=
 if
> > > it needs to know how to understand the bits it can read with the
> > > eeprom_read() API.
> >=20
> > I'm half convinced that the layout information will actually work for
> > more complex cases, like the linked list Rob described.
> >=20
> > If such a structure is ever to be found, it would feel wrong to have
> > that in the EEPROM driver, but it would feel just as wrong to put that
> > in the client driver, that would have to handle the parsing of raw
> > data coming flashed by one single crazy board vendor.
> >=20
> > Maybe we can have each cell carry a property that defines the format
> > it's stored in, and match that to some parsers plugins, starting with
> > the generic and trivial cases but still allowing for custom parsers to
> > be defined?
> >=20
> > Something like
> >=20
> > eeprom@42 {
> > 	compatible =3D "atmel,at24something";
> > 	reg =3D <0x42>;
> >=20
> > 	serial@0 {
> > 		label =3D "board serial";
> > 		reg =3D <0x0 0x10>;
> > 		format =3D "packed";
> > 	};
> >=20
> > 	opps@10 {
> > 		label =3D "board serial";
> > 		reg =3D <0x10 0x10>, <0x40 0x10>, <0x80 0x10>;
> > 		format =3D "random-vendor,opp-linked-list";
> > 	};
> > };
> >=20
> > That would make eeprom_read always return the same format of data to
> > the client drivers, without cripling the generic EEPROM drivers
> > either.
> >=20
>=20
> Is the goal here to make eeprom_read() figure out how to return
> the next byte of data and hide the parsing logic behind the
> eeprom APIs? I imagine "random-vendor,opp-linked-list" would be
> handled by the eeprom driver and that would return OPPs byte by
> byte across the different reg properties to the eeprom consumer?
>=20
> This approach concerns me because every eeprom_read() call needs
> to fit the format that the client driver is expecting. How do we
> validate that? What do we do if we have a random OPP client #1
> that expects to get the data from eeprom_read() with OPPs in
> ascending order and random OPP client #2 that expects to get the
> data from eeprom_read() with OPPs in descending order?

Without going that far, we could have the little/big endian topic here
as well.

But I guess it all boils down to wether we should support only the
trivial cases, or not. Generally speaking, and not just about the OPPs
above, we could really well end up with a "generic" (not necessarily a
really generic driver, but also IPs used across several SoCs, like the
Mentor/Synopsis ones) driver, requiring to read some data from an
EEPROM for some reason.

Where would you fit the raw data parsing code? In that generic
driver. It would end up being just as messy, if not more.

So yeah, it really depends on wether we just want to support reading a
contiguous block of data, or if we want to cover all cases. And in
that case, we should indeed support the cases you mentioned above.

> It feels like we're making the eeprom framework too smart without
> a well defined abstraction. If we were to make it so that
> eeprom_get_opps() knew what to do and parsed/populated the OPPs,
> it might work. But if we're just exporting raw data across a
> read/write API with some implementation specific mangling it
> sounds like it's going to get messy fast. And if the API is well
> defined, it would start to become rather large with many
> different types of data that need to be parsed and sometimes data
> that's only specific to a single SoC.

Or even a single board. Most of the drivers are in that case. That
doesn't mean that the frameworks should just ignore them entirely
because of that fact.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--/Zw+/jwnNHcBRYYu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJU7x0IAAoJEBx+YmzsjxAgZD0QAKQeZvCLiKlIcnBxbTtHU8xE
UAOOZdfH7bFFwaLz4277wolkYESMGItsdn+Ohh1OjaBSCMtVG6RabVPa9T9N4k4o
RrxDyMcXLmE2PMpVBqe3xVCu6sGt+zItEiA2C8f+A+jdq7Klbv7SWjeyDjIcPrs5
ffgp0L9nxvmh37h83du66DM30G6CPyuk9tcZpzToXp+eRbsks3N2ctgrErxfvnD8
+MlUXkuxboSsIg71h3f5t3aTFYZDXLBNzMf7KyJBXDdZb8mDl5gXytfY4F5Z9o5P
cdyCIp6JAfdRdJ3AAhnzndWCd6yAcOq3SMm2Y2gj9Fe61kQK+PxOh3urTxwej8H8
9dvsNAOViDLq3TC6Mxo4+MrBAOvJsI9SudNK3iGq45D3I+OJIbLizbab3FuuNbwX
kcbKt6OSOb0X/BBWy1WiRaNbFII74fwtQ4bv1bSTtiA4iPzX9e3HJQ2iKLeAflkg
cdhaRBWbAuAcbRdPzMWndfsDMAXIY48PjzRC6oYEtqmLo4zXp9T6OKUkCwt9MgWy
SseawhQWH0cMDwGEPnKoisX4MBm0a0TWdu3B7DBUudVfJiGd2bx7Cgrjv0odP9fh
TcKhBRlu7qlAF3bPWFxqN38bXfJMQeLP5Asp5o/7aZsdZhSzdUXKeysKkygvYQKQ
GrO/Yr9k3Md9ykrcl9Oc
=KY2r
-----END PGP SIGNATURE-----

--/Zw+/jwnNHcBRYYu--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
