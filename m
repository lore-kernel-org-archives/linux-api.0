From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC PATCH 2/2] mm, vmstat: reduce zone->lock holding time by
 /proc/pagetypeinfo
Date: Wed, 23 Oct 2019 18:15:56 +0200
Message-ID: <b280d277-9870-48c4-0c0a-df4195ddd3c4@suse.cz>
References: <20191023095607.GE3016@techsingularity.net>
 <20191023102737.32274-1-mhocko@kernel.org>
 <20191023102737.32274-3-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191023102737.32274-3-mhocko@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Jann Horn <jannh@google.com>, Song Liu <songliubraving@fb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

+ linux-api

On 10/23/19 12:27 PM, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> pagetypeinfo_showfree_print is called by zone->lock held in irq mode.
> This is not really nice because it blocks both any interrupts on that
> cpu and the page allocator. On large machines this might even trigger
> the hard lockup detector.
> 
> Considering the pagetypeinfo is a debugging tool we do not really need
> exact numbers here. The primary reason to look at the outuput is to see
> how pageblocks are spread among different migratetypes therefore putting
> a bound on the number of pages on the free_list sounds like a reasonable
> tradeoff.
> 
> The new output will simply tell
> [...]
> Node    6, zone   Normal, type      Movable >100000 >100000 >100000 >100000  41019  31560  23996  10054   3229    983    648
> 
> instead of
> Node    6, zone   Normal, type      Movable 399568 294127 221558 102119  41019  31560  23996  10054   3229    983    648
> 
> The limit has been chosen arbitrary and it is a subject of a future
> change should there be a need for that.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> ---
>  mm/vmstat.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 4e885ecd44d1..762034fc3b83 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1386,8 +1386,25 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
>  
>  			area = &(zone->free_area[order]);
>  
> -			list_for_each(curr, &area->free_list[mtype])
> +			list_for_each(curr, &area->free_list[mtype]) {
>  				freecount++;
> +				/*
> +				 * Cap the free_list iteration because it might
> +				 * be really large and we are under a spinlock
> +				 * so a long time spent here could trigger a
> +				 * hard lockup detector. Anyway this is a
> +				 * debugging tool so knowing there is a handful
> +				 * of pages in this order should be more than
> +				 * sufficient
> +				 */
> +				if (freecount > 100000) {
> +					seq_printf(m, ">%6lu ", freecount);
> +					spin_unlock_irq(&zone->lock);
> +					cond_resched();
> +					spin_lock_irq(&zone->lock);
> +					continue;
> +				}
> +			}
>  			seq_printf(m, "%6lu ", freecount);
>  		}
>  		seq_putc(m, '\n');
> 
