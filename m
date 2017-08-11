From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH v4 2/4] seccomp: Introduce SECCOMP_RET_KILL_PROCESS
Date: Fri, 11 Aug 2017 15:05:14 -0700
Message-ID: <1502489117-70522-3-git-send-email-keescook@chromium.org>
References: <1502489117-70522-1-git-send-email-keescook@chromium.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502489117-70522-1-git-send-email-keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Fabricio Voznika <fvoznika-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Tycho Andersen <tycho-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mathias Svensson <idolf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This introduces the BPF return value for SECCOMP_RET_KILL_PROCESS to kill
an entire process. This cannot yet be reached by seccomp, but it changes
the default-kill behavior (for unknown return values) from kill-thread to
kill-process.

Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 include/uapi/linux/seccomp.h | 18 ++++++++++--------
 kernel/seccomp.c             | 22 ++++++++++++++++------
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 5a03f699eb17..7e77c92df78a 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -22,18 +22,20 @@
 /*
  * All BPF programs must return a 32-bit value.
  * The bottom 16-bits are for optional return data.
- * The upper 16-bits are ordered from least permissive values to most.
+ * The upper 16-bits are ordered from least permissive values to most,
+ * as a signed value (so 0x8000000 is negative).
  *
  * The ordering ensures that a min_t() over composed return values always
  * selects the least permissive choice.
  */
-#define SECCOMP_RET_KILL_THREAD	0x00000000U /* kill the thread */
-#define SECCOMP_RET_KILL	SECCOMP_RET_KILL_THREAD
-#define SECCOMP_RET_TRAP	0x00030000U /* disallow and force a SIGSYS */
-#define SECCOMP_RET_ERRNO	0x00050000U /* returns an errno */
-#define SECCOMP_RET_TRACE	0x7ff00000U /* pass to a tracer or disallow */
-#define SECCOMP_RET_LOG		0x7ffc0000U /* allow after logging */
-#define SECCOMP_RET_ALLOW	0x7fff0000U /* allow */
+#define SECCOMP_RET_KILL_PROCESS 0x80000000U /* kill the process */
+#define SECCOMP_RET_KILL_THREAD	 0x00000000U /* kill the thread */
+#define SECCOMP_RET_KILL	 SECCOMP_RET_KILL_THREAD
+#define SECCOMP_RET_TRAP	 0x00030000U /* disallow and force a SIGSYS */
+#define SECCOMP_RET_ERRNO	 0x00050000U /* returns an errno */
+#define SECCOMP_RET_TRACE	 0x7ff00000U /* pass to a tracer or disallow */
+#define SECCOMP_RET_LOG		 0x7ffc0000U /* allow after logging */
+#define SECCOMP_RET_ALLOW	 0x7fff0000U /* allow */
 
 /* Masks for the return value sections. */
 #define SECCOMP_RET_ACTION	0x7fff0000U
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 95ac54cff00f..5c7299b9d953 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -192,7 +192,7 @@ static u32 seccomp_run_filters(const struct seccomp_data *sd,
 
 	/* Ensure unexpected behavior doesn't result in failing open. */
 	if (unlikely(WARN_ON(f == NULL)))
-		return SECCOMP_RET_KILL_THREAD;
+		return SECCOMP_RET_KILL_PROCESS;
 
 	if (!sd) {
 		populate_seccomp_data(&sd_local);
@@ -529,14 +529,16 @@ static void seccomp_send_sigsys(int syscall, int reason)
 #endif	/* CONFIG_SECCOMP_FILTER */
 
 /* For use with seccomp_actions_logged */
-#define SECCOMP_LOG_KILL_THREAD		(1 << 0)
+#define SECCOMP_LOG_KILL_PROCESS	(1 << 0)
+#define SECCOMP_LOG_KILL_THREAD		(1 << 1)
 #define SECCOMP_LOG_TRAP		(1 << 2)
 #define SECCOMP_LOG_ERRNO		(1 << 3)
 #define SECCOMP_LOG_TRACE		(1 << 4)
 #define SECCOMP_LOG_LOG			(1 << 5)
 #define SECCOMP_LOG_ALLOW		(1 << 6)
 
-static u32 seccomp_actions_logged = SECCOMP_LOG_KILL_THREAD |
+static u32 seccomp_actions_logged = SECCOMP_LOG_KILL_PROCESS |
+				    SECCOMP_LOG_KILL_THREAD  |
 				    SECCOMP_LOG_TRAP  |
 				    SECCOMP_LOG_ERRNO |
 				    SECCOMP_LOG_TRACE |
@@ -563,8 +565,11 @@ static inline void seccomp_log(unsigned long syscall, long signr, u32 action,
 		log = seccomp_actions_logged & SECCOMP_LOG_LOG;
 		break;
 	case SECCOMP_RET_KILL_THREAD:
-	default:
 		log = seccomp_actions_logged & SECCOMP_LOG_KILL_THREAD;
+		break;
+	case SECCOMP_RET_KILL_PROCESS:
+	default:
+		log = seccomp_actions_logged & SECCOMP_LOG_KILL_PROCESS;
 	}
 
 	/*
@@ -719,10 +724,12 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 		return 0;
 
 	case SECCOMP_RET_KILL_THREAD:
+	case SECCOMP_RET_KILL_PROCESS:
 	default:
 		seccomp_log(this_syscall, SIGSYS, action, true);
 		/* Dump core only if this is the last remaining thread. */
-		if (get_nr_threads(current) == 1) {
+		if (action == SECCOMP_RET_KILL_PROCESS ||
+		    get_nr_threads(current) == 1) {
 			siginfo_t info;
 
 			/* Show the original registers in the dump. */
@@ -731,7 +738,10 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 			seccomp_init_siginfo(&info, this_syscall, data);
 			do_coredump(&info);
 		}
-		do_exit(SIGSYS);
+		if (action == SECCOMP_RET_KILL_PROCESS)
+			do_group_exit(SIGSYS);
+		else
+			do_exit(SIGSYS);
 	}
 
 	unreachable();
-- 
2.7.4
