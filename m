Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793819511;
	b=41j2JzXN4IlsQywk5Z/0s3FIuwbMHpiJujL88cp7XoIwl3MDhmf1AK1RKUTq/7OM1Fnm
	 9VOTtGfgoTf7ZnyuUQXVC9+sPDkIgubV4HedrHTKER5kYeOB8kIO+icY/kN3z2P3nIqBC
	 XBWqtEdb4iS82hnlCkdhGZk20Y0wdHcOQ7FrMJ+9ejWI2z8UfTsKvlyFhIDh4iKMa+Ihw
	 TKoJUFwXnh3btBiVZYvPhorEwAq0T2LlP971lH7fyWKC+l46t9A0jGRhbX466qCuYw4Z7
	 UlfGLUNjlubED6MA6HS0rsafVBYXOT9DQxmI5hvgaz+k5GCIah5/v0fxZO0yN78RObA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793819511;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=xiigALyHFVH3PBK5TlmDEvHxWG7fkvXh1nD+cSek+7w=;
	b=2Vw2UqUUmrJrywqM+Lrex2uibsM0B7FZ5Jq30SWLLO9L+3Ucpe+UwwNalxidIVhO2BMf
	 goR7G+ZohjRGX8Pzpt+FgMYtaF94XCFv/cSIzhOkLUsGm2kVxrrPJnEyf3jq06cp7sZH7
	 nP3UkVRMdPlEb3OFPmqizuQxmHTKNsP86NHfres7ZjOCc4KOAnQ7Thh6BNRrtAaUSG+rK
	 jMxVZDnH6u9KT76mbMXuLxyHavA8Tl+VCzlatXWlYvKhwcEmPTOsqsddN3B4LZqORuBJf
	 VYw19ZnbhJaxt3RVmTOk5+mmr6IofmRQ60dWSnVg5IplpKnOuF1ryDoSmyY27vigYHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ZSBvcPKu;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE68A606A330;
	Wed,  4 Nov 2026 19:11:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE68A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ZSBvcPKu
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 050331650;
	Wed,  4 Nov 2026 11:11:47 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8441D3F673;
	Wed,  4 Nov 2026 11:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793819510; bh=V+Gx6zriHP0k0OYX76UFXlquTwkTO7eEmccEIw5TWIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZSBvcPKuvW9846WhqDxus2zzmbVzHBvQ2UweWIf4wiyhi/2k9qHhmDLZ+LBvgD6Eo
	 OkIOMfAobMVc9DAoHw0tLZbvynJqNY0E8VZdfwkXbBqeQVmQsVBbqczJ79gsxGfxsv
	 2rqZfNgXPAX1lTvK3p+MbYdBH7l/8jJYxXL241Y0=
Date: Wed, 4 Nov 2026 19:11:44 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com,
	lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
	cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 17/20] attestation: Add CTLV operation handling
Message-ID: <auuDcABX27EeTApl@e129823.arm.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-18-jiri@resnulli.us>
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
In-Reply-To: <20261015145053.3664509-18-jiri@resnulli.us>

[..snip..]

> +static int attestation_evidence_request_decode(struct attestation *att, struct ctlv_op_ctx *ctx,
> +					       const struct ctlv_cursor *request,
> +					       struct attestation_evidence_request *decoded,
> +					       struct attestation_evidence_object_request **objects)
> +{
> +	const struct attestation_evidence_caps *caps = att->provider->evidence_caps;
> +	u32 challenge_length;
> +
> +	decoded->challenge =
> +		ctlv_attestation_evidence_get_evidence_challenge_get(request, &challenge_length);
> +	decoded->challenge_length = challenge_length;
> +	if (challenge_length < caps->min_challenge_length ||
> +	    challenge_length > caps->max_challenge_length)

Hmm, I'm not sure whether this check is required for
ATTESTATION_EVIDENCE_BLOB_EVENT_LOG blob type.

for example, if the provider provides two evidence:
  - ATTESTATION_EVIDENCE_BLOB_PRIMARY (might attestation token)
  - ATTESTATION_EVIDENCE_BLOB_EVENT_LOG

might challenge is reuiqred for generating the token
and this would be marked at min/max_challenge_size in evidence_cap.

However, in case of eventlog, it wouldn't require challenge.
for example, TPM event log or CCEL event log.

Do we need some field on attestation_evidence_supported_object whether
it requires challenge or not and applies this sanity check per the object?

Otherwise, to get eventlog, it would need to send *dummy* challenge
always.

[...]

-- 
Sincerely,
Yeoreum Yun
