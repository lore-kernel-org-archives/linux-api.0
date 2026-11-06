Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793953675;
	b=fKLMaBPOugzWZqfrhP8KNv0brA2gWo4q9JLMnrcuModuweTI/BwRZdCCm/m0m0PI6Aau
	 SQ/YDgPTB/fusHhKt4hBd3r8CiEbbrOJBwUlFJI02yEtwgfBEUMT7te2pDbUmvy7gjMim
	 GvYD2LYYNGuJZxWeSR57NZH83EJTYuxNG+wHzRF65XtgIZIDkIfY/s3sdQxNJY3VKgpEg
	 soHCSpraJ9olf+7MpaU3z/rybIP0Cq8JK2/VMrKTQPwEGPwdViPpo4ic3nXji80/69chj
	 WDV+d+3h4cKts3rmjj9BZC8l1k8W5XF98lic6EJijXNvWNkixvCoqKQJrIOB1EdQfiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793953675;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=eFyf1J2eCmzdcygEsnj9uuRDnIkV5nwpe7sUFMbcNPA=;
	b=yaWgi58CRljkFUGIx23aycD+UUnds6P3gzk3n5S9Wolj/oQN8NMJ7bVLug4NpimzotXt
	 bj+LRTkPN2504vSSeXl/N9NqsQFESWt/YEy3GFZnbgkQYeE7xp9Q42y/de4u4si8ngfRw
	 Tk0C69TPxOYMxX+oRps9bz5y+dz+oyIMpVVROBW96U1kS2O3pK8/aipsYxU2bv7JeUAu9
	 83edFh3BU0v6weDjHdEpv4O16HWNwr+kB/zLlPXAcZ0guLF9y1xTiOzJ5datzVwSSIl0M
	 5+Yqd7OPNx1WlskQL1kp/2qNcDmRioIUPmmP5827WyEFpvhIelY3xgh5tDwnnVeY1bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76949606A32F
	for <linux-api@vger.kernel.org>; Fri,  6 Nov 2026 08:27:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76949606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so2869575e9.1
        for <linux-api@vger.kernel.org>; Fri, 06 Nov 2026 00:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793953668; x=1794558468; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eFyf1J2eCmzdcygEsnj9uuRDnIkV5nwpe7sUFMbcNPA=;
        b=B/rSxcDlMYnthEPXsv+Dey7MmueZn3MQHpzmfFmdz1qKA5YAzHst+P9vXXtmfUjBQd
         Hdo9pdjh+loJd+rBiJmMoikQfhb0UunnrP0Elsn0wtcOJK5yGfwrv7yB5A5r1O7aEZ6N
         JKoqxQnRiR3gEpt3AYwAVsU2u4+l2q+hP33U4CSayE/Uxg/PHBIy+CSfOyKmo3a6U0hF
         CoMD+sTdwlw31W6xMku/iAxMVKl4QD+AzugLDDpHwuzMW/hxt5bfWmEDVgpP/L4oJclM
         6+zD7o/sl2wTljFv+oUaeCGHHdQWPtNEG2pghabPaWW4g0MZgOfU+JN06X9amJ35uAOt
         hiZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793953668; x=1794558468;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eFyf1J2eCmzdcygEsnj9uuRDnIkV5nwpe7sUFMbcNPA=;
        b=KwjtdfRT4ga0FJvVSDPvHyGjnM3nzfZhY8sodaWpUD9kkhqOVRj5BD49WjHOBzpU6e
         WkAmL8s6+c9CxaNf0AfrJeAAvS+46UWvzQ2ab9Iybfz77G1jkx5txVZRe+oalWPg9nCv
         cdYBX0k2zJ293+qKJNgHeHqWYBaVpASOuVmAVmXeklF2C6iOWtMUpRp5JnSsCAwRw7nh
         7bWdtB3EkXaLDkwvoeKalFYYO/byTbNmIJGUXBUyRnCstKcDwZPG7y0SwHDp9xmf3osY
         qDqKGNySbst0ek64gOU9hdqvoxD5nkP7z6h1OXEbbGZ4z+OP7mQXwZj47IJttXK0c1Sy
         tLaw==
X-Forwarded-Encrypted: i=1; AKwUvBzlBS0T+ie6cjt4yTgqK3kUEpHMz6enUzX4g5ninHd9j6aNo8008K3nroQ5oOw8AQSNd8oXY6LHjYU=@vger.kernel.org
X-Gm-Message-State: APuU4Z+JE4EF+H4hzbEvhL1khtAvvfLQyailoqFjPHyOXQ7eIMAqJGt0
	Y1ELlYOo9JfgtM5Gnv1oeo04R4ZDu1hjTJ2vrpexKat9dF4JdaYUZ4v1dHwC/6KnOsE=
