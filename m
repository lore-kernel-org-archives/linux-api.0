Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793302738;
	b=3KRy2kqPrryokNO1BiqKqMJ7Xfy+Lp9fnPZSRSEIyBhYhr6HTdNmff+XzIZbMKosDCzD
	 AY+p5GRIQ4SDrtD3E5XPcijx216gDoDAsxPDC0CqJn2gnRsADn+BB4iyL4gnIdHkDtZu+
	 yrlgWlY11QVnIdwmRdCUyRrlECyxM1A4BvT/vPsY4NrG1fEiA/ZM604HMmSLvX3C16rzf
	 SBVuhqT+2V5x+qXHU6M6zbvgaz96F7XxmN5X502Xs9XnWN90aNLz+t4+NS9uwyxaKiqp9
	 ULn9ubVU3K683YpiTHE8hhmqhJSBTWMxCEZavudJzItK5edU+FC4iOvneemnAS5sIkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793302738;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=L2bOsI/tPPOv5HbBwJUDpCwYmaK0u+9V6K9ALx35wl4=;
	b=Ry85wgPM60zt91icI0ogJT9QYbCaMNMW0544tCzRXOFElD/JIaRBQ72TKUm4nmI7plMM
	 CB9VyRVQDBgRmuPPZoT1SPEo3t0uoa9s/0NP7itY8ngzPsXCP3wAtGB/nUY2+otSNE4mD
	 kfaDALCeDtoThtIpOQ7CdkgCZt5rWB7WLPzHetdMjnqMtEZygP5fGyHhSz5Zwu3jdhnxV
	 3d7NHOpHykHzMmPGv7mQFFSqq75LIosFUO7rftyv3c1nh+3xb0eei8IXrNt9z2VChhZq/
	 8oRBJ1/02QoQ1wTeO6+I16ay+a2QqqBpWhIvzCUnefBgjSB5iVptFrrpOReM361Q2Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.208.179
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE71606A31F
	for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 19:38:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FE71606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3a9841363b5so291501fa.2
        for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 12:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793302734; x=1793907534; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L2bOsI/tPPOv5HbBwJUDpCwYmaK0u+9V6K9ALx35wl4=;
        b=FNBa56KT/9Dp2z4RqTJX4SmEdUz5QF0XsrQGqBzBDcfvePMHkyjRSZHgA2dL4abyfy
         Z5mCosjvFkTxPpDmCgqoP7G7lT2FVFFUQ0YpXNjOUhaorkhdgy63Iaj0z/fMjsNDNf/C
         B7N559oM1aQ463TkFMl4hlBO/WHCqunTmnc/UsMFfppEpnpGG5WUa9uxWJFZXCt4Mw4m
         rz9/qKuz3+niyjl8T1wW4UCRCMZX5MVtZiU3CO2A9BHdOcdEtVxmOzi+D8+vZa+Jmmo5
         /rJGHoehxWckvC7h0zyK1y6pn3xGNLKqI4ReeBj7jtQ2yBzeEYj7vSzrelBOMx5CX0az
         WXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793302734; x=1793907534;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L2bOsI/tPPOv5HbBwJUDpCwYmaK0u+9V6K9ALx35wl4=;
        b=maCd/wObjRh+SuMqNEhUg3jOhWdy4UwI8IXyYF1p6jaVjldutdBA0Tf8+aGTHNyb9/
         VgTCBlVU6/+5Ljs8ApN6nGEyo2SySilnFpw9Uwb33YVn0qVo7m4Rq4jMjE724SHHFPph
         gG77i+V2+zsd0LlU5uTP7SU1gtE1A2270Ru+kQeB6NVUrUxvMe0nkYFECTnzNclcjYE3
         Rlxf4HKNtPNkuwBi2az4Lnyh1mntI/JEUHyYmffl39C+mtKNbYUHl5S5+XZHWvAN2jdo
         4cnlh8WR2t1QYSBS1l67kPgy8ktUzaXFYRDFlLECw9ATs1tTD7HR7PlLMqfHDx01efc0
         dwNg==
X-Forwarded-Encrypted: i=1; AKwUvByJRQ3s+ATeCq6+HHl1uFgjFnTOlfy4OtNVoYF62K6SWQ4d82ZPFj56sAoVU03GeLI1C6ZTk9ivG1I=@vger.kernel.org
X-Gm-Message-State: AFq9FYJi64hAzGvFgZpAhXTsntO1nTGAt0VgyAsJautaGnP8ItWWO1El
	wmdn4wL2sW6/Ej9VqKoVXVMJSvm/6Bv9tW5qk8biCNI6GrxG7Vt6gD5b5A6ZIqFA6gM=
