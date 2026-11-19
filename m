Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.116
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795090655;
	b=h2lFTUmSMgLwd/TzUhVYKdZRKtRFbVA65AZ72XN0/2p/Yd5SEwjaQUL/ndYy/GuZXbsm
	 8QpOADXDGTiFJ+mkWj1sZmKtLmF0xLXSWwbwegY4S3TOm0XmnNhm7Il1WQQeiD1lrIAOX
	 1G8UNdOh4AdyUQUwi/pMTXYUkGa3i8KcA+x+/WjoYBCXNrXz1OP47CxlS9mqXUzoalNpi
	 Szhbs1fX4zvfYKI/s7UBg+8N+2IO3JJgQNIEHZr2jsP+KIvQP3g8ZxbRcl+k9EPxFK1Fr
	 Q/DkGC6HMQT8sBdfi8EVpbVaw6LabcSpirctmyDYlGzvH3dLhZ4WJAYQUuDE6p8iZNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795090655;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:Content-Language:To:Cc:References:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=4+hewYS5Xc85XMsrC6qSZHgaMk+5vxcwYlnKkuazLe8=;
	b=c6pxGio934w25h55golelOAji79X+uPHJW1QEjGE/h5tJUU6FcaBNsqEHAU3f+aIZiV0
	 fnkzkhTBQ3fZAKWzsu6PFYTauAGsu0nJ3pii6xYQz+UJGZiY6dJSKtR7B0Yc/01fWkjBx
	 8VPxr101PeSGtU5T64ywpl+qxsKVfU9PS2hUqGZej6ZZ1UYN2Kzq444WC52C3CeWEwLDk
	 cTy+RmBlP0GyW5kFhxdc7Oc6yj34JDq5XNNkRC2Mx/bIszbX2ZEW3S7lT8gz9Dvh1n1jP
	 S5N05aaGqPNCzTbFsNcZEZuIwKvLHo9SpZgLd5RzDhqtvJi4XQUoMEjmXUwPI77RnFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=enneenne.com;
	spf=pass smtp.mailfrom=enneenne.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=CycFhd9A;
	arc=none smtp.remote-ip=62.149.156.116
Received: from smtpcmd11116.aruba.it (smtpcmd11116.aruba.it [62.149.156.116])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F45606A325
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 12:17:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9F45606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=CycFhd9A
Received: from [192.168.0.186] ([101.57.122.26])
	by Aruba SMTP with ESMTPSA
	id U14zxDwan6VShU14zxRiua; Thu, 19 Nov 2026 13:17:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1795090651; bh=V3OZh4icVrzbMI2k6cXTPEjlLw6DW6zRycuz+4CAfec=;
	h=Date:MIME-Version:Subject:To:From:Content-Type;
	b=CycFhd9A1catDJK8mSVVnIjyH5ROQd1v+wC5+drY99wllUzOcvv0JnbleYae1QyWl
	 BfXvel5+GlGK/smjYdZVOsE8ifTJ+aNn92e3/PHwymqXJ9vopCmtPNtiJdDDxgFhXQ
	 gH0O5LL0GqGBMM5zzAqHd0YcDoUE/TebWvQKcOdv9bAt/QbHhwHYpgUqx3x1h4Ldgp
	 75NfGZPT+sNKTTrA02giDUkiO0gk016/Jf4H4Ha37Gpw+3d0e3MxEHOw+7cjazCAy7
	 12PcNhVzIViATgQFKluA/RK3kpXudgDDYCPNifgplaPxzA8PVajw1Iru4DOG02ulfO
	 Vnl/JByjL9DVw==
Message-ID: <10d27c34-72d7-4380-abc9-6f8eddc6c08c@enneenne.com>
Date: Thu, 19 Nov 2026 13:17:29 +0100
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
Content-Language: en-US
To: Demi Marie Obenour <demiobenour@gmail.com>,
 Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
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
 <01692969-8e92-4a08-bde9-aad86674504f@gmail.com>
