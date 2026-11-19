Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062949;
	b=GUv/CCI2XWTMIjUwgz7Gz8k1TXK7qb6HP3g4sKyL24ruWAbTz43B3fQQv2foj9XfmTNb
	 TRV2ERqB+A/LrOCiAW0h9ncphNiFTRY2N+ahdUNagImjrGA9+Ejp6Z5bgZUnWjO10wv8M
	 86owGmyY4/Wq5emUssFa0p2hMYP7jWuaVwnoHD4HwAXMfX7f2p5RpVSRWt1sHv3ZX84Ii
	 TS4ocuzmpOcnLbf14rT9ZuiXpnK1bkknwQdBATT9ZoJke0V2Txly2Zd71/MSiKHJtnoUv
	 E3PrHGm2FKrl9uK8zFWBAdT8W+VAAVI87tMEELVdb5MtR9fyepmoYA4AtxJ767qbYUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062949;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:Autocrypt:In-Reply-To:Content-Type;
	bh=15/4X+XmCoRzDJOy9ULZn+kckyAFR/IxSL1m0Ml3mE8=;
	b=aG6u3yjz8jQ0XxDOzfC1lBb/927jQspUbEpLfJ8ipZ9ugVnREg7uYyCQoH3/JSc46RdI
	 sUbQgQ+5c0bN88ABc4sAH+oxImPmA6uGJIFWvMoKBcEOCXQH9Vuh9/2NbFZh/qMTW5g2o
	 AzyHK6zYcsGQVqdcmBv4cCgCBb+RNqXPaiayJzIePwgQMZKWM5xaSd3vUMLYKi2cD17hb
	 WSbNa/dB4VPahH1mkVt7h1beeCSSYga13fVc9eqMPLLBtW3gbJwlHPVEpOIe6s9k5szmW
	 7Vr7VQuryA8dVHYyOrv+jOAyJ65lkN9pMeiXaXWaQanxhjBV6rWMPBMjSiNW4pGW/RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OYpuJWPY;
	arc=none smtp.remote-ip=209.85.128.180
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAC8606A32A
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 04:35:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DAC8606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OYpuJWPY
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8b4d07494b0so6308807b3.0
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 20:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795062948; x=1795667748; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:content-language:references:cc
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=15/4X+XmCoRzDJOy9ULZn+kckyAFR/IxSL1m0Ml3mE8=;
        b=OYpuJWPYnMuVPwGxgn3jii7J+dOqqSRfMo+VEVUGQIRV/3I6NGnjsYgyBvK/29gGJQ
         nzLYTJ5/X19g8IIlQGLvK7IRtOFGn1b0NnuUke+jhOdRTSkMyY1dXGhVGJpMErebOORg
         IWrzmU1J8Vhh+M+lgYoXZ8X761Z9EK+1DZAB45aXRetYSljytP3rGjqwMbR1N+9IWIyK
         BYdDfyKvflZgVHh8nkuEp3sUFt6nZ/3ptDnEFddjGO9XZG2TMAtxTCNWuVNwkECoe0xD
         /t+zoR/cOgCsTSMEa9kGl+Fbvhabz5fOTaz4FdlwJN9I8GLj1pMy3b5wjXSf5ezPh/B+
         G/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795062948; x=1795667748;
        h=content-type:in-reply-to:autocrypt:content-language:references:cc
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=15/4X+XmCoRzDJOy9ULZn+kckyAFR/IxSL1m0Ml3mE8=;
        b=JiMeItBGG1Kh5kS8CWWwHQE2gFhqX43bCjD8a3VYIrET4NyTwZJPFCOvngv8dLyubM
         u72j14Ld+hOL9RX9zp5eM3LHJgix+e1ExGqzCxwv1eTGFQidj/h0BLYE2fioWqCDsKAO
         YMxkSGU6r5b5Oj8i74a03RoTzLAnxG/ecLmbQ2xWwjl8rjDcra3Jx/9/1TNS8pid51HF
         4lTeVmBEzPw3V3wynBjkzdnNF9oj80WSV1vuZmZRCmVsvqyddMQHC456/ZU3isLvkT6r
         2oJf802VfNFy3/1YBMDzUH6zNj/txPJX0RVwRYULQWalIfR/dnSQfe+Jl4q4rWoZ3dTB
         65ig==
X-Forwarded-Encrypted: i=1; AL+hErGi7YnBfXnJMERYu5koKOZ5ttRVNDhRiDpcp1bkOAyr4PTMp07x8rXMdHeZ1yRSuljCggFQ3vZqnZk=@vger.kernel.org
X-Gm-Message-State: APuU4Z+UoxwzgBTZZUvW87imdOD7p8QXJ80Xgq7icoSJ3FqP9Lm4YwBO
	wILc37y7CctYUIzB5/dtofv6gGliY3A6wRwpAP2okt2RPsWCDBR7Hqoq
