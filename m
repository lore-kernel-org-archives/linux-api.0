Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794075738;
	b=zk/siqEIt3aWh8AcuKvqeE3pOWnGU//FxaB3/RDdXJJKP6Ym3LFaVxndA32gsNQrYO69
	 1GzduplNkyAdRxfLkmqdWXOXmWuUZe8oScLVIuwVjDrpGNtaMYzVoWMfKdkbOuEMpFYJw
	 i6b2MZE6o6Mwm08lqKi3Mil+39GQXrqd5tkQMxXAI4ZXjqIpkdPTxHUHvsfhY6kfIC+By
	 tXTmcnX25A1IXaQ1uFSPaahKAwAuXedo4rV/96CpxjvtCQ7BBgcJlv5Dc2f2Pyy9Dfazz
	 HWzUGf48q9Q2k1y3PYvTkCLhVCbahQ3RQnQoDb3rQFkyZovjtzZn60BYCzTygNw9BIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794075738;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=0PYrrOTARKubZGB4WKQQtaeNrSGw8tapkr1EDK855Qs=;
	b=v4MOOsHQr8fRKUifq/44XfNXXCjYFII8ztfUMrwU6zSgYC/5Ks1IWVrEGmxlwPxEOB/0
	 t7RIUeEdkKEHXdqK5sat77JGWWYWnoRbiXSSDFQCU2oFi/8zgZJEBmgQOYPWWWek9Ogxh
	 XU6TIBNh82j2mUzLs8QD5mMAe35DhzE29uicF2tgikNVZk9FymW6nFO7jn/Rd7sHVjQaB
	 PnG0Xydqm6TlPcKbeQHtMsTCsQ7I7cr26c68uy4x9jzITUb5djvAF8MfH97MUPeih8CVt
	 1xEUM4CtO6zvXxUQc6pS8mS6OjK83QhtWomxkiaj6YjvM/71WzsSqrmcQ6qNh/N62xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dSoSTh0A;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BAD0606A32D;
	Sat,  7 Nov 2026 18:22:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BAD0606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dSoSTh0A
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F456152B;
	Sat,  7 Nov 2026 10:22:12 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E9F4F3F673;
	Sat,  7 Nov 2026 10:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794075735; bh=oCNyzWg3oBOCxZL5sK6vJaGzWB3RBDFj1HrKHmc/TO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dSoSTh0AYSDOUr0CpLFMh7a/aIdcmiOdAYQ5QYM6Uyr3K6vj3gUpDL+3dyU7RL7SE
	 +tdAi6nPsNryVLVnlQGfnf7gSA4PnLsU+dxgYdo3PArwciNODCtLmaiUG2CUIXM7Dg
	 WqINi8+mQwoiGN7WqyN70mM0O5lJ9/s2yc6d38oQ=
Date: Sat, 7 Nov 2026 18:22:08 +0000
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
Message-ID: <au9sUBtdnDk9yA1U@e129823.arm.com>
References: <20261104194622.GC3889730@ziepe.ca>
 <aux01NUd85PabtZu@FV6GYCPJ69>
 <auyKE2sGqtfjk4v5@e129823.arm.com>
 <auy7IM0_S2tv7EZX@FV6GYCPJ69>
 <au2WdWFOYbPEv0Uj@e129823.arm.com>
 <au3i-0eDzJZaWukx@FV6GYCPJ69>
 <au3mAsQrh0GniXJo@e129823.arm.com>
 <au34wXtIqii-hfFI@FV6GYCPJ69>
 <au3-LyBiCZtUMpEx@e129823.arm.com>
 <au9eskF5P17h3cql@FV6GYCPJ69>
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
In-Reply-To: <au9eskF5P17h3cql@FV6GYCPJ69>

