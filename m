From: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Subject: [merged] mm-page_alloc-rip-out-zonelist_order_zone.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:37:52 -0700
Message-ID: <20170907183752.2-nMkWkoK%akpm@linux-foundation.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: abdhalee-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, mm-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, toshi.kani-ZPxbGqLxI0U@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org
List-Id: linux-api@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: rip out ZONELIST_ORDER_ZONE
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-rip-out-zonelist_order_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: mm, page_alloc: rip out ZONELIST_ORDER_ZONE

Patch series "cleanup zonelists initialization", v1.

This is aimed at cleaning up the zonelists initialization code we have
but the primary motivation was bug report [2] which got resolved but
the usage of stop_machine is just too ugly to live. Most patches are
straightforward but 3 of them need a special consideration.

Patch 1 removes zone ordered zonelists completely. I am CCing linux-api
because this is a user visible change. As I argue in the patch
description I do not think we have a strong usecase for it these days.
I have kept sysctl in place and warn into the log if somebody tries to
configure zone lists ordering. If somebody has a real usecase for it
we can revert this patch but I do not expect anybody will actually notice
runtime differences. This patch is not strictly needed for the rest but
it made patch 6 easier to implement.

Patch 7 removes stop_machine from build_all_zonelists without adding any
special synchronization between iterators and updater which I _believe_
is acceptable as explained in the changelog. I hope I am not missing
anything.

Patch 8 then removes zonelists_mutex which is kind of ugly as well and
not really needed AFAICS but a care should be taken when double checking
my thinking.


This patch (of 9):

Supporting zone ordered zonelists costs us just a lot of code while the
usefulness is arguable if existent at all.  Mel has already made node
ordering default on 64b systems.  32b systems are still using
ZONELIST_ORDER_ZONE because it is considered better to fallback to a
different NUMA node rather than consume precious lowmem zones.

This argument is, however, weaken by the fact that the memory reclaim has
been reworked to be node rather than zone oriented.  This means that
lowmem requests have to skip over all highmem pages on LRUs already and so
zone ordering doesn't save the reclaim time much.  So the only advantage
of the zone ordering is under a light memory pressure when highmem
requests do not ever hit into lowmem zones and the lowmem pressure doesn't
need to reclaim.

Considering that 32b NUMA systems are rather suboptimal already and it is
generally advisable to use 64b kernel on such a HW I believe we should
rather care about the code maintainability and just get rid of
ZONELIST_ORDER_ZONE altogether.  Keep systcl in place and warn if somebody
tries to set zone ordering either from kernel command line or the sysctl.

[mhocko-IBi9RG/b67k@public.gmane.org: reading vm.numa_zonelist_order will never terminate]
Link: http://lkml.kernel.org/r/20170721143915.14161-2-mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Acked-by: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Acked-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: Abdul Haleem <abdhalee-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 
 Documentation/sysctl/vm.txt                     |    4 
 Documentation/vm/numa                           |    7 
 include/linux/mmzone.h                          |    2 
 mm/page_alloc.c                                 |  181 +-------------
 5 files changed, 29 insertions(+), 167 deletions(-)

diff -puN Documentation/admin-guide/kernel-parameters.txt~mm-page_alloc-rip-out-zonelist_order_zone Documentation/admin-guide/kernel-parameters.txt
--- a/Documentation/admin-guide/kernel-parameters.txt~mm-page_alloc-rip-out-zonelist_order_zone
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2783,7 +2783,7 @@
 			Allowed values are enable and disable
 
 	numa_zonelist_order= [KNL, BOOT] Select zonelist order for NUMA.
-			one of ['zone', 'node', 'default'] can be specified
+			'node', 'default' can be specified
 			This can be set from sysctl after boot.
 			See Documentation/sysctl/vm.txt for details.
 
diff -puN Documentation/sysctl/vm.txt~mm-page_alloc-rip-out-zonelist_order_zone Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-page_alloc-rip-out-zonelist_order_zone
+++ a/Documentation/sysctl/vm.txt
@@ -572,7 +572,9 @@ See Documentation/nommu-mmap.txt for mor
 
 numa_zonelist_order
 
