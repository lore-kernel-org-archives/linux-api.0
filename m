From: Mat Martineau <mathew.j.martineau-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RESEND v5 6/6] crypto: AF_ALG - add support for key_id
Date: Fri, 13 May 2016 16:32:35 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1605131616200.29074@mjmartin-mac01.local>
References: <20160505195048.1843.7817.stgit@tstruk-mobl1> <20160505195120.1843.35821.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160505195120.1843.35821.stgit@tstruk-mobl1>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
List-Id: linux-api@vger.kernel.org


Tadeusz -

David updated the keys-asym-keyctl branch, and this patch set won't build 
any more.

On Thu, 5 May 2016, Tadeusz Struk wrote:

> diff --git a/crypto/algif_akcipher.c b/crypto/algif_akcipher.c
> index e00793d..f486b6d 100644
> --- a/crypto/algif_akcipher.c
> +++ b/crypto/algif_akcipher.c
> +static int asym_key_encrypt(const struct key *key, struct akcipher_request *req)
...
> +	params.data_len = req->src_len;
> +	params.enc_len = req->dst_len;

The params member names have changed (now in_len and out_len).

> +	ret = encrypt_blob(&params, in, out);

The encrypt function for the key can now be called with 
params.key->type->asym_eds_op(). This also allows you to factor out the 
duplication in asym_key_encrypt, asym_key_decrypt, and asym_key_sign. See 
keyctl_pkey_e_d_s() in keyctl_pkey.c

> +static int asym_key_verify(const struct key *key, struct akcipher_request *req)
...
> +	ret = verify_signature(key, NULL, &sig);

key->type->asym_verify_signature() is available as well.


Regards,

--
Mat Martineau
Intel OTC