From: Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <01692969-8e92-4a08-bde9-aad86674504f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfKBPrYJ2CDN4f71Kap/ixDsQG8LCW21ix5G/r+qduPuGoKFzPku3ui/3D6NrDy/I4fLjS/AZ5x4bSLPCyVIF0to5TjSclhUTdSU4uon2/XK98GioKEpu
 t0DAXGgZowfR8EBdb4xlQI1aOmtiyouqFm6ozJqENawyIYsyVwWUPVtIrxKIMh6tgg2DcE0bNvKSfTxI4E/KX6og6HQ36T9SsUF5L6ywvP0CPLLtoj3XfOJK
 KK6OL4sQiUzIGXyKYC/g5t6eDL7TGBKZYqtynb/EnlVDCDMoH+BMpug/FQzubq89PMXLKw1FzF7r79429pnKXBHAlDBdAGSZfIFNS5uHsw8Ky4Ryb//LMK9V
 xLfwyhC5KBHWow0xsn0MR7mF6xbrK8rHOP6EY/6N+7N/mkYzZW0dxG31VP79/qgd0FE+u/f6bwMdsGglkPiv7Y+X/kQhNQovCMTLqK/xd4/A1//iDD4ibkuq
 1/kQFk3iW8okXGDrlVnZ6UkHWDYJU0H4V33JM+dA1KrG1s5yxelszfrfDGYXDXRvM9MRXG2C0JJFVnXDW1DBfX7oruz0XIMBt6ZuUqYpwYoCJYgDT8/Y94gB
 RtndS527vikEPvkczW3D2qQoIsrt4+TG4WSJC3lfoPhIyloLUzoc3clohznlcZ5d41rbBCRbfQ1vSp4l+bVmTsLWseSQTZKxyCBx5FWky+xTaEm69CxDc2nW
 HxMYdlYxr4DwnIfL+x2fqCJ5RbC7gBciMQd6ihsH1iadIXHfBcS4KhXDviVzexL7jL7TLPHnlpjTAhT/rODrCAAiT5G8Le0zqKlXI3LhP81Ke0+765dQ0e9y
 vgu5MhNb82zl8mX48OJ9rhfGTJKQP6C/S1uHuzQOV8VuqFJx7jL006rc7ZGJIcc4/bSi4OzRvFhFOgNVnMJP+jAWIUvBJtJS4o9aDPfIoaC0wUPeec7ltUUx
 3YAptj8Js+/LJy8wIk8KSIHNu1+DIrXnbtSxZ48rdWX3ylBXpUU2OdzVbAPjylucDm+hVHDEnZGmwM4stN3z19Ce9cCXkLIDcyAWyz9J1zqQ0O2bu0XmE7hv
 9+HAxJgOrvm6fyiIZnDN/P7bOyh6SKydeOvoEul+E155hehVkqO41wFNa7awsiPXufzyRwo7sKbPtMCbyJ4P/mnlwQSbOC29VJQeoCboPfyks3hw+p1gJkwG
 UStDxD9YrJOkVXUS048vbJ5rbuI5vxFjkO5bxo7Dsgk2WyJjnWav55v2ahPGzLX0t+XZEaY1n4iDLxnooNN/H35sYauqbDVs3RMMPG938OJL4wUKNVf/6fDh
 Y3+0UYag

On 19/11/2026 05:35, Demi Marie Obenour wrote:
> On 11/18/26 7:43 PM, Demi Marie Obenour wrote:
>> On 11/18/26 7:37 PM, Jarkko Sakkinen wrote:
>>> On Wed, Nov 18, 2026 at 06:42:15PM -0500, Demi Marie Obenour wrote:
>>>> AES-256-CBC isn't a suitable mode on its own, unless it's combined
>>>> with a MAC in encrypt-then-MAC.  Even then, it has a 2^64 birthday
>>>> bound, so it should only be used 2^48 times with a single key unless
>>>> the key is ephemeral.

CBC is there for existing formats (craf writes files that openssl enc
can read) and because the CAAM path is CBC only. I take your points
on it.

>>>> AES-GCM is not a suitable algorithm either.  If you allow encrypting
>>>> with a key loaded from persistent storage, there is no way for the API
>>>> to ensure it is only used with a unique nonce.  Nonce reuse leaks the
>>>> authentication key and allows forgeries.  Using random nonces isn't
>>>> good enough either: NIST only allows 2^32 encryptions in this case,
>>>> and the API can't enforce that limit.

You are right that a construction of our own is the wrong choice:
patch 9, the only GCM in the series, has no user yet and can go.

[snip]

>> The usual solution to something like this is a userspace service
>> like ssh-agent.  Then you can do whatever key management you want.
>> That doesn't protect against root, but if someone can get root you
>> have bigger problems.

The threat here is root, on devices where root eventually falls: a
key root can copy decrypts that device's data offline and forever. A
service that holds the key in its memory gives that away. keycrypt
with the OP-TEE backend does not: the TA keeps the key and checks the
purpose sealed with it at every use, so even a compromised kernel can
only use it on that device, and only for that purpose.

> Also, if you need keys stored in hardware for some reason (compliance,
> time-limited exfiltration), you can use a userspace library or
> daemon that abstracts over whatever the hardware-specific API is.

Yes, that is the case I mean, and a daemon over a TEE would not give
the key away either. What it costs here is, for OP-TEE's PKCS#11 TA,
secure storage before the root filesystem exists; for the CAAM, the
only user-space path is AF_ALG cbc(paes), the one off-CPU exception
left in an interface the kernel documents as deprecated, privileged by
default, with a key format per driver and no purpose.

Ciao,

Rodolfo

-- 
GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming
