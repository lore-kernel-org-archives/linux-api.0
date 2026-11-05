Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882155;
	b=0L84HeggzT4suJqU4nNVeUuSTMfzsw/o74yck13aEg/6MKP3vSqrMZbfVx4CB5HwR1BH
	 bUGrtJhudUvThIoldpIe4NVeDsYtb91bvDLMXUDf52nH7Cbf8GvJUwZOJzsyNYUZviIzt
	 suOZLQkkLWu6yHavhrAIlPpr1cAyaats8MpVcwPfcNgaJZJQaoYKDMlVFv46xsXvA7/lM
	 kXdA+bDszaMh8v9N9496ye6kQMDujRrnoxuap5NkGmOqcFOmj4Uscd1WEc7ysxzx+4fZX
	 P6Dzuq7WYcGXQpKgFWmZAOnY7uN6ksEF20H4k4n7P74oI67NRMLU6WslmM8KJ9aNPeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882155;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=viyDdmvwD4U6PS8lafjWT8pU3blZXU6a4uhU+bJMb8s=;
	b=iHJ+O7dZOXqNqI6krKpxZ5c+dhtRV8K79MJfWoo0dU7c3Kt26i4zSWgt4ZqRnJ8NFRg4
	 2CaqNvhiVJCzSqTYsRjgu8gp/TAac+a6c3+OvsQhMWbZt6X8IzKftNoVSeZZ1dnzBSPMk
	 GMxoAlsR3JOKeSg9B+SdCJDwzd5xreofcyOR91dOsped4fPH1VJLv9s4u4JiesOee2KSG
	 GBC+K47cYs2V02AhiDR0AM8zelrO57iWScUkCjkXT+ZS01gnxegYV6RC5m8CeLOU+RsoU
	 ydxAjwMFV/EpvsnG/PN+rXR/s5xawrY/ub6njftis6G2mFGIN9zerETRF1JV5/aLelA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=khwmS6IO;
	arc=none smtp.remote-ip=209.85.167.46
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D96606D806
	for <linux-api@vger.kernel.org>; Thu,  5 Nov 2026 12:35:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43D96606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=khwmS6IO
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5be4fea434bso574091e87.1
        for <linux-api@vger.kernel.org>; Thu, 05 Nov 2026 04:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793882152; x=1794486952; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=viyDdmvwD4U6PS8lafjWT8pU3blZXU6a4uhU+bJMb8s=;
        b=khwmS6IOV7BeOJk5vVOoYILP+8pKH+tWxdl1OMSJ1HVjmXymvCR1SMmwyMCayrilGQ
         IkaDwmalX3igSVne7d0QxuHYEmsMWB9o58OQuOIW8Lle7U+0s7hL2mD97+iQyAkH9BYp
         tN0eybs7YdFMJn8p9exyLKqur9hS/ju8pGGG1eatouTCJQDvUc4Q/VH0vvROLQUdD9Hg
         Oe4z503BqA7YRx3a+Z25EfVok0cDuqAC6EFoA6Ye5xzHvUGaWr2t1fs6uWtO7uYHAb6T
         WA5OTuxtVTyYZtf/7Ecvzco9bmsdxZowRUk88/RyY48V+FNfbBM7tq/8E/TH2g2jROpE
         RgZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793882152; x=1794486952;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=viyDdmvwD4U6PS8lafjWT8pU3blZXU6a4uhU+bJMb8s=;
        b=luyEPaMX+WZYNVJnjP8z7V3pcK4e6q0+SjGyn8FNWyXXs4MsS1mP0CjI0g/wlwtrIs
         xXkR2NLfj6hXaMrcJaCYH1WbX7X0u60pqNjFUdU7OmO49h1Hgsp1XiPaefcE9muyLyDF
         cOFdaQSAr/lWPb0QAxsT7PDDVz42la5Xig4gdpR+xVNh4AZKy+p7keCl9vXLZ2bHVddM
         mN+uwEdiyZ+HC0Ckpo4QSCpR/qESK3LeTGUBbuUYmzYxlnkfg828QNjKi5vyY+ql8bEo
         kFbLLBMHOVYG0ETMhApy/RVOyeJUEiU0xaxwqOgzmeI042L6/R5lHojFb3c6q00RUHxh
         USiw==
X-Forwarded-Encrypted: i=1; AKwUvBwb4Ttn3lxOLB1w6eNP0kZ8QTn8jjoTMDhl70gHJl2arWWg6UoMaOzsRHGsW+3IcCmRkKQDxy6wajU=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Z3MIb2hyDiXhsJQMGc4k+bbiQfBVHBnE0+A2Z26mvJBlgzAb3
	HdoIr1FQunJtJpR3wxhxR+YcyBCGc7r0pr8lHLrRxe/b5B0/zlK8ujKDGtSu661ZlL4=
