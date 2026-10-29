Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793266379;
	b=v0eGjP1odRuPK6MhWpcDlf69XFBuvd+++78TBk0pj2Iav416YRLUx+VRDf3kJ8vNIGXL
	 REMFvt3GDoYTWj3X+8XIffLiYI437CXM3aCnWBH/INLe+gMXxc2X8MJ07P0dzUhB20efZ
	 tve2ie+SFYV4VAtQPHOxXbMLKmsRFRYMk7lvpXn5a8WbzburOVohU4Cp9Ru+SwTzOCNPy
	 xc5driRH9aWySBOAvBCNLglF/JEsVobqejcJFdJKLteW8IdjizEemgScP/KarcLb27CpW
	 +cT31hWyjMEbx+y2NuDTdDT5aDIATqbh9AKOkb+ZaFR9VPEIWcERvA55xxHtOGDiFng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793266379;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=25Xe2LGlhfjUVvHKZS8zB+EQgKUVnKIy/4iS8f7+DSY=;
	b=C7GEUQjhps4eXz8vli1Vxy/+Z/PP3Yuo8+pw756PuYrrHqEvhCxqjWNx51VRKD4BbsgL
	 78Bp1rt20sLihX2ZO9Wmh5IVouO7XTrqPcIeMG+H0enDPkK4XMdmqOQDmhOF9M+mG9WfS
	 minokAADMv76RCDXA8Y/VwJrBSn69+FvIF4wlXBYUgqNsn2O0asHW0il9e2mo1Mv3t240
	 N8klLcgGOaGVAcu9ofp+34bwqIheY3wrsO7hQKurUlV+yc5KMiLDWL6YofS3QwPluROhH
	 KHmXFStVLSjTNElMbK81Mertq4dWU0nKw7H9sauxj83BJ+x6TBeHTJDFDdNvFBpsCow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D53606A31E
	for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 09:32:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4D53606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso13028905e9.1
        for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 02:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793266377; x=1793871177; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=25Xe2LGlhfjUVvHKZS8zB+EQgKUVnKIy/4iS8f7+DSY=;
        b=QH69CTU+mXD9r/mvEuahgml2HOKFQRQJRW8BDZn+++9cViMZQc/pcNx8tmGqUlzfst
         VGUgif0Z8D7dZmUQqjKAyfKtT49slL0aATVCJvSp8Pah7juV8r8n2umG7Hsbtw7LWYXs
         e3Lidy6xFzE4p4IJ/Ru/yw1c4e6NtsU5b+8JxoyD6sa+3d/+tTabLmRxA/oJ9qkiL1Ir
         hP8YXvceBTsFHvjt4RNrthEjgcD61ucWib5a7uANRq+iQ6GS+WgvB3ZcOP3yzxdiOdOl
         LJph8ZfuS8zWbl59DoBWEwStQfyFGxQ/qLXI6YS4TDEaxNEqX+9iCbR8qm/HQnRzaKUm
         NX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793266377; x=1793871177;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=25Xe2LGlhfjUVvHKZS8zB+EQgKUVnKIy/4iS8f7+DSY=;
        b=P+nhoCTdwNoawZGe5IETXuaURVY81N5B9iz2UPwJ3Zmaqufx4bF1BuG/MVmyDrn/CK
         r0Yknya4AusB6vYne/X72jauw4HSW9uxYUMrvKpwyfiNbUmh2qzCYHewmqUDzLfYjKbo
         RFE8ujvcDtT1u+ItieJxrX7Sgq2brRjIzb3iiPsvnX96vcCx4PgyzrKwW7ybI0Q0fQnf
         sD/ERDvQQqFBp2EnM6s+k+u5zCihzsvFUqQH8I6YI+O0lqcdryzdD90qP2HHTmnG3KUz
         UFQ2Ryb2YAqow4dh998HZeu2gD6tcL1Vbe9UChhwpY0Q6eWYbMvYQaAwy0rGWM31QXc5
         UffA==