X-Gm-Gg: AZFdTZdP1qqiGuWH+HrG4mwPhOf3cFosnr/tBKqWhp/AGwfPy9ItlbgkUZjNPAxeEfY
	eZgECiZ4tqjASgvKPq2OHUh+MzdtR4k6/ijVXWVPmxvgbMPRIHNCB1EfzVMsLSKTC7uOOAKpI05
	kn4tO6cdNu6o4VDnJEsmOJCQ1I4COUPgWs+Gx/EH9AxCyaUPulkPCxyZHZ0jlG7xYTcZWgHWBK1
	y6bGQu0V6PLfyh8nfniam3b8xj8uOsnPV8isjAG3YSCi+cpCuuj2AFTo3lW3dHFbddVnbTAFNhJ
	CnMfw7Jlaux+DoWUH1OpQ6kkISy5i6hIOJMbJWUFnLlgmJTIXBvZ9/3uMr15CZxHFbvCKPkR1yP
	Zbq3WYRTVyy1LNCnX6XYRjaMR1gX8k3EVWxUS0YxCHNkTOW3yh/T4ynZcy65wpK/yH4vKXOhC1R
	hgIHRtBe/sR9ZNoDmuCK8SE0D/kirpJSG7MjpRth4dBRUs5hf/Fp8IOCRRMtR/GN+HE9gPL/dIH
	HHU9B5FKQihEJ6+qO7Wqtkb3H0zZPTMxxWiGSEQWDAOrPjV2dGlzUsA50rdt6SGlZkw4ENglpLP
	dmk3EVHiEsh+yPlZM1gl9GHMIS6LyEmybA==
X-Received: by 2002:a05:690c:6ac9:b0:8b4:bd06:d72a with SMTP id 00721157ae682-8b5145d462amr2408167b3.7.1795062948285;
        Wed, 18 Nov 2026 20:35:48 -0800 (PST)
Received: from [10.138.10.6] ([149.102.242.31])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4fe0eb6dbsm28160327b3.37.2026.11.18.20.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 20:35:47 -0800 (PST)
Message-ID: <01692969-8e92-4a08-bde9-aad86674504f@gmail.com>
Date: Wed, 18 Nov 2026 23:35:40 -0500
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9] KEYS: keycrypt: keys that user space can use but
 never read
From: Demi Marie Obenour <demiobenour@gmail.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>,
 David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Jens Wiklander <jenswi@kernel.org>,
 Sumit Garg <sumit.garg@kernel.org>, op-tee@lists.trustedfirmware.org,
 =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
 Pankaj Gupta <pankaj.gupta@nxp.com>, Sahil Malhotra
 <sahil.malhotra@nxp.com>, Ahmad Fatoum <a.fatoum@pengutronix.de>,
 Richard Weinberger <richard@nod.at>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Eric Biggers <ebiggers@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-crypto@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20261118140421.584086-1-giometti@enneenne.com>
 <650f89ef-9745-4f75-b254-80fa5ac4773d@gmail.com>
 <av5EyVHnNzT27dyK@kernel.org>
 <61ca7c37-7b42-48a3-be2e-95deb4d999a2@gmail.com>
Content-Language: en-US
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <61ca7c37-7b42-48a3-be2e-95deb4d999a2@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------TcKWtsLCyJxi3XICi0j0cgZS"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------TcKWtsLCyJxi3XICi0j0cgZS
Content-Type: multipart/mixed; boundary="------------4OgpeGPySwpKXLmv1JC05A5y";
 protected-headers="v1"; hp="clear"
Message-ID: <01692969-8e92-4a08-bde9-aad86674504f@gmail.com>
Date: Wed, 18 Nov 2026 23:35:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9] KEYS: keycrypt: keys that user space can use but
 never read
From: Demi Marie Obenour <demiobenour@gmail.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>,
 David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Jens Wiklander <jenswi@kernel.org>,
 Sumit Garg <sumit.garg@kernel.org>, op-tee@lists.trustedfirmware.org,
 =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
 Pankaj Gupta <pankaj.gupta@nxp.com>, Sahil Malhotra
 <sahil.malhotra@nxp.com>, Ahmad Fatoum <a.fatoum@pengutronix.de>,
 Richard Weinberger <richard@nod.at>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Eric Biggers <ebiggers@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-crypto@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20261118140421.584086-1-giometti@enneenne.com>
 <650f89ef-9745-4f75-b254-80fa5ac4773d@gmail.com>
 <av5EyVHnNzT27dyK@kernel.org>
 <61ca7c37-7b42-48a3-be2e-95deb4d999a2@gmail.com>
Content-Language: en-US
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <61ca7c37-7b42-48a3-be2e-95deb4d999a2@gmail.com>

