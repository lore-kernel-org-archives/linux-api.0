Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814887;
	b=HH+jFQMTwvQPUO5GrouUbhfsoIOuAOtscYjB764CEwLZ9odwxHX48hheqNwTeaGvtUGq
	 YL3ui2j4YhezJ0T5pet0x75BxUHwy+HqVMjlvgPgqKwEeBAKE02H4AS3zKt3X0wOl57PQ
	 /ZCaMcKTfX2KiR0Au2GfwVYhy59kt5/9qR4Me2LF5vnc6pFSWqbinQuNEVsKYgR2WoS/L
	 rqZtIeoGs1QdsAaLfWYxoYaBMH4PMHGrkO7pBhF3lVz9J8fAzMY4E6NsF87c56SCV51Wu
	 FVz16DXpmhlhoPs4si2fVrtKUoOsAfyq7y0vplZZhuAj+TLIN4hPr2D/YjrHq+yx4JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814887;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=a8PVgr6ypDrmvyZQYT+mIAJLHr75TSjPc21F4dgd8gQ=;
	b=Gxx/H3wxY5ZlU8prNpgBsIfSWyd6y6dqwyD+Dh8RPULdaWPfJJhmp0uuly8ZER8oaMlL
	 8lBmcFaXV+pKNLxZA3ZxUKPo56BvftGjoO3nnO40rMbglZgLH0Hcwhmv5fghp4KdozTSC
	 HLTCYBOxGzbsSZb7+xMdJfWPy1JL5z5fjvNO1kLpTtDzTASEvfzZzZKGmF0n2+wu4LjWN
	 htYaqGQZdnmLDHPFhrP40g1x9oGUD8u3fSfkVRSu+mZgQZLCw9vWV3PChHsi7SJDoQJKj
	 Is5Y8jooI+FGzgkVsPCfAAcdXat/DxW+bHicGyjTmohCyb9ttpP5cDwz9Gs2eXguL3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=INpwrSmc;
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6613C606CFC8
	for <linux-api@vger.kernel.org>; Wed,  4 Nov 2026 17:54:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6613C606CFC8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=INpwrSmc
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93e635220b4so92229485a.1
        for <linux-api@vger.kernel.org>; Wed, 04 Nov 2026 09:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793814886; x=1794419686; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a8PVgr6ypDrmvyZQYT+mIAJLHr75TSjPc21F4dgd8gQ=;
        b=INpwrSmcSZ3/FfNbUp3Zcr+7zlKzli+O6Uz28XKAuaFHCd6G1aFXVW+Kr3yO5Ukz+j
         ffDXRlN6wtFTSSL1fI87DbOCN5vN+Dc416Nx6rDo4BG87l6cEysDdTsz9/v6agED2t+J
         az1Qc3jEPHGJciuqX8c8qHkclvi7nCxDnvEXRAWlfbwS4b/tczJBghfuvNFFt5Sen/Eu
         CngVW0iXdQ5aqtzO5S5pQGC/GojetaWvMaM/79HB0aZi9AGJnQGdsr25FTscWCuemx6V
         59aB6uINYARVi1TbzM33RDdQMxcq9J/VGqC7mlwisFA76vBco1Plqb7SMZBj/4wLB/55
         +vlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793814886; x=1794419686;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a8PVgr6ypDrmvyZQYT+mIAJLHr75TSjPc21F4dgd8gQ=;
        b=mglw7WX8SRv38XCaCKbOioylyOMAysvv5IHrsOlDHECgRFWzZsB7yZEhWT8qdOr624
         6+Rx/wG0MLbM6cOJeQIc2x+Jh42+Fd3PVLBvKmYTAcOprfyBT71LBNbw2N/KQwptFcMl
         6BlOSL4hAXgsnSHbHXGF3h1LjWWreXwCyUmF6tnE+N3EokZsbjcAFUjfmogC2DIttouR
         Vfksw8QlO0KKTvvzONLfJ3xvINZjvAKgUGaKBkrdww0TXmHaCj8+a7g/PuXu9m0Qz7ML
         PvUXIEf94/FgN4Xanly/5rxm32XOvsRyTKonLwS1BrYmxKfhMkGOhB4NqQAoyVa24clT
         l/PQ==
X-Forwarded-Encrypted: i=1; AKwUvBwZsg7Ihop8s6fhDv97xfcluXx8WPeQzr5mOzVOGylP8aJ/+ZmySyAtzgcQjmcSx/eqGX9+KiMI2qQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z956sarb7u2tdc8ml4OK5w1E2137VzKRAVocZHgV4aC58Dup6j5
	YNVaRhjkYPATuAYXhL2e8jiM9SKHuYSus2KOKo/1e1aPUYfoxWoYFZ7GlndSRr6sOrM=
