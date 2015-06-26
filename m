From: Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
Subject: [RFCv2 5/5] mm: remove direct calling of migration
Date: Fri, 26 Jun 2015 18:58:30 +0900
Message-ID: <1435312710-15108-6-git-send-email-gioh.kim@lge.com>
References: <1435312710-15108-1-git-send-email-gioh.kim@lge.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435312710-15108-1-git-send-email-gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Migration is completely generalized.

Signed-off-by: Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
---
 mm/balloon_compaction.c |  8 --------
 mm/migrate.c            | 15 ---------------
 2 files changed, 23 deletions(-)

diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index df72846..a7b7c79 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -206,13 +206,6 @@ int balloon_page_migrate(struct address_space *mapping,
 	if (!isolated_balloon_page(page))
 		return rc;
 
-	/*
-	 * Block others from accessing the 'newpage' when we get around to
-	 * establishing additional references. We should be the only one
-	 * holding a reference to the 'newpage' at this point.
-	 */
-	BUG_ON(!trylock_page(newpage));
-
 	if (WARN_ON(!__is_movable_balloon_page(page))) {
 		dump_page(page, "not movable balloon page");
 		unlock_page(newpage);
@@ -222,7 +215,6 @@ int balloon_page_migrate(struct address_space *mapping,
 	if (balloon && balloon->migratepage)
 		rc = balloon->migratepage(balloon, newpage, page, mode);
 
-	unlock_page(newpage);
 	return rc;
 }
 
diff --git a/mm/migrate.c b/mm/migrate.c
index a0bc1e4..0b52fa4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -844,21 +844,6 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
 		}
 	}
 
-	if (unlikely(driver_page_migratable(page))) {
-		/*
-		 * A driver page does not need any special attention from
-		 * physical to virtual reverse mapping procedures.
-		 * Skip any attempt to unmap PTEs or to remap swap cache,
-		 * in order to avoid burning cycles at rmap level, and perform
-		 * the page migration right away (proteced by page lock).
-		 */
-		rc = page->mapping->a_ops->migratepage(page->mapping,
-						       newpage,
-						       page,
-						       mode);
-		goto out_unlock;
-	}
-
 	/*
 	 * Corner case handling:
 	 * 1. When a new swap-cache page is read into, it is added to the LRU
-- 
1.9.1
