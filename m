Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3739D3A542B;
	Sat, 17 Oct 2026 19:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792263969; cv=none; b=bwPJX0ihmM5OT5daQBNWOudSi8GZaB0u9YcwGTMXuQgNPnegArU3ocCaip2ukVphG0s8IX9wLoXLVzha4MrNMklIe47Oo4kij4JaUFv9/cxAKc/9RXQqFJX6rpSC/23aKoWVBGEYtVh0gPBmoVIn6SWxfu24B4xW9wMwSM5vvDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792263969; c=relaxed/simple;
	bh=i6dC7Gb0ndxFtpavZSmCzK65DY2ECoLUqL2W9aT9IG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j3Ft/NNcc3Ea13F24PaCu+MEfrBBmi/P6PVzXd97RwXrrWPfefrFMc+6UyySlyXztwvRx6YH++NBemnpWRUFs4FwhDZSGAL4kf3mAJ7HvLiCfdVu2UhvBVW+ZwLy5CNdwBbNzOfV6JQdYDV2sYkWKSTTUSCBkKzp/R8MZAcLRbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ab3YQKLi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ab3YQKLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7811F000C4;
	Sat, 17 Oct 2026 19:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792263967;
	bh=ajLC8mkk50RHMw7Urd9PrK4QoCFzGuQMoIysPTSBY4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ab3YQKLipR+i93ddz+0I23rbhBcG8sVpei4gwRer9ETup17+ddxwxITi2G+AbMXor
	 CQs69vW0CEY2NPevcsv5WELJo55mGVubIXp9emKBZ19Y4v5J+Vl+TLn4QddWaosPvH
	 6ZjgPyIkCoQzAkC04akEQKqmEp6Yw+K+RDa3fLJOD6JUAmpc2/rCoULi7tpYKF61KD
	 PB29N2gZohbFAIlpNboXOrmpk8Mi85AUWc8yg8To0TkDgOJ/zY4rs+M3Xw/7Y6gpu1
	 qqKAhUe/GRp2tUQwLcawXFBH1kPiR48ODRqZasWSdQ0fm8Itep3wbI5/ZsXWGhD3Gs
	 xtrGHPtjUAhsA==
Date: Sat, 17 Oct 2026 22:06:04 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Dionna Glaze <drdeeglaze@gmail.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
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
Message-ID: <atPHHNVJ2w0bkJIC@kernel.org>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>

On Sat, Oct 17, 2026 at 11:16:07AM -0700, Dionna Glaze wrote:
> +Jarkko
> The TPM driver is pretty entrenched and heavily used by different user
> space applications, so it seems really ambitious to bundle in TPM
> here.

This is something on the table thanks to Trenchboot and its early boot
code.

One key atom is prepared to be robust in early environments i.e.,
struct tpm_buf. I rewrote it as it is the atom here albeit not very
visible change as itself.

I think rest is to define how to cut and decouple the current code,
and how it is split to source modules so that the right stuff gets 
linked to the target binaries.

I think with enough trouble tpm_tis for instance could have a flagged
early boot version. I would actually do a tpm_tis_early.c source module
for this, which would never be linked to kernel but would wire like
the rest of the driver to the framework.

The actual hard part is to re-engineer tpm_chip, tpm_chip_ops and
transmit flow perhaps so that the framework is easy to decouple,
structs are not pain to manage in early boot code, and that
type off stuff, which you really need to just fight through.

Overall, there's work but not really "unknown unknowns". I'm happy
to review this but have limited capacity to push through the bushes
as I have my hands full of keyrings right now.


> Consider that you have to do a lot of command interpretation to know
> whether a user is getting or extending a PCR value, or whether it's
> systemd doing an NVPCR thingamajig.
> I don't think you can intercept commands and translate to intent for
> any kind of extension to be correctly tracked by your MR journalling
> addition here.
> Can you explain a little more what your intent is?

I'm a bit lost of the context here but I have a tool, which I think is
the most accurate TPM2 protocol presentation there really is but it is in
Rust:

https://crates.io/crates/tpm2-protocol

It has zero-copy data types for TPM2, it can interpret and present
both commands and response at the scale of the whole TCG spec, has
zero dependencies, does not allocate memory i.e. can point directly
into wire and is from the get go to be importable to an enclave
entry point, OS kernels and pre-boot firmware.

It is designed to be importable and test harness compiles only with
rustc to demonstrate this.

I don't know how much it is used but at least Valve is doing
something with it.

Br, Jarkko


