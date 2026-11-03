Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793695143;
	b=lovuFf7V97GokdKHfIktjatCrf0Y1SrOhR62SPm/60Zp6VHnZOwHFONDk08g2XWKXI5V
	 fq01mI14oxlcS8amnY3agdJVxxsKg3ZgmZedqja64Zm1zARSeXSiIzLivqUCXvZWGWeQY
	 3FIt2KWIbNx1LGbrlk9jrFFlgWKdoF2GKfeoITEWnhmrTi3KfdkAHKXH74Sc8jOlQ454D
	 ZziVBkcsVlnUPobiZcXm3kjkY8HsC+VRyrIkU/c8O4i4EUuYKeWpDFdj54hrb6rFIou33
	 UwANPl1sJVaZscsmXWXOSiiA1ED/N+UD9OkSryUAKz1SE8gpmVvEhSKuWkfFvKZiB+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793695143;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=MRTks+7ld7RMCsMZY4NHpGohDqoSKPsEVE5vKTy4ZGs=;
	b=w09cNMsl/85hCl620QPI5gJvcqnYUHh5el0rA2+umJcLfGlMh5YDVdbmdJyi06XOOOtW
	 pNB96uTDtwk4rZqtXetM9ex6/JvJfD63KJunwt9OPLw+ALY1s9k2CrEyGJIzUm5qdH0o3
	 u760SqEATViE1ZrXuEtQKgNjlM4gn7dle8eFKjViI7JVmJpE7wk6lnshcKZUFLAnV4OYo
	 u1d94lCJeCFVo+MjQJ9QEC7nccTCniSqDqE7w94rmWho45GJgK9tg19zUxIBNsPkzcSgc
	 Ke/yQ5fUpfsqINdEhZSMe8+ySVT8nlzGZr5aAv1K+lmu1bcq9XGQcZvf98tTfWjYdGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=FzhtqlhW;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AABA606A32F
	for <linux-api@vger.kernel.org>; Tue,  3 Nov 2026 08:38:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AABA606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=FzhtqlhW
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so4000575e9.0
        for <linux-api@vger.kernel.org>; Tue, 03 Nov 2026 00:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793695135; x=1794299935; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MRTks+7ld7RMCsMZY4NHpGohDqoSKPsEVE5vKTy4ZGs=;
        b=FzhtqlhWaJl8/mR5HSEsoDwcWP7F6hzS6SADauqAQGdfoDE1MyfnX/pMvL8xxXfm6y
         GIu5T3pkFU7JZwkuiHng+TEYbg3mYN0Dnc4ZcreC9vKEFh1iTWYxTUNtP6YOIxkyb++g
         pfSfRH1bj01FENErN9h5Es4nug0+yQGK7BzSD7NSZIICk93SgEaHo5iWQO573bppmgy4
         JGinVjtRi4ZFntVmtNpKEMwWBwNfJl4ufBshlTDs6VNMyRBFna8wYzNCOqkdAsH+unnU
         WbEmFhkkGduaAnA+odcSRJ4a5quFKvu+hFPS9DojkfnVsZgGsJEFJVYYS19OH/GsH9++
         ySCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793695135; x=1794299935;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MRTks+7ld7RMCsMZY4NHpGohDqoSKPsEVE5vKTy4ZGs=;
        b=L3/jT+BqRLBFkeNGmg5f9qTb/pAkUs4/qUlp4ALsxm18reO5dZr35vj0QCiOaPxgAs
         DOJgQiQ/6/LLfpeFK2lndFyRvtlQArRcJfsEC9tEemcSh+rcxKMg0lYKcuqZPrk5tNZY
         uyZHG+JIBngf46cL6OYru+BUKkgp/dzfNc7tr4HLWmzmkhp7SmT8XUSQo6DMvssk26vf
         pkaG11RYxmk8l0F4vyBacyJND3dsPQq7S/fSRQTq1p27P8l1c121qbZxfE9tHJjhZm6S
         cH2vBl9KzsYBGVpwJQmcxuWBjGmoAfSkfOBStjgZs/ysOc6mbtXwzT8TYmofYFKEjmx6
         mRwg==
