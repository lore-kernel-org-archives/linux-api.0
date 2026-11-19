Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.116
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795083572;
	b=lz3bMO7f71bTMGuyYK4l3Rg7izDyMz24OJOcMaodmopf4d77wY3lDYg5CKEyQa0UMthc
	 vQdQtocyRGhIrocSzMcwTqfbrubjbojBS/O8f0UxcKSeL90BguqvnnY0aajFMQYALNCZD
	 oTLUfP7afjqEsb6MJhsmMdy5zY/4Kz5CtKbWXp3GFAoyyCCxIn6CRt/4M5pkgE5WBfpv7
	 YbqEmiHLu9Cz7qwgfDViPi7wjw2W3VZW0hVeq+r7uNgGFKSiCs2ucC+HlfWpjP90XziwK
	 jdRt8W+mwJZYX5IBsj5bBbYEbmWcU1EbLYaR/gzGkwQOMTydI2bVFF00oRKvbkynxzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795083572;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:Content-Language:To:Cc:References:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CMAE-Envelope;
	bh=qoTfovvGGzpx6qWwGgUcp8ZrLCtEAOaZqm/XAVRtgu8=;
	b=XvGAqoYxVLKOBZpkJPYr8t46nATpp5jJCxsQcUuHZV8vRLychtw4INgZa64tuG5c0lID
	 tuTO6R1JVL+j4EzSH0fLeWkp/XDwqAlzyOtFk62/8HoU65GluF89PWLlVJjuBx4sda4H+
	 ON7o8q7mb1jBfDaSGVW4Na08jQ8PE8uVpvgXxb3fY+54vNPMOEdNX/j1tvINlhihd0Ko8
	 1/z5FIpWFdbimNRmjJK76vrQEwT4BGvACMMcr+0kNdJC9SFeHhB10vbCF28ZEv2hUCGca
	 XAPlddnhO16VunS2ZBLZlPnei6B4ClpVXog/YBKZIHMVuaj8Xb2pt1ysJoxvp5M2THA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=enneenne.com;
	spf=pass smtp.mailfrom=enneenne.com;
	dkim=pass header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b="YbUT/4nB";
	arc=none smtp.remote-ip=62.149.156.116
Received: from smtpcmd11116.aruba.it (smtpcmd11116.aruba.it [62.149.156.116])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AC760A2610
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 10:19:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8AC760A2610
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.a=rsa-sha256 header.s=a1 header.b=YbUT/4nB
Received: from [192.168.0.186] ([101.57.122.26])
	by Aruba SMTP with ESMTPSA
	id TzEoxCjbX6VShTzEoxQo8b; Thu, 19 Nov 2026 11:19:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1795083571; bh=xVDB/U48+KhBs5UAsVUdiYW+qscID3emDO8ims3vEAk=;
	h=Date:MIME-Version:Subject:To:From:Content-Type;
	b=YbUT/4nBgfoaIXJwrMhQeMlvt9sIO8ewa18oowgWvXyRXmLc2FHqa2uE+1ff4WSTf
	 +SlwXjDXm5+E/qUhmEoIB20CoCnXl3yFBCAfguB9RFKweMi7UXcT5bvO6X6JzcKsVY
	 YdpDu59seHkq9sF+x9RNqBAoaQVUMas1goxW3myB1EgiT3nhghCefk4/uA0S5tFFps
	 TKVA8foIHclyKVCWFHy5lEMDBTPNoWtxVHid8dwSdINvi25UgNeSV0dcPqLyfphhGR
	 kGKvJwZviyVJAXY+tsejDtlxxsZooEEM2WPMcXCcmF3vDQZeiDtSbhOPjEWtT1DFPA
	 jFwJQ9Lcm3lfg==
