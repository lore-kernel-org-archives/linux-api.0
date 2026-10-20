Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792535502;
	b=u+7xLY/bCqtLuJUeV0bTR+EQudMv5JnBfl2sRXo0WMgj/VDuDIAfSs1Sq8J2Oa51H2aS
	 N9DnN4m07DJiDByKSHXuC44At02thW+DF1pY8WBvh80gLSoeaTPMMxLXVhLMUQa2KSb9M
	 1VK/XEtcoZqBoY1Hn1zjNlyD4WJQbvroCOGKfv40YkfGyeYP8Rr8GF9I8WD7qpOsOr9qU
	 EWzFuRLOw7zqMqtw+AJkw4NWDW9pHho5ZZf4ujIZ/uTxfSBdcYqdzTB5+Fkl0kR3IOBgq
	 podyn743fKqQnOaNNO0KVRkIvHGrc9wuVzX2RuuqWpQIezKCobZYMlQW7Ju+j1qeCEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792535502;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Bnu+kNnMExiYGspJcW2RNy7rTvfoxn48MnVTXTVovA0=;
	b=AvtbagAaFhb5mW6Vux9o5ycJr6MvQRzwvg5pzmOwjdxEMVBw92Eff4crLX7e2+rqxXA8
	 KC/juIZWkAJk92icyoAl3JV/yTFM+mSTn/7perQBAf4whKgtuI3Z27o2/ry/m7npQwNok
	 mJTt+93xSM85CrFnNlhXRIGfSxouqeZNzlvETuyLMbeKsXBp2Q+TtsUDCoSAwVG9zCIh5
	 Vma/KyqfvyZzgZdaXKEpDj3dnHQH3i9KWf604u9lx79A1JhEcmEDoVGfOnvpiYWB/OgIY
	 eAFYPT6GoK/PbO2BT8OQR2zf2luPAIBaytiiHswMt0NXsL6f1ztDA8btDdzFG0Uyhng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k7pe5AHs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446C0606A319;
	Tue, 20 Oct 2026 22:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k7pe5AHs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F37D1F000C9;
	Tue, 20 Oct 2026 22:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792535501;
	bh=Bnu+kNnMExiYGspJcW2RNy7rTvfoxn48MnVTXTVovA0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=k7pe5AHs+MjYWAJU/+nDIHLefrMV6rK8MaLzcSFNAFwG3iZmzaDghijG+jjSYyCXs
	 QzX52yF6+I4DTsIx/PzMZkh3fptZYABZHvlEcX8q3f5VXokzxU8NenlyncUGWWR4JX
	 O82pyZEEn1V3ba1OwE7N8DRRKSpRE9lMPBzeSFDxh1Bm0lOieLdJCr7uoWyEcBvLLK
	 A+/t1QRiyeTqNeSiWsUKg2PnXLUNKz+LqbTE9IUiMsZPXdFuOu2BzChKUbfr0yHqwd
	 mnctzIeIEvGwE1CdeHlnX/snS4Gl4jNjgnjtUVX3He4rb0eAsn/i8vp11p1LtUIINh
	 IKUsCe2jhL61Q==
Date: Tue, 20 Oct 2026 23:31:32 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com,
 lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
 cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
 James.Bottomley@HansenPartnership.com, aik@amd.com, jpiotrowski@nvidia.com,
 qinkun@google.com, pgonda@google.com, alistair.francis@wdc.com,
 ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
 dave.hansen@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 peter.fang@intel.com
Subject: Re: [PATCH RFC 01/20] ctlv: Add the schema language and generator
Message-ID: <20261020233132.793b7e97@jic23-hlaptop>
In-Reply-To: <20261015145053.3664509-2-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	<20261015145053.3664509-2-jiri@resnulli.us>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Oct 2026 16:50:34 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@nvidia.com>
> 
> Define the YAML schema and append-only family registry. Add ctlvgen to
> validate specifications and emit kernel and UAPI outputs.
> 
> Assisted-by: Cursor: GPT-5.6 Sol
> Assisted-by: Cursor: Claude Opus 5.5
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Obviously you asked for broad structural review and this isn't that. I'm terrible
at reading code for just the big picture but feel free to ignore the small stuff
in this reply.

My python being even worse than my yaml I'll only say that
part looked plausible to me!

> diff --git a/Documentation/ctlv/ctlv-schema.yaml b/Documentation/ctlv/ctlv-schema.yaml
> new file mode 100644
> index 000000000000..38fd56e6627c
> --- /dev/null
> +++ b/Documentation/ctlv/ctlv-schema.yaml
> @@ -0,0 +1,359 @@
> +# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
> +%YAML 1.2
> +---
> +$id: http://kernel.org/schemas/ctlv/ctlv-schema.yaml#
> +$schema: https://json-schema.org/draft-07/schema
> +
> +# The syntax gate for a CTLV family specification: permitted keys, their shapes
> +# and the closed sets of keywords. Anything needing more than one declaration at
> +# a time is checked by tools/ctlv/ctlvgen/lib/semantics.py.
> +
> +$defs:
> +  name:
> +    description: Kebab-case identifier. A dot is reserved for selectors.
> +    type: string
> +    pattern: ^[a-z0-9]+(-[a-z0-9]+)*$
> +
> +  family-name:
> +    description: Name carried by family discovery.
> +    allOf:
> +      - $ref: '#/$defs/name'
> +      - maxLength: 63
> +
> +  selector:
> +    description: |