X-Forwarded-Encrypted: i=1; AKwUvBxeP9+aBwpjSPE20Cp/iDPDkrsljkk/QXIU3DaABCwgTwyfZSMUZkOjGrgRZv+lTpOrdmKA2EE7da8=@vger.kernel.org
X-Gm-Message-State: APuU4Z/JbZh3IYsOkQR8nawjQV+hGAt6qmpuh1MCOGrnZ3Usanh179HQ
	rtiIfJznaCW3QaT3FR/pRV096fKcQcvtQG8SbXmsxoCGrSsibLI3wj5FFQ9mhUg1phk=
X-Gm-Gg: AYBFou3l8PWYESq9xBYb9hyAYPANJixa30YpfzKvmBUnYdWs2MSX8Y0rCUrtAbJxPYh
	ZFNwcgO9vlB80zXcI4xI8MM3rIdT8zaiteXuiUlCZjTkgbUB4ODApfQT12458ITGAXjuOEcl/5z
	DNxCAYXeLqSf6XaQA37zqUOJwVe6UU/4/p4fC1MU2WWjvl3aMiWQg2JHnKy+bPWH7TFkP5sBm9l
	8D/TqSIWS2zc/XKa1J5axYexFYQwRC1ObKJdld08vCqpdjmOmcrKmKqflMOx8GoSj3FWpEwgfZR
	xVN0BgxLVMIpPZnVwU0z6puLcB38ZWBOL4CxufTCvRMXLQ1kHRPeovCpFZUyLBAczS0ObBkNXya
	nyWEswn3WBuA2Z6SX9Ob1P+ctnYyBELZbiNzDDz4TlnZK9w1oRk6XI7/7JE+mucCCbCY8BmkWp8
	eE8zC8gAJcFi4O2Yr01UQF7d56u8/7rzWZ5+4gr7nsDqGhTsiAu4WJP/ugKAOlDB++7bKiGaAJT
	xyKpCujPiulVXlRrodItUZMjqGIFlC3Ok7Avaoy5ghx26S0JRV9XXjPu58RSlhxjsLaPNdWQ18M
	rncbTcylALXzgmZQAcBKc7PPN1/cnM7Qfu/9N6dAc3PMFbLGGuE19G54JBM=
X-Received: by 2002:a05:600c:8116:b0:4a0:20b4:ba93 with SMTP id 5b1f17b1804b1-4ac17e10724mr285917965e9.16.1793695135152;
        Tue, 03 Nov 2026 00:38:55 -0800 (PST)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm432002285e9.1.2026.11.03.00.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:38:54 -0800 (PST)
Date: Tue, 3 Nov 2026 09:38:50 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, 
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com, 
	cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <aumdeBFHvrN5_NgX@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <yq5a7bjajaco.fsf@kernel.org>
 <atooh7uO2RauUTfY@FV6GYCPJ69>
 <yq5av76sj10a.fsf@kernel.org>
 <20261023142038.GE3977851@ziepe.ca>
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
In-Reply-To: <20261023142038.GE3977851@ziepe.ca>

Fri, Oct 23, 2026 at 04:20:38PM +0200, jgg@ziepe.ca wrote:
>On Fri, Oct 23, 2026 at 01:34:53PM +0530, Aneesh Kumar K.V wrote:

[..]

>> 
>> ./ctlvctl/ctlvctl --spec-dir=./specs/ exec ctlv0 device-get                                                               
>> # device-get, 1 fragment, generation 0                                                                                      
>>   device.generation 0            
>>   device.caps                                                                                                               
>>     cap.evidence                                                                                                            
>>       cap.min-challenge-length 0                                                                                            
>>       cap.max-challenge-length 0                                                                                            
>>       cap.max-total-output-length 369098752                                                                                 
>>       cap.evidence-flags evidence-accept
>>       cap.object                                                                                                            
>>         cap.blob-class cert-chain                                                                                           
>>         cap.blob-instance 0                                                                                                 
>>         cap.format spdm-cert-chain
>>         cap.representation raw                                                                                              
>>         cap.representation tcb-digest                                                                                       
>>         cap.hash-algo 4                                                                                                     
>>         cap.hash-algo 5          
>>         cap.hash-algo 6                                                                                                     
>>         cap.max-length 16777216                                                                                             
>>   device.info                                                                                                               
>>     pci.name 0000:02:00.0                       
>> 
>> I think we can use evidence-refresh to select the blob-instance for the
>> desired slot once the CCA specification supports that.
>
>Jiri these ctlv outputs are really neat, it would be nice to include
>some of them in the commit messages so people can get a sense of how
>this looks without running it?

Okay.

[..]
