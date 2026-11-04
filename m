Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793780561;
	b=Z4OvtjMk/aWbyarNpJ8+er20y3WZmXBycPa+9ghpT+JFggywpBonUNrOzzxyEKvEUa0F
	 0Qph1qleEEqXYbRiitNvSDvmkFf9foIr0DwnskLvlIOlaVGdW7oeFftZFYhzD5z0smmG4
	 JdYZYkLxNgbpRQPNfQVvNHirzRFnU8yr3tEXq2j9PI42OomWVCrlK86n/fjyO990m6U1O
	 krHvwQCcIgzTsagcnFOXQfKjleJfx/in/tS+8Old26n0MAATQbHrctnTpuu9VzuOaUKXH
	 8no+B/HyBElyu7Rx3fkP8z5zdCeOc6GBl4AuTRmBdXUcBRNa4xklv7jMGI/T2MRTsww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793780561;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Zx8jHzDvw8va/CX+J+ppLsFj9mBNb+GyOOHFkDmbSlI=;
	b=oTtjXMEH5JLxFFKGYqidSY8yfDiM5W/zyFN0kesTMvLwrzg8G3SGvt12Z0nRnnZaHTVi
	 sjFnHvZtoX9UUPM7V2rQOQI/hwG60Knn1G4X81q+xdSAnc7DrLwM9XiI6Lr7rSKWClBkY
	 OXO+4woV6pMryazyB2eUlYcBkkrnKrnressJaSQkyngyft/oSriD6j4gbcK6DXFe73umV
	 hfzy1FlUaFsMvBwMydugdv41u+x7Kv15ZcMmvt7maGYLY4Emqm2EtYHQLr4ruM7qWC7nY
	 lzng0o/Wxi4dmYIqfuROLm/9Fg7WtKEgLp7KsD67OIJjw6YtmL0e5sp1GyrFxT4uKyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A29C606A326
	for <linux-api@vger.kernel.org>; Wed,  4 Nov 2026 08:22:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A29C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso2333805e9.1
        for <linux-api@vger.kernel.org>; Wed, 04 Nov 2026 00:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793780552; x=1794385352; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zx8jHzDvw8va/CX+J+ppLsFj9mBNb+GyOOHFkDmbSlI=;
        b=stGCcKR2XDWs2JXEfhtZr7iLAW8lUux9SMxROW6OOCRA1mWbx8OrRo4JMyxUU+27jW
         8c13+kyddkij1BwcIWUx304IGIDbLM01Ibc2QYWx3RFhyX7gUV0iwPgp0xCFVDf1vyxS
         PETlqgBra90W+V/xUeB/QKZV9smQJ+N83Bar1G3ihYu5ExGkVz/eUj3qiP1q/iXdAaWO
         iP95iXIz3iUqNRhfpusCP2d0spZdrly4qJazkBVuuot+aWl5mVhhuL+oA45dVpKNrgNX
         ae4LyDG/ScCBOiSm9zbGcSHLDVtAEZ/lplpYpBpok5SQLo4JKTsqx5vxTu/N2nZBy+Hq
         IERg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793780552; x=1794385352;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zx8jHzDvw8va/CX+J+ppLsFj9mBNb+GyOOHFkDmbSlI=;
        b=lOU36+IxkHTZuP/NKqi7Pp74B6iK+Rd2YX+s7UNNAgxupE2nWNKZ+75KYrpXLLIfMQ
         CkaWse1CqlUv6hEI+veUVf1jttQeFFlXD5/I8xqFmLeY1m++0yonhqhDyUaj/hk1K1/W
         ZWPkaoZ3lqcDJAPhIqcsxmy/u4Z81yzdry6++GX4hEG8Yez+TyDOoqMzpWqZ9S0rDIGk
         S8kW940d8hUsjFqS/Na72tVjGptItGzp0IshuEUZPagojF0un1b1HqjeAAhF3OtVygbK
         a0NEQIYC+XSS91FZDX0/qHAvvzqvnAHLvkZVSGL6CyxuB4kiO9nR2A/4Yo5Lm2jhHKXN
         Wg/Q==
