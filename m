Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975124;
	b=1zk937nW5pkA6SDEof112catgyjUVdE7PmX/vJ/D04p0s6ppJVMsZlBHTRhQNXtonSza
	 cHVbmXt96E2C9rYPalTOAKgWd1vT+ujAEs7x8RJJs4GX/BpqnLDR9lXA0I9Qv37eewAg3
	 fluaCFmn/SrWkjbGXyAbDlGdc9FQFOlJ3oZTElC88kSPv4nJ/GrGjpGNnIk8eu5G/V1Oq
	 yye3jYnZup0Ej2OweqtFKffznny66Fbz8Tat36wxU+lNwsCyM+BCZpGUbmFnMICpPllTt
	 fOAQwSaGkui0DyISqfXosF3ogkkzmxhKylrolpqcejTGmCcD7OM7yX+rMau9IuULZKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975124;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=XjubV5JgjeqjPXQH1+nVKdJIc9BEV5NX4y8ymGv5/6U=;
	b=LVOTrcbkrPId2+TICjV7Q+EyBffWbYCBZDNfXpsQRs6ljFB5KRWyKhpkdQFfWAN2XWdZ
	 UQllcdh6/nbHCxxj2qhcrvFKX25uwaq++p9Hf6xj9jRdQuYpE/XrNCtPxrAid856cnPYV
	 twJIpcOYWF8D9AOPE9/LcZLv4jtIiDMnHRUmxVmbokEKXkfyF1pt5zbXFhp7UBLEwRwcw
	 +C4GJPRNnysyj+qDil4CCDAdtiV1S4SJwh+lw30YHCbLC39bLAk+//Kw+lRy2mGYoT583
	 fj8jjHJzi4Av8d5s4AZ0yYch6IRqtvKM7s/Dqb6ticPTXcFDOiHXfT/JxrPL3PE5nmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=ckzssVGu;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DD2606A331
	for <linux-api@vger.kernel.org>; Fri,  6 Nov 2026 14:25:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9DD2606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=ckzssVGu
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a215e64962so7916685e9.1
        for <linux-api@vger.kernel.org>; Fri, 06 Nov 2026 06:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793975121; x=1794579921; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XjubV5JgjeqjPXQH1+nVKdJIc9BEV5NX4y8ymGv5/6U=;
        b=ckzssVGusvfgdWa877JLQ+g9yDiCK6LqO/d2+VrE2UpCFHeE+tB8b8SqRws5GBSqx2
         niAzMrDh/1+1TLdEtAHsHMLBcXse/VRnxauwVjCp5d5GcSC+C3lO66eKw9KUJzSNwUdr
         OQnF0wN0rxiSqYb9YFICNXlvm2xv/XyjY/QBNxXoN0xib15CvZpB1K2Gt+j86EGnOwok
         QpWXbvz/My5HqLkQQ3nStgmnG7bcqlSBJTI7SghOq0Afdu8BADzs7xoCM1y7UZhF2BGa
         wkt53axlAXW/ruJjjShFpz4MO8GFfDgXTRWtmJF5eSx1BSuanyCMCXdzxdeCTPA5N1vf
         vQOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793975121; x=1794579921;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XjubV5JgjeqjPXQH1+nVKdJIc9BEV5NX4y8ymGv5/6U=;
        b=Y5FCsZWN4l1lzNZmKjbFrK/bSfVBwc8O1yTWqxHnTmLBuaNj8/I+PaMt0IirEPUk7u
         /wtfATrHuN65D7BCl/nHZMLefcKWz/DwMvzyDdUtwEk8XwDz5crmqvvQyl6uDD3imkzN
         OaEW5/KxnK7Lu4hJ8xuDw2LMkf8ml9+JJJx+V+6QwRH/Ya55ntYnB2FGHR0SaY4ppF0H
         BVobIZ//x3GyUGijtuQeIHEpL/XirnHpqRgdUv5SLfdSJn2Ab6cNk3UEPAn0l9g+Kffs
         kglhxY1nm0oVJrwRgaSsbC08T8UrSIqaCLP7livznK+kc+yk8wDk48ADzF4xEGRXzt/k
         sZnw==
