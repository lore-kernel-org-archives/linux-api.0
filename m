Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793881978;
	b=TkgNMvxii/4QsQqYTcrHprKxBtdx112szFCrSlE9kmpGhW8dg926BTdZKtjR9/9O8JM7
	 Hsmeorsk0E9nqLonQDuLt/SxoZJjp0CGW0yCMOBm5wPSZtiGIweKPSDSdtcLAe9u5C86k
	 d6fuzag1F0z92SO0UEMHDEnSxNgwZa0DOuXmITJUUCb5E0Kl0gs0b+Z1G5zvHjJ3wGOKc
	 WXeLOYABT5VpolNwqiZpJJLV8MpMGFyfVxhmOexS1Z8iMop8rQPHwG8cggHB+bVb4RqW6
	 ov4Kw5ltAWmbXP1lYZV1iOlfArhtidXhJ4xW3WuBa7fPTnNOcOGpDmgtWauf2ydYVLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793881978;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=RcJPtti5GFvFEoOYZYt06D/AhFo3icPnTOuzdt+NBsE=;
	b=ql2rzYexO/alO8XZTKA8Ft2+d3CgxAnbBsSneQMxD/LV6UHvDKXVKVr0Z7BI8XXBuyU7
	 JUVriK+Tgh4oDdACg2juKP+J2yZvwJE+L5xRQ21e/pUy4PBoBh6AT5UPw7KulvrZuFIZb
	 KobyjNNku09qQj5pRcU9bbpnESPggU2lYCLOK64ap65AWy0uX30B+GTAK7dl6oWr0eHCc
	 Po+9mds6gZ5uT1b8v6mnaWUCX8heO/3TfxJ7l5Nvw/ZWV7ykNsKvtKe+y5zzKrQVOUkOF
	 wDmlZNVPTd34WxTr4qtm4mY3ofr5akpmMsp/+ycfwAjAyLyMfm9gEf6zImYWhjfxNAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.167.50
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EEF606A32E
	for <linux-api@vger.kernel.org>; Thu,  5 Nov 2026 12:32:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53EEF606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5be47aa555cso1566955e87.3
        for <linux-api@vger.kernel.org>; Thu, 05 Nov 2026 04:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793881975; x=1794486775; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RcJPtti5GFvFEoOYZYt06D/AhFo3icPnTOuzdt+NBsE=;
        b=cCtFJSjXtpRSezyNE06wb3mNCryoz4ZPMqTXXg9EyTCJZDz7c1Wwg43Xnz2iDZHF9h
         uoCWVLQ8jvnyNWaRYluSpDmCHcdouiOJqpYN9KBvHh7ma3RwL36T1cBdawdpqOMfO/a1
         D1maF55YHx7FUilZtWynmISNmN56ev+z3BACC8vviL7dY4cTVG/suNv+f41imfxIare+
         C+bWcbedtAvtUrVKoW0m4EHeVcV77/6F/wIkQEtfvtcI0MozKYY2HozTWAUqXlxvcYfr
         NNTPhbfo1Y4AwQsaGifksj17DoQg1AoaBDPOa/kjNoLrOyT0vE5GD0k95/0RPFy4NjWV
         +K1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793881975; x=1794486775;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RcJPtti5GFvFEoOYZYt06D/AhFo3icPnTOuzdt+NBsE=;
        b=cfHc+j5/950/1GEzc8vOBzuSgs+XEHmrIwfZeIFsaw1C+fjFOa0/gFQR0RkCxwORhK
         oiQCdhZ1AWWg0E8cuG0k+2JjSscu6kocGfTzjI7n/83IX9kVIRYzXPOBker0gqXfvBey
         wzUDHqDRI206UOE3sRqe8jnpgv9df+NoHyFVQOaM5k/1kM1klYrqXIUWGrSakEpp9Y2Z
         YoJbM2fFWHCalGWB23IleefWeXVf81SwDMYg+RJvsUsmp+rlBNCLkmuEM0GfhkH1VDZt
         5Zh/0R6AzsVpMUe5mfth8PNGfmfBp/LZfc8ggM/E+GqGcn0meIhHdoD6IGsPP4YLqAeq
         wl4g==
X-Forwarded-Encrypted: i=1; AKwUvBxgNAl8U058Lc7TPhlKQEaZHdoZUcTLLUlDa5UPJoy/uPnkPFjcJMRMd3Ld+7jq9UiGCkVpVJ1Y/mM=@vger.kernel.org
X-Gm-Message-State: APuU4Z90isrhfDOsT+wgz2Zllq5fSEe88gmgMuXdDQ2R+aXbvbd/LY4f
	cdHKJ1enbv3RTO/jQwlXlEu3EaFH7kn8vbahJuNrGt5px1jnm7ASTKAYEfRO9JzgMvo=
