From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2] crypto: AF_ALG - add support for keys/asymmetric-type
Date: Sat, 16 Jan 2016 10:51:53 +0000
Message-ID: <5232.1452941513@warthog.procyon.org.uk>
References: <569677D6.7070704@intel.com> <20151226155014.27615.14985.stgit@desktop.home> <10464.1452691882@warthog.procyon.org.uk> <569659AC.9070506@intel.com> <1452697593.88154.49.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <569677D6.7070704@intel.com>
Content-ID: <5231.1452941513.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: dhowells@redhat.com, David Woodhouse <dwmw2@infradead.org>, Tadeusz Struk <tstruk@gmail.com>, herbert@gondor.apana.org.au, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
List-Id: linux-api@vger.kernel.org

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> I think the coupling of an algorithm to its key is the problem here.
> Usually an algorithm should be able to work with any (valid) key.

A key stored in hardware and used through that hardware won't necessarily
support all crypto operations - it may be restricted to just signing or just
encrypting for example.

> The solution to this can be implemented on the crypto API. 
> If the TMP driver would register its supported algorithms on the crypto API
> and in the setkey function it would check if a key is a real key or this
> "something" (probably a ptr to TMP dev instance?) then in the first
> case it would fallback to an implementation that takes a key data.
> In the second case it can do its thing whatever it is.

>From what Herbert has said, he won't go for that since the TPM keys are
restricted in the operations one can use the key for.

I think the crypto API is what we use when the key data is available to us in
the kernel - but it should be driven through the asymmetric key API.  You ask
the asymmetric key API to verify a key, say, then that will switch to the TPM
driver or to the software public key implementation.  The latter will then
load the appropriate crypto layer akcipher algorithm (eg. RSA) and use that -
where the akcipher implementation will either be a software one or will get
offloaded to some hardware that can do it - but that doesn't itself securely
hold the key.

David
