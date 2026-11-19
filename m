Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049718;
	b=GUtO5r6BGuCMjKEhdhET526/HjMeayU9PKBcm/PTKLnLpeOKRXwTDbCZ/1q6bBH81vRa
	 XIYeld7OMjAg6/pRGTdJbb42mxkBUJfv3wa/6WtzeNKJALc7fIpyu081be0e6JAeb0fXf
	 ZvK2O1R8BbScRitmWfefDAfov/someEpMtSBcx+0AzOApuScQpq9k1tF8VoQFFV7pvyiM
	 2NNr1O4A8iMiW7De49dMxH0BQzki7CZFPUAcYYFrN0DWZ9u2WKsilvCkI4MVKcYdX+9vp
	 BejD9j5JFLQbZrpCeOpEgAmFR0pB55FxCHMv/ByZNdJl6O/mYzmZfN4N1UZmJrEsTTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049718;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=25HxFNVSbdwyEfeQT/v/hb2lKg9U17dcPsjF33ZXCwc=;
	b=FUP+0nj6RPx/U6VSe9Bu+m284XSH7q368OvxAtGKlNNhwhc2le3smQY7m0SxomMY9vko
	 faXwKuWrp7U3RTHyzKOQcdp9gzAeiyuFcSVjHzLqq+yePJnFY5TGbl41B6V4d5FhgFUsC
	 o89SFVZFzBfjE+4h0W9qyfthXOtk670w54oirT4h021gfVTCoRBOd4XHfhsO2+RNFMX6A
	 IBAKd88Y11FIKrAqTNoD8wR2CkSVjzFOjvNw8FSWOvmvxtYX5SnXVcIHeOM1t+sOb2WOy
	 cZsA5M6vt72rI/8o0Gj1QQXSrG6RTLapHLWDM3Gq+qFZ+r5DcTvfALxMI0s0v89rOrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VSxT9huh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3848A606A32A;
	Thu, 19 Nov 2026 00:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VSxT9huh
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6BD871F000C6;
	Thu, 19 Nov 2026 00:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795049718;
	bh=25HxFNVSbdwyEfeQT/v/hb2lKg9U17dcPsjF33ZXCwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VSxT9huhMwIVOvdxA1oFUsA4Z3PU2/6QKN1JtOI9ZSJErZpgzNWfQOcPlKak7TIE4
	 tm+0xSyBkBRfpn8XMWTzqp6KgUlDMmSl0HEHE90q5hwkySZIy9ns74+aW5YDlu9QwV
	 vwcxJUfaAxhlXZj0yYWSuZ8ZbfS2AK6rkE6AUIW0ogLTDSl9WRU2XQN9k6nL4Fy8mv
	 C4L9LtEdTSU97TB4VEGpS/gI+hAGPUHp3DtgSFei2y7DITtIFMXh2ymqvxfleCFenG
	 HZgKoVAwIiKWIq+u3tkkkmJxz6F1QUKEAxNhZ+GdXSpvRLONSfa7LYlJ4B0KvBgLyc
	 SaJhYffuT9SzQ==
Date: Thu, 19 Nov 2026 02:55:14 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Demi Marie Obenour <demiobenour@gmail.com>
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
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 9/9] KEYS: keycrypt: Add the aes256-gcm-stream
 algorithm
Message-ID: <av5I8lhExyKvf9w_@kernel.org>
References: <20261118140421.584086-1-giometti@enneenne.com>
 <20261118141257.627441-1-giometti@enneenne.com>
 <75946579-8335-4491-86da-fcda25ae9fd8@gmail.com>
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
In-Reply-To: <75946579-8335-4491-86da-fcda25ae9fd8@gmail.com>

On Wed, Nov 18, 2026 at 07:25:09PM -0500, Demi Marie Obenour wrote:
> On 11/18/26 9:12 AM, Rodolfo Giometti wrote:
> > This patch is a proposal on its own: nothing before it needs it, so it
> > can be discussed, or left out, apart from the rest.

If there is no one who needs this, this is literally throwing a dice
with Claude.

> > 
> > aes256-cbc does not authenticate what it decrypts, and a file or a
> > transfer longer than one call cannot be sealed with a single AES-GCM
> > invocation without buffering all of it, nor decrypted without
> > releasing plaintext before its tag is checked.
> > 
> > Add aes256-gcm-stream: the STREAM construction (Hoang, Reyhanitabar,
> > Rogaway, Vizar) over AES-256-GCM. A message is split into segments
> > of up to 64 KiB, each sealed with its own tag under a subkey derived
> > with HKDF-SHA256 from the key and a 16-byte salt drawn at
> > KEYCTL_CRYPT_OPEN; the nonce carries the segment's position and a
> > last-segment flag, and the counter lives in the kernel, so segments
> > can be neither reordered nor dropped from the end unnoticed. The
> > segments go through a new ioctl, KEYCRYPT_IOC_SEGMENT, and
> > KEYCRYPT_IOC_FINAL reports a stream whose last segment never came.
> > A tee or hsm backend draws the salt and keeps the counter in its
> > secure side; the sw and optee backends implement it.
> 
> Please use Cobblestone-128 or Cobblestone-256 instead.
> https://c2sp.org/chunked-encryption has the spec, and you can check
> against the implementation in pyca/cryptography or (for Cobblestone-128)
> the Go package filippo.io/cobblestone.  This assumes your CPU has AES
> and GCM instructions; if not, you should see about using one that does
> or work with a cryptographer to standardize an alternative that doesn't
> need them.
> 
> Nonstandard constructions like this one are to be avoided.

The wider problem in crypto without a use case there is nothing
to protect.

> -- 
> Sincerely,
> Demi Marie Obenour (she/her/hers)


Br, Jarkko
