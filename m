Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793821585;
	b=DQ9QdkYTNf/RAF4K5vq+McKfZBBpnIzEEhyWXO+0GbBIIu0D0tzlBe6TujwA/dDNEkqy
	 giqG8P0Ru7QvIelccd2J8H5TlkxXGwrJCJxitkRIhyyTk2cFjaghprXjm1zVL0LG7t8WM
	 zhBO6t9ww7bq5uPW95aCtf5V51Sf/WuuSI/9i+2rESJQ6+UKjLO/V8b902zNzkJ4LpQBa
	 N1EoFTntvJvCtwkXjnx7paIa9U7VKxp+80UfjnSPA8qIApoWgyKFrrAPJJNhkC7SbHq2K
	 yj0+z2zsesOo8ZHEzccqyQuH2op12+iyluiPQnBzC3I7U1Df+3v9KKNiRRY5Lcwq3cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793821585;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=/iOiQOUFj+ZNXsxkV0W7K4UHGpRKtOzL2hr1OPDdR9w=;
	b=lsoEk3aAsocMhmR41kuajYfdPIxkursOSBiIZjBvie97rEEWClHMLR2MXPbsrG5Ykmz4
	 NVCEjho8VbKKB6ZCuryoSL/Nun4dKABsVV5LrcKNOVrWZG930V57u8ofROA/usQtx97k/
	 tEyixWELECIf1kqjCHbGqW6og9K4aNRPu9bXlzErgof6jIUBRM2QFK2OCefZdMaEukWNz
	 lzkrNxwCyFGPEj1fvVqc61HzbAK4RHmyftWs585rpSkppSDyYeS2FnlkTpFyXZyZ/S6Lr
	 qYTCoiYFhPlqSLn/fCVF5XRD3ahqRUZbFRfOdwDYQRq3DCL7WWMsk+tF/IgsErvxlkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=WRBm+GQF;
	arc=none smtp.remote-ip=209.85.160.177
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448BD608CABC
	for <linux-api@vger.kernel.org>; Wed,  4 Nov 2026 19:46:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 448BD608CABC
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=WRBm+GQF
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5361e313e63so10162411cf.3
        for <linux-api@vger.kernel.org>; Wed, 04 Nov 2026 11:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793821584; x=1794426384; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/iOiQOUFj+ZNXsxkV0W7K4UHGpRKtOzL2hr1OPDdR9w=;
        b=WRBm+GQFrwS5Zas3ZL99mrACnUfCSQ6IoeXlzzeD5KKnBqHHgtxYl2c9wviBwKfOJD
         qtN+ZFY9uOU0mlzNZCuwr0exw/fYbp1g7ho5/pM/xUO2KAdWMlMV2RV+eo8CzwSP0PK1
         MgVCvd6blq74OYN7OPzEIJ01+NGUqyNVGsk9oJ9gJnGaU9hlo5GRil1NKdsf3xy0EYAo
         KWR5bpoPTgSvX2xINyPwl/GgNSWpYL76GMZPxcwzp8e6CZ+A0tOfzm6uN9XILruejEOn
         jmRIHZ7FemA5lobw30d7bQdTmz2Zgu/15vEm4Imf92NuvMQXWpZlg1Y/yMPrwX5t4FVQ
         NW8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793821584; x=1794426384;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/iOiQOUFj+ZNXsxkV0W7K4UHGpRKtOzL2hr1OPDdR9w=;
        b=z4pdoYjHAv+eeO4dJ99mXgW24LCywZ8Y2DPCg/nP5PCSsDDAtks8raxDXHd3vNGOTM
         Kq+X6hE3C6x7+cUQioknSlqyC7iUgb+gRZjHyuTdHxbGPXuw4Bg8i+vFj7QaON3T9Dxp
         0qx7wkxaKm21Qsvptehcrmfwmav0/vRcuanK7kukmpQyO+t38HQsI6ybxywnTMDEJD/n
         8CiDN+zGmizWnoBFzc4L3kPuMd8R2sanT1o4U5xtfnJZiXxHkcSNy+NIXMVt3hv/IQwY
         DiU5+2U1WMjjOrZ5UQbThJ7ipbqCMGWH1pL0pC8SgZWqhud54py6Xpo4qbow36ulnaEn
         zXPw==
X-Forwarded-Encrypted: i=1; AKwUvBx7wZKPu6j/dw+kOUmnpkxQ6G+5YT86jliFEaV8kTWZOYu6lm3AF4lp9pcVEOy9SrfcUGklfTXI0qU=@vger.kernel.org
X-Gm-Message-State: APuU4Z8gvLE5B/+BsUHuCumTa1lBXKuBm7BKRUw060nPjLAfrM26RbTa
	9vTYF4spaQhi+C5t7srDHb3V1GJfj0upgthlgvt9BRoM+ud/s1bZxoSSMwioSBjYXTU=
