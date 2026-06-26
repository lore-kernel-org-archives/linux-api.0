Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A213D3DB335;
	Fri, 26 Jun 2026 10:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782471336; cv=none; b=aZQRkSc3fzz+TKrwiw05CGZJssXm6pZ3c5di5N9hk7uzswB5z+yqOO9X6LVNdgDCMNme3Yn3DGx8X6MzL65HkWgWdYHUHD1FWIzfnN1iLrzlWUcWWOLz/Q8BGqWNBvfXWXYAYeku3kD/nUTJgrz/2Eb8/ZHSFO1E5yJ+WCDBtD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782471336; c=relaxed/simple;
	bh=Pg/QvNc4j9H1BLdDz0GXIMcYO67sejm2IIXsUQKsPeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgUEKvXg8H5J0m0EGZ0Uk7wIk/FLWpZQYbRVuY1hCTr++sqMRiVAuCyLwgr/LESQN20lhrrUlYHSP5g3i6P1J5u+hVifY5pFGZ1OKZoduOSeakudLEEGLZIx4q5Wg0Ag6fui/3S0A6CR5Hzb5C+wSbwsBnxNGIvQ0lSPjzyVy+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=II5ulM2a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="II5ulM2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1821D1F000E9;
	Fri, 26 Jun 2026 10:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782471335;
	bh=5qUqUO94Lsgk2pmwn16HNoraThlX5eu1F9Lne1J2lFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=II5ulM2a0TAGT9OX04JqPHP4XO48Ektj6r2dCjZv8MAUUZMc0a/LYpXopUqQ1xchp
	 LyIacXJ34B1honivxeNuPdIa4bGfe7QGwL6dkGIhXYoemvD25osUhNDQVeKcofwonY
	 uDGlaM3auu9JbZq8dW3DIzcnTj1Dcr8CAZqAM/UBjsMKwsN3kSItjSYluLnr/PvQGg
	 80CSIMuXKueVn82P7ukoZvKcOOl0gVBedjkG5oOZlrQ+TvBmTXiauVh3RGOwu7pUVm
	 xAKOvi4qGM+ZxP/c+1LhWavarNIuQblX7Dv/UQEoWd+jvPXw7B0bkBaP7bchElroSZ
	 buv52ZOhHOfwA==
Date: Fri, 26 Jun 2026 12:55:31 +0200
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
	linux-riscv@lists.infradead.org, Shuah Khan <skhan@linuxfoundation.org>, sipsupport@rambus.com, 
	Thi Nguyen <thin@rambus.com>
Subject: Re: [PATCH 01/19] dt-bindings: crypto: add Rambus CryptoManager Hub
Message-ID: <20260626-radiant-affable-raccoon-f48b9a@quoll>
References: <20260625173328.1140487-1-skrishnamoorthy@rambus.com>
 <20260625173328.1140487-2-skrishnamoorthy@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260625173328.1140487-2-skrishnamoorthy@rambus.com>

On Thu, Jun 25, 2026 at 10:33:09AM -0700, Saravanakrishnan Krishnamoorthy wrote:
> From: Alex Ousherovitch <aousherovitch@rambus.com>
> 
> Add device tree binding schema for the CRI CryptoManager Hub (CMH)
> hardware crypto accelerator.  The binding covers the parent SoC-level
> node with register region, interrupt, DMA properties, and per-core
> child nodes identified by compatible string and unit address.

...

> 
> ** This message and any attachments are for the sole use of the intended recipient(s). It may contain information that is confidential and privileged. If you are not the intended recipient of this message, you are prohibited from printing, copying, forwarding or saving it. Please delete the message and attachments and notify the sender immediately. **

OK, we are done. I am removing your posting from Patchwork.

Best regards,
Krzysztof

