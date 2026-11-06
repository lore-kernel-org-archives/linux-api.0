Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793955453;
	b=a4I7XeOWpEYjZtxshlGdeRbM1PTcu/LHz0RPodc7WpgJeUBH3RiqEy7XhsiiYShqrgLx
	 M9UHNtrqa3v7Hy1Tpug/t9e2Ha/+pMtrlnlGOJ46QM2PPHCamvTLLg7LOfugkfkqDoivf
	 S4QLEM/CNG1MmeuTZvigSd150fmlOuUuCIVArDOduReg9bd+bKR1EuI0lx5pe/eh/M9lv
	 L5IiirVLhu9Ro9cwnM1Xj+ZcG2DdaoIGHKMtp31y2A8/vVOrAW4HTpxZW+Cd/mhMM8dlF
	 9Mp9MYkymJ3BFwjAOwF4CtFOri64Rpmw8ASeF7ltgnv3nNhDNqXN37AEQc8IYeMpWYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793955453;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=U8NbQLJQXWhE9kRQfhYMRG1gPTaScKvk/CWFssfmr0M=;
	b=1RI5IcoW44sYCFv8H+D4wSo/fTEqRE0Mc07aofYa50WxwX3d5sYwOENQb19NEU0e8mvP
	 z67M6srWl500oJLVR1v/A7UsxyRs0hudgcrUJdCRJzpNXfv8E/HuCYwKCRVbeP9GcCzj4
	 1Eopvob0Ox/f1PSEhp8G+BtmjBUOJrSAVx4cghYclojlrShWKOKwCpK8KqL3lcIEbnRdi
	 BOe81WKsSFoIoJD6RWORtqvX5KBvxG+yrZqY1sQkBA6zkaIi+miw0Nu/QiICvQ7KUaOa0
	 dJsvAeW3hmSBzalr3PObN/tkMkZLUO1blbWnDWBc7FEwXzTkEuiHw/9RYtQo/IYiI0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XszJqe4J;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27B1606A32C;
	Fri,  6 Nov 2026 08:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C27B1606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XszJqe4J
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD0C91650;
	Fri,  6 Nov 2026 00:57:28 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 945A63F673;
	Fri,  6 Nov 2026 00:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793955452; bh=O/L8Xi+/doDKEHUTFfH9GXIaTDWnQJy0rB+FzYj+0/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XszJqe4JrvzxPntwZX3H1oWIoGpTG4x+s3Eno/88TbHCZ0FGPvkSOrDvEtcBCz0s9
	 x8laoq14tL0TS1I17eP+Fd3F5Ox8CIiN9yaH+byC8xsMcqvhXaySnADXt+e7uGt5iJ
	 ov6U+NtVpkprCc3zV6oCmqqNrj8n/80rxEetD8LM=
Date: Fri, 6 Nov 2026 08:57:25 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, drdeeglaze@gmail.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
	aneesh.kumar@kernel.org
Subject: Re: [PATCH RFC 17/20] attestation: Add CTLV operation handling
Message-ID: <au2WdWFOYbPEv0Uj@e129823.arm.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-18-jiri@resnulli.us>
 <auuDcABX27EeTApl@e129823.arm.com>
 <20261104194622.GC3889730@ziepe.ca>
 <aux01NUd85PabtZu@FV6GYCPJ69>
 <auyKE2sGqtfjk4v5@e129823.arm.com>
 <auy7IM0_S2tv7EZX@FV6GYCPJ69>
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
In-Reply-To: <auy7IM0_S2tv7EZX@FV6GYCPJ69>