X-Gm-Gg: AYBFou3KEjomGO6+w26lLG5L99spBf6rpxZjpgi6NmdSouC8OA5yAZhJ1ekZ8kF4iWf
	e7Tr/1gRChmL/qlUQg3DlFywDaiXtpb2ec9WramnGmZ17AEg62ageNBGCm+LdYXSI6LuR1m8kqn
	Ai7nzbw0I8YeD6aeVKgfWAWbURinwsnsOEZEEEk1ZiVRCt4IwHkJfDh8WD3K5l2jlGazWiPw8Di
	4l7zMtOV99XVRDp+ZrZkJplLa6i7fxYxKysSandzMj3zgIRFUSPPhdnIWv6VzJJFZQ0vpRn3Kdb
	OGRbV34kGOg7pWQnSQEDUQgaLv7QqizK8pXTIu6aqrYseX2QdYC/HSm5FQJIiu3dwoSjIAYPF3K
	Uh7/Lfp55cM9chpgJfdhbVyYPc7oTqwmSP9zRbFP3uB1Q+Dya52UvRX7m+P4IFHZAXwDwxtyowZ
	PYVbL70fsBpkIjSvADMYPxgR/KqzoTVPKxqVHJZ4b3gR7Nzh4JMKi1zHXGJsYoRh/XJ7awX6+zu
	wVK+AbYECX71iWw8+qopMWbNqsXLSwQqK4BrIQ1WoyUPHQalyQfCpRMhxB5VaZ4+JCMzAT5MaNo
	q+hlGbvKdO2YaVsMc645T5A5ETDZxwjvdG3V+6r9eFy6T9Ckk8fJg+qGqKlX
X-Received: by 2002:a05:600c:3e0e:b0:4a2:150f:1605 with SMTP id 5b1f17b1804b1-4b6dfba908bmr27264855e9.24.1793953667539;
        Fri, 06 Nov 2026 00:27:47 -0800 (PST)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b73ee651b7sm16201965e9.0.2026.11.06.00.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 00:27:46 -0800 (PST)
Date: Fri, 6 Nov 2026 09:27:42 +0100
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
Message-ID: <auy7IM0_S2tv7EZX@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-18-jiri@resnulli.us>
 <auuDcABX27EeTApl@e129823.arm.com>
 <20261104194622.GC3889730@ziepe.ca>
 <aux01NUd85PabtZu@FV6GYCPJ69>
 <auyKE2sGqtfjk4v5@e129823.arm.com>
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
In-Reply-To: <auyKE2sGqtfjk4v5@e129823.arm.com>

Thu, Nov 05, 2026 at 02:52:19PM +0100, yeoreum.yun@arm.com wrote:
>On Thu, Nov 05, 2026 at 01:32:49PM +0100, Jiri Pirko wrote:
>> Wed, Nov 04, 2026 at 08:46:22PM +0100, jgg@ziepe.ca wrote:
>> >On Wed, Nov 04, 2026 at 07:11:44PM +0000, Yeoreum Yun wrote:
>> >> [..snip..]
>> >> 
>> >> > +static int attestation_evidence_request_decode(struct attestation *att, struct ctlv_op_ctx *ctx,
>> >> > +					       const struct ctlv_cursor *request,
>> >> > +					       struct attestation_evidence_request *decoded,
>> >> > +					       struct attestation_evidence_object_request **objects)
>> >> > +{
>> >> > +	const struct attestation_evidence_caps *caps = att->provider->evidence_caps;
>> >> > +	u32 challenge_length;
>> >> > +
>> >> > +	decoded->challenge =
>> >> > +		ctlv_attestation_evidence_get_evidence_challenge_get(request, &challenge_length);
>> >> > +	decoded->challenge_length = challenge_length;
>> >> > +	if (challenge_length < caps->min_challenge_length ||
>> >> > +	    challenge_length > caps->max_challenge_length)
>> >> 
>> >> Hmm, I'm not sure whether this check is required for
>> >> ATTESTATION_EVIDENCE_BLOB_EVENT_LOG blob type.
>> >> 
>> >> for example, if the provider provides two evidence:
>> >>   - ATTESTATION_EVIDENCE_BLOB_PRIMARY (might attestation token)
>> >>   - ATTESTATION_EVIDENCE_BLOB_EVENT_LOG
>> >> 
>> >> might challenge is reuiqred for generating the token
>> >> and this would be marked at min/max_challenge_size in evidence_cap.
>> >> 
>> >> However, in case of eventlog, it wouldn't require challenge.
>> >> for example, TPM event log or CCEL event log.
>> >
>> >Right
>> >
>> >> Do we need some field on attestation_evidence_supported_object whether
>> >> it requires challenge or not and applies this sanity check per the object?
>> >> 
>> >> Otherwise, to get eventlog, it would need to send *dummy* challenge
>> >> always.
>> >
>> >I wonder if we should have two interfaces here for signed and unsigned
>> >evidence? It would be clearer for userspace then when it needs to
>> >provide a challenge or not.
>> 
>> Isn't the challenge field provided/not-provided enough?
>> 
>> Currently on the introspection side, device-get op would provide
>> challenge-lengths array:
>> 
>>         evidence?:
>>           challenge-lengths[8]:
>>             length?: uint(..4096)
>>             min-length?: uint(..4096)
>>             max-length?: uint(..4096)
>>  	  objects[16]:
>>             blob-class: evidence-blob-class
>>             max-length: uint
>>             blob-instance?: uint(..u32-max)
>> 
>> I think it would make sense to have challenge-lengths array per object:
>> 
>>  	  objects[16]:
>>             blob-class: evidence-blob-class
>>             max-length: uint
>>             blob-instance?: uint(..u32-max)
>>             challenge-lengths[8]:
>>               length?: uint(..4096)
>>               min-length?: uint(..4096)
>>               max-length?: uint(..4096)
>> 
>> Then the unsigned object would just simply have challenge-lengths empty?
>
>This looks good to me. :)

