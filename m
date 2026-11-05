Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793886752;
	b=Eff3NaDAHFZviENrRENjpWtTmyknxKeVdBLOQoRqKW1wcmN2KJwQpcEJvg9YahWK5YgC
	 ClpQshNOf8xMzPmRo4FuMJSVKhZVQ96ja5zIQTh9k/SRfn8RjSHMvbSr0j5hm5/HdyiGO
	 LgAUpOTNmNUDrMI2SYcxspHFRjOQis/fVz4IvQdkHmxU0AuCZaGeGhNDp8LjOMFXC36J7
	 k0AylXh1Xdug0GTyMHx/89FkyN/8JDXtiiiWX09S0O+w24X+ezSwftWj7HEZNKIIJLIsn
	 IicsoaT4C4/AcAlE6LsEuiw8K7RPrvvvec7RaGiL5izDKYG0COY7+1GrDpYg0gWQRZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793886752;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=RsnUe3JgTB8DnyyeAYUnaAmGAs6RXw0MhN3JR3y8fLA=;
	b=E1w+bELqrTPFhL3My3Qhluiw0mAt7kiO6hwoCcxbRKCkXfBQ7+8GvHPZi7pj0dZsOcAB
	 HDYxVFr/N1TATuvHxmRxKk/U+5bZQiY+loaV9rn8DthuyXrc+FTKHSEKWWBEVLpe5qWrE
	 HDIutcBM8x2CaUHd1FpDC3jR0QKDtZ6l/Sssf+k27X+B2xODP1hVTqIAweCh6fh7hJnjW
	 CcXvSO1hShVbbAKze3Kl0rnhcNhpR2ARsaMB8tGOm6saMARSFo91cQHHGD8U69yJHYULf
	 dADqJp/Fqk/7hf+n4Lqk2wqsrzxRN3ZBCFlj7QGYvsA3hug9zdbEYcKyFLSVIU9vBmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dOQH4A24;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44B4F606A333;
	Thu,  5 Nov 2026 13:52:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44B4F606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dOQH4A24
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B9691650;
	Thu,  5 Nov 2026 05:52:23 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 374123F628;
	Thu,  5 Nov 2026 05:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793886746; bh=U59oM5gHSrnPLb3WgEtriMAyHxBns7UzuoS2VJzFNB8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dOQH4A24WRuTkitLEFqE+4JEmVDQkzQmG2G8d0S5B5K3MM5bRC9UfDmkrloVmL4yz
	 9L1KgPSvMstz/tUmr9wWbaKHmfp8Brpqab13VVX8sZ06a2V/XoAuMyZKxwpoCr80sP
	 CJcmUZcsQD+OG7nWeMGRTp4l2Tf3gTKbLHGA96OY=
Date: Thu, 5 Nov 2026 13:52:19 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Yeoreum Yun <yeoreum.yun@arm.com>,
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
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 17/20] attestation: Add CTLV operation handling
Message-ID: <auyKE2sGqtfjk4v5@e129823.arm.com>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261015145053.3664509-18-jiri@resnulli.us>
 <auuDcABX27EeTApl@e129823.arm.com>
 <20261104194622.GC3889730@ziepe.ca>
 <aux01NUd85PabtZu@FV6GYCPJ69>
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
In-Reply-To: <aux01NUd85PabtZu@FV6GYCPJ69>

On Thu, Nov 05, 2026 at 01:32:49PM +0100, Jiri Pirko wrote:
> Wed, Nov 04, 2026 at 08:46:22PM +0100, jgg@ziepe.ca wrote:
> >On Wed, Nov 04, 2026 at 07:11:44PM +0000, Yeoreum Yun wrote:
> >> [..snip..]
> >> 
> >> > +static int attestation_evidence_request_decode(struct attestation *att, struct ctlv_op_ctx *ctx,
> >> > +					       const struct ctlv_cursor *request,
> >> > +					       struct attestation_evidence_request *decoded,
> >> > +					       struct attestation_evidence_object_request **objects)
> >> > +{
> >> > +	const struct attestation_evidence_caps *caps = att->provider->evidence_caps;
> >> > +	u32 challenge_length;
> >> > +
> >> > +	decoded->challenge =
> >> > +		ctlv_attestation_evidence_get_evidence_challenge_get(request, &challenge_length);
> >> > +	decoded->challenge_length = challenge_length;
> >> > +	if (challenge_length < caps->min_challenge_length ||
> >> > +	    challenge_length > caps->max_challenge_length)
> >> 
> >> Hmm, I'm not sure whether this check is required for
> >> ATTESTATION_EVIDENCE_BLOB_EVENT_LOG blob type.
> >> 
> >> for example, if the provider provides two evidence:
> >>   - ATTESTATION_EVIDENCE_BLOB_PRIMARY (might attestation token)
> >>   - ATTESTATION_EVIDENCE_BLOB_EVENT_LOG
> >> 
> >> might challenge is reuiqred for generating the token
> >> and this would be marked at min/max_challenge_size in evidence_cap.
> >> 
> >> However, in case of eventlog, it wouldn't require challenge.
> >> for example, TPM event log or CCEL event log.
> >
> >Right
> >
> >> Do we need some field on attestation_evidence_supported_object whether
> >> it requires challenge or not and applies this sanity check per the object?
> >> 
> >> Otherwise, to get eventlog, it would need to send *dummy* challenge
> >> always.
> >
> >I wonder if we should have two interfaces here for signed and unsigned
> >evidence? It would be clearer for userspace then when it needs to
> >provide a challenge or not.
> 
> Isn't the challenge field provided/not-provided enough?
> 
> Currently on the introspection side, device-get op would provide
> challenge-lengths array:
> 
>         evidence?:
>           challenge-lengths[8]:
>             length?: uint(..4096)
>             min-length?: uint(..4096)
>             max-length?: uint(..4096)
>  	  objects[16]:
>             blob-class: evidence-blob-class
>             max-length: uint
>             blob-instance?: uint(..u32-max)
> 
> I think it would make sense to have challenge-lengths array per object:
> 
>  	  objects[16]:
>             blob-class: evidence-blob-class
>             max-length: uint
>             blob-instance?: uint(..u32-max)
>             challenge-lengths[8]:
>               length?: uint(..4096)
>               min-length?: uint(..4096)
>               max-length?: uint(..4096)
> 
> Then the unsigned object would just simply have challenge-lengths empty?

This looks good to me. :)

-- 
Sincerely,
Yeoreum Yun
