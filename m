From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH v6 6/6] crypto: AF_ALG - add support for key_id
Date: Wed, 25 May 2016 17:45:48 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1605251640370.12130@mjmartin-mac01.local>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1> <20160515041719.15888.27170.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160515041719.15888.27170.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org


On Sat, 14 May 2016, Tadeusz Struk wrote:

> diff --git a/crypto/algif_akcipher.c b/crypto/algif_akcipher.c
> index e00793d..6733df1 100644
> --- a/crypto/algif_akcipher.c
> +++ b/crypto/algif_akcipher.c
> +static int asym_key_verify(const struct key *key, struct akcipher_request *req)
> +{
> +	struct public_key_signature sig;
> +	char *src = NULL, *in;
> +	int ret;
> +
> +	if (!sg_is_last(req->src)) {
> +		src = kmalloc(req->src_len, GFP_KERNEL);
> +		if (!src)
> +			return -ENOMEM;
> +		scatterwalk_map_and_copy(src, req->src, 0, req->src_len, 0);
> +		in = src;
> +	} else {
> +		in = sg_virt(req->src);
> +	}
> +	sig.pkey_algo = "rsa";
> +	sig.encoding = "pkcs1";
> +	/* Need to find a way to pass the hash param */

Are you referring to sig.digest here? It looks like you will hit a 
BUG_ON() in public_key_verify_signature() if sig.digest is 0. However, 
sig.digest is unlikely to be 0 because the struct is not cleared - should 
fix this, since public_key_verify_signature() will try to follow that 
random pointer.

> +	sig.hash_algo = "sha1";
> +	sig.digest_size = 20;
> +	sig.s_size = req->src_len;
> +	sig.s = src;
> +	ret = verify_signature(key, NULL, &sig);

Is the idea to write the signature to the socket, and then read out the 
expected digest (the digest comparison being done elsewhere)? Is that 
something that will be supported by a future hardware asymmetric key 
subtype?

verify_signature() ends up calling public_key_verify_signature(), which 
currently expects to get both the digest and signature as input and 
returns an error if verification fails. The output of 
crypto_akcipher_verify() is discarded before public_key_verify_signature() 
returns so nothing ends up in req->dst to read from the socket.

ALG_OP_VERIFY should behave the same whether using ALG_SET_PUBKEY or 
ALG_SET_PUBKEY_ID, and they aren't right now.

If sig.digest is 0, verify_signature() could return the expected digest in 
the sig structure and skip the digest comparison it currently does. Then 
that data could be packaged up in req as if crypto_akcipher_verify() had 
been called. I don't know if this change confuses the semantics of 
verify_signature() too much, maybe a new function is required with all the 
requisite plumbing to the asymmetric key subtype.