X-Gm-Gg: AYBFou0xxckNaOi67tV/o3QpDlUqC1EJx2ZUIe1hBpm1rIx65nOvcHsPCQ24d7W+tUM
	95rqs2m75L2PiRMEONIXNBAdWwhnQIKsENt0aRVQvQgKQueXmGzdlZS/5TCj2Pitg/28TGHY2Fj
	M/xVHlIkG6W4L/b4BIo3edSMxuD143J10ezUq77k7rKLwU79SRiZ8Z6eWm02UVMaYUy8xntynO7
	OllMHXjPELWu01mMCraZ6lph9Em2Dz4vD6++i1msvCyocRqI4hvA8v1GnGH4bxFAFVE8zQ/zfGL
	Bs6jRkurFYScf1LTstDyFsjVgtPC2XVEdWA5DdtjhL19dRkcZHp4EWAoZYpQ/UKSp/NDWnowjhK
	vFBCEujThdmnpo4fSgMDZwR/u9gRZbMoTVAiKd9dhdcTmKIpU9sc6VGTxoMzqYoM8crGYUrFYnZ
	Uu+z9sCR5J0ijq1IuEC/FDoJYTJJMrKT+Eiy/uIXWc3zGf3+CFA8KsQ+gJcOKFeXKPCjEY2KlWH
	TINRpzS7sOBKhsq9zPxIUZxTq+7HLUjpJ9ovPo7kSMIXDzncW/1pXmSJrA8kXZaucPnKNBh81ZT
	BEdv9FSvsge8+Y5cg3zueEIgJ4qoqAs3y4QKEHsDnOIlj6tDwFblUImj4wg=
X-Received: by 2002:a05:6512:3f03:b0:5be:414b:a84b with SMTP id 2adb3069b0e04-5bfcadda82dmr2380923e87.51.1793302734163;
        Thu, 29 Oct 2026 12:38:54 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfd7ef0c2esm69050e87.50.2026.10.29.12.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 12:38:53 -0700 (PDT)
Date: Thu, 29 Oct 2026 20:38:49 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
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
Message-ID: <auOgwlGeW-vRGVb0@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-15-jiri@resnulli.us>
 <179302367452.58760.3782556786585774917.b4-review@b4>
 <auMX4kbsflE9kK3Q@FV6GYCPJ69>
 <20261029184324.GE3734323@nvidia.com>
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
In-Reply-To: <20261029184324.GE3734323@nvidia.com>

Thu, Oct 29, 2026 at 07:43:24PM +0100, jgg@nvidia.com wrote:
>On Thu, Oct 29, 2026 at 11:04:58AM +0100, Jiri Pirko wrote:
>> Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:
>> 
>> [..]
>> 
>> >
>> >=======
>> >
>> >device-get:
>> >  request: {}
>> >  reply:
>> >    caps:
>> >      evidence?:
>> >        min-challenge-length: uint
>> >        max-challenge-length: uint
>> >
>> >Did anyone implement a variable length challenge? That seems a bit
>> >strange. There is also a very important crypto warning here that the
>> 
>> Yes. TPM2_Quote accepts variable-length qualifyingData, represented by
>> TPM2B_DATA with an explicit length. This varies per request on the same
>> TPM:
>> 
>> [1] TPM Library Part 2, section 10.3.3, page 136: TPM2B_DATA.
>> https://medias.cdn.trustedcomputinggroup.org/production/Trusted_Platform_Module_2_0_Library_Part_2_Structures_Version_185_pub_c0a962a931.pdf#page=136
>> 
>> [2] Part 3, section 18.4.2, page 158: TPM2_Quote qualifyingData.
>> https://medias.cdn.trustedcomputinggroup.org/production/Trusted_Platform_Module_2_0_Library_Part_3_Commands_Version_185_pub_87a5c10230.pdf#page=158
>> 
>> The PSA Attestation API, section 4.4, also requires one implementation to
>> support 32-, 48-, and 64-byte challenges:
>> https://arm-software.github.io/psa-api/attestation/1.0/api/api.html
>> 
>> FIRME DEN0149 1.0 ALP2, section 8.12, Table 8.23, page 100, likewise
>> defines an explicit Platform challenge size parameter in x4[31:0].
>> FIRME itself does not mandate the specific 32/48/64-byte set:
>> https://documentation-service.arm.com/static/699c3b70b60ef220b14ec14d?token=#page=100
>
>I feel like userspace needs to know the difference between 'any size
>between 0 and 100 and 'exactly one of 32, 64, 128' ?

True.
