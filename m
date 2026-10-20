Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792537213;
	b=z8+aL7wV/mSGJWKeBvSyTJcGQTT9kbdSOtbl8RQPvcncMKPMvhkE7kxHG2YmHNWWytCu
	 OFTX+2e5HE6WfEonB+pvrZ/1g1KnoaVRvF491bQHZNAjX8DWEu7XVsz/73I3BoVCAKwzh
	 Xx727JCEXfwObsYKfHiLFElMoz4aptEuweto7gnJTsGvE7JqauAkSJlT8TTOBbHSQbTKt
	 5M3ACU9erK6JNotJS3T7rnGNG3bDIIVB1AsS7ARJ1pQwGHrvbVuKl67gA3Ot5UykoXPBK
	 /s3FtiGJ5qN2Bi28pApxl7Usz4aVDszQYgw+aSwI59410Kj0V6ZYNnOB3uxvm2YWpWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792537213;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=DgzMkFS09rbRFwZ4qpsmxdlgfbYdDf6ylfA8LxCI1R8=;
	b=kHhI00xG4vSVvXFj5muZbWOlIy1Fc93SAPJ061X7KvlxP9N9Ji24+YNkHNsSxInzG7FN
	 iICuYXp0aceesB+Oj4EmxOZm9qxQ6nZz3h0n8DW4yjbgTZw+vUZNwiRbBBPBRPHUhbY4R
	 M5ILfS+e9uyjdhQxaPaftd8pmPiZamP+KkBuIQpetUyZo0Uvpp1IptGIixMVOh658cL7u
	 jJsCebOVP4xy3kOODnxjxvCh1e5YJovwaUYajakm9FSPkYVMBSswtNtGPvFUdFCjI1j3T
	 f/UnEpLt6UnbgiT4t3XPlrYISXGqLxBn0h6hnumeBukOaFHbT9An15CO6hFeEPL9+Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GzWdJMx/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AF1606A31F;
	Tue, 20 Oct 2026 23:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GzWdJMx/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59CC1F000CA;
	Tue, 20 Oct 2026 23:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792537213;
	bh=DgzMkFS09rbRFwZ4qpsmxdlgfbYdDf6ylfA8LxCI1R8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GzWdJMx/J+lIl8jl0o/1aIJfIn0Fiikh7T+QKFR+muFhEsJWOyIDXXjHB+ymwJ9p3
	 X9xKslDzIkwXjT22ffDq28qVVcTwehXVKBjqCuMHe7oifsyFoFjE8mlPe6p69/MUG0
	 MqjZpXRtX22SZuDwxy9BmnfnERl772BdXOcn+WSnOCj9BqWo8CGdM6RLUV5lAFjL4n
	 S67onXBFxCsaRTyTczYF2pHQMsVGoY65AFPd8qbvie4RwhzkWSG1URpHInd65Koss/
	 OvO48afHdNcQIgFAjjreKYHN44g+BnKp9EmpI6DwUsl+l1SD9TVEjVky16hSIWSgCu
	 HRWv0tIfiqHhg==
Date: Wed, 21 Oct 2026 00:00:03 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com,
 lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
 cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
 James.Bottomley@HansenPartnership.com, aik@amd.com, jpiotrowski@nvidia.com,
 qinkun@google.com, pgonda@google.com, alistair.francis@wdc.com,
 ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
 dave.hansen@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 peter.fang@intel.com
Subject: Re: [PATCH RFC 02/20] ctlv: Add the UAPI wire format and family API
Message-ID: <20261021000003.71f78d99@jic23-hlaptop>
In-Reply-To: <20261015145053.3664509-3-jiri@resnulli.us>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	<20261015145053.3664509-3-jiri@resnulli.us>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Oct 2026 16:50:35 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@nvidia.com>
> 
> Define CTLV's common TLV transport, ioctl, event records, identifiers
> and limits. Add the in-kernel API used by family implementations and
> generated code.
> 
> Assisted-by: Cursor: GPT-5.6 Sol
> Assisted-by: Cursor: Claude Opus 5.5
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Minor stuff only.  Some of it moaning about toys we don't get in uapi
headers that make kernel code 'so elegant' :)

> diff --git a/include/linux/ctlv_family.h b/include/linux/ctlv_family.h
> new file mode 100644
> index 000000000000..1ae4d3a536f7
> --- /dev/null
> +++ b/include/linux/ctlv_family.h

