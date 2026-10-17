Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1F63E44F8;
	Sat, 17 Oct 2026 19:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792264979; cv=none; b=HREC0zabqacdaZEAjMvJdEWwZepY494rZ9UbxFZUPd6xlXiko7faix/+91y7NEDXh+bFy1/WcYD1T7DEt5DdzOTWfVmYD74aSOvQXiPl8y66ig/0ybm2huTB6COtqRlaexOfjm9EJSXOu5M3qAumdbxEZLUNNT+yEiXvYDNf1XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792264979; c=relaxed/simple;
	bh=iUQY4+7HSoLaBb60jFM/tTO/LHqOP7tcbkc2ajWfxvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dtLjQDqjVTNy6NjCX+kjZMVtT6++XSSLh9XvU9gJOH5fySw6gjwbbA1W8Kk6AaBjfba7f31H9WJnu5WpTjPssE95LMXeLQSWMH2Iu1lBhrueGFBklmBOdgcrnk3AJyPQbWlDZ+RGXBkVa6tmLujWafZG7KIIRTejSSRtRCQZSfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZM+ADv4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZM+ADv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7C31F000C4;
	Sat, 17 Oct 2026 19:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792264977;
	bh=OONfiEuJZp2QNI0FjSs0RzhjRXwPO3yVnFTCpoHyjFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AZM+ADv477n/ZHphD6yHLuvZ0s3S9MKN18c1z2xXM3hNxvq0IYVcf/Hu3frVT1qos
	 6vc4Sz3L03yI1XFGS/Hk6V9vlOe3z3Y1KUxa+Uv/lH0UaeQRZ3jHYW0CKzsgyqmuWG
	 pTfdrr6KmxaIApEVTDTER2w4WpWmG29uGY/Vvr4cvoTJ4DmvcgCwcdGJ55YvydgvA2
	 dl8t/d5oBYmUAoRG7qq4NNfV1/DSMN44EVbJ43CtDUN+8r9jSNs61a2AextuGvJn6K
	 THL55h1UXzBB1gEBOksuCXDvkWMfCX8uE0/IKOCd+bJOTYbZcvdfF8vtUhfLpdNkhU
	 2megWx820XP7g==
Date: Sat, 17 Oct 2026 22:22:53 +0300
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
Message-ID: <atPLDSEN7wodAf-f@kernel.org>
References: <20261015145053.3664509-1-jiri@resnulli.us>
 <20261016234354.GA664420@nvidia.com>
 <CANwfdvXFLJpC4Bc1PwRoUUP20fu2K8b+FHZ1JLLFXAikC-cBaw@mail.gmail.com>
 <atPHHNVJ2w0bkJIC@kernel.org>
 <atPHqYfR4i731Nfw@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atPHqYfR4i731Nfw@kernel.org>

On Sat, Oct 17, 2026 at 10:08:29PM +0300, Jarkko Sakkinen wrote:
> On Sat, Oct 17, 2026 at 10:06:08PM +0300, Jarkko Sakkinen wrote:
> > It has zero-copy data types for TPM2, it can interpret and present
> > both commands and response at the scale of the whole TCG spec, has
> > zero dependencies, does not allocate memory i.e. can point directly
> > into wire and is from the get go to be importable to an enclave
> > entry point, OS kernels and pre-boot firmware.
> 
> Enclave entry point would make sense if you wanted to do a vTPM.
> I.e. it is also fully symmetric when it comes to the end point.

Actually if we imagine tpm2-protocol as an alternative that would revert
at large portion of the work required otherwise. tpm2-protocol crate
gives you already capability to do whatever TPM commands.

The other part is really then just "early tis" and "early crb" drivers.

I'm not favoring Rust here or suggesting that but it is good to bring
also this angle.

How I would approach "full Rust" alternative would be to write clean TCG
only TIS and CRB drivers in Rust despite redundancy with the C code.
They have their role and at least would "light my fire" more than
fighting in the bushes with the legacy code, doesn't it?

Sorry for the extra response. Just flushing out the alts.

Br, Jarkko
