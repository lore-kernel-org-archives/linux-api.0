Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795098787;
	b=2LreflKMo9u/a9lTYG9UY9DO9b1HsOQYfF07CU+u+6flOrjHgfIqVpt2N6PNGWFlsZVi
	 kqZx6siMMcuVFmDtlCsMAEy3ymWcx57CFSf2sl0QbNQBi0RPNfgms/ibbGAjWC2m/+sA7
	 5PHdwjYAn3ephDrFaXhyE5zEffXXu8oZNPoqvD3y7TMlMcrhMf2hHkbnDUb/loWxd3HIR
	 hXBc7HCZqoh9FwBmSGtI8l/iIe78Fg6B0/s9YVO4+JAyZs+SIs9CsQLSn9oFVlqJ3SCNO
	 i5jSc57LUDbyeRFwC2VPKo2yGdGhbTKVAc0Ns2a9lW0vEmNRMD9UkgZ2xJawiTAoehA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795098787;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=lv3NYu11pHprgRUUKX5nzbXJ9PYh0wkr94sy1z7rgm4=;
	b=HhUz9P0F7LL2iWHLCqEtIIjRSjYOooDMWnHt/FHS0RGOuuepJWvL4pBjWc3XWKU0SUK+
	 w/PA6i3tfp5AoaHIlqiMnM2VWjp21PlNjCfEa52mfCdMhQCtkxBmguQNbN/3djHSM45no
	 Ak/AAIpGE8nDC1DSJlPRGy5eedfHT1NBUuAnDBJkZQ+dCNsEm7E/dOmLadC/idPE4GxZP
	 2GWKzOj+IvNOCIYaF0n+PKDRLikW8wszbLrIF5F5tK4sB/pnFG75X59h040SfcLtU66kV
	 p0nRE3anKMwJ4xQQns1OS57BTB3/eJGWCI/zz8m1TbNjw/1jZSMO6wjaY/fbzbvzgAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DkO9ZyBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id F34B1606A320;
	Thu, 19 Nov 2026 14:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DkO9ZyBD
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3738E1F000CA;
	Thu, 19 Nov 2026 14:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795098786;
	bh=lv3NYu11pHprgRUUKX5nzbXJ9PYh0wkr94sy1z7rgm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DkO9ZyBD2TgaZMRcs8EgWiOCyNyqCS5GVpH0PIaxsiAxioBTNKOP1wNtv66D5cYUo
	 SVbW8UDU1ecj5E3RCQAhHUNANk3OefmNfhyVcaUvR0Gz4clykNB0Ug9GoG1Ptr8ZuJ
	 ONnfC20iTyqzzJ2bUJn6Pg6qw6zmZqZ3ZatVKnDFWAqwRPzMWGYReKxU4oRi50tS1Q
	 1qTF54aQpt4AAtXTH2qm2wUUGVJhq8ji6yCXpiUz4OvXBnHZfzrVs9GnUElmUD670e
	 vrz7s2wx6vlq7TxR3Li0W0SBs0mp7rRKPrBjNuC5IHgS3SdNuJjawMEJSGy/3xT0BT
	 6PR8vQwsFHWZw==
Date: Thu, 19 Nov 2026 16:33:03 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Rodolfo Giometti <giometti@enneenne.com>
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
	Eric Biggers <ebiggers@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-crypto@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Demi Marie Obenour <demiobenour@gmail.com>
Subject: Re: [RFC PATCH 0/9] KEYS: keycrypt: keys that user space can use but
 never read
Message-ID: <av8In0Xyd5iI9N7K@kernel.org>
References: <20261118140421.584086-1-giometti@enneenne.com>
 <650f89ef-9745-4f75-b254-80fa5ac4773d@gmail.com>
 <av5EyVHnNzT27dyK@kernel.org>
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
In-Reply-To: <av5EyVHnNzT27dyK@kernel.org>

On Thu, Nov 19, 2026 at 02:37:33AM +0200, Jarkko Sakkinen wrote:
> The exitential problem here is that KEYCTL_CRYPT_OPEN creates a circular
> relationship between the keyrings API and a specific key type.
> 
> At hardware level I did not see any support for TPM, which narrows down
> the potential user base.
> 
> The remaining potential user base is further reduced by those that use
> trusted keys; leaving out those who need to solve the assumed problem
> that only this patch set can presumebly sort out.
> 
> And we don't really know at this point that cut. This is pretty much
> the break down of what is wrong here.
> 
> If there is/was a problem to sort out, it should be so constrained that
> it should be as quick to describe as stepping over a nail really.
> 
> These are the main topics what I would focus on.

I'm not disregarding that there might be something; and neither
disregarding e.g., the use of Claude. Throwing a dice can apply as well
human made code as for me code is just code. Perhaps using Claude,
people just tend to have just a itchier trigger finger :-)

The place where *in my personal opinion*  anyone who uses agents would
be better to do manual work is the commit message. It enforces to use
cognitive abilities even more so than writing code, if you with
absolutely no self-deception, read it all through and write with your
own words what the heck it does.

Usually when hitting the wall doing that leads into better code
because of the healthy reality check. I'm not a medical doctor but
I believe at least that thinking more stuff like this is also great
for long-term health and cognitive abilities.

AI is for mental health as a car is for physical health; for better or
worse.

Code quality is also over-rated although best effort should be done
but that's all. If you get it, then it is done. It's harder than it
sounds without self-deception part.

And yeah, we don't have projected problems. I.e. "no users" is always
NAK. You have to step on the nail at first.

Just need to clear my thoughts on overall the topic :-) This is I guess
where I stand now. Hope you find these helpful.

Br, Jarkko
