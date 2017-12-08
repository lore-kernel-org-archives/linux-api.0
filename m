From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-dont-reserve-zone_highmem-for-zone_movable-request.patch
 added to -mm tree
Date: Fri, 08 Dec 2017 14:45:28 -0800
Message-ID: <5a2b1608.fzedxVmuuLgSQW11%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, lauraa@codeaurora.org, linux-api@vger.kernel.org, linux@armlinux.org.uk, mgorman@techsingularity.net, mhocko@suse.com, mina86@mina86.com, minchan@kernel.org, m.szyprowski@samsung.com, riel@redhat.com, tony@atomide.com, vbabka@suse.cz, will.deacon@arm.com, mm-commits@vger.kernel.org
List-Id: linux-api@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: don't reserve ZONE_HIGHMEM for ZONE_MOVABLE request
has been added to the -mm tree.  Its filename is
     mm-page_alloc-dont-reserve-zone_highmem-for-zone_movable-request.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-dont-reserve-zone_highmem-for-zone_movable-request.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-dont-reserve-zone_highmem-for-zone_movable-request.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_alloc: don't reserve ZONE_HIGHMEM for ZONE_MOVABLE request

Freepage on ZONE_HIGHMEM doesn't work for kernel memory so it's not that
important to reserve.  When ZONE_MOVABLE is used, this problem would
theorectically cause to decrease usable memory for GFP_HIGHUSER_MOVABLE
allocation request which is mainly used for page cache and anon page
allocation.  So, fix it by setting 0 to
sysctl_lowmem_reserve_ratio[ZONE_HIGHMEM].

And, defining sysctl_lowmem_reserve_ratio array by MAX_NR_ZONES - 1 size
makes code complex.  For example, if there is highmem system, following
reserve ratio is activated for *NORMAL ZONE* which would be easyily
misleading people.

 #ifdef CONFIG_HIGHMEM
 32
 #endif

This patch also fixes this situation by defining
sysctl_lowmem_reserve_ratio array by MAX_NR_ZONES and place "#ifdef" to
right place.

Link: http://lkml.kernel.org/r/1504672525-17915-1-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Tony Lindgren <tony@atomide.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: <linux-api@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    5 ++---
 include/linux/mmzone.h      |    2 +-
 mm/page_alloc.c             |   25 ++++++++++++++-----------
 3 files changed, 17 insertions(+), 15 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-page_alloc-dont-reserve-zone_highmem-for-zone_movable-request Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-page_alloc-dont-reserve-zone_highmem-for-zone_movable-request
+++ a/Documentation/sysctl/vm.txt
@@ -312,8 +312,6 @@ The lowmem_reserve_ratio is an array. Yo
 % cat /proc/sys/vm/lowmem_reserve_ratio
 256     256     32
 -
-Note: # of this elements is one fewer than number of zones. Because the highest
-      zone's value is not necessary for following calculation.
 
 But, these values are not used directly. The kernel calculates # of protection
 pages for each zones from them. These are shown as array of protection pages
@@ -364,7 +362,8 @@ As above expression, they are reciprocal
 pages of higher zones on the node.
 
 If you would like to protect more pages, smaller values are effective.
-The minimum value is 1 (1/1 -> 100%).
+The minimum value is 1 (1/1 -> 100%). The value less than 1 completely
+disables protection of the pages.
 
 ==============================================================
 
diff -puN include/linux/mmzone.h~mm-page_alloc-dont-reserve-zone_highmem-for-zone_movable-request include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-dont-reserve-zone_highmem-for-zone_movable-request
+++ a/include/linux/mmzone.h
@@ -886,7 +886,7 @@ int min_free_kbytes_sysctl_handler(struc
 					void __user *, size_t *, loff_t *);
 int watermark_scale_factor_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
-extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES-1];
+extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES];
 int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 int percpu_pagelist_fraction_sysctl_handler(struct ctl_table *, int,
diff -puN mm/page_alloc.c~mm-page_alloc-dont-reserve-zone_highmem-for-zone_movable-request mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-dont-reserve-zone_highmem-for-zone_movable-request
+++ a/mm/page_alloc.c
@@ -204,17 +204,18 @@ static void __free_pages_ok(struct page
  * TBD: should special case ZONE_DMA32 machines here - in those we normally
  * don't need any ZONE_NORMAL reservation
  */
-int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES-1] = {
+int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES] = {
 #ifdef CONFIG_ZONE_DMA
-	 256,
+	[ZONE_DMA] = 256,
 #endif
 #ifdef CONFIG_ZONE_DMA32
-	 256,
+	[ZONE_DMA32] = 256,
 #endif
+	[ZONE_NORMAL] = 32,
 #ifdef CONFIG_HIGHMEM
-	 32,
+	[ZONE_HIGHMEM] = 0,
 #endif
-	 32,
+	[ZONE_MOVABLE] = 0,
 };
 
 EXPORT_SYMBOL(totalram_pages);
@@ -6971,13 +6972,15 @@ static void setup_per_zone_lowmem_reserv
 				struct zone *lower_zone;
 
 				idx--;
-
-				if (sysctl_lowmem_reserve_ratio[idx] < 1)
-					sysctl_lowmem_reserve_ratio[idx] = 1;
