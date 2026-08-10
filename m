Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8AE3630BF;
	Mon, 10 Aug 2026 08:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786349800; cv=none; b=W6tkuH6fsf/I9CqeUreAJhoPJKSo+vn8+Q3thrzkxxy0XwmwSZBFQHhu8xpClxxIRmnGRjQMM2PcKZfnEFghf+XkZxdJIElsMUIPAbQL3D6FWTVtx4WGr+PvDIiey8yGNucW4tuoop+KEhlugoeIRYIAuPFShQEj8Ip+xAVZ6Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786349800; c=relaxed/simple;
	bh=jxURVrZrJxl4BSnFlCxdE6TuxtmYnHYt7tKAWjOEtQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hnoJXI/nbE1bTXBRYBVCwHIu+be/0D6sXHyTjBdYhfmh0aD+2a7mv8OdiHbowrUf6LopgS7DmbtWkj/R2+zqOMhD5xbUkEQaeYKsclR2Q1yDA5agGs1E1sh5G7Ulh9wFyW1sDvrFS0SCGRyR0gXBkCkawVd/dKcFdT4853I07sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B6c6g0R1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B6c6g0R1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B6C1F000E9;
	Mon, 10 Aug 2026 08:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786349798;
	bh=vYVtX6o58XSw+uvxL4V9eAqdz08LrGfSfgxuI5BEMv0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B6c6g0R19Hyae9RQQEE+CJM5ydxtmvZiQ7ZoLhzgOuTZUkqrGpwC1PmoZlKx3T9oE
	 TQbaGuxIauj1HmAr5cAV26f72+tNXtC+wYjlFEuyXERibvLrl/Gy2OC5aM3rbsoSVe
	 JYyTox8yar9iqgLG9GxPfeG8Ihv8Fil7KcGVM6ySgHhFply+AiPOIBar7mscE3ccY0
	 G+IAL8NCI7AoVx41SN4dGsFDKhj8czdep4tTC1c9udkAJH4TiyHz8biftJ1I0FXdy/
	 suDC26IQ4rWiWhaM9EXE2tS/spMVLyMaTpLDfDgj29rE9A7WhEw+mYTCA2HVjo6QJh
	 u32xngDKqD/Ug==
Message-ID: <778fef91-0610-4ddc-9d64-e6b45b30127f@kernel.org>
Date: Mon, 10 Aug 2026 10:16:26 +0200
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/19] dt-bindings: crypto: add Rambus CryptoManager
 Hub
To: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alex Ousherovitch <aousherovitch@rambus.com>,
 Conor Dooley <conor+dt@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Palmer Dabbelt
 <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Rob Herring <robh@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, devicetree@vger.kernel.org,
 Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
 linux-api@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
 Shuah Khan <skhan@linuxfoundation.org>, Thi Nguyen <thin@rambus.com>
References: <20260806195519.2703224-1-skrishnamoorthy@rambus.com>
 <20260806195519.2703224-2-skrishnamoorthy@rambus.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <20260806195519.2703224-2-skrishnamoorthy@rambus.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/08/2026 21:55, Saravanakrishnan Krishnamoorthy wrote:
> From: Alex Ousherovitch <aousherovitch@rambus.com>
> 
> Add device tree binding schema for the Rambus CryptoManager Hub (CMH)
> hardware crypto accelerator.  The binding describes the parent
> SoC-level node with its SIC register region and one mailbox@N child
> node per mailbox the host owns, each carrying a reg (mailbox instance
> index), an optional interrupt, VCQ ring geometry (rambus,slots-log2 /
> rambus,strides-log2) and a rambus,cores affinity list.  Which crypto cores
> are present is discovered from the SIC CORE_ENABLE register at probe,
> not described in the device tree.
> 
> Register the 'rambus' vendor prefix for Rambus Inc.
> 
> Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
> Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>

Completely messed order of tags.

> Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>

How Alex could sign after you?

> Reviewed-by: Joel Wittenauer <Joel.Wittenauer@cryptography.com>
> Reviewed-by: Thi Nguyen <thin@rambus.com>

Your SoB is the last.

Are you sure these people reviewed THIS code instead of blanket-review
for everything?

Did they find any issues in the schema which you fixed?


