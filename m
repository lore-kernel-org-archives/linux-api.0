Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792589026;
	b=gLXITzAWTEqqMCup60NWBZkyl7woWdOnNrGy4Xrup0gn8bSSru0Oj1dKFXrUIaHN30Mm
	 9ESAtTCBm/BPWiG8RNuOyoywav3LxWtfXT7UnKfqb0hqMZ65/Z9tRTHUzeouODebFE23E
	 2Ldrw9q7vUUm+X9tuAAkVs/FBchRoXNXk+3T2V3tUTRyO0mJSiNuzr6q180/JECGG4BSN
	 HI7viJE9PVmk25rn8HqLRwvL9/Svr6k87BgSBc4GbtZhbd9DY9o6vST6lAKb6A7+Epb9W
	 Ib1xWPLqCuYUGUPAoe5Sy43Agm4qMmbpqUj+M71229Twnge2oiYsKYXDF0AXIw5Oe+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792589026;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=ENEgiLYyZC1rCnAzeRub371bt2VgRo0VClTgBaXb9SQ=;
	b=GxPWus4DTR9qSArTxXdmorCgX5Wmu0ZNms67DWAxa3uV53B7b+3ACxvrF+OUAbkGcqhe
	 wocxPLpU+fFrlUEjMXD+zG5EhtzYw43iZ+OoM4N3grKVOThAJzHf7wFd/fCpGyjgaJCLO
	 bxDc7y74ejVh2FF9VxbA0o8sR1gTmtN6n/uN8DufIxoqrk19G1Oxj+1mPapuAp5oOXifs
	 WH3JpVW6IrBaOLn8I6s6a7gD7MiBAZ5CWkaLyCgLy9bh//GzFFl3cz+bPU+xh9wrYRYa3
	 H4jRqVKObfvDp4eC7tA67BWsw+XVy285srXATbocHSyHNPYvpD7WjTwv52svq1cy2eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=yADG1ECr;
	arc=none smtp.remote-ip=209.85.167.45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF14606A320
	for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 13:23:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACF14606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=yADG1ECr
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5ba357a1929so736984e87.0
        for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 06:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1792589023; x=1793193823; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ENEgiLYyZC1rCnAzeRub371bt2VgRo0VClTgBaXb9SQ=;
        b=yADG1ECr+QObb1QB83+iidmbJj/fobUApZuVsn1YngJx0ZfuONZA+pu4Ic4qUtnpBh
         GkC63lm5wjgFfb5gMxmSAQ1T2MEC4rYKyNJBBZCRDvoNFfdc/1dnbPoawHNFeIMG3cQ1
         dwQhoE+vIJAk+03yuCz00MdNPuLCfWEByg6Xqf6mtFZQHE4dGhAcSwxre3Khenao61eM
         S/YfPRVj5VyHZarKAEdvN1f5q0N5RbEvEKVfa6CCJfAqWlGEaFei/xSUvauLvApvz3jM
         2mJS5acP+BCEntRYDraaf909OwUFD6CronNRivnX9dfLAoUcbHGmy9cQS/fpdfcJEuVV
         IBRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792589023; x=1793193823;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ENEgiLYyZC1rCnAzeRub371bt2VgRo0VClTgBaXb9SQ=;
        b=nOYvzaTErHlLcp7aWdjuulqwQAw1BhuLnUW6OZaDDwq+rgd5CU88FkFmXxvAnujd3+
         sl7Xc9PmO6cuDc394tSllPk3q+VrrE0S2XaVt3VdxKnUa2EKlSWmw7mrzU4ip5y0aY0Z
         poI5DKdAnJDb4EZHWBgeS07l3p0AoXTRHnygb7xkvbFFpmppFwWBsKtcPqNI2WYVjNeA
         4EK3X8Sq1zfONW1AuXkkM9SLX1pWHpOszc8Z4cAVFgXW+eYZvVtby72lrKdyi82yi1M2
         EZMQEUto7kTDxClrDyj9HAk1l5EoeOYHuBkUEQWC3gqX8BkJcDJIHiNa4vRAPUF85JKn
         qIgQ==
X-Forwarded-Encrypted: i=1; AKwUvBwqw+IJ8s40vIfDCF9mFEL5P3NuNGUh2BzygtDQiwYd1aEQxA7/na+MFeg8Bxn7I2nurJ1IYhJqTqQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYL0oQzj0iulrOxK0O7eKNrkJgV8nYrCdYLGyQfVMAipqWIz1Um5
	YoYo0fE1JT7Ij6nfZISna3nygvFktBEpVbbYTRKwGaqAodqPiyjozQYQwn0W71mOFQY=
