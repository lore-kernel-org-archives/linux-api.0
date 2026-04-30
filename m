Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F38B40DFDE;
	Thu, 30 Apr 2026 02:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777516657; cv=none; b=PIMzHvAcROUaGwzJkQZUHxi5dHHCPqp7KW5AXEO86P14wOnM9z3gp7/G6GF5VLpstXSYkSx+5/dDhAcxCjOPlIuwwqk0cOj+lbh+kVJ1LUIoC4DHUh4g2Xbi11oupnU0YU+PeWKqvNNO81oSq720pcopQcziZhjnaWdPfhZf+Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777516657; c=relaxed/simple;
	bh=cmojHuLP3jnNZWqmo/6rv3gqgflgbv0J4HVHA1I/ffo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7JLaLgNQVQG7aGssXup/HQdpoD3E6CAPNGn5t3PFpNJz4ezoYmAq7DkNCY14t+Rq7JaVSxed9xMObrtWJwW/jpXr4vjK801Edb65e9LEd4ip0gnfkSgqix0BVzYPJUTADZ3zJQChsbwUWZktAQCRKY19ci8wxgaTxctt+iJ4Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=B41INN4W; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="B41INN4W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=dVtNlQBpH51UytQpIb8A6JMmXFC/Chl+lh2xCMpAn80=; 
	b=B41INN4Wgi9RyGKTQmptdjwvbjK5VHc2WwpnIVc1s9k5mK+s0F24dIeS5bFODOqXTdKseb00Naf
	TCQQOL/t0N3IPq5mCY4NYzk28P7BufssSYEYtiUPX+kFz1zdTlrVU/GJgb8ILVPXaosRMqn+Lw0HN
	tl6lpUCGLY43BU5x1271pyOkBc9cYBvIigphUr21YA5mFnYFQoY5OuxwnzK4FOL31O3A3yb4DXtaM
	I2dVeBnvZxrfi8msBorNmpmjRd7LT4oY1Lk87KFqaBega+CUX2NSGg0BdQ1XDWUr8kVUZFu5u1c40
	13CcP1vx4MIeBY8yqOsVN8u0u26NtvrI5siQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wIGlw-00A1Fb-2O;
	Thu, 30 Apr 2026 10:05:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Apr 2026 10:05:00 +0800
Date: Thu, 30 Apr 2026 10:05:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] crypto: af_alg - Document the deprecation of AF_ALG
Message-ID: <afK4zC-Mgo6LBfUh@gondor.apana.org.au>
References: <20260430011544.31823-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430011544.31823-1-ebiggers@kernel.org>

On Wed, Apr 29, 2026 at 06:15:44PM -0700, Eric Biggers wrote:
> AF_ALG is almost completely unnecessary, and it exposes a massive attack
> surface that hasn't been standing up to modern vulnerability discovery
> tools.  The latest one even has its own website, providing a small
> Python script that reliably roots most Linux distros: https://copy.fail/
> 
> This isn't sustainable, especially as LLMs have accelerated the rate the
> vulnerabilities are coming in.  The effort that is being put into this
> thing is vastly disproportional to the few programs that actually use
> it, and those programs would be better served by userspace code anyway.
> 
> These issues have been noted in many mailing list discussions already.
> But until now they haven't been reflected in the documentation or
> kconfig menu itself, and the vulnerabilities are still coming in.
> 
> Let's go ahead and document the deprecation.
> 
> This isn't intended to change anything overnight.  After all, most Linux
> distros won't be able to disable the kconfig options quite yet, mainly
> because of iwd.  But this should create a bit more impetus for these
> userspace programs to be fixed, and the documentation update should also
> help prevent more users from appearing.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

What about the exposure of akcipher through security/keys/keyctl_pkey.c?

There isn't even a Kconfig option to disable that user-space API.
If module signatures are enabled then this automatically gets added
to the kernel:

MODULE_SIG -> MODULE_SIG_FORMAT -> SYSTEM_DATA_VERIFICATION ->
KEYS + ASYMMETRIC_KEY_TYPE

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
