From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 01/10] crypto: AF_ALG: add user space interface for AEAD
Date: Wed, 19 Nov 2014 05:20:42 +0100
Message-ID: <2398701.sGeMzIcHaz@tachyon.chronox.de>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <11608519.pS4L9VjM2n@tachyon.chronox.de> <20141118140631.GA12100@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141118140631.GA12100@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, ABI/API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Am Dienstag, 18. November 2014, 22:06:31 schrieb Herbert Xu:

Hi Herbert,

> On Sun, Nov 16, 2014 at 03:23:50AM +0100, Stephan Mueller wrote:
> > AEAD requires the following data in addition to normal symmetric
> > 
> > ciphers:
> > 	* Associated authentication data of arbitrary length
> > 	
> > 	* Authentication tag for decryption
> > 	
> > 	* Length of authentication tag for encryption
> > 
> > The authentication tag data is communicated as part of the actual
> > ciphertext as mandated by the kernel crypto API. Therefore we only need
> > to provide a user space interface for the associated authentication data
> > as well as for the authentication tag length.
> > 
> > This patch adds both as a setsockopt interface that is identical to the
> > AF_ALG interface for setting an IV and for selecting the cipher
> > operation type (encrypt or decrypt).
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> I don't like the fact that we're putting arbitrary limits on
> the AD, as well as the fact that the way you're doing it the
> AD has to be copied.
> 
> How about simply saying that the first X bytes of the input
> shall be the AD?

When looking deeper into skcipher_sendmsg, I see that the input data is copied 
into the kernel using memcpy_fromiovec. The memory is allocated before the 
memcpy call by skcipher_alloc_sgl.

The AD is input data and therefore needs to be copied into the kernel just 
like plaintext. Of course it is possible to require user space to concatenate 
the AD with the plaintext (or ciphertext in case of decryption). However, I 
see the following drawbacks when we do that:

- either user space has to do a very good memory allocation or it has to copy 
the data into the buffer before the plaintext. Also, if the plaintext buffer 
is not allocated in the right way, even the plaintext has to be copied to the 
newly created buffer that concatenates the AD with the plaintext. So, unless 
user space is very careful, at least some memcpy must be done in user space to 
accommodate the requirement that AD and plaintext is concatenated.

- The kernel function of skcipher_sendmsg would now become very complicated, 
because a similar logic currently applied to plaintext needs to be also 
implemented to copy and track the initial AD into the kernel.

However I see your point as the sendmsg approach to handle AD currently 
implements two memcpy() calls: one is the copy_from_user of the sendmsg system 
call framework to copy in msg and then the memcpy in skcipher_sendmsg.

To avoid the cluttering of the skcipher_sendmsg function (which already is 
complex), may I propose that a setsockopt call is used just like the SET_IV 
call? When using the setsockopt call, I see the following advantages:

- only one memcpy (the copy_from_user) is needed to move the data into kernel 
land -- this would be then en-par with the skcipher_sendmsg approach.

- the implementation of the setsockopt approach would be very clean and small 
as just one copy_from_user call is to be made followed by a 
aead_request_set_assoc call.

- user space memory handling is very clean as user space does not need a very 
specific memory setup to deliver AD. So, if the memory layout is not as 
specific as needed for the AEAD call, with the setsockopt approach, we do not 
need additional memcpy calls in user space.

In any case, we need to set some upper boundary for the maximum size of the 
AD. As I do not know of any standardized upper limit for the AD size, I would 
consider the standard CAVP testing requirements. These tests have the maximum 
AD size of 1<<16. When using the setsockopt call approach we can allocate the 
in-kernel AD memory at the setsockopt call time. IMHO it would be save now to 
limit the maximum AD size to 1<<16 at this point.
> 
> Cheers,


-- 
Ciao
Stephan
