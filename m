From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif - change algif_skcipher to be asynchronous
Date: Wed, 14 Jan 2015 16:38:05 +1100
Message-ID: <20150114053805.GA15204@gondor.apana.org.au>
References: <20150113202823.32244.45456.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150113202823.32244.45456.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org, qat-linux@intel.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 13, 2015 at 12:28:23PM -0800, Tadeusz Struk wrote:
> The way the algif_skcipher works currently is that on sendmsg/sendpage it
> builds an sgl for the input data and then on read/recvmsg it sends the job
> for encryption putting the user to sleep till the data is processed.
> This way it can only handle one job at a given time.
> This patch changes it to be asynchronous.
> The idea is to allow enqueue multiple jobs to get most of available crypto HW
> accelerators and then read when the data is processed without blocking.
> To allow that both the input and output sgl need to be know at sendmsg/sendpage
> or the operation needs to happen "in place" in the input sgl. The approach here
> is to use the "in place" operation and process the data in the sgl provided in
> sendmsg. To allow that new user visible flags are introduced:
> ALG_SET_OP_TYPE
> ALG_OP_OUTOF_PLACE
> ALG_OP_IN_PLACE
> By default the operation type is ALG_OP_OUTOF_PLACE, which works the same way as
> without the change and allows existing application working without any update.
> 
> Using the test application from https://lkml.org/lkml/2011/8/28/87 with small
> modification to support in place operation, and reading after every 16th
> sendmsg these are the results:

What you want is AIO so we should try to use that interface rather
than creating some funky crypto-specific interface.

Dave, the AIO hooks in net/socket.c is currently simply pointing
to the sync implementation.  What are you thoughts on allowing
socket implementations to supply these hooks?

The algif interface can then use these hooks to implement AIO
which is useful for maximising the hardware performance without
resorting to loads of threads.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
