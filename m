Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793884302;
	b=aPLoxCnoFaOyG/MCoROqgld756FNPKABtCfhWr+fLDrnO1mDxCfpXDmD3SR+1qHPIUGe
	 UX5ihav2xke7eBfkTI/qysQxz4zDt75X4uFAeVmQzjgk9JVmJ0Z+QQxINNxy87eVcDqf0
	 0RAXt83RVsB1i1yvDQoo+hSMHpC1bDG+/wxgRs0NKqAu9H1hsb9oBhFjQU/wC02ZotTwD
	 bkrclbD8ArOVd6M/qlS6uiGDIx5as9n5+X1juDJLoG0W8H2pqoeuoxZNhVCgsoxjuEtvi
	 NZLooUBiNjtShG0sNTu0qxgFbyemTYiRcnzr5ylDTIC1DqgmeG5XEoXVsIx88LJpA2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793884302;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=cFWG6Sga3Lp6k+n+muTvwPlAdm13M1aYQLJn0cvv/Mc=;
	b=TSdPcZ17NBp7OYV84SGVNroX+Wxw3SZ9D/syY5eAzwK/gRvtgJmaXrFQEloc/oE8bf80
	 /EcXf3008sxIXlnqZlmJ6VFR7N5n8761nsRsIGeoEWBm1jz5ZDWmkvLY/7+7IzbJQO2ct
	 3t9CcyNUKy9u+zLtbc0Di8y0jNe32rEXiuiahTHhPvvaY77NZrTtun4bY5/4MJKItvNe1
	 ocbOGP14QpwESXr/SROqOpVOv+dDhRKBESHEa15aAsH5Gfp0ANgkKQaKHNGlb3SUpwdbw
	 doJZlRzqjY8byNyBEQ9z6bQcMhy8v0vddvwNlHL4zUXsli0X+l2ffsL2WnZamDlBFhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.167.46
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59444606D815
	for <linux-api@vger.kernel.org>; Thu,  5 Nov 2026 13:11:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59444606D815
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5be3ea5a7adso1565705e87.2
        for <linux-api@vger.kernel.org>; Thu, 05 Nov 2026 05:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793884298; x=1794489098; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cFWG6Sga3Lp6k+n+muTvwPlAdm13M1aYQLJn0cvv/Mc=;
        b=O/WK73xDQgKKqiq4d4hHESILJFUUZ9SW6N85AxaK3rE7ZySNU3qEhKNIEYD1O9eQqI
         95fjFpuc79ZuTRElQ+h02Wj9E5V0JdSNQuaGTA2nDcJfjwcR6SkYbmUTwtS+3MD4FVai
         ypADZ2qW/Q/jvYffnvPAfE4QHI637QdVgl4zoT9tCL8MI048zRl+q75E6+KPj4p4A6Zx
         8ziMQe+vSfe4gTBqJH2XsnQLmfKmDFpDC5GOmuyWNS93SOEMOgYVkUvZ+fTkwWIqFQh4
         8Bfsje7zWlYV6r9bYcca0QX0n264DtY3WiqEOGm9x9Zo+Y7muxa/sL0dJGq9PlVpHr6A
         gqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793884298; x=1794489098;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cFWG6Sga3Lp6k+n+muTvwPlAdm13M1aYQLJn0cvv/Mc=;
        b=sn1rSCOpTb/NohU9WAf9F3M0wrhgWRCUkyKoWhCTUmmWFiySX/uDPJztruypZnuZXu
         MlmxkDh+hyD7K+sxPhCnOd+2d8r6xrCQp7dhoB3fIpRHNuf/s6XdbeKjWnlWcleWnVpU
         ZhcnwmfOaMaMJZEs4NIaHgwG7Cr5KT9IKf+k3UnoysNBv0fKpd69rW5SF4dYjaWAJPft
         R49cT6rabOCCey+bZGjB+ORx7oTmVEqhCcrWrvuIkOrUIkEkfEouCPAmPqlQVI/gmAMg
         O/VloZJc1CA/WvKt5CNSzLoCeIhb8vcS6ShhUT5JbL4i8xg8/infNKd/BDg0bsJE+Guc
         Unuw==
X-Forwarded-Encrypted: i=1; AKwUvBwaoQ8FnhHycnKCIj8yKN4QVf9IWfD4S6xNkUQ2ahGOHZ3vbBm/LROHTgXwT+NcLIfVjmr5gS5lr64=@vger.kernel.org
X-Gm-Message-State: APuU4Z+9V2jbTo1DLh3/UynVpIHGQ5w/j4qKAeQujhEfIB9UQLuJ7KtM
	rk3Nr34KG6u+1EQjZO3sHPnmevZ21pu6sCTB3uOg1ctJsXGFSCNIKxq7gc40qySx11A=
