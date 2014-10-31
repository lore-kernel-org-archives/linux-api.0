From: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/5] kdbus: check if lsm permits installing received fds
Date: Fri, 31 Oct 2014 18:19:09 +0100
Message-ID: <1414775949-26750-1-git-send-email-k.lewandowsk@samsung.com>
References: <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1414773397-26490-1-git-send-email-k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, inux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, casey.schaufler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lmctlx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, r.krypa-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Karol Lewandowski <lmctlx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Karol Lewandowski <lmctlx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/misc/kdbus/queue.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/misc/kdbus/queue.c b/drivers/misc/kdbus/queue.c
index 6693852..dae18bd 100644
--- a/drivers/misc/kdbus/queue.c
+++ b/drivers/misc/kdbus/queue.c
@@ -25,6 +25,7 @@
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/sizes.h>
+#include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 
@@ -41,6 +42,18 @@ static int kdbus_queue_entry_fds_install(struct kdbus_queue_entry *entry)
 	int ret, *fds;
 	size_t count;
 
+        for (i = 0; i < entry->fds_count; i++) {
+                ret = security_file_receive(entry->fds_fp[i]);
+                if (ret)
+                        return ret;
+        }
+
+        for (i = 0; i < entry->memfds_count; i++) {
+                ret = security_file_receive(entry->memfds_fp[i]);
+                if (ret)
+                        return ret;
+        }
+
 	/* get array of file descriptors */
 	count = entry->fds_count + entry->memfds_count;
 	if (!count)
-- 
2.1.1
