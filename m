Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793090090;
	b=kuTLatDy47aP/RSBQ8Xto1eJ1GlQWKImF2yYLi443h1EI4yDrGjsD7xF84+WVHiaOkdb
	 hlP+6Qyqt5hvvs5zas4eCCj59KH0OB54CBidR1ps7EfXyUmbSCq/zknGWpFe2FqHMwRmx
	 4UiPx3rbcvfrUzQpuUXHFjDHdjAuZyF+CiFjuxeXmEVDrAawZaVdjs2titCOO5VF4ztPN
	 1aGp/N2rq5pnkAf7vwAAIkrwm/3KDWgyT2UJNbdiBsxKASUxtgn89GJ14Sfbu/aN7duRS
	 R5Zt3hopMEhvYO3wkMIvo5ZFvYqWiG05q9qZsMmyJ35fkB4ADzhRaCCF/J0gOM6CrDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090090;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=JBm8ffaCoPQH1JzTyc8e2It/Betu/HEG2/vRVRWiTUw=;
	b=khLgCQmSseLyuXp+uTKALpbr4APsPtdujraYeQBjzsmPq2tYXsE7HKF2tZjuOrF30Qfr
	 KyONOuj+LeUMbUJ0z+i6y7M5OCfOwGMKhJh2wkqlm4EMLJqiPGbWgw+vYtQJc8tJJbCZh
	 EoXiX+p27Hc52YuvaXXjsyQvk+iOZCDsqePdoJd3YeWY8E1rCh1HyTJ55JxVU2l50zIpk
	 MkEogdQvsc+MQm1kwEuKVllfY7KhMatJZ/aP9KVfncnsiuTar3bO/U+6IK/85hGFoqcJZ
	 BTKjsMz4RuSVPR8VBB4gJeOOPanX7Xb4jLSbc3KA0M1A2uim9fY18Hzw051S8PWJdGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677A2606A324
	for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 08:34:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 677A2606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so20996995e9.3
        for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 01:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793090082; x=1793694882; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JBm8ffaCoPQH1JzTyc8e2It/Betu/HEG2/vRVRWiTUw=;
        b=o3vw+R6WJM/xY5JqumC6/LUb4K4obMv0LWE2BkRABhu2x+bsyUqCR820A7ZCHwkfnC
         Sn/+pQ3m+CYjUbeS9jCMjyJImOaj+z8d/dCOu4EFG3Y1ZhqfTxLIi/tMTL2aAS0KAZjH
         peSCp75+tsY1riFXx52/4tof5ojkSxcnPvRzAH7xQ0h3ImgmU9w0joDiMP/Pi1uMSjFx
         bljGGs0wwgGfu9RqNIdZk/gyQ20assvRY1Gzxql5mzVbAXwP0jDEfcY68G9+Uy9858pf
         CbKr3I6NEEEgEcALs+KrHMjLGmUbg8SPUS8dRewMi3C/7X8PLL31gMcyyHhQAVMuvFwa
         KxbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793090082; x=1793694882;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JBm8ffaCoPQH1JzTyc8e2It/Betu/HEG2/vRVRWiTUw=;
        b=TbGp7hW3eE9d+mt/zbwtnypPgHK9rdm8W4FDdLBerbQ2gFd+cEadiqk+kypYmAIri5
         /3O5r62z+sqdeoRdYGkuSsB1GysCLyaEGXRX3/McroBf6PHOccfkd4bT3uxbRz0Y3y2Z
         2Dzup6zgwJ5Sl/tOcp79i8edj/Wub3KbO2bl3RRH/ScPhiOSdDDeSLymDbPpKUAhpdw6
         /R5jLD9QYQP58RbCPQyWstG0PzNezTb5Ziv2S/iPmrN3n992oDKK8ODO80izjwNCVctZ
         64LLRvGZq+E9hmR1Y9ohn75DVAkapiypCg3jMz07tuRSltpHvESdzMgSM1tbGaxtrjWx
         wTsg==
