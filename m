Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC3C3B3BE6;
	Fri,  9 Oct 2026 14:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557930; cv=none; b=f20faLjJtQ/ogLYlAvSDVgcRYmCjlHN8IH4VTDkCRQTFmmcNqt6bNlbJi/Zz/Loxwf9tmneitbsALblFMRQUzUPyjrrOVeFel6vk+TIeTVv0PIhRXFDWIaSSzZSskDGSP4qZIly0dO9cY7/m8D7ojg0VfgfcRkeBacco5+Hrk3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557930; c=relaxed/simple;
	bh=cHfQVjGwTWN3mvTSbJ4bmJy0NC2sVCOgxbk5TVTcD4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SWBq/3tDfyuSBU95fSMPyhxP/dLQMikPRCGJRXbc0lE6L4roJLp4WIDNkpUodgIHJZOpDs/3CyuC8ItlGpt3d/TWAsDJhxrZb3vWgc4cUcA5e6pAMaeiiRgdZKJmy+RluQQ5HIpAOae1O/OdH/OCQVIcfj4EjlquN4KkirO9hMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oB2P4myO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oB2P4myO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347611F000FF;
	Fri,  9 Oct 2026 14:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791557928;
	bh=J/ONsV+WMtPXVXfEYwgkgLrKLerfe5w3ubhZH2PKm7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oB2P4myO0GpdK6FMZk/oWFksORFCClpCMXEpB++z2aZo0R6mQqhI/nwj10JTfZCLZ
	 YbARhQzN51Q67l2DyjbKkdA5j3FouF2S/Yv9KQPPOn0ReT7SzcGozEbzuylML/dJrr
	 8f8skk/VY6PgI6KhOwMQE5LpBr3+uyRta046TWvWO6MolvmNT5PONTMxM1KjmCeyNx
	 DhJ5Z5XQBzyY+d7gcxO+/3Sr4RFlUVm7l1KUnx8k/R3K2J+rBKZar8g+9w8BPAIDX/
	 wBcm8GtmETD8aoHYe6hKbqG9n/uWus8XP6U+DnPFNtpr3N06V/uJOQVir5yOtW08b4
	 EnpSEukL7MluQ==
Date: Fri, 9 Oct 2026 15:58:40 +0100
From: Conor Dooley <conor@kernel.org>
To: zjzhao@edatec.cn
Cc: gregkh@linuxfoundation.org, jirislaby@kernel.org, robh@kernel.org,
	krzk+dt@kernel.org, conor+dt@kernel.org, hugo@hugovil.com,
	hy@wkmic.com, linux-serial@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v5 1/2] dt-bindings: serial: Document WK2xxx SPI UART
Message-ID: <20261009-0d3ee8f71d04ab70c387db33@squawk>
References: <cover.20261009.wk2xxx.v5@edatec.cn>
 <20261009082530.248219-1-zjzhao@edatec.cn>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="GcGhcH9vO+oZF4fF"
Content-Disposition: inline
In-Reply-To: <20261009082530.248219-1-zjzhao@edatec.cn>

