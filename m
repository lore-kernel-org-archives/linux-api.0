Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535BB41A55B;
	Tue, 11 Aug 2026 08:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786437147; cv=none; b=LZYJA4AsDBBrkI8UcSuUCAfoQG+GzZM6rQizedQ39o3Vv7H7WaKedwfa/Hf3LGI7pd2iGXWGXW5pAGdicZWuf8fjSt0rrB/RqLjVM1PYCX1k118zuaps72P3Q2Y+TKad3y/TQNLH+nwjtpYedNZNzSMZiTYR/gnuOOHGd25Rfs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786437147; c=relaxed/simple;
	bh=bQolbzRG0QxOGnEQDCa8/z0+30UvmnXM/fyDtH33PXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kl5ovdS8FOCZLDun/IxgcNbD/eb37jeNbks3XVnqy0a80/9vjnOMsRLy0UUQFFclvdnAdxd03z0tw6ueqHbxuObp4jJi4ItHtTN1UFwj24YBwB9Dq9ByOUcZp/tOHFXi2+kE+VM7HgbVe/9zzUjGgW6FB3w/PLqYTA4wVrTNIkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOg5/hkS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOg5/hkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5AD1F000E9;
	Tue, 11 Aug 2026 08:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786437144;
	bh=qEqfWRHWi14MDoi5GTB3EIB4jqDfZdRQHZn9kMInfcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dOg5/hkS0PDvkXVqYuo6lDv6X3wyOyisMZQa0Ogk8nlRAVQl+7eOh3KnH5/G/SHl9
	 3ebhvB921hZ8vxfSlBKuE4CFiI5t0kMdJRIxsCBc5hcZXBBqT1qtYzl4NivYUYMZxP
	 th04xBmSCgkyuWYRR81ZT0nZYsTujCJYWMyEqcu5BjmeBK7MPRTFqNZFz6PrksE65A
	 39sRZiTZG8h8yCd7dGbbEwSFFJbMVCg7HAOkNEEluE+Q2/RqKLq3dlnCz3g6GUzQYJ
	 LhyYHMc+bauFyyGCUYIbfP4PLQzy+GGPILyGH9BZrg7DJlRulTxe+Ha6bcphM2TlJM
	 9LKE7YwfY1OiA==
Date: Tue, 11 Aug 2026 10:32:21 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alex Ousherovitch <aousherovitch@rambus.com>, 
	Conor Dooley <conor+dt@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <pjw@kernel.org>, Rob Herring <robh@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, devicetree@vger.kernel.org, 
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>, linux-api@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Shuah Khan <skhan@linuxfoundation.org>, 
	Thi Nguyen <thin@rambus.com>
Subject: Re: [PATCH v3 01/19] dt-bindings: crypto: add Rambus CryptoManager
 Hub
Message-ID: <20260811-lyrical-aromatic-mouse-bbbd42@quoll>
References: <20260806195519.2703224-1-skrishnamoorthy@rambus.com>
 <20260806195519.2703224-2-skrishnamoorthy@rambus.com>
 <778fef91-0610-4ddc-9d64-e6b45b30127f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <778fef91-0610-4ddc-9d64-e6b45b30127f@kernel.org>

On Mon, Aug 10, 2026 at 10:16:26AM +0200, Krzysztof Kozlowski wrote:
> On 06/08/2026 21:55, Saravanakrishnan Krishnamoorthy wrote:
> > From: Alex Ousherovitch <aousherovitch@rambus.com>
> > 
> > Add device tree binding schema for the Rambus CryptoManager Hub (CMH)
> > hardware crypto accelerator.  The binding describes the parent
> > SoC-level node with its SIC register region and one mailbox@N child
> > node per mailbox the host owns, each carrying a reg (mailbox instance
> > index), an optional interrupt, VCQ ring geometry (rambus,slots-log2 /
> > rambus,strides-log2) and a rambus,cores affinity list.  Which crypto cores
> > are present is discovered from the SIC CORE_ENABLE register at probe,
> > not described in the device tree.
> > 
> > Register the 'rambus' vendor prefix for Rambus Inc.
> > 
> > Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
> > Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
> 
> Completely messed order of tags.
> 
> > Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
> 
> How Alex could sign after you?
> 
> > Reviewed-by: Joel Wittenauer <Joel.Wittenauer@cryptography.com>
> > Reviewed-by: Thi Nguyen <thin@rambus.com>
> 
> Your SoB is the last.
> 
> Are you sure these people reviewed THIS code instead of blanket-review
> for everything?
> 
> Did they find any issues in the schema which you fixed?
> 
> 
> > ---
> >  .../bindings/crypto/rambus,cmh.yaml           | 207 ++++++++++++++++++

Also filename should match compatible.

Best regards,
Krzysztof

