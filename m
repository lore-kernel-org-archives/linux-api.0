From: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] mm: fix status code move_pages() returns for zero page
Date: Wed, 24 Jun 2015 13:23:48 +0300
Message-ID: <1435141428-98266-1-git-send-email-kirill.shutemov@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Man page for move_pages(2) specifies that status code for zero page is
supposed to be -EFAULT. Currently kernel return -ENOENT in this case.

follow_page() can do it for us, if we would ask for FOLL_DUMP.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/migrate.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 236ee25e79d9..d3529d620a5b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1222,7 +1222,9 @@ static int do_move_page_to_node_array(struct mm_struct *mm,
 		if (!vma || pp->addr < vma->vm_start || !vma_migratable(vma))
 			goto set_status;
 
-		page = follow_page(vma, pp->addr, FOLL_GET|FOLL_SPLIT);
+		/* FOLL_DUMP to ignore special (like zero) pages */
+		page = follow_page(vma, pp->addr,
+				FOLL_GET | FOLL_SPLIT | FOLL_DUMP);
 
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
@@ -1232,10 +1234,6 @@ static int do_move_page_to_node_array(struct mm_struct *mm,
 		if (!page)
 			goto set_status;
 
-		/* Use PageReserved to check for zero page */
-		if (PageReserved(page))
-			goto put_and_set;
-
 		pp->page = page;
 		err = page_to_nid(page);
 
@@ -1392,18 +1390,14 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 		if (!vma || addr < vma->vm_start)
 			goto set_status;
 
-		page = follow_page(vma, addr, 0);
+		/* FOLL_DUMP to ignore special (like zero) pages */
+		page = follow_page(vma, addr, FOLL_DUMP);
 
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
 			goto set_status;
 
-		err = -ENOENT;
-		/* Use PageReserved to check for zero page */
-		if (!page || PageReserved(page))
-			goto set_status;
-
-		err = page_to_nid(page);
+		err = page ? page_to_nid(page) : -ENOENT;
 set_status:
 		*status = err;
 
-- 
2.1.4
