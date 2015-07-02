From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/10] mm/hugetlb: vma_has_reserves() needs to handle fallocate hole punch
Date: Thu,  2 Jul 2015 08:38:42 -0700
Message-ID: <1435851526-4200-7-git-send-email-mike.kravetz@oracle.com>
References: <1435851526-4200-1-git-send-email-mike.kravetz@oracle.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435851526-4200-1-git-send-email-mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Aneesh Kumar <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Hillf Danton <hillf.zj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

In vma_has_reserves(), the current assumption is that reserves are
always present for shared mappings.  However, this will not be the
case with fallocate hole punch.  When punching a hole, the present
page will be deleted as well as the region/reserve map entry (and
hence any reservation).  vma_has_reserves is passed "chg" which
indicates whether or not a region/reserve map is present.  Use
this to determine if reserves are actually present or were removed
via hole punch.

Signed-off-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 mm/hugetlb.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1c3049c..5923c21 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -800,9 +800,19 @@ static int vma_has_reserves(struct vm_area_struct *vma, long chg)
 			return 0;
 	}
 
-	/* Shared mappings always use reserves */
-	if (vma->vm_flags & VM_MAYSHARE)
-		return 1;
+	if (vma->vm_flags & VM_MAYSHARE) {
+		/*
+		 * We know VM_NORESERVE is not set.  Therefore, there SHOULD
+		 * be a region map for all pages.  The only situation where
+		 * there is no region map is if a hole was punched via
+		 * fallocate.  In this case, there really are no reverves to
+		 * use.  This situation is indicated if chg != 0.
+		 */
+		if (chg)
+			return 0;
+		else
+			return 1;
+	}
 
 	/*
 	 * Only the process that called mmap() has reserves for
-- 
2.1.0
