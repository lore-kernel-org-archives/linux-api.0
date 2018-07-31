From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3 7/7] mm, slab: shorten kmalloc cache names for large
 sizes
Date: Tue, 31 Jul 2018 10:55:39 +0200
Message-ID: <9e019ae9-b6a8-c824-8913-dd02a8e6e6ce@suse.cz>
References: <20180718133620.6205-1-vbabka@suse.cz>
 <20180718133620.6205-8-vbabka@suse.cz>
 <01000164ebe0d06f-8f639717-8d32-4eb9-9cc1-708332b12ca6-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <01000164ebe0d06f-8f639717-8d32-4eb9-9cc1-708332b12ca6-000000@email.amazonses.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@techsingularity.net>, Matthew Wilcox <willy@infradead.org>
List-Id: linux-api@vger.kernel.org

On 07/30/2018 05:48 PM, Christopher Lameter wrote:
> On Wed, 18 Jul 2018, Vlastimil Babka wrote:
> 
>> +static const char *
>> +kmalloc_cache_name(const char *prefix, unsigned int size)
>> +{
>> +
>> +	static const char units[3] = "\0kM";
>> +	int idx = 0;
>> +
>> +	while (size >= 1024 && (size % 1024 == 0)) {
>> +		size /= 1024;
>> +		idx++;
>> +	}
>> +
>> +	return kasprintf(GFP_NOWAIT, "%s-%u%c", prefix, size, units[idx]);
>> +}
> 
> This is likely to occur elsewhere in the kernel. Maybe generalize it a
> bit?

I'll try later on top, as that's generic printf code then.

> Acked-by: Christoph Lameter <cl@linux.com>

Thanks for all acks.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
