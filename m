Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792587896;
	b=iW/ouOmSmn0QCuVq4Sn0F0qeI5ROJf5aBk9/0HLE3OAyy+CcL9XqVmFIzBZ2pq5+Pefk
	 xwZ35QErZWOioWoOanSQYItefHnV9KBjDrqC0r081VgxX27+iE7+J18/SUuwaeWqRv8/P
	 cYrrxaaNXGY5QxSvuXqjYUCr9L211MAL5A1U7AGN6dLYiw/KValIjGTE8FEZl142J3WjS
	 5PzbKa7znhtD3zKtLb1u5vVlKyMUo99uiF8hpAAu35sQG7Sq20uH28VYY0C44CXqOOTHq
	 5H5OrrxwTaENyW7jJaf/up0V49hBmdY4kCSeKqYz+ne5dvlvX0h8cBfkhA8HRfo7nZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792587896;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=XBJOZdPNJaWBnEXbMM9r6oKBxoRWtijN3lb4QnOPdPU=;
	b=BA9nN6FRR2KaISTuC8ObA8RP+NDgH9wtnNexWlJJmzztvyplAZJFE7zd4rNtpxaDy8mx
	 qc7pG2sFgOtY0j6DJx91QHDq93ln5UqUExrWb+uG38HY/XgSszZ3aCqPo3gwOGlhlT1az
	 Nx49r7pYi2tW4Hn4ouikZD3Y5o3Aw8a+7s0SsUyTdIeAFVbIoR1CfSH9iRP4EuZ6Wr/G+
	 rUui+exZvnUJ6EQ1TDMncPT+PgNlcGW/+lm/0HQzP2tlYjjVW5gF9GdYaMccrdV1TFBhJ
	 VJpxxlrE7gDUK9Fq5AmXkk62JjPnenEwaevj/Hjg1OZgOlGCg6sEl5XNPH+9EIpf10g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=CFLBbsMY;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F07606A31E
	for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 13:04:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68F07606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=CFLBbsMY
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a1d293b293so4004325e9.2
        for <linux-api@vger.kernel.org>; Wed, 21 Oct 2026 06:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1792587893; x=1793192693; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XBJOZdPNJaWBnEXbMM9r6oKBxoRWtijN3lb4QnOPdPU=;
        b=CFLBbsMYwkrufn9yAq0dSA5Z2c8I2rI4qRFb2c71CsfhYTuPu1XRsLh69ZdtqYM98x
         9C7RY1x4yjmLKjlv5JMunmxpuiHgr10OI/zCMoNcmyFwjHLmzfgUNQ8rWUEAJRoNAgPd
         zx6f1rQ+q6QLX+7BmMwMlP6A/8+Oc5Yrau5gTZOanD+1ts5Aa7lgDfF10KVx3gHSb730
         rAnUJJ7t2T2AqgXlhscveNcqek8YMjE2eKzx6NEQ7hcihBA0/X7uvPVcD7TOMvGRg+CI
         VJqsYeSAGOgzr7gowdk3glF2ev0bFVuPoPFN+QB9wwVANRdfS5JCQbZWv6FroeDwvu9l
         NhoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792587893; x=1793192693;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XBJOZdPNJaWBnEXbMM9r6oKBxoRWtijN3lb4QnOPdPU=;
        b=vEmc08omsc6MIYO9VnqkWK+BeXwkpN/RTiF9kuYAVCfEtbVi9EpFS2tdkpAMfAypw1
         hipldEo/WU5Y9P20XViFvMF3nUE3cs8fmF6lSukkuJJ9DYHJY4bhVSC+NVcDGVyviQ51
         +pVf31Cpv3rHGOfSyH2aY9+LWbdrpyVz2k6Wmh848VnWg0o+tXc5GPWN2AL9KW7Ud5P0
         nB6czq+/t8ekBRy4H5smTtv0tSDS5/SN/jHhwbkevgL8v2bi5RYuD5iHHjjvEfxtSjvC
         VzHGpe2LScTd/3xxWNcDpN8/pO6snSJy1aEcdVefS99xDofDnzcWG3vzDzoJLOYPqX+7
         qIRQ==
