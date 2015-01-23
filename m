From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] crypto: algif - change algif_skcipher to be asynchronous
Date: Fri, 23 Jan 2015 14:40:56 -0800
Message-ID: <54C2CDF8.3000406@intel.com>
References: <20150113202823.32244.45456.stgit@tstruk-mobl1> <20150114053805.GA15204@gondor.apana.org.au> <54B6A939.4070207@intel.com> <20150116020052.GB5851@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150116020052.GB5851-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qat-linux-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/15/2015 06:00 PM, Herbert Xu wrote:
>> But then would you like to extend AIO interface to take the IV and
>> > something that would indicate the encrypt/decrypt operation on
>> > aio_write()? Also as far as I can see AIO doesn't support splice()
> Any metadata such as the IV can still go through the existing
> sendmsg interface, just as you would do a sendmsg before a sendfile
> to set things up.
> 
>> > operation for zero copy, which is the main thing here.
> The AIO interface itself can accomodate zero-copy.  It's just that
> we currently don't have any support for it in the network socket
> API.
> 
Hi,
Ok, It looks to me that we *do* have all we need to implement zero copy
and AIO with algif_skcipher. The only thing we need to do is to add
support for it in skcipher_recvmsg(). I think no change is required in
neither skcipher_sendmsg(), skcipher_sendpage(), nor the if_alg interface.
Then to start using the interface asynchronously an application will
need to call aio_read() or lio_listio() instead of read(), but if
someone will use read(), then it will still work in the same
(synchronous) way as it is today.
How does this sound to you, Herbert?
I'll send a v2 shortly.
Thanks,
Tadeusz
