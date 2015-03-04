From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v13 0/2] crypto: AF_ALG: add AEAD support
Date: Wed, 4 Mar 2015 22:16:32 +1300
Message-ID: <20150304091632.GB9195@gondor.apana.org.au>
References: <2180298.gqj58NYuqx@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2180298.gqj58NYuqx@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: 'Quentin Gouchet' <quentin.gouchet@gmail.com>, Daniel Borkmann <dborkman@redhat.com>, linux-api@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, Feb 28, 2015 at 08:49:22PM +0100, Stephan Mueller wrote:
> Hi,
> 
> This patch set adds AEAD support to the AF_ALG interface
> exported by the kernel crypto API.
> 
> The AEAD implementation uses the same approach as provided with
> skcipher by offering the following interfaces:
> 
> 	* sendmsg and recvmsg interfaces allowing multiple
> 	  invocations supporting a threaded user space. To support
> 	  multi-threaded user space, kernel-side buffering
> 	  is implemented similarly to skcipher.
> 
> 	* splice / vmsplice interfaces allowing a zero-copy
> 	  invocation
> 
> The new AEAD interface is fully tested with the test application
> provided at [1]. That test application exercises all newly added user space
> interfaces. The testing covers:
> 
> 	* use of the sendmsg/recvmsg interface
> 
> 	* use of the splice / vmsplice interface
> 
> 	* invocation of all AF_ALG types (aead, rng, skcipher, hash)
> 
> 	* using all types of operation (encryption, decryption, keyed MD,
> 	  MD, random numbers, AEAD decryption with positive and negative
> 	  authentication verification)
> 
> 	* stress testing by running all tests for 30 minutes in an
> 	  endless loop
> 
> 	* test execution on 64 bit and 32 bit

All applied.  Thanks a lot for your hard work!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
