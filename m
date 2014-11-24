From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 5/7] crypto: AF_ALG: add random number generator support
Date: Mon, 24 Nov 2014 16:08:51 +0100
Message-ID: <1924093.6oedGBDXii@tauon>
References: <4088013.2O8zCP0xXa@tachyon.chronox.de> <2490914.nzfN9gyyGH@tachyon.chronox.de> <20141124143150.GC31469@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20141124143150.GC31469@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>, 'Quentin Gouchet' <quentin.gouchet@gmail.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Am Montag, 24. November 2014, 22:31:50 schrieb Herbert Xu:

Hi Herbert,

>On Fri, Nov 21, 2014 at 06:32:52AM +0100, Stephan Mueller wrote:
>> This patch adds the random number generator support for AF_ALG.
>> 
>> A random number generator's purpose is to generate data without
>> requiring the caller to provide any data. Therefore, the AF_ALG
>> interface handler for RNGs only implements a callback handler for
>> recvmsg.
>> 
>> The following parameters provided with a recvmsg are processed by the
>> 
>> RNG callback handler:
>>         * sock - to resolve the RNG context data structure accessing
>>         the
>>         
>>           RNG instance private to the socket
>>         
>>         * len - this parameter allows userspace callers to specify
>>         how
>>         
>>           many random bytes the RNG shall produce and return. As the
>>           kernel context for the RNG allocates a buffer of 128 bytes
>>           to
>>           store random numbers before copying them to userspace, the
>>           len
>>           parameter is checked that it is not larger than 128. If a
>>           caller wants more random numbers, a new request for recvmsg
>>           shall be made.
>> 
>> The size of 128 bytes is chose because of the following 
considerations:
>>         * to increase the memory footprint of the kernel too much
>>         (note,
>>         
>>           that would be 128 bytes per open socket)
>>         
>>         * 128 is divisible by any typical cryptographic block size an
>>         
>>           RNG may have
>>         
>>         * A request for random numbers typically only shall supply
>>         small
>>         
>>           amount of data like for keys or IVs that should only
>>           require
>>           one invocation of the recvmsg function.
>> 
>> Note, during instantiation of the RNG, the code checks whether the
>> RNG
>> implementation requires seeding. If so, the RNG is seeded with output
>> from get_random_bytes.
>> 
>> A fully working example using all aspects of the RNG interface is
>> provided at http://www.chronox.de/libkcapi.html
>> 
>> Signed-off-by: Stephan Mueller <smueller@chronox.de>
>
>Sorry but who is going to use this and for what purpose?
>
>Every other algif interface exports real hardware features that
>cannot otherwise be accessed from user-space.  All crypto RNGs
>are by definition software-only, so what is the point of this?


My idea is twofold: The software-RNGs currently available (X9.31 and 
DRBG) use other ciphers as backends. Therefore, they can be considered 
as transforms on top of these backend ciphers. Now, if these backend 
ciphers are available in kernel mode only, currently only these in-
kernel RNGs can use the hardware.

With the consideration of AEAD, all ciphers supported by the kernel 
crypto API are available to user space. That means, there is no need for 
an additional crypto library in user space in addition to provide 
hardware access. The RNG part is there to complement the case for not 
needing an additional crypto lib in user space.

Ciao
Stephan