FWIW I fully agree with Jason that sometimes it is worth burning
some lines and even duplicating things a bit to avoid too many
complex macros.  I didn't have anything to add to comments on this file
at this point.  Will see how new version looks!


> diff --git a/include/uapi/linux/ctlv.h b/include/uapi/linux/ctlv.h
> new file mode 100644
> index 000000000000..6bc0d1a296e6
> --- /dev/null
> +++ b/include/uapi/linux/ctlv.h
> @@ -0,0 +1,183 @@
> +/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
> +/*
> + * Copyright (c) 2026, NVIDIA CORPORATION & AFFILIATES
> + *
> + * CTLV transport UAPI: the TLV wire format, the op-execution ioctl, the event
> + * record header and transport limits. Schema-free; a family's constants
> + * are generated into <linux/<family>_gen.h>, the root family's into
> + * <linux/ctlv_gen.h>.
> + */
> +#ifndef _UAPI_LINUX_CTLV_H
> +#define _UAPI_LINUX_CTLV_H
> +
> +#include <linux/ioctl.h>
> +#include <linux/types.h>
> +
> +/**
> + * struct ctlv_attr - Attr header.
> + * @len: this header plus its payload, excluding this attr's trailing padding
> + * @flags: CTLV_ATTR_F_* bits
> + * @attr_id: complete attr ID, or CTLV_ATTR_ROOT for a message root
> + *
> + * Attrs are aligned to CTLV_ALIGNTO, which is why @attr_id is __aligned_u64: a
> + * 32-bit ABI would otherwise align this structure to four bytes. A nested
> + * payload is the concatenation of CTLV_ALIGN(child.len) bytes per child, so
> + * child padding counts inside the containing attr's @len while a leaf's own

Whilst I get what you mean, leaf doesn't feel like a clear concept in this
comment block.  Maybe 'this attrs own padding does not.' or something like that?

> + * padding does not. Scalar payloads are native-endian. Within each request
> + * root or nest, occurrences of one @attr_id are contiguous; different IDs
> + * otherwise have no required order.
> + */
> +struct ctlv_attr {
> +	__u32 len;
> +	__u32 flags;
> +	__aligned_u64 attr_id;
> +};
> +
> +#define CTLV_ALIGNTO 8
> +#define CTLV_ALIGN(_len) (((_len) + CTLV_ALIGNTO - 1) & ~(CTLV_ALIGNTO - 1))

Could this use __ALIGN_KERNEL() from uapi/linux/const.h?


> +
> +/* Set exactly on root and nested attrs, clear on scalar attrs. */
> +#define CTLV_ATTR_F_NESTED		(1U << 0)
> +/* Query fragments: set on the root and each nest logically open at the end. */
> +#define CTLV_ATTR_F_FRAG_MORE		(1U << 1)
> +/*
> + * A request attr, never the root, that a device whose schema does not declare
> + * its ID skips whole instead of refusing the message. An ID that schema does
> + * declare is held to it wherever it appears, so this asks to be forgiven what
> + * this kernel has never heard of and nothing else.
> + */
> +#define CTLV_ATTR_F_IGNORE_IF_UNKNOWN	(1U << 2)

Doesn't really matter but could use __BITUL() just to hammer home this are single
bits. Places like pci_regs.h have started doing this for new things.



> +/* Implementation limits, not wire-field maxima: raising them is compatible. */
> +
> +/* Request roots, action replies, query reply fragments and event roots. */
> +#define CTLV_MAX_INLINE_MESSAGE_LEN	0x100000	/* 1 MiB */
> +/* Includes the error information root. */
> +#define CTLV_MAX_ERROR_LEN		0x4000		/* 16 KiB */
> +/* The root attr is at depth zero. */
> +#define CTLV_MAX_NEST_DEPTH		32
> +#define CTLV_DEFAULT_QUERY_REPLY_LEN	0x10000		/* 64 KiB */
> +#define CTLV_MAX_EVENT_QUEUE_LEN	0x1000000	/* 16 MiB */

Pity the linux/sizes.h header isn't in UAPI as result is we need
those comments on what the sizes are.  Ah well, never mind.

> +
> +#endif /* _UAPI_LINUX_CTLV_H */