X-Gm-Gg: AYBFou1TiEO/I9C5FHn2ZBx6PKHLV9N1l8/7+RQzxh/4jrH68uqLV82asKXiXSyg912
	R0HzTHItzZRS3U78+zaXC3xwWASxVXzdz7H2bUKgvl8hPHheIKjRh5/NfokaEIijHI75JN0er/w
	Eto4aYWAS4KhWI09/DMsYcuwsMWp8SX5lwCGZv0sw6I4+BCEL38e9W/6fzrAv+ldn5RZOn9iAoR
	C5m0PC2w2FqZL3mnVKMMdnXFosZcuKBxdxRDfrP0Lmp0vQJFuCel4cSgyGxT3fdHG7Z7u1dSy+d
	O3rB8OaVz242m0hy9GfBN9Lj/WBNF9Yt4LFjgBAYddbYQ9Olka039EndnQQsyfBy+xH4lsqf2cE
	R13kqEtubaSrkqdhCqHf3MsdO4hXlENn6HiyS6D2SfvU6EW5f4xZ5YGXGSncqopvbgglq3wLjD8
	qbcD/XgRRlK7pg4QsSVaQ5CUr3BUq+9gPEkIM/HqeLBi/TesJA8iX5no4vHJsXOQZfhjfZ5firJ
	YvcpiV+J84O6QBlyAB89CK606hnanACtZPM3w8KHYDAdzIZcj3/UZ5hkohEhUkd9nW/8JSDT6m3
	GqGrSdEUDa/mDp/y8vbUDObNsH9s0dQkWON4qgWSRbgLR5LkmuMbZkThF8yyruUjkf5mYUp2fXh
	ZlXS3fLtkLhye7Li3W9SNpvTgmhJVCdE=
X-Received: by 2002:a05:622a:98b:b0:535:be07:f31c with SMTP id d75a77b69052e-542b83f684dmr276665021cf.74.1793821583898;
        Wed, 04 Nov 2026 11:46:23 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54b100aba28sm32315511cf.9.2026.11.04.11.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 11:46:23 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xOgwA-0000000HIFZ-2f1S;
	Wed, 04 Nov 2026 15:46:22 -0400
Date: Wed, 4 Nov 2026 15:46:22 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Jiri Pirko <jiri@resnulli.us>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org,
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com,
	drdeeglaze@gmail.com, James.Bottomley@hansenpartnership.com,
	aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com,
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com,
	ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
	rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
	dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 17/20] attestation: Add CTLV operation handling
Message-ID: <20261104194622.GC3889730@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-18-jiri@resnulli.us>
 <auuDcABX27EeTApl@e129823.arm.com>
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
In-Reply-To: <auuDcABX27EeTApl@e129823.arm.com>

On Wed, Nov 04, 2026 at 07:11:44PM +0000, Yeoreum Yun wrote:
> [..snip..]
> 
> > +static int attestation_evidence_request_decode(struct attestation *att, struct ctlv_op_ctx *ctx,
> > +					       const struct ctlv_cursor *request,
> > +					       struct attestation_evidence_request *decoded,
> > +					       struct attestation_evidence_object_request **objects)
> > +{
> > +	const struct attestation_evidence_caps *caps = att->provider->evidence_caps;
> > +	u32 challenge_length;
> > +
> > +	decoded->challenge =
> > +		ctlv_attestation_evidence_get_evidence_challenge_get(request, &challenge_length);
> > +	decoded->challenge_length = challenge_length;
> > +	if (challenge_length < caps->min_challenge_length ||
> > +	    challenge_length > caps->max_challenge_length)
> 
> Hmm, I'm not sure whether this check is required for
> ATTESTATION_EVIDENCE_BLOB_EVENT_LOG blob type.
> 
> for example, if the provider provides two evidence:
>   - ATTESTATION_EVIDENCE_BLOB_PRIMARY (might attestation token)
>   - ATTESTATION_EVIDENCE_BLOB_EVENT_LOG
> 
> might challenge is reuiqred for generating the token
> and this would be marked at min/max_challenge_size in evidence_cap.
> 
> However, in case of eventlog, it wouldn't require challenge.
> for example, TPM event log or CCEL event log.

Right

> Do we need some field on attestation_evidence_supported_object whether
> it requires challenge or not and applies this sanity check per the object?
> 
> Otherwise, to get eventlog, it would need to send *dummy* challenge
> always.

I wonder if we should have two interfaces here for signed and unsigned
evidence? It would be clearer for userspace then when it needs to
provide a challenge or not.

Jason
