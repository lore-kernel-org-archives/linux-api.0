From: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 3/4] pagemap: hide physical addresses from non-privileged
 users
Date: Tue, 09 Jun 2015 23:00:19 +0300
Message-ID: <20150609200019.21971.54721.stgit@zurg>
References: <20150609195333.21971.58194.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150609195333.21971.58194.stgit@zurg>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>

This patch makes pagemap readable for normal users back but hides physical
addresses from them. For some use cases PFN isn't required at all: flags
give information about presence, page type (anon/file/swap), soft-dirty mark,
and hint about page mapcount state: exclusive(mapcount = 1) or (mapcount > 1).

Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Fixes: ab676b7d6fbf ("pagemap: do not leak physical addresses to non-privileged userspace")
Link: http://lkml.kernel.org/r/1425935472-17949-1-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org

---

v3: get capabilities from file
---
 fs/proc/task_mmu.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index b02e38f..f1b9ae8 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -962,6 +962,7 @@ struct pagemapread {
 	int pos, len;		/* units: PM_ENTRY_BYTES, not bytes */
 	pagemap_entry_t *buffer;
 	bool v2;
+	bool show_pfn;
 };
 
 #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
@@ -1046,12 +1047,13 @@ out:
 static void pte_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
 		struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
-	u64 frame, flags;
+	u64 frame = 0, flags;
 	struct page *page = NULL;
 	int flags2 = 0;
 
 	if (pte_present(pte)) {
-		frame = pte_pfn(pte);
+		if (pm->show_pfn)
+			frame = pte_pfn(pte);
 		flags = PM_PRESENT;
 		page = vm_normal_page(vma, addr, pte);
 		if (pte_soft_dirty(pte))
@@ -1087,15 +1089,19 @@ static void pte_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
 static void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
 		pmd_t pmd, int offset, int pmd_flags2)
 {
+	u64 frame = 0;
+
 	/*
 	 * Currently pmd for thp is always present because thp can not be
 	 * swapped-out, migrated, or HWPOISONed (split in such cases instead.)
 	 * This if-check is just to prepare for future implementation.
 	 */
-	if (pmd_present(pmd))
-		*pme = make_pme(PM_PFRAME(pmd_pfn(pmd) + offset)
-				| PM_STATUS2(pm->v2, pmd_flags2) | PM_PRESENT);
-	else
+	if (pmd_present(pmd)) {
+		if (pm->show_pfn)
+			frame = pmd_pfn(pmd) + offset;
+		*pme = make_pme(PM_PFRAME(frame) | PM_PRESENT |
+				PM_STATUS2(pm->v2, pmd_flags2));
+	} else
 		*pme = make_pme(PM_NOT_PRESENT(pm->v2) | PM_STATUS2(pm->v2, pmd_flags2));
 }
 #else
@@ -1171,11 +1177,14 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 static void huge_pte_to_pagemap_entry(pagemap_entry_t *pme, struct pagemapread *pm,
 					pte_t pte, int offset, int flags2)
 {
-	if (pte_present(pte))
-		*pme = make_pme(PM_PFRAME(pte_pfn(pte) + offset)	|
-				PM_STATUS2(pm->v2, flags2)		|
-				PM_PRESENT);
-	else
+	u64 frame = 0;
+
+	if (pte_present(pte)) {
+		if (pm->show_pfn)
+			frame = pte_pfn(pte) + offset;
+		*pme = make_pme(PM_PFRAME(frame) | PM_PRESENT |
+				PM_STATUS2(pm->v2, flags2));
+	} else
 		*pme = make_pme(PM_NOT_PRESENT(pm->v2)			|
 				PM_STATUS2(pm->v2, flags2));
 }
@@ -1258,6 +1267,8 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	if (!count)
 		goto out_mm;
 
+	/* do not disclose physical addresses: attack vector */
+	pm.show_pfn = file_ns_capable(file, &init_user_ns, CAP_SYS_ADMIN);
 	pm.v2 = soft_dirty_cleared;
 	pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
 	pm.buffer = kmalloc(pm.len * PM_ENTRY_BYTES, GFP_TEMPORARY);
@@ -1328,9 +1339,6 @@ static int pagemap_open(struct inode *inode, struct file *file)
 {
 	struct mm_struct *mm;
 
-	/* do not disclose physical addresses: attack vector */
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	pr_warn_once("Bits 55-60 of /proc/PID/pagemap entries are about "
 			"to stop being page-shift some time soon. See the "
 			"linux/Documentation/vm/pagemap.txt for details.\n");
