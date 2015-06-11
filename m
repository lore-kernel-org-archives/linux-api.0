From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v13 1/2] crypto: AF_ALG: add AEAD support
Date: Fri, 12 Jun 2015 01:03:50 +0200
Message-ID: <3778379.0alfAEIvmc@tauon.atsec.com>
References: <2180298.gqj58NYuqx@tachyon.chronox.de> <14853152.iudhcNpbrH@tachyon.chronox.de> <557A12D1.90409@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <557A12D1.90409-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Thursday 11 June 2015, 15:59:29 schrieb Tadeusz Struk:

Hi Tadeusz,

>Hi Stephan,
>
>On 02/28/2015 11:50 AM, Stephan Mueller wrote:
>> +	err = af_alg_wait_for_completion(ctx->enc ?
>> +					 crypto_aead_encrypt(&ctx->aead_req) :
>> +					 crypto_aead_decrypt(&ctx->aead_req),
>> +					 &ctx->completion);
>> +
>> +	if (err) {
>> +		/* EBADMSG implies a valid cipher operation took place */
>> +		if (err == -EBADMSG)
>> +			aead_put_sgl(sk);
>> +		goto unlock;
>
>Shouldn't we free the TX sgl regardless of the error was?
>Or do we expect that the user will try to read again and it will be Ok the
>second time? Hope you still remember :)

It is the latter: as the crypto was not completed properly, leave the data in 
memory. This may allow a user to send more data if he needs to for completing 
the AEAD operation.

Ciao
Stephan