-This sysctl is only for NUMA.
+This sysctl is only for NUMA and it is deprecated. Anything but
+Node order will fail!
+
 'where the memory is allocated from' is controlled by zonelists.
 (This documentation ignores ZONE_HIGHMEM/ZONE_DMA32 for simple explanation.
  you may be able to read ZONE_DMA as ZONE_DMA32...)
diff -puN Documentation/vm/numa~mm-page_alloc-rip-out-zonelist_order_zone Documentation/vm/numa
--- a/Documentation/vm/numa~mm-page_alloc-rip-out-zonelist_order_zone
+++ a/Documentation/vm/numa
@@ -79,11 +79,8 @@ memory, Linux must decide whether to ord
 fall back to the same zone type on a different node, or to a different zone
 type on the same node.  This is an important consideration because some zones,
 such as DMA or DMA32, represent relatively scarce resources.  Linux chooses
-a default zonelist order based on the sizes of the various zone types relative
-to the total memory of the node and the total memory of the system.  The
-default zonelist order may be overridden using the numa_zonelist_order kernel
-boot parameter or sysctl.  [see Documentation/admin-guide/kernel-parameters.rst and
-Documentation/sysctl/vm.txt]
+a default Node ordered zonelist. This means it tries to fallback to other zones
+from the same node before using remote nodes which are ordered by NUMA distance.
 
 By default, Linux will attempt to satisfy memory allocation requests from the
 node to which the CPU that executes the request is assigned.  Specifically,
diff -puN include/linux/mmzone.h~mm-page_alloc-rip-out-zonelist_order_zone include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-rip-out-zonelist_order_zone
+++ a/include/linux/mmzone.h
@@ -896,7 +896,7 @@ int sysctl_min_slab_ratio_sysctl_handler
 extern int numa_zonelist_order_handler(struct ctl_table *, int,
 			void __user *, size_t *, loff_t *);
 extern char numa_zonelist_order[];
-#define NUMA_ZONELIST_ORDER_LEN 16	/* string buffer size */
+#define NUMA_ZONELIST_ORDER_LEN	16
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 
diff -puN mm/page_alloc.c~mm-page_alloc-rip-out-zonelist_order_zone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-rip-out-zonelist_order_zone
+++ a/mm/page_alloc.c
@@ -4858,52 +4858,18 @@ static int build_zonelists_node(pg_data_
 	return nr_zones;
 }
 
-
-/*
- *  zonelist_order:
- *  0 = automatic detection of better ordering.
- *  1 = order by ([node] distance, -zonetype)
- *  2 = order by (-zonetype, [node] distance)
- *
- *  If not NUMA, ZONELIST_ORDER_ZONE and ZONELIST_ORDER_NODE will create
- *  the same zonelist. So only NUMA can configure this param.
- */
-#define ZONELIST_ORDER_DEFAULT  0
-#define ZONELIST_ORDER_NODE     1
-#define ZONELIST_ORDER_ZONE     2
-
-/* zonelist order in the kernel.
- * set_zonelist_order() will set this to NODE or ZONE.
- */
-static int current_zonelist_order = ZONELIST_ORDER_DEFAULT;
-static char zonelist_order_name[3][8] = {"Default", "Node", "Zone"};
-
-
 #ifdef CONFIG_NUMA
