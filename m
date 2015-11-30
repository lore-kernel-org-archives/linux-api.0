From: Minchan Kim <minchan@kernel.org>
Subject: [PATCH v5 10/12] arm: add pmd_mkclean for THP
Date: Mon, 30 Nov 2015 15:39:41 +0900
Message-ID: <1448865583-2446-11-git-send-email-minchan@kernel.org>
References: <1448865583-2446-1-git-send-email-minchan@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1448865583-2446-1-git-send-email-minchan@kernel.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jason Evans <je@fb.com>, Daniel Micay <danielmicay@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Shaohua Li <shli@kernel.org>, Michal Hocko <mhocko@suse.cz>, yalin.wang2010@gmail.com, Andy Lutomirski <luto@amacapital.net>, Minchan Kim <minchan@kernel.org>
List-Id: linux-api@vger.kernel.org

MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent overwrite
of the contents since MADV_FREE syscall is called for THP page.

This patch adds pmd_mkclean for THP page MADV_FREE support.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 arch/arm/include/asm/pgtable-3level.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index 59d1457ca551..dc46398bc3a5 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -240,6 +240,7 @@ PMD_BIT_FUNC(wrprotect,	|= L_PMD_SECT_RDONLY);
 PMD_BIT_FUNC(mkold,	&= ~PMD_SECT_AF);
 PMD_BIT_FUNC(mkwrite,   &= ~L_PMD_SECT_RDONLY);
 PMD_BIT_FUNC(mkdirty,   |= L_PMD_SECT_DIRTY);
+PMD_BIT_FUNC(mkclean,   &= ~L_PMD_SECT_DIRTY);
 PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
 
 #define pmd_mkhuge(pmd)		(__pmd(pmd_val(pmd) & ~PMD_TABLE_BIT))
-- 
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