X-Gm-Gg: AYBFou0smLoyMb1Lgf9+pM7GONaUO8IMkQVLuJJrtVB8HoMNX/bTY0K9xxqUd7b6WNO
	UGtgR21+AI069ke/LyCJXybwTkOw0JsbYjHNq2w8AaTmXzQTHlOnV8vmCfiv4PHDrpeFqmQqmBS
	nwx/IJjdOeDNZVK9AmqQd/a3ONCbRGS3loZvA78wpyf5g8hd0s8Y495aItMsRAqIXHUeXGpN4PG
	pG+RON7IY5CbC5i/k5371lweixV0gEA4oO5L8qoVo+LWoLVxbI9VOo9PlilcK8qrmDV48+a9Bwh
	L8tMrQH2TYfxaP+LFwQSMvH6UXLm6Ks+W5rbTMnSBl0EXXJ6D63nDhg21bqKdOhkX5hoO+pJkj1
	7YXX5d5wPPAbX83+3DrJSDC2CiKRMWLK1q8J3zRp+GzPG2FxiS6VITGDBBFZO2fNW1/tEqwBauh
	qdWvaiThAe1oL+aM/aJFuBdS6FTGH5bKZmSWpWP1ceBnoZiVqfzdlkZMDNXjm8SsD+4KbUn7NPb
	GZLj4yU+1KfSa1N84iOoG6aFqajKeRGvtD0sSes3dIwsQ1hP0aYdolm7vLSVOfxCrR3sHfZ6d+Z
	hvI1ZP7rZK9NoqiBGtAp3iLSx2zT5FKHEFzdV+mafOByrLhlynfR4fC6evc=
X-Received: by 2002:a05:6512:128a:b0:5b8:fa05:e49c with SMTP id 2adb3069b0e04-5bfd9569d40mr7209047e87.34.1793884298157;
        Thu, 05 Nov 2026 05:11:38 -0800 (PST)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bff38ab798sm817490e87.23.2026.11.05.05.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 05:11:37 -0800 (PST)
Date: Thu, 5 Nov 2026 14:11:32 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 02/20] ctlv: Add the UAPI wire format and family API
Message-ID: <auyAJ8OMWHUTCFKs@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-3-jiri@resnulli.us>
 <at-iEMxN98nie1Qr@e129823.arm.com>
 <auBaROC0XdWpILEI@FV6GYCPJ69>
 <20261027141524.GF1685504@ziepe.ca>
 <auC5sw9YMC9NO4wl@e129823.arm.com>
 <20261027151729.GG1685504@ziepe.ca>
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
In-Reply-To: <20261027151729.GG1685504@ziepe.ca>

Tue, Oct 27, 2026 at 04:17:29PM +0100, jgg@ziepe.ca wrote:
>On Tue, Oct 27, 2026 at 02:48:19PM +0000, Yeoreum Yun wrote:
>> > On Tue, Oct 27, 2026 at 09:02:14AM +0100, Jiri Pirko wrote:
>> > > Mon, Oct 26, 2026 at 07:55:12PM +0100, yeoreum.yun@arm.com wrote:
>> > > >[    3.856919]  ctlv_schema_check_attr+0x3dc/0x538
>> > > >[    3.857105]  ctlv_schema_check_indexed_nest+0x788/0x958
>> > > >[    3.857301]  ctlv_schema_validate+0x88/0x180
>> > > >[    3.857482]  ctlv_msg_test_as_deep_as_the_core_allows+0x11c/0x1e8
>> > > >[    3.857698]  kunit_try_run_case+0x64/0x188
>> > > >[    3.857878]  kunit_generic_run_threadfn_adapter+0x30/0x68
>> > > >[    3.858086]  kthread+0x10c/0x140
>> > > >[    3.858245]  ret_from_fork+0x10/0x20
>> > > >[    3.858398] SMP: stopping secondary CPUs
>> > > >[    3.858630] Kernel Offset: disabled
>> > > >[    3.858720] CPU features: 0x0,00000000,00b0802e,9f190bc3,2affe72f
>> > > >[    3.858872] Memory Limit: none
>> > > >[    3.858976] ---[ end Kernel panic - not syncing: kernel stack overflow ]---
>> > > >
>> > > >[...]
>> > > >
>> > > >I think it might be good to configurable according to architecture
>> > > >unless it's not good to reduce the CTLV_MAX_NEST_DEPTH number
>> > > >otherwise, increasing stack size when CTLV is enabled seems unresonable...
>> > > 
>> > > Agreed, will lower it down. I think we should be okay with 8 for start.
>> > 
>> > I'm surprised this ran out of stack though with even as few as
>> > 32 levels.. Is there accidently something large on the stack?
>> >
>> 
>> Nope.
>> 
>> When I see the each functions stack allocation:
>> - ctlv_schema_check_indexed_nest():
>> 	sub	sp, sp, #0xf0 // 240 bytes
>> 
>> - ctlv_schema_check_attr():
>> 	sub	sp, sp, #0xb0 // 176 bytes
>> 
>> Roughly (240 + 176) * CTLV_MAX_NEST_DEPTH = 13,952 (around 14KB)
>> consumed.
>
>400 bytes per nest seems pretty big to me...
>
>Do you have debug options enabled or something that increases stack usage?

KASAN is such an option. On arm64 with GCC 15, the stack protector and
zero-initialized stack variables, ctlv_schema_check_indexed_nest() takes
208 bytes and ctlv_schema_check_attr() 144 without KASAN. With generic
KASAN, which instruments the stack with GCC, they take 432 and 304: the
redzones around every local whose address is taken more than double both
frames. Your numbers are in between, I guess a different compiler or
KASAN mode.

Otherwise there is nothing large on the stack. 96 of the 208 bytes hold
the callee-saved registers, the rest are small locals and spills. It is
just two frames per nesting level.
With the limit lowered to 8, validation at the maximum depth takes about
3KB, about 6KB with generic KASAN.

