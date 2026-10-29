Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268307;
	b=r5GJPYeU1M9QRgsgqck/aNFKDAm6+0II/5t6POUguAixEJCCdpW5lsks0NPLGc/I5OKZ
	 bI4+CTxxdUkCuy73Oxnb3mNY+pge2PaBB2wARMOAga/7YgHa9tuV1hanfPL0TOpcVQTeU
	 Kf9gzxyj0ErrUkeJbIsCB12JFUdnffkYAZxov8FZLBKc1Tw7qk/yGPH/fywwotkvEl0y6
	 H3XYCANLLADfBPeh3Pr05lrTjUtkSDyxNyEt0xkHPt6nKRYG9S19TICfZJRW4fVZ6LGBV
	 1wHwJCkxPhB3TBUQH0BHrxUOq8QFoqt8M0E4fe7QNlNsFp0yRbKOPjKA9UHAVSmjxMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268307;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=HZ9giMsL3tTbnyDf/k62OFthNCmQXGHyiD+KvibTtRA=;
	b=eCVqGD+jMf9TBdFEUA7C7KAeEfjLNIb52xSXshix7XyYRWiPHoIFvhdA+mmfNGQXemmV
	 NE7tc6z2sln1D+fAfkQHBk18e5A7Y7ShhB+auPsEumsf4z0kc15mIdOL67tijsEwoxk+r
	 yNuSC3bhzAEDmaBELCPnzTsNQe7uwKBnYDREn7/aGnrZsYsHpyUCq8LCrW6XJTX10VsCa
	 tRzVveik8wqFJFXHT/DBlcVr1Qd1DrBn5gHKwWjv/o1JEEk45osPloQ9N253aTKin9NG3
	 STrUfMlALb4YW2t68udrE3onhFbQmsogefX/mDO+cAdr7QQuLsNqSNQdGIFncLYB0mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=H1R2lLqH;
	arc=none smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3448606A31D
	for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 10:05:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3448606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=H1R2lLqH
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c40e30c26a4so105697666b.0
        for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 03:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793268304; x=1793873104; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HZ9giMsL3tTbnyDf/k62OFthNCmQXGHyiD+KvibTtRA=;
        b=H1R2lLqHn2Lr6k+r6OdZgfppHvcjyP6TZWTLyu5FilYMTbK3u3CZpeuCjjZIdi4jnC
         0TwveKR9jA6jVTkHNUrcAW5Tw1tmadniatMZ/qV5n4QHz4UpZeLMCH6YQcpCWNXHiqxm
         sw8RqXVy0A85Vy4bcECMhm6L0/zQylmNx98oc9kMhu0oZgHWGKa9CkqcG5v4I07BYGt8
         CgLVdi11r6LTfqrelvyydvPWPfjIYWzxZUqu9juiWWPud6Vj39Og6UeHebRhF8opkpqo
         QTVfn2BUYNe+MeNX4dHVQkUb1CFSbYgbCR2R0c9GD4Um/2KcLIxENbQuIx0sssnOk+oO
         cWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793268304; x=1793873104;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HZ9giMsL3tTbnyDf/k62OFthNCmQXGHyiD+KvibTtRA=;
        b=t8SO7ytUowWSkDQ/OaZ5o4MKAfRPZjZLWmrQr3nCQPTcueRYMBhpdXy1r7OZU/nn/P
         XBnGto40DsTKP2B6bOTht5fYbt/Y1pXmL6Wp3Y2ZBby+fbTO8nN0w2rfzJGDehLmho/9
         nB6nVrb98f3akUbk7B++jHZiVcy84I2FFxa2v0usaqivE3+3O+8V28+cEG4cVo7HK/QE
         38Ptror1CG3BgOU7Bnvr9DUMusE612hc+NsS8yx1WwsPoTU34n946j1KjdWcdIMqotZK
         Hu02fLu8pikZy/hcud5qNSypFtqvUlXvV8SXfOl2yCUGHPUyx6dCWWkmTgFfp16gQBTD
         ndzA==
