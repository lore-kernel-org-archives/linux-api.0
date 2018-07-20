From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3 3/7] mm, slab: allocate off-slab freelists as
 reclaimable when appropriate
Date: Fri, 20 Jul 2018 11:37:34 +0200
Message-ID: <d164e040-3422-96c7-68e2-7efdf8818874@suse.cz>
References: <20180718133620.6205-1-vbabka@suse.cz>
 <20180718133620.6205-4-vbabka@suse.cz>
 <20180719083530.jhugqzkvjnbrddim@techsingularity.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180719083530.jhugqzkvjnbrddim@techsingularity.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mel Gorman <mgorman@techsingularity.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Matthew Wilcox <willy@infradead.org>
List-Id: linux-api@vger.kernel.org

On 07/19/2018 10:35 AM, Mel Gorman wrote:
> On Wed, Jul 18, 2018 at 03:36:16PM +0200, Vlastimil Babka wrote:
>> In SLAB, OFF_SLAB caches allocate management structures (currently just the
>> freelist) from kmalloc caches when placement in a slab page together with
>> objects would lead to suboptimal memory usage. For SLAB_RECLAIM_ACCOUNT caches,
>> we can allocate the freelists from the newly introduced reclaimable kmalloc
>> caches, because shrinking the OFF_SLAB cache will in general result to freeing
>> of the freelists as well. This should improve accounting and anti-fragmentation
>> a bit.
>>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> I'm not quite convinced by this one. The freelist cache is tied to the
> lifetime of the slab and not the objects. A single freelist can be reclaimed
> eventually but for caches with many objects per slab, it could take a lot
> of shrinking random objects to reclaim one freelist. Functionally the
> patch appears to be fine.

Hm you're right that the reclaimability of freelist is maybe too much
detached, and could do more harm than good for the reclaimable caches. I
will probably drop it unless I can measure it's an improvement. Thanks.
