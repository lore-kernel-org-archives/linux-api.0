From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v3 1/7] crypto: AF_ALG: add user space interface for AEAD
Date: Mon, 24 Nov 2014 22:26:39 +0800
Message-ID: <20141124142639.GA31469@gondor.apana.org.au>
References: <4088013.2O8zCP0xXa@tachyon.chronox.de>
 <5694690.RURGUoE58b@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5694690.RURGUoE58b-PJstQz4BMNNP20K/wil9xYQuADTiUCJX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Cc: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Quentin Gouchet' <quentin.gouchet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lkml - Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 21, 2014 at 06:30:18AM +0100, Stephan Mueller wrote:
>
> @@ -421,6 +421,18 @@ int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
>  			con->op = *(u32 *)CMSG_DATA(cmsg);
>  			break;
>  
> +		case ALG_SET_AEAD_AUTHSIZE:
> +			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
> +				return -EINVAL;
> +			con->aead_authsize = *(u32 *)CMSG_DATA(cmsg);
> +			break;

This is a tfm attribute so it should go into setsockopt.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
