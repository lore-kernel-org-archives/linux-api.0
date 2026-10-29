Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.105.40.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793299832;
	b=FBVy898n+5GtPPp9Gov6aFde2s6s3ko6GCqIMdthqs/15NLWj8qty12DvrzARWDNrqHm
	 h1mL+0YNsGM1lEIt8m+LvbiqtCEWk3AdtmT8FJkVIE9XeUfevNKvjG16bZRR3f9tQjDdb
	 ymJlDFoNZMI+fSPPOzD1IrqJTSDxvLPgShDpts7gRWtlsOegf11Q3yoBTO6POZVDQp+Gg
	 ZUN3eolVFl7GXAmI3Qe4wayQwPivuJAk2Y9+9IosZeJIj37lL67MbuViu39FvTImhGCw1
	 VQ3Sr2fBLQkn2I6z/OU3feXzsf3M+cwkzlWomu6c1/MK8UDYqrJhYIdSk80mk0cxFcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793299832;
	h=DMARC-Filter:Received:Received:Received:X-OVh-ClientIp:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:x-ovh-tracer-id:X-VR-SPAMSTATE:
	 X-VR-SPAMSCORE:X-VR-SPAMCAUSE:DKIM-Signature;
	bh=5IMCEQSW4EddZ7FIT1wbfB/0SX217DwqV013zAOLwEo=;
	b=tNGVNp7xm0kUSN0dxn1y7e0qluntTWIJdWRBc999cBWsOIAPwKLUeTxDzY7EfKnuYgwZ
	 hieG3XbietH8B58bOWUKH6V1xFeySMtMjhK2b/PuQVEm6Sj16CG0N+nDPr+892R3rsVmE
	 6ciPgPV1q8EF5M3k3J4V9wwb8MURl64JoQguQJCEmFhxR0duloboS7uD+R0Xxi2do6RIu
	 3p/jPtgUBqons5sXZReFe55FiMUS7cs5LfDJL3k4odvuMADI6oyANWrrfs6X85KnhQjyL
	 kSPp6eUffYINR8loZ2HVNB7l7+or+TN5/znQV/JPGiM9m9V8u4EnqZmCDkObM8Q1Bpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=3mdeb.com;
	spf=pass smtp.mailfrom=3mdeb.com;
	dkim=pass header.d=3mdeb.com header.i=@3mdeb.com header.a=rsa-sha256 header.s=ovhmo3617313-selector1 header.b=Im5XjzsV;
	arc=none smtp.remote-ip=46.105.40.108