X-Gm-Gg: AYBFou1A7simX45EWgcORrAYXGUrm+oaL43Gm9jWhYzWPEPEIjzy4kM3KhXCFwTylU9
	nX0DdQOyQs7Vai0Z9Xmp70JX2FmdbOScyAQjy5CAYDvyUy2YDYwWdX2HOugF35Q9m/F38T+yhlM
	TuqPsb3muYOyx1KHnCet0zwPY1OOEli1a2xU8HhohqoqwU0jHUewkha5q1rjYwmsuOfMN6tEi1w
	Ak9cVjKUFAU96z2f/wINPCcn9oxspNx9MDySSysF9tCH1HeDPiIxB2pHjWRRHcuqC45+MtM3x8p
	z7FbNPP/h+qbE+sEz0/JrFJu6sGOaLodrfi94xS7YWGc0BShogaMARvx1LUlxJZSTmpTE3LdvQt
	UNiE3Gsv/PZ6uP65Yv5pfcdc5IFUIOUofF6Qcq5fbkeuiFvK5/E4nXoODistWi3u2sV4ovKJQ3A
	Xvbnvv+XOHpeYoKU+4PBZtc1tnb2wgNq07MaFg3f2NJLwRkdmQcQaGFGbAN6sQYLZBjgEX+g6mn
	1GQ66+FUZNAuV4qHy/+6v0IZSjK2PIrqt1VCju/BJbdL+x5micXMV351mFgqzuvlvPllyJFkK3l
	mwonZ872KDdBR1G87591nF7mjl3vHOpu3a4dQwk=
X-Received: by 2002:a05:6512:3056:b0:5bf:b96b:2c75 with SMTP id 2adb3069b0e04-5bfd957c416mr7135190e87.37.1793881975197;
        Thu, 05 Nov 2026 04:32:55 -0800 (PST)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bff38ab170sm875824e87.16.2026.11.05.04.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 04:32:54 -0800 (PST)
Date: Thu, 5 Nov 2026 13:32:49 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 17/20] attestation: Add CTLV operation handling
Message-ID: <aux01NUd85PabtZu@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-18-jiri@resnulli.us>
 <auuDcABX27EeTApl@e129823.arm.com>
 <20261104194622.GC3889730@ziepe.ca>
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
In-Reply-To: <20261104194622.GC3889730@ziepe.ca>

Wed, Nov 04, 2026 at 08:46:22PM +0100, jgg@ziepe.ca wrote:
>On Wed, Nov 04, 2026 at 07:11:44PM +0000, Yeoreum Yun wrote:
>> [..snip..]
>> 
>> > +static int attestation_evidence_request_decode(struct attestation *att, struct ctlv_op_ctx *ctx,
>> > +					       const struct ctlv_cursor *request,
>> > +					       struct attestation_evidence_request *decoded,
>> > +					       struct attestation_evidence_object_request **objects)
>> > +{
>> > +	const struct attestation_evidence_caps *caps = att->provider->evidence_caps;
>> > +	u32 challenge_length;
>> > +
>> > +	decoded->challenge =
>> > +		ctlv_attestation_evidence_get_evidence_challenge_get(request, &challenge_length);
>> > +	decoded->challenge_length = challenge_length;
>> > +	if (challenge_length < caps->min_challenge_length ||
>> > +	    challenge_length > caps->max_challenge_length)
>> 
>> Hmm, I'm not sure whether this check is required for
>> ATTESTATION_EVIDENCE_BLOB_EVENT_LOG blob type.
>> 
>> for example, if the provider provides two evidence:
>>   - ATTESTATION_EVIDENCE_BLOB_PRIMARY (might attestation token)
>>   - ATTESTATION_EVIDENCE_BLOB_EVENT_LOG
>> 
>> might challenge is reuiqred for generating the token
>> and this would be marked at min/max_challenge_size in evidence_cap.
>> 
>> However, in case of eventlog, it wouldn't require challenge.
>> for example, TPM event log or CCEL event log.
>
>Right
>
>> Do we need some field on attestation_evidence_supported_object whether
>> it requires challenge or not and applies this sanity check per the object?
>> 
>> Otherwise, to get eventlog, it would need to send *dummy* challenge
>> always.
>
>I wonder if we should have two interfaces here for signed and unsigned
>evidence? It would be clearer for userspace then when it needs to
>provide a challenge or not.

Isn't the challenge field provided/not-provided enough?

Currently on the introspection side, device-get op would provide
challenge-lengths array:

        evidence?:
          challenge-lengths[8]:
            length?: uint(..4096)
            min-length?: uint(..4096)
            max-length?: uint(..4096)
 	  objects[16]:
            blob-class: evidence-blob-class
            max-length: uint
            blob-instance?: uint(..u32-max)

I think it would make sense to have challenge-lengths array per object:

 	  objects[16]:
            blob-class: evidence-blob-class
            max-length: uint
            blob-instance?: uint(..u32-max)
            challenge-lengths[8]:
              length?: uint(..4096)
              min-length?: uint(..4096)
              max-length?: uint(..4096)

Then the unsigned object would just simply have challenge-lengths empty?