X-Forwarded-Encrypted: i=1; AKwUvBzr5HgcrznYiOlhm7lRDAnAEr1adNKLyIWF0crodY1l01ZXuTxweRnFLusw5eQm4QN0kBq5ubHgkGg=@vger.kernel.org
X-Gm-Message-State: AFq9FYLU0yIgDtpWui8xv8Ce74be6AH5jAEirOjXdWcLxQNRv2ZQhmXg
	HtkfFb58+y+AFIF5GX25JFphFf8WKD7eNmRF5vJM2PSPaYcuxRhp5o3DozidLfgDgJI=
X-Gm-Gg: AYBFou2q0d6E+XfBCWJeh/AQNlwBF2xOBMV4TbIaslTXWjI+8m4C3dTfYuNFvk/oIoB
	Ixr8a/bffiVqgVsMpBn37cd1tXp0P+xFQidAyzStM5T25aU8n+siTabh0mFkeYm3G7dEYUYI9Oa
	verWEZfmZsx3BUho5PDVsKuSfPlV3Wo3CMIuPlk/7129EObC/1NC+R1/BQ+YuCmLMbbdV/NKULp
	U2A2jylcpHixWZamDV2bRGGXj7m+WpUp8cyRmGCLJKz06CLfd5SI0ZbOws1pD0fUDOLAhFMSC2c
	6EKmBLv8dzZpxm0s9QeqRjhyCwyeWaRfJ4gn8z37Vk5wudqyPWHCam/AHnpXJWIZfJ4NngtLmzj
	evqtuD0fC1TG/Z8KccMfBIXmfDHIGnZfrV2HS1k7YUNFKnEtNQwGzfw9mYY++jYYBDaen2fvL+q
	zAmGIjAkCdYlMv4eV+AYjspAlWv/TSOeFjdUl0fX+rxtBRp7ienXlGeL0cu+4jUySKqDxPIKw6J
	xaRrPkUy+FnZeyWNFwX26OghiQCB6EfkRIZAk4E6U8FXuQO23wqCsj9Ittx/55RoGzx0wmkIhjA
	9fzSV43Bx80k
X-Received: by 2002:a05:600c:3512:b0:4a1:e00b:a0ea with SMTP id 5b1f17b1804b1-4a1fd8a3fd3mr39461765e9.1.1792587893167;
        Wed, 21 Oct 2026 06:04:53 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25835c77sm5101952f8f.36.2026.10.21.06.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 06:04:52 -0700 (PDT)
Date: Wed, 21 Oct 2026 15:04:49 +0200
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
Subject: Re: [PATCH RFC 15/20] attestation: Prepare provider and instance core
Message-ID: <ati4arl9sf1Rgnob@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-16-jiri@resnulli.us>
 <179245258506.58760.1633805100070716498.b4-review@b4>
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
In-Reply-To: <179245258506.58760.1633805100070716498.b4-review@b4>

Tue, Oct 20, 2026 at 01:29:45AM +0200, jgg@nvidia.com wrote:
>> [ ... 99 lines skipped ... ]
>> +++ b/drivers/attestation/Kconfig
>> @@ -0,0 +1,12 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +menuconfig ATTESTATION
>> +	tristate "Attestation"
>> +	depends on CTLV
>
>ld.lld-21: error: undefined symbol: hash_digest_size
>>>> referenced by ctlv.c
>>>>               drivers/attestation/core/ctlv.o:(ctlv_attestation_mr_read_query) in archive vmlinux.a
>>>> referenced by ctlv.c
>
>Needs a:
>
>+       select CRYPTO_HASH_INFO

Ack

>
>-- 
>Jason