Received: from 3.mo583.mail-out.ovh.net (3.mo583.mail-out.ovh.net [46.105.40.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824EF606A31F
	for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 18:50:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 824EF606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=3mdeb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=3mdeb.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=3mdeb.com header.i=@3mdeb.com header.a=rsa-sha256 header.s=ovhmo3617313-selector1 header.b=Im5XjzsV
Received: from director11.ghost.mail-out.ovh.net (unknown [10.110.0.24])
	by mo583.mail-out.ovh.net (Postfix) with ESMTP id 4jFtb35dPnz5wsY
	for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 18:50:23 +0000 (UTC)
Received: from ghost-submission-7ccd8bbbb6-vvbcf (unknown [10.108.54.148])
	by director11.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 5DB45C2910;
	Thu, 29 Oct 2026 18:50:20 +0000 (UTC)
Received: from 3mdeb.com ([37.59.142.95])
	by ghost-submission-7ccd8bbbb6-vvbcf with ESMTPSA
	id 8HFFAWyV42qTfBwASyHcuw
	(envelope-from <sergii.dmytruk@3mdeb.com>); Thu, 29 Oct 2026 18:50:20 +0000
Authentication-Results:garm.ovh; auth=pass (GARM-95G0015624ec90-fccb-4a19-869f-137c4fe8d7b2,
                    80E54DDF43994B3DD4677030DFD12DA1D43C0C90) smtp.auth=sergii.dmytruk@3mdeb.com
X-OVh-ClientIp:176.111.182.218
Date: Thu, 29 Oct 2026 20:50:20 +0200
From: Sergii Dmytruk <sergii.dmytruk@3mdeb.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com,
	lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
	cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@HansenPartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 15/20] attestation: Prepare provider and instance core
Message-ID: <auOVbGYJjIQTN53z@MjU3Nj>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-16-jiri@resnulli.us>
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
In-Reply-To: <20261015145053.3664509-16-jiri@resnulli.us>
x-ovh-tracer-id: 10767825236716430673
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTFRGI1yaOcyDfLgNXjfMxwmupW2IW64ehzRIoHhqwLBlPIe0jAgyJB0LlqKu0wtkov5oTsfOtxqVTrvMp41g1IW4164qf3YzjiVMHIil3j9rRAWoNXx3GiQVReQC9kv4gSz1+UST8GFYnYUTcgZllXIwzyufvQL6rB4SnBRobHyvpxxp4dydBi/G8rhr8eTNISs6C4cfrkUVgVh7QKeICXeIwY/NFnauWbK7VIpUUiWDXk+YLgM8Xrc0YK6W+iMtkXMPrXLTTZNhDWHz5rTmMOLTH9a6noJ9yg9Av2enhV1YX1pjSh9SByPSMh2zOloOHaeU/23sH8dlgGVpp2yd+qdfietWoFeTJKUGwV67ekxO7SazBR+dp1k4L9pdErPwGAMTxWmshDFuEvpr8dpvJmKL1IbKnnfdSHBYafQ/dhEhOQajN6E2LlOH8cDE9qxfmk2qYx886ElgfE4E/3cdmBtewD5urj0nfc2nXa/XW+xjYhwKrutvtaBzL2YZi02/B7gaXS5uHqwYiTUUvRVSnd1cyQOM8oidzUg5mn2DhOWmbdnfkyB5DnSlP8Aa+WP192GaMvjzhglOVo9XjeLTRbU5TMvsGvdHTXgMnYYffCNK1sLC5ynNw7jWbP3MEQwqWr0JziS3SbtoICyZOhcCA1OMJKgJqXqHRH6tY44wAfwcQ
DKIM-Signature: a=rsa-sha256; bh=5IMCEQSW4EddZ7FIT1wbfB/0SX217DwqV013zAOLwEo=;
 c=relaxed/relaxed; d=3mdeb.com; h=From; s=ovhmo3617313-selector1;
 t=1793299823; v=1;
 b=Im5XjzsVNNrV1DhjQgGOj5hk3cOh2OquWrmePLmX1H/PEb6Bezqn8vEK9s5jIx0aSh3rIq4S
 dDLP+xwj7Dp9TD2RcDSbtNpS+fwPzj44hLfhyg/Ji3Jo/0xkAeuKpASGnZd8vLQiDtZNi57r8Dz
 +JyXXi4oKQ3XKBUZ5AfIX4pvUe9tXyti6k+wknTD2S1wwbLMl0JwJMCoB9EK/MAGxGaLPbPktyg
 swkNZLe5V2GoTUBQVkH0yS9zfMFxZ1rdXdTJ2sM+MfP0NSwsllPmayUrkAmOlpQJ10OP+aGkUNT
 turz/t7g0Dn/0eD/xrwmKZdsmbsrg8k/rz/m1uOKUsLGQ==

On Thu, Oct 15, 2026 at 04:50:48PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Add provider validation, instance registration and lifecycle management for
> the attestation family.
> 
> The provider descriptor is one immutable evidence and MR contract; journal
> storage follows in the next patch. The core object can be compile-checked
> here. CONFIG_ATTESTATION remains unwired until the CTLV handlers land.
> 
> Assisted-by: Cursor: GPT-5.6 Sol
> Assisted-by: Cursor: Claude Opus 5.5
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  Documentation/driver-api/attestation.rst |  36 +++
>  Documentation/driver-api/index.rst       |   1 +
>  MAINTAINERS                              |   2 +
>  drivers/attestation/Kconfig              |  12 +
>  drivers/attestation/Makefile             |   4 +
>  drivers/attestation/core/core.c          | 280 +++++++++++++++++++++++
>  drivers/attestation/core/internal.h      |  35 +++
>  include/linux/attestation.h              | 138 +++++++++++
>  8 files changed, 508 insertions(+)
>  create mode 100644 Documentation/driver-api/attestation.rst
>  create mode 100644 drivers/attestation/Kconfig
>  create mode 100644 drivers/attestation/Makefile
>  create mode 100644 drivers/attestation/core/core.c
>  create mode 100644 drivers/attestation/core/internal.h
>  create mode 100644 include/linux/attestation.h

[...]

> diff --git a/include/linux/attestation.h b/include/linux/attestation.h
> new file mode 100644
> index 000000000000..0fd806ea77d8
> --- /dev/null
> +++ b/include/linux/attestation.h
> @@ -0,0 +1,138 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _LINUX_ATTESTATION_H
> +#define _LINUX_ATTESTATION_H
> +
> +#include <crypto/hash.h>
> +#include <linux/types.h>
> +
> +#include <uapi/linux/ctlv_attestation_gen.h>
> +#include <uapi/linux/hash_info.h>
> +
> +struct attestation;
> +struct ctlv_blob;
> +
> +/**
> + * struct attestation_digest - One MR digest.
> + * @algorithm: hash algorithm
> + * @data: digest bytes
> + */
> +struct attestation_digest {
> +	enum hash_algo algorithm;
> +	u8 data[HASH_MAX_DIGESTSIZE];
> +};
> +
> +/**
> + * struct attestation_digest_set - Digests ordered as the MR algorithms.
> + * @values_count: number of digests
> + * @values: digest array
> + */
> +struct attestation_digest_set {
> +	size_t values_count;
> +	struct attestation_digest *values;
> +};
> +
> +/**
> + * struct attestation_mr_props - Immutable MR properties.
> + * @id: provider-unique MR ID
> + * @name: MR name
> + * @algorithms: ordered hash algorithms

Why do these need to be sorted?  Is it just to make indexing easier?

I see that the number of algorithms is also checked on extending.  Does
it mean that a situation when not all PCR banks are extended at the same
time is considered an invalid one?  That may be a problem at least for
DRTM which may extend only one bank even if several are active.

> + * @algorithms_count: number of algorithms
> + * @has_register_index: whether @register_index is valid
> + * @register_index: native register index
> + * @readable: MR can be read
> + * @extendable: MR can be extended

At least with TPMs, whether a PCR can be extended depends on locality,
so this isn't necessarily a static property.  Is this flag expected to
always be accurate or it would be OK for a provider to declare an
extendable MR but then deny doing it?

> + */
> +struct attestation_mr_props {
> +	unsigned int id;
> +	const char *name;
> +	const enum hash_algo *algorithms;
> +	size_t algorithms_count;
> +	bool has_register_index;
> +	unsigned int register_index;
> +	bool readable;
> +	bool extendable;
> +};
> +
> +/**
> + * struct attestation_evidence_supported_object - Evidence output description.
> + * @format: evidence format name
> + * @max_length: maximum output bytes
> + * @binds_mrs: evidence validity depends on MR state
> + */
> +struct attestation_evidence_supported_object {
> +	const char *format;
> +	size_t max_length;
> +	bool binds_mrs;
> +};
> +
> +/**
> + * struct attestation_evidence_caps - Immutable evidence capabilities.
> + * @min_challenge_length: minimum challenge bytes
> + * @max_challenge_length: maximum challenge bytes
> + * @max_total_output_length: maximum bytes across all objects
> + * @objects: supported evidence objects
> + * @objects_count: number of objects
> + */
> +struct attestation_evidence_caps {
> +	size_t min_challenge_length;
> +	size_t max_challenge_length;
> +	size_t max_total_output_length;
> +	const struct attestation_evidence_supported_object *objects;
> +	size_t objects_count;
> +};
> +
> +/**
> + * struct attestation_evidence_object_request - One resolved output object.
> + * @supported_object: matching capability entry
> + * @output: resolved output blob
> + */
> +struct attestation_evidence_object_request {
> +	const struct attestation_evidence_supported_object *supported_object;
> +	struct ctlv_blob *output;
> +};
> +
> +/**
> + * struct attestation_evidence_request - Validated evidence request.
> + * @challenge: challenge bytes
> + * @challenge_length: challenge length
> + * @objects: requested output objects
> + * @objects_count: number of objects
> + */
> +struct attestation_evidence_request {
> +	const u8 *challenge;
> +	size_t challenge_length;
> +	const struct attestation_evidence_object_request *objects;
> +	size_t objects_count;
> +};
> +
> +/**
> + * struct attestation_evidence_result - Provider evidence result.
> + * @object_lengths: produced length for every requested object
> + */
> +struct attestation_evidence_result {
> +	size_t *object_lengths;

No number of objects?  That would make this structure more
self-contained.  Copying `objects` from the request would allow passing
it around to handle results, but there may not be too much value in
doing it this way.

> +};
> +
> +/**
> + * struct attestation_provider - Immutable provider operations and properties.
> + * @evidence_get: produce requested evidence
> + * @mr_read: read one MR
> + * @mr_extend: extend one MR
> + * @evidence_caps: evidence capabilities, or NULL
> + * @mrs: fixed MR properties
> + * @mrs_count: number of fixed MRs
> + */
> +struct attestation_provider {
> +	int (*evidence_get)(struct attestation *att,
> +			    const struct attestation_evidence_request *request,
> +			    struct attestation_evidence_result *result);
> +	int (*mr_read)(struct attestation *att, unsigned int mr_id,
> +		       struct attestation_digest_set *values);
> +	int (*mr_extend)(struct attestation *att, unsigned int mr_id,
> +			 const struct attestation_digest_set *values);
> +	const struct attestation_evidence_caps *evidence_caps;
> +	const struct attestation_mr_props *mrs;
> +	size_t mrs_count;
> +};
> +
> +#endif /* _LINUX_ATTESTATION_H */
> -- 
> 2.56.0