-/* The value user specified ....changed by config */
-static int user_zonelist_order = ZONELIST_ORDER_DEFAULT;
-/* string for sysctl */
-#define NUMA_ZONELIST_ORDER_LEN	16
-char numa_zonelist_order[16] = "default";
-
-/*
- * interface for configure zonelist ordering.
- * command line option "numa_zonelist_order"
- *	= "[dD]efault	- default, automatic configuration.
- *	= "[nN]ode 	- order by node locality, then by zone within node
- *	= "[zZ]one      - order by zone, then by locality within zone
- */
 
 static int __parse_numa_zonelist_order(char *s)
 {
-	if (*s == 'd' || *s == 'D') {
-		user_zonelist_order = ZONELIST_ORDER_DEFAULT;
-	} else if (*s == 'n' || *s == 'N') {
-		user_zonelist_order = ZONELIST_ORDER_NODE;
-	} else if (*s == 'z' || *s == 'Z') {
-		user_zonelist_order = ZONELIST_ORDER_ZONE;
-	} else {
-		pr_warn("Ignoring invalid numa_zonelist_order value:  %s\n", s);
+	/*
+	 * We used to support different zonlists modes but they turned
+	 * out to be just not useful. Let's keep the warning in place
+	 * if somebody still use the cmd line parameter so that we do
+	 * not fail it silently
+	 */
+	if (!(*s == 'd' || *s == 'D' || *s == 'n' || *s == 'N')) {
+		pr_warn("Ignoring unsupported numa_zonelist_order value:  %s\n", s);
 		return -EINVAL;
 	}
 	return 0;
@@ -4911,19 +4877,15 @@ static int __parse_numa_zonelist_order(c
 
 static __init int setup_numa_zonelist_order(char *s)
 {
-	int ret;
-
 	if (!s)
 		return 0;
 
-	ret = __parse_numa_zonelist_order(s);
-	if (ret == 0)
-		strlcpy(numa_zonelist_order, s, NUMA_ZONELIST_ORDER_LEN);
-
-	return ret;
+	return __parse_numa_zonelist_order(s);
 }
 early_param("numa_zonelist_order", setup_numa_zonelist_order);
 
+char numa_zonelist_order[] = "Node";
+
 /*
  * sysctl handler for numa_zonelist_order
  */
@@ -4931,42 +4893,17 @@ int numa_zonelist_order_handler(struct c
 		void __user *buffer, size_t *length,
 		loff_t *ppos)
 {
-	char saved_string[NUMA_ZONELIST_ORDER_LEN];
+	char *str;
 	int ret;
-	static DEFINE_MUTEX(zl_order_mutex);
 
-	mutex_lock(&zl_order_mutex);
-	if (write) {
-		if (strlen((char *)table->data) >= NUMA_ZONELIST_ORDER_LEN) {
-			ret = -EINVAL;
-			goto out;
-		}
-		strcpy(saved_string, (char *)table->data);
-	}
-	ret = proc_dostring(table, write, buffer, length, ppos);
-	if (ret)
-		goto out;
-	if (write) {
-		int oldval = user_zonelist_order;
-
-		ret = __parse_numa_zonelist_order((char *)table->data);
-		if (ret) {
-			/*
-			 * bogus value.  restore saved string
-			 */
-			strncpy((char *)table->data, saved_string,
-				NUMA_ZONELIST_ORDER_LEN);
-			user_zonelist_order = oldval;
-		} else if (oldval != user_zonelist_order) {
-			mem_hotplug_begin();
-			mutex_lock(&zonelists_mutex);
-			build_all_zonelists(NULL, NULL);
-			mutex_unlock(&zonelists_mutex);
-			mem_hotplug_done();
-		}
-	}
-out:
-	mutex_unlock(&zl_order_mutex);
+	if (!write)
+		return proc_dostring(table, write, buffer, length, ppos);
+	str = memdup_user_nul(buffer, 16);
+	if (IS_ERR(str))
+		return PTR_ERR(str);
+
+	ret = __parse_numa_zonelist_order(str);
+	kfree(str);
 	return ret;
 }
 
@@ -5075,70 +5012,12 @@ static void build_thisnode_zonelists(pg_
  */
 static int node_order[MAX_NUMNODES];
 
-static void build_zonelists_in_zone_order(pg_data_t *pgdat, int nr_nodes)
-{
-	int pos, j, node;
-	int zone_type;		/* needs to be signed */
-	struct zone *z;
-	struct zonelist *zonelist;
-
-	zonelist = &pgdat->node_zonelists[ZONELIST_FALLBACK];
-	pos = 0;
-	for (zone_type = MAX_NR_ZONES - 1; zone_type >= 0; zone_type--) {
-		for (j = 0; j < nr_nodes; j++) {
-			node = node_order[j];
-			z = &NODE_DATA(node)->node_zones[zone_type];
-			if (managed_zone(z)) {
-				zoneref_set_zone(z,
-					&zonelist->_zonerefs[pos++]);
-				check_highest_zone(zone_type);
-			}
-		}
-	}
-	zonelist->_zonerefs[pos].zone = NULL;
-	zonelist->_zonerefs[pos].zone_idx = 0;
-}
-
-#if defined(CONFIG_64BIT)
-/*
- * Devices that require DMA32/DMA are relatively rare and do not justify a
- * penalty to every machine in case the specialised case applies. Default
- * to Node-ordering on 64-bit NUMA machines
- */
-static int default_zonelist_order(void)
-{
-	return ZONELIST_ORDER_NODE;
-}
-#else
-/*
- * On 32-bit, the Normal zone needs to be preserved for allocations accessible
- * by the kernel. If processes running on node 0 deplete the low memory zone
- * then reclaim will occur more frequency increasing stalls and potentially
- * be easier to OOM if a large percentage of the zone is under writeback or
- * dirty. The problem is significantly worse if CONFIG_HIGHPTE is not set.
- * Hence, default to zone ordering on 32-bit.
- */
-static int default_zonelist_order(void)
-{
-	return ZONELIST_ORDER_ZONE;
-}
-#endif /* CONFIG_64BIT */
-
-static void set_zonelist_order(void)
-{
-	if (user_zonelist_order == ZONELIST_ORDER_DEFAULT)
-		current_zonelist_order = default_zonelist_order();
-	else
-		current_zonelist_order = user_zonelist_order;
-}
-
 static void build_zonelists(pg_data_t *pgdat)
 {
 	int i, node, load;
 	nodemask_t used_mask;
 	int local_node, prev_node;
 	struct zonelist *zonelist;
-	unsigned int order = current_zonelist_order;
 
 	/* initialize zonelists */
 	for (i = 0; i < MAX_ZONELISTS; i++) {
@@ -5168,15 +5047,7 @@ static void build_zonelists(pg_data_t *p
 
 		prev_node = node;
 		load--;
-		if (order == ZONELIST_ORDER_NODE)
-			build_zonelists_in_node_order(pgdat, node);
-		else
-			node_order[i++] = node;	/* remember order */
-	}
-
-	if (order == ZONELIST_ORDER_ZONE) {
-		/* calculate node order -- i.e., DMA last! */
-		build_zonelists_in_zone_order(pgdat, i);
+		build_zonelists_in_node_order(pgdat, node);
 	}
 
 	build_thisnode_zonelists(pgdat);
@@ -5204,11 +5075,6 @@ static void setup_min_unmapped_ratio(voi
 static void setup_min_slab_ratio(void);
 #else	/* CONFIG_NUMA */
 
-static void set_zonelist_order(void)
-{
-	current_zonelist_order = ZONELIST_ORDER_ZONE;
-}
-
 static void build_zonelists(pg_data_t *pgdat)
 {
 	int node, local_node;
@@ -5348,8 +5214,6 @@ build_all_zonelists_init(void)
  */
 void __ref build_all_zonelists(pg_data_t *pgdat, struct zone *zone)
 {
-	set_zonelist_order();
-
 	if (system_state == SYSTEM_BOOTING) {
 		build_all_zonelists_init();
 	} else {
@@ -5375,9 +5239,8 @@ void __ref build_all_zonelists(pg_data_t
 	else
 		page_group_by_mobility_disabled = 0;
 
-	pr_info("Built %i zonelists in %s order, mobility grouping %s.  Total pages: %ld\n",
+	pr_info("Built %i zonelists, mobility grouping %s.  Total pages: %ld\n",
 		nr_online_nodes,
-		zonelist_order_name[current_zonelist_order],
 		page_group_by_mobility_disabled ? "off" : "on",
 		vm_total_pages);
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from mhocko-IBi9RG/b67k@public.gmane.org are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-memory_hotplug-introduce-add_pages.patch
mm-sparse-fix-typo-in-online_mem_sections.patch
fs-proc-remove-priv-argument-from-is_stack.patch
treewide-remove-gfp_temporary-allocation-flag.patch
