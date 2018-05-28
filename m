From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/6] lib/rhashtable: guarantee initial hashtable
 allocation
Date: Mon, 28 May 2018 18:02:37 +0800
Message-ID: <20180528100237.needq2u5e3v2n642@gondor.apana.org.au>
References: <20180524211135.27760-1-dave@stgolabs.net>
 <20180524211135.27760-3-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180524211135.27760-3-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Thu, May 24, 2018 at 02:11:31PM -0700, Davidlohr Bueso wrote:
>
> +	/*
> +	 * This is api initialization and thus we need to guarantee the
> +	 * initial rhashtable allocation. Upon failure, retry with a
> +	 * smallest possible size, otherwise we exhaust our options with
> +	 * __GFP_NOFAIL.
> +	 */
>  	tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
> -	if (tbl == NULL)
> -		return -ENOMEM;
> +	if (unlikely(tbl == NULL)) {
> +		size = HASH_MIN_SIZE;

You should also take min_size into account.  Yes I know the current
code ignores it unless you also set nelem_hint.  But that's just a
bug.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
