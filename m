From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH] crypto: algif - change algif_skcipher to be asynchronous
Date: Mon, 26 Jan 2015 13:57:44 +1100
Message-ID: <20150126025744.GH19796@gondor.apana.org.au>
References: <20150113202823.32244.45456.stgit@tstruk-mobl1>
 <20150114053805.GA15204@gondor.apana.org.au>
 <54B6A939.4070207@intel.com>
 <20150116020052.GB5851@gondor.apana.org.au>
 <54C2CDF8.3000406@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54C2CDF8.3000406-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qat-linux-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 23, 2015 at 02:40:56PM -0800, Tadeusz Struk wrote:
>
> Ok, It looks to me that we *do* have all we need to implement zero copy
> and AIO with algif_skcipher. The only thing we need to do is to add
> support for it in skcipher_recvmsg(). I think no change is required in
> neither skcipher_sendmsg(), skcipher_sendpage(), nor the if_alg interface.
> Then to start using the interface asynchronously an application will
> need to call aio_read() or lio_listio() instead of read(), but if
> someone will use read(), then it will still work in the same
> (synchronous) way as it is today.
> How does this sound to you, Herbert?

It sounds good but let's see the code first :)
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
