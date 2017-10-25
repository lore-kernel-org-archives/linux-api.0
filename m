From: Fan Du <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCHv3 1/2] proc: mm: export PTE sizes directly in smaps
Date: Wed, 25 Oct 2017 08:27:34 +0800
Message-ID: <1508891255-15427-1-git-send-email-fan.du@intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fan Du <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

/proc/$pid/smaps has a number of fields that are intended to imply the
kinds of PTEs used to map memory.  "AnonHugePages" obviously tells you
how many PMDs are being used.  "MMUPageSize" along with the "Hugetlb"
fields tells you how many PTEs you have for a huge page.

The current mechanisms work fine when we have one or two page sizes.
But, they start to get a bit muddled when we mix page sizes inside
one VMA.  For instance, the DAX folks were proposing adding a set of
fields like:

	DevicePages:
	DeviceHugePages:
	DeviceGiganticPages:
	DeviceGinormousPages:

to unmuddle things when page sizes get mixed.  That's fine, but
it does require userspace know the mapping from our various
arbitrary names to hardware page sizes on each architecture and
kernel configuration.  That seems rather suboptimal.

What folks really want is to know how much memory is mapped with
each page size.  How about we just do *that* instead?

Patch attached.  Seems harmless enough.  Seems to compile on a
bunch of random architectures.  Makes smaps look like this:

Private_Hugetlb:       0 kB
Swap:                  0 kB
SwapPss:               0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Locked:                0 kB
Ptes@4kB:	      32 kB
Ptes@2MB:	    2048 kB

The format I used here should be unlikely to break smaps parsers
unless they're looking for "kB" and now match the 'Ptes@4kB' instead
of the one at the end of the line.

Note: hugetlbfs PTEs are unusual.  We can have more than one "pte_t"
for each hugetlbfs "page".  arm64 has this configuration, and probably
others.  The code should now handle when an hstate's size is not equal
to one of the page table entry sizes.  For instance, it assumes that
hstates between PMD_SIZE and PUD_SIZE are made up of multiple PMDs
and prints them as such.

I've tested this on x86 with normal 4k ptes, anonymous huge pages,
1G hugetlbfs and 2M hugetlbfs pages.

1. I'd like to thank Dan Williams for showing me a mirror as I
   complained about the bozo that introduced 'AnonHugePages'.

[Fan]
Rebase the original patch from Dave Hansen by fixing a couple of compile
issues.

Signed-off-by: Fan Du <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/filesystems/proc.txt |   6 +++
 fs/proc/task_mmu.c                 | 106 ++++++++++++++++++++++++++++++++++++-
 mm/hugetlb.c                       |  11 ++++
 3 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index adba21b..a11ab80 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -423,6 +423,9 @@ SwapPss:               0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
 Locked:                0 kB
+Ptes@4kB:	       4 kB
+Ptes@2MB:	    8192 kB
+
 VmFlags: rd ex mr mw me dw
 
 the first of these lines shows the same information as is displayed for the
@@ -460,6 +463,9 @@ replaced by copy-on-write) part of the underlying shmem object out on swap.
 "SwapPss" shows proportional swap share of this mapping. Unlike "Swap", this
 does not take into account swapped out page of underlying shmem objects.
 "Locked" indicates whether the mapping is locked in memory or not.
+"Ptes@..." lines show how many page table entries are currently in place and
+pointing to memory.  There is an entry for each size present in the hardware
+page tables for this mapping.
 
 "VmFlags" field deserves a separate description. This member represents the kernel
 flags associated with the particular virtual memory area in two letter encoded
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5589b4b..30dbf37 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -451,6 +451,9 @@ struct mem_size_stats {
 	unsigned long shared_hugetlb;
 	unsigned long private_hugetlb;
 	unsigned long first_vma_start;
+	unsigned long rss_pte;
+	unsigned long rss_pmd;
+	unsigned long rss_pud;
 	u64 pss;
 	u64 pss_locked;
 	u64 swap_pss;
@@ -529,6 +532,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 
 	if (pte_present(*pte)) {
 		page = vm_normal_page(vma, addr, *pte);
+		mss->rss_pte += PAGE_SIZE;
 	} else if (is_swap_pte(*pte)) {
 		swp_entry_t swpent = pte_to_swp_entry(*pte);
 
@@ -590,6 +594,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 		/* pass */;
 	else
 		VM_BUG_ON_PAGE(1, page);
+	mss->rss_pmd += PMD_SIZE;
 	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd));
 }
 #else
