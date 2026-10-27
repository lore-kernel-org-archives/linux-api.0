Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793096254;
	b=Bu3VxnFdj2yRs9uReh5waNJAU2V2v+SrqjgQwjuzRhgbee+avrxfKiSFUESSvxrmwpyE
	 eQQFx+y0uCl5EIxNJncElJ9zbLqFtRJlaVwXH+1onLRwXoyHWSlOvyfmT3iPjelAo/q6O
	 wHsttNt+CU8b4ozkzNBQSEYOq87f3ztJtKsPDIwxLgucGyQWago+vZ2SBazpbw2rA/hkU
	 x0R6t3fF49OS2zeFUmkHtstOhe4LMLdXgLWsEZnZhxWLoW03JjVT4QGNEcHN7Q/z/OCDu
	 7tGE+sUZyQetelSxdeQUtm4PSGycTF8D6Ucmsh04+kFadKCY2KIT5yCU6UGMrzx0QCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793096254;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=ROl8Z/DFaCJAxQvsLDCIwxAYaCdKritEmYyIuCU28LM=;
	b=LcGQhpUFw8QgYLVSgTroNukdUI6f3D4t64ZsBCFqUPnl6GsoZXgXB8xm1sT3W64UX5Uj
	 oONwgoUK5pvirj7GB7UqmvxPNxFz2mcnUfJfE30IZHCBwdFaKbbmezO0KQAmeKKVeRLwp
	 ZmO+3VRza+FsSoqdLvvmD9AzdG8FmtKdF733HlrDXpqg6nar8uUpXkdFnALc9Q1QlQ1i8
	 ybJMVfMKCF2k03YNfWCqCj8Olvjp5ZCY2DcmLt3e9W5J35H0Zu9rn6bb4YZr9XwbHsHrZ
	 e0atp85qwTJkVfXUplgUd5i9XJiJfQCV5Z7MmZda+ibF92Y7ZIE+cNjt1HXXmoLgM1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=fmA5ZVtw;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E6B606A326
	for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 10:17:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9E6B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=fmA5ZVtw
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so37708285e9.2
        for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 03:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793096251; x=1793701051; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ROl8Z/DFaCJAxQvsLDCIwxAYaCdKritEmYyIuCU28LM=;
        b=fmA5ZVtwVJcNE/fAKAHqsP3pTMhIMG/B4/fp3GRzy6U2KUaRfKgSPPQRO7kH3SZ6uV
         l+fzzhfmGr9Mctm3db6DzPN2NeHVOu5pYzT1nPmjh7/grQz1Dup/ibheJflAfN28BYGt
         sbIOe1LMk8vFbragFHLOaRICCrM6OPu2imRyfnGBgaurj8ZgT/B2EU27xE/StHY2p3vI
         0FtODpcVTVfduuEmzZ206fQ1o2SEoqVEe0oCCy1muVMUaUmDeCS4IvdMx8Y+6Yayv+xv
         4MfvlIyEMIM0RMDLyW4wNgG61M8b27rM8mXK+xBP7O+Jx/KNHvVSN9NnsB2j6/T8iqaN
         ieig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793096251; x=1793701051;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ROl8Z/DFaCJAxQvsLDCIwxAYaCdKritEmYyIuCU28LM=;
        b=sDxHsnTgMOeEdrthpJzcZlzTq8K3ShiByS16fF1kzsbvJNMfKfcG1UJtgPDzzc7P+T
         buF9Wv0Z8Xxq0+Xt+BSdU5BPpQpUqO7HgWEROUIWderW5KxsUr+Zj+iFWnCbPY5LGT0V
         IxlvHteXNY2nbU1+xooIDqw3RXh4p4ajiESXgj4Pc1fOeKyZtiot4pRTLxwuHCyjA3RF
         xY6i8zwkqErGTZm268QfI66y5t2dSfuUB9Eg9di8Ii10ybdoUtH678343sjeKfHGEhHv
         xG4dkj90VjG0GtJRaxecjExc2JKjBiJ776wOT6rRT96n4YqwsF9xSq0rfTRYTb4/7X5L
         pudg==
X-Forwarded-Encrypted: i=1; AKwUvBw0/6+UMu4oQOzdbqiadTwMlbndnaYR1Ls+fOq1hIFQz9ZtM3wDAM9arnxbFygmbb+gzfOuWbheLVs=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ1XOfIRD09sWehPto9/NfjwqwHj/TP2SIH6ILS8vyAC7eMkvT7
	KC5OkqFe0bAHqkvBPUiIV16uuAbwQhiV4lHmhs1mWHDObtAVenDsKriIWynDp/xVtkM=
