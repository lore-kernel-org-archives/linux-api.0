Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BD12F5A0E;
	Fri, 11 Sep 2026 04:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789101128; cv=none; b=j++8IlKfal9VpCh19YB0+wFw60sRzUlPwdDhZSM/oFue/TFVdB5sFTyQkXXtmL2qM/YZM0tNGKqEUQA5DiZbpua0hW6F7jNvqpbvatqSh/gxEnnbBfK3vyabLfZYyQuT97pssWV/wQxW0DUjGnv40wCzu8/fmcd9EvGqz6Qej28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789101128; c=relaxed/simple;
	bh=cEScVFGDdkbeR+3r7iH2a8OUoRNNEg4QrEzRNMPhI3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bJk4ECCR9GIIqVCFqFs1z2z0uOX9MnYxkXws42ZekQ+4HM/+EU3keiVnVHp7SED2q62Fi8QtIb5xlqGARETAgfYsJWFuDbeVUB5WO7ICBPg4J75EvaSPvDq5S2DOa/EpLvvQD3kVdwHmKWYc/+VOCRor4jCaF+9R9L79V0I2OkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=f4AKmI0S; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="f4AKmI0S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=YKpfvW0m7fMGPwroikXgrjlEkqn9S1O/EG9PiSNdpjs=; 
	b=f4AKmI0SRdE8F+kpVQXiub5fRB7v/nIJ2L3G5tkE0IFsgd3K5CaDIQI3l0p6UZbJ2mO3DjrYlbi
	mwMOSsi1YjJvikFFyKFw84u7aOz8+H3rMWlPaKAxz6HCbmXt6Ks7qZfJyo/9beOxaupITxz4wWd54
	j2YL0NVc9k8WR4GaxdmtC9sUVr/uqoFmjw63bokCWOsuCmOTimCzaqm6zyJFLcH1qWw9BprNSOn41
	XtLLUsVM8HzahjPISNGoNcffLAgI4iKEBcI61DQnEo3QcG9qnDnm5rG7I0BmJ7ej8pNVX5IXlAWyJ
	qIwseeWShWs2Q0+zzrLpuBeXusz+FN1H6SPQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4svP-0000000CtQw-0BeT;
	Fri, 11 Sep 2026 12:31:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 14:31:43 +1000
Date: Fri, 11 Sep 2026 14:31:43 +1000
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
Subject: Re: [PATCH v4 04/19] crypto: cmh - add SHA-2/SHA-3/SHAKE ahash
Message-ID: <aqOEL-YUVFuThcmf@gondor.apana.org.au>
References: <20260825221539.255951-1-aousherovitch@rambus.com>
 <20260825221539.255951-5-aousherovitch@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825221539.255951-5-aousherovitch@rambus.com>

On Tue, Aug 25, 2026 at 03:15:23PM -0700, Alex Ousherovitch wrote:
>
> +/*
> + * .update -- buffer incoming data, submit full blocks to HW.

Please drop block buffering in new drivers.  The Crypto API handles
this for you.  Take a look at the aspeed driver for an example.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