@@ -699,6 +704,30 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
+/*
+ * Most architectures have a 1:1 mapping of PTEs to hugetlb page
+ * sizes, but there are some outliers like arm64 that use
+ * multiple hardware PTEs to make a hugetlb "page".  Do not
+ * assume that all 'hpage_size's are not exactly at a page table
+ * size boundary.  Instead, accept arbitrary 'hpage_size's and
+ * assume they are made up of the next-smallest size.  We do not
+ * handle PGD-sized hpages and hugetlb_add_hstate() will WARN()
+ * if it sees one.
+ *
+ * Note also that the page walker code only calls us once per
+ * huge 'struct page', *not* once per PTE in the page tables.
+ */
+static void smaps_hugetlb_present_hpage(struct mem_size_stats *mss,
+					unsigned long hpage_size)
+{
+	if (hpage_size >= PUD_SIZE)
+		mss->rss_pud += hpage_size;
+	else if (hpage_size >= PMD_SIZE)
+		mss->rss_pmd += hpage_size;
+	else
+		mss->rss_pte += hpage_size;
+}
+
 static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 				 unsigned long addr, unsigned long end,
 				 struct mm_walk *walk)
@@ -719,11 +748,14 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 	}
 	if (page) {
 		int mapcount = page_mapcount(page);
+		unsigned long hpage_size = huge_page_size(hstate_vma(vma));
+
+		smaps_hugetlb_present_hpage(mss, hpage_size);
 
 		if (mapcount >= 2)
-			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
+			mss->shared_hugetlb += hpage_size;
 		else
-			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
+			mss->private_hugetlb += hpage_size;
 	}
 	return 0;
 }
@@ -733,6 +765,75 @@ void __weak arch_show_smap(struct seq_file *m, struct vm_area_struct *vma)
 {
 }
 
+/*
+ * What units should we use for a given number?  We want
+ * 2048 to be 2k, so we return 'k'.  1048576 should be
+ * 1M, so we return 'M'.
+ */
+static char size_unit(unsigned long long nr)
+{
+	/*
+	 * This ' ' might look a bit goofy in the output.  But, why
+	 * bother doing anything.  Do we even have a <1k page size?
+	 */
+	if (nr < (1ULL<<10))
+		return ' ';
+	if (nr < (1ULL<<20))
+		return 'k';
+	if (nr < (1ULL<<30))
+		return 'M';
+	if (nr < (1ULL<<40))
+		return 'G';
+	if (nr < (1ULL<<50))
+		return 'T';
+	if (nr < (1ULL<<60))
+		return 'P';
+	return 'E';
+}
+
+/*
+ * How should we shift down a a given number to scale it
+ * with the units we are printing it as? 2048 to be 2k,
+ * so we want it shifted down by 10.  1048576 should be
+ * 1M, so we want it shifted down by 20.
+ */
+static int size_shift(unsigned long long nr)
+{
+	if (nr < (1ULL<<10))
+		return 0;
+	if (nr < (1ULL<<20))
+		return 10;
+	if (nr < (1ULL<<30))
+		return 20;
+	if (nr < (1ULL<<40))
+		return 30;
+	if (nr < (1ULL<<50))
+		return 40;
+	if (nr < (1ULL<<60))
+		return 50;
+	return 60;
+}
+
+static void show_one_smap_pte(struct seq_file *m, unsigned long bytes_rss,
+		unsigned long pte_size)
+{
+	seq_printf(m, "Ptes@%ld%cB:	%8lu kB\n",
+			pte_size >> size_shift(pte_size),
+			size_unit(pte_size),
+			bytes_rss >> 10);
+}
+
+static void show_smap_ptes(struct seq_file *m, struct mem_size_stats *mss)
+{
+	/* Only print the entries for page sizes present in the VMA */
+	if (mss->rss_pte)
+		show_one_smap_pte(m, mss->rss_pte, PAGE_SIZE);
+	if (mss->rss_pmd)
+		show_one_smap_pte(m, mss->rss_pmd, PMD_SIZE);
+	if (mss->rss_pud)
+		show_one_smap_pte(m, mss->rss_pud, PUD_SIZE);
+}
+
 static int show_smap(struct seq_file *m, void *v, int is_pid)
 {
 	struct proc_maps_private *priv = m->private;
@@ -852,6 +953,7 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 			   (unsigned long)(mss->pss >> (10 + PSS_SHIFT)));
 
 	if (!rollup_mode) {
+		show_smap_ptes(m, mss);
 		arch_show_smap(m, vma);
 		show_smap_vma_flags(m, vma);
 	}
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 424b0ef..b98b2ce 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2836,6 +2836,17 @@ void __init hugetlb_add_hstate(unsigned int order)
 					huge_page_size(h)/1024);
 
 	parsed_hstate = h;
+
+	/*
+	 * PGD_SIZE isn't widely made available by architecures,
+	 * so use PUD_SIZE*PTRS_PER_PUD as a substitute.
+	 *
+	 * Check for sizes that might be mapped by a PGD.  There
+	 * are none of these known today, but be on the lookout.
+	 * If this trips, we will need to update the mss->rss_*
+	 * code in fs/proc/task_mmu.c.
+	 */
+	WARN_ON_ONCE((PAGE_SIZE << order) >= PUD_SIZE * PTRS_PER_PUD);
 }
 
 static int __init hugetlb_nrpages_setup(char *s)
-- 
1.8.3.1
