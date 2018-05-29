From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 2/6] lib/rhashtable: guarantee initial hashtable
 allocation
Date: Tue, 29 May 2018 10:03:38 -0700
Message-ID: <20180529170338.7brp2m2k4gfqwf64@linux-n805>
References: <20180524211135.27760-1-dave@stgolabs.net>
 <20180524211135.27760-3-dave@stgolabs.net>
 <20180528094956.zaxusqqju3wtbdcz@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180528094956.zaxusqqju3wtbdcz@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Mon, 28 May 2018, Herbert Xu wrote:
>> +	/*
>> +	 * This is api initialization and thus we need to guarantee the
>> +	 * initial rhashtable allocation. Upon failure, retry with a
>> +	 * smallest possible size, otherwise we exhaust our options with
>> +	 * __GFP_NOFAIL.
>> +	 */
>>  	tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
>> -	if (tbl == NULL)
>> -		return -ENOMEM;
>> +	if (unlikely(tbl == NULL)) {
>> +		size = HASH_MIN_SIZE;
>> +
>> +		tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
>> +		if (tbl == NULL)
>> +			tbl = bucket_table_alloc_retry(ht, size, GFP_KERNEL);
>> +	}
>
>Perhaps you should also explain here why we don't just try the
>minimum size with __GFP_NOFAIL as the second step rather than the
>third.

Please see the comment above, I try to explain the rationale.

Thanks,
Davidlohr
