Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795784098;
	b=LqnL/hPr4QZmKiPWWi6PruiOBNFHYFo2QywV/t0huY2TDCYt62byAFADBmmL/ukZPJni
	 dl5wnw4fiwUSeuMKuD1Px9rK2FzWPJkjvrPZfep5bkXNIqnx1pbs3ePuv/A57yUZzd0OR
	 WldN3SmLuBtxIPw8ruYDGp1OJ97L6ynjIfRklajLyoohl3IhyH00oiAJTJ3khLpKUBBZI
	 MTV1/HngCdM96RTq7HxR4MQKvjIulcAYD30iDzY6RqvU7AbAXe58r4pezzdjxyHnrqoYz
	 Bwbeck2sk2dgy/9Bbz9RDfJWH/wgouNiTcN3KwkdU3T7sGl9XfCwd0Kv9D+AOtsuzuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795784098;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=BIsNU2toYcPxvRASiDSGEyVwKK+YxJ3krLZbrLRoCLo=;
	b=4JjoaYA4tHUHlkIHKViCeBQdJ/uYaQFABuuFaEWm97jOwdbkrld5uHrVPR6A3EMLdwYV
	 haOZTOdcqcbG/zbtTdDxMs2s45a4zBozYFip/kE0A7uFLA9t3TAJZvQ5uY8m0/Qp8zy7K
	 4LrRnJafHZPQPIkYNwo0MIcdR6WFMaZi6ZIgy+CniomR9uCDFmjp1Z14eubAADDaTLhZ/
	 en8xuWDaLAXQAyJi/xg5UStmABn933Lo5G4WiG/wI12sST18QFNX+xEBS/WJ0g8wwA2ZI
	 KXOzbFTtmrF4oe+pSWRLjI/whqYfuxlHthabyK/XsNyAAgG2cVcK7yCoz0/0AOt7l6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b="h/lSNS6m";
	arc=none smtp.remote-ip=209.85.167.53
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEC5606A327
	for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 12:54:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEEC5606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=h/lSNS6m
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5c07c7306e1so6952102e87.1
        for <linux-api@vger.kernel.org>; Fri, 27 Nov 2026 04:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1795784095; x=1796388895; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BIsNU2toYcPxvRASiDSGEyVwKK+YxJ3krLZbrLRoCLo=;
        b=h/lSNS6meNH3H33ItcK06LQ4siOR34uSFHUeHIkaa9tQVVkXDGSr5/fyoyUqZjM+4v
         5nXjOR74edcabmb0d44caTq1P2mhqQyo4AZvRAklJNxQXS32K8mHR5yxOAhn+AK4deKm
         nTQRj2lE0MiLFUZjIAXfCoxLWqeHe6vCDrczVRPwwRXtgxbBMogwnx2qUOXrw656oCWi
         PDm3EV40p5p+xnKWU86lNx7nH+oaov3v2Lcza+jJj2VopoB2N2UE5rlOilEQ7Ts9nDXD
         9rX9ncUq5461FLOhUlKIs4WD3CfOS6CN3b96kMBj31oddJ5ESzGKNWje8ne/b172bm7T
         zsSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795784095; x=1796388895;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BIsNU2toYcPxvRASiDSGEyVwKK+YxJ3krLZbrLRoCLo=;
        b=gFTufpC9hnpfd5f7aB4EOhG4Ao2VnpGyMGNJ/k3XKhUJ7LiPtqDQ4Dh3tqB8ouA0Zs
         Wu8cyRs7d+/qa9wi+Au7T+MM/zSz9Ct3dqhYne0PZafK81UQ2WMruatMb58ZY815Uruj
         4WC7j1iujWrCsJ5Q9JcSTMgfwTVz+UwI9tKtBImk5OZr2NZ+KgQIgSN/AxgezfLgJv6e
         8evRD0u9azFkvtPT9O66octMLpKPcVi6Wttgb9Ea2OSymSJetackZLOkZW3OoJboCuZQ
         tXv8iNFET9I7EChVaso5aKV/oiS/bXKdFN0ed+a/i3rZ0cCpViUhg21KgWWKuwszuRK5
         0rlA==
