From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/9] mm, page_alloc: rip out ZONELIST_ORDER_ZONE
Date: Wed, 19 Jul 2017 11:33:49 +0200
Message-ID: <a4490c3e-9f7b-72b2-dfa3-80c054df6600@suse.cz>
References: <20170714080006.7250-1-mhocko@kernel.org>
 <20170714080006.7250-2-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170714080006.7250-2-mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 07/14/2017 09:59 AM, Michal Hocko wrote:
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

Found some leftovers to cleanup:

include/linux/mmzone.h:
extern char numa_zonelist_order[];
#define NUMA_ZONELIST_ORDER_LEN 16      /* string buffer size */

Also update docs?
Documentation/sysctl/vm.txt:zone.  Specify "[Zz]one" for zone order.
Documentation/admin-guide/kernel-parameters.txt:
numa_zonelist_order= [KNL, BOOT] Select zonelist order for NUMA.
Documentation/vm/numa:a default zonelist order based on the sizes of the
various zone types relative
Documentation/vm/numa:default zonelist order may be overridden using the
numa_zonelist_order kernel

Otherwise,
Acked-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
