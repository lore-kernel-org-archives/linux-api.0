Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793022506;
	b=VXltJJA8IR9TK9Dgm74ISwWQMaLpDXa/asUdrvqg+gEDLwsFzYrloD2rjtwob3Jee+CN
	 dzwKCGbcZ9A/NqdDXByJR10GBoohnrxjhImEVn2527bZWBW0ujqUFeSw+CYiII65VWg9b
	 Tf51N+6Zh2tZmOSiDjdXIP8YEAFVXmsoHLYOiE56+YGEgaJwRS3y+MbIQ51xiUYs5RfQQ
	 fyVMKcT2wjrrl2JK6KZnS34A6JkmurdLWXSxBVe/5hhY5Q6XCV5BHvMuNRFP2Q0q/b7Gr
	 2BEZE4RM2uRtdNaPfEbmuwtM697GEZiGX1htnE5s/3ndCKYRBq5cuzMPHekTUNMiD/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793022506;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=eeiDIzKBgXHTvIB/FzTge64uqO1p8vq38QKemD1zDpA=;
	b=OgMpuIGKCQU7sPfUmUvcpjgJtTmRAzdPUUr4v+qRLfq+82s4ugB2zqNxg13cRWvm2wfM
	 FThe8Ol2KQkoq8sf6vk9/5emwlE7GsG3lZDhcdUIrWVUMJYPZ+g0NznQvJjYjHhO4vh4R
	 3uW0wHnhGtGT4K3V3VhK4z7wGPbrbu8Qme9CTfqEtg5yEW9FWlZOMtgv2pHhw0GfQD9vR
	 0HA7Got+Fw0IyJr4b09JN4IHhXO8b2vto2QVdE2X4vmJ1w54KaoNqx2Jyl3MTPj28l5+D
	 cQqSVypV11M8GZ4tu9+aJbYfmZnVQbdaUfp+JmaVm+bBQTD5xsvISJ+krhDgGzbtoQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FC8606A31B
	for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 13:48:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5FC8606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a4dc547987so5898695e9.0
        for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 06:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793022494; x=1793627294; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eeiDIzKBgXHTvIB/FzTge64uqO1p8vq38QKemD1zDpA=;
        b=VM8IYrnCNNqs45DDC5LE9lQowRMEKYE5Y/KZ57bV4yet/aoDBGlAsxJOmTRykOk8dn
         FshcS/W8j64dt0Mh5C8VdYgUtcsCto+ScQaOEpF+I1g+GJr3PKhwYJY8a9G++KZq2rIk
         fciASrl2LvGXd8pYXvHkATr9UTdfoqHxMbXc79S2QEtkqqFElfTeqUk4ffn+ZNgaeGe/
         nm24iy1xia1O5G3DOANrqIMherXJogHmuD48d2u+nc2vCUxcd8XNkN3ljWXSZqr8HlaX
         Y9o5gWTDf6GO67jT9mY+jbYN5IM9+ZXATUXh+KiGk5uTlXn1ZnpDB+tpDMpOFgjZMwAW
         Jg2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793022494; x=1793627294;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eeiDIzKBgXHTvIB/FzTge64uqO1p8vq38QKemD1zDpA=;
        b=Xen5q0UbzzEjC8tERsJNHExG63TNU9C/T8HbDTDs30NKkm84Laxeutdf+ZPoK4CYU/
         cmQoKf6DAsJ4WFzE6kElCyeyAZDZREq7ndtA3VtJYR6Lci3f0GlXh7IghJa7iRzq2dpn
         eYf3GyH7tRkiJALYXiCoevIB0lqMK1gg4qqpfAjZx8y5np3q4dB21/ERCUUPQv3ASv1F
         qPvzIb0GL5I4r88BnUKFZxU0vVZdGlh1GBzBZGs2xFiPxpyfRpazoNIYBBQZM2sxi8aR
         3n1yreiGHLGqlr+gOHbasKPepVqTQPgfr8KYxkLbp2Gzvn2xm9ujgkqgbkif/fbdupvj
         CFkQ==
X-Forwarded-Encrypted: i=1; AKwUvBxLcRvTsFbJgvsmW3A+RUvC6k7HRQq26qtWgvqagE3Ivldn771+nnyIqoyyPbUNPnndf4kziKsAZCk=@vger.kernel.org
X-Gm-Message-State: AFq9FYLw8FFm7kwYTUk3Z4V5aFHR6XSJ7yWfWx86CwdHD48ztwTKJJ3P
	CZqthidRqikr7YSkqcW/7s810pqiDWW/p6xHL8YayBfqrkvfiKDcPd9GPiUGF+1PdGG6YGNeFdp
	V/3Wok1aPUXZN
