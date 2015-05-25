From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: Re: [PATCH v5 00/11] Add simple NVMEM Framework via regmap.
Date: Mon, 25 May 2015 19:51:45 +0300
Message-ID: <E5772084-6CF5-41DE-B68B-073D9F75F0BC@konsulko.com>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org> <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devicetree <devicetree@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, sboyd@codeaurora.org, Matt Porter <mporter@konsulko.com>
List-Id: linux-api@vger.kernel.org

Hi Srinivas,

> On May 21, 2015, at 19:42 , Srinivas Kandagatla <srinivas.kandagatla@=
linaro.org> wrote:
>=20
> Thankyou all for providing inputs and comments on previous versions o=
f this patchset.
> Here is the v5 of the patchset addressing all the issues raised as
> part of previous versions review.
>=20

>=20

[snip]

I tried to use the updated patchset with my at24 & beaglebone capemanag=
er patches.

I have a big problem with the removal of the raw of_* access APIs.

Take for instance the case where you have multiple slot accessing diffe=
rent EEPROMs.

> slots {
> 	slot@0 {
> 		eeprom =3D <&cape0_data>;
> 	};
>=20
> 	slot@1 {
> 		eeprom =3D <&cape1_data>;
> 	};
> };

In that case there is no per-device node mapping; it=E2=80=99s a per-su=
b node.

=46or now I=E2=80=99m exporting the of_* accessors again, please consid=
er exposing the of_* API again.

> --=20
> 1.9.1
>=20

Regards

=E2=80=94 Pantelis
