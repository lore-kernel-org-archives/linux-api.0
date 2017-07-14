From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/9] mm, page_alloc: rip out ZONELIST_ORDER_ZONE
Date: Fri, 14 Jul 2017 13:38:40 +0200
Message-ID: <20170714113840.GI2618@dhcp22.suse.cz>
References: <20170714080006.7250-1-mhocko@kernel.org>
 <20170714080006.7250-2-mhocko@kernel.org>
 <20170714093650.l67vbem2g4typkta@suse.de>
 <20170714104756.GD2618@dhcp22.suse.cz>
 <20170714111633.gk5rpu2d5ghkbrrd@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170714111633.gk5rpu2d5ghkbrrd@suse.de>
Sender: owner-linux-mm@kvack.org
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri 14-07-17 12:16:33, Mel Gorman wrote:
> On Fri, Jul 14, 2017 at 12:47:57PM +0200, Michal Hocko wrote:
> > > That should to be "default" because the original code would have the proc
> > > entry display "default" unless it was set at runtime. Pretty weird I
> > > know but it's always possible someone is parsing the original default
> > > and not handling it properly.
> > 
> > Ohh, right! That is indeed strange. Then I guess it would be probably
> > better to simply return Node to make it clear what the default is. What
> > do you think?
> > 
> 
> That would work too. The casing still matches.

This folded in?
---
>From c7c36f011590680b254813be00ed791ddbc1bf1c Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Fri, 14 Jul 2017 13:36:05 +0200
Subject: [PATCH] fold me "mm, page_alloc: rip out ZONELIST_ORDER_ZONE"

- do not print Default in sysctl handler because our behavior was rather
inconsistent in the past numa_zonelist_order was lowecase while
zonelist_order_name was uppercase so boot time unchanged value woul
print lowercase while updated value could be uppercase. Print "Node"
which is the default instead - Mel

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dd4c96edcec3..49bade7ff049 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4828,8 +4828,8 @@ int numa_zonelist_order_handler(struct ctl_table *table, int write,
 	int ret;
 
 	if (!write) {
-		int len = sizeof("Default");
-		if (copy_to_user(buffer, "Default", len))
+		int len = sizeof("Node");
+		if (copy_to_user(buffer, "Node", len))
 			return -EFAULT;
 		return len;
 	}
-- 
2.11.0

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