X-Gm-Gg: AYBFou02dsJtDKhg1iJO+G12VwwPWoNLOAC0hbARxNq4fumYeE/NH/GarSO49s5Ck/Y
	C9TbpG0bjiyIJnAzdqEPec3HTmq11jDs2dgHgI+ing3vZnKi32M8MxBFZeCzz6fGlM+cdM5XwiL
	TbVWIZC9rnf3fSHeQyWikTh5RuUUe1B36jzYJas2oQWZC7nbsyLe5mJCxxm/PuHUbOvJkBcmA4z
	Ps35jWmV49LlJ6wNUhGmn/dxoQLVfxvWc+yHtd7BcRmhN6iElNUZppicx/UuCLoKxpOJavsXrUV
	m4Tm6dvJ8WAWYA4phQ6/vIbhcrz9ADwypkZj1eayN03l7r/Z0cHOhiuwRj0PjoRYz0U+L6i/dgu
	V8481rRSu3/6szPjY4zW1QlGeo2hT6rEL9CnVMyz4sF44kQF6LhwKr/3WqzQNCarUVk4/3i0hOx
	tOTsfnUm4CnB3J5WZ+w7/aalTCXzMqSO1k3zia18GVx8wcbfDQusZ4hvGsiZbzJDz9Xl8tLyze9
	loAo/LHQ24YO1KB5ZayoOFJxNDRj1fv9uXlwtgbjeRcTKGIYMNdYvHh55knI6GJ
X-Received: by 2002:a05:600c:4704:b0:4a2:190f:cf6a with SMTP id 5b1f17b1804b1-4a35acc2ea1mr170116035e9.35.1793096250940;
        Tue, 27 Oct 2026 03:17:30 -0700 (PDT)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a2ed5a2sm271453735e9.15.2026.10.27.03.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 03:17:29 -0700 (PDT)
Date: Tue, 27 Oct 2026 11:17:25 +0100
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
Subject: Re: [PATCH RFC 05/20] ctlv: Prepare message input handling
Message-ID: <auB5yxcuA50kg5x4@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-6-jiri@resnulli.us>
 <179302367449.58760.13616210130636541456.b4-review@b4>
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
In-Reply-To: <179302367449.58760.13616210130636541456.b4-review@b4>

Mon, Oct 26, 2026 at 03:07:54PM +0100, jgg@nvidia.com wrote:
>> [ ... 38 lines skipped ... ]
>> --- /dev/null
>> +++ b/drivers/ctlv/Kconfig
>> @@ -0,0 +1,12 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +menuconfig CTLV
>> +	tristate "CTLV character device TLV UAPI"
>> +	help
>> +	  CTLV provides character device UAPIs described by a checked-in YAML
>> +	  specification. It owns the character device lifetime, the strict TLV
>> +	  message format, request validation, reply serialization, the large
>> +	  payloads a request describes rather than carries, per-open event
>> +	  queues and runtime schema introspection, so families only implement
>> +	  semantics.
>> +
>> +	  If you don't know what to do here, say N.
>
>This should probably just be a simple selectable config instead of a
>full blown menuconfig. ie one with no description. Since this is
>really just a tool for subsystems to use every subsystem that uses it
>should just select it.
>
>So:
>
>config CTLV
>   bool

Makes sense.


>
>
>> [ ... 159 lines skipped ... ]
>> +static bool ctlv_message_nest_index_ok(const struct ctlv_cursor *nest)
>> +{
>> +	const struct ctlv_message_input_index *index = nest->msg->index;
>> +	const struct ctlv_message_input_nest *indexed;
>> +	const struct ctlv_message_input_scope *scope;
>> +	const struct ctlv_attr *attr;
>> +
>> +	if (WARN_ON_ONCE(!nest->msg->request || !index ||
>> +			 nest->index_nest_scope >= index->scopes_count))
>> +		return false;
>> +	scope = &index->scopes[nest->index_nest_scope];
>> +	if (WARN_ON_ONCE(scope->nest >= index->nests_count))
>> +		return false;
>> +	indexed = &index->nests[scope->nest];
>> +	attr = (const void *)((const u8 *)nest->msg->root + indexed->offset);
>> +	if (WARN_ON_ONCE(attr != nest->attr))
>> +		return false;
>> +	return !WARN_ON_ONCE(scope->tree != nest->tree || scope->node != nest->node);
>
>Maybe wrap these invariant assertions in a helper and we can compile
>them out?
>
>  #ifdef CONFIG_CTLV_DEBUG
>  #define CTLV_ASSERT(xxx) WARN_ON_ONCE(xxx)
>  #endif

Well, yeah, that would probably make sense.


>
>It helps manage expectations around WARN_ON. I assume these have all
>been checked to guarentee they cannot be triggered by users space?

Sure.

>
>-- 
>Jason
