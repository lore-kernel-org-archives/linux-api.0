Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B68A37269B;
	Mon, 28 Sep 2026 18:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790619531; cv=none; b=Kf3Q8omYobh72rfJtlKiqvtdjmR9H7WCyvyEoEmW3QI3fVkX8ocFj4qm4lBbJAkfgLzYVrlMD8H5OCYl5f9bzSw6CCEu/yCKzIe2fal3Yx8kIaKoMJhmVOsYAgOld9zrfczdBqoh4Rcg+vjc/VcZxUnVhKuhHx+qPyujRpArPbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790619531; c=relaxed/simple;
	bh=K+gm/+Cc9qAPK0prI75QXEUR81iMnLHYkECUNXcg+H0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HIltLqfplqUZdCRkEx7vDc7fBnPpeRBuvrzdtH6t0B3nfZH29P61kjmFCquutQpV/nc1uO4nZLAsXRPrc/la9CQz0iUTV34WyPU/bl0UdfNbwfQIMKcpPPSSzvQygs4eT76bJu94g1nI+ddpYd8gyICrynEZ72t9p/cNlqUKcTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDahCbPk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDahCbPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91C51F000FF;
	Mon, 28 Sep 2026 18:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790619529;
	bh=IngvfdjDTuMxuKWaiC5XQNkdziiuEHqoUpcP04yDirI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VDahCbPkV+RSr4vSZ1HWmkwUpQ/kplhol52IB+WLXyrnPMar5mgI7cZhss+Ge7G17
	 go6E0RRqYMg0QqKIiMnQgb5vOpVDpsh9YGKDXc60lR2r5WMPXbKC0dr4AjCw9rIfgj
	 yNzICd4YdTMd0dcx4wh2BbxmbTUVThYBNlXVqq5iF+cQI8wIgK03FE27niBRpoKOJL
	 DN6TTpxi1FyykohiU1CIcPfEA9siwthZ2XQ8FZw/WHPqDBlBo8CKTQmHN3cjaQcneR
	 Le+tNHmx2qpKojmC561RZeS+UTHSJ/q0Wnyt7hlPO6A9HoE9jiQSISLLwBLycEdKGV
	 mTdaWVAHDVOMg==
Date: Mon, 28 Sep 2026 13:18:48 -0500
From: Rob Herring <robh@kernel.org>
To: Alex Ousherovitch <aousherovitch@rambus.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>,
	Shuah Khan <shuah@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
	devicetree@vger.kernel.org,
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
	linux-api@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thi Nguyen <thin@rambus.com>
Subject: Re: [PATCH v5 01/19] dt-bindings: crypto: add Rambus CryptoManager
 Hub
Message-ID: <20260928181848.GA150882-robh@kernel.org>
References: <20260917225929.2494111-1-aousherovitch@rambus.com>
 <20260917225929.2494111-2-aousherovitch@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917225929.2494111-2-aousherovitch@rambus.com>

On Thu, Sep 17, 2026 at 03:59:10PM -0700, Alex Ousherovitch wrote:
> Add device tree binding schema for the Rambus CryptoManager Hub (CMH)
> hardware crypto accelerator.  The binding describes the parent
> SoC-level node with its SIC register region and one queue@N child
> node per mailbox the host owns, each carrying a reg (mailbox instance
> index), an optional interrupt, VCQ ring geometry (rambus,num-slots /
> rambus,slot-stride-bytes) and a rambus,cores affinity list.  Which
> crypto cores are present is discovered from the SIC CORE_ENABLE
> register at probe, not described in the device tree.
> 
> Register the 'rambus' vendor prefix for Rambus Inc.
> 
> Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
> Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
> Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
> ---
>  .../bindings/crypto/rambus,cmh-v1030.yaml     | 151 ++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>  2 files changed, 153 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
> new file mode 100644
> index 000000000000..a0df35bdc371
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
> @@ -0,0 +1,151 @@
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
> +  crypto cores are present is a fixed silicon-build property indicated by
> +  the SIC CORE_ENABLE register, so cores are not described in the device
> +  tree.  Clock and reset are owned by the management host; a node
> +  describing a non-management host has no clock or reset provider of its
> +  own, so clocks and reset-gpios are optional.
> +
> +  CMH gates access to a locked mailbox by a hardware HOST ID presented on
> +  the bus with every access, permitting only the owning host's ID.  An
> +  integration must present a single, stable HOST ID for all accesses to a
> +  given mailbox, independent of the issuing CPU (relevant on SMP hosts
> +  whose interconnect encodes the issuing CPU in the HOST ID).
> +
> +properties:
> +  compatible:
> +    items:
> +      - not: {}
> +        description: SoC-specific compatible, e.g. vendor,soc-cmh
> +      - const: rambus,cmh-v1030
> +
> +  reg:
> +    maxItems: 1
> +    description:
> +      SIC (System Interface Controller) MMIO region.  The registers of
> +      mailbox instance N are at offset N * 0x1000 within this region.
> +
> +  clocks:
> +    minItems: 1
> +    maxItems: 3
> +    description:
> +      The "core" functional clock, and optionally the half-rate "core-div2"
> +      clock (present only on configurations with side-channel-protected
> +      cores) and/or the "rt" real-time tick clock.  See clock-names for the
> +      valid combinations.
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

Can be simplified to:

items:
  - const: core
  - enum: [ core-div2, rt ]
  - const: rt

> +
> +  reset-gpios:
> +    maxItems: 1
> +    description:
> +      Host-controlled reset for the CryptoManager Hub.  The hub has two
> +      external, active-low reset inputs -- a power-on reset and a hard
> +      reset; where a board routes one of them to a host GPIO, that line is
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

Is there a maximum number of instances? If so, 'maximum: N'.

Rob