--------------4OgpeGPySwpKXLmv1JC05A5y
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/18/26 7:43 PM, Demi Marie Obenour wrote:
> On 11/18/26 7:37 PM, Jarkko Sakkinen wrote:
>> On Wed, Nov 18, 2026 at 06:42:15PM -0500, Demi Marie Obenour wrote:
>>> On 11/18/26 9:04 AM, Rodolfo Giometti wrote:
>>>> This RFC proposes a key type, "keycrypt", whose material user space =
can
>>>> use for symmetric operations but never read: AES-256-CBC, HMAC-SHA25=
6
>>>> and an authenticated AES-256-GCM stream, through a file descriptor t=
hat
>>>> KEYCTL_CRYPT_OPEN returns for one key and one operation.
>>>
>>> I haven't looked at the API, but from a cryptographic perspective,
>>> this encourages very poor practices.  AES-GCM even allows userspace
>>> to extract the secret authentication key.
>>>
>>> AES-256-CBC isn't a suitable mode on its own, unless it's combined
>>> with a MAC in encrypt-then-MAC.  Even then, it has a 2^64 birthday
>>> bound, so it should only be used 2^48 times with a single key unless
>>> the key is ephemeral.
>>>
>>> AES-GCM is not a suitable algorithm either.  If you allow encrypting
>>> with a key loaded from persistent storage, there is no way for the AP=
I
>>> to ensure it is only used with a unique nonce.  Nonce reuse leaks the=

>>> authentication key and allows forgeries.  Using random nonces isn't
>>> good enough either: NIST only allows 2^32 encryptions in this case,
>>> and the API can't enforce that limit.
>>>
>>> For long-term keys, all of the following are much safer choices.
>>> They have 192-bit nonces, which means that one can generate them
>>> at random for each encryption without any problems.
>>>
>>> - XAES-256-GCM
>>> - XChaCha20-Poly1305
>>> - AEGIS-256
>>>
>>> AES-GCM-SIV is also okay, provided that you are fine with occasionall=
y
>>> leaking if two plaintexts are equal.  This happens whenever there is
>>> a nonce collision, so with probability 2^-32 after 2^32 encryptions.
>>
>> The exitential problem here is that KEYCTL_CRYPT_OPEN creates a circul=
ar
>> relationship between the keyrings API and a specific key type.
>>
>> At hardware level I did not see any support for TPM, which narrows dow=
n
>> the potential user base.
>>
>> The remaining potential user base is further reduced by those that use=

>> trusted keys; leaving out those who need to solve the assumed problem
>> that only this patch set can presumebly sort out.
>>
>> And we don't really know at this point that cut. This is pretty much
>> the break down of what is wrong here.
>>
>> If there is/was a problem to sort out, it should be so constrained tha=
t
>> it should be as quick to describe as stepping over a nail really.
>>
>> These are the main topics what I would focus on.
>=20
> This whole patchset looks like a solution looking for a problem.
>=20
> The usual solution to something like this is a userspace service
> like ssh-agent.  Then you can do whatever key management you want.
> That doesn't protect against root, but if someone can get root you
> have bigger problems.

Also, if you need keys stored in hardware for some reason (compliance,
time-limited exfiltration), you can use a userspace library or
daemon that abstracts over whatever the hardware-specific API is.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------4OgpeGPySwpKXLmv1JC05A5y--

--------------TcKWtsLCyJxi3XICi0j0cgZS
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmr+fJ0ACgkQszaHOrMp
8lNnog//Zv9Yu40JzQzbXChbDVpLW3jj2qZL14ylL6dgxwdF+94Q9H/FQSHtrVYN
ZNtaFNLgIxnWfLYPn2cmx1Q0iNVsC1T7HyK9UMEq9H5GFhcaJSMe0zarKt4FCFUt
I2QUDPL/9pNo33Zl+p+Anqa+PtMXjh0d+pRsFTPjt84edhdJzDoQd4iffp8z/LJp
5veNCmRZ1LgUPhd9RJnB3OOg83845zdjuRFyEdqMzmgjkQJxBVncm4IIEJeAtCdb
m54q8JQ/a/cRgqpdDjyGNpwpgsKqEAhPTpoOfgtXZTPH/c1J9pMVVL9TJ/C5rlwS
Tm6alVHHKNTAZCngFnYw/pYKUbgf4N4qhB5lHbCoL4YvBPgIo6wAMHr8BagGqEBA
1P6cYA87ODKbMFEDPzC/Qysc3a1QI5L2bPT085Yd/eqU2OEHExP/IIx7xGI0JKR5
xypVEKBowMiGRJHW6UAg9KzeiCRHjFWOOWTOiRUmwIwKWKGJu0cpVPfai0gv10ux
qz7TcQPnAWpnJiEK2XrYF3GxA3U9DcGT7uCZT5GQc+np1UwAkEmXQRfVaPzPWVgO
m/cpZsBR8rtzCO85v81tY3scYnfZpJ1VHEulFu4r8fdDa1LXmdFaVC+wlJVj4TI4
hwK+eSrts8c8la9ANURvrhu/1PdK0i6+9FzhWzJ4hovXCtN/HTg=
=3DVi
-----END PGP SIGNATURE-----

--------------TcKWtsLCyJxi3XICi0j0cgZS--