X-Forwarded-Encrypted: i=1; AKwUvBzVYEqn16ZrjDMUjiFxgD7KmzmcL590JlhdnZxI4j3X1NDDjXSshptnswcQsq+yoVW3NRvDfbQcJWc=@vger.kernel.org
X-Gm-Message-State: APuU4Z+WXMdMxEYiBkMTlj/HXAL0Mu1Mnpry9SpZDOigdVyOj1f3siaV
	++LNFtyN+G1t2T/3K5zjz29PDZCJOW+k3oqjEOfUH85SrAX8SUb0VtlP0CXiHSkoXzo=
X-Gm-Gg: AYBFou2fudlYKAbKR7vo3NsDOKgiOfrhmUETGm/gT3mUY6aRk0pXIsPbqLiQ+IDkelt
	lkHKUxSTs70HaM9MUi842FjpaRcUBNQ3eLfW4Y0xyN+kOWF380F/JLvGR/Ct+TZ78Hd5AyzRHPo
	RCh+Bz/Kkby5GHiIh5edAoRvT2OoWoQ2jYCoAwqN4z6t+OKD2PjmHMgAeMkkvVS1CituTrJ5aGW
	6Bp9QZpKXjbhJ/gqoBqDA2GzS11YGhh/Z8Mm9iEqfGUOFuDF1dJ4lH341T063OVXT0yer5yIUu2
	UvaEZpIajJs7E0lc/bGYAJeJP6rQ9c5e873QmSY7TaX/jlH7gS2JQCN9kf1YHnux9ATbqeGjv53
	h+a9Mc8c9X6QQkbY3rwWm1aVZlXPKlj/nRY/iMgPO8pvw6+RB8Ljpbo+Gzu+LDZR/VPyn4cPhdN
	Rsb88Nx6evpM2rmvzuttYBrhurhEm7OZ94lX9h5WdTHzl70ZzO4TznVSU/AokLxkAnsotXYLoX+
	lTdzvdgdpnjF0+SQ2Pe+GbKyf/gPLQoTcE+3MH8nRG7HTcNyYOXWtnusaTxM797ZxtXMh+ayV7n
	0kqCxo5YxTrRmS1aYgROBb7xmT2eN8Slp6y8
X-Received: by 2002:a05:600c:5307:b0:4a1:e00b:a10b with SMTP id 5b1f17b1804b1-4b6de973c39mr43606025e9.7.1793975120493;
        Fri, 06 Nov 2026 06:25:20 -0800 (PST)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b571f46538sm136357845e9.5.2026.11.06.06.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 06:25:19 -0800 (PST)
Date: Fri, 6 Nov 2026 15:25:15 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org, 
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com, 
	James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com, qinkun@google.com, 
	pgonda@google.com, jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com, 
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com, 
	elena.reshetova@intel.com, dave.hansen@linux.intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com, aneesh.kumar@kernel.org
Subject: Re: [PATCH RFC 17/20] attestation: Add CTLV operation handling
Message-ID: <au3i-0eDzJZaWukx@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-18-jiri@resnulli.us>
 <auuDcABX27EeTApl@e129823.arm.com>
 <20261104194622.GC3889730@ziepe.ca>
 <aux01NUd85PabtZu@FV6GYCPJ69>
 <auyKE2sGqtfjk4v5@e129823.arm.com>
 <auy7IM0_S2tv7EZX@FV6GYCPJ69>
 <au2WdWFOYbPEv0Uj@e129823.arm.com>
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
In-Reply-To: <au2WdWFOYbPEv0Uj@e129823.arm.com>

