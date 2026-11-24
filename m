Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795522399;
	b=t0vWeYrsc/400csLCs281ih29rQ/sO3iwBChc09jseQTJzLG0mD/jmdMMXWyIB9L971g
	 chcaWCRHlrYeBEF14YXiEdAEYuReCrSVAT9ZZHXQGWl8KG52wnARldmWVgOzviM8+WfDR
	 5H0NzLMZdMd1/9kKqfR5VjsH7E/LtGHW4aryp6H9WRzcowYRFJfE0aP9oJ8/P/TzDgWWx
	 L+XHocGrPqOkd5mavb7KE6XxsIPX18+wGyPUHGjlVvdDHi5k19c67JADUGSNoCO2wnThh
	 FyGhwYS50ZtUpgOmFdHPBH9Z6gg1F3U+DhrNPPfdKG1lkgrTpQbb0Cxg5Ff04PsxqjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795522399;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Np0NcUv7mJCJjaicOw4k1YXtQeAzhuGY2ockZsxXegU=;
	b=aQl2FcAmJQQg3DWi6m07HhxqBDSFAsGVywc0RcvMJ/5yu4XXcfI0q0nvaPD6sJ3VySDx
	 CbKHK70022tfba2wsnMespX2hozSbreTKp52EYUPfg20HXk6D9AVDouxGX1mAUtIrQzfW
	 ioTzM2ndmRTodvlz1dPlc0nKb6sAhqm1RC5YzWKy7OfJOuDtEh4urVfkCcOp4jDvMf91k
	 dIBFvD6ImiKiMvoEnJJYTzGEmqgsovK2wb3eVVwB3/2NAbD0DH9uQeR/ozWS2tb3Z0geX
	 lPHExgatiE4b/cKCnBQxq+L8T7OZ0d6/5u7KPriK8SrRl0y+jfCe55U3JrNMnuLwibA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b="viTi3/8K";
	arc=none smtp.remote-ip=209.85.167.49
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA2F606A322
	for <linux-api@vger.kernel.org>; Tue, 24 Nov 2026 12:13:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCA2F606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=viTi3/8K
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5be4b61fd3dso3736440e87.3
        for <linux-api@vger.kernel.org>; Tue, 24 Nov 2026 04:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1795522396; x=1796127196; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Np0NcUv7mJCJjaicOw4k1YXtQeAzhuGY2ockZsxXegU=;
        b=viTi3/8KeIE8uhX56JlXlP6/VB/uifLp1YNde/hFxWBVL09rfHt1AgzNSQ1xTLYKYW
         TxNBy5Mj7sV0GRKJ160Si2rkUSAgJn33iwqUin2swB01y6Ut9G2oo/NtD6GwmuBWsdGK
         pBscQJ//hVMyPypXQMgFo5oJH1vUFdJ5blh4dTSbHXAdAibs/3F+XbUA3jS5gh2JSVOJ
         LN2T2nENIFcXoTm0K25ZjYzgf6wvRTivXcZG6y1mBdXRA/xDPzAu9oc8mACnMdnRVp8I
         5SJUX/xIX1KhwdTHpI3kikeVNii6iesD7pV4JscgeRxDpEqmN+UfwGtYVMRPotk3OsIE
         2nmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795522396; x=1796127196;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Np0NcUv7mJCJjaicOw4k1YXtQeAzhuGY2ockZsxXegU=;
        b=GyZaj64RwMZWsZaxIOJp0gQwNDlCgre2jQy+Sw0q0NgA8LZbT9eWZWkqaNneieoV/j
         heEbC3fRDxT2pQpTZRvBGuWDv+VNnEtGmmYEIyH62tlZdm9dC/Zp7jpQ7VLadaatgeez
         sD0zbUKZ1fMNnMK4rSjGisTlJJLLSoC2+Iv4csb6wa7BZCebsvTeyO29s3DOgVO4ZNm8
         0qZvDQgCfgp/Rngo5r+iEEMuhvYDHPzeiLx96h2+Nk9ePtRhKz2TDXIWgfa+X+CaV14u
         4uFaswHx0zZ484bkfQh6p0Jx3OzOpiTtcrt3kUjNyovJAhW40wWEWcoeZTx2IZZxcXlQ
         +P+g==
X-Forwarded-Encrypted: i=1; AL+hErEzCnoaCvD0Uy6YoKL9zLppmgeWfqAojON/8xGtqctlU4GZnYVOLLuCImEne/pttp0Y+bWAD3VDoVo=@vger.kernel.org
X-Gm-Message-State: APuU4Z/xfakv9d5PMS5pS3Wf6txBXG6bkdLDIYZiYBypCZT9YluvjXY7
	3duQlzooGiaAQbFjeuqqlexDZCpNTP3QI7M0aAyBTTwqUC4ez6hK+QwW2O5hGcTdcS4=