X-Gm-Gg: AYBFou1lgu6JKJrdZqxepghM+jsZ5tFL8m4afvnTThiOe/1hMdgNpBuYp9loCZp5ua7
	1j+Z6HB/69XR4cEFXNCoENYUOIYAGGR1gh4/SY23wpSg53VCkdp85exT+kKuGbz2etXmsD9zAgL
	ERA8EZJ8aiT0AIokc+1hb9ZQbcxN1vakrV7zdwppEEAEmeXzEDWa76YZKVRqPs7QaS9705qGtUf
	wnAAZWs4lAdQmt324WXvhiKaW2mbkxsOXlsA60Cz4A5pxdXYPt28fflWOKi7vvesnRofzhzEKq1
	Jz5pVk5ZJCf8oD4N6OjKnCisjA6sgN9PhnSuwnOLIvz0Tgf6KfbiA1adpNPtn3hKRZOIqMt3IdE
	BmUmRfAL4PFnAsecZNzG288fvqFTz79ignSZcH/uVRgKEp6QH5TeyT9MOQOY69pOxWRWmp1Lddj
	9fO6Kz+csNOcVKTBTauU3oEXuv0odcaWqJCt7tOt3NFJihNEq4WVzREnAmljlTcqyd3wpHEW3lr
	cVRLP1BjNeWHmAOGTCssvIQmOYgTnKWmRUDs31i17sj+JUOl3R4GgGOxQ4UC404oXlYlLMG0Oku
	JO/MMxVTqGE4lQtwpD2Hdl0uywesaBo0c41NdKvE7q9OG6bhkH9tlP0zYKONerclTT4ax3YdWV2
	jKH5usZrgRw==
X-Received: by 2002:a05:620a:4155:b0:93e:d364:c9fe with SMTP id af79cd13be357-944216970cemr2702179085a.40.1793814886203;
        Wed, 04 Nov 2026 09:54:46 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-945d479a7easm257041185a.12.2026.11.04.09.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 09:54:44 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xOfC1-0000000H1Y6-00br;
	Wed, 04 Nov 2026 13:54:37 -0400
Date: Wed, 4 Nov 2026 13:54:36 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 14/20] attestation: Add the base family specification
 and generated files
Message-ID: <20261104175436.GZ3889730@ziepe.ca>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-15-jiri@resnulli.us>
 <179302367452.58760.3782556786585774917.b4-review@b4>
 <auSxxPM5z8BzgNm3@FV6GYCPJ69>
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
In-Reply-To: <auSxxPM5z8BzgNm3@FV6GYCPJ69>

On Fri, Oct 30, 2026 at 04:05:13PM +0100, Jiri Pirko wrote:
> Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:
> 
> [..]
> 
> >> +
> >> +/* attrs of group cap */
> >> +#define _CTLV_ATTESTATION_ATTR_CAP(_attr) \
> >> +	_CTLV_ATTESTATION_ATTR(CTLV_ATTESTATION_GROUP_CAP, _CTLV_ATTESTATION_ATTR_CAP_##_attr)
> >> +
> >> +enum _ctlv_attestation_attr_cap {
> >> +	_CTLV_ATTESTATION_ATTR_CAP_EVIDENCE = 1,
> >> +	_CTLV_ATTESTATION_ATTR_CAP_MR,
> >> +	_CTLV_ATTESTATION_ATTR_CAP_MIN_CHALLENGE_LENGTH,
> >> +	_CTLV_ATTESTATION_ATTR_CAP_MAX_CHALLENGE_LENGTH,
> >> +	_CTLV_ATTESTATION_ATTR_CAP_MAX_TOTAL_OUTPUT_LENGTH,
> >> +	_CTLV_ATTESTATION_ATTR_CAP_MR_FLAGS,
> >> +	_CTLV_ATTESTATION_ATTR_CAP_OBJECT,
> >> +	_CTLV_ATTESTATION_ATTR_CAP_BLOB_CLASS,
> >> +	_CTLV_ATTESTATION_ATTR_CAP_FORMAT,
> >> +	_CTLV_ATTESTATION_ATTR_CAP_REPRESENTATION,
> >> +	_CTLV_ATTESTATION_ATTR_CAP_MAX_LENGTH,
> >> +};
> >> +
> >> +#define CTLV_ATTESTATION_ATTR_CAP_EVIDENCE _CTLV_ATTESTATION_ATTR_CAP(EVIDENCE)
> >
> >I feel like there are too many layers here for a code generator..
> >
> >enum ctvl_attestation_attributes {
> >   CTLV_ATTESTATION_ATTR_CAP_EVIDENCE = CTLV_ATTR(CTLV_FAMILY_ATTESTATION, 2, 1),
> >}
> >
> >Do the intermediate constants add anything?
> 
> True. I originally had it like you suggest, I changed to enums to avoid
> the explicit numbers. But you are right, does not add anything.
> Changed back.

I was also thinking that having the explicit numbers makes it more
robust if someone does backport. We should try to have everything
explicitly numbered in these generated files to prevent subtle errors
like that.

Jason
