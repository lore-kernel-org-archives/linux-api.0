From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] mm/hugetlb: Fix NULL-pointer dereference on 5-level paging machine
Date: Wed, 22 Nov 2017 15:19:21 +0300
Message-ID: <20171122121921.64822-1-kirill.shutemov@linux.intel.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, stable@vger.kernel.org
List-Id: linux-api@vger.kernel.org

I've made mistake during converting hugetlb code to 5-level paging:
in huge_pte_alloc() we have to use p4d_alloc(), not p4d_offset().
Otherwise it leads to crash -- NULL-pointer dereference in pud_alloc()
if p4d table is not yet allocated.

It only can happen in 5-level paging mode. In 4-level paging mode
p4d_offset() always returns pgd, so we are fine.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: c2febafc6773 ("mm: convert generic code to 5-level paging")
Cc: <stable@vger.kernel.org> # v4.11+
---
 mm/hugetlb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2d2ff5e8bf2b..94a4c0b63580 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4617,7 +4617,9 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 	pte_t *pte = NULL;
 
 	pgd = pgd_offset(mm, addr);
-	p4d = p4d_offset(pgd, addr);
+	p4d = p4d_alloc(mm, pgd, addr);
+	if (!p4d)
+		return NULL;
 	pud = pud_alloc(mm, p4d, addr);
 	if (pud) {
 		if (sz == PUD_SIZE) {
-- 
2.15.0
