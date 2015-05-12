From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: [PATCH v2 2/3] pagemap: hide physical addresses from non-privileged
 users
Date: Tue, 12 May 2015 12:43:05 +0300
Message-ID: <20150512094305.24768.51807.stgit@buzz>
References: <20150512090156.24768.2521.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150512090156.24768.2521.stgit@buzz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch makes pagemap readable for normal users back but hides physical
addresses from them. For some use cases PFN isn't required at all: flags
give information about presence, page type (anon/file/swap), soft-dirty mark,
and hint about page mapcount state: exclusive(mapcount = 1) or (mapcount > 1).

Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Fixes: ab676b7d6fbf ("pagemap: do not leak physical addresses to non-privileged userspace")
Link: lkml.kernel.org/r/1425935472-17949-1-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org
---
 fs/proc/task_mmu.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 29febec65de4..0b7a8ffec95f 100644
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
@@ -1260,6 +1269,8 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	if (!count)
 		goto out_task;
 
+	/* do not disclose physical addresses: attack vector */
+	pm.show_pfn = capable(CAP_SYS_ADMIN);
 	pm.v2 = soft_dirty_cleared;
 	pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
 	pm.buffer = kmalloc(pm.len * PM_ENTRY_BYTES, GFP_TEMPORARY);
@@ -1335,9 +1346,6 @@ out:
 
 static int pagemap_open(struct inode *inode, struct file *file)
 {
-	/* do not disclose physical addresses: attack vector */
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	pr_warn_once("Bits 55-60 of /proc/PID/pagemap entries are about "
 			"to stop being page-shift some time soon. See the "
 			"linux/Documentation/vm/pagemap.txt for details.\n");
