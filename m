From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH v3 1/7] mm, slab: combine kmalloc_caches and
 kmalloc_dma_caches
Date: Thu, 19 Jul 2018 09:10:20 +0100
Message-ID: <20180719081020.5pl3naynwhgev6rx@techsingularity.net>
References: <20180718133620.6205-1-vbabka@suse.cz>
 <20180718133620.6205-2-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180718133620.6205-2-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Matthew Wilcox <willy@infradead.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 18, 2018 at 03:36:14PM +0200, Vlastimil Babka wrote:
> The kmalloc caches currently mainain separate (optional) array
> kmalloc_dma_caches for __GFP_DMA allocations. There are tests for __GFP_DMA in
> the allocation hotpaths. We can avoid the branches by combining kmalloc_caches
> and kmalloc_dma_caches into a single two-dimensional array where the outer
> dimension is cache "type". This will also allow to add kmalloc-reclaimable
> caches as a third type.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

I'm surprised there are so many kmalloc users that require the DMA zone.
Some of them are certainly bogus such as in drivers for archs that only
have one zone and is probably a reflection of the confusing naming. The
audit would be a mess and unrelated to the patch so for this patch;

Acked-by: Mel Gorman <mgorman@techsingularity.net>

-- 
Mel Gorman
SUSE Labs
