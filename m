Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372719;
	b=zDvHkA+f0d+DRV0tqAgV7bMkfEH/OjJPjS63kmHurlRjYLISTwG8gSz+wAnRvtThaoRY
	 daUEJ2zZFHjXx/gg2yJuRwxtn+x/O13sE3L2TupaBXcULw9qtHzTWIxpfan52+XMz2PYi
	 PTe2t/5sd7cT5LsT3h1bknj6JE2o+21bVY4fgcmnfnBm3vTCM/EanqyeMTYpHGWMXh1eR
	 TXJdk3v/JztxtZdLnq/G1lJnySCNXHvIQ41J6gpidNYCBImW3XyDRtZUZ1zQpdurASfMj
	 QQpDCXbP9C430qAuid7vkmXg6VnInHf7z6Q+1COM6wWTW3eYwIwJuuvYmDOFYv7361w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372719;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=8skhpE8x/+Won6i3+XD12raNMCS4xOoCCKoDLeKTESk=;
	b=Rvs02NeonEeS+U3Yq9piD5GdTJqNVsEHMfgGXltaH/mCLkjcXKiq4FmVTBBJzlpK19Yi
	 zsPN2Pc5LXRlhZh3OGJJuRPsuPPIWAV3ywOiCoQ3uq7jB5tufYdtY3qTTjzHWG9OAYv5U
	 1WvCbWEemfNw+AjryGT8+fpepW9EixAFiJpPL/gMnwH1L4UiaABabsXTz46usKAuM5ePW
	 Qgqj+Ry9tFNNUSoCvFRLNIfKpH+nQG/CphZLq8tPTJ9mdFOlh/tSu241aRfUwy96bPrEf
	 KUbfd5DMj/7sQFhlqYDLZ98829DQSARuPSZTSi2I1tsO/p6wYqtbvC67JzACEY5XsgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=czkACChM;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDAD606A31A
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 15:05:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCDAD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=czkACChM
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso467869f8f.2
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 08:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793372717; x=1793977517; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8skhpE8x/+Won6i3+XD12raNMCS4xOoCCKoDLeKTESk=;
        b=czkACChM1Vp//qoKfk5C/DvEMQvaO2yxTtnTnNrUz1iZrGkpmjYA7sRpCOkiK85OR5
         DKyVNu3yHScYnpTV8mEyNjy0GM6AiGkEY+yqMV2kwhj4nogM5hBtnMNrDyDvhJfUP91Y
         2qLHj18b3y+ItwylHnK3AxAJpQcnWODG8q5TOy1izMOxysmu/gE3PBKDvsyiMMeYHPdN
         L37BWcbW4GBGw63knHhhcjI2CyLf8W45aZwoP+DUdcfn7pfklTtyoTc13Ps5EzD68ze2
         PhwKJwRPpHLlcw1quPe3gfGrKyhVNOtKuxcCOGPE+MqRlL4wQREaJw+p9SN5GR4rJNeH
         4qQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793372717; x=1793977517;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8skhpE8x/+Won6i3+XD12raNMCS4xOoCCKoDLeKTESk=;
        b=Tkx4h7yFWnga1eHnGhDbh9vNRYYELTgtYykdi+vuIairy3CaI3TZUP063IH6iMiEVm
         EvhZI2ovo+i+BCVy2KTMccBDO0cBSVQK4lBuiDWxnwksTDUPoFnfQuOBRb07PpNlSYpV
         rec+7PBRa8ZtSIWy6H3sjF/fudckdepx5YqO2N88ow3zzTnyPKssAAopN7Jnjm/5/XI3
         DoGw0dYHg/JB6LAzbPZIJwpRfMLoPVikKnS+R6gqxPMQ2zrHzlfmWYAGR2bpvhqFXzwL
         QWpew8Axs+jswmiXm/NpdNwvkMbe+wd+6f8sBpiWRK8r9gIpL2xkkXHB85l+cXPFxbAc
         rueQ==
X-Forwarded-Encrypted: i=1; AKwUvBxyFP5+Mjv5A5jl4ixP997GB6FUv3XZlZtHCepElpNFA7MZULE4YgEpOGcFhbUOHPKjIqgJdIjoc3w=@vger.kernel.org
X-Gm-Message-State: AFq9FYKUoV3J2OtvAgNJsP/NxSjvezq59iwxHU6kfd+RKJY8v0x03i/A
	kWsl1SMyWSj8ac2on3kEL63xRBUriu+rfxNggFbIRDV7zxBWVQF42mHR81ubY7W9NwY=