X-Forwarded-Encrypted: i=1; AKwUvBw3D0xiPykExaY6EX/6Hwtlz27TbUJ9AIjvdKhaHO8r7F9/UZTCshj8fQZiX8shYVZm9XlLCDbmJPE=@vger.kernel.org
X-Gm-Message-State: APuU4Z8ts2+AjydFtQCgWU7kmdB+i7wOEkFPE7qts3lBmOWpq0YggxCk
	pY8wgQsMvhq34CrZgewMtOmNYf37KDJuOpo4lIwNqy1LcHbW9ZbUchtr4rxPWF3YEOU=
X-Gm-Gg: AYBFou2+uKBmR1UWX+DLU/hzjt4/nk/VYlc+YjItJXw/a/plFB8DIisRM+4ucNCIm+4
	7QyYu+uAhPJE4kYnCRb66kDfPhwYMBdrJCDamwmmwKeVr/URCUifHOeqq2cwnfc+JQhgNb/xGr9
	DoVbpBIPHxvQs6sDVyAJFkJrlZpsXM3fy0UHe1cBfdzqCYV2Zr+LJ7iCJ8NNxqE7JzEqz3OosRm
	66FmOjNLBgolpLaDWc/kySU0k0D0FzLnBvM9t13Yt1KXYolBaMkwTqDeYsEiSzs8zTq0Rbff8v5
	FaIbMUShCX9Z3XM2JG2zWSiKx0u3512SytmwUkyOuTVMygTMsdquUby45Z/ME7d0Q4TD2NTK7FI
	F6LS68bfqeGrDa36ze7Qd/XCnMDDozFlf43NbVej7v9Kd0uTXkucjvvYW4RVeq/ROEy3oQ3E4qb
	Go8lpXTWnf2iLps7kkCBDIOqx2WLh3figuM+KPlsiXVU2BRWK7IAiG/FNeIBeX58GoJOK83pWwM
	oUJURX0HqiwF60tg+yKrS09s5tXr2J99IMuBqQJ0ABvTK3Xh2gqUGens2a6hFIhHXzHahXVAQlD
	35dvLntH+6T0Gm7KX0HCBDuCbagQT7CU0z5F
X-Received: by 2002:a05:600c:3554:b0:4a2:267:25b3 with SMTP id 5b1f17b1804b1-4ac18c7461emr379283885e9.35.1793780552290;
        Wed, 04 Nov 2026 00:22:32 -0800 (PST)
