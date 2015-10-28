From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Wed, 28 Oct 2015 11:56:59 +0900
Message-ID: <F0D283A6-37C8-47EC-9DE0-998B8A59F138@holtmann.org>
References: <1831785.BBs8Hj3CxY@myon.chronox.de> <1885267.SGBklDhT9E@myon.chronox.de> <1CD8D5EC-1BAA-495E-B671-6423C3CA4104@holtmann.org> <4777180.cceLVNSOUa@myon.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <4777180.cceLVNSOUa@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: David Woodhouse <dwmw2@infradead.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

Hi Stephan,

>> So if a server has public/private key pair, then the first thing that should
>> the server do is load this key pair into the kernel and retrieve a key
>> serial for it. And then use this key id to derive the session key. That
>> session key can then be used with AF_ALG and skcipher for the data
>> shoveling.
>> 
>> However that all said, the keys should never leave the kernel. Neither the
> 
> I personally do not fully agree here. For our day-to-day desktops and servers 
> I would fully and completely agree. But I see other use cases of Linux in 
> routers or other embedded systems where there may be other checks and balances 
> in place where this hard demand is not warranted.

actually in embedded devices (especially the tiny IoT stuff I am looking after) I really want keys in a central place and do not have to copy them around all the time. Keeping keys secure is actually a hard job. Doing that multiple places in the kernel and in userspace seems not a good idea. Especially not for an embedded device.

The keys subsystem is great since it includes access control to your keys. If you have the right permissions you can get the keys back out if you want to. However if the key is locked down, you will not be able to read it again.

I mean the keys subsystem can operate on per user, per process and per thread keys and access rights. So the policy that you are after is already done nicely via the keys subsystem. I really don't think we are limiting anything here. We are actually giving users more choice for policy.

> Thus, I feel that this is a policy decision to be made in user space (see my 
> other email -- please answer on that topic there to keep a single thread).
> 
>> private key nor the session key. There is no point in sending keys through
>> userspace. We actually do not want this at all. That is especially
>> important if your actual private/public key pair is in hardware. So maybe
>> your RSA accelerator might expose secure storage for the keys. Loading them
>> over and over again from userspace makes no sense.
>> 
>> As David mentioned, we need to take a deep look at what the userspace API
>> for asymmetric cipher suites (and we also have needs for ECDH etc. and not
>> just RSA) should look like. Just exposing akcipher via AF_ALG is premature.
>> If we expose it now, it is not an API that we can take back. Having two
>> userspace APIs for the exactly the same functionality is a bad thing.
>> Especially if one is limited to software only keys.
> 
> Do not get me wrong, my patch is shall be there for all to comment. I have no 
> issues when we find a better solution. And I also do not like multiple 
> interfaces that would not be needed if we would have thought better.
>> 
>> We also need to look at the larger picture here. And that is TLS support in
>> the kernel. Potentially via AF_KCM or something similar.
> 
> With all due respect, I would object here. When we say yes to TLS (even if it 
> is parts of TLS up to the point where the KDF happens), we invite all higher 
> level crypto implementations: IKE, SNMP, SSH -- I would not want to go down 
> that path that started by simply supporting accelerated asymmetric ciphers.

Reality is that TLS in the kernel is happening. Reality is also that we do signing and certificate handling in the kernel. How much of the cipher negotiations and key derivation happens in kernel vs userspace is something to be still discussed. And there will be userspace involved for sure. However that does not mean that we keep moving keys through userspace to just load it back into another subsystem. That kind of API really needs to stop.

One other note I make is that we are looking at such tiny systems that including OpenSSL or GnuTLS is not an option at all. However we do use secure boot and need to be able to handle certificates and TLS.

> Look at user space crypto libs: where is the most fuzz happening? Not in the 
> cipher implementations, but in the network protocols.

Ciphers itself are easy of course. What we are saying here is that we do not have the cipher as the main important input on what to do. We have the key itself. The key decides what options for ciphers or fallback ciphers we have. So let me repeat this, we need to think really hard about supporting hardware keys. We need to see the bigger picture. Just looking at ciphers is not enough.

Regards

Marcel