X-Forwarded-Encrypted: i=1; AL+hErGaQ6KldTszusqE3aPlpw1sIndJhSKPQwrgBcAgS0ybmmtzjO00aqUB3QysZJlQwZ/pSRt9CLJ5F7M=@vger.kernel.org
X-Gm-Message-State: APuU4Z/g9kO2Hu8X4f4bux1LDj0k1SR1/6W+gFRcj3Yf5kqX9Gzc9kpT
	nrcMyCrtt2BAaDzm+rXsUXxLxycRP4jAhGehwF3acICDbEg1+62dSSYoPEMbSqXzgNA=
X-Gm-Gg: AZFdTZeRgWh5WG1lSjAo7L4Rr+GoFYMAezwWgv/FstFTBk6Y5p6e70/nw6PvlBKNnUW
	fI4GSXkMmpVa9BEI8aic3amcZZNFLR3Lpk90vLYyNMB4gbOV0Rp4YMuG+kIQyYQexCrDnY9skbN
	5rnpJgImjyKvnsY78PuG25h67wbgy5ObW9A0oQDnKMC6PLWrzqaEvQS1yUsbczmSsQyrOdlZqiJ
	fK8pIXleEj5gHln+ZnfcxnuTedbKJ1T9QmBiUkrqEhbqnfidCZcm7XSS3Vz6fTmPpp3nzL27Ev7
	UwN5JHHalr1eDXo0W6wSodCZJmDWYi9rtIF+6z54V1OmVGHlnc3kK6hWz5YPvS6UPDKw+2p7T7k
	yUd91sHQKArJ41d5QSmHA/Mm9W4Qa575BafU4rdAtioxKswYj5G0WunecTFiumn7KYT1mOaXV20
	pG8tvKoGs1jbjYkK2HzJue5Xxwbnb8F8A3OknXKP+SDUAVU5vQE4oFU59huhi16COvjK9y4V+vg
	5U+Q2MAwipB3cdnbyFlEPyJwsyHw5Un2z3tsOd+MpREoasZ66/Ez8nPfsSnDn9qAsIld31T1Gwd
	6EvEPvbO7ejpl3Pyt2eprHhPLXhTXfIj3SkwDsGZ
X-Received: by 2002:ac2:4bd5:0:b0:5c1:5986:cd2 with SMTP id 2adb3069b0e04-5c1bc82f327mr8185787e87.56.1795784094485;
        Fri, 27 Nov 2026 04:54:54 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bd079047sm5936259e87.76.2026.11.27.04.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:54:53 -0800 (PST)
Date: Fri, 27 Nov 2026 13:54:49 +0100
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
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com, jarkko@kernel.org, zohar@linux.ibm.com, 
	yeoreum.yun@arm.com, aneesh.kumar@kernel.org, dave.jiang@intel.com, 
	nik.borisov@suse.com, sergii.dmytruk@3mdeb.com
Subject: Re: [PATCH RFC v2 1/9] attestation: Add the base family
 specification and generated files
Message-ID: <awl4L8vEV5bvwE-Z@FV6GYCPJ69>
References: <20261113160838.2512652-1-jiri@resnulli.us>
 <20261113160838.2512652-2-jiri@resnulli.us>
 <179573913907.519186.8407997114208887089.b4-review@b4>
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
In-Reply-To: <179573913907.519186.8407997114208887089.b4-review@b4>

Fri, Nov 27, 2026 at 01:25:39AM +0100, jgg@nvidia.com wrote:
>> [ ... 60 lines skipped ... ]
>> +++ b/Documentation/ctlv/abi/ctlv-attestation.yaml
>> @@ -0,0 +1,147 @@
>> +# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
>> +%YAML 1.2
>> +---
>> +# Checked-in ABI snapshot of the ctlv-attestation family, from
>> +# Documentation/ctlv/specs/ctlv-attestation.yaml, written by
>> +# "make -C tools/ctlv regen".
>> +#
>> +# Updating the file is how a UAPI change gets reviewed; an update that
>> +# removes or renumbers anything, narrows a bound, or makes a member required
>> +# is an ABI break, whatever the file says afterwards.
>> +family: {name: ctlv-attestation, id: 1, inherits: ctlv}
>> +enums:
>> +  evidence-class: {signed: 1, event-log: 2}
>> +  evidence-format: {ccel: 1}
>> +  hash-algo: {$header: linux/hash_info.h, $enum: hash_algo,
>> +              $end: HASH_ALGO__LAST}
>
>I feel like this should parse the C enum into numbers here so the ABI
>can be checked too?

