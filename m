Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E95F31E834;
	Sat, 17 Oct 2026 21:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792271665; cv=none; b=p9AfgzQA2XbE38Vk1cyqudNew9pflTzt6d3ayoBpYPcg2evqclF+1S3ukG0eWmC8gDxZKWUoTyuZsV14T7OgzfVNIxFp9YntZeMqZ7TnMUuyHANJVhCid5sYojo2kkq3p+C9NvaQ/Cnw5EBieDuY7s37Qz0Ymsa3i4Kg/qpstkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792271665; c=relaxed/simple;
	bh=uwQYxTDhT24TVmXMpGbl8/96piiC56dPsU977K30FL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UqYfZPsBk2314cEuxZ0M4DPJz0wUjppH5pYmX4gNLnG18lL44s244h602Il/uCmJPN7Ct0ZZatcfJDPhSUJ4bHn0gkvDlAdMC/76U/qFQ0O+PsokvNvOEPzjeeirKDk3Ym/vDKRYXXT43ClAJkn7XVu6w3McdRvR0qI18Ck6ytc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MvbzIyL0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MvbzIyL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B82E1F000C4;
	Sat, 17 Oct 2026 21:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792271663;
	bh=FKO4CvfP/4EzoFbPAE+XxKnikN9D8rSYpkJhdJvI2YY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MvbzIyL0+uVY1WLiysuCtcLfA7PbeMDJpKuvDJe215wvkhLzeUV1GMQmQqgs1zvRu
	 XZGJ97HAv7I5lhtf9N7+ly81oScPwT85cZ1RVqcf1RmqETY7Z63C87hD/+H1sf4SS+
	 10TGoybaPW9G/6/ODl73rFLo9IwJa77No3hZ9stqenEnyRNqJx7b6thQu+UphD5jqG
	 57LfY1kqT2f6UQ5IQ0rR52PYJPDQ9wVGss7xlVaN+oUrXWkX1dNmjExBWsO+yPEqJ1
	 3WacyFkzF5oeq43mEuLsz0jclKaDKuQjFAnglzjM+aNlt4E60uFgnfLNNrwnePSRWD
	 dz4W+vAVVEgVg==
Date: Sun, 18 Oct 2026 00:14:20 +0300
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
Message-ID: <atPlLOrAr0XcLlRW@kernel.org>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <atPHHNVJ2w0bkJIC@kernel.org>
 <20261017205557.GN13920@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017205557.GN13920@nvidia.com>

On Sat, Oct 17, 2026 at 05:55:57PM -0300, Jason Gunthorpe wrote:
> On Sat, Oct 17, 2026 at 10:06:04PM +0300, Jarkko Sakkinen wrote:
> > On Sat, Oct 17, 2026 at 11:16:07AM -0700, Dionna Glaze wrote:
> > > +Jarkko
> > > The TPM driver is pretty entrenched and heavily used by different user
> > > space applications, so it seems really ambitious to bundle in TPM
> > > here.
> > 
> > This is something on the table thanks to Trenchboot and its early boot
> > code.
> 
> I've proposed that there be no early TPM in the Linux DRTM
> implementation. The trampoline would just do a bit of additional work
> with its existing TPM code before it reaches Linux.
> 
> https://lore.kernel.org/all/20261016165135.GA494690@nvidia.com/

Maybe really would want to see a PoC of this.

> 
> My intention with attestation subsystem: tpm and DRTM is to follow the
> ARM design and get ACPI up enough to reach a HW driver. Attestation
> subsystem will multiplex the DRTM "PCR" logging to which ever ROT that
> DRTM launch selected. This is another reason why I dont like early TPM
> because it turns from just early TPM, already hard, into
> early-every-ROT which is much worse.

Earlyboot code could be done with just C by having TCG compatible
device parts in a "TIS lib" and "CRB lib" but yeah, this will
inevitably hit into having to upscale hardware over TCG MMIO.

So yeah, I think I get the negatives. This is what bothers me
a bit also in Trenchboot patch set. Arbitrary context dependent
hardware support for TPM does sound a bit risky...

> 
> I view all the stuff you are listing to make tpm early work as too
> difficult compared to just having the trampoline do it since it
> already must have a TPM extend operation inside it.

OK, thanks for sharing this, and I'm not arguing against this.

> 
> Jason

Br, Jarkko