Message-ID: <6fc1eaee-3a60-49d9-a5a0-74b662f2232f@enneenne.com>
Date: Thu, 19 Nov 2026 11:19:30 +0100
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
To: Jarkko Sakkinen <jarkko@kernel.org>,
 Demi Marie Obenour <demiobenour@gmail.com>
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
From: Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <av5EyVHnNzT27dyK@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfNmI1DIntSdZQogEw4CF+ExsMW52Dv4KVdQXYoEI2SlV11eEe+IxA80+xUydMG7wJYG2UEM6OiD9fNlRWY7iZyyfEynPQDNyEEdFhZWKfwj8abUd2CVm
 Lq49bpZ8Z2hgx71DU6sYhhPLl43jb2ht+KlVBI2Wws/GNH5B314G6kSkVXdUI0zRZd2gi9GuTGtx9GWmWncQRI4c/1+DT6GPQBX8WtlSvd+6+m3S0U28wDVb
 9Hs0soZ49fsX6dkU30YublBd1jh16ccPykwFzi0QXARm/rgb+5uK/CGYB48nylkVg/Iou536TAACMpiIFEXZHeWUt50k8OfWaF0zaM+UpvSSdAus9yIAxvfo
 TN94jAoBEVnYhfDi4/82Wy353ZJ1o5Gj7OLddeLFkBJpl5Wzw5rMleizI45QkQxnhWD9ETOrQetS561qT7M5CxMYKxPdP2CZdtSrbjcXhI6YyhaQFk/VhuOD
 xGbNMNlUIo4efMC8Jcl4US1dtNwkfWg/BpgPT1zm36hQYfAnbrypJsoCkLgDERPLHDlxy3WHcdLrwjTHDhF152PUwUN3+0cXJP+rpQt4cnKrbJOd8mbnMBA5
 EMXx6ob9CMe6mj+soYJG99NcZl4tQ0l+s5hpHAPsuc526bT/lm5wQJkL1AqL3CRNSBp8R47j5nwfQayZ+tYMift/3GXo8dIjA1+x5Yvr6vMNcofIH7i/59ur
 Cr0sge9wRuaNCXPdPiwh8reCg0jcdmIDUSmDeezWJ/vVEu0ZRJk6A0sox8LZ4P6BOT1DZRkpwpiVSc8FzhApAGo7gQFx9BodEBr1xaKmgy0lQPUfofalbEII
 C6SljIGeSVkINsuuIJIc4xdBFC7WWD/A2Sc+c78UHrVkV0MV4yXYbaTvr9wNBVTgrAwp3+Y2tyceUQ++SVMYBYF0Ep10RMiXXsCHHx8Ag3zq5QoaPh3C5Ewb
 Xi3Ngl0pycbj6Q70Q43aVHp4xi3eUQlhWi1FOWVON921NfgQcZmZwXdeGWDCESlVLmbWInKcpIgUO2tNtllaYf9/CQP+sPgnyHv17dhDWbS3pxvLllfyiCb3
 ok3jS7JCxO6vaFDZQLPPhhR/83ZbJ2KLWnwLSR3vhTJoHsFu1MSbYvLxA49eoVbSM//x+PpbPS6efabzTOuqyXJypu2VSbiPywrJvlCcYgz8HkYiOp/KN/7w
 5+vVhbHV+6327zrFt84ZC5MvsP6W7QnSoCxLdbTLlHwV7lXCyMgyzPaAh/4+68Unc1/0NALeZ2REnwOiT7xXoxkV85CK2tGeb5X9z7vGZH0Jh1i15QTOZRXm
 iZpFWF2L

On 19/11/2026 01:37, Jarkko Sakkinen wrote:

[snip]

> The exitential problem here is that KEYCTL_CRYPT_OPEN creates a circular
> relationship between the keyrings API and a specific key type.

Agreed: it should be a key_type operation, dispatched the way
KEYCTL_PKEY_* dispatches to asym_eds_op, so that keyctl knows no key
type.

> At hardware level I did not see any support for TPM, which narrows down
> the potential user base.

On a TPM system the sw backend can take its master from a TPM-sealed
trusted key, but there keycrypt adds little over a trusted key. The
users are SoCs with a TEE and often no TPM, OP-TEE on i.MX for one.

> The remaining potential user base is further reduced by those that use
> trusted keys; leaving out those who need to solve the assumed problem
> that only this patch set can presumebly sort out.
> 
> And we don't really know at this point that cut. This is pretty much
> the break down of what is wrong here.
> 
> If there is/was a problem to sort out, it should be so constrained that
> it should be as quick to describe as stepping over a nail really.

The nail: a device must encrypt and decrypt its own files, also from
a minimal initramfs, with a key that root or a kernel exploit can use
on the device but never copy off it. Trusted keys hand their users the
key's bytes (dm-crypt, encrypted keys and AF_ALG read them). CAAM's
"pk" option is the one exception, but even there a new key is drawn
in kernel memory before the CAAM wraps it, and user space reaches it
only through AF_ALG, which the kernel calls insecure and deprecated
(Documentation/crypto/userspace-if.rst, and "Userspace interface
(deprecated)" in crypto/Kconfig), privileged by default, with no
purpose bound to the key. The i.MX93 has no CAAM at all: there the key
can live in OP-TEE, and keycrypt lets the keyring use it without it
ever leaving the TA.

The stream of patch 9 has no user yet and can go.

Ciao,

Rodolfo

-- 
GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming
