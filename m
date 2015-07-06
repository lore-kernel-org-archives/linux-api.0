From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 01/24] kernel: define taststats commands in the one place
Date: Mon,  6 Jul 2015 11:47:02 +0300
Message-ID: <1436172445-6979-2-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Currently if we add a new TASKSTATS_ constant, we will chanage all
CGROUPSTATS_ contants and break backward compatibility.

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 include/uapi/linux/cgroupstats.h | 15 ---------------
 include/uapi/linux/taskstats.h   |  7 +++++++
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/uapi/linux/cgroupstats.h b/include/uapi/linux/cgroupstats.h
index 3753c33..8095931 100644
--- a/include/uapi/linux/cgroupstats.h
+++ b/include/uapi/linux/cgroupstats.h
@@ -37,21 +37,6 @@ struct cgroupstats {
 	__u64	nr_io_wait;		/* Number of tasks waiting on IO */
 };
 
-/*
- * Commands sent from userspace
- * Not versioned. New commands should only be inserted at the enum's end
- * prior to __CGROUPSTATS_CMD_MAX
- */
-
-enum {
-	CGROUPSTATS_CMD_UNSPEC = __TASKSTATS_CMD_MAX,	/* Reserved */
-	CGROUPSTATS_CMD_GET,		/* user->kernel request/get-response */
-	CGROUPSTATS_CMD_NEW,		/* kernel->user event */
-	__CGROUPSTATS_CMD_MAX,
-};
-
-#define CGROUPSTATS_CMD_MAX (__CGROUPSTATS_CMD_MAX - 1)
-
 enum {
 	CGROUPSTATS_TYPE_UNSPEC = 0,	/* Reserved */
 	CGROUPSTATS_TYPE_CGROUP_STATS,	/* contains name + stats */
diff --git a/include/uapi/linux/taskstats.h b/include/uapi/linux/taskstats.h
index 2466e55..a1cc91b 100644
--- a/include/uapi/linux/taskstats.h
+++ b/include/uapi/linux/taskstats.h
@@ -176,9 +176,16 @@ enum {
 	TASKSTATS_CMD_UNSPEC = 0,	/* Reserved */
 	TASKSTATS_CMD_GET,		/* user->kernel request/get-response */
 	TASKSTATS_CMD_NEW,		/* kernel->user event */
+	__TASKSTATS_CMD_RESERVED,
+
+	CGROUPSTATS_CMD_GET,		/* user->kernel request/get-response */
+	CGROUPSTATS_CMD_NEW,		/* kernel->user event */
+
 	__TASKSTATS_CMD_MAX,
 };
 
+#define __CGROUPSTATS_CMD_MAX __TASKSTATS_CMD_MAX
+#define CGROUPSTATS_CMD_MAX (__CGROUPSTATS_CMD_MAX - 1)
 #define TASKSTATS_CMD_MAX (__TASKSTATS_CMD_MAX - 1)
 
 enum {
-- 
2.1.0
