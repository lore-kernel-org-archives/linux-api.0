From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: [RFC 3/3] mm: introduce do_munmap_nofail
Date: Tue, 28 Apr 2015 14:11:51 +0200
Message-ID: <1430223111-14817-4-git-send-email-mhocko@suse.cz>
References: <20150114095019.GC4706@dhcp22.suse.cz>
 <1430223111-14817-1-git-send-email-mhocko@suse.cz>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430223111-14817-1-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

vm_mmap_pgoff with MAP_LOCKED need to call do_munmap in case the
population of the area fails. The operation cannot fail for obvious
reasons. The current code simply retries in the loop which is not
very nice.

This patch introduces do_munmap_nofail() which uses __GFP_NOFAIL
for allocations required down the unmap path. It is always better
to loop inside the allocator rather than outside if there is no
sensible way handle the allocation failure.
Allocator can perform additional steps to help the allocation to
succeed (e.g. can get access to memory reserves).

The caller of the function has to make sure that the mapping is
initialized properly - namely [start, len] correspond to an existing VMA
and that the split doesn't exceed sysctl_max_map_count. This is true for
vm_mmap_pgoff so it is safe to be used in this path. The function is for
internal use only so it is not exported to the rest of the kernel.

While we are at it, let's make nommu shrink_vma return void because it
doesn't have any failing path.

Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/internal.h |  4 ++++
 mm/mmap.c     |  6 ++++++
 mm/nommu.c    | 11 ++++++++---
 mm/util.c     | 15 ++-------------
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index a25e359a4039..7f9d1f112d3b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -415,6 +415,10 @@ extern unsigned long vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
 
+/* Caller has to make sure the [addr, len] corresponds to a valid VMA */
+extern void do_munmap_nofail(struct mm_struct * mm,
+			     unsigned long addr, size_t len);
+
 extern void set_pageblock_order(void);
 unsigned long reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *page_list);
diff --git a/mm/mmap.c b/mm/mmap.c
index 4882008dac83..d54544c7b2ba 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2612,6 +2612,12 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 	return __do_munmap_gfp(mm, start, len, GFP_KERNEL);
 }
 
+void do_munmap_nofail(struct mm_struct *mm, unsigned long start, size_t len)
+{
+	BUG_ON(__do_munmap_gfp(mm, start, len, GFP_KERNEL|__GFP_NOFAIL));
+}
+
+
 int vm_munmap(unsigned long start, size_t len)
 {
 	int ret;
diff --git a/mm/nommu.c b/mm/nommu.c
index f1e7b41a2031..9bdd1dedb4cd 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1628,7 +1628,7 @@ int split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
  * shrink a VMA by removing the specified chunk from either the beginning or
  * the end
  */
-static int shrink_vma(struct mm_struct *mm,
+static void shrink_vma(struct mm_struct *mm,
 		      struct vm_area_struct *vma,
 		      unsigned long from, unsigned long to)
 {
@@ -1661,7 +1661,6 @@ static int shrink_vma(struct mm_struct *mm,
 	up_write(&nommu_region_sem);
 
 	free_page_series(from, to);
-	return 0;
 }
 
 /*
@@ -1735,7 +1734,8 @@ static int __do_munmap_gfp(struct mm_struct *mm, unsigned long start, size_t len
 				return ret;
 			}
 		}
-		return shrink_vma(mm, vma, start, end);
+		shrink_vma(mm, vma, start, end);
+		return;
 	}
 
 erase_whole_vma:
@@ -1751,6 +1751,11 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 }
 EXPORT_SYMBOL(do_munmap);
 
+static void do_munmap_nofail(struct mm_struct *mm, unsigned long start, size_t len)
+{
+	BUG_ON(do_munmap(mm, start, len, GFP_KERNEL|__GFP_NOFAIL));
+}
+
 int vm_munmap(unsigned long addr, size_t len)
 {
 	struct mm_struct *mm = current->mm;
diff --git a/mm/util.c b/mm/util.c
index fbffefa3b812..ddac3ea918c2 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -324,21 +324,10 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 		 */
 		if (flag & MAP_LOCKED) {
 			down_write(&mm->mmap_sem);
-			while (!fatal_signal_pending(current)) {
+			if (!fatal_signal_pending(current)) {
 				mm->map_count--;
 				need_map_count_fix = false;
-				if (!do_munmap(mm, ret, populate))
-					break;
-
-				/*
-				 * Do not block other threads to make a progress
-				 * e.g. madvise
-				 */
-				mm->map_count++;
-				need_map_count_fix = true;
-				up_write(&mm->mmap_sem);
-				cond_resched();
-				down_write(&mm->mmap_sem);
+				do_munmap_nofail(mm, ret, populate);
 			}
 			up_write(&mm->mmap_sem);
 
-- 
2.1.4
