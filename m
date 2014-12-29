From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v6 1/4] crypto: AF_ALG: add AEAD support
Date: Mon, 29 Dec 2014 16:05:40 +0100
Message-ID: <29582980.qoHS2EjmLy@tachyon.chronox.de>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de> <5002301.TQO37u96dE@tachyon.chronox.de> <20141229103319.GB13334@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141229103319.GB13334-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Montag, 29. Dezember 2014, 21:33:19 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Dec 25, 2014 at 11:01:47PM +0100, Stephan Mueller wrote:
> > +	err = -ENOMEM;
> 
> This should be EINVAL.

Changed
> 
> > +	if (!aead_sufficient_data(ctx))
> > +		goto unlock;
> 
> So we're checking two things here, one that we have enough data
> for AD and two we have the authentication tag.  The latter is
> redundant as the underlying implementation should be able to cope
> with short input so we should only check the assoclen here.

Agreed, will change it to

if (ctx->used < ctx->aead_assoclen)

> 
> Also this check should be moved to the sendmsg side as that'll
> make it more obvious as to what went wrong.

I would be a bit uneasy about that as this would open up a potential kernel 
crasher: the sleep in aead_readable() can wake up recvmsg in two conditions: 
either we received sufficient data or we do not expect more data (due to !ctx-
>more). If the latter triggers, we still may have insufficient AD data. Yet, 
the following code now sets the AD with aead_request_set_assoc using the 
initially expected data. So, the data buffer provided to  
aead_request_set_assoc is not long enough. The mentioned check shall prevent 
this problem.

In addition, I do not see how we can move that check to the sendmsg/sendpage 
side: the code currently allows the caller to freely invoke the syscall 
arbitrary amount of times. Thus, one particular invocation of sendmsg/sendpage 
does not mean we receive all AD.

Again, to allow the caller the greatest degree of freedom, you can call 
sendmsg with an arbitrary amount of bytes as often as you want (until we fill 
up all buffers) before the recvmsg is triggered. So, there is no need to send 
the entire AD (or even AD+message) buffer in one sendmsg call. Compare the 
AEAD interface with a hash interface:

- the AEAD sendmsg/sendpage is logically equivalent to a hash update that you 
can call an arbitrary number of times with an arbitrary number of bytes.

- the AEAD recvmsg is logically equivalent to the hash final.

This would mean that the check must stay in recvmsg as only here we know that 
the caller wants data to be processed.

> 
> PS we should add a length check for missing/partial auth tags
> to crypto_aead_decrypt.  We can then remove such checks from
> individual implementations.

I agree in full here. Shall I create such a patch together with the AEAD 
AF_ALG interface, or can we merge the AEAD without that patch now and create a 
separate patch later?
> 
> Thanks,


-- 
Ciao
Stephan
