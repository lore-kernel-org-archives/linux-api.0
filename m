Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395E53939B1;
	Sat, 17 Oct 2026 19:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792264110; cv=none; b=AeKy9W20tcgVEgBSbsWzRoDl4TCz8XDyhkKqqJ6vJ4EXOhSXkilTecUFzXvCblaNpHTVsUPU8sULUVbg2nBeqtRKNl63mlCZRYCH4VFTqEiFHswM3JPUTC8tqbTH5C7/rFid+9kcZ/mOa/P7koKoBK1J78oZ6u83YNgT4cRzgN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792264110; c=relaxed/simple;
	bh=cko0LxyGoNoWA3Sia1nfNENkgSFWJiUV23tmjXF/d8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IaTfRpBeHozDcdsJvceqck2d7RH2jL+l/OH/V/X86LTbS1ljytexIJY9YdxuOMA+wSNlfBhc0xj6XCVCp6UIET6kVe9RMJYdn+rcOL2wiDZ0cSSbabAis71vhIgeC2kr3NAhhIrBQ7iA+RrC+K5OU3WjHa6VZePAyXoaBCgmFr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TaSk11uM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TaSk11uM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3466C1F000C4;
	Sat, 17 Oct 2026 19:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792264108;
	bh=cko0LxyGoNoWA3Sia1nfNENkgSFWJiUV23tmjXF/d8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TaSk11uMLCtEiiuw9dYfP9dVjuwaoykNjRQe/I3urVaQJb+9wPALxTE344RrD10yX
	 FY8dihwJ421Z8actkQ97BXBQJnKZJgmqMM1DEClRSqDm13T+iEXwdC9Sn8E0JIezs/
	 5jOG2l8hOSKsk0gR9+gp+6gURzeRr0FM0JefT33vsF2dXvsh5Yr+tMPQzaP/Ua8+40
	 UQrHN2yQS6ZzxSFPeu1JMQq6vZa0eTQWlQgBPYlf7y8u+aabGZ+V5grE/Uj6oeJUga
	 rp/ggZr1KSgAKCSAteSNgvT6huhgBJoFaSK2GY1WAac2qL9/1pNNTL+dALnUGXavAP
	 87RD+NLw6nNTg==
Date: Sat, 17 Oct 2026 22:08:25 +0300
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
Message-ID: <atPHqYfR4i731Nfw@kernel.org>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <atPHHNVJ2w0bkJIC@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atPHHNVJ2w0bkJIC@kernel.org>

On Sat, Oct 17, 2026 at 10:06:08PM +0300, Jarkko Sakkinen wrote:
> It has zero-copy data types for TPM2, it can interpret and present
> both commands and response at the scale of the whole TCG spec, has
> zero dependencies, does not allocate memory i.e. can point directly
> into wire and is from the get go to be importable to an enclave
> entry point, OS kernels and pre-boot firmware.

Enclave entry point would make sense if you wanted to do a vTPM.
I.e. it is also fully symmetric when it comes to the end point.

Br, Jarkko
