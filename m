From: Minchan Kim <minchan@kernel.org>
Subject: [PATCH v14 6/8] arm: add pmd_mkclean for THP
Date: Thu, 14 Aug 2014 10:53:30 +0900
Message-ID: <1407981212-17818-7-git-send-email-minchan@kernel.org>
References: <1407981212-17818-1-git-send-email-minchan@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1407981212-17818-1-git-send-email-minchan@kernel.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Minchan Kim <minchan@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org, Steve Capper <steve.capper@linaro.org>
List-Id: linux-api@vger.kernel.org

MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent
overwrite of the contents since MADV_FREE syscall is called for
THP page.

This patch adds pmd_mkclean for THP page MADV_FREE support.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Steve Capper <steve.capper@linaro.org>
Acked-by: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 arch/arm/include/asm/pgtable-3level.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index 06e0bc0f8b00..bc913a065270 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -234,6 +234,7 @@ PMD_BIT_FUNC(mkold,	&= ~PMD_SECT_AF);
 PMD_BIT_FUNC(mksplitting, |= L_PMD_SECT_SPLITTING);
 PMD_BIT_FUNC(mkwrite,   &= ~L_PMD_SECT_RDONLY);
 PMD_BIT_FUNC(mkdirty,   |= L_PMD_SECT_DIRTY);
+PMD_BIT_FUNC(mkclean,   &= ~L_PMD_SECT_DIRTY);
 PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
 
 #define pmd_mkhuge(pmd)		(__pmd(pmd_val(pmd) & ~PMD_TABLE_BIT))
-- 
2.0.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
