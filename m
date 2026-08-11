Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215AF3264EA;
	Tue, 11 Aug 2026 08:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786437241; cv=none; b=F8qqvDGrgwG7BF6FT3Yh//8Ili20eG90v28J3wyCkqJiiURqfRf82FV1u0sAvQgvdu44qU+eVK+C+HG2Dehcc0BX+aKlC+BEhvWNSPbLGyp80seeEYO86T2RBRNdnFEmZgoAoyRPoPd832NH08U/jeQmDy9SJ+INWrLkYuAsKQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786437241; c=relaxed/simple;
	bh=AGA4efeEDyGDxVbHwZcWK7SBfUvZrXt781JOoYtG8NI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FV/g1BPqwTQjUvrHqUnnwWYQGJLgOL5eQaJv8FgwmQAbinSbgqzq2xo+gn9fxD7k1RCayaaWv+mN5up0Xg3KKlfZ8wfhhXU3TxisWz8p0SxEeOMeTqSQrDtVy3jbLYs9HAb7hLYzYCXV2Ny6U5bPaDHCkia8JdqYjRetUtHHmNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebFJcjIb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebFJcjIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61F41F000E9;
	Tue, 11 Aug 2026 08:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786437239;
	bh=lrDqlEwSMhcC4vXVXzfkcEzvcaD78VvoCFKvgZhCaEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ebFJcjIbwbQxRzIlNCTZvrO3L9nPoxtPiS3N1n9jF1x29aWnv9VykxjQG33XxLHAM
	 1vY5/FBM0MR5r53YYNKpqnQReZbi1FDD0Offnb3ADgm0jVH1Ykp3x1fATlCl9bzM5a
	 Hzb1AdJDdHC3ivKZl0uId+tXyYnh7lcvD2HHpNs2jNniQifD1NDfICsb54Pj2Lw6mj
	 COVX93oZwlhzbqy9I/jSsDm44+JHxFKsx82YjvPo0oA6vx3gZvj/YHJTHpTFGzHvS6
	 LDNVoG5+WQsGpVjSlbNLYncR1LraAT6jsUrSOsaPp9o1sgzum0XOKXOVX6PPW7nuFJ
	 dz1cxah/rNmzQ==
Date: Tue, 11 Aug 2026 10:33:56 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
	Alex Ousherovitch <aousherovitch@rambus.com>, Conor Dooley <conor+dt@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Jonathan Corbet <corbet@lwn.net>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Rob Herring <robh@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, devicetree@vger.kernel.org, 
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>, linux-api@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Shuah Khan <skhan@linuxfoundation.org>, 
	Thi Nguyen <thin@rambus.com>
Subject: Re: [PATCH v3 03/19] crypto: cmh - add key provisioning and
 management
Message-ID: <20260811-belligerent-analytic-sheep-3fce16@quoll>
References: <20260806195519.2703224-1-skrishnamoorthy@rambus.com>
 <20260806195519.2703224-4-skrishnamoorthy@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260806195519.2703224-4-skrishnamoorthy@rambus.com>

On Thu, Aug 06, 2026 at 12:55:02PM -0700, Saravanakrishnan Krishnamoorthy wrote:
> From: Alex Ousherovitch <aousherovitch@rambus.com>
> 
> Add the CMH key management subsystem:
> 
> - Key provisioning: create, import, derive, and destroy hardware keys
>   stored in the CMH datastore
> - System object management: allocate and free CMH system objects
> - Management ioctl interface (/dev/cmh_mgmt): ioctl commands
>   covering key lifecycle, KIC key derivation, PKE operations (RSA,
>   ECDSA, ECDH, EdDSA), PQC operations (ML-KEM, ML-DSA, SLH-DSA),
>   SM2, EAC, and DRBG reseeding
> - SM2 ioctl handlers: SM2 encrypt, decrypt, sign, and key exchange
>   -- operations that require multi-step protocol flows not
>   expressible through the standard crypto API sig interface
> - UAPI header: cmh_mgmt_ioctl.h (ioctl definitions and structures)

And we need custom IOCTL interface because existing kernel interfaces are ... ?

Say something useful in commit msg, e.g. WHY you are doing this, not
what you are doing.

Best regards,
Krzysztof

