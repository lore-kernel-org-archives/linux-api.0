From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH v3 7/7] mm, slab: shorten kmalloc cache names for large
 sizes
Date: Thu, 19 Jul 2018 09:46:01 +0100
Message-ID: <20180719084601.bl7zeq3ube7vulgq@techsingularity.net>
References: <20180718133620.6205-1-vbabka@suse.cz>
 <20180718133620.6205-8-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180718133620.6205-8-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Matthew Wilcox <willy@infradead.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 18, 2018 at 03:36:20PM +0200, Vlastimil Babka wrote:
> Kmalloc cache names can get quite long for large object sizes, when the sizes
> are expressed in bytes. Use 'k' and 'M' prefixes to make the names as short
> as possible e.g. in /proc/slabinfo. This works, as we mostly use power-of-two
> sizes, with exceptions only below 1k.
> 
> Example: 'kmalloc-4194304' becomes 'kmalloc-4M'
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

There is a slight chance this will break any external tooling that
calculates fragmentation stats for slab/slub if they are particularly
stupid parsers but other than that;

Acked-by: Mel Gorman <mgorman@techsingularity.net>

-- 
Mel Gorman
SUSE Labs