--GcGhcH9vO+oZF4fF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 09, 2026 at 04:24:07PM +0800, zjzhao@edatec.cn wrote:
> From: Zi Jie Zhao <zjzhao@edatec.cn>
>=20
> Add a DT binding for the WK2xxx SPI-to-UART bridge ICs (WK2124,
> WK2132, WK2168, WK2212 and WK2204) from Chengdu Weikai
> Microelectronics (WKmic).
>=20
> Describe each UART channel with a serial@N child node carrying its
> serial and RS-485 properties. Register the wkmic vendor prefix based
> on the vendor website.
>=20
> Differentiate compatible strings by channel count and register
> availability. WK2124 and WK2132 lack hardware flow-control and
> RS-485 registers. WK2212 is a separate two-channel model that
> supports both features. Reject serial@2 and serial@3 on the
> two-channel members.
>=20
> Correct the WK2202 compatible used in the public v4 series to
> WK2212. WK2202 in the public reference driver is a typo.
>=20
> Require the standard clocks property for the single external
> reference clock used by the chips.
>=20
> Assisted-by: LLM
> Signed-off-by: Zi Jie Zhao <zjzhao@edatec.cn>
> ---
>  .../bindings/serial/wkmic,wk2124.yaml         | 119 ++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>  MAINTAINERS                                   |   7 ++
>  3 files changed, 128 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/serial/wkmic,wk2124=
=2Eyaml
>=20
> diff --git a/Documentation/devicetree/bindings/serial/wkmic,wk2124.yaml b=
/Documentation/devicetree/bindings/serial/wkmic,wk2124.yaml
> new file mode 100644
> index 000000000000..47a0cbdb5ca1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/wkmic,wk2124.yaml
> @@ -0,0 +1,119 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/serial/wkmic,wk2124.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: WKmic WK2xxx SPI to UART bridge
> +
> +maintainers:
> +  - Huang Yang <hy@wkmic.com>
> +
> +description:
> +  The WK2xxx family (WK2124, WK2132, WK2168, WK2212 and WK2204) are SPI =
to
> +  UART bridge ICs from WKmic (Chengdu Weikai Microelectronics). Each IC
> +  exposes two or four full-duplex UART channels with 256-byte RX/TX FIFOs
> +  through a single SPI slave interface and one interrupt line, and is
> +  clocked from a single external reference clock. Each channel is
> +  described by a "serial@N" child node that carries its own serial and
> +  RS-485 properties.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - wkmic,wk2124
> +      - wkmic,wk2132
> +      - wkmic,wk2168
> +      - wkmic,wk2212
> +      - wkmic,wk2204
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    description:
> +      When missing, the device driver uses polling instead.
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +patternProperties:
> +  "^serial@[0-3]$":
> +    type: object
> +    description: A single UART channel of the chip.
> +    allOf:
> +      - $ref: /schemas/serial/serial.yaml#
> +      - $ref: /schemas/serial/rs485.yaml#
> +    properties:
> +      reg:
> +        description: UART channel number on the chip.
> +        maximum: 3
> +    required:
> +      - reg
> +    unevaluatedProperties: false
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - "#address-cells"
> +  - "#size-cells"
> +
> +allOf:
> +  - $ref: /schemas/spi/spi-peripheral-props.yaml#
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - wkmic,wk2132
> +              - wkmic,wk2212
> +    then:
> +      patternProperties:
> +        "^serial@[23]$": false
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    xtal: clock-11059200 {
> +        compatible =3D "fixed-clock";
> +        clock-frequency =3D <11059200>;
> +        #clock-cells =3D <0>;
> +    };

Drop this node here please, the infra will populate it at runtime to
make your example work.

pw-bot: changes-requested

Otherwise, it looks fine.to me..

Thanks,
Conor.


> +
> +    spi {
> +        #address-cells =3D <1>;
> +        #size-cells =3D <0>;
> +
> +        serial@0 {
> +            compatible =3D "wkmic,wk2204";
> +            reg =3D <0>;
> +            spi-max-frequency =3D <10000000>;
> +            clocks =3D <&xtal>;
> +            interrupt-parent =3D <&gpio>;
> +            interrupts =3D <24 IRQ_TYPE_LEVEL_LOW>;
> +            #address-cells =3D <1>;
> +            #size-cells =3D <0>;
> +
> +            serial@0 {
> +                reg =3D <0>;
> +            };
> +
> +            serial@1 {
> +                reg =3D <1>;
> +                rs485-rts-active-low;
> +                linux,rs485-enabled-at-boot-time;
> +            };
> +        };
> +    };
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Doc=
umentation/devicetree/bindings/vendor-prefixes.yaml
> index ba2002969373..cdc04229d642 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
> @@ -1907,6 +1907,8 @@ patternProperties:
>      description: Wireless Tag (qiming yunduan)
>    "^wits,.*":
>      description: Shenzhen Merrii Technology Co., Ltd. (WITS)
> +  "^wkmic,.*":
> +    description: Chengdu Weikai Microelectronics Co., Ltd. (http://www.w=
kmic.com/)
>    "^wlf,.*":
>      description: Wolfson Microelectronics
>    "^wm,.*":
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3b2eb2a7a89a..e4a2443524d4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -29432,6 +29432,13 @@ M:	Miloslav Trmac <mitr@volny.cz>
>  S:	Maintained
>  F:	drivers/input/misc/wistron_btns.c
> =20
> +WK2XXX SPI UART DRIVER
> +M:	Huang Yang <hy@wkmic.com>
> +L:	linux-serial@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/serial/wkmic,wk2124.yaml
> +F:	drivers/tty/serial/wk2xxx.c
> +
>  WMI BINARY MOF DRIVER
>  M:	Armin Wolf <W_Armin@gmx.de>
>  R:	Thomas Wei=DFschuh <linux@weissschuh.net>
> --=20
> 2.43.0
>=20

--GcGhcH9vO+oZF4fF
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaskBIAAKCRB4tDGHoIJi
0gioAQCCXaZVxKgZfqGh8sn8aKKnA4/fEW+1CqDV00+hrVxY3QEAs+zNzGhcF2W8
HY1y72jE+YymGtDIu1QvxfGFOIl2mwI=
=eOrH
-----END PGP SIGNATURE-----

--GcGhcH9vO+oZF4fF--