X-Forwarded-Encrypted: i=1; AKwUvBzTJL6oEz58wgaDQIk3joX7uKH/X5xCE0vLxIZGR0N39GvOrktJhPztfufWMDXEPauj7o7xCsrZ/8k=@vger.kernel.org
X-Gm-Message-State: AFq9FYIeZljQQA0jWWEnGSDH41vTIt3Yj/zcPlVy37lV/9J86oPUnQmm
	vVBQpCWndiKE88YsVluPZAbFhSlZoBeAz2UUl2RKZ88qcBPP21ejK2F5RI8KD3CqT5k=
X-Gm-Gg: AYBFou2JlEAmnmHtR0L2oqXgu7h/do8+EHk3A6Z/s/EKLCUDtvScQUmxsD/PXA9xlpt
	bfw9AqfguMw53VHO1HKQasTArFoLq0sdvTPjzBdye2h9kbySc3RFluDR2wbktcBVwyREB0RTlhE
	7gSlJ7fXkymiAnlTZGmjfRHuQzaisOkCH4CJO6FvrZ4AJDffqzpFOVMMWIBq+XgnaLUHS7R2DpZ
	Zny5q51UUcicv8ar/Zwytc0TUInO9pOgbVYnGgr1yujJCbSaFQcLx8CC6IeWvCn+v+YtrY+wCHJ
	YZee7Ze2p68X7VJq4pnX1/QxdAyqx/7MNyjhbPSpQ3y+JvKvWzKsHi2CDi90lSC7R/rG5zJmQbR
	eH7T8/3bWCHCPbLW7k5oY8V7a6ZUiPjArM+NPlqzCF0+1Rs7p4WTGjkUdJR4lRu5s/scS+sM7xW
	K1H7fYjB6O3I9vpJ/sF32dSQbFj6c+2N9UVPkMbfgU93y3XhYqO+OfbBmo3LUaJhCLWLiVXceDf
	UcFgt3IrNIPk2M9NadvsTh860l/F+yRJUbkR2tNey8l8yUeTbi0SHhJh3C2LdeFLw7rly6q3fvC
	rWAlR3gCZRgju0HojFZ+GJHOEb5WjB7ZrcQrAA==
X-Received: by 2002:a17:906:ee82:b0:c25:4d9e:bb28 with SMTP id a640c23a62f3a-c49d10fc56bmr194240166b.3.1793268303706;
        Thu, 29 Oct 2026 03:05:03 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd7abf6asm705408566b.81.2026.10.29.03.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 03:05:03 -0700 (PDT)
Date: Thu, 29 Oct 2026 11:04:58 +0100
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
Message-ID: <auMX4kbsflE9kK3Q@FV6GYCPJ69>
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

>
>=======
>
>device-get:
>  request: {}
>  reply:
>    caps:
>      evidence?:
>        min-challenge-length: uint
>        max-challenge-length: uint
>
>Did anyone implement a variable length challenge? That seems a bit
>strange. There is also a very important crypto warning here that the

Yes. TPM2_Quote accepts variable-length qualifyingData, represented by
TPM2B_DATA with an explicit length. This varies per request on the same
TPM:

[1] TPM Library Part 2, section 10.3.3, page 136: TPM2B_DATA.
https://medias.cdn.trustedcomputinggroup.org/production/Trusted_Platform_Module_2_0_Library_Part_2_Structures_Version_185_pub_c0a962a931.pdf#page=136

[2] Part 3, section 18.4.2, page 158: TPM2_Quote qualifyingData.
https://medias.cdn.trustedcomputinggroup.org/production/Trusted_Platform_Module_2_0_Library_Part_3_Commands_Version_185_pub_87a5c10230.pdf#page=158

The PSA Attestation API, section 4.4, also requires one implementation to
support 32-, 48-, and 64-byte challenges:
https://arm-software.github.io/psa-api/attestation/1.0/api/api.html

FIRME DEN0149 1.0 ALP2, section 8.12, Table 8.23, page 100, likewise
defines an explicit Platform challenge size parameter in x4[31:0].
FIRME itself does not mandate the specific 32/48/64-byte set:
https://documentation-service.arm.com/static/699c3b70b60ef220b14ec14d?token=#page=100


>userspace use of the challenge must not create a "signing oracle". Ie
>do not pass naked network data into the challenge..

Agreed that we should document safe challenge construction.


[..]


