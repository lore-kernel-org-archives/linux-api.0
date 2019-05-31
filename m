From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFCv2 3/6] mm: introduce MADV_PAGEOUT
Date: Fri, 31 May 2019 12:59:27 -0400
Message-ID: <20190531165927.GA20067@cmpxchg.org>
References: <20190531064313.193437-1-minchan@kernel.org>
 <20190531064313.193437-4-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190531064313.193437-4-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com
List-Id: linux-api@vger.kernel.org

Hi Michan,

this looks pretty straight-forward to me, only one kink:

On Fri, May 31, 2019 at 03:43:10PM +0900, Minchan Kim wrote:
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2126,6 +2126,83 @@ static void shrink_active_list(unsigned long nr_to_scan,
>  			nr_deactivate, nr_rotated, sc->priority, file);
>  }
>  
> +unsigned long reclaim_pages(struct list_head *page_list)
> +{
> +	int nid = -1;
> +	unsigned long nr_isolated[2] = {0, };
> +	unsigned long nr_reclaimed = 0;
> +	LIST_HEAD(node_page_list);
> +	struct reclaim_stat dummy_stat;
> +	struct scan_control sc = {
> +		.gfp_mask = GFP_KERNEL,
> +		.priority = DEF_PRIORITY,
> +		.may_writepage = 1,
> +		.may_unmap = 1,
> +		.may_swap = 1,
> +	};
> +
> +	while (!list_empty(page_list)) {
> +		struct page *page;
> +
> +		page = lru_to_page(page_list);
> +		if (nid == -1) {
> +			nid = page_to_nid(page);
> +			INIT_LIST_HEAD(&node_page_list);
> +			nr_isolated[0] = nr_isolated[1] = 0;
> +		}
> +
> +		if (nid == page_to_nid(page)) {
> +			list_move(&page->lru, &node_page_list);
> +			nr_isolated[!!page_is_file_cache(page)] +=
> +						hpage_nr_pages(page);
> +			continue;
> +		}
> +
> +		mod_node_page_state(NODE_DATA(nid), NR_ISOLATED_ANON,
> +					nr_isolated[0]);
> +		mod_node_page_state(NODE_DATA(nid), NR_ISOLATED_FILE,
> +					nr_isolated[1]);
> +		nr_reclaimed += shrink_page_list(&node_page_list,
> +				NODE_DATA(nid), &sc, TTU_IGNORE_ACCESS,
> +				&dummy_stat, true);
> +		while (!list_empty(&node_page_list)) {
> +			struct page *page = lru_to_page(&node_page_list);
> +
> +			list_del(&page->lru);
> +			putback_lru_page(page);
> +		}
> +		mod_node_page_state(NODE_DATA(nid), NR_ISOLATED_ANON,
> +					-nr_isolated[0]);
> +		mod_node_page_state(NODE_DATA(nid), NR_ISOLATED_FILE,
> +					-nr_isolated[1]);
> +		nid = -1;
> +	}
> +
> +	if (!list_empty(&node_page_list)) {
> +		mod_node_page_state(NODE_DATA(nid), NR_ISOLATED_ANON,
> +					nr_isolated[0]);
> +		mod_node_page_state(NODE_DATA(nid), NR_ISOLATED_FILE,
> +					nr_isolated[1]);
> +		nr_reclaimed += shrink_page_list(&node_page_list,
> +				NODE_DATA(nid), &sc, TTU_IGNORE_ACCESS,
> +				&dummy_stat, true);
> +		mod_node_page_state(NODE_DATA(nid), NR_ISOLATED_ANON,
> +					-nr_isolated[0]);
> +		mod_node_page_state(NODE_DATA(nid), NR_ISOLATED_FILE,
> +					-nr_isolated[1]);
> +
> +		while (!list_empty(&node_page_list)) {
> +			struct page *page = lru_to_page(&node_page_list);
> +
> +			list_del(&page->lru);
> +			putback_lru_page(page);
> +		}
> +
> +	}

The NR_ISOLATED accounting, nid parsing etc. is really awkward and
makes it hard to see what the function actually does.

Can you please make those ISOLATED counters part of the isolation API?
Your patch really shows this is an overdue cleanup.

These are fast local percpu counters, we don't need the sprawling
batching we do all over vmscan.c, migrate.c, khugepaged.c,
compaction.c etc. Isolation can increase the counter page by page, and
reclaim or putback can likewise decrease them one by one.

It looks like mlock is the only user of the isolation api that does
not participate in the NR_ISOLATED_* counters protocol, but I don't
see why it wouldn't, or why doing so would hurt.

There are also seem to be quite a few callsites that use the atomic
versions of the counter API when they're clearly under the irqsafe
lru_lock. That would be fixed automatically by this work as well.
