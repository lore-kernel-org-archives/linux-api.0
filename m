From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH v3 3/7] mm, slab: allocate off-slab freelists as
 reclaimable when appropriate
Date: Thu, 19 Jul 2018 09:35:30 +0100
Message-ID: <20180719083530.jhugqzkvjnbrddim@techsingularity.net>
References: <20180718133620.6205-1-vbabka@suse.cz>
 <20180718133620.6205-4-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180718133620.6205-4-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Matthew Wilcox <willy@infradead.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 18, 2018 at 03:36:16PM +0200, Vlastimil Babka wrote:
> In SLAB, OFF_SLAB caches allocate management structures (currently just the
> freelist) from kmalloc caches when placement in a slab page together with
> objects would lead to suboptimal memory usage. For SLAB_RECLAIM_ACCOUNT caches,
> we can allocate the freelists from the newly introduced reclaimable kmalloc
> caches, because shrinking the OFF_SLAB cache will in general result to freeing
> of the freelists as well. This should improve accounting and anti-fragmentation
> a bit.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

I'm not quite convinced by this one. The freelist cache is tied to the
lifetime of the slab and not the objects. A single freelist can be reclaimed
eventually but for caches with many objects per slab, it could take a lot
of shrinking random objects to reclaim one freelist. Functionally the
patch appears to be fine.

-- 
Mel Gorman
SUSE Labs