Fri, Nov 06, 2026 at 09:57:25AM +0100, yeoreum.yun@arm.com wrote:
>On Fri, Nov 06, 2026 at 09:27:42AM +0100, Jiri Pirko wrote:
>> Thu, Nov 05, 2026 at 02:52:19PM +0100, yeoreum.yun@arm.com wrote:
>> >On Thu, Nov 05, 2026 at 01:32:49PM +0100, Jiri Pirko wrote:
>> >> Wed, Nov 04, 2026 at 08:46:22PM +0100, jgg@ziepe.ca wrote:
>> >> >On Wed, Nov 04, 2026 at 07:11:44PM +0000, Yeoreum Yun wrote:
>> >> >> [..snip..]
>> >> >> 
>> >> >> > +static int attestation_evidence_request_decode(struct attestation *att, struct ctlv_op_ctx *ctx,
>> >> >> > +					       const struct ctlv_cursor *request,
>> >> >> > +					       struct attestation_evidence_request *decoded,
>> >> >> > +					       struct attestation_evidence_object_request **objects)
>> >> >> > +{
>> >> >> > +	const struct attestation_evidence_caps *caps = att->provider->evidence_caps;
>> >> >> > +	u32 challenge_length;
>> >> >> > +
>> >> >> > +	decoded->challenge =
>> >> >> > +		ctlv_attestation_evidence_get_evidence_challenge_get(request, &challenge_length);
>> >> >> > +	decoded->challenge_length = challenge_length;
>> >> >> > +	if (challenge_length < caps->min_challenge_length ||
>> >> >> > +	    challenge_length > caps->max_challenge_length)
>> >> >> 
>> >> >> Hmm, I'm not sure whether this check is required for
>> >> >> ATTESTATION_EVIDENCE_BLOB_EVENT_LOG blob type.
>> >> >> 
>> >> >> for example, if the provider provides two evidence:
>> >> >>   - ATTESTATION_EVIDENCE_BLOB_PRIMARY (might attestation token)
>> >> >>   - ATTESTATION_EVIDENCE_BLOB_EVENT_LOG
>> >> >> 
>> >> >> might challenge is reuiqred for generating the token
>> >> >> and this would be marked at min/max_challenge_size in evidence_cap.
>> >> >> 
>> >> >> However, in case of eventlog, it wouldn't require challenge.
>> >> >> for example, TPM event log or CCEL event log.
>> >> >
>> >> >Right
>> >> >
>> >> >> Do we need some field on attestation_evidence_supported_object whether
>> >> >> it requires challenge or not and applies this sanity check per the object?
>> >> >> 
>> >> >> Otherwise, to get eventlog, it would need to send *dummy* challenge
>> >> >> always.
>> >> >
>> >> >I wonder if we should have two interfaces here for signed and unsigned
>> >> >evidence? It would be clearer for userspace then when it needs to
>> >> >provide a challenge or not.
>> >> 
>> >> Isn't the challenge field provided/not-provided enough?
>> >> 
>> >> Currently on the introspection side, device-get op would provide
>> >> challenge-lengths array:
>> >> 
>> >>         evidence?:
>> >>           challenge-lengths[8]:
>> >>             length?: uint(..4096)
>> >>             min-length?: uint(..4096)
>> >>             max-length?: uint(..4096)
>> >>  	  objects[16]:
>> >>             blob-class: evidence-blob-class
>> >>             max-length: uint
>> >>             blob-instance?: uint(..u32-max)
>> >> 
>> >> I think it would make sense to have challenge-lengths array per object:
>> >> 
>> >>  	  objects[16]:
>> >>             blob-class: evidence-blob-class
>> >>             max-length: uint
>> >>             blob-instance?: uint(..u32-max)
>> >>             challenge-lengths[8]:
>> >>               length?: uint(..4096)
>> >>               min-length?: uint(..4096)
>> >>               max-length?: uint(..4096)
>> >> 
>> >> Then the unsigned object would just simply have challenge-lengths empty?
>> >
>> >This looks good to me. :)
>> 
>> The challenge is one of several open points that all depend on what an
>> evidence object is: Rick's TDREPORT, legacy versus DICE Quotes,
>> "primary", "raw" and the format strings. Here is my proposal to settle
>> these together:
>> 
>> The model:
>> 
>> 1. device-get lists each object with an id, a class (signed, event-log,
>>    cert-chain or auxiliary), the formats it may come in, its max-length
>>    and, for signed objects only, challenge-lengths.
>> 2. evidence-get names objects by id, as MR ops name MRs, each with its
>>    output blob. It carries a challenge exactly when it names a signed
>>    object, and the challenge has to fit each of them.
>> 3. The reply gives each object's format, length and, where the TCB
>>    vouches for it, the TCB's digest. The output is always {label, data}.
>> 4. A signed object is made by the call, over the challenge, and never
>>    reused. The rest are read as they stand.
>> 
>> This settles following issues discussed during this patchset review:
>> 
>> 1. One op, not two. Per-object challenge-lengths tell userspace when to
>>    pass a challenge, and one call returns the signed object with the log
>>    and certificates needed to check it.
>> 2. TDX's TDREPORT goes: it is MAC'd for the platform, not signed.
>>    /dev/tdx_guest keeps TDX_CMD_GET_REPORT0.
>> 3. TDX's Quote object lists the legacy and the DICE format. The provider
>>    labels what the host returned and fails on a Quote it cannot label.
>> 4. "primary" becomes "signed", manifest joins auxiliary, spdm-vca,
>>    spdm-measurements and tdisp-report become formats, and signature
>>    goes, as a signed object carries its own.
>> 5. "raw" goes with the representation attr. The TCB digest is a reply
>>    field, so a blob always holds the object's own bytes.
>> 
>> Formats become an enum each provider family defines, instead of free
>> strings. I'm still unsure if format should be entirely provider-specific
>> and defined as "extension", or it should be somehow mixture of common
>> and provider-specific. Looks there is not really much common
>> anyway, so I lean towards provider-specific only. So far I have:
>
>Overall, This is plausible for me with some small question.
>
>> 
>> ======  ============  ==========  =========  ===========================
>> Family  Format        Class       Challenge  Bytes
>> ======  ============  ==========  =========  ===========================
>[...]
>> tpm     ek-cert       cert-chain  none       EK certificate from NV
>
>Just a thought, but how are we planning to retrieve
>the NV index for EK certificate?
>
>As far as I know, TPM NV storage doesn't support labeling.
>
>Should I assume that the NV index would be specified as part of the
>challenge to retrieve the certificate from TPM NV storage?

