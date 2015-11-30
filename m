From: Minchan Kim <minchan@kernel.org>
Subject: [PATCH v5 06/12] mm: mark stable page dirty in KSM
Date: Mon, 30 Nov 2015 15:39:37 +0900
Message-ID: <1448865583-2446-7-git-send-email-minchan@kernel.org>
References: <1448865583-2446-1-git-send-email-minchan@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1448865583-2446-1-git-send-email-minchan@kernel.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jason Evans <je@fb.com>, Daniel Micay <danielmicay@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Shaohua Li <shli@kernel.org>, Michal Hocko <mhocko@suse.cz>, yalin.wang2010@gmail.com, Andy Lutomirski <luto@amacapital.net>, Minchan Kim <minchan@kernel.org>
List-Id: linux-api@vger.kernel.org

The MADV_FREE patchset changes page reclaim to simply free a clean
anonymous page with no dirty ptes, instead of swapping it out; but
KSM uses clean write-protected ptes to reference the stable ksm page.
So be sure to mark that page dirty, so it's never mistakenly discarded.

[hughd: adjusted comments]
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/ksm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 30cb0f753e19..5e967536c38e 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1015,6 +1015,12 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
 			 */
 			set_page_stable_node(page, NULL);
 			mark_page_accessed(page);
+			/*
+			 * Page reclaim just frees a clean page with no dirty
+			 * ptes: make sure that the ksm page would be swapped.
+			 */
+			if (!PageDirty(page))
+				SetPageDirty(page);
 			err = 0;
 		} else if (pages_identical(page, kpage))
 			err = replace_page(vma, page, kpage, orig_pte);
-- 
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
