Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792499340;
	b=imqIowdWjLwJdfYTZ26a9d1p04MHYz4E1QTVj8pNkVeXuvJAn3ioqGf2UH5e9F83mRuu
	 3Sv/hecrmD+kDAJuDU8gtaGD5BBJljgf/pTsOIhJaahliInAXu5ND5dbb/TsJWAuSfmGH
	 /Dmh2rYHRZbShANO60TMNNsKaJ1fGoxb7L1QwPuhjmUxKevdmnuuijK/mX87+q6gUpFU4
	 xCMYyGwvX5Cw7S72iYkOaK0ijB0OtBsdnM8lGIeB9nsSaehTWm9eQax2x7qyJ0/AWZEha
	 5mU5TUVWf1d+2eB2vBPE3aBk6TZfcb0GVadWFeTgtdnoV5WMle65Ntz4uhla1+4VZEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792499340;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=5bLIqnhjUZD53MQ8mIyoL64maRPRtf//51viUHZYxfw=;
	b=ju3KfvjLLHb8wp2fSZ78+8X7QaZ0CYHBcCZUVQXcb9z7jRNNAZ9LssV1mBNxQSZdOJMz
	 8vsMIiuBhYHrVXWXxFJjDnjiNaQ6AP428iQoRT44lftPDLp+uZOE1DU95+O9yexxLTVIr
	 hweE9rNbmyqBLOOqCybMxaes1uHb2TtftqQwBL1a/rAcd1UvDtUErjH3razOQ9unX7QCW
	 qQXlT9nCo6sTyrv53CsCG55ZdoHmEt4JKRrFT+cjw+MPIhIewjnRvra1msXmdX8LCOFY8
	 IK0Oih2rAQN9ASJ53j7lroY2kL0OwPd9iMO2lqh0s/8mNuD6K4s5KVOi5xPNNN74+HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=resnulli.us;
	spf=none smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=YWQo69lb;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B42606A31E
	for <linux-api@vger.kernel.org>; Tue, 20 Oct 2026 12:28:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83B42606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=YWQo69lb
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48df54150dfso2445187f8f.0
        for <linux-api@vger.kernel.org>; Tue, 20 Oct 2026 05:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1792499338; x=1793104138; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5bLIqnhjUZD53MQ8mIyoL64maRPRtf//51viUHZYxfw=;
        b=YWQo69lbuMlzAP5RdqrQrLx77X6LX94CycMTmUoX+vc7zIantga+lXOuVqP8Vgavii
         aMHjXJgGZcMilKGQVLQxuos2bg5NWmwNeszGgaHWYw6MOq1Wdtg/+QRSrWzrrzhTS+Ra
         S7bgQNT8g9yNBpi7b8JDzTqCzz4Avn1jbamDZDTY8/tXJ/ZaYpuSKa8eZEDVl+8+Qqmt
         ZQLt7KhOKj5xVUgPay5ZDn72g06IDDYypT7LTYrrJ5htnGnSgVHzjmkZIusiQQBJcUfS
         alOl0TJHFJO7AxJejHgBf9DgXpAIcJEmh5xR7NJHWc1kzRyQ7Jm2TxL45dPOy6Lu4mZM
         2Dhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792499338; x=1793104138;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5bLIqnhjUZD53MQ8mIyoL64maRPRtf//51viUHZYxfw=;
        b=AJDjUKVTRSaw7ab4fz5BqB/25Bul6PfUdsQxs1N1pOZz191y8iAHZGLc7S8/pACG6Q
         HcMXlDj1ofEOCAro/ePlrTCaUtcaVOyNCKNomb4NSaMo8IlLGuwf0YilqK8pCuI1uAds
         o7y5Kkp2f6jFVpRWe0BKCJCNIejfbkeN/p2SX2zDfpW5m7cELbp+1Rxpa1MIVxYte1wF
         eztPALbfAE1lFuwldTEpTn5PDm9kFtDEmTzeJkd6I12hxvYxh6YIqc8nT+Tzh4xHJBBh
         PaHe70FTtKGkIB0sWxdQonL4efqAupcPiHtMMCv7gxrmFmVVUSbOqtTNMyqiio8SaRFH
         FNWg==
