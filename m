From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 2/5] lib/rhashtable: guarantee initial hashtable
 allocation
Date: Fri, 1 Jun 2018 22:41:31 -0700
Message-ID: <20180602054131.ta7ligrfwbgvemfv@linux-r8p5>
References: <20180601160125.30031-1-dave@stgolabs.net>
 <20180601160125.30031-3-dave@stgolabs.net>
 <20180602044150.xpazuhpxbwt37xmu@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180602044150.xpazuhpxbwt37xmu@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, manfred@colorfullife.com, mhocko@kernel.org, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Sat, 02 Jun 2018, Herbert Xu wrote:
>>  	tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
>> -	if (tbl == NULL)
>> -		return -ENOMEM;
>> +	if (unlikely(tbl == NULL)) {
>> +		size = min_t(u16, ht->p.min_size, HASH_MIN_SIZE);
>
>You mean max_t?

Not really. I considered some of the users to set quite a large min_size
(such as 1024 buckets). The min() makes sense to me in that it's the smallest
possible value. If memory later becomes available and the hashtable is resized
to a more appropriate value, couldn't any issues regarding collisions not be dealt
with organically? And we've agreed that allocating a tiny table is the
least of our problems.

Thanks,
Davidlohr