X-Gm-Gg: AYBFou1BkupuipwwD5cNjYoUZDwcQ8lxdu83jTkVyP1iRCcvWUDvriIqyU5KAhJ+gbD
	nzTI30ItksNAeIma9hH6VOvFy2RsmNHC2vkPD8jurTa/4xhgu9/dIsXh/gXjSuw6YcXngy/nVVF
	jahN3HgGRItjlhCPltMrG5cqmNNrggiy+YVSbiWa0F4sn15IY4WudsI44V8RjYB5IpEwL4R13pI
	Ql21fd70MeE08E9VdPSLT2y1G0RKMkaVbXmOfi4ImiL0kAsaZmWHWnl3IAlMUntBS6+M2Xrw4y9
	12/SHIbJnAe4w+1FbfTOvpBN1d+REXBF2iofpQgFM/9R4gOAHsSM8yP3lXB1eW7zJZESImLQwMG
	yfuVUwd3jiJls+GsR2bCeOWrByh92OdjvenfBbB78bwEBc59pBqOTzmu4rep32lbaAlXwtYJpKx
	SD2IKjB4A1kpP4e68CFu5/wCmgsGSF2jOLdKViOHJG5/v1Qo8SiyQ836joAJV2vFAVfD1ubbH9E
	YTWmB1HRrd5di3lvjtKHc8K/jAB9+qR2afe07VeWqWmtXh+dTx66C/70jJBongC
X-Received: by 2002:a05:600c:3d8d:b0:4a1:f377:5c75 with SMTP id 5b1f17b1804b1-4a35acc2edbmr104469535e9.33.1793022493724;
        Mon, 26 Oct 2026 06:48:13 -0700 (PDT)
Received: from localhost ([208.127.45.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a5ea0df763sm107133535e9.3.2026.10.26.06.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 06:48:13 -0700 (PDT)
Date: Mon, 26 Oct 2026 14:48:09 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 12/20] ctlv: Add device and operation dispatch
Message-ID: <at9ZEDZl89V0jaJB@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-13-jiri@resnulli.us>
 <20261021022505.6fe1b1bb@jic23-hlaptop>
 <20261022184313.GD3381610@ziepe.ca>
 <attZl_0TNMDLgi4U@FV6GYCPJ69>
 <20261023142633.GF3977851@ziepe.ca>
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
In-Reply-To: <20261023142633.GF3977851@ziepe.ca>

Fri, Oct 23, 2026 at 04:26:33PM +0200, jgg@ziepe.ca wrote:
>On Fri, Oct 23, 2026 at 02:58:33PM +0200, Jiri Pirko wrote:
>> >> Jason did some nice handling in the fwctl stuff for
>> >> device alloc and hand over after device_initialize()
>> >> (I've copied it into a few places recently :)
>> >> 
>> >> I'd like to see something similar here as it made
>> >> it easier to follow lifetimes etc.
>> >
>> >This is really at the wrong layer.. Attestation subsystem is the lead
>> >subsystem, it should be allocating the struct device memory and the
>> >driver should see the typical
>> >
>> >  struct attestation_dev *adev;
>> >
>> >  adev = attestation_alloc()
>> >  [..]
>> >  attestation_register(adev)
>> 
>> Er, the driver would call attestation_create() which will be a wrapper
>> of ctvl_create. The reason is inheritance chain and each parent being
>> passed info to and doing its own init()
>
>We really want it to look like the above so we get proper container_of
>stuff.
>
>struct driver_attestion_dev {
>   struct attestaion_dev adev;
>}
>
>driver_adev = attestaion_alloc(..)
>
>Don't want "create" to allocate the memory, it is upside down. The
>fixed memory ctvl needs should be buried in the attestaion_Dev
>
>struct attestation_dev {
>   struct device dev;    // sysfs dev inside class attestation
>   struct ctlv_XX ctlv;  // ctlv instance
>   struct cdev cdev;
>
>   const struct attestation_ops *ops;
>}
>
>That's the essential skeleton of what a subsystem should look like in
>linux, ctvl shouldn't co-opt it, it should embed like cdev does.
>
>Look at fwctl for reference

Yeah, I understand the typical flow. I just wanted to benefit from the
fact the ctlv has the inheritance chain to reuse it for init/fini flows
alongside the private structures allocations. It saves a lot of
boilerplate code and hides it inside CTLV. I admit, it makes things a
bit obfuscated for end user (driver/subsystem). I'm working on
conversion to what you suggest.
