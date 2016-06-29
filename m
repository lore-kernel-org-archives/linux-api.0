From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH v8 6/6] crypto: AF_ALG - add support for key_id
Date: Wed, 29 Jun 2016 11:43:20 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1606291104130.37168@mjmartin-mac01.local>
References: <146672252642.23101.15972023870303797249.stgit@tstruk-mobl1.ra.intel.com> <146672255872.23101.10938182451423661314.stgit@tstruk-mobl1.ra.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <146672255872.23101.10938182451423661314.stgit@tstruk-mobl1.ra.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, mathew.j.martineau@linux.intel.com, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org


Tadeusz,

On Thu, 23 Jun 2016, Tadeusz Struk wrote:

> This patch adds support for asymmetric key type to AF_ALG.
> It will work as follows: A new PF_ALG socket options are
> added on top of existing ALG_SET_KEY and ALG_SET_PUBKEY, namely
> ALG_SET_KEY_ID and ALG_SET_PUBKEY_ID for setting public and
> private keys respectively. When these new options will be used
> the user, instead of providing the key material, will provide a
> key id and the key itself will be obtained from kernel keyring
> subsystem. The user will use the standard tools (keyctl tool
> or the keyctl syscall) for key instantiation and to obtain the
> key id. The key id can also be obtained by reading the
> /proc/keys file.
>
> When a key corresponding to the given keyid is found, it is stored
> in the socket context and subsequent crypto operation invoked by the
> user will use the new asymmetric accessor functions instead of akcipher
> api. The asymmetric subtype can internally use akcipher api or
> invoke operations defined by a given subtype, depending on the
> key type.
>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
> crypto/af_alg.c             |   10 ++
> crypto/algif_akcipher.c     |  212 ++++++++++++++++++++++++++++++++++++++++++-
> include/crypto/if_alg.h     |    1
> include/uapi/linux/if_alg.h |    2
> 4 files changed, 220 insertions(+), 5 deletions(-)
>
> diff --git a/crypto/algif_akcipher.c b/crypto/algif_akcipher.c
> index 2b8d37e..106f715 100644
> --- a/crypto/algif_akcipher.c
> +++ b/crypto/algif_akcipher.c
> +static int asym_key_verify(const struct key *key, struct akcipher_request *req)
> +{
> +	struct public_key_signature sig;
> +	char *src = NULL, *in, digest[20];
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

Comment still needed?

> +	sig.hash_algo = "sha1";
> +	sig.digest_size = sizeof(digest);
> +	sig.digest = digest;
> +	sig.s_size = req->src_len;
> +	sig.s = src;
> +	ret = verify_signature(key, &sig);
> +	if (!ret) {
> +		req->dst_len = sizeof(digest);

I think you fixed the BUG_ON() problem but there's still an issue with the 
handling of the digest. Check the use of sig->digest in 
public_key_verify_signature(), it's an input not an output. Right now it 
looks like 20 uninitialized bytes are compared with the computed digest 
within verify_signature, and then the unintialized bytes are copied to 
req->dst here.

With some modifications to public_key_verify_signature you could get the 
digest you need, but I'm not sure if verification with a hardware key 
(like a key in a TPM) can or can not provide the digest needed. Maybe this 
is why the verify_signature hook in struct asymmetric_key_subtype is 
optional.

> +		scatterwalk_map_and_copy(digest, req->dst, 0, req->dst_len, 1);
> +	}
> +	kfree(src);
> +	return ret;
> +}
> +

--
Mat Martineau
Intel OTC