evidence-get allows to accept mr-selection as part of the request
alongside the challenge.


>
>[...]
>> armcca  event-log     event-log   none       Realm firmware log, if any
>
>JFYI, this would be a CCEL log like tdx:
>  - https://github.com/tianocore/edk2/issues/11384

Okay.

>
>
>> snp     report        signed      64         SNP attestation report
>> snp     cert-table    cert-chain  none       VCEK or VLEK, ASK and ARK
>> ======  ============  ==========  =========  ===========================
>> 
>> Did I miss something that would break us here?
>> 
>> CTLV layout draft:
>> 
>>     device-get reply, caps.evidence:
>>       objects[16]:
>>         id: uint(..15)
>>         class: evidence-class
>>         # The reply says which one was written.
>>         formats[4]: evidence-format
>>         max-length: uint
>>         # Signed objects only, entries as today.
>>         challenge-lengths[8]?: ...
>>         # Descriptive, such as an SPDM slot.
>>         instance?: uint(..u32-max)
>>         # When the TCB vouches for the object with a digest.
>>         tcb-digest-algo?: hash-algo
>> 
>>     evidence-get request:
>>       # Required exactly when a signed object is named.
>>       challenge?: binary(1..4K)
>>       objects[16]:
>>         id: uint(..15)
>>         data: blob(out, va memfd dma-buf)
>>       # selection, privlevel, service and options as now.
>> 
>>     evidence-get reply:
>>       # In request order.
>>       objects[16]:
>>         format: evidence-format
>>         length: uint
>>         tcb-digest?:
>>           hash-algo: hash-algo
>>           data: binary(16..64)
>>       # The generations as now.
>> 
>> Makes sense?
>
>For me, It seems fine.
>
>-- 
>Sincerely,
>Yeoreum Yun
