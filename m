Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792783390;
	b=z2wSu2OvWgKLaYJWF61cxpB3sHQYza5U3EXmKClccg3aYeEixIzF6QUnKifxaPLQvRT7
	 GHHnH6u2ha5fp/SbPg0jS8YsqMWQPESbpdubJhdl/WFFf/piDVuFT3ZGlfj99rsdJMoJH
	 SHhjHHiz+NZ3ExQ5eoeMn02LXH4ie8yj2kA1dVMb3THCcZRIq2FDEKkFUYR/17EhulqUC
	 2axDtbXhKdyJP1zSMHHWmmTvXV7FjbycRxfal0a9pfYrF4Obv+AXd9Dji8qL8riKLklTX
	 aHMAapEhHrNs7HVneLChHRO6IDBUR+XQOOWicFVAdpEsVsbg1bXkX26KGTAOvLuDpvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792783390;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Dd1SiQToxpbgH+zCRYMh63AZHeiiSvMwcrYKR3uwlwM=;
	b=WRYkKBU49MsPo9ygm+pBam2oeZOM0nYAIk8dTyPq9QyvKLunguhy9WKJXq82TlS28vDH
	 H+JrKGtv98Oc8+zSxJLqEBTxnJoVQwWnNDm7FUxSvYXm2Vl+OhEshEzYKqCJWkQ5lXvk5
	 r6ybslzUaaMDmD6DYVhqpaz8ECvTyE8kUNcAWNUb95+1pZM9GrMQ+6NL0TnEygOFinE1U
	 A3NiWWmyKuvxo1Yc1LQnryxYLINj8flqS4ejpXYQVxRv1DBNTHf+IoMOifBovdkEnrYGx
	 jMSsvlx5rc9GUohqvfoHs4HoY9t0xpJnROl22X1XsRVDdFHEb6kXXP5Nap+CV3msYNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o3MFnpI4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91D5606A31A;
	Fri, 23 Oct 2026 19:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o3MFnpI4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5DA1F01825;
	Fri, 23 Oct 2026 19:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792783389;
	bh=Dd1SiQToxpbgH+zCRYMh63AZHeiiSvMwcrYKR3uwlwM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=o3MFnpI43a/ChdWrEQZMYDEkWLk3bzVOSByK9b0wUXXSZYXK+Qbi5/vkqEw76H3jN
	 yZIfjdKVBqV/Gb0441p+NZsargr/VZwcUv5hxAu6Xe5oVbDm48qjx6VIB6JcthPR4Q
	 PjUiUrZJ4OesqnXHOKt4VfKaqbPl9XWebAz0GP2L2Rg8bdijs7oWUcs27W/19N93IA
	 Tibuc5kG/Me3sR1MS4BA1QKrkx/pTvYpZdKXBadSrARHDtFXQKe52/WPIyUW7FPyNw
	 GR7/tUs0OYLPodK1aVl0lBrBBeOiQwcugP/nYACuus0nn8MlQlaQfMPpjGv39UqSmm
	 s+9GZrHBcmU/w==
Date: Fri, 23 Oct 2026 20:23:07 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com,
 lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
 cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
 James.Bottomley@hansenpartnership.com, aik@amd.com, jpiotrowski@nvidia.com,
 qinkun@google.com, pgonda@google.com, alistair.francis@wdc.com,
 ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
 dave.hansen@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 peter.fang@intel.com
Subject: Re: [PATCH RFC 04/20] Documentation: ctlv: Add userspace ABI
Message-ID: <20261023202307.62694a50@jic23-hlaptop>
In-Reply-To: <atnJUfh0_Y3BRKx3@FV6GYCPJ69>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	<20261015145053.3664509-5-jiri@resnulli.us>
	<20261021011122.2cd96901@jic23-hlaptop>
	<atnJUfh0_Y3BRKx3@FV6GYCPJ69>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

> >>``reply_len`` is never
> >> +overwritten; the length written is the reply root's ``len``. The pointers are
> >> +fixed-width so a 32-bit and a 64-bit process pass the same structure, and in
> >> +place of a size field the ioctl number encodes the size and ``reserved``, which
> >> +must be zero, covers compatible growth.
> >> +
> >> +Every action and query carries a physical request root, including an empty
> >> +request. ``request_len`` is therefore at least one attr header and at most the
> >> +1 MiB transport limit.  
> >
> >Why this particular limit?  Any thought to making that discoverable rather
> >than fixed? (with a minimum to allow the operation for the length to be discovered).  
> 
> OPS_DUMP exposes max size per op already. This limit serves different
> purpose. It is a safeguard againt insane family yaml author. If he would
> try to fit in ridiculously long binary attr, it would provide a clue to
> use blob attr instead. I think that 1M is too big. I would perhaps go
> with 64k initially. As it is kernel internal limit, could be changed in
> any time. Makes sense?

Yes. Small is better as as starting point I think. 64K should be enough
for anyone, right?

> 
> 
> >
> >Maybe it is better to just have fixed size.  I wonder if ultimately we
> >may end up with cases where the tlv is just passed on to firmware / device
> >(because it is nice and convenient!) and having to split or marshall
> >multiple messages would be a pain.  
> 
> hmm. tlvs passed to device would work, you would just have to take care
> of the blobs inside.

You'll know you succeeded when someone decides the device should
do the work ;)  Of course that's also the day when design decisions
are stuck even more in stone than they are for kernel /userspace ABI.


Thanks,

Jonathan
