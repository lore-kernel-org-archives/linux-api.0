From: Christopher Lameter <cl@linux.com>
Subject: Re: [RFC PATCH 4/5] mm: rename and change semantics of
 nr_indirectly_reclaimable_bytes
Date: Fri, 25 May 2018 15:59:42 +0000
Message-ID: <010001639806f32c-c18e739a-feac-4c6d-bce0-61c410579310-000000@email.amazonses.com>
References: <20180524110011.1940-1-vbabka@suse.cz> <20180524110011.1940-5-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524110011.1940-5-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@techsingularity.net>, Vijayanand Jitta <vjitta@codeaurora.org>
List-Id: linux-api@vger.kernel.org

On Thu, 24 May 2018, Vlastimil Babka wrote:

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 32699b2dc52a..4343948f33e5 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -180,7 +180,7 @@ enum node_stat_item {
>  	NR_VMSCAN_IMMEDIATE,	/* Prioritise for reclaim when writeback ends */
>  	NR_DIRTIED,		/* page dirtyings since bootup */
>  	NR_WRITTEN,		/* page writings since bootup */
> -	NR_INDIRECTLY_RECLAIMABLE_BYTES, /* measured in bytes */
> +	NR_RECLAIMABLE,         /* all reclaimable pages, including slab */
>  	NR_VM_NODE_STAT_ITEMS

We already have NR_SLAB_RECLAIMABLE and NR_RECLAIMABLE now counts what
NR_SLAB_RECLAIMABLE counts plus something else. THis means updating
two counters in parallel.

Could keep the existing counter and just account
for those non slab things you mentioned? Avoid counting twice and may
provide unique insides into those non slab reclaimable objects. I'd like
to see this.
