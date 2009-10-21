From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Tue, 20 Oct 2009 23:20:21 -0700
Message-ID: <20091021062021.GA2667@us.ibm.com>
References: <4AD8C7E4.9000903@free.fr> <20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com> <20091020005125.GG27627@count0.beaverton.ibm.com> <m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com> <m1iqeauyvl.fsf@fess.ebiederm.org> <20091020183329.GB22646@us.ibm.com> <m1r5sxsw7w.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <m1r5sxsw7w.fsf-+imSwln9KH6u2/kzUuoCbdi2O/JbrIOy@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Eric W. Biederman [ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org] wrote:
| > I will post a version of the patch outside this patchset with min
| > and max parameters and we can see if it can be optimized/beautified.
| 
| Thanks,
| Eric

Here is the patch.  alloc_pid() calls alloc_pidmap() as follows:

-		nr = alloc_pidmap(tmp);
+		min = max = 0;
+		if (target_pids) {
+			min = target_pids[i];
+			max = min + 1;
+		}
+		nr = alloc_pidmap(tmp, min, max);

It does look like this patch executes a bit more code even in the common
case but let me know if you think this is better.
	
---

From: Sukadev Bhattiprolu <suka@suka.(none)>
Date: Tue, 20 Oct 2009 17:01:18 -0700
Subject: [PATCH] Add min and max parameters to alloc_pidmap()

With support for setting a specific pid number for a process, alloc_pidmap()
will need a 'min' and a 'max' parameter.

---
 kernel/pid.c |   47 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index c4d9914..56e13c1 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -147,18 +147,30 @@ static int alloc_pidmap_page(struct pidmap *map)
 	return 0;
 }
 
-static int alloc_pidmap(struct pid_namespace *pid_ns)
+static int alloc_pidmap(struct pid_namespace *pid_ns, int min, int max)
 {
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
 	int rc = -EAGAIN;
 	struct pidmap *map;
 
-	pid = last + 1;
-	if (pid >= pid_max)
-		pid = RESERVED_PIDS;
+	if (min < 0 || max < 0 || max > pid_max)
+		return -EINVAL;
+
+	if (!max)
+		max = pid_max;
+
+	pid = min;
+	if (pid && pid >= max)
+		return -EINVAL;
+	else if (!pid) {
+		pid = last + 1;
+		if (pid >= pid_max)
+			pid = RESERVED_PIDS;
+	}
+
 	offset = pid & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
-	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
+	max_scan = (max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
 	for (i = 0; i <= max_scan; ++i) {
 		rc = alloc_pidmap_page(map);
 		if (rc)
@@ -168,7 +180,12 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
 					atomic_dec(&map->nr_free);
-					pid_ns->last_pid = pid;
+					/*
+					 * 'last_pid' only makes sense when
+					 * choosing from entire range
+					 */
+					if (!min)
+						pid_ns->last_pid = pid;
 					return pid;
 				}
 				offset = find_next_offset(map, offset);
@@ -179,22 +196,26 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
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
 			offset = RESERVED_PIDS;
-			if (unlikely(last == offset)) {
-				rc = -EAGAIN;
-				break;
-			}
 		}
 		pid = mk_pid(pid_ns, map, offset);
+		/*
+		 * If we are back to where we started, well, no pids are
+		 * currently available in selected range.
+		 */
+		if (pid < min || unlikely(last == offset)) {
+			rc = -EAGAIN;
+			break;
+		}
 	}
 	return rc;
 }
@@ -272,7 +293,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
-		nr = alloc_pidmap(tmp);
+		nr = alloc_pidmap(tmp, 0, 0);
 		if (nr < 0)
 			goto out_free;
 
-- 
1.6.0.4
