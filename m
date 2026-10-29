Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793266215;
	b=sVKYPnG4Eqq4W8t5oFdbPT8q6/woDV4nEqo3ejg7RDoeJVrXkwS+mDdqR0OmhsoiE6Ec
	 fh4y17uhmGR5n3amv4LOh/URllMhHlW64sa8/DJOgwe3s91MknwgmvKylfJOSRITrCssS
	 VRRrJ1gPz2LMGRFNITqFUlQcvL11s9EaukyQQSZXsnxD7l5bt9f5ig0sN0ssbDBCMKDrT
	 l0XtQ5nqt6UzbVxvEwhFOtuFm0sLDvCDxDME5P4F8EHlaxMMrAHF6aYzn0X1+V5NABeMD
	 n1qXQHF8QKAixAqbjOqRGdm0wrkSvtiu3/14Pxtlzh3GSDo7ttVliw5KNkWbZMBToqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793266215;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=SxasBSQqzrj10fgfbmH9pq+LqGH/ruAKc1rAsZ6gHrY=;
	b=4t2VuxtjyBABiUgRkPJ3dOaogS7ChMj1bBSnhfvsQymP8ekK125rs39FXK5/wu1ghTyM
	 EvcgEhiP5OKgC8lLxNXolY+13uo6/A4vjVgTS1gkYK5C0y1U4E4jiT2GWklHkTaRU81IC
	 DGVvm36nSBIYr5WCfEsbNkcAxc4tMNuCdfyqNXi6Z2h2DtAr+qxdraiqTDutFJTXJ8mYu
	 8p1JQ8/+W/HB3tK00hwTxIvtKXzLLQOHHI5PeoHb+qJfKfuVuTLLmoxG6k70XfTZDYIX1
	 aWNlvBSzdEShXYJH5Mm98DqvgDbD39/rmD8SzNMpfAFJ0IyIdCq11rbbenF87ZI555g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7746606A31D
	for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 09:30:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7746606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso12982325e9.0
        for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 02:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793266207; x=1793871007; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SxasBSQqzrj10fgfbmH9pq+LqGH/ruAKc1rAsZ6gHrY=;
        b=quH9pYLZIETR04d3yKmQFTy1ZqTKb6PP40cYO4TwGO4bHDxZVFg1XfSuuw/cJ+9GOV
         6s0JSiO6XSVuxhaXSYJyGQIp1h/4Q2EbGvVtF7mFxGpuOMG4BCW/+ShuvuVMiCB23+Sv
         Bl3oHpiRalOlsDzuoXZwV8CH9JdaDYkiilX7JIPQYGtVqepwEXJiuQHPEC10+3c2p3Pt
         hnDIzFK9kttO9BFinkggUOPnm+39Nv0Vz7t4fEXEWCHfecizU7Za/hbrKdJFrkwS52jI
         p8NYQGUFduovAJ02P+qtE0BTvnmGgcxknifYKHNwpMuifDLSTHBCMuINlRMDvR6DAakd
         KZxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793266207; x=1793871007;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SxasBSQqzrj10fgfbmH9pq+LqGH/ruAKc1rAsZ6gHrY=;
        b=aetmR76UouIQWVJzaZ/3EdtHmzyRMr3cjd8W/4PeaaAwzwfKv48rKK98ZjkwBTFnIx
         nSDVq9hZ0pFHgZ32bm3FafM4PJmj6jo/MjBezXc2sL01wMnFt2ZXJRcu4O+L0Cvh7h86
         x16zmNIjh2uipt/kBSKxwv8C4ijX81sarmRfY++sLboj/cyDORPr3p0m9TIWOVHeeT0r
         W0ce5QQlaBIU5PMm4ktW7QAQCFpQOR3H+FjDipu1Cxcc0Lax8Ni3t4S1b5nfvkooayks
         xNpWjoBf5uWtkckSrjtZr/hYYA8SIwIeh31pNT3OKuS2mcp2ab5Yr/vskY3nJKUxvyTx
         c+Kw==
X-Forwarded-Encrypted: i=1; AKwUvBw7hlupR4jqirgpWPhrA4SAvudVEaaytOq4LZjGUI+Ejk5sTqBFqGodt7pg+rf+TwICmcpTzKLYU9w=@vger.kernel.org
X-Gm-Message-State: AFq9FYIrbrXMeKcGBpLwEZCoMlWPg3kp/Ye8VDoogawM8MAWKxEYYzqa
	qEz4xkt4ET+hJcFENJi7CiAp7K9LUVUg8+RVtcUoTuHB0EmK1ELVkHjCMjmb9rb4gxc/8NfG5iZ
	SAjtyi4Y=
X-Gm-Gg: AYBFou1GRgrPqI6QXYxz39eHbiY+bsq/xgXt2DTnBk2G9fniPJFCtAEcpdm0jfuSmmt
	hsiwfZk2s8JyTjJ9AK3KfS8W8zW2jl8HeskzN5jwdvoUIrG5W3FZYI8QDwGouETDnSmzIpHn39t
	xmbKv1P0fR+CtJf46foHR+uxk3y/gREORG0WVII6zL1/UMIuDUNxAMruo2DifvGbJKd3t9C67bX
	fOddCBKCO+PHmjXNmXJ6hzDBm/hgvDvRkR+E3+0LpOEORxMDCkRf4Ees6RCgVj0Syyx+m+f5XTr
	AOcQYQaYhq8sStogmcltVzimwu5TzYC7d1Xh41cqrUUF1S+6ykhYR1OUtnW9B91WbvjEXGK2or3
	H49EPZc7rW678iyyclDgfPY+BLpQ2XUw3lpYEb1AlXYeSVJZHh5DJBVOOLdVAtPw+YYv5TrEZ1Q
	BVM+FrjRyrSeOuvZvuRcY2uVQK9wzUga+wk+84EQuUIwHpfrafkof+nKKA09einJ0Sbn5liuU8H
	zZeJTQnoT6HqDoXACdS1vgFpTqC50Ewz8I96IBZ9lQU33tPdbuHd/pCb8lGt088uSKiCP6uQ0gf
	/64MFXzO2ppTMHK4/hQeFgPri3+d20AREcT48A==
X-Received: by 2002:a05:600c:3b11:b0:4a1:dade:f049 with SMTP id 5b1f17b1804b1-4a966c41007mr110102485e9.15.1793266206771;
        Thu, 29 Oct 2026 02:30:06 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd37f4sm40285265f8f.44.2026.10.29.02.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 02:30:06 -0700 (PDT)
Date: Thu, 29 Oct 2026 10:30:01 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-coco@lists.linux.dev, 
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
Message-ID: <auMR_GztmsRcEHpv@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <592d643f-e97d-4de8-9a87-e47d57dc8457@intel.com>
 <20261027193629.GK1685504@ziepe.ca>
 <5f33aeed-a20d-4881-9ccf-a69bc308d348@intel.com>
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
In-Reply-To: <5f33aeed-a20d-4881-9ccf-a69bc308d348@intel.com>

Wed, Oct 28, 2026 at 12:09:19AM +0100, dave.jiang@intel.com wrote:
>
>
>On 10/27/26 12:36 PM, Jason Gunthorpe wrote:
>> On Tue, Oct 27, 2026 at 11:43:04AM -0700, Dave Jiang wrote:
>> 

[..]

>
>>  
>>> 6. tdx_attestation_test's discovery_and_construction_fields expects an
>>>    inheritance chain of 4, but the TDX family inherits ctlv-attestation
>>>    directly, which gives 3. In a real TDX guest it fails with
>>>    "Expected 4 (4) == ctlv_chain_len(self->dev) (3)".
>> 
>> I would have naively guessed this should inherent from some SPDM family?
>
>The TDX family is the TD's own attestation (TD report, Quote and RTMRs), with
>no device or SPDM in it. In wip_attestation_all_1 it inherits ctlv-attestation
>directly, so I think the test's 4 is what's stale. Jiri would know for sure.

Yeah, looks like the test is stale indeed.

>
>DJ