X-Gm-Gg: AZFdTZeRQ4H9SZK1A4UO1Y7GOzcDqCJRQMowQ3ERirvV4EvhgPMr/KpOo2791VdrOEc
	8Qz8v3u1YuBguKJgvtcmT4AGzaM2dMF8Om+pE2ZmK17auRo8y+oqGTVSoERcxozsxzwOISiUO22
	5v67YBfats+42qTfzibw8oo4s4rD/rcrT2Di/EmZxIo+Ha3nNr7hNbriE0Sj2IS8LJRbA9sruvg
	pNMe/DyfHEaSekyoGcYEVoydzzaYI3+tIr3sBMLyayuUr5YlY72dgnMUqY53z+qic/Tk6vFkV1I
	slhgNIAIyJhGe3ZktwRBirKeJRkAZF2DOS/4MyP4OPgrBI2RRtImWpUjBLkWE4/YdmNqAkv/YLv
	2ZN5eC2/46D8Shszj79XFX4Kol14DXjTY5gO9rmHqtUirGXecRdaPdmpcLp6TD/CXrrRB6kNiGX
	9LIBrd0XKENHU0MeJQAYQOn2O/b8IvO4wv9LDmAffKz9gJoHhtYC93hTrjrerkPy55PpK6VZoow
	+B+u4odLuFQH2j1xl7VVE+/dJGQoh8T3D6BGzE0DmfmTB+TbOWAPyToqNYAn696khkmDNKkL2gG
	QP8xYL/Y+vuQ0KKK34/xK9ECK2GaoIVHkxOF1g==
X-Received: by 2002:a05:6512:23a9:b0:5c1:6065:40d with SMTP id 2adb3069b0e04-5c1bc867b6dmr3406850e87.38.1795522395833;
        Tue, 24 Nov 2026 04:13:15 -0800 (PST)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bd01c018sm3681005e87.44.2026.11.24.04.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 04:13:15 -0800 (PST)
Date: Tue, 24 Nov 2026 13:13:11 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, 
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com, 
	cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com, zohar@linux.ibm.com, 
	aneesh.kumar@kernel.org, dave.jiang@intel.com, nik.borisov@suse.com, 
	sergii.dmytruk@3mdeb.com
Subject: Re: [PATCH RFC v2 9/9] attestation: Add the TDX family implementation
Message-ID: <awV_P5443pO4yJa5@FV6GYCPJ69>
References: <20261113160838.2512652-1-jiri@resnulli.us>
 <20261113160838.2512652-10-jiri@resnulli.us>
 <awQCrnD5CtEhKRWz@e129823.arm.com>
 <awQz1P6iXYrL8lv0@kernel.org>
 <20261123151128.GD179082@ziepe.ca>
 <awRYr7yB8IWj7S3G@kernel.org>
 <awRan8ZELzpTwduV@kernel.org>
 <20261123154042.GI179082@ziepe.ca>
 <awRe-A_KeE_kXyPq@kernel.org>
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
In-Reply-To: <awRe-A_KeE_kXyPq@kernel.org>

Mon, Nov 23, 2026 at 04:42:48PM +0100, jarkko@kernel.org wrote:
>On Mon, Nov 23, 2026 at 11:40:42AM -0400, Jason Gunthorpe wrote:
>> On Mon, Nov 23, 2026 at 05:24:15PM +0200, Jarkko Sakkinen wrote:
>> > > > > As per the function, perhaps tpm2_calc_event_log_size() should be
>> > > > > relocated to lib and have non-TPM name like firmware_event_log_size()
>> > > > > or something.
>> > > > 
>> > > > Probably under drivers/attestation since that is where all the TCG
>> > > > formatted logs should end up. It should be 'tcg_event_log_size()' or
>> > > > something. Maybe a tiny module for it like we would have done in lib/
>> > > 
>> > > +1 for the name, as it is obviously more accurate prefix.
>> > 
>> > Location, I don't know. I was thinking something like "lib/tcg.c" with
>> > routines that are plain calculations based on TCG/TPM data.
>> 
>> I think we should not have new users outside attestation subsystem,
>> but the legacy onces will still exist obviously..
>> 
>> IDK either, but this is my guess..
>
>No strong opinions on this; just unpurging my thoughts.

Okay, will put have this in a helper lib.


>
>> 
>> > And perhaps for tpm_buf (both stack/heap allocatable), if Trenchboot
>> > ever moves forward.
>> 
>> DRTM users will route through attestation subsystem to do their
>> extends so the tpm_buf user would be the TPM driver inside
>> attestation. We definitely need this for ROT agility.
>> 
>> We should be able to build the attestation TPM driver without any
>> trenchboot stuff to motivate it.
>
>OK, this was my guess but did not know it by fact.
>
>> 
>> Jason
>
>
>Br, Jarkko
