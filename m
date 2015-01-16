From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif - change algif_skcipher to be asynchronous
Date: Fri, 16 Jan 2015 13:00:52 +1100
Message-ID: <20150116020052.GB5851@gondor.apana.org.au>
References: <20150113202823.32244.45456.stgit@tstruk-mobl1>
 <20150114053805.GA15204@gondor.apana.org.au>
 <54B6A939.4070207@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54B6A939.4070207@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org, qat-linux@intel.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 14, 2015 at 09:36:57AM -0800, Tadeusz Struk wrote:
> 
> But then would you like to extend AIO interface to take the IV and
> something that would indicate the encrypt/decrypt operation on
> aio_write()? Also as far as I can see AIO doesn't support splice()

Any metadata such as the IV can still go through the existing
sendmsg interface, just as you would do a sendmsg before a sendfile
to set things up.

> operation for zero copy, which is the main thing here.

The AIO interface itself can accomodate zero-copy.  It's just that
we currently don't have any support for it in the network socket
API.

> >From the other hand it shouldn't be a problem to add crypto specific
> stuff to include/uapi/linux/if_alg.h, because it is all about crypto
> anyway, is it not?

Yes but you're violating the meaning of sendpage().  The latter
is not crypto-specific so you shouldn't be adding things that
prevent future optimisations to it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