Really trivial but nice to drop | where it doesn't make sense to
force line break preservation like here. 

> +      A named attr set, a whole attr group, or one exact attr as
> +      "group.attr". There are no tuple selectors and no cross-family
> +      qualification.
> +    type: string
> +    pattern: ^[a-z0-9]+(-[a-z0-9]+)*(\.[a-z0-9]+(-[a-z0-9]+)*)?$
> +
> +  selectors:
> +    oneOf:
> +      - $ref: '#/$defs/selector'
> +      - type: array
> +        minItems: 1
> +        items:
> +          $ref: '#/$defs/selector'

My yaml is terrible (and all learnt form reviewing DT bindings which are
undoubtedly perfect :) but random LLM agrees with me that you can simplify
this as it's a local definition.  I think doing so makes life a little
easier for reader by indicating it is thing defined a few lines up.

            $ref: 'selector'

I don't care that much though.

> +
> +  uint:
> +    type: integer
> +    minimum: 0
> +    maximum: 4294967295
> +
> +  integer-bound:
> +    type: integer
> +    minimum: -9223372036854775808
> +    maximum: 18446744073709551615
> +
> +  max-occurrences:
> +    description: |
> +      A finite positive count, or unlimited, which is reachable only from
> +      query replies.
> +    oneOf:
> +      - type: integer
> +        minimum: 1
> +        maximum: 4294967295
> +      - const: unlimited
> +
> +  unit:
> +    description: CTLV-owned unit, matching enum ctlv_unit.
> +    enum: [ seconds, hertz, bytes, celsius ]

These are used in here?  I'm sure some are but guessing not
all of them yet.


> +  attr:
> +    description: |
> +      One attr declaration. Exactly one primary form out of type, enum,
> +      flags, attrs and blob must be present. optional-attrs and recursive
> +      may only accompany attrs.

Maybe worth the yaml gynastics needed to enforce this rather than
just putting it in the description?  An LLM fed me something when
I sanity checked how bad it would be and it's only somewhat nasty...

Bunch of:
 oneOf:
      - required: [ type ]
        not: { anyOf: [ { required: [ enum ] }, { required: [ flags ] }, { required: [ attrs ] }, 	{ required: [ blob ] } ] }

lines, though I thought there was a more compact way to do it.


> +    type: object
> +    required: [ name ]
> +    additionalProperties: false
> +    properties:
> +      name:
> +        $ref: '#/$defs/name'
> +      type:
> +        description: |
> +          Primitive payload. Integers are always 64-bit, and a bool is one
> +          byte holding zero or one.
> +        enum: [ uint, sint, bool, string, binary ]
> +      enum:
> +        description: Name of an enum definition; implies an unsigned payload.
> +        $ref: '#/$defs/name'
> +      flags:
> +        description: Name of a flags definition; implies an unsigned payload.
> +        $ref: '#/$defs/name'
> +      attrs:
> +        description: Nested payload, given as selectors.
> +        $ref: '#/$defs/selectors'
> +      optional-attrs:
> +        description: Further nested payload whose placements are optional.
> +        $ref: '#/$defs/selectors'
> +      recursive:
> +        description: |
> +          The nested payload is one attr set that may contain this attr
> +          again, describing a structure of any depth. Only a query reply can
> +          hold one, since such a nest has no maximum length.
> +        const: true
> +      blob:
> +        $ref: '#/$defs/blob'
> +      min:
> +        description: Inclusive minimum of an integer payload.
> +        $ref: '#/$defs/integer-bound'
> +      max:
> +        description: Inclusive maximum of an integer payload.
> +        $ref: '#/$defs/integer-bound'
> +      length:
> +        description: Exact payload length of a binary attr.
> +        $ref: '#/$defs/uint'
> +      min-length:
> +        description: |
> +          Minimum payload length, excluding the terminator of a string.
> +        $ref: '#/$defs/uint'
> +      max-length:
> +        description: |
> +          Maximum payload length, excluding the terminator of a string.
> +        $ref: '#/$defs/uint'
> +      unit:
> +        $ref: '#/$defs/unit'
> +      scale:
> +        description: Decimal exponent applied to the payload.
> +        type: integer
> +        minimum: -128
> +        maximum: 127
> +      max-occurrences:
> +        $ref: '#/$defs/max-occurrences'
> +
