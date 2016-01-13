From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2] crypto: AF_ALG - add support for keys/asymmetric-type
Date: Wed, 13 Jan 2016 13:31:22 +0000
Message-ID: <10464.1452691882@warthog.procyon.org.uk>
References: <20151226155014.27615.14985.stgit@desktop.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151226155014.27615.14985.stgit@desktop.home>
Content-ID: <10462.1452691882.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Tadeusz Struk <tstruk@gmail.com>
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au, tadeusz.struk@intel.com, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com, dwmw2@infradead.org
List-Id: linux-api@vger.kernel.org

Tadeusz Struk <tstruk@gmail.com> wrote:

> +	pkey = keyring->payload.data[asym_crypto];
> +	if (!pkey) {
> +		key_put(keyring);
> +		goto out;
> +	}
> +
> +	err = setkey(private, pkey->key, pkey->keylen);
> +	key_put(keyring);

Note that you may not assume that there's data there that you can use in this
manner.  The key might be a pointer to some hardware device such as a TPM.  I
have a TPM asymmetric subtype in progress.

I think this really needs to be driven from a keyctl() because you need to let
the asymmetric subtype decide how it wants to handle this.  I would suggest
adding KEYCTL_{ASYM_GETINFO,SIGN,VERIFY,ENCRYPT,DECRYPT} - the problem is how
to pass sufficient arguments, how to decrypt the private key and what metadata
needs to be passed vs what is inline with the data.

David
