Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C24236B054;
	Wed, 23 Sep 2026 05:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142479; cv=none; b=HSP59hzpRoJ2Z4iKn0hjRtzuAZmRczHMfb3pEKbHj1kG8xNnpVVTg5zpH5xyCXGpqv7Dx800MeMw0hXuuC0jAzgK45egoV4shtjSWZ8u11arJwYglzbzNsNRqJlbUx/2wbMjymj0yfC0DGdcsxzPMmUTm0ElV67ywdI9ZzAdsh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142479; c=relaxed/simple;
	bh=TNIUVnMy2x3vQX/5pT7Dhx0BP310NZcgzcsOZKT9mkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y7SQPkOxSNcdWrmh2amUXU0iJy6J/hc52+frRE58kEZbTQXsp9r7v8VbFSq0Ax9tYNuw4I8Afgbu7cfBnkF7wSGxbaa/OSLhwRlXiEskZSE83zt7xqs0ioatWL4VOBq/c9FlNYaz4RSspCLQ6k8kor/Ztm66fbs9KjhRgO0hfJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=fQjpyr+B; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="fQjpyr+B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=vjVcIyF3kkMlZyzd56bm3scXTaq3Opyr7xmaB4B2Hds=; 
	b=fQjpyr+BmwmCnb2wn8FgspFTB/fV2AOUx20SW/K0WXbOBgwzSIj6itpncVmckPhInMgMVrr7M2Y
	idhFzE1gbqvR4s0K1kfiHjNxejXYmpWDMTDjp2guUwP0AswDMavepSRkC0kKniYvmFiHbfqQYXjYZ
	zysKaGXEUQeDeEcqMZLbV+XDYX759yDIymCal4GriDKMmbSNGKTVbA5UPkmw0SbHRNKnOjtdoSSQn
	WYU6T/U0IRE7+l2AttIExnjPqqcXbBh0gTcqg4a1xnbj/eq1kQSBxy0QW6x24hezQRi7P9z/fRoZA
	GqxrBxZ2vh7BTJHu51gD5fDTHNg5Alc/omkA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9FpV-0000000Gupv-0dgl;
	Wed, 23 Sep 2026 13:47:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 15:47:41 +1000
Date: Wed, 23 Sep 2026 15:47:41 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alex Ousherovitch <aousherovitch@rambus.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>,
	Shuah Khan <shuah@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
	devicetree@vger.kernel.org,
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
	linux-api@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thi Nguyen <thin@rambus.com>
Subject: Re: [PATCH v5 04/19] crypto: cmh - add SHA-2/SHA-3/SHAKE ahash
Message-ID: <arNn_fjy4jamSitO@gondor.apana.org.au>
References: <20260917225929.2494111-1-aousherovitch@rambus.com>
 <20260917225929.2494111-5-aousherovitch@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917225929.2494111-5-aousherovitch@rambus.com>

On Thu, Sep 17, 2026 at 03:59:13PM -0700, Alex Ousherovitch wrote:
>
> +		alg->halg.base.cra_flags       = CRYPTO_ALG_KERN_DRIVER_ONLY |
> +						 CRYPTO_ALG_NO_FALLBACK |
> +						 CRYPTO_ALG_ASYNC |
> +						 CRYPTO_AHASH_ALG_BLOCK_ONLY;

Why did you set the NO_FALLBACK flag? This is only meant to be used
by very specific cases such as s390.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
