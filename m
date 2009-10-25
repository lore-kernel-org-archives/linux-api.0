From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [v9][PATCH 1/9] Factor out code to allocate pidmap page
Date: Sat, 24 Oct 2009 20:37:24 -0700
Message-ID: <20091025033724.GB20327@us.ibm.com>
References: <20091025033508.GA20327@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091025033508.GA20327-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>
Cc: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, sukadev-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Subject: [v9][PATCH 1/9] Factor out code to allocate pidmap page

To simplify alloc_pidmap(), move code to allocate a pid map page to a
separate function.

Changelog[v3]:
	- Earlier version of patchset called alloc_pidmap_page() from two
	  places. But now its called from only one place. Even so, moving
	  this code out into a separate function simplifies alloc_pidmap().
Changelog[v2]:
	- (Matt Helsley, Dave Hansen) Have alloc_pidmap_page() return
	  -ENOMEM on error instead of -1.

Signed-off-by: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Acked-by: Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
---
 kernel/pid.c |   45 ++++++++++++++++++++++++++++++---------------
 1 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index d3f722d..7d4bb6e 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -122,9 +122,35 @@ static void free_pidmap(struct upid *upid)
 	atomic_inc(&map->nr_free);
 }
 
+static int alloc_pidmap_page(struct pidmap *map)
+{
+	void *page;
+
+	if (likely(map->page))
+		return 0;
+
+	page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+
+	/*
+	 * Free the page if someone raced with us installing it:
+	 */
+	spin_lock_irq(&pidmap_lock);
+	if (map->page)
+		kfree(page);
+	else
+		map->page = page;
+	spin_unlock_irq(&pidmap_lock);
+
+	if (unlikely(!map->page))
+		return -ENOMEM;
+
+	return 0;
+}
+
 static int alloc_pidmap(struct pid_namespace *pid_ns)
 {
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
+	int rc;
 	struct pidmap *map;
 
 	pid = last + 1;
@@ -134,21 +160,10 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
 	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
 	for (i = 0; i <= max_scan; ++i) {
-		if (unlikely(!map->page)) {
-			void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
-			/*
-			 * Free the page if someone raced with us
-			 * installing it:
-			 */
-			spin_lock_irq(&pidmap_lock);
-			if (map->page)
-				kfree(page);
-			else
-				map->page = page;
-			spin_unlock_irq(&pidmap_lock);
-			if (unlikely(!map->page))
-				break;
-		}
+		rc = alloc_pidmap_page(map);
+		if (rc)
+			break;
+
 		if (likely(atomic_read(&map->nr_free))) {
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
-- 
