From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH v3 4/7] dcache: allocate external names from reclaimable
 kmalloc caches
Date: Thu, 19 Jul 2018 09:42:57 +0100
Message-ID: <20180719084257.2qqafzcteqwkb2xd@techsingularity.net>
References: <20180718133620.6205-1-vbabka@suse.cz>
 <20180718133620.6205-5-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180718133620.6205-5-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Matthew Wilcox <willy@infradead.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 18, 2018 at 03:36:17PM +0200, Vlastimil Babka wrote:
> We can use the newly introduced kmalloc-reclaimable-X caches, to allocate
> external names in dcache, which will take care of the proper accounting
> automatically, and also improve anti-fragmentation page grouping.
> 
> This effectively reverts commit f1782c9bc547 ("dcache: account external names
> as indirectly reclaimable memory") and instead passes __GFP_RECLAIMABLE to
> kmalloc(). The accounting thus moves from NR_INDIRECTLY_RECLAIMABLE_BYTES to
> NR_SLAB_RECLAIMABLE, which is also considered in MemAvailable calculation and
> overcommit decisions.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Mel Gorman <mgorman@techsingularity.net>

-- 
Mel Gorman
SUSE Labs