X-Gm-Gg: AYBFou0Yb15gsOLIh4dOZYBiYOzob++93+Z4FpKNdClQ7WTqMG8kYKSzi1iRFQQ7Gjx
	BCnKmr5H+9UnJW6j/5T1dy8KXATq2Vkh1hQ3J1csJcbNtgBbkVNwLpYAZaYTFqDfa/EuOYLLy9D
	Z305n8usC+8ENzReFB+iAEHrBnX/jo4nDLOh+rq/5CBdtj+j6ORB2U8EuY6o81XYLTz/0wBa0gG
	4Qgu9HK8MtMeH8JS5HyOg2/7v5CsnXSGzQnG+AVInAqK5MG4Ja7QKXFlv104XpdyzsQZd3l6NuK
	gCu5uToKnyTdoKZHWIjEmgz6dA1rIBEbCyIKqpseBR+L9uJCTc/ZOhVQjDZ0y12I64Uo3i8kghC
	mw3YpWbtB7bWIa21e0KNcgTVxM2fcUwtbaNdh+rd8bZAC/3y1FXqU1Vwm9de0N/NmLvgTemqlqo
	O2h0PPlvR0+mSwrFlrtoF2AOQ3vNb2wg2DOws2UTkIfTb/GPka7amp5PxTW8PuEcI+nwZLgxZop
	OxS0PyzFl5mKrFKm1SFcfznlpCWfudV3fzj1eatDzHTIKpExaFNe+cZTC+0489KodQ=
X-Received: by 2002:a05:6512:3c8e:b0:5be:55b6:7a92 with SMTP id 2adb3069b0e04-5bfa1c2d635mr792386e87.30.1792589022381;
        Wed, 21 Oct 2026 06:23:42 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ac4a4f5f04sm2718501fa.32.2026.10.21.06.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 06:23:41 -0700 (PDT)
Date: Wed, 21 Oct 2026 15:23:38 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 01/20] ctlv: Add the schema language and generator
Message-ID: <ati8DWgQb23dV4Dv@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-2-jiri@resnulli.us>
 <20261020233132.793b7e97@jic23-hlaptop>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020233132.793b7e97@jic23-hlaptop>

Wed, Oct 21, 2026 at 12:31:32AM +0200, jic23@kernel.org wrote:
>On Thu, 15 Oct 2026 16:50:34 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Define the YAML schema and append-only family registry. Add ctlvgen to
>> validate specifications and emit kernel and UAPI outputs.
>> 
>> Assisted-by: Cursor: GPT-5.6 Sol
>> Assisted-by: Cursor: Claude Opus 5.5
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>
>Obviously you asked for broad structural review and this isn't that. I'm terrible
>at reading code for just the big picture but feel free to ignore the small stuff
>in this reply.
>
>My python being even worse than my yaml I'll only say that
>part looked plausible to me!
>
>> diff --git a/Documentation/ctlv/ctlv-schema.yaml b/Documentation/ctlv/ctlv-schema.yaml
>> new file mode 100644
>> index 000000000000..38fd56e6627c
>> --- /dev/null
>> +++ b/Documentation/ctlv/ctlv-schema.yaml
>> @@ -0,0 +1,359 @@
>> +# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://kernel.org/schemas/ctlv/ctlv-schema.yaml#
>> +$schema: https://json-schema.org/draft-07/schema
>> +
>> +# The syntax gate for a CTLV family specification: permitted keys, their shapes
>> +# and the closed sets of keywords. Anything needing more than one declaration at
>> +# a time is checked by tools/ctlv/ctlvgen/lib/semantics.py.
>> +
>> +$defs:
>> +  name:
>> +    description: Kebab-case identifier. A dot is reserved for selectors.
>> +    type: string
>> +    pattern: ^[a-z0-9]+(-[a-z0-9]+)*$
>> +
>> +  family-name:
>> +    description: Name carried by family discovery.
>> +    allOf:
>> +      - $ref: '#/$defs/name'
>> +      - maxLength: 63
>> +
>> +  selector:
>> +    description: |
>
>Really trivial but nice to drop | where it doesn't make sense to
>force line break preservation like here. 

Okay

