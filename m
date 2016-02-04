From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 4/5] powerpc: query dynamic DEBUG_PAGEALLOC setting
Date: Thu,  4 Feb 2016 14:56:25 +0900
Message-ID: <1454565386-10489-5-git-send-email-iamjoonsoo.kim@lge.com>
References: <1454565386-10489-1-git-send-email-iamjoonsoo.kim@lge.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1454565386-10489-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Christian Borntraeger <borntraeger@de.ibm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Takashi Iwai <tiwai@suse.com>, Chris Metcalf <cmetcalf@ezchip.com>, Christoph Lameter <cl@linux.com>, linux-api@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
List-Id: linux-api@vger.kernel.org

We can disable debug_pagealloc processing even if the code is complied
with CONFIG_DEBUG_PAGEALLOC. This patch changes the code to query
whether it is enabled or not in runtime.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 arch/powerpc/kernel/traps.c     |  5 ++---
 arch/powerpc/mm/hash_utils_64.c | 40 ++++++++++++++++++++--------------------
 arch/powerpc/mm/init_32.c       |  8 ++++----
 3 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index b6becc7..33c47fc 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -203,9 +203,8 @@ static int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 #ifdef CONFIG_SMP
 	printk("SMP NR_CPUS=%d ", NR_CPUS);
 #endif
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	printk("DEBUG_PAGEALLOC ");
-#endif
+	if (debug_pagealloc_enabled())
+		printk("DEBUG_PAGEALLOC ");
 #ifdef CONFIG_NUMA
 	printk("NUMA ");
 #endif
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index ba59d59..03a622b 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -255,10 +255,10 @@ int htab_bolt_mapping(unsigned long vstart, unsigned long vend,
 
 		if (ret < 0)
 			break;
-#ifdef CONFIG_DEBUG_PAGEALLOC
-		if ((paddr >> PAGE_SHIFT) < linear_map_hash_count)
+
+		if (debug_pagealloc_enabled() &&
+			(paddr >> PAGE_SHIFT) < linear_map_hash_count)
 			linear_map_hash_slots[paddr >> PAGE_SHIFT] = ret | 0x80;
-#endif /* CONFIG_DEBUG_PAGEALLOC */
 	}
 	return ret < 0 ? ret : 0;
 }
@@ -512,17 +512,17 @@ static void __init htab_init_page_sizes(void)
 	if (mmu_has_feature(MMU_FTR_16M_PAGE))
 		memcpy(mmu_psize_defs, mmu_psize_defaults_gp,
 		       sizeof(mmu_psize_defaults_gp));
- found:
-#ifndef CONFIG_DEBUG_PAGEALLOC
-	/*
-	 * Pick a size for the linear mapping. Currently, we only support
-	 * 16M, 1M and 4K which is the default
-	 */
-	if (mmu_psize_defs[MMU_PAGE_16M].shift)
-		mmu_linear_psize = MMU_PAGE_16M;
-	else if (mmu_psize_defs[MMU_PAGE_1M].shift)
-		mmu_linear_psize = MMU_PAGE_1M;
-#endif /* CONFIG_DEBUG_PAGEALLOC */
+found:
+	if (!debug_pagealloc_enabled()) {
+		/*
+		 * Pick a size for the linear mapping. Currently, we only
+		 * support 16M, 1M and 4K which is the default
+		 */
+		if (mmu_psize_defs[MMU_PAGE_16M].shift)
+			mmu_linear_psize = MMU_PAGE_16M;
+		else if (mmu_psize_defs[MMU_PAGE_1M].shift)
+			mmu_linear_psize = MMU_PAGE_1M;
+	}
 
 #ifdef CONFIG_PPC_64K_PAGES
 	/*
@@ -720,12 +720,12 @@ static void __init htab_initialize(void)
 
 	prot = pgprot_val(PAGE_KERNEL);
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	linear_map_hash_count = memblock_end_of_DRAM() >> PAGE_SHIFT;
-	linear_map_hash_slots = __va(memblock_alloc_base(linear_map_hash_count,
-						    1, ppc64_rma_size));
-	memset(linear_map_hash_slots, 0, linear_map_hash_count);
-#endif /* CONFIG_DEBUG_PAGEALLOC */
+	if (debug_pagealloc_enabled()) {
+		linear_map_hash_count = memblock_end_of_DRAM() >> PAGE_SHIFT;
+		linear_map_hash_slots = __va(memblock_alloc_base(
+				linear_map_hash_count, 1, ppc64_rma_size));
+		memset(linear_map_hash_slots, 0, linear_map_hash_count);
+	}
 
 	/* On U3 based machines, we need to reserve the DART area and
 	 * _NOT_ map it to avoid cache paradoxes as it's remapped non
diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index a10be66..c2b7716 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -112,10 +112,10 @@ void __init MMU_setup(void)
 	if (strstr(boot_command_line, "noltlbs")) {
 		__map_without_ltlbs = 1;
 	}
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	__map_without_bats = 1;
-	__map_without_ltlbs = 1;
-#endif
+	if (debug_pagealloc_enabled()) {
+		__map_without_bats = 1;
+		__map_without_ltlbs = 1;
+	}
 }
 
 /*
-- 
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
