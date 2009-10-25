From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [v9][PATCH 3/9] Define set_pidmap() function
Date: Sat, 24 Oct 2009 20:38:22 -0700
Message-ID: <20091025033822.GD20327@us.ibm.com>
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


Subject: [v9][PATCH 3/9] Define set_pidmap() function

Define a set_pidmap() interface which is like alloc_pidmap() only that
caller specifies the pid number to be assigned.

Changelog[v9]:
	- Completely rewrote this patch based on Eric Biederman's code.
Changelog[v7]:
        - [Eric Biederman] Generalize alloc_pidmap() to take a range of pids.
Changelog[v6]:
        - Separate target_pid > 0 case to minimize the number of checks needed.
Changelog[v3]:
        - (Eric Biederman): Avoid set_pidmap() function. Added couple of
          checks for target_pid in alloc_pidmap() itself.
Changelog[v2]:
        - (Serge Hallyn) Check for 'pid < 0' in set_pidmap().(Code
          actually checks for 'pid <= 0' for completeness).

Signed-off-by: Sukadev Bhattiprolu <sukadev-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 kernel/pid.c |   40 ++++++++++++++++++++++++++++++++--------
 1 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index c4d9914..52c92b3 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -147,18 +147,19 @@ static int alloc_pidmap_page(struct pidmap *map)
 	return 0;
 }
 
-static int alloc_pidmap(struct pid_namespace *pid_ns)
+static int do_alloc_pidmap(struct pid_namespace *pid_ns, int last, int min,
+		int max)
 {
-	int i, offset, max_scan, pid, last = pid_ns->last_pid;
+	int i, offset, max_scan, pid;
 	int rc = -EAGAIN;
 	struct pidmap *map;
 
 	pid = last + 1;
 	if (pid >= pid_max)
-		pid = RESERVED_PIDS;
+		pid = min;
 	offset = pid & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
-	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
+	max_scan = (max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
 	for (i = 0; i <= max_scan; ++i) {
 		rc = alloc_pidmap_page(map);
 		if (rc)
@@ -168,7 +169,6 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
 					atomic_dec(&map->nr_free);
-					pid_ns->last_pid = pid;
 					return pid;
 				}
 				offset = find_next_offset(map, offset);
@@ -179,16 +179,16 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 			 * bitmap block and the final block was the same
 			 * as the starting point, pid is before last_pid.
 			 */
-			} while (offset < BITS_PER_PAGE && pid < pid_max &&
+			} while (offset < BITS_PER_PAGE && pid < max &&
 					(i != max_scan || pid < last ||
 					    !((last+1) & BITS_PER_PAGE_MASK)));
 		}
-		if (map < &pid_ns->pidmap[(pid_max-1)/BITS_PER_PAGE]) {
+		if (map < &pid_ns->pidmap[(max-1)/BITS_PER_PAGE]) {
 			++map;
 			offset = 0;
 		} else {
 			map = &pid_ns->pidmap[0];
-			offset = RESERVED_PIDS;
+			offset = min;
 			if (unlikely(last == offset)) {
 				rc = -EAGAIN;
 				break;
@@ -199,6 +199,30 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	return rc;
 }
 
+static int alloc_pidmap(struct pid_namespace *pid_ns)
+{
+	int nr;
+
+	nr = do_alloc_pidmap(pid_ns, pid_ns->last_pid, RESERVED_PIDS, pid_max);
+	if (nr >= 0)
+		pid_ns->last_pid = nr;
+	return nr;
+}
+
+static int set_pidmap(struct pid_namespace *pid_ns, int target)
+{
+	if (!target)
+		return alloc_pidmap(pid_ns);
+
+	if (target >= pid_max)
+		return -EINVAL;
+
+	if (target < 0 || (target < RESERVED_PIDS &&
+				pid_ns->last_pid >= RESERVED_PIDS))
+		return -EINVAL;
+	return do_alloc_pidmap(pid_ns, target - 1, target, target + 1);
+}
+
 int next_pidmap(struct pid_namespace *pid_ns, int last)
 {
 	int offset;
-- 