Well, note that this only works for uapi/ enums. So those are already
part of ABI. I don't think we need to do anything extra here.


>
>> +flags:
>> +  mr-device-caps: {extend: 0}
>> +  mr-caps: {extend: 0}
>> +records:
>> +  mr-desc:
>> +    id: 0x00010000
>> +    fields:
>> +      name: {number: 1, type: string, min-length: 1, max-length: 128}
>> +      supported-hash-algorithms: {number: 2, enum: hash-algo,
>> +                                  max-occurrences: hash-algo}
>> +      caps: {number: 3, flags: mr-caps}
>> +      register-index: {number: 4, type: uint, max: u32-max, optional: true}
>> +  mr-value:
>> +    id: 0x00020000
>> +    fields:
>> +      hash-algo: {number: 1, enum: hash-algo}
>> +      data: {number: 2, type: binary, min-length: 16, max-length: 64}
>> +  mr-generation:
>> +    id: 0x00030000
>> +    fields:
>> +      mr-generation: {number: 1, type: uint, max: u32-max}
>> +  mr-values:
>> +    id: 0x00040000
>> +    fields:
>> +      mr-values: {number: 1, record: mr-value, max-occurrences: hash-algo}
>> +  device-get request:
>> +    id: 0x80010000
>> +  device-get reply:
>> +    id: 0xc0010000
>> +    fields:
>> +      caps: {number: 1, record: device-get caps}
>> +      info: {number: 2, extension: device-info}
>> +  device-get caps:
>> +    id: 0xc0011000
>> +    fields:
>> +      evidence: {number: 1, record: device-get caps.evidence, optional: true}
>> +      mr: {number: 2, record: device-get caps.mr, optional: true}
>> +  device-get caps.evidence:
>> +    id: 0xc0011100
>> +    fields:
>> +      objects: {number: 1, record: device-get caps.evidence.objects,
>> +                max-occurrences: 16}
>> +  device-get caps.evidence.objects:
>> +    id: 0xc0011110
>> +    fields:
>> +      id: {number: 1, type: uint, max: 15}
>> +      class: {number: 2, enum: evidence-class}
>> +      formats: {number: 3, enum: evidence-format, max-occurrences: 4,
>> +                optional: true}
>> +      vendor-formats: {number: 4, enum: evidence-vendor-format,
>> +                       max-occurrences: 4, optional: true}
>> +      max-length: {number: 5, type: uint}
>> +      challenge-lengths:
>> +        {number: 6, record: device-get caps.evidence.objects.challenge-lengths,
>> +         max-occurrences: 8, optional: true}
>> +  device-get caps.evidence.objects.challenge-lengths:
>> +    id: 0xc0011111
>> +    fields:
>> +      length: {number: 1, type: uint, min: 1, max: 4K, unit: bytes,
>> +               optional: true}
>> +      min-length: {number: 2, type: uint, min: 1, max: 4K, unit: bytes,
>> +                   optional: true}
>> +      max-length: {number: 3, type: uint, min: 1, max: 4K, unit: bytes,
>> +                   optional: true}
>> +  device-get caps.mr:
>> +    id: 0xc0011200
>> +    fields:
>> +      flags: {number: 1, flags: mr-device-caps}
>> +  evidence-get request:
>> +    id: 0x80020000
>> +    fields:
>> +      challenge: {number: 1, type: binary, min-length: 1, max-length: 4K,
>> +                  optional: true}
>> +      objects: {number: 2, record: evidence-get objects, max-occurrences: 16}
>> +  evidence-get objects:
>> +    id: 0x80021000
>> +    fields:
>> +      id: {number: 1, type: uint, max: 15}
>> +      data: {number: 2, blob: output, backings: [va], max-length: u32-max}
>> +  evidence-get reply:
>> +    id: 0xc0020000
>> +    fields:
>> +      results: {number: 1, record: evidence-get results, max-occurrences: 16}
>> +    members: ['record mr-generation?']
>> +  evidence-get results:
>> +    id: 0xc0021000
>> +    fields:
>> +      format: {number: 1, enum: evidence-format, optional: true}
>> +      vendor-format: {number: 2, enum: evidence-vendor-format, optional: true}
>> +      length: {number: 3, type: uint}
>> +  mr-get request:
>> +    id: 0x80030000
>> +    fields:
>> +      id: {number: 1, type: uint, max: u32-max, optional: true}
>> +  mr-get reply:
>> +    id: 0xc0030000
>> +    fields:
>> +      items: {number: 1, record: mr-get items, max-occurrences: unlimited}
>> +  mr-get items:
>> +    id: 0xc0031000
>> +    fields:
>> +      id: {number: 1, type: uint, max: u32-max}
>> +    members: [$include mr-desc]
>> +  mr-read request:
>> +    id: 0x80040000
>> +    fields:
>> +      id: {number: 1, type: uint, max: u32-max}
>> +  mr-read reply:
>> +    id: 0xc0040000
>> +    members: [record mr-generation, record mr-values]
>> +  mr-extend request:
>> +    id: 0x80050000
>> +    fields:
>> +      id: {number: 1, type: uint, max: u32-max}
>> +    members: [record mr-values]
>> +  mr-extend reply:
>> +    id: 0xc0050000
>> +    members: [record mr-generation]
>> +extensions: {device-info: 1}
>> +enum-extensions: {evidence-vendor-format: 1}
>> +ops:
>> +  device-get: {id: 1, type: action, fd-access: read,
>> +               request: device-get request, reply: device-get reply}
>> +  evidence-get: {id: 2, type: action, availability: dynamic, optional: true,
>> +                 request: evidence-get request, reply: evidence-get reply}
>> +  mr-get: {id: 3, type: query, fd-access: read, optional: true,
>> +           request: mr-get request, reply: mr-get reply}
>> +  mr-read: {id: 4, type: query, fd-access: read, optional: true,
>> +            request: mr-read request, reply: mr-read reply}
>> +  mr-extend: {id: 5, type: action, optional: true, request: mr-extend request,
>> +              reply: mr-extend reply}
>> diff --git a/Documentation/ctlv/abi/families.registry.yaml b/Documentation/ctlv/abi/families.registry.yaml
>> index 5845e745777150..7a5c6af2956578 100644
>> --- a/Documentation/ctlv/abi/families.registry.yaml
>> +++ b/Documentation/ctlv/abi/families.registry.yaml
>> @@ -5,3 +5,4 @@
>>  # Written by "make -C tools/ctlv regen".
>>  families:
>>    - ctlv
>> +  - ctlv-attestation
>> diff --git a/Documentation/ctlv/families.yaml b/Documentation/ctlv/families.yaml
>> index 4d219d7af74a79..dbb0243b873d68 100644
>> --- a/Documentation/ctlv/families.yaml
>> +++ b/Documentation/ctlv/families.yaml
>> @@ -15,3 +15,4 @@
>>  
>>  families:
>>    - ctlv
>> +  - ctlv-attestation
>> diff --git a/Documentation/ctlv/generated-files.yaml b/Documentation/ctlv/generated-files.yaml
>> index d4766b176ceb98..00a56634805d40 100644
>> --- a/Documentation/ctlv/generated-files.yaml
>> +++ b/Documentation/ctlv/generated-files.yaml
>> @@ -16,3 +16,10 @@ families:
>>        kernel-header: include/linux/ctlv_gen.h
>>        kernel-source: lib/ctlv/ctlv_gen.c
>>        user-source: tools/ctlv/libctlv/ctlv_user_gen.c
>> +
>> +  - name: ctlv-attestation
>> +    source: Documentation/ctlv/specs/ctlv-attestation.yaml
>> +    outputs:
>> +      uapi-header: include/uapi/ctlv/ctlv_attestation_gen.h
>> +      kernel-header: drivers/attestation/generated/ctlv_attestation_gen.h
>> +      kernel-source: drivers/attestation/generated/ctlv_attestation_gen.c
>> diff --git a/Documentation/ctlv/specs/ctlv-attestation.yaml b/Documentation/ctlv/specs/ctlv-attestation.yaml
>> new file mode 100644
>> index 00000000000000..78b2dad6318a6f
>> --- /dev/null
>> +++ b/Documentation/ctlv/specs/ctlv-attestation.yaml
>> @@ -0,0 +1,181 @@
>> +# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
>> +%YAML 1.2
>> +---
>> +# Attestation devices: evidence and measurement registers (MRs). The device's
>> +# family inherits this one, fills device-info and gives evidence-vendor-format
>> +# the formats its vendor defines.
>> +family: ctlv-attestation
>> +inherits: ctlv
>
>This is much easier to read, I think it works well like this!

