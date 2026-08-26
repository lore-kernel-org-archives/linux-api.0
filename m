Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313CD347FCD;
	Wed, 26 Aug 2026 17:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787763755; cv=none; b=gMqDaYM00Q9bt3/3n9Bjz/UPJFCIOOuNnWrFUZTyW12adq6SpCm/nR+qlx3vjLH4Dv+gPIuT4ChKCzkrb4bLjBWIxQjq+oRBXbqOfJIpwSLGfjqlHoL9lLrbpNc5IlKn7KfnocwdFnel55lOwQOJhxEkInN0ycCAbJHjWllB6sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787763755; c=relaxed/simple;
	bh=u0RKM02wOzuvhntRLoFKu9oNmuIfFheu6cW7Dr4jCJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iEcEt6X6aK0VV/mHNisM6hNSIkGmvbQ+biu3WYJhuJlWOL2EzZvrtqISjw5gHSTTmvHEOqmBCtJ9qysG3DNFprQnn6GCh8ZWqniYA1CTjBxhAcA3kR+7K9pMxTzJxPmYAbDD6VjzQ7eQKPE8/WjOk2UNWGlcoOPgXFQYv2EYHkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bn/DiV/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bn/DiV/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EBA1F000E9;
	Wed, 26 Aug 2026 17:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787763743;
	bh=PvMhOpMtgahb/2g6h4rPwkBMlykF3l7pKxLhOb+mM+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bn/DiV/GuREkqk9gLaLx9oQOgG/zG/4wjB0MvEVME582wC2HbgYlUE3fOR/KD8sYK
	 oCBf2UdqvnKJ9wytcgrqwQVTkbinysLZ0yZz5oPZlMo9pSqLwYCsXEQhrrzYoxBA0R
	 wEnMTcMArz+ogjjsExgFwpAwuLvyJovUy67/4qFCwoMeD++JRnmcm4KbH+lKP2QajX
	 C+XapE8uFFYdvM+bW+q8IsgbwPhHCO9diw1dha1JdZgQBacL8KU9dtB/xdES3J1ndv
	 vC0o3AN8uuJla0rAs/LFvDPR/bq6bkALmlomtA/wkxeSOibPN2luyhIryddfiEse/P
	 ilQneArTa5cxg==
Date: Wed, 26 Aug 2026 18:02:16 +0100
From: Conor Dooley <conor@kernel.org>
To: Alex Ousherovitch <aousherovitch@rambus.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>,
	Shuah Khan <shuah@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
	devicetree@vger.kernel.org,
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
	linux-api@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thi Nguyen <thin@rambus.com>
Subject: Re: [PATCH v4 01/19] dt-bindings: crypto: add Rambus CryptoManager
 Hub
Message-ID: <20260826-unwritten-marshland-47cdf3c17cad@spud>
References: <20260825221539.255951-1-aousherovitch@rambus.com>
 <20260825221539.255951-2-aousherovitch@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ijLsa67cbXpBs7zp"
Content-Disposition: inline
In-Reply-To: <20260825221539.255951-2-aousherovitch@rambus.com>

--ijLsa67cbXpBs7zp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 03:15:20PM -0700, Alex Ousherovitch wrote:
> Add device tree binding schema for the Rambus CryptoManager Hub (CMH)
> hardware crypto accelerator.  The binding describes the parent
> SoC-level node with its SIC register region and one queue@N child
> node per mailbox the host owns, each carrying a reg (mailbox instance
> index), an optional interrupt, VCQ ring geometry (rambus,num-slots /
> rambus,slot-stride-bytes) and a rambus,cores affinity list.  Which crypto=
 cores
> are present is discovered from the SIC CORE_ENABLE register at probe,
> not described in the device tree.
>=20
> Register the 'rambus' vendor prefix for Rambus Inc.
>=20
> Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
> Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.=
com>
> Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.co=
m>
> ---
>  .../bindings/crypto/rambus,cmh-v1030.yaml     | 194 ++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>  2 files changed, 196 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rambus,cmh-v=
1030.yaml
>=20
> diff --git a/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.ya=
ml b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
> new file mode 100644
> index 000000000000..d9598b0f3bbc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
> @@ -0,0 +1,194 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/rambus,cmh-v1030.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Rambus CryptoManager Hub (CMH) Hardware Crypto Accelerator
> +
> +maintainers:
> +  - Alex Ousherovitch <aousherovitch@rambus.com>
> +  - Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
> +  - Joel Wittenauer <Joel.Wittenauer@cryptography.com>
> +
> +description: |
> +  The Rambus CryptoManager Hub (CMH) is a hardware cryptographic acceler=
ator
> +  accessed via a mailbox-based VCQ (Virtual Command Queue) interface.  T=
he
> +  host writes VCQ command sequences into per-mailbox DMA queue buffers a=
nd
> +  rings a doorbell; the CMH eSW processes them and signals completion via
> +  interrupt.
> +
> +  The management host statically partitions the hardware mailboxes across
> +  the SoC's host interfaces at integration time; the set of mailboxes a
> +  given host owns is therefore fixed and not runtime-discoverable (a
> +  mailbox locked to a host reads as unavailable in the SIC availability
> +  register).  Each owned mailbox is described by a child node.  Which
> +  crypto cores are present is a fixed silicon-build property indicated by
> +  the SIC CORE_ENABLE register, so cores are not described in the device
> +  tree.
> +
> +  CMH gates access to a locked mailbox by a hardware HOST ID presented on
> +  the bus with every access, permitting only the owning host's ID.  An
> +  integration must present a single, stable HOST ID for all accesses to a
> +  given mailbox, independent of the issuing CPU (relevant on SMP hosts
> +  whose interconnect encodes the issuing CPU in the HOST ID).
> +
> +properties:
> +  compatible:
> +    const: rambus,cmh-v1030
> +    description:
> +      Identifies the CryptoManager Hub v1.030 IP revision (register map =
and
> +      command ABI).  A specific SoC integration should list its own
> +      "<vendor>,<soc>-cmh" compatible first with "rambus,cmh-v1030" as a
> +      fallback; that extended form will be added when such a platform is
> +      upstreamed.

This commentary should just not be here.
Instead, do what's been done in sifive,clint.yaml for the clint2. I
don't feel great about suggesting that, and it feels like it's becoming
more common - although maybe that's a good thing because it means IP
vendors are being more proactive about upstreaming.

> +
> +  reg:
> +    maxItems: 1
> +    description:
> +      SIC (System Interface Controller) MMIO region.  The registers of
> +      mailbox instance N are at offset N * 0x1000 within this region.
> +
> +  clocks:
> +    minItems: 1
> +    items:
> +      - description: Main functional clock ("core").
> +      - description:
> +          Half-rate "core-div2" clock (present only on configurations wi=
th
> +          side-channel-protected cores) or the "rt" real-time tick clock.
> +      - description: Real-time tick clock ("rt") for the internal timer.
> +
> +  clock-names:
> +    oneOf:
> +      - items:
> +          - const: core
> +      - items:
> +          - const: core
> +          - const: core-div2
> +      - items:
> +          - const: core
> +          - const: rt
> +      - items:
> +          - const: core
> +          - const: core-div2
> +          - const: rt
> +
> +  reset-gpios:
> +    maxItems: 1
> +    description:
> +      Host-controlled reset for the CryptoManager Hub.  The hub has two
> +      external, active-low reset inputs -- a power-on reset and a hard
> +      reset; where a board routes one of them to a host GPIO, that line =
is
> +      described here.
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +patternProperties:
> +  "^queue@[0-9a-f]+$":
> +    type: object
> +    description:
> +      One node per hardware mailbox (VCQ command queue) this host owns.
> +      The set of owned mailboxes is fixed by the management host at
> +      integration time and enumerated here.
> +    properties:
> +      reg:
> +        maxItems: 1
> +        description:
> +          0-based mailbox instance index.  The instance's registers are
> +          at reg * 0x1000 within the SIC region.
> +
> +      interrupts:
> +        maxItems: 1
> +        description: Completion/error interrupt for this mailbox.
> +
> +      rambus,num-slots:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 819=
2,
> +               16384, 32768]
> +        default: 64
> +        description:
> +          Number of VCQ ring slots for this mailbox's command queue in
> +          host DMA memory.  This is a per-board, per-mailbox host-memory
> +          ring geometry -- boards built around the same SoC (hence the
> +          same compatible) may use different ring sizes, so it is
> +          described per mailbox rather than derived from the compatible.
> +
> +      rambus,slot-stride-bytes:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        enum: [128, 256, 512, 1024]
> +        default: 512
> +        description:
> +          Stride in bytes between consecutive VCQ ring slots for this
> +          mailbox's command queue.  Like rambus,num-slots this is a
> +          per-board host-memory ring geometry, not derived from the
> +          compatible.
> +
> +      rambus,cores:
> +        $ref: /schemas/types.yaml#/definitions/uint32-array
> +        items:
> +          enum: [0x02, 0x03, 0x04, 0x05, 0x08, 0x09, 0x0a, 0x18]
> +        description: |
> +          Core-affinity list: the hardware core IDs whose work is
> +          dispatched to this mailbox.  A core ID may appear on at most o=
ne
> +          mailbox.  Cores not listed on any mailbox are load-balanced
> +          across all mailboxes.  Optional (default: none -- the mailbox
> +          only serves the load-balanced pool).
> +
> +          Because each core instance has a distinct ID, separate
> +          instances of the same core type can be pinned to different
> +          mailboxes.
> +
> +          Core IDs:
> +            0x02 HC, 0x03 AES, 0x04 SM4, 0x05 SM3,
> +            0x08 HCQ, 0x09 QSE, 0x0a PKE, 0x18 CCP.

You could just make this a string array, and then you'd not need this
mapping of unintelligible hex values. Of course then your driver has to
do it, but I'd rather see understandable (and portable, since a new
revision could change the IDs) values in DT.

> +
> +    required:
> +      - reg
> +
> +    additionalProperties: false
> +
> +required:
> +  - compatible
> +  - reg
> +  - "#address-cells"
> +  - "#size-cells"

Surely clocks are also mandatory?

pw-bot: changes-requested

Cheers,
Conor.

> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    soc {
> +        #address-cells =3D <2>;
> +        #size-cells =3D <2>;
> +
> +        crypto@a4800000 {
> +            compatible =3D "rambus,cmh-v1030";
> +            reg =3D <0x0 0xa4800000 0x0 0x41000>;
> +            clocks =3D <&cmh_core_clk>;
> +            clock-names =3D "core";
> +            #address-cells =3D <1>;
> +            #size-cells =3D <0>;
> +
> +            /* Fast symmetric cores dedicated to mailbox 0:
> +             * HC 0x02, AES 0x03, SM4 0x04, SM3 0x05, CCP 0x18 */
> +            queue@0 {
> +                reg =3D <0>;
> +                interrupts =3D <1>;
> +                rambus,cores =3D <0x02 0x03 0x04 0x05 0x18>;
> +            };
> +
> +            /* Slow asymmetric/PQC cores dedicated to mailbox 1:
> +             * HCQ 0x08, QSE 0x09, PKE 0x0a */
> +            queue@1 {
> +                reg =3D <1>;
> +                interrupts =3D <2>;
> +                rambus,cores =3D <0x08 0x09 0x0a>;
> +                rambus,num-slots =3D <64>;
> +                rambus,slot-stride-bytes =3D <512>;
> +            };
> +        };
> +    };
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Doc=
umentation/devicetree/bindings/vendor-prefixes.yaml
> index 396044f368e7..8b1a8f0a673d 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
> @@ -1371,6 +1371,8 @@ patternProperties:
>      description: RaidSonic Technology GmbH
>    "^ralink,.*":
>      description: Mediatek/Ralink Technology Corp.
> +  "^rambus,.*":
> +    description: Rambus Inc.
>    "^ramtron,.*":
>      description: Ramtron International
>    "^raspberrypi,.*":
> --=20
> 2.43.7
>=20

--ijLsa67cbXpBs7zp
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCao8cGAAKCRB4tDGHoIJi
0sjsAQCs5O4ETXRJy6kouRnk1/OQzmyoUsRPrpeb9rM/21hfJAD9EpAJQfU5xwoJ
RERZNwRIPTsmZQlDVlrThF4+t3HV5wM=
=dVOj
-----END PGP SIGNATURE-----

--ijLsa67cbXpBs7zp--
