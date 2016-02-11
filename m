From: js1304@gmail.com
Subject: [PATCH v2 1/5] mm/vmalloc: query dynamic DEBUG_PAGEALLOC setting
Date: Thu, 11 Feb 2016 13:04:57 +0900
Message-ID: <1455163501-9341-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1455163501-9341-1-git-send-email-iamjoonsoo.kim@lge.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1455163501-9341-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Christian Borntraeger <borntraeger@de.ibm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Takashi Iwai <tiwai@suse.com>, Chris Metcalf <cmetcalf@ezchip.com>, Christoph Lameter <cl@linux.com>, linux-api@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
List-Id: linux-api@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

We can disable debug_pagealloc processing even if the code is compiled
with CONFIG_DEBUG_PAGEALLOC. This patch changes the code to query
whether it is enabled or not in runtime.

v2: update comment, per David.
adjust comment to use 80 cols, per Andrew.

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/vmalloc.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index fb42a5b..d4b2e34 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -531,22 +531,21 @@ static void unmap_vmap_area(struct vmap_area *va)
 static void vmap_debug_free_range(unsigned long start, unsigned long end)
 {
 	/*
-	 * Unmap page tables and force a TLB flush immediately if
-	 * CONFIG_DEBUG_PAGEALLOC is set. This catches use after free
-	 * bugs similarly to those in linear kernel virtual address
-	 * space after a page has been freed.
+	 * Unmap page tables and force a TLB flush immediately if pagealloc
+	 * debugging is enabled.  This catches use after free bugs similarly to
+	 * those in linear kernel virtual address space after a page has been
+	 * freed.
 	 *
-	 * All the lazy freeing logic is still retained, in order to
-	 * minimise intrusiveness of this debugging feature.
+	 * All the lazy freeing logic is still retained, in order to minimise
+	 * intrusiveness of this debugging feature.
 	 *
-	 * This is going to be *slow* (linear kernel virtual address
-	 * debugging doesn't do a broadcast TLB flush so it is a lot
-	 * faster).
+	 * This is going to be *slow* (linear kernel virtual address debugging
+	 * doesn't do a broadcast TLB flush so it is a lot faster).
 	 */
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	vunmap_page_range(start, end);
-	flush_tlb_kernel_range(start, end);
-#endif
+	if (debug_pagealloc_enabled()) {
+		vunmap_page_range(start, end);
+		flush_tlb_kernel_range(start, end);
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
