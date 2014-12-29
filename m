From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v6 3/4] crypto: AF_ALG: add random number generator
 support
Date: Mon, 29 Dec 2014 21:41:49 +1100
Message-ID: <20141229104149.GA13699@gondor.apana.org.au>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de>
 <2323421.LJnyPUDp59@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2323421.LJnyPUDp59-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 25, 2014 at 11:00:06PM +0100, Stephan Mueller wrote:
> This patch adds the random number generator support for AF_ALG.
> 
> A random number generator's purpose is to generate data without
> requiring the caller to provide any data. Therefore, the AF_ALG
> interface handler for RNGs only implements a callback handler for
> recvmsg.
> 
> The following parameters provided with a recvmsg are processed by the
> RNG callback handler:
> 
> 	* sock - to resolve the RNG context data structure accessing the
> 	  RNG instance private to the socket
> 
> 	* len - this parameter allows userspace callers to specify how
> 	  many random bytes the RNG shall produce and return. As the
> 	  kernel context for the RNG allocates a buffer of 128 bytes to
> 	  store random numbers before copying them to userspace, the len
> 	  parameter is checked that it is not larger than 128. If a
> 	  caller wants more random numbers, a new request for recvmsg
> 	  shall be made.
> 
> The size of 128 bytes is chose because of the following considerations:
> 
> 	* to increase the memory footprint of the kernel too much (note,
> 	  that would be 128 bytes per open socket)
> 
> 	* 128 is divisible by any typical cryptographic block size an
> 	  RNG may have
> 
> 	* A request for random numbers typically only shall supply small
> 	  amount of data like for keys or IVs that should only require
> 	  one invocation of the recvmsg function.
> 
> Note, during instantiation of the RNG, the code checks whether the RNG
> implementation requires seeding. If so, the RNG is seeded with output
> from get_random_bytes.
> 
> A fully working example using all aspects of the RNG interface is
> provided at http://www.chronox.de/libkcapi.html
> 
> Signed-off-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>

Patch applied.
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
