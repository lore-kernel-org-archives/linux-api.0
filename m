From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] mm, vmstat: List total free blocks for each order in
 /proc/pagetypeinfo
Date: Wed, 23 Oct 2019 20:02:17 +0200
Message-ID: <20191023180217.GO17610@dhcp22.suse.cz>
References: <20191023102737.32274-3-mhocko@kernel.org>
 <20191023173423.12532-2-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191023173423.12532-2-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Waiman Long <longman@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Jann Horn <jannh@google.com>, Song Liu <songliubraving@fb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Aquini <aquini@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed 23-10-19 13:34:23, Waiman Long wrote:
[...]
> @@ -1419,6 +1419,17 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
>  		}
>  		seq_putc(m, '\n');
>  	}
> +
> +	/*
> +	 * List total free blocks per order
> +	 */
> +	seq_printf(m, "Node %4d, zone %8s, total             ",
> +		   pgdat->node_id, zone->name);
> +	for (order = 0; order < MAX_ORDER; ++order) {
> +		area = &(zone->free_area[order]);
> +		seq_printf(m, "%6lu ", area->nr_free);
> +	}
> +	seq_putc(m, '\n');

This is essentially duplicating /proc/buddyinfo. Do we really need that?
-- 
Michal Hocko
SUSE Labs
