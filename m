From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v13 1/2] crypto: AF_ALG: add AEAD support
Date: Thu, 11 Jun 2015 15:59:29 -0700
Message-ID: <557A12D1.90409@intel.com>
References: <2180298.gqj58NYuqx@tachyon.chronox.de> <14853152.iudhcNpbrH@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <14853152.iudhcNpbrH-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: 'Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Stephan,
On 02/28/2015 11:50 AM, Stephan Mueller wrote:
> +	err = af_alg_wait_for_completion(ctx->enc ?
> +					 crypto_aead_encrypt(&ctx->aead_req) :
> +					 crypto_aead_decrypt(&ctx->aead_req),
> +					 &ctx->completion);
> +
> +	if (err) {
> +		/* EBADMSG implies a valid cipher operation took place */
> +		if (err == -EBADMSG)
> +			aead_put_sgl(sk);
> +		goto unlock;

Shouldn't we free the TX sgl regardless of the error was?
Or do we expect that the user will try to read again and it will be Ok the second time?
Hope you still remember :)

> +	}
> +
> +	aead_put_sgl(sk);
> +
> +	err = 0;
> +
> +unlock:
> +	for (i = 0; i < cnt; i++)
> +		af_alg_free_sg(&ctx->rsgl[i]);
> +
> +	aead_wmem_wakeup(sk);
> +	release_sock(sk);
> +
> +	return err ? err : outlen;
> +}