The challenge is one of several open points that all depend on what an
evidence object is: Rick's TDREPORT, legacy versus DICE Quotes,
"primary", "raw" and the format strings. Here is my proposal to settle
these together:

The model:

1. device-get lists each object with an id, a class (signed, event-log,
   cert-chain or auxiliary), the formats it may come in, its max-length
   and, for signed objects only, challenge-lengths.
2. evidence-get names objects by id, as MR ops name MRs, each with its
   output blob. It carries a challenge exactly when it names a signed
   object, and the challenge has to fit each of them.
3. The reply gives each object's format, length and, where the TCB
   vouches for it, the TCB's digest. The output is always {label, data}.
4. A signed object is made by the call, over the challenge, and never
   reused. The rest are read as they stand.

This settles following issues discussed during this patchset review:

1. One op, not two. Per-object challenge-lengths tell userspace when to
   pass a challenge, and one call returns the signed object with the log
   and certificates needed to check it.
2. TDX's TDREPORT goes: it is MAC'd for the platform, not signed.
   /dev/tdx_guest keeps TDX_CMD_GET_REPORT0.
3. TDX's Quote object lists the legacy and the DICE format. The provider
   labels what the host returned and fails on a Quote it cannot label.
4. "primary" becomes "signed", manifest joins auxiliary, spdm-vca,
   spdm-measurements and tdisp-report become formats, and signature
   goes, as a signed object carries its own.
5. "raw" goes with the representation attr. The TCB digest is a reply
   field, so a blob always holds the object's own bytes.

Formats become an enum each provider family defines, instead of free
strings. I'm still unsure if format should be entirely provider-specific
and defined as "extension", or it should be somehow mixture of common
and provider-specific. Looks there is not really much common
anyway, so I lean towards provider-specific only. So far I have:

======  ============  ==========  =========  ===========================
Family  Format        Class       Challenge  Bytes
======  ============  ==========  =========  ===========================
tdx     quote         signed      64         Intel TDX DCAP Quote
tdx     quote-dice    signed      64         DICE-based TDX Quote
tdx     ccel          event-log   none       ACPI CCEL log area, a TCG
                                             crypto-agile event log
spdm    cert-chain    cert-chain  none       SPDM certificate chain,
                                             instance = slot 0-7
spdm    vca           auxiliary   none       SPDM version, capabilities
                                             and algorithms transcript
spdm    measurements  signed      32         SPDM GET_MEASUREMENTS
                                             response
spdm    tdisp-report  auxiliary   none       TDISP interface report
tpm     quote         signed      varies     TPM2_Quote's attestation
                                             structure and signature
tpm     event-log     event-log   none       TCG PC Client crypto-agile
                                             event log
tpm     ek-cert       cert-chain  none       EK certificate from NV
armcca  token         signed      64         CCA attestation token,
                                             platform and realm parts
armcca  event-log     event-log   none       Realm firmware log, if any
snp     report        signed      64         SNP attestation report
snp     cert-table    cert-chain  none       VCEK or VLEK, ASK and ARK
======  ============  ==========  =========  ===========================

Did I miss something that would break us here?

CTLV layout draft:

    device-get reply, caps.evidence:
      objects[16]:
        id: uint(..15)
        class: evidence-class
        # The reply says which one was written.
        formats[4]: evidence-format
        max-length: uint
        # Signed objects only, entries as today.
        challenge-lengths[8]?: ...
        # Descriptive, such as an SPDM slot.
        instance?: uint(..u32-max)
        # When the TCB vouches for the object with a digest.
        tcb-digest-algo?: hash-algo

    evidence-get request:
      # Required exactly when a signed object is named.
      challenge?: binary(1..4K)
      objects[16]:
        id: uint(..15)
        data: blob(out, va memfd dma-buf)
      # selection, privlevel, service and options as now.

    evidence-get reply:
      # In request order.
      objects[16]:
        format: evidence-format
        length: uint
        tcb-digest?:
          hash-algo: hash-algo
          data: binary(16..64)
      # The generations as now.

Makes sense?
