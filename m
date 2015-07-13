From: Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
Subject: [PATCH 4/4] mm: remove direct calling of migration
Date: Mon, 13 Jul 2015 17:35:19 +0900
Message-ID: <1436776519-17337-5-git-send-email-gioh.kim@lge.com>
References: <1436776519-17337-1-git-send-email-gioh.kim@lge.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436776519-17337-1-git-send-email-gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Gioh Kim <gurugio-A7HHaXTFBl7R7s880joybQ@public.gmane.org>, Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Gioh Kim <gurugio-A7HHaXTFBl7R7s880joybQ@public.gmane.org>

Migration is completely generalized so that migrating mobile page
is processed with lru-pages in move_to_new_page.

Signed-off-by: Gioh Kim <gioh.kim-Hm3cg6mZ9cc@public.gmane.org>
Acked-by: Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/migrate.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 53f0081d..e6644ac 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -844,21 +844,6 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
 		}
 	}
 
-	if (unlikely(mobile_page(page))) {
-		/*
-		 * A mobile page does not need any special attention from
-		 * physical to virtual reverse mapping procedures.
-		 * Skip any attempt to unmap PTEs or to remap swap cache,
-		 * in order to avoid burning cycles at rmap level, and perform
-		 * the page migration right away (proteced by page lock).
-		 */
-		lock_page(newpage);
-		rc = page->mapping->a_ops->migratepage(page->mapping,
-						       newpage, page, mode);
-		unlock_page(newpage);
-		goto out_unlock;
-	}
-
 	/*
 	 * Corner case handling:
 	 * 1. When a new swap-cache page is read into, it is added to the LRU
-- 
2.1.4