On Sat, Nov 07, 2026 at 06:25:54PM +0100, Jiri Pirko wrote:
> Fri, Nov 06, 2026 at 05:19:59PM +0100, yeoreum.yun@arm.com wrote:
> >On Fri, Nov 06, 2026 at 05:03:32PM +0100, Jiri Pirko wrote:
> >> Fri, Nov 06, 2026 at 03:36:50PM +0100, yeoreum.yun@arm.com wrote:
> >> >> Fri, Nov 06, 2026 at 09:57:25AM +0100, yeoreum.yun@arm.com wrote:
> >> >> >On Fri, Nov 06, 2026 at 09:27:42AM +0100, Jiri Pirko wrote:
> >> >> >> Thu, Nov 05, 2026 at 02:52:19PM +0100, yeoreum.yun@arm.com wrote:
> >> >> >> >On Thu, Nov 05, 2026 at 01:32:49PM +0100, Jiri Pirko wrote:
> >> >> >> >> Wed, Nov 04, 2026 at 08:46:22PM +0100, jgg@ziepe.ca wrote:
> >> >> >> >> >On Wed, Nov 04, 2026 at 07:11:44PM +0000, Yeoreum Yun wrote:
> >> >> >> >> >> [..snip..]
> >> >> >> >> >> 
> >> >> >> >> >> > +static int attestation_evidence_request_decode(struct attestation *att, struct ctlv_op_ctx *ctx,
> >> >> >> >> >> > +					       const struct ctlv_cursor *request,
> >> >> >> >> >> > +					       struct attestation_evidence_request *decoded,
> >> >> >> >> >> > +					       struct attestation_evidence_object_request **objects)
> >> >> >> >> >> > +{
> >> >> >> >> >> > +	const struct attestation_evidence_caps *caps = att->provider->evidence_caps;
> >> >> >> >> >> > +	u32 challenge_length;
> >> >> >> >> >> > +
> >> >> >> >> >> > +	decoded->challenge =
> >> >> >> >> >> > +		ctlv_attestation_evidence_get_evidence_challenge_get(request, &challenge_length);
> >> >> >> >> >> > +	decoded->challenge_length = challenge_length;
> >> >> >> >> >> > +	if (challenge_length < caps->min_challenge_length ||
> >> >> >> >> >> > +	    challenge_length > caps->max_challenge_length)
> >> >> >> >> >> 
> >> >> >> >> >> Hmm, I'm not sure whether this check is required for
> >> >> >> >> >> ATTESTATION_EVIDENCE_BLOB_EVENT_LOG blob type.
> >> >> >> >> >> 
> >> >> >> >> >> for example, if the provider provides two evidence:
> >> >> >> >> >>   - ATTESTATION_EVIDENCE_BLOB_PRIMARY (might attestation token)
> >> >> >> >> >>   - ATTESTATION_EVIDENCE_BLOB_EVENT_LOG
> >> >> >> >> >> 
> >> >> >> >> >> might challenge is reuiqred for generating the token
> >> >> >> >> >> and this would be marked at min/max_challenge_size in evidence_cap.
> >> >> >> >> >> 
> >> >> >> >> >> However, in case of eventlog, it wouldn't require challenge.
> >> >> >> >> >> for example, TPM event log or CCEL event log.
> >> >> >> >> >
> >> >> >> >> >Right
> >> >> >> >> >
> >> >> >> >> >> Do we need some field on attestation_evidence_supported_object whether
> >> >> >> >> >> it requires challenge or not and applies this sanity check per the object?
> >> >> >> >> >> 
> >> >> >> >> >> Otherwise, to get eventlog, it would need to send *dummy* challenge
> >> >> >> >> >> always.
> >> >> >> >> >
> >> >> >> >> >I wonder if we should have two interfaces here for signed and unsigned
> >> >> >> >> >evidence? It would be clearer for userspace then when it needs to
> >> >> >> >> >provide a challenge or not.
> >> >> >> >> 
> >> >> >> >> Isn't the challenge field provided/not-provided enough?
> >> >> >> >> 
> >> >> >> >> Currently on the introspection side, device-get op would provide
> >> >> >> >> challenge-lengths array:
> >> >> >> >> 
> >> >> >> >>         evidence?:
> >> >> >> >>           challenge-lengths[8]:
> >> >> >> >>             length?: uint(..4096)
> >> >> >> >>             min-length?: uint(..4096)
> >> >> >> >>             max-length?: uint(..4096)
> >> >> >> >>  	  objects[16]:
> >> >> >> >>             blob-class: evidence-blob-class
> >> >> >> >>             max-length: uint
> >> >> >> >>             blob-instance?: uint(..u32-max)
> >> >> >> >> 
> >> >> >> >> I think it would make sense to have challenge-lengths array per object:
> >> >> >> >> 
> >> >> >> >>  	  objects[16]:
> >> >> >> >>             blob-class: evidence-blob-class
> >> >> >> >>             max-length: uint
> >> >> >> >>             blob-instance?: uint(..u32-max)
> >> >> >> >>             challenge-lengths[8]:
> >> >> >> >>               length?: uint(..4096)
> >> >> >> >>               min-length?: uint(..4096)
> >> >> >> >>               max-length?: uint(..4096)
> >> >> >> >> 
> >> >> >> >> Then the unsigned object would just simply have challenge-lengths empty?
> >> >> >> >
> >> >> >> >This looks good to me. :)
> >> >> >> 
> >> >> >> The challenge is one of several open points that all depend on what an
> >> >> >> evidence object is: Rick's TDREPORT, legacy versus DICE Quotes,
> >> >> >> "primary", "raw" and the format strings. Here is my proposal to settle
> >> >> >> these together:
> >> >> >> 
> >> >> >> The model:
> >> >> >> 
> >> >> >> 1. device-get lists each object with an id, a class (signed, event-log,
> >> >> >>    cert-chain or auxiliary), the formats it may come in, its max-length
> >> >> >>    and, for signed objects only, challenge-lengths.
> >> >> >> 2. evidence-get names objects by id, as MR ops name MRs, each with its
> >> >> >>    output blob. It carries a challenge exactly when it names a signed
> >> >> >>    object, and the challenge has to fit each of them.
> >> >> >> 3. The reply gives each object's format, length and, where the TCB
> >> >> >>    vouches for it, the TCB's digest. The output is always {label, data}.
> >> >> >> 4. A signed object is made by the call, over the challenge, and never
> >> >> >>    reused. The rest are read as they stand.
> >> >> >> 
> >> >> >> This settles following issues discussed during this patchset review:
> >> >> >> 
> >> >> >> 1. One op, not two. Per-object challenge-lengths tell userspace when to
> >> >> >>    pass a challenge, and one call returns the signed object with the log
> >> >> >>    and certificates needed to check it.
> >> >> >> 2. TDX's TDREPORT goes: it is MAC'd for the platform, not signed.
> >> >> >>    /dev/tdx_guest keeps TDX_CMD_GET_REPORT0.
> >> >> >> 3. TDX's Quote object lists the legacy and the DICE format. The provider
> >> >> >>    labels what the host returned and fails on a Quote it cannot label.
> >> >> >> 4. "primary" becomes "signed", manifest joins auxiliary, spdm-vca,
> >> >> >>    spdm-measurements and tdisp-report become formats, and signature
> >> >> >>    goes, as a signed object carries its own.
> >> >> >> 5. "raw" goes with the representation attr. The TCB digest is a reply
> >> >> >>    field, so a blob always holds the object's own bytes.
> >> >> >> 
> >> >> >> Formats become an enum each provider family defines, instead of free
> >> >> >> strings. I'm still unsure if format should be entirely provider-specific
> >> >> >> and defined as "extension", or it should be somehow mixture of common
> >> >> >> and provider-specific. Looks there is not really much common
> >> >> >> anyway, so I lean towards provider-specific only. So far I have:
> >> >> >
> >> >> >Overall, This is plausible for me with some small question.
> >> >> >
> >> >> >> 
> >> >> >> ======  ============  ==========  =========  ===========================
> >> >> >> Family  Format        Class       Challenge  Bytes
> >> >> >> ======  ============  ==========  =========  ===========================
> >> >> >[...]
> >> >> >> tpm     ek-cert       cert-chain  none       EK certificate from NV
> >> >> >
> >> >> >Just a thought, but how are we planning to retrieve
> >> >> >the NV index for EK certificate?
> >> >> >
> >> >> >As far as I know, TPM NV storage doesn't support labeling.
> >> >> >
> >> >> >Should I assume that the NV index would be specified as part of the
> >> >> >challenge to retrieve the certificate from TPM NV storage?
> >> >> 
> >> >> evidence-get allows to accept mr-selection as part of the request
> >> >> alongside the challenge.
> >> >
> >> >Sorry. Could you explain a little bit detail for this?.
> >> >AFAIU, this is to get the EK certificate from TPM non-volatile storage.
> >> >But, I don't know why *EK* certificate get would be relevant for
> >> >*mr selection*.  AFAIK, the TPM_Quote will be used AK not a EK.
> >> 
> >> You are right, my mistake. I misunderstood the question.
> >> 
> >> mr-selection selects PCRs for Quote, or an extend-NV measurement
> >> register for NV Certify.
> >> 
> >> An NV-resident EK certificate is retrieved using NV_Read. I think
> >> blob-instance is a good fit. For TPM certificate objects, it could
> >> identify the certificate's NV index.
> >
> >Ah. I missed the TCG_EK_Credential_Profile specification which defines
> >the NV index value for EK certificate:
> >
> >2.2.1.4 Low Range
> >  The Low Range is at NV Indices 0x01c00002 - 0x01c0000c.
> >    0x01c00002 RSA 2048 EK Certificate
> >    0x01c00003 RSA 2048 EK Nonce
> >    0x01c00004 RSA 2048 EK Template
> >    0x01c0000a ECC NIST P256 EK Certificate
> >    0x01c0000b ECC NIST P256 EK Nonce
> >    0x01c0000c ECC NIST P256 EK Template
> >
> >But, do we need some argument to get which EK certificate to get?
> >(RSA or ECC NIST P256)?
> 
> Why blob-instance 0-10 is not good enough here?

No, it's enough with just breaking down format like:
======  ============  ==========  =========  ===========================
Family  Format        Class       Challenge  Bytes
======  ============  ==========  =========  ===========================
tpm     ek-cert-rsa   cert-chain  none       EK certificate from NV
tpm     ek-cert-ecc   cert-chain  none       EK certificate from NV

> 
> 
> >
> >Otherwise, Is this interface going to print all EK certificate
> >regardless of alg?
> >
> >> >Also, AFAIK, mr_selection is meaningful when the evidence_accept is
> >> >supported.
> >> 
> >> These are independent. mr-selection chooses the measurements included
> >> in evidence. EVIDENCE_ACCEPT authorizes a subsequent native transition.
> >> The TPM provider can quote selected PCRs without supporting acceptance.
> >
> >Acked.
> >
> >-- 
> >Sincerely,
> >Yeoreum Yun

-- 
Sincerely,
Yeoreum Yun
