From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3 2/7] mm, slab/slub: introduce kmalloc-reclaimable
 caches
Date: Fri, 20 Jul 2018 11:35:04 +0200
Message-ID: <32c05b49-6703-08c2-bacf-ee070082d5ae@suse.cz>
References: <20180718133620.6205-1-vbabka@suse.cz>
 <20180718133620.6205-3-vbabka@suse.cz>
 <20180719181613.GA26595@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180719181613.GA26595@castle.DHCP.thefacebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@techsingularity.net>, Matthew Wilcox <willy@infradead.org>
List-Id: linux-api@vger.kernel.org

On 07/19/2018 08:16 PM, Roman Gushchin wrote:
>>  	is_dma = !!(flags & __GFP_DMA);
>>  #endif
>>  
>> -	return is_dma;
>> +	is_reclaimable = !!(flags & __GFP_RECLAIMABLE);
>> +
>> +	/*
>> +	 * If an allocation is botth __GFP_DMA and __GFP_RECLAIMABLE, return
>                                  ^^
> 			       typo
>> +	 * KMALLOC_DMA and effectively ignore __GFP_RECLAIMABLE
>> +	 */
>> +	return (is_dma * 2) + (is_reclaimable & !is_dma);
> 
> Maybe
> is_dma * KMALLOC_DMA + (is_reclaimable && !is_dma) * KMALLOC_RECLAIM
> looks better?

I think I meant to do that but forgot, thanks.

>>  }
>>  
>>  /*
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 4614248ca381..614fb7ab8312 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -1107,10 +1107,21 @@ void __init setup_kmalloc_cache_index_table(void)
>>  	}
>>  }
>>  
>> -static void __init new_kmalloc_cache(int idx, slab_flags_t flags)
>> +static void __init
>> +new_kmalloc_cache(int idx, int type, slab_flags_t flags)
>>  {
>> -	kmalloc_caches[KMALLOC_NORMAL][idx] = create_kmalloc_cache(
>> -					kmalloc_info[idx].name,
>> +	const char *name;
>> +
>> +	if (type == KMALLOC_RECLAIM) {
>> +		flags |= SLAB_RECLAIM_ACCOUNT;
>> +		name = kasprintf(GFP_NOWAIT, "kmalloc-rcl-%u",
>> +						kmalloc_info[idx].size);
>> +		BUG_ON(!name);
> 
> I'd replace this with WARN_ON() and falling back to kmalloc_info[idx].name.

It's basically a copy/paste of the dma-kmalloc code. If that triggers,
it means somebody was changing the code and introduced a wrong order (as
Mel said). A system that genuinely has no memory for that printf at this
point, would not get very far anyway...

>> +	} else {
>> +		name = kmalloc_info[idx].name;
>> +	}
>> +
>> +	kmalloc_caches[type][idx] = create_kmalloc_cache(name,
>>  					kmalloc_info[idx].size, flags, 0,
>>  					kmalloc_info[idx].size);
>>  }