X-Forwarded-Encrypted: i=1; AKwUvBxkx5olroq8IGb7VYGc4U83c+I1GBaB8PHFHn2lLC0b+FCoPzPGu6RY1/0Wx246X+GtzhCXtSqxtVQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYKzCyfzmMTIEHzAGZbr1B3fbxHT0SmZtx81NR2N3F7Ue5yTErCI
	o4J1BUNNy+znva8kvSNREAaOSDZCJ7mHU4re/LpGy6NC2NfxzZVS6C+d/orTpR+Q8F4=
X-Gm-Gg: AYBFou0UQu6e+Xvqwjz4GDokilD22ApXicBKZ+OhxzYJsrEjp88bjIWAYoCxXJokESR
	wSoUTqOs5z63ur/bum/M+24o6kTwW6WSRllTnPUbJ48ZQOz2gZLdDeZ986sETKOZ6mJMdwvgUxV
	3V1KX1to7NzP3PKSprjx8+zEBNgWboUPzHGkrNtiWlqj3Tz+s4xJMPtMnS14goSK7e3iaU87dcz
	jkyACM4ZXQ1WcjL9a1yttGSpEfi32DGnkgoDeruRXws7NZo2Ajjh/VjgDJaWRaFPiJh05Og4yPj
	OYgoO33CZpq0cxFfaBROkAlHmmtlvtVyhYX6qgYu73kyg85IRe/p9Vw526pBtR7dP03G6/GTVSx
	V3S0CaJ8XpAIj8lnhOaIum/OD4BjAYCIn9LstwZ5knzkAYLAMblm7NWrm0tuo3cTUqB3+Mmtj6E
	3jt9LC/x0CN0ebLe7TBDk1e5Pxsa+gVrY2joBww0In5KoInKDyrfwlY5kHcMTxIb4laDKS/5FtY
	pJl
X-Received: by 2002:a05:6000:3108:b0:486:f907:ebec with SMTP id ffacd0b85a97d-48e07bc104dmr25850403f8f.31.1792499337690;
        Tue, 20 Oct 2026 05:28:57 -0700 (PDT)
Received: from localhost ([85.163.81.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d80fc6csm5636775f8f.14.2026.10.20.05.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 05:28:57 -0700 (PDT)
Date: Tue, 20 Oct 2026 14:28:55 +0200
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
Subject: Re: [PATCH RFC 03/20] ctlv: Add the root family specification and
 generated files
Message-ID: <atdeH3nA_gkLwPLM@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-4-jiri@resnulli.us>
 <179245258505.58760.6060356114682279013.b4-review@b4>
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
In-Reply-To: <179245258505.58760.6060356114682279013.b4-review@b4>

Tue, Oct 20, 2026 at 01:29:45AM +0200, jgg@nvidia.com wrote:
>> [ ... 238 lines skipped ... ]
>> --- /dev/null
>> +++ b/Documentation/ctlv/families.yaml
>> @@ -0,0 +1,13 @@
>> +# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
>> +%YAML 1.2
>> +---
>> +# Append-only registry of CTLV family names, indexed by family ID: the entry at
>> +# index N has family ID N, up to 65535. The root family owns ID 0 and heads the
>> +# list, and every other entry comes after the entry of the family it inherits.
>> +# An entry may be marked deprecated, but never reordered, removed, renamed or
>> +# reused, its position being its wire identity. Every entry must have a
>> +# specification in specs/<name>.yaml, and is added by the change that adds the
>> +# implementation. Fixtures under tools/ctlv/tests/ are not registered.
>> +
>> +families:
>> +  - ctlv
>
>I see where you are coming from with this, but it is going to be
>problematic from a global kernel perspective. Given CTLV is imagined
>as a general tool for any subsystem we cannot control the tree that
>things merge through. It will not be like netdev where there is one
>authoritative tree with a linear history.
>
>So if Bob and Jane maintainers both add their own subsystems by the
>time it gets to Linus the IDs will get scrambled, and bisection will
>be lost. 
>
>Either changes to this file must be strictly done in a single tree
>with shared branches (which is going to be a bit hard process wise)
>
>Or we need to put the ID #s here and have some simple process to
>coordinate them during the development process. Since new families are
>probably rare it shouldn't be a big deal

Exactly. Collision is not very likely. Explicit ID or implicit, scramble
would still happen. And in that case it is resolvable.
