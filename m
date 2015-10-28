From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Wed, 28 Oct 2015 09:46:51 +0900
Message-ID: <1CD8D5EC-1BAA-495E-B671-6423C3CA4104@holtmann.org>
References: <1831785.BBs8Hj3CxY@myon.chronox.de> <1499937.MpmApGzYrd@tauon.atsec.com> <1445989396.3405.131.camel@infradead.org> <1885267.SGBklDhT9E@myon.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1885267.SGBklDhT9E@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: David Woodhouse <dwmw2@infradead.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

Hi Stephan,

>>> Albeit that all sounds like the crown jewel, how do you propose that shall
>>> happen?
>>> 
>>> Assume that you have a web server that has a pub and priv key in its
>>> current configuration -- I guess that is the vast majority of configs.
>>> 
>>> Can you please elaborate how the process for such a web server shall
>>> really
>>> work?
>> 
>> 1. Create a kernel-side key.
>> 2. Use it.
>> 
>> That may require adding an API similar to the one you're proposing, but
>> working with kernel keys instead of directly with akcipher. Or perhaps
>> the key subsystem can already offer what you need in userspace. David?
> 
> Ohh, I see. So, you are saying that there should not be a setpub/privkey for 
> the akcipher AF_ALG interface?!

I tested support for adding ALG_SET_KEY_ID which takes the 32-bit key serial and then using AF_ALG with an skcipher. That works so far so fine. For making this super clean and get it upstream, it needs a symmetric key type (which is planned to be added by David). I can post my current patch as RFC since it is dead simple actually.

> If somebody wants to use akcipher, he shall set the key via the keyring and 
> akcipher shall obtain it from the keyring?
> 
> However, for the actual data shoveling, AF_ALG should still be used?

There is no massive data shoveling by an akcipher. All data shoveling for TLS is done via the symmetric session key that is negotiated. Actually with asymmetric ciphers, your keys will be normally larger than your clear text anyway.

So if a server has public/private key pair, then the first thing that should the server do is load this key pair into the kernel and retrieve a key serial for it. And then use this key id to derive the session key. That session key can then be used with AF_ALG and skcipher for the data shoveling.

However that all said, the keys should never leave the kernel. Neither the private key nor the session key. There is no point in sending keys through userspace. We actually do not want this at all. That is especially important if your actual private/public key pair is in hardware. So maybe your RSA accelerator might expose secure storage for the keys. Loading them over and over again from userspace makes no sense.

As David mentioned, we need to take a deep look at what the userspace API for asymmetric cipher suites (and we also have needs for ECDH etc. and not just RSA) should look like. Just exposing akcipher via AF_ALG is premature. If we expose it now, it is not an API that we can take back. Having two userspace APIs for the exactly the same functionality is a bad thing. Especially if one is limited to software only keys.

We also need to look at the larger picture here. And that is TLS support in the kernel. Potentially via AF_KCM or something similar.

And with TLS in mind, we actually do want to just load the whole X.509 certificate into the key subsystem. It will then allow you retrieve the key id, validate the certificate and use the key. Current kernels already support this kind of functionality and we want to enable this and extend it. Having random pieces in userspace and/or kernel space to extract keys from the containers is a pretty bad idea. We really want this centralized. Here the same goal applies, to not have multiple userspace APIs doing the same thing.

Regards

Marcel