> ---
>  .../bindings/crypto/rambus,cmh.yaml           | 207 ++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>  2 files changed, 209 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rambus,cmh.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/rambus,cmh.yaml b/Documentation/devicetree/bindings/crypto/rambus,cmh.yaml
> new file mode 100644
> index 000000000000..2709e20fb76f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/rambus,cmh.yaml
> @@ -0,0 +1,207 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/rambus,cmh.yaml#
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
> +  The Rambus CryptoManager Hub (CMH) is a hardware cryptographic accelerator
> +  accessed via a mailbox-based VCQ (Virtual Command Queue) interface.  The
> +  host writes VCQ command sequences into per-mailbox DMA queue buffers and
> +  rings a doorbell; the CMH eSW processes them and signals completion via
> +  interrupt.
> +
> +  The management host statically partitions the hardware mailboxes across
> +  the SoC's host interfaces at integration time; the set of mailboxes a
> +  given host owns is therefore fixed and not runtime-discoverable (a
> +  mailbox locked to a host reads as unavailable in the SIC availability
> +  register).  Each owned mailbox is described by a child node.  Which
> +  crypto cores are present, by contrast, is a fixed silicon-build property
> +  the driver reads from the hardware at probe (the SIC CORE_ENABLE
> +  register), so cores are not described in the device tree.
> +
> +  CMH identifies the host that owns a mailbox by a hardware HOST ID
> +  presented on the bus with every access, and permits only that HOST ID
> +  to access a mailbox while it is locked.  An integration must therefore
> +  present a single, stable HOST ID for all accesses to a given mailbox,
> +  independent of which CPU issues them.  On SMP hosts whose interconnect
> +  encodes the issuing CPU in the HOST ID, the integration must provide a
> +  single consistent HOST ID for the set of CPUs that share a mailbox; the
> +  driver neither selects nor can override the HOST ID presented by the
> +  hardware.
> +
> +  Supported algorithm families: SHA-2, SHA-3, SM3, AES, SM4,
> +  ChaCha20-Poly1305, RSA, ECDSA, EdDSA, ECDH, SM2, ML-KEM, ML-DSA,
> +  SLH-DSA, LMS, XMSS, DRBG.
> +
> +properties:
> +  compatible:
> +    const: rambus,cmh-v1030
> +    description:
> +      Identifies the CryptoManager Hub v1.030 IP revision (register map and
> +      command ABI).  A specific SoC integration should list its own
> +      "<vendor>,<soc>-cmh" compatible first with "rambus,cmh-v1030" as a
> +      fallback; that extended form will be added when such a platform is
> +      upstreamed.

Considering how variable the binding looks like, this needs real SoC
compatibles.

> +> +  reg:
> +    maxItems: 1
> +    description:
> +      SIC (System Interface Controller) MMIO region.  The registers of
> +      mailbox instance N are at offset N * 0x1000 within this region.
> +
> +  clocks:
> +    minItems: 1
> +    maxItems: 3
> +    description:
> +      Functional clocks driving the CryptoManager Hub.  The block gates its
> +      clocks internally (integrated clock-gating cell); the host does not
> +      gate them, so these describe the input pins only.  The names, in
> +      order, are "core" (the main functional clock), "core-div2" (a
> +      half-rate clock present only on configurations with
> +      side-channel-protected cores) and "rt" (the real-time tick clock

Don't repeat constraints in free form text.

> +      for the internal timer).  Absent on integrations where a separate
> +      management/power controller owns the clocks and Linux has no clock
> +      handle.

List the items instead with description. minItems stays.

> +
> +  clock-names:
> +    minItems: 1
> +    items:
> +      - const: core
> +      - const: core-div2
> +      - const: rt
> +
> +  reset-gpios:
> +    maxItems: 1
> +    description:
> +      Optional host-driven reset for the CryptoManager Hub.  The hub has
> +      two external, active-low reset inputs -- a power-on reset and a hard
> +      reset; where a board routes one of them to a host-controlled GPIO,
> +      that line is described here.  Present only on integrations where the
> +      Linux host is the management host; where a separate management
> +      controller owns reset (the usual case) it is absent and Linux does
> +      not drive reset.
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +patternProperties:
> +  "^mailbox@[0-9a-f]+$":
> +    type: object
> +    description:
> +      One node per hardware mailbox owned by this host.  The mailboxes a
> +      host owns are assigned by the management host at integration time

So they are SoC-deducible.

> +      and cannot be probed, so they are enumerated here.

Where are mbox-cells?

> +    properties:
> +      reg:
> +        maxItems: 1
> +        description:
> +          0-based mailbox instance index.  The instance's registers are
> +          at reg * 0x1000 within the SIC region.
> +
> +      interrupts:
> +        maxItems: 1
> +        description:
> +          Completion/error interrupt for this mailbox.  Optional; when no

Don't repeat constraints in free form text.

The schema tells if something is optional or not.

> +          mailbox has an interrupt the driver falls back to polling.

Driver is usually irrelevant here and that internal review which
supposedly happen for this code should tell you this.

> +
> +      rambus,slots-log2:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        minimum: 1
> +        maximum: 15
> +        description:
> +          log2 of the number of VCQ ring slots the driver provisions for

Driver stuff does not belong to DT.

> +          this mailbox in host DMA memory.  This is a per-board,
> +          per-mailbox host-memory layout choice programmed into the
> +          mailbox QUEUE/SLOTS registers, not a silicon constant --
> +          boards built around the same SoC (hence the same compatible)
> +          may provision different ring geometry, so it is described per
> +          mailbox here rather than derived from the compatible.  The
> +          upper bound is imposed by the hardware.  Optional; defaults to
> +          6 (64 slots).

Missing default. Anyway, I do not understand why standard number you
express as log. slots-num is a number. Number is 1, 2 or 4 etc. Not
logarithm of something. Do you say: I have log-8 dollars in my wallet?

> +
> +      rambus,strides-log2:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        minimum: 7
> +        maximum: 10
> +        description:
> +          log2 of the per-slot stride in bytes for this mailbox's VCQ
> +          ring.  Like rambus,slots-log2 this is a per-board layout
> +          choice, not derived from the compatible.  The range is imposed
> +          by the hardware.  Optional; defaults to 9 (512 bytes per slot).
> +


Best regards,
Krzysztof
