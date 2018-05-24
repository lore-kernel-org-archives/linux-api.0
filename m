From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH 0/5] kmalloc-reclaimable caches
Date: Thu, 24 May 2018 11:40:59 -0700
Message-ID: <cfb7c8df-2a6a-bf84-8a30-df97c58c9c47@infradead.org>
References: <20180524110011.1940-1-vbabka@suse.cz>
 <20180524114350.GA10323@bombadil.infradead.org>
 <0944e1ed-60fe-36ce-ea06-936b3f595d5f@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0944e1ed-60fe-36ce-ea06-936b3f595d5f@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@techsingularity.net>, Vijayanand Jitta <vjitta@codeaurora.org>
List-Id: linux-api@vger.kernel.org

On 05/24/2018 09:18 AM, Randy Dunlap wrote:
> On 05/24/2018 04:43 AM, Matthew Wilcox wrote:
>> On Thu, May 24, 2018 at 01:00:06PM +0200, Vlastimil Babka wrote:
>>> Now for the issues a.k.a. why RFC:
>>>
>>> - I haven't find any other obvious users for reclaimable kmalloc (yet)
>>
>> Is that a problem?  This sounds like it's enough to solve Facebook's
>> problem.
>>
>>> - the name of caches kmalloc-reclaimable-X is rather long
>>
>> Yes; Christoph and I were talking about restricting slab names to 16 bytes
>> just to make /proc/slabinfo easier to read.  How about
>>
>> kmalloc-rec-128k
>> 1234567890123456
>>
>> Just makes it ;-)
>>
>> Of course, somebody needs to do the work to use k/M instead of 4194304.
>> We also need to bikeshed about when to switch; should it be:
>>
>> kmalloc-rec-512
>> kmalloc-rec-1024
>> kmalloc-rec-2048
>> kmalloc-rec-4096
>> kmalloc-rec-8192
>> kmalloc-rec-16k
>>
>> or should it be
>>
>> kmalloc-rec-512
>> kmalloc-rec-1k
>> kmalloc-rec-2k
>> kmalloc-rec-4k
>> kmalloc-rec-8k
>> kmalloc-rec-16k
>>
>> I slightly favour the latter as it'll be easier to implement.  Something like
> 
> Yes, agree, start using the suffix early.
> 
>>
>> 	static const char suffixes[3] = ' kM';
>> 	int idx = 0;
>>
>> 	while (size > 1024) {

I would use   (size >= 1024)
so that 1M is printed instead of 1024K.

>> 		size /= 1024;
>> 		idx++;
>> 	}
>>
>> 	sprintf("%d%c", size, suffices[idx]);
> 
> 	                      suffixes
>>
>> --
> 
> 


-- 
~Randy
