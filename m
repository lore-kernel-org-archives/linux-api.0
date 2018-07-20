From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3 1/7] mm, slab: combine kmalloc_caches and
 kmalloc_dma_caches
Date: Fri, 20 Jul 2018 11:30:23 +0200
Message-ID: <fbd8741b-1d1d-408b-74e0-5d6e87cb1e54@suse.cz>
References: <20180718133620.6205-1-vbabka@suse.cz>
 <20180718133620.6205-2-vbabka@suse.cz>
 <20180719081020.5pl3naynwhgev6rx@techsingularity.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180719081020.5pl3naynwhgev6rx@techsingularity.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mel Gorman <mgorman@techsingularity.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Matthew Wilcox <willy@infradead.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>
List-Id: linux-api@vger.kernel.org

On 07/19/2018 10:10 AM, Mel Gorman wrote:
> On Wed, Jul 18, 2018 at 03:36:14PM +0200, Vlastimil Babka wrote:
>> The kmalloc caches currently mainain separate (optional) array
>> kmalloc_dma_caches for __GFP_DMA allocations. There are tests for __GFP_DMA in
>> the allocation hotpaths. We can avoid the branches by combining kmalloc_caches
>> and kmalloc_dma_caches into a single two-dimensional array where the outer
>> dimension is cache "type". This will also allow to add kmalloc-reclaimable
>> caches as a third type.
>>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> I'm surprised there are so many kmalloc users that require the DMA zone.
> Some of them are certainly bogus such as in drivers for archs that only
> have one zone and is probably a reflection of the confusing naming. The
> audit would be a mess and unrelated to the patch so for this patch;

Yeah, there was a session about that on LSF/MM and Luis was working on
it. One of the motivations was to get rid of the branch, so that's
sidestepped by this patch. I would still like to not have slabinfo full
of empty dma-kmalloc caches though :)

> Acked-by: Mel Gorman <mgorman@techsingularity.net>
> 