X-Forwarded-Encrypted: i=1; AKwUvBx6N+428pCTkejzXEMAxfX5pb1Vi/ssR86UhjuH6I7ecPKS02JtsfOpPYmPNO9d7hbw3QcZ8BcOYIw=@vger.kernel.org
X-Gm-Message-State: AFq9FYKNIRkVamUXopiU/uXP35/RBW0X3rkH/qbHIkQ66ldkaxi7i4lt
	ZcApDJL2oIuRLY/i63n0Cdpt410OKujv3Wb7jB3nCfjUwC1bm/WwpMvWodsZ1iKJJgY=
X-Gm-Gg: AYBFou09wVIIIf/GUsyKFESNptb+D/qHVUTeDCPYsYEh/qPYYtr7J+t8TF2AofzkDXv
	NL845SgK5buCt8CuYyC2njrOA5Pcy+yKfoCFZSTgmxjRyWJtypgL8YOFubyyRr2r5Ol6djb5uRF
	nOpCYF0JlLTU11unA712NWaJFCq9C4pyj/T48uvfKkYjljLUdc0M4L416yR9qBzgI6FNXdxyrcP
	cWDnPDoFnfgXROVevjLqugIfAD2X93eHOItbm+saYKvD2+ojyUFpl+T3CJyIWZPwLwEqc4iaMOz
	k9S+JVVQHOTLOB6ywa5jOIYGBSgNdgndAuX0on0r9ad0VpWrBP1EkXiCOo3h/UNRxSyY9z5VUxI
	Vnj7iCuGOqeEFrEZsL6EFznhk2DElIYBrb5TsVzA5yVX5cvU/OMFciq6q+lQ8XBuYDkTSGzp6xk
	/EVWotagXupuQY6U2vPXpay34JnuZ8KT8noGn/WKEoJeMktEkBMXeSA5/SrULdwUbEuinuzF1Vt
	TKDs0cHB6cDeIzkDk50mmNcM5aXggNCoRnK/9pjNP71XOjP3n+pfcZCcnOB7OmA
X-Received: by 2002:a05:600c:19d4:b0:4a2:18d4:f9e0 with SMTP id 5b1f17b1804b1-4a35acbbcaamr167523235e9.25.1793090082317;
        Tue, 27 Oct 2026 01:34:42 -0700 (PDT)
Received: from localhost ([128.77.52.125])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a55e99fsm261457975e9.4.2026.10.27.01.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 01:34:41 -0700 (PDT)
Date: Tue, 27 Oct 2026 09:34:38 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	jgg@ziepe.ca, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 01/20] ctlv: Add the schema language and generator
Message-ID: <auBhwll-zJAaLXRf@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-2-jiri@resnulli.us>
 <20261020233132.793b7e97@jic23-hlaptop>
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
In-Reply-To: <20261020233132.793b7e97@jic23-hlaptop>

Wed, Oct 21, 2026 at 12:31:32AM +0200, jic23@kernel.org wrote:
>On Thu, 15 Oct 2026 16:50:34 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>

[..]

>> +      A named attr set, a whole attr group, or one exact attr as
>> +      "group.attr". There are no tuple selectors and no cross-family
>> +      qualification.
>> +    type: string
>> +    pattern: ^[a-z0-9]+(-[a-z0-9]+)*(\.[a-z0-9]+(-[a-z0-9]+)*)?$
>> +
>> +  selectors:
>> +    oneOf:
>> +      - $ref: '#/$defs/selector'
>> +      - type: array
>> +        minItems: 1
>> +        items:
>> +          $ref: '#/$defs/selector'
>
>My yaml is terrible (and all learnt form reviewing DT bindings which are
>undoubtedly perfect :) but random LLM agrees with me that you can simplify
>this as it's a local definition.  I think doing so makes life a little
>easier for reader by indicating it is thing defined a few lines up.
>
>            $ref: 'selector'
>
>I don't care that much though.

Tried it: $ref is resolved as a URI against the schema's $id, so
'selector' doesn't resolve. '#/$defs/selector' is the shortest form that
works without an extra $id line in every definition, and it is what DT
bindings use, so I'm keeping it.


[..]