X-Forwarded-Encrypted: i=1; AKwUvBy7rfkmGK4a7+f8t5ABU0Q9QgtlvTS/QfviQbr0K8CCQcRH9un7pDqEep9fps86Y2OYAsU4YpNgu6U=@vger.kernel.org
X-Gm-Message-State: AFq9FYIfBhUDCTsc1kgifcjMgVhyAu40RSkPGS/rHuDUxhOTGTjneblr
	4JZbEA10+EkWcMILhF4HE2fDzhsjnBiwLMw70xG2z4WpoMZO8hnHFdMQGxtOhDxYc5CctVLKWGu
	dgpfXW6c=
X-Gm-Gg: AYBFou3Dvh1iHlLnpHipO7jlCm+PP83/SzgAk8q/sagHq2cVsBDUskKIZxcgcnnifXt
	BgZ+aVlU5gbjQ07QemgNu+oxNXfHrBd8Micka60el1W2jpdUBexqhZNksWcy/JzuWsVvZjjJ08p
	RqVrgiSvhcF3WwDbHDyizm4WRALCEoQs3nQtE1IY1xn1B62vKpP7PJLlu+az2cAJZ9z/6ITRf4g
	plG6mGXlFiY4PkYiH32Z8YVYgpiLtWr62p08Z2DwdPtqBWwbhoAh875rlDrhXMQYnp6wmmdCf12
	Yr6+dtT4/E8zcnyE9DD3N14TGgAWGBHfIwysE33KFZjV50Zx1phjvwkLzR7OGvWgNIl7uusCGkY
	Lp5tUuyTD+6+J4doozzGi/4ZQ7GCsJWMVMl6t+VkQImKRURjAjrqnFPTxgxHbLsHCDT/mXbvs8C
	XQWyIC2XCvqw/acWeCaFsRRyGC8vfBRwVI2gwTLOt0rvQ3gcYiDjXwqllBBdbe+LxH/5wBXjyCP
	w1RaetERYyEYfDjrIPJJ6HvbRPDUSZSyVTPzGbhvxoaZwOTIfYI//ckFNuxTdSBviwxlFVA9oCy
	ka/hQHp8oiNET4rL3G68irUeF5kkcN/ThXnrXg==
X-Received: by 2002:a05:600c:1909:b0:4a2:1e1:d55 with SMTP id 5b1f17b1804b1-4a9675dc5cfmr104826795e9.28.1793266376792;
        Thu, 29 Oct 2026 02:32:56 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80285b2dsm52889635e9.13.2026.10.29.02.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 02:32:56 -0700 (PDT)
Date: Thu, 29 Oct 2026 10:32:51 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <auMSPNNXZv1f43v7@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <592d643f-e97d-4de8-9a87-e47d57dc8457@intel.com>
 <20261027193629.GK1685504@ziepe.ca>
 <5f33aeed-a20d-4881-9ccf-a69bc308d348@intel.com>
 <20261027234658.GL1685504@ziepe.ca>
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
In-Reply-To: <20261027234658.GL1685504@ziepe.ca>

Wed, Oct 28, 2026 at 12:46:58AM +0100, jgg@ziepe.ca wrote:
>On Tue, Oct 27, 2026 at 04:09:19PM -0700, Dave Jiang wrote:
>

[..]

>
>> >> 6. tdx_attestation_test's discovery_and_construction_fields expects an
>> >>    inheritance chain of 4, but the TDX family inherits ctlv-attestation
>> >>    directly, which gives 3. In a real TDX guest it fails with
>> >>    "Expected 4 (4) == ctlv_chain_len(self->dev) (3)".
>> > 
>> > I would have naively guessed this should inherent from some SPDM family?
>> 
>> The TDX family is the TD's own attestation (TD report, Quote and RTMRs), with
>> no device or SPDM in it. In wip_attestation_all_1 it inherits ctlv-attestation
>> directly, so I think the test's 4 is what's stale. Jiri would know for sure.
>
>I think TDX report/quote/rtmrs should be a different familiy from TDX device
>assignment SPDM. They are completely different things.

correct:
1) ctlv-attestation-tdx
2) ctlv-attestation-spdm

The spdm instance is backed by particular implementation/transport.