On Fri, Nov 06, 2026 at 09:27:42AM +0100, Jiri Pirko wrote:
> Thu, Nov 05, 2026 at 02:52:19PM +0100, yeoreum.yun@arm.com wrote:
> >On Thu, Nov 05, 2026 at 01:32:49PM +0100, Jiri Pirko wrote:
> >> Wed, Nov 04, 2026 at 08:46:22PM +0100, jgg@ziepe.ca wrote:
> >> >On Wed, Nov 04, 2026 at 07:11:44PM +0000, Yeoreum Yun wrote:
> >> >> [..snip..]
> >> >> 
> >> >> > +static int attestation_evidence_request_decode(struct attestation *att, struct ctlv_op_ctx *ctx,
> >> >> > +					       const struct ctlv_cursor *request,
> >> >> > +					       struct attestation_evidence_request *decoded,
> >> >> > +					       struct attestation_evidence_object_request **objects)
> >> >> > +{
> >> >> > +	const struct attestation_evidence_caps *caps = att->provider->evidence_caps;
> >> >> > +	u32 challenge_length;
> >> >> > +
> >> >> > +	decoded->challenge =
> >> >> > +		ctlv_attestation_evidence_get_evidence_challenge_get(request, &challenge_length);
> >> >> > +	decoded->challenge_length = challenge_length;
> >> >> > +	if (challenge_length < caps->min_challenge_length ||
> >> >> > +	    challenge_length > caps->max_challenge_length)
> >> >> 
> >> >> Hmm, I'm not sure whether this check is required for
> >> >> ATTESTATION_EVIDENCE_BLOB_EVENT_LOG blob type.
> >> >> 
> >> >> for example, if the provider provides two evidence:
> >> >>   - ATTESTATION_EVIDENCE_BLOB_PRIMARY (might attestation token)
> >> >>   - ATTESTATION_EVIDENCE_BLOB_EVENT_LOG
> >> >> 
> >> >> might challenge is reuiqred for generating the token
> >> >> and this would be marked at min/max_challenge_size in evidence_cap.
> >> >> 
> >> >> However, in case of eventlog, it wouldn't require challenge.
> >> >> for example, TPM event log or CCEL event log.
> >> >
> >> >Right
> >> >
> >> >> Do we need some field on attestation_evidence_supported_object whether
> >> >> it requires challenge or not and applies this sanity check per the object?
> >> >> 
> >> >> Otherwise, to get eventlog, it would need to send *dummy* challenge
> >> >> always.
> >> >
> >> >I wonder if we should have two interfaces here for signed and unsigned
> >> >evidence? It would be clearer for userspace then when it needs to
> >> >provide a challenge or not.
> >> 
> >> Isn't the challenge field provided/not-provided enough?
> >> 
> >> Currently on the introspection side, device-get op would provide
> >> challenge-lengths array:
> >> 
> >>         evidence?:
> >>           challenge-lengths[8]:
> >>             length?: uint(..4096)
> >>             min-length?: uint(..4096)
> >>             max-length?: uint(..4096)
> >>  	  objects[16]:
> >>             blob-class: evidence-blob-class
> >>             max-length: uint
> >>             blob-instance?: uint(..u32-max)
> >> 
> >> I think it would make sense to have challenge-lengths array per object:
> >> 
> >>  	  objects[16]:
> >>             blob-class: evidence-blob-class
> >>             max-length: uint
> >>             blob-instance?: uint(..u32-max)
> >>             challenge-lengths[8]:
> >>               length?: uint(..4096)
> >>               min-length?: uint(..4096)
> >>               max-length?: uint(..4096)
> >> 
> >> Then the unsigned object would just simply have challenge-lengths empty?
> >
> >This looks good to me. :)
> 
> The challenge is one of several open points that all depend on what an
> evidence object is: Rick's TDREPORT, legacy versus DICE Quotes,
> "primary", "raw" and the format strings. Here is my proposal to settle
> these together:
> 
> The model:
> 
> 1. device-get lists each object with an id, a class (signed, event-log,
>    cert-chain or auxiliary), the formats it may come in, its max-length
>    and, for signed objects only, challenge-lengths.
> 2. evidence-get names objects by id, as MR ops name MRs, each with its
>    output blob. It carries a challenge exactly when it names a signed
>    object, and the challenge has to fit each of them.
> 3. The reply gives each object's format, length and, where the TCB
>    vouches for it, the TCB's digest. The output is always {label, data}.
> 4. A signed object is made by the call, over the challenge, and never
>    reused. The rest are read as they stand.
> 
> This settles following issues discussed during this patchset review:
> 
> 1. One op, not two. Per-object challenge-lengths tell userspace when to
>    pass a challenge, and one call returns the signed object with the log
>    and certificates needed to check it.
> 2. TDX's TDREPORT goes: it is MAC'd for the platform, not signed.
>    /dev/tdx_guest keeps TDX_CMD_GET_REPORT0.
> 3. TDX's Quote object lists the legacy and the DICE format. The provider
>    labels what the host returned and fails on a Quote it cannot label.
> 4. "primary" becomes "signed", manifest joins auxiliary, spdm-vca,
>    spdm-measurements and tdisp-report become formats, and signature
>    goes, as a signed object carries its own.
> 5. "raw" goes with the representation attr. The TCB digest is a reply
>    field, so a blob always holds the object's own bytes.
> 
> Formats become an enum each provider family defines, instead of free
> strings. I'm still unsure if format should be entirely provider-specific
> and defined as "extension", or it should be somehow mixture of common
> and provider-specific. Looks there is not really much common
> anyway, so I lean towards provider-specific only. So far I have:

Overall, This is plausible for me with some small question.

> 
> ======  ============  ==========  =========  ===========================
> Family  Format        Class       Challenge  Bytes
> ======  ============  ==========  =========  ===========================
[...]
> tpm     ek-cert       cert-chain  none       EK certificate from NV

Just a thought, but how are we planning to retrieve
the NV index for EK certificate?

As far as I know, TPM NV storage doesn't support labeling.

Should I assume that the NV index would be specified as part of the
challenge to retrieve the certificate from TPM NV storage?

[...]
> armcca  event-log     event-log   none       Realm firmware log, if any

JFYI, this would be a CCEL log like tdx:
  - https://github.com/tianocore/edk2/issues/11384


> snp     report        signed      64         SNP attestation report
> snp     cert-table    cert-chain  none       VCEK or VLEK, ASK and ARK
> ======  ============  ==========  =========  ===========================
> 
> Did I miss something that would break us here?
> 
> CTLV layout draft:
> 
>     device-get reply, caps.evidence:
>       objects[16]:
>         id: uint(..15)
>         class: evidence-class
>         # The reply says which one was written.
>         formats[4]: evidence-format
>         max-length: uint
>         # Signed objects only, entries as today.
>         challenge-lengths[8]?: ...
>         # Descriptive, such as an SPDM slot.
>         instance?: uint(..u32-max)
>         # When the TCB vouches for the object with a digest.
>         tcb-digest-algo?: hash-algo
> 
>     evidence-get request:
>       # Required exactly when a signed object is named.
>       challenge?: binary(1..4K)
>       objects[16]:
>         id: uint(..15)
>         data: blob(out, va memfd dma-buf)
>       # selection, privlevel, service and options as now.
> 
>     evidence-get reply:
>       # In request order.
>       objects[16]:
>         format: evidence-format
>         length: uint
>         tcb-digest?:
>           hash-algo: hash-algo
>           data: binary(16..64)
>       # The generations as now.
> 
> Makes sense?

For me, It seems fine.

-- 
Sincerely,
Yeoreum Yun