Yeah, pretty happy with it as well. Thanks for the suggestion!


>
>> +
>> +enums:
>> +  # What an evidence object is.
>> +  evidence-class:
>> +    # Made by evidence-get over its challenge, and signed by the root of
>> +    # trust.
>> +    - signed
>> +    # The platform's log of what firmware and the boot chain measured into
>> +    # the MRs. Later extends, through mr-extend or otherwise, are not in it.
>> +    - event-log
>> +  # A layout of an evidence object that a standard defines.
>> +  evidence-format:
>> +    # The log area of an ACPI CCEL table, a TCG crypto-agile event log.
>> +    - ccel
>
>Lets be in the habit of including a detailed spec reference for things
>that are standards.

Agreed. Will add it.


>
>> +  # A layout of an evidence object that one vendor defines, given by the
>> +  # device's family.
>> +  evidence-vendor-format: extension
>
>I find this 'standard' 'vendor' distinction confusing. Is this an
>artifact of the compilation process?
>
>This would be more usable if there was one enum but both this yaml and
>the driver yaml can contribute values to it. If we made an 'extendable
>enum' then the values could be full 64 bit ID numbers with the tree
>coding so that the extension works the same way as a op and record?
>
>Though I'm a bit nervous about what happens if something in a driver
>turns into a standard. It would be nice to be able to make the
>driver's ID promoted to a global ID without changing the ID. That
>sounds like something the generator could learn to do later I guess.

