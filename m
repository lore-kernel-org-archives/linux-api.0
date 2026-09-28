Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BF63016FB;
	Mon, 28 Sep 2026 05:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790572657; cv=none; b=ePaXocaoKqXaUQdt6/5LRSqxX0Jh14RSnrygEqvxhJ2h0Tuh8tQDrIueDdbFeWcqO0WaTsPgVSWXwFg2UG+aWERsS6nc4vDbC0/MkhwrHpvffn63RDxGeGLjArOQmAlMVbvfOCZV7pjlNKZxqCK2emecOI90RYQdJ+02pGc/d8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790572657; c=relaxed/simple;
	bh=lmIa/rLnB25wRisYAW7elKt98KJBLWkjxaC5fbBBn9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ssl6akuASIZD2Y2HLk0aXpdwpNr5IlVM4gq8XW1cPPXmZnoO5vKG9UtpnGq+RlJ8P66YUxrffvzZA1hNDhJ6Za37Brf6FkLRPPmDE1/g5xnBmCg9gvYS1NdJ5wsrARlOAy8ABoAhsncFtWhOlyK+dwzMxsLkzhuTcErMTAhta/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=dFMmu984; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="dFMmu984"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=g0urVNX8ATEeOHGXP86K6LmXYM7IrN5hrV8PI7/e+Bk=; 
	b=dFMmu984dAtawQ423gsVyUC4zFZWVprPabJ0C+rVE9whvBqO8AgEKSe30ieqccgf2TP+pXT6RjP
	3FflfBCIRHkUB8IQZcLcXAtwk9qyw+LX1BBBLuHrElqAvYHO7n/k+toyUP6oQNI+L4wqc0FsQGjUf
	cMuVr6oWRqa59fs3XU+Ij/DkBGDJAmvZ1d1aLTexcjlFMQOagnpklv4gJlxk4cjO4NPMzgqkGROaP
	TkOhCfnmm1iACvdIxUIXKjdLNw8niOmqwn+o5pIVGt/K/z9Evsh1x0N9mg/XJ/d7KiJ5ymii7XOYq
	3T5Xgm1QUu7ZS8oY0wlBTnrQG8Q5gVKVLtPw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xB3jp-00000000w9f-3e6c;
	Mon, 28 Sep 2026 13:17:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Sep 2026 15:17:17 +1000
Date: Mon, 28 Sep 2026 15:17:17 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Ousherovitch, Alex" <aousherovitch@rambus.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Rob Herring <robh@kernel.org>,
	"Krishnamoorthy, Saravanakrishnan" <skrishnamoorthy@rambus.com>,
	Shuah Khan <shuah@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"Wittenauer, Joel" <Joel.Wittenauer@cryptography.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Nguyen, Thi" <thin@rambus.com>
Subject: Re: [PATCH v5 04/19] crypto: cmh - add SHA-2/SHA-3/SHAKE ahash
Message-ID: <arn4XYwPYt6i2k7d@gondor.apana.org.au>
References: <20260917225929.2494111-1-aousherovitch@rambus.com>
 <20260917225929.2494111-5-aousherovitch@rambus.com>
 <arNn_fjy4jamSitO@gondor.apana.org.au>
 <LV8PR04MB9006374FD8621EBF3C7E7F6CD7822@LV8PR04MB9006.namprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <LV8PR04MB9006374FD8621EBF3C7E7F6CD7822@LV8PR04MB9006.namprd04.prod.outlook.com>

On Wed, Sep 23, 2026 at 08:50:55PM +0000, Ousherovitch, Alex wrote:
>
> - shake128/256, cshake, kmac and poly1305 have no matching provider
>   registered in this tree, so the allocation fails and the transform can't
>   be created at all. NO_FALLBACK is required to instantiate them.

Hang on, if an algorithm isn't even implemented in generic C for
the Crypto API, then it should not be implemented by a driver
either.

The reason these algorithms aren't in the Crypto API is because
they have no users.

So please drop them.

> - sha2, sha3 and sm3 do have a software provider, so the transform loads,
>   but the auto-fallback can't stand in for the hardware on the streaming
>   path: our exported state is the opaque HW save/restore checkpoint, not
>   the canonical state, so a multi-part export/import round-trip through the
>   fallback misinterprets it (and for SHA-2/SHA-3 the statesize exceeds
>   HASH_MAX_STATESIZE, so ahash_do_req_chain() returns -ENOSYS). A one-shot
>   digest could still use the software provider, but a fallback that only
>   covers one-shot and corrupts streaming isn't usable.

Sorry, that is not supported by our API.  If you cannot export the
hash state in a compatible format, then you will have to switch over
to fallbacks and only support digest operations.

Please also elaborate what you mean by opaque checkpoint, does it
contain the entire hash state or not?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
