From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Thu, 26 Feb 2015 14:21:07 +0100
Message-ID: <20150226132107.GH29241@lukather>
References: <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org>
 <CAL_Jsq+SeuoojgTpv1y_aPJ_jzDr3HqZhYEBQ3_vYGBHvcccug@mail.gmail.com>
 <54E78A31.9020306@linaro.org>
 <CAL_Jsq+mvpRjYfL_8OseTDCB-6aBhwhNKLBQXXJeVQLDwWm8Nw@mail.gmail.com>
 <20150222143211.GX25269@lukather>
 <CAL_JsqLqqw5DyUqCaOTSKPwF-Ms5EU4f_OPoW9YVpMCo8A_bbw@mail.gmail.com>
 <54EBB3AC.30000@codeaurora.org>
 <20150224092155.GO25269@lukather>
 <20150225013049.GJ24928@codeaurora.org>
 <54EEE46B.6090905@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXr400anF0jyguTS"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54EEE46B.6090905-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--BXr400anF0jyguTS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 26, 2015 at 09:16:27AM +0000, Srinivas Kandagatla wrote:
> I think we are making simple eeprom framework too smart which will
> break in future.
>=20
> IMHO, Anything on top of eeprom interface that interprets the data should
> not go into the eeprom framework itself, it can either live some parsers/=
SOC
> specific drivers/interfaces.

True, but that doesn't mean that this parser support can't be built
within the framework itself.

> As Stephen pointed out earlier lets start with something like this, which
> would provide a better abstraction to the discussed use cases like
> serial-number and packed data in eeprom.
>=20
>    qfprom@1000000 {
>       reg =3D <0x1000000 0x1000>;
>       ranges =3D <0 0x1000000 0x1000>;
>       compatible =3D "qcom,qfprom-msm8960"
>=20
>       pvs-data: pvs-data@40 {
>             compatible =3D "qcom,pvs-a";
>             reg =3D <0x40 0x20>,
>       };
>=20
>        tsens-data: tmdata@10 {
>             reg =3D <0x10 40>;
>       };
>=20
>       serial-number: serial@50 {
>             compatible =3D "qcom,serial-msm8960";
>             reg =3D <0x50 4>, <0x60 4>;
>       };
>=20
>    };

And I'm sorry, but I still don't get why the compatibles are needed
here.

> and then on the consumer side:
>=20
> 	device {
> 		eeproms =3D <&serial-number>;
> 		eeprom-names =3D "soc-rev-id";
> 	};
> =09
> driver side:
>=20
> 	eeprom_get_cell()
> 	eeprom_read();

Looks good otherwise.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--BXr400anF0jyguTS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJU7x3DAAoJEBx+YmzsjxAg1LAQAJFRmTg8ttj2FEucVUpayrem
Ncm+tdWLo+9RSEhtyTIJwfHPCdI2ViQ0vADf7KWJQXYXFknrbLFKV4dmCoZBhY1r
ofXIkHczFcHiWUj4KpCF3lhsq+VJK4ku7oK0CJRjxfHAUrKq24CZ32IFgnpuPFc8
FPcjFIggUMnm76HcBCV6nk9jZuuYhjHbuSHM56pod67Pusn1G5BM/nUltBXa5lhW
EDznYf8So+wzwmn2P+wA5MUwOuBWz0FK9cOHCYF13GWkitUMi2C0jl2MRIc3ZDRL
rKgBKdki/Z2bHpe7ICeqlUkKloX6gr6Zc+cdKWCGTmhcBxk9EnDQH+NIE8+olEHR
vqMqSVDjfycJb3bI2y7rNBW5LTcUcjollVZuvLzIjv5JNP+R63i8Ub+t+oPFG0rE
rLQ8sW8VPkxujJonNk92pmvgxJQUvh9YacOmZrPn8ak9wH87m3nNl/loNyX2Gpvo
Vt5JPwJnzNiSyB5JGwR7dWxDg2wpHzQpzvHH7FYYbpzJUCmJyMadGxrjAoMMyFfA
AvdIlWXiPnyEe/s5HYpDInYg/CCVvlvx3RU/ujBsWuX8eUTWI0rfDKhQwdCkO/AV
QKy7H+NEpGBjUWF7F8ZkmdQk0+yWfmE5IxRJJlUOT+KNfQL6XjUeP628B/5hDvlf
9QiPNU8T4or5rjaWoD6d
=e8kL
-----END PGP SIGNATURE-----

--BXr400anF0jyguTS--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
