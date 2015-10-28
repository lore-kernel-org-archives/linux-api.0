From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Wed, 28 Oct 2015 02:29:59 +0100
Message-ID: <4777180.cceLVNSOUa@myon.chronox.de>
References: <1831785.BBs8Hj3CxY@myon.chronox.de> <1885267.SGBklDhT9E@myon.chronox.de> <1CD8D5EC-1BAA-495E-B671-6423C3CA4104@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1CD8D5EC-1BAA-495E-B671-6423C3CA4104@holtmann.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 28. Oktober 2015, 09:46:51 schrieb Marcel Holtmann:

Hi Marcel,

> So if a server has public/private key pair, then the first thing that should
> the server do is load this key pair into the kernel and retrieve a key
> serial for it. And then use this key id to derive the session key. That
> session key can then be used with AF_ALG and skcipher for the data
> shoveling.
> 
> However that all said, the keys should never leave the kernel. Neither the

I personally do not fully agree here. For our day-to-day desktops and servers 
I would fully and completely agree. But I see other use cases of Linux in 
routers or other embedded systems where there may be other checks and balances 
in place where this hard demand is not warranted.

Thus, I feel that this is a policy decision to be made in user space (see my 
other email -- please answer on that topic there to keep a single thread).

> private key nor the session key. There is no point in sending keys through
> userspace. We actually do not want this at all. That is especially
> important if your actual private/public key pair is in hardware. So maybe
> your RSA accelerator might expose secure storage for the keys. Loading them
> over and over again from userspace makes no sense.
> 
> As David mentioned, we need to take a deep look at what the userspace API
> for asymmetric cipher suites (and we also have needs for ECDH etc. and not
> just RSA) should look like. Just exposing akcipher via AF_ALG is premature.
> If we expose it now, it is not an API that we can take back. Having two
> userspace APIs for the exactly the same functionality is a bad thing.
> Especially if one is limited to software only keys.

Do not get me wrong, my patch is shall be there for all to comment. I have no 
issues when we find a better solution. And I also do not like multiple 
interfaces that would not be needed if we would have thought better.
> 
> We also need to look at the larger picture here. And that is TLS support in
> the kernel. Potentially via AF_KCM or something similar.

With all due respect, I would object here. When we say yes to TLS (even if it 
is parts of TLS up to the point where the KDF happens), we invite all higher 
level crypto implementations: IKE, SNMP, SSH -- I would not want to go down 
that path that started by simply supporting accelerated asymmetric ciphers.

Look at user space crypto libs: where is the most fuzz happening? Not in the 
cipher implementations, but in the network protocols.


-- 
Ciao
Stephan
