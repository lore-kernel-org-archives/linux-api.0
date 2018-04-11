From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 1/3] mm: introduce NR_INDIRECTLY_RECLAIMABLE_BYTES
Date: Wed, 11 Apr 2018 15:16:08 +0200
Message-ID: <08524819-14ef-81d0-fa90-d7af13c6b9d5@suse.cz>
References: <20180305133743.12746-1-guro@fb.com>
 <20180305133743.12746-2-guro@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180305133743.12746-2-guro@fb.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

[+CC linux-api]

On 03/05/2018 02:37 PM, Roman Gushchin wrote:
> This patch introduces a concept of indirectly reclaimable memory
> and adds the corresponding memory counter and /proc/vmstat item.
> 
> Indirectly reclaimable memory is any sort of memory, used by
> the kernel (except of reclaimable slabs), which is actually
> reclaimable, i.e. will be released under memory pressure.
> 
> The counter is in bytes, as it's not always possible to
> count such objects in pages. The name contains BYTES
> by analogy to NR_KERNEL_STACK_KB.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: kernel-team@fb.com

Hmm, looks like I'm late and this user-visible API change was just
merged. But it's for rc1, so we can still change it, hopefully?

One problem I see with the counter is that it's in bytes, but among
counters that use pages, and the name doesn't indicate it. Then, I don't
see why users should care about the "indirectly" part, as that's just an
implementation detail. It is reclaimable and that's what matters, right?
(I also wanted to complain about lack of Documentation/... update, but
looks like there's no general file about vmstat, ugh)

I also kind of liked the idea from v1 rfc posting that there would be a
separate set of reclaimable kmalloc-X caches for these kind of
allocations. Besides accounting, it should also help reduce memory
fragmentation. The right variant of cache would be detected via
__GFP_RECLAIMABLE.

With that in mind, can we at least for now put the (manually maintained)
byte counter in a variable that's not directly exposed via /proc/vmstat,
and then when printing nr_slab_reclaimable, simply add the value
(divided by PAGE_SIZE), and when printing nr_slab_unreclaimable,
subtract the same value. This way we would be simply making the existing
counters more precise, in line with their semantics.

Thoughts?
Vlastimil

> ---
>  include/linux/mmzone.h | 1 +
>  mm/vmstat.c            | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index e09fe563d5dc..15e783f29e21 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -180,6 +180,7 @@ enum node_stat_item {
>  	NR_VMSCAN_IMMEDIATE,	/* Prioritise for reclaim when writeback ends */
>  	NR_DIRTIED,		/* page dirtyings since bootup */
>  	NR_WRITTEN,		/* page writings since bootup */
> +	NR_INDIRECTLY_RECLAIMABLE_BYTES, /* measured in bytes */
>  	NR_VM_NODE_STAT_ITEMS
>  };
>  
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 40b2db6db6b1..b6b5684f31fe 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1161,6 +1161,7 @@ const char * const vmstat_text[] = {
>  	"nr_vmscan_immediate_reclaim",
>  	"nr_dirtied",
>  	"nr_written",
> +	"nr_indirectly_reclaimable",
>  
>  	/* enum writeback_stat_item counters */
>  	"nr_dirty_threshold",
> 
