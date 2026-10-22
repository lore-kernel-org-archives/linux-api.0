Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792698012;
	b=MZDZUJpiOwyxnYneP3wZyYNP/2dxwFYawflClkVof4hQsOsp8X5LyHiTkmDxRDSlNbWY
	 MzxwHyJ9GVOdJ4kwLsVumbTouop1FUvRzYOsSJM5bLVhriqTrpD19xF4Q/JU9Q5IF2nMm
	 F08MAQN5WtpDJk2BLI4MV9g/ve1GVR33nAbsi36lUbI9jQsPbBIP2wPrGTA0UaoyijN3k
	 X8rDTzgMPS+4w7sgWXEsCOJS7KaP6t4tcMgEiXsln73xALYqbbdyYavSGernOHkxNC7MF
	 mBYaZImAzckFz2kP+k6FYTp5PJawF8oxpvPUMbstH4SrlFNPaqru4DNBUM+k7c4eUjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792698012;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=q5JTgohXUR8Op6NlSpjnxP0zgVyww3zZN/iYh+n3im0=;
	b=2lHL6VzxLe4IqeNkn0Nr0K8v0+0scoz2mgKNzDlhNmIornsx7Pf1uZ7hvwf7AL5QlAo5
	 DAEBnr9hH/AKXREX5jo7/ldCgSBhMY2cxx2KJjaLgLqftrQhdvOAhXEHlyfg5uU5X0S2T
	 kdXlHu/eE8H3dx6dHzUlKJ3tIOqI9wfCR+rfrRgATjBuP06ZzAY9D1cAu+pFWhuYGo1Mp
	 A6TNHY4TpevuTEN3dkxs9KaqEF+Cv/xDhAjevX6LH6xKM1acyhC/ktWeHbidc4CccpBCC
	 Dwk45ACmCW1RTKnYAUOeY6sEBZ+4aZ53/wfJ7F50b8/nFJs6/pYhr/v2mA2GWP7HTcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HfnsLZh2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9FAEB606A31B;
	Thu, 22 Oct 2026 19:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HfnsLZh2
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E04F11F01828;
	Thu, 22 Oct 2026 19:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792698012;
	bh=q5JTgohXUR8Op6NlSpjnxP0zgVyww3zZN/iYh+n3im0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HfnsLZh2mR0+/B55NAr+FDqKkXP3gp8VdcfFaDuzdDFhGd8HslFepY4FSDOsg5TC8
	 9TGoS10sS4qDN+u+S/yBZkD5toajxWzyof1x0YkJrraLJAU+0im1NSsgvIYJnO2E+Z
	 sMEK6bo4G1yrEyVCLvyGS9miMNKhqjILvQ7ireFl/idxEl1/IR2UvadcGz2QO+jkFi
	 lvMDcdI9iQdWnq6DhrFuw2sZ5mFtoa+4uNOko8j1DJvWEVs1++UeNSPwDqgh0l8ee5
	 hjOS0mztl6thTUKCfs/mG5f+JVhBkRDcY1YFpq4QBUBfF6mXTv/tiCDiTb5QJQ+6ni
	 JpyUKDRu0j7pA==
Date: Thu, 22 Oct 2026 22:40:08 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Jiri Pirko <jiri@resnulli.us>,
	Dionna Glaze <drdeeglaze@gmail.com>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	david.quigley@intel.com, lukas@wunner.de, ksinyuk@kernel.org,
	rodrigo.vivi@intel.com, cedric.xing@intel.com, sameo@meta.com,
	James.Bottomley@hansenpartnership.com, aik@amd.com,
	jpiotrowski@nvidia.com, qinkun@google.com, pgonda@google.com,
	jic23@kernel.org, alistair.francis@wdc.com, ankita@nvidia.com,
	suzuki.poulose@arm.com, kas@kernel.org, rick.p.edgecombe@intel.com,
	elena.reshetova@intel.com, dave.hansen@linux.intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, peter.fang@intel.com,
	roberto.sassu@huawei.com
Subject: Re: [PATCH RFC 00/20] attestation: Add a common subsystem and TDX
 support
Message-ID: <atpmmFnAVtOYLlOY@kernel.org>
References: <20261019225658.GS13920@nvidia.com>
 <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
 <20261021143529.GP3008132@nvidia.com>
 <8d8833fac61558a94af415143530884349584a2f.camel@linux.ibm.com>
 <atnqmDhgaJycTf_Q@FV6GYCPJ69>
 <2342b42699292d4e5fc85e5dd4d351a3f29ae336.camel@linux.ibm.com>
 <20261022185133.GA3746973@nvidia.com>
 <atphzdVThE9L5Kmv@kernel.org>
 <20261022192322.GD3746973@nvidia.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261022192322.GD3746973@nvidia.com>

On Thu, Oct 22, 2026 at 04:23:22PM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 22, 2026 at 10:19:41PM +0300, Jarkko Sakkinen wrote:
> > On Thu, Oct 22, 2026 at 03:51:33PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Oct 22, 2026 at 07:24:57AM -0400, Mimi Zohar wrote:
> > > > > Isn't the hypervisor what we are doing now? I mean multiple extension
> > > > > originators share the same register and eventually the same log. Or do
> > > > > you suggest to go even further having a "generic_registerX" exposed for
> > > > > every hw implementation allowing the user to have full abstraction?
> > > > > The "generic_registerX" would be always alias to something hw specific,
> > > > > like RTMR2 for example of TDX.
> > > > 
> > > > I definitely prefer the latter, as everything continues to work as is with
> > > > minimal, if any, change.
> > > > 
> > > > AI's wording:
> > > > • The Virtual Mapping: The [attestation] subsystem exposes "Virtual RTMRs"
> > > > (vRTMRs) internally to the kernel.
> > > > 
> > > > • IMA's Dedicated Lane: The kernel config routes IMA to vRTMR_IMA.
> > > 
> > > I was thinking something similar too
> > > 
> > > I called this "PCR policy" in my previous posting, but in-kernel I
> > > would expect something like IMA to request the "IMA PCR" from the
> > > current attestation policy.
> > > 
> > > This could be a locality 0 TPM PCR, a locality 2 PCR for a DRTM
> > > launch, a TDX RTMR, etc. It keeps the layout in one place, and lets
> > > the multiplexor steer it to different hardware.
> > 
> > 5 Authenticated hibernate [1]
> > 
> > This is on the table at least.
> 
> Yeah, any in-kernel use of PCRs has to fit into the overall system
> policy. Like maybe you don't want to use PCR 5 if you have DRTM, or
> you want to do hibernation using an alternative ROT from TPM..

Just mentioning it for completeness but it is, of course, not a
committed reservation as the patch set is still only an RFC.

I'm looking forward to test the feature as soon as I have the
bandwidth to setup a proper environment for it.

> 
> Jason

Br, Jarkko