X-Gm-Gg: AYBFou2N0YiCC+s7N2yPQP2oE5mXm1vdeINal8Tjs1tSHFyzrrB+aEXdu1FlDhlaC8s
	R8cN7VYmRdGlmK9M01YEDGdezSJou92QsMxKo7LiiJ6pe0frorylPcGLrGIu7Vc7/rCxWZRoDJA
	zCBVJwysPMCwdqGc0d++5O15pHf0OXXs8gOuTbV37gEKxZfcgre+u1zRfXL4Nmi6bPd4xPTWTzn
	SMx/J4BCHipMfth43Iyx9HpmykH4vqHTbHTa8GvCPWrLgEBDrrQFy4+9UwzvMhn0pk+wOvtnH7y
	QjpkO5f6LSUeo+lnmqRSsej136RqGDYGaT5eOsD0jtnOGw5XWqigS2etOKtsrxZgx5YTFK26auS
	SJsvzOntQUyjNIVm13IDFoXGT9sxtU476trqPDztGmVJr6YqBoGIJx/qikmZ1Ey0XUEWGJo+T/g
	jf8rIEDw7R32sfgj6s+mMFKCGrgoG6/1Oult7aGB7wqS1LzHxJmUP4+lDQhRz14RTLW34/LDpKz
	0zZywWZe8qM8BCvbjQFxalwkrD99e6fJDMccpkSYIDT+L7mOSss/x+Sv7VWTYlSj/q8ABBQ5Ffd
	FWOpAF23qDkCwnUkVc/lmSFkp10FN5+5J4o5u+M=
X-Received: by 2002:a05:6512:2342:b0:5bf:d738:a5a9 with SMTP id 2adb3069b0e04-5bffa1653b7mr666170e87.22.1793882152273;
        Thu, 05 Nov 2026 04:35:52 -0800 (PST)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bff38ab878sm806136e87.21.2026.11.05.04.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 04:35:50 -0800 (PST)
Date: Thu, 5 Nov 2026 13:35:46 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com, 
	cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 14/20] attestation: Add the base family specification
 and generated files
Message-ID: <aux4F5Fj1VjSwUb-@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-15-jiri@resnulli.us>
 <179302367452.58760.3782556786585774917.b4-review@b4>
 <auSxxPM5z8BzgNm3@FV6GYCPJ69>
 <20261104175436.GZ3889730@ziepe.ca>
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
In-Reply-To: <20261104175436.GZ3889730@ziepe.ca>

Wed, Nov 04, 2026 at 06:54:36PM +0100, jgg@ziepe.ca wrote:
>On Fri, Oct 30, 2026 at 04:05:13PM +0100, Jiri Pirko wrote:
>> Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:
>> 
>> [..]
>> 
>> >> +
>> >> +/* attrs of group cap */
>> >> +#define _CTLV_ATTESTATION_ATTR_CAP(_attr) \
>> >> +	_CTLV_ATTESTATION_ATTR(CTLV_ATTESTATION_GROUP_CAP, _CTLV_ATTESTATION_ATTR_CAP_##_attr)
>> >> +
>> >> +enum _ctlv_attestation_attr_cap {
>> >> +	_CTLV_ATTESTATION_ATTR_CAP_EVIDENCE = 1,
>> >> +	_CTLV_ATTESTATION_ATTR_CAP_MR,
>> >> +	_CTLV_ATTESTATION_ATTR_CAP_MIN_CHALLENGE_LENGTH,
>> >> +	_CTLV_ATTESTATION_ATTR_CAP_MAX_CHALLENGE_LENGTH,
>> >> +	_CTLV_ATTESTATION_ATTR_CAP_MAX_TOTAL_OUTPUT_LENGTH,
>> >> +	_CTLV_ATTESTATION_ATTR_CAP_MR_FLAGS,
>> >> +	_CTLV_ATTESTATION_ATTR_CAP_OBJECT,
>> >> +	_CTLV_ATTESTATION_ATTR_CAP_BLOB_CLASS,
>> >> +	_CTLV_ATTESTATION_ATTR_CAP_FORMAT,
>> >> +	_CTLV_ATTESTATION_ATTR_CAP_REPRESENTATION,
>> >> +	_CTLV_ATTESTATION_ATTR_CAP_MAX_LENGTH,
>> >> +};
>> >> +
>> >> +#define CTLV_ATTESTATION_ATTR_CAP_EVIDENCE _CTLV_ATTESTATION_ATTR_CAP(EVIDENCE)
>> >
>> >I feel like there are too many layers here for a code generator..
>> >
>> >enum ctvl_attestation_attributes {
>> >   CTLV_ATTESTATION_ATTR_CAP_EVIDENCE = CTLV_ATTR(CTLV_FAMILY_ATTESTATION, 2, 1),
>> >}
>> >
>> >Do the intermediate constants add anything?
>> 
>> True. I originally had it like you suggest, I changed to enums to avoid
>> the explicit numbers. But you are right, does not add anything.
>> Changed back.
>
>I was also thinking that having the explicit numbers makes it more
>robust if someone does backport. We should try to have everything
>explicitly numbered in these generated files to prevent subtle errors
>like that.

Okay.
