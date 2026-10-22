Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792696786;
	b=KJtZ7jGPKTXhfd6qx/9V+Oga/eWtbOLk7cAABX5dwoHvLzt+lcvO3t0/T32hBMI7Xv2p
	 e3pSdH7pEXfxqGSHOSQqvfw6VEv+PENiHoTpgO+J7hTPM1/8fXjlAh0JbSmqyJmVHnkqh
	 MDzDLMW4Rt5H6zri/wA9kDHM5Gfkia3A4pQfAd9njP8MG5D6l/sD/CncPOuFcjSUaK5JM
	 BLNYsdNKO6k9cmKgQYHK9tDohbNfQdhndt5VywCbLiSQobChAz4+gMfsPYh+2iRj9dOsA
	 se7+enN2mIvXnQrJ/DaetWSYBXL4Nr9BVhfWP3w3Rb5+qw9ghAEihQxqGwoAql9Lzsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792696786;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=1CQ2OmKH7HAXrNK05fYyWAw1wAeHi9lDw5w5mb4p0FE=;
	b=fKxvpDctQBLb8F4AjJKdlGmMPyAAmwZOmk67PdRCuGTPWw3eX1pcCp9pRvd2cP93oiL8
	 d2hed5e9RvE6SwmCD8+JhN2tImwMCNIxjCqrYuBRfoja2aRsXFV9ANBJcuvEc5FHGETco
	 BwmqIibuCl1ceWZBiaH7lqRkMJzfYBmgEhztjIjbJIkZMrtPMaMGPuRdD4GNf0hywOFbf
	 4/PdBZy8DbzS4neKzniLhyXyyRe+1CBS2YBPaKOl28+7zPLX8rZ3NP8Wwjp8omYTsfa1H
	 pg0ryj3uAor/PZ7Me4ULqFpB/cuT8P9k2MF3cZ50GWQBi0cnnJMaeNSZhCmIQGROKxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jShNqmPC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E223D606A319;
	Thu, 22 Oct 2026 19:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jShNqmPC
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ECC621F01825;
	Thu, 22 Oct 2026 19:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792696785;
	bh=1CQ2OmKH7HAXrNK05fYyWAw1wAeHi9lDw5w5mb4p0FE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jShNqmPC1RaI9+uiZe+w1cik/dTmuiJgFoD+G+MD361qg7FiyDa/gor393hVz5M9u
	 VXc9urCHWE8Fi/SCzn453ti9hRAUgh3k6ftQZWIi+4rwssb/BSzmAatVzE3ZmSt6SW
	 iZEB/bX4mS9uWLql+MOSCGkrTo5tg7gWXus8LihsnKNp3HHBQblGvebhV6AFyD1cLn
	 C2UiMWOOxKGTYPqOBwdBdK12tQeaQc93bujasAjwCJHxiTRvF7l347cps48OtwjLEm
	 DC3e99iLtbpLE/mR4ZNqwGahnOG/FE1CEZbpWTIn1katwS3YW0hWRhMm/1PBTLrMr9
	 gRdhgObvbpXEQ==
Date: Thu, 22 Oct 2026 22:19:41 +0300
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
Message-ID: <atphzdVThE9L5Kmv@kernel.org>
References: <atX9fugGUsI0hGcA@FV6GYCPJ69>
 <CANwfdvUhuQ6L+w+91iDZD=diMmaJ6_2ZsFKkcoiKWOmPMC1oKg@mail.gmail.com>
 <20261019225658.GS13920@nvidia.com>
 <ath4vwt7KGyDXKVJ@FV6GYCPJ69>
 <103486a4a29ecc7b72940dd051c00ae59266bd05.camel@linux.ibm.com>
 <20261021143529.GP3008132@nvidia.com>
 <8d8833fac61558a94af415143530884349584a2f.camel@linux.ibm.com>
 <atnqmDhgaJycTf_Q@FV6GYCPJ69>
 <2342b42699292d4e5fc85e5dd4d351a3f29ae336.camel@linux.ibm.com>
 <20261022185133.GA3746973@nvidia.com>
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
In-Reply-To: <20261022185133.GA3746973@nvidia.com>

On Thu, Oct 22, 2026 at 03:51:33PM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 22, 2026 at 07:24:57AM -0400, Mimi Zohar wrote:
> > > Isn't the hypervisor what we are doing now? I mean multiple extension
> > > originators share the same register and eventually the same log. Or do
> > > you suggest to go even further having a "generic_registerX" exposed for
> > > every hw implementation allowing the user to have full abstraction?
> > > The "generic_registerX" would be always alias to something hw specific,
> > > like RTMR2 for example of TDX.
> > 
> > I definitely prefer the latter, as everything continues to work as is with
> > minimal, if any, change.
> > 
> > AI's wording:
> > • The Virtual Mapping: The [attestation] subsystem exposes "Virtual RTMRs"
> > (vRTMRs) internally to the kernel.
> > 
> > • IMA's Dedicated Lane: The kernel config routes IMA to vRTMR_IMA.
> 
> I was thinking something similar too
> 
> I called this "PCR policy" in my previous posting, but in-kernel I
> would expect something like IMA to request the "IMA PCR" from the
> current attestation policy.
> 
> This could be a locality 0 TPM PCR, a locality 2 PCR for a DRTM
> launch, a TDX RTMR, etc. It keeps the layout in one place, and lets
> the multiplexor steer it to different hardware.

5 Authenticated hibernate [1]

This is on the table at least.

> 
> The policy would outline all the in-kernel users, and probably provide
> some how give a recommendation to userspace like 'systemd log goes
> here'
> 
> Jason

[1] https://lore.kernel.org/linux-integrity/20261008132532.1155166-1-matthewg@nvidia.com/

Br, Jarkko
