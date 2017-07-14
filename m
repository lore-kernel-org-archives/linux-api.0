From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/9] mm, page_alloc: rip out ZONELIST_ORDER_ZONE
Date: Fri, 14 Jul 2017 10:36:50 +0100
Message-ID: <20170714093650.l67vbem2g4typkta@suse.de>
References: <20170714080006.7250-1-mhocko@kernel.org>
 <20170714080006.7250-2-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170714080006.7250-2-mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 14, 2017 at 09:59:58AM +0200, Michal Hocko wrote:
> From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> 
> Supporting zone ordered zonelists costs us just a lot of code while
> the usefulness is arguable if existent at all. Mel has already made
> node ordering default on 64b systems. 32b systems are still using
> ZONELIST_ORDER_ZONE because it is considered better to fallback to
> a different NUMA node rather than consume precious lowmem zones.
> 
> This argument is, however, weaken by the fact that the memory reclaim
> has been reworked to be node rather than zone oriented. This means
> that lowmem requests have to skip over all highmem pages on LRUs already
> and so zone ordering doesn't save the reclaim time much. So the only
> advantage of the zone ordering is under a light memory pressure when
> highmem requests do not ever hit into lowmem zones and the lowmem
> pressure doesn't need to reclaim.
> 
> Considering that 32b NUMA systems are rather suboptimal already and
> it is generally advisable to use 64b kernel on such a HW I believe we
> should rather care about the code maintainability and just get rid of
> ZONELIST_ORDER_ZONE altogether. Keep systcl in place and warn if
> somebody tries to set zone ordering either from kernel command line
> or the sysctl.
> 
> Cc: <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> index 80e4adb4c360..d9f4ea057e74 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4864,40 +4824,22 @@ int numa_zonelist_order_handler(struct ctl_table *table, int write,
>  		void __user *buffer, size_t *length,
>  		loff_t *ppos)
>  {
> -	char saved_string[NUMA_ZONELIST_ORDER_LEN];
> +	char *str;
>  	int ret;
> -	static DEFINE_MUTEX(zl_order_mutex);
>  
> -	mutex_lock(&zl_order_mutex);
> -	if (write) {
> -		if (strlen((char *)table->data) >= NUMA_ZONELIST_ORDER_LEN) {
> -			ret = -EINVAL;
> -			goto out;
> -		}
> -		strcpy(saved_string, (char *)table->data);
> +	if (!write) {
> +		int len = sizeof("Default");
> +		if (copy_to_user(buffer, "Default", len))
> +			return -EFAULT;
> +		return len;
>  	}

That should to be "default" because the original code would have the proc
entry display "default" unless it was set at runtime. Pretty weird I
know but it's always possible someone is parsing the original default
and not handling it properly.

Otherwise I think we're way past the point where large memory 32-bit
NUMA machines are a thing so

Acked-by: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

-- 
Mel Gorman
SUSE Labs
