Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572391F30BB;
	Sat, 17 Oct 2026 20:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792270511; cv=none; b=G7qMZhs18a7kmV3f3qr7AKJQxzk8ES6cviHm7vbwkKV8a1FsrHjEGQVVslc0SpmWQaXo8EmjL27YelCgt4TDXRU3+0pUzB8OOwGL5A0KjlEWGYpwjSS2Jlx9mlrPL6lJZrcUwiWxhiJ2pGrsi7/351Yp16b6KWE6AjEINCzs1N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792270511; c=relaxed/simple;
	bh=yGno2iTDq5hw0OHBXLo7UU2CESgBiS7RV1/ZeYDAU1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8IHjro0Z9Lx7OyDzS1286rVT2sWDIwBWFQGqPKoDWtqmm166DAP4XEiW0hCg8C4HKFAfwhaxHzebaFnz5wrZAKXeZvnpEl2b4sF3RumgOiZWdepIGCH4Ef1F+AAfl6++qk4xUz4dIXzugLJvNZ0DPxXwNc80D5FpRVh2VEHHBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VW6kcfxX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VW6kcfxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414541F000C4;
	Sat, 17 Oct 2026 20:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792270509;
	bh=P/uqGyU7l9Qf7Ba9DLV47J1ke5U16L/bBf8Zedn49kY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VW6kcfxXDGhEdgWIZabCbJZltp6NVLkCivx7DW93VkCROqiGBjJxHGRkPstlE7dJz
	 8OWfvSBoy1upGSVCquk+/ZYV+/bi8sWpaqOdeMwHCnr5aKtIeIgvNfxzlFj8a9Bz0l
	 oF6TOpM3MKifRjY0c2TKrqg8i0vws+gckl6kxxo86Xg9+FBOygXdDDzOtmBu0hpPC0
	 k7ab54vOWRhB+QyxffXDFVBNEKX+gI0K2itji1CG79+R7n/0oFWeic+SdfxI6pirZS
	 hj6AkUIuSHGSkc5QDo36VjcSI98n6D7/NPuQgPMmqjsFLhmuFMSTkDWAZyQ+SJzdoN
	 /dMGYaCjjSifQ==
Date: Sat, 17 Oct 2026 23:55:05 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dionna Glaze <drdeeglaze@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, david.quigley@intel.com, lukas@wunner.de,
	ksinyuk@kernel.org, rodrigo.vivi@intel.com, cedric.xing@intel.com,
	sameo@meta.com, James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <atPgqROZZxnihYfC@kernel.org>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <20261017203407.GM13920@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017203407.GM13920@nvidia.com>

On Sat, Oct 17, 2026 at 05:34:07PM -0300, Jason Gunthorpe wrote:
> > +Jarkko
> > The TPM driver is pretty entrenched and heavily used by different user
> > space applications, so it seems really ambitious to bundle in TPM
> > here.
> 
> By "ROT agility" I mean if you want to do an extend operation you
> should not have to know the details of the HW holding the "PCR".
> 
> One of the APIs offered here is a HW agnostic extend that can be used
> to build ROT agility into user space programs that are doing
> logging. That's systemd-pcr-extend for example.
> 
> The extent of the TPM support is to be able to issue a PCR extend
> triggered with a TPM command by the agnostic API. Not ambitious at
> all.

I wish I had a better picture what is going on.

I don't have capacity to heavily on this but can help sorting out
issues if they are put better into nutshell.

I would recommend to at least check out tpm2-protocol because when
I did it my main use case was exactly protocol interceptor. It is
designed from the bottom for that one use case. Plus zero cost
memory usage can be casted to a raw pointer.

Br, Jarkko