>
>> +      A named attr set, a whole attr group, or one exact attr as
>> +      "group.attr". There are no tuple selectors and no cross-family
>> +      qualification.
>> +    type: string
>> +    pattern: ^[a-z0-9]+(-[a-z0-9]+)*(\.[a-z0-9]+(-[a-z0-9]+)*)?$
>> +
>> +  selectors:
>> +    oneOf:
>> +      - $ref: '#/$defs/selector'
>> +      - type: array
>> +        minItems: 1
>> +        items:
>> +          $ref: '#/$defs/selector'
>
>My yaml is terrible (and all learnt form reviewing DT bindings which are
>undoubtedly perfect :) but random LLM agrees with me that you can simplify
>this as it's a local definition.  I think doing so makes life a little
>easier for reader by indicating it is thing defined a few lines up.
>
>            $ref: 'selector'
>
>I don't care that much though.

Okay

>
>> +
>> +  uint:
>> +    type: integer
>> +    minimum: 0
>> +    maximum: 4294967295
>> +
>> +  integer-bound:
>> +    type: integer
>> +    minimum: -9223372036854775808
>> +    maximum: 18446744073709551615
>> +
>> +  max-occurrences:
>> +    description: |
>> +      A finite positive count, or unlimited, which is reachable only from
>> +      query replies.
>> +    oneOf:
>> +      - type: integer
>> +        minimum: 1
>> +        maximum: 4294967295
>> +      - const: unlimited
>> +
>> +  unit:
>> +    description: CTLV-owned unit, matching enum ctlv_unit.
>> +    enum: [ seconds, hertz, bytes, celsius ]
>
>These are used in here?  I'm sure some are but guessing not
>all of them yet.

Nope. I just want these to be part of the initial schema as it is not
omitted by later family implementation by accident. Easy to pick up by
AI assistents I believe.


>
>
>> +  attr:
>> +    description: |
>> +      One attr declaration. Exactly one primary form out of type, enum,
>> +      flags, attrs and blob must be present. optional-attrs and recursive
>> +      may only accompany attrs.
>
>Maybe worth the yaml gynastics needed to enforce this rather than
>just putting it in the description?  An LLM fed me something when
>I sanity checked how bad it would be and it's only somewhat nasty...
>
>Bunch of:
> oneOf:
>      - required: [ type ]
>        not: { anyOf: [ { required: [ enum ] }, { required: [ flags ] }, { required: [ attrs ] }, 	{ required: [ blob ] } ] }
>
>lines, though I thought there was a more compact way to do it.

Okay, will try.


>
>
>> +    type: object
>> +    required: [ name ]
>> +    additionalProperties: false
>> +    properties:
>> +      name:
>> +        $ref: '#/$defs/name'
>> +      type:
>> +        description: |
>> +          Primitive payload. Integers are always 64-bit, and a bool is one
>> +          byte holding zero or one.
>> +        enum: [ uint, sint, bool, string, binary ]
>> +      enum:
>> +        description: Name of an enum definition; implies an unsigned payload.
>> +        $ref: '#/$defs/name'
>> +      flags:
>> +        description: Name of a flags definition; implies an unsigned payload.
>> +        $ref: '#/$defs/name'
>> +      attrs:
>> +        description: Nested payload, given as selectors.
>> +        $ref: '#/$defs/selectors'
>> +      optional-attrs:
>> +        description: Further nested payload whose placements are optional.
>> +        $ref: '#/$defs/selectors'
>> +      recursive:
>> +        description: |
>> +          The nested payload is one attr set that may contain this attr
>> +          again, describing a structure of any depth. Only a query reply can
>> +          hold one, since such a nest has no maximum length.
>> +        const: true
>> +      blob:
>> +        $ref: '#/$defs/blob'
>> +      min:
>> +        description: Inclusive minimum of an integer payload.
>> +        $ref: '#/$defs/integer-bound'
>> +      max:
>> +        description: Inclusive maximum of an integer payload.
>> +        $ref: '#/$defs/integer-bound'
>> +      length:
>> +        description: Exact payload length of a binary attr.
>> +        $ref: '#/$defs/uint'
>> +      min-length:
>> +        description: |
>> +          Minimum payload length, excluding the terminator of a string.
>> +        $ref: '#/$defs/uint'
>> +      max-length:
>> +        description: |
>> +          Maximum payload length, excluding the terminator of a string.
>> +        $ref: '#/$defs/uint'
>> +      unit:
>> +        $ref: '#/$defs/unit'
>> +      scale:
>> +        description: Decimal exponent applied to the payload.
>> +        type: integer
>> +        minimum: -128
>> +        maximum: 127
>> +      max-occurrences:
>> +        $ref: '#/$defs/max-occurrences'
>> +