I see your point. Bit if we have 64bit enum value what included the
family id, we still have per-family namespace of enum values. Hard to
"promote to global id". We would have to have one range of enum values,
some of which would be driver, some global. How exactly you see this
happening?


>
>The comment should be improved to define what consitutes a 'format'. I
>was advocating that the format should define enough to check the
>signature and the challenge universally.
>
>Like Peter described the new TDX evidence as "tdx-quote-eat-cwt-1.0".
>
>Poking at the IETF RFCs with AI a bit I think it should be described
>as "CWT EAT" in this language. The EAT RFC defines the location of the
>challenge and uses the CWT packaging which defines how the signature
>is placed.
>
>I think ARM uses this format too, IDK what AMD uses.
>
>The EAT itself should have information inside that describes the
>"tdx-quote-1.0" idea, so we don't need it externally.

Perhaps we need 2 attributes, "evidence-packaging" and
"evidence-format"? This is a bit unclear to me to be honest.


>
>> +  # The kernel's hash algorithms.
>> +  hash-algo:
>> +    $header: linux/hash_info.h
>> +    $enum: hash_algo
>> +    $end: HASH_ALGO__LAST
>> +
>> +flags:
>> +  # What a device offers for its MRs.
>> +  mr-device-caps:
>> +    # mr-extend is provided.
>> +    - extend
>
>I guessed the userspace should learn what operations are supported
>using introspection directly on the operation? Do we need to specify
>what ops are implemented in device-get?

True, will remove this leftover.


>
>> [ ... 5 lines skipped ... ]
>> +records:
>> +  # One MR, as mr-get describes it.
>> +  mr-desc:
>> +    # The platform's name for the MR, such as rtmr0.
>> +    name: string(1..128)
>> +    # Its banks, each once, in the provider's order.
>> +    supported-hash-algorithms[hash-algo]: hash-algo
>
>I wonder if it would be wise to put a bit more syntax here:
>    supported-hash-algorithms[num_entries(hash-algo)]: hash-algo
>
>Just to be clear about exactly what is being extracted from
>hash_algo.. It is the total number of entries, not the maximum value
>or something else.

I already have this changed in my work tree as:
"supported-hash-algorithms[enum hash-algo]: enum hash-algo". I think it
is enough, what do you think?

[...]
