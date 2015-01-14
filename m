From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: algif - change algif_skcipher to be asynchronous
Date: Wed, 14 Jan 2015 09:36:57 -0800
Message-ID: <54B6A939.4070207@intel.com>
References: <20150113202823.32244.45456.stgit@tstruk-mobl1> <20150114053805.GA15204@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20150114053805.GA15204@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org, qat-linux@intel.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Herbert,
On 01/13/2015 09:38 PM, Herbert Xu wrote:
> What you want is AIO so we should try to use that interface rather
> than creating some funky crypto-specific interface.
> 
> Dave, the AIO hooks in net/socket.c is currently simply pointing
> to the sync implementation.  What are you thoughts on allowing
> socket implementations to supply these hooks?
> 
> The algif interface can then use these hooks to implement AIO
> which is useful for maximising the hardware performance without
> resorting to loads of threads.

But then would you like to extend AIO interface to take the IV and
something that would indicate the encrypt/decrypt operation on
aio_write()? Also as far as I can see AIO doesn't support splice()
operation for zero copy, which is the main thing here.

>From the other hand it shouldn't be a problem to add crypto specific
stuff to include/uapi/linux/if_alg.h, because it is all about crypto
anyway, is it not?

If you have a better way how to indicate that data processing should
start on the last page in sendpage() instead of ALG_OP_IN_PLACE I would
be happy to use it.
Thanks,
Tadeusz
