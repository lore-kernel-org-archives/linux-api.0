From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v4 6/7] crypto: KEYS - add generic handlers to symmetric key type
Date: Tue, 12 Apr 2016 23:10:46 +0100
Message-ID: <16339.1460499046@warthog.procyon.org.uk>
References: <20160401013819.16799.38454.stgit@tstruk-mobl1> <20160401013745.16799.91093.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160401013819.16799.38454.stgit@tstruk-mobl1>
Content-ID: <16338.1460499046.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> +/**
> + * asymmetric_key_verify_signature - invoke verify signature operation on a key
> + *			             of the asymmetric subtype
> + * @key: key from the system keyring
> + * @sig: signature to verify
> + *
> + * return: 0 on success or errno on failure
> + */
> +int asymmetric_key_verify_signature(const struct key *key,
> +				    const struct public_key_signature *sig)

This is duplicating what's in signature.c in the same directory.

David
