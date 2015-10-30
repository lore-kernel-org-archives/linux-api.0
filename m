From: Minchan Kim <minchan@kernel.org>
Subject: [PATCH 6/8] mm: lru_deactivate_fn should clear PG_referenced
Date: Fri, 30 Oct 2015 16:01:42 +0900
Message-ID: <1446188504-28023-7-git-send-email-minchan@kernel.org>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1446188504-28023-1-git-send-email-minchan@kernel.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, zhangyanfei@cn.fujitsu.com, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jason Evans <je@fb.com>, Daniel Micay <danielmicay@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Michal Hocko <mhocko@suse.cz>, yalin.wang2010@gmail.com, Shaohua Li <shli@kernel.org>, Minchan Kim <minchan@kernel.org>
List-Id: linux-api@vger.kernel.org

deactivate_page aims for accelerate for reclaiming through
moving pages from active list to inactive list so we should
clear PG_referenced for the goal.

Acked-by: Hugh Dickins <hughd@google.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/swap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/swap.c b/mm/swap.c
index d0eacc5f62a3..4a6aec976ab1 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -810,6 +810,7 @@ static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
 
 		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
 		ClearPageActive(page);
+		ClearPageReferenced(page);
 		add_page_to_lru_list(page, lruvec, lru);
 
 		__count_vm_event(PGDEACTIVATE);
-- 
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