X-Gm-Gg: AYBFou3TRHnwjnRDTk/oxHXBtggLUCUh9C6o9eZ5vlma6gmujeS/Tzw0AQo8fVq1/+D
	l7qI2oT8nTxSLSmvcQ9Iy4b7qoF7U4daPMFgDEAAq8HPNF0cNON0sdSzuqAiF9e6Deb968pu6dw
	Fc28pRM40S8ppc/0i2sHome1xOwBx7OPf0pfA7Ih0oLbouhuMSW4havWLzA47RZNUhAg10hUKW2
	93CuAQOYAA38M0LDjhqjNYwiSch2m7yKhX9HgmNw27RbUpQ5VNpx5l1vjmy5Rr4i5yvRfcN8/zj
	jw1Sb2Zw67q5DEgDFGSILSr1yq9GoICAG2KvEpj7H1z4ZNZy0904h+qtRV7xXOVCiLv+8q6zn2s
	VLX8CkgmbMEIcPIW/xcY2P2o08uhLPZjLqDovVMe6DhIcfag575SvflYT7x3L6N4Ah0GTmIWUp6
	3VFPK/LlsaLZs7PUI4/8rxSxdGEamK14GHDjGQZVL/oQmqnImy+jPaXEDSFynAPuamy3FUknC9L
	g6E8913NE/kwzZ3QNrF1EG9d9vV1GE2xr+j0dVymwpNm48i+iShfFtjtApZ/GpcX3YPaL6s7Xrk
	4qo5rg0BzgJoMVc/GROq1G+1eBR4Vh8zW3ZRXiQq
X-Received: by 2002:a5d:4ec6:0:b0:48c:7143:610c with SMTP id ffacd0b85a97d-48e6e3091c8mr5024505f8f.36.1793372717264;
        Fri, 30 Oct 2026 08:05:17 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b77f06sm3716923f8f.21.2026.10.30.08.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 08:05:16 -0700 (PDT)
Date: Fri, 30 Oct 2026 16:05:13 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 14/20] attestation: Add the base family specification
 and generated files
Message-ID: <auSxxPM5z8BzgNm3@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-15-jiri@resnulli.us>
 <179302367452.58760.3782556786585774917.b4-review@b4>
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
In-Reply-To: <179302367452.58760.3782556786585774917.b4-review@b4>

Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:

[..]

>> +
>> +/* attrs of group cap */
>> +#define _CTLV_ATTESTATION_ATTR_CAP(_attr) \
>> +	_CTLV_ATTESTATION_ATTR(CTLV_ATTESTATION_GROUP_CAP, _CTLV_ATTESTATION_ATTR_CAP_##_attr)
>> +
>> +enum _ctlv_attestation_attr_cap {
>> +	_CTLV_ATTESTATION_ATTR_CAP_EVIDENCE = 1,
>> +	_CTLV_ATTESTATION_ATTR_CAP_MR,
>> +	_CTLV_ATTESTATION_ATTR_CAP_MIN_CHALLENGE_LENGTH,
>> +	_CTLV_ATTESTATION_ATTR_CAP_MAX_CHALLENGE_LENGTH,
>> +	_CTLV_ATTESTATION_ATTR_CAP_MAX_TOTAL_OUTPUT_LENGTH,
>> +	_CTLV_ATTESTATION_ATTR_CAP_MR_FLAGS,
>> +	_CTLV_ATTESTATION_ATTR_CAP_OBJECT,
>> +	_CTLV_ATTESTATION_ATTR_CAP_BLOB_CLASS,
>> +	_CTLV_ATTESTATION_ATTR_CAP_FORMAT,
>> +	_CTLV_ATTESTATION_ATTR_CAP_REPRESENTATION,
>> +	_CTLV_ATTESTATION_ATTR_CAP_MAX_LENGTH,
>> +};
>> +
>> +#define CTLV_ATTESTATION_ATTR_CAP_EVIDENCE _CTLV_ATTESTATION_ATTR_CAP(EVIDENCE)
>
>I feel like there are too many layers here for a code generator..
>
>enum ctvl_attestation_attributes {
>   CTLV_ATTESTATION_ATTR_CAP_EVIDENCE = CTLV_ATTR(CTLV_FAMILY_ATTESTATION, 2, 1),
>}
>
>Do the intermediate constants add anything?

True. I originally had it like you suggest, I changed to enums to avoid
the explicit numbers. But you are right, does not add anything.
Changed back.
