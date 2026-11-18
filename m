Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014471;
	b=i7xHja6TX4k2vyKVkTIxxZGJ9X9lDgKZeyQUGHeWihz2Ayxl0RJZBmawedv75lma9zWN
	 8i/Nk7u7ojiSdk3GT8y0gnfvysRsokmn528PV12JIq+d2SOzFlk0CZoezrMWTTfN6FRuK
	 vsfzB9qbFbMRUBrzKJVi/dmZyWZyELWSvdLB62kRJDEue3TVxZ/JCW3qac0Q9HblL9/jO
	 3foVhJi/A85J1O5Pcq+u4VywX2CUOwbX13s7CvOzuoRz753TDtiI0OGLXgeI63Y/6olKy
	 PKGUmYuJ/Q59N+5GbZUsj9c7DFu70rOHiIN2gjpWhMV45L8rQRiod4SvfDAVWgN3/8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014471;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WpNvKlvQgWs4nlBDzrAzqY0K1wpz+T9bN3CMOunjYys=;
	b=Fl/TV1qL8pXXYwQtwzaPISgKZqc9cgUbzPKdsyvhlL1vaPsX09DGzchUesLj8AqWekO6
	 grFoSgSx3PEW1Fl6fN/1K/CPXsrj6jsXmYVQ7FDfex42qBz/4g+jxeIAR1LRyK34Po7oL
	 fZ2sLD+g02DwI/Upn28HXV4tzv65YR46g6RHkGKIpiXoKRHjJhFXxC7FY217hpK5Dcm3D
	 JoMIbttbo/E/0gTy+AF6FxrPQVHA5mqr8ePxveg9SGM7+R/7MSIUk4UsxVQXGmbkKV6vA
	 wuPiyahEJTeeRXqrJM2HPCneGJbfJK0ubTpu0UZHZblMXQBLFKkSVJZzUf1T5PRfLyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ik0wB+4P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CE5E0606A32A;
	Wed, 18 Nov 2026 15:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ik0wB+4P
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C01C41F000C4;
	Wed, 18 Nov 2026 15:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795014471;
	bh=WpNvKlvQgWs4nlBDzrAzqY0K1wpz+T9bN3CMOunjYys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ik0wB+4PWOYL2hmQiNwFTeBBvupZ2nUcJiZ54iyfaa2tU77mnLlpFifyj8n1RAoxc
	 JiFr1whbKGn9jctVHgQHsWlXlRxqGaOAejYgryvppYJ1hYUJPmJajsbl1RZNJZ2urH
	 fAR3taWBeKxDwuMnnlsPRwbWW5GR06M9hA5dv1M1pEA51yEPNLWXKWfBsoGOA85JWU
	 RdSwiNfRnISgDS/zRQ8IFyTjSctGJRDAEhTnp4ENDN8HwGtDmIypnNR9Lro8os8drC
	 gH5m26+2mcTSgygYysYIO2BPjm0gAz6kctoO3OxBWgeB2Wg89nS8C+lhRUQ+5galCW
	 RrUE6ZrvqIprA==
Date: Wed, 18 Nov 2026 17:07:46 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: Rodolfo Giometti <giometti@enneenne.com>,
	David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jens Wiklander <jenswi@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	op-tee@lists.trustedfirmware.org,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Richard Weinberger <richard@nod.at>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-crypto@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [RFC PATCH 0/9] KEYS: keycrypt: keys that user space can use but
 never read
Message-ID: <av2_QoJHp1gMTFMp@kernel.org>
References: <20261118140421.584086-1-giometti@enneenne.com>
 <mvyqqjhvfka3kkumztixzozrthutkq6mfakkonxqbpm5gvzb62@eitzzleeyioe>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mvyqqjhvfka3kkumztixzozrthutkq6mfakkonxqbpm5gvzb62@eitzzleeyioe>

On Wed, Nov 18, 2026 at 03:57:27PM +0100, Marco Felsch wrote:
> These are basically the trusted-key purpose.

This is it.

If I was adding something like this, I would at least:

1. Discuss the solution that would extend trusted keys to the level
   that makes it crystal clear that this is won't work out too
   well.
2. Then show how the new thing addresses all of this.

If there is any gist this should not require whole a lot of text
dump.

AI assistance should not be really even mentioned the cover letters in
my opinion. It's equal to text editor; or smoke signals. It does not
level down anything i.e., I'm equally dissatified however this was
produced :-) 

Br, Jarkko
