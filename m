From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 3/4] mm: proc/pid/smaps: factor out common stats printing
Date: Mon, 23 Jul 2018 13:19:32 +0200
Message-ID: <20180723111933.15443-4-vbabka@suse.cz>
References: <20180723111933.15443-1-vbabka@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180723111933.15443-1-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Colascione <dancol@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, linux-api@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
List-Id: linux-api@vger.kernel.org

To prepare for handling /proc/pid/smaps_rollup differently from /proc/pid/smaps
factor out from show_smap() printing the parts of output that are common for
both variants, which is the bulk of the gathered memory stats.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 fs/proc/task_mmu.c | 51 ++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d2ca88c92d9d..1d6d315fd31b 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -747,6 +747,32 @@ static void smap_gather_stats(struct vm_area_struct *vma,
 
 #define SEQ_PUT_DEC(str, val) \
 		seq_put_decimal_ull_width(m, str, (val) >> 10, 8)
+
+/* Show the contents common for smaps and smaps_rollup */
+static void __show_smap(struct seq_file *m, struct mem_size_stats *mss)
+{
+	SEQ_PUT_DEC("Rss:            ", mss->resident);
+	SEQ_PUT_DEC(" kB\nPss:            ", mss->pss >> PSS_SHIFT);
+	SEQ_PUT_DEC(" kB\nShared_Clean:   ", mss->shared_clean);
+	SEQ_PUT_DEC(" kB\nShared_Dirty:   ", mss->shared_dirty);
+	SEQ_PUT_DEC(" kB\nPrivate_Clean:  ", mss->private_clean);
+	SEQ_PUT_DEC(" kB\nPrivate_Dirty:  ", mss->private_dirty);
+	SEQ_PUT_DEC(" kB\nReferenced:     ", mss->referenced);
+	SEQ_PUT_DEC(" kB\nAnonymous:      ", mss->anonymous);
+	SEQ_PUT_DEC(" kB\nLazyFree:       ", mss->lazyfree);
+	SEQ_PUT_DEC(" kB\nAnonHugePages:  ", mss->anonymous_thp);
+	SEQ_PUT_DEC(" kB\nShmemPmdMapped: ", mss->shmem_thp);
+	SEQ_PUT_DEC(" kB\nShared_Hugetlb: ", mss->shared_hugetlb);
+	seq_put_decimal_ull_width(m, " kB\nPrivate_Hugetlb: ",
+				  mss->private_hugetlb >> 10, 7);
+	SEQ_PUT_DEC(" kB\nSwap:           ", mss->swap);
+	SEQ_PUT_DEC(" kB\nSwapPss:        ",
+					mss->swap_pss >> PSS_SHIFT);
+	SEQ_PUT_DEC(" kB\nLocked:         ",
+					mss->pss_locked >> PSS_SHIFT);
+	seq_puts(m, " kB\n");
+}
+
 static int show_smap(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
@@ -791,28 +817,9 @@ static int show_smap(struct seq_file *m, void *v)
 		seq_puts(m, " kB\n");
 	}
 
-	if (!rollup_mode || last_vma) {
-		SEQ_PUT_DEC("Rss:            ", mss->resident);
-		SEQ_PUT_DEC(" kB\nPss:            ", mss->pss >> PSS_SHIFT);
-		SEQ_PUT_DEC(" kB\nShared_Clean:   ", mss->shared_clean);
-		SEQ_PUT_DEC(" kB\nShared_Dirty:   ", mss->shared_dirty);
-		SEQ_PUT_DEC(" kB\nPrivate_Clean:  ", mss->private_clean);
-		SEQ_PUT_DEC(" kB\nPrivate_Dirty:  ", mss->private_dirty);
-		SEQ_PUT_DEC(" kB\nReferenced:     ", mss->referenced);
-		SEQ_PUT_DEC(" kB\nAnonymous:      ", mss->anonymous);
-		SEQ_PUT_DEC(" kB\nLazyFree:       ", mss->lazyfree);
-		SEQ_PUT_DEC(" kB\nAnonHugePages:  ", mss->anonymous_thp);
-		SEQ_PUT_DEC(" kB\nShmemPmdMapped: ", mss->shmem_thp);
-		SEQ_PUT_DEC(" kB\nShared_Hugetlb: ", mss->shared_hugetlb);
-		seq_put_decimal_ull_width(m, " kB\nPrivate_Hugetlb: ",
-					  mss->private_hugetlb >> 10, 7);
-		SEQ_PUT_DEC(" kB\nSwap:           ", mss->swap);
-		SEQ_PUT_DEC(" kB\nSwapPss:        ",
-						mss->swap_pss >> PSS_SHIFT);
-		SEQ_PUT_DEC(" kB\nLocked:         ",
-						mss->pss_locked >> PSS_SHIFT);
-		seq_puts(m, " kB\n");
-	}
+	if (!rollup_mode || last_vma)
+		__show_smap(m, mss);
+
 	if (!rollup_mode) {
 		if (arch_pkeys_enabled())
 			seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
-- 
2.18.0
