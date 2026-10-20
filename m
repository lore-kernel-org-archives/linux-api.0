Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792539570;
	b=1n5PGTy/OW0MlWPolc93PR9QuGb9rF5DJ88OpngXOCty0CYLf07KxFNa0GS6xXwkWErg
	 zY8Q4dGTUbEE9PudOD0fmo5CNkCLiK+cZnuRpfT1p5Rsf85Kf7+TAaZXgfGmdHFL4ZrIR
	 XOwQMLMS0vx7qv9LuCjDJMMBEi4846cXq4onC3oWSbDoWPenOWi1FAHx2GE7ySaXwH8aP
	 bHfxaDYmjU9FOPWtkoMjKUQE8VJrSVNd8Bp/aVbYpS9i3sqyuBHMi3kbWJrs2CovApe1r
	 r1Ociroc0xujeQkxE+FrlpPyNeZ390ICSvZn+1kKDNzjsY8HUM7vJ0TXre+5wsNFySA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792539570;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=MvPKh2LFCRo5HFkIjF2qDl5qC/wMMf/toViD9nxJYC0=;
	b=C4cLb/Frx/qBOKkL+xJH6G3nDa9knripWNJLJLUzYTh3o4Q1sHoZiBH156xr2Fau7UXC
	 oYg6SIo2PtWEPI4E0SDscXq33TEYBDmw+uRJFpsuAuUfZOgOQg7Hm1hVSnAgzglA/IVaZ
	 Ahcir2W7rn3cdqEPlQN2rx3ZAhJz+pj5jwKY09eBkUr9sfm2c2pc6pww8h6E2BBW0q//F
	 ebagaHCmqyenIsV3RDG3J3dQ0fQysFspn4oroQsDCVteybA+4fEQs9m1TYJaZu0S/0uvi
	 H21iHS61RYLx04h1S4ele6QDlqa2thvbOTrAomxoCLfQmLGzQngp4+WPkTzbkUyORXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Nau/Q4LF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F157606A319;
	Tue, 20 Oct 2026 23:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nau/Q4LF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB4D1F000C9;
	Tue, 20 Oct 2026 23:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792539569;
	bh=MvPKh2LFCRo5HFkIjF2qDl5qC/wMMf/toViD9nxJYC0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Nau/Q4LFrwosrfYQpQ+p0FIoHHf1KpsvhH26jv59Sn/U/x/EA5+nAoav6rAnDS8BA
	 RiQ7lhIBhhs3+50lQVutaVM03jVaq49QF40fqbIEi469uvbG7+bLvN8SIYiuXCcpEi
	 0VFQT2ZURPZ0qdzAiuI+XZgiq/ssnsDdedIpx69+lH80Zc1uUiYJi5kF0nf4U+DknV
	 rAzgqxrM7nX6/e2/uhHpLguBPh0Rhfz3mcETzqagf5fWjcdrKuTEoqdqsRFPMV5F8g
	 Adv70qRaGSD+Rg0PVPUVibeacB0h37KeuWZsdvcZjPWtSPiI2cXz2/q9l04IWfphOz
	 plFGSCwHK5vXg==
Date: Wed, 21 Oct 2026 00:39:18 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-api@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, jgg@ziepe.ca, david.quigley@intel.com,
 lukas@wunner.de, ksinyuk@kernel.org, rodrigo.vivi@intel.com,
 cedric.xing@intel.com, sameo@meta.com, drdeeglaze@gmail.com,
 James.Bottomley@HansenPartnership.com, aik@amd.com, jpiotrowski@nvidia.com,
 qinkun@google.com, pgonda@google.com, alistair.francis@wdc.com,
 ankita@nvidia.com, suzuki.poulose@arm.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, elena.reshetova@intel.com,
 dave.hansen@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 peter.fang@intel.com
Subject: Re: [PATCH RFC 02/20] ctlv: Add the UAPI wire format and family API
Message-ID: <20261021003918.36151a58@jic23-hlaptop>
In-Reply-To: <20261021000003.71f78d99@jic23-hlaptop>
References: <20261015145053.3664509-1-jiri@resnulli.us>
	<20261015145053.3664509-3-jiri@resnulli.us>
	<20261021000003.71f78d99@jic23-hlaptop>
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


> > +/**
> > + * struct ctlv_attr - Attr header.
> > + * @len: this header plus its payload, excluding this attr's trailing padding
> > + * @flags: CTLV_ATTR_F_* bits
> > + * @attr_id: complete attr ID, or CTLV_ATTR_ROOT for a message root
> > + *
> > + * Attrs are aligned to CTLV_ALIGNTO, which is why @attr_id is __aligned_u64: a
> > + * 32-bit ABI would otherwise align this structure to four bytes. A nested
> > + * payload is the concatenation of CTLV_ALIGN(child.len) bytes per child, so
> > + * child padding counts inside the containing attr's @len while a leaf's own  
> 
> Whilst I get what you mean, leaf doesn't feel like a clear concept in this
> comment block.  Maybe 'this attrs own padding does not.' or something like that?
Ignore this one - lack of coffee...  Leaf is indeed clearly defined as most nested
child.

> 
> > + * padding does not. Scalar payloads are native-endian. Within each request
> > + * root or nest, occurrences of one @attr_id are contiguous; different IDs
> > + * otherwise have no required order.
> > + */
> > +struct ctlv_attr {
> > +	__u32 len;
> > +	__u32 flags;
> > +	__aligned_u64 attr_id;
> > +};
