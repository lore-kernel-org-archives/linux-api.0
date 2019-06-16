From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: [PATCH NOTFORMERGE 2/5] mm: revert madvise_inject_error line split
Date: Sun, 16 Jun 2019 10:58:32 +0200
Message-ID: <20190616085835.953-3-oleksandr@redhat.com>
References: <20190616085835.953-1-oleksandr@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190616085835.953-1-oleksandr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Just to highlight it after our conversation.

Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
---
 mm/madvise.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index edb7184f665c..70aeb54f3e1c 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1041,8 +1041,7 @@ static int madvise_common(struct task_struct *task, struct mm_struct *mm,
 
 #ifdef CONFIG_MEMORY_FAILURE
 	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
-		return madvise_inject_error(behavior,
-					start, start + len_in);
+		return madvise_inject_error(behavior, start, start + len_in);
 #endif
 
 	write = madvise_need_mmap_write(behavior);
-- 
2.22.0