Received: from localhost ([208.127.45.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fece99a5dsm2366556f8f.21.2026.11.04.00.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 00:22:31 -0800 (PST)
Date: Wed, 4 Nov 2026 09:22:26 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Sergii Dmytruk <sergii.dmytruk@3mdeb.com>
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
Message-ID: <aurpges1eUwSJUBE@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-16-jiri@resnulli.us>
 <auOVbGYJjIQTN53z@MjU3Nj>
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
In-Reply-To: <auOVbGYJjIQTN53z@MjU3Nj>

Thu, Oct 29, 2026 at 07:50:20PM +0100, sergii.dmytruk@3mdeb.com wrote:
>On Thu, Oct 15, 2026 at 04:50:48PM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>

[..]

>> +/**
>> + * struct attestation_mr_props - Immutable MR properties.
>> + * @id: provider-unique MR ID
>> + * @name: MR name
>> + * @algorithms: ordered hash algorithms
>
>Why do these need to be sorted?  Is it just to make indexing easier?

They don't. Will lift this limitation.


>
>I see that the number of algorithms is also checked on extending.  Does
>it mean that a situation when not all PCR banks are extended at the same
>time is considered an invalid one?  That may be a problem at least for
>DRTM which may extend only one bank even if several are active.

Great catch, I missed this usecase. Will allow extension of subset
of banks.


>
>> + * @algorithms_count: number of algorithms
>> + * @has_register_index: whether @register_index is valid
>> + * @register_index: native register index
>> + * @readable: MR can be read
>> + * @extendable: MR can be extended
>
>At least with TPMs, whether a PCR can be extended depends on locality,
>so this isn't necessarily a static property.  Is this flag expected to
>always be accurate or it would be OK for a provider to declare an
>extendable MR but then deny doing it?

Okay to declare it and return some appropriate error, like -EPERM. Will
document it.


>
>> + */
>> +struct attestation_mr_props {
>> +	unsigned int id;
>> +	const char *name;
>> +	const enum hash_algo *algorithms;
>> +	size_t algorithms_count;
>> +	bool has_register_index;
>> +	unsigned int register_index;
>> +	bool readable;
>> +	bool extendable;
>> +};
>> +
>> +/**
>> + * struct attestation_evidence_supported_object - Evidence output description.
>> + * @format: evidence format name
>> + * @max_length: maximum output bytes
>> + * @binds_mrs: evidence validity depends on MR state
>> + */
>> +struct attestation_evidence_supported_object {
>> +	const char *format;
>> +	size_t max_length;
>> +	bool binds_mrs;
>> +};
>> +
>> +/**
>> + * struct attestation_evidence_caps - Immutable evidence capabilities.
>> + * @min_challenge_length: minimum challenge bytes
>> + * @max_challenge_length: maximum challenge bytes
>> + * @max_total_output_length: maximum bytes across all objects
>> + * @objects: supported evidence objects
>> + * @objects_count: number of objects
>> + */
>> +struct attestation_evidence_caps {
>> +	size_t min_challenge_length;
>> +	size_t max_challenge_length;
>> +	size_t max_total_output_length;
>> +	const struct attestation_evidence_supported_object *objects;
>> +	size_t objects_count;
>> +};
>> +
>> +/**
>> + * struct attestation_evidence_object_request - One resolved output object.
>> + * @supported_object: matching capability entry
>> + * @output: resolved output blob
>> + */
>> +struct attestation_evidence_object_request {
>> +	const struct attestation_evidence_supported_object *supported_object;
>> +	struct ctlv_blob *output;
>> +};
>> +
>> +/**
>> + * struct attestation_evidence_request - Validated evidence request.
>> + * @challenge: challenge bytes
>> + * @challenge_length: challenge length
>> + * @objects: requested output objects
>> + * @objects_count: number of objects
>> + */
>> +struct attestation_evidence_request {
>> +	const u8 *challenge;
>> +	size_t challenge_length;
>> +	const struct attestation_evidence_object_request *objects;
>> +	size_t objects_count;
>> +};
>> +
>> +/**
>> + * struct attestation_evidence_result - Provider evidence result.
>> + * @object_lengths: produced length for every requested object
>> + */
>> +struct attestation_evidence_result {
>> +	size_t *object_lengths;
>
>No number of objects?  That would make this structure more
>self-contained.  Copying `objects` from the request would allow passing
>it around to handle results, but there may not be too much value in
>doing it this way.

Not really needed. This struct is only related got evidence_get cb and
it is always used alongside with struct attestation_evidence_request
which has the count. It would be redundant to have it here too.


>
>> +};
>> +
>> +/**
>> + * struct attestation_provider - Immutable provider operations and properties.
>> + * @evidence_get: produce requested evidence
>> + * @mr_read: read one MR
>> + * @mr_extend: extend one MR
>> + * @evidence_caps: evidence capabilities, or NULL
>> + * @mrs: fixed MR properties
>> + * @mrs_count: number of fixed MRs
>> + */
>> +struct attestation_provider {
>> +	int (*evidence_get)(struct attestation *att,
>> +			    const struct attestation_evidence_request *request,
>> +			    struct attestation_evidence_result *result);
>> +	int (*mr_read)(struct attestation *att, unsigned int mr_id,
>> +		       struct attestation_digest_set *values);
>> +	int (*mr_extend)(struct attestation *att, unsigned int mr_id,
>> +			 const struct attestation_digest_set *values);
>> +	const struct attestation_evidence_caps *evidence_caps;
>> +	const struct attestation_mr_props *mrs;
>> +	size_t mrs_count;
>> +};
>> +
>> +#endif /* _LINUX_ATTESTATION_H */
>> -- 
>> 2.56.0
