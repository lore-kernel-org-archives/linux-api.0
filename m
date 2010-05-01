From: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Subject: [PATCH v21 003/100] eclone (3/11): Define set_pidmap() function
Date: Sat,  1 May 2010 10:14:45 -0400
Message-ID: <1272723382-19470-4-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1272723382-19470-1-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, Sukadev Bhattiprolu <sukadev-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Define a set_pidmap() interface which is like alloc_pidmap() only that
caller specifies the pid number to be assigned.

Changelog[v13]:
	- Don't let do_alloc_pidmap return 0 if it failed to find a pid.
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

Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org
Signed-off-by: Sukadev Bhattiprolu <sukadev-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Serge E. Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
---
 kernel/pid.c |   41 +++++++++++++++++++++++++++++++++--------
 1 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 8330488..4eaf975 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -146,17 +146,18 @@ static int alloc_pidmap_page(struct pidmap *map)
 	return 0;
 }
 
-static int alloc_pidmap(struct pid_namespace *pid_ns)
+static int do_alloc_pidmap(struct pid_namespace *pid_ns, int last, int min,
+		int max)
 {
-	int i, offset, max_scan, pid, last = pid_ns->last_pid;
+	int i, offset, max_scan, pid;
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
 		if (unlikely(!map->page))
 			if (alloc_pidmap_page(map) < 0)
@@ -165,7 +166,6 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
 					atomic_dec(&map->nr_free);
-					pid_ns->last_pid = pid;
 					return pid;
 				}
 				offset = find_next_offset(map, offset);
@@ -176,16 +176,16 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
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
 			if (unlikely(last == offset))
 				break;
 		}
@@ -194,6 +194,31 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	return -EBUSY;
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
+	if ((target < 0) || (target < RESERVED_PIDS &&
+				pid_ns->last_pid >= RESERVED_PIDS))
+		return -EINVAL;
+
+	return do_alloc_pidmap(pid_ns, target - 1, target, target + 1);
+}
+
 int next_pidmap(struct pid_namespace *pid_ns, int last)
 {
 	int offset;
-- 
1.6.3.3
