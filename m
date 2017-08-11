From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v4 1/4] seccomp: Rename SECCOMP_RET_KILL to SECCOMP_RET_KILL_THREAD
Date: Fri, 11 Aug 2017 15:05:13 -0700
Message-ID: <1502489117-70522-2-git-send-email-keescook@chromium.org>
References: <1502489117-70522-1-git-send-email-keescook@chromium.org>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1502489117-70522-1-git-send-email-keescook@chromium.org>
Sender: linux-doc-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Tyler Hicks <tyhicks@canonical.com>, Fabricio Voznika <fvoznika@google.com>, Paul Moore <paul@paul-moore.com>, Tycho Andersen <tycho@docker.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>, Mathias Svensson <idolf@google.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

In preparation for adding SECCOMP_RET_KILL_PROCESS, rename SECCOMP_RET_KILL
to the more accurate SECCOMP_RET_KILL_THREAD.

The existing selftest values are intentionally left as SECCOMP_RET_KILL
just to be sure we're exercising the alias.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/networking/filter.txt            |  2 +-
 Documentation/userspace-api/seccomp_filter.rst |  4 +--
 include/uapi/linux/seccomp.h                   |  3 +-
 kernel/seccomp.c                               | 39 ++++++++++++++------------
 samples/seccomp/bpf-direct.c                   |  4 +--
 samples/seccomp/bpf-helper.h                   |  2 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c  | 17 ++++++-----
 7 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/Documentation/networking/filter.txt b/Documentation/networking/filter.txt
index b69b205501de..73aa0f12156d 100644
--- a/Documentation/networking/filter.txt
+++ b/Documentation/networking/filter.txt
@@ -337,7 +337,7 @@ Examples for low-level BPF:
   jeq #14, good           /* __NR_rt_sigprocmask */
   jeq #13, good           /* __NR_rt_sigaction */
   jeq #35, good           /* __NR_nanosleep */
-  bad: ret #0             /* SECCOMP_RET_KILL */
+  bad: ret #0             /* SECCOMP_RET_KILL_THREAD */
   good: ret #0x7fff0000   /* SECCOMP_RET_ALLOW */
 
 The above example code can be placed into a file (here called "foo"), and
diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
index f4977357daf2..d76396f2d8ed 100644
--- a/Documentation/userspace-api/seccomp_filter.rst
+++ b/Documentation/userspace-api/seccomp_filter.rst
@@ -87,11 +87,11 @@ Return values
 A seccomp filter may return any of the following values. If multiple
 filters exist, the return value for the evaluation of a given system
 call will always use the highest precedent value. (For example,
-``SECCOMP_RET_KILL`` will always take precedence.)
+``SECCOMP_RET_KILL_THREAD`` will always take precedence.)
 
 In precedence order, they are:
 
-``SECCOMP_RET_KILL``:
+``SECCOMP_RET_KILL_THREAD``:
 	Results in the task exiting immediately without executing the
 	system call.  The exit status of the task (``status & 0x7f``) will
 	be ``SIGSYS``, not ``SIGKILL``.
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index f94433263e4b..5a03f699eb17 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -27,7 +27,8 @@
  * The ordering ensures that a min_t() over composed return values always
  * selects the least permissive choice.
  */
-#define SECCOMP_RET_KILL	0x00000000U /* kill the task immediately */
+#define SECCOMP_RET_KILL_THREAD	0x00000000U /* kill the thread */
+#define SECCOMP_RET_KILL	SECCOMP_RET_KILL_THREAD
 #define SECCOMP_RET_TRAP	0x00030000U /* disallow and force a SIGSYS */
 #define SECCOMP_RET_ERRNO	0x00050000U /* returns an errno */
 #define SECCOMP_RET_TRACE	0x7ff00000U /* pass to a tracer or disallow */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 59cde2ed3b92..95ac54cff00f 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -192,7 +192,7 @@ static u32 seccomp_run_filters(const struct seccomp_data *sd,
 
 	/* Ensure unexpected behavior doesn't result in failing open. */
 	if (unlikely(WARN_ON(f == NULL)))
-		return SECCOMP_RET_KILL;
+		return SECCOMP_RET_KILL_THREAD;
 
 	if (!sd) {
 		populate_seccomp_data(&sd_local);
@@ -529,15 +529,17 @@ static void seccomp_send_sigsys(int syscall, int reason)
 #endif	/* CONFIG_SECCOMP_FILTER */
 
 /* For use with seccomp_actions_logged */
-#define SECCOMP_LOG_KILL		(1 << 0)
+#define SECCOMP_LOG_KILL_THREAD		(1 << 0)
 #define SECCOMP_LOG_TRAP		(1 << 2)
 #define SECCOMP_LOG_ERRNO		(1 << 3)
 #define SECCOMP_LOG_TRACE		(1 << 4)
 #define SECCOMP_LOG_LOG			(1 << 5)
 #define SECCOMP_LOG_ALLOW		(1 << 6)
 
-static u32 seccomp_actions_logged = SECCOMP_LOG_KILL  | SECCOMP_LOG_TRAP  |
-				    SECCOMP_LOG_ERRNO | SECCOMP_LOG_TRACE |
+static u32 seccomp_actions_logged = SECCOMP_LOG_KILL_THREAD |
+				    SECCOMP_LOG_TRAP  |
+				    SECCOMP_LOG_ERRNO |
+				    SECCOMP_LOG_TRACE |
 				    SECCOMP_LOG_LOG;
 
 static inline void seccomp_log(unsigned long syscall, long signr, u32 action,
@@ -560,13 +562,13 @@ static inline void seccomp_log(unsigned long syscall, long signr, u32 action,
 	case SECCOMP_RET_LOG:
 		log = seccomp_actions_logged & SECCOMP_LOG_LOG;
 		break;
-	case SECCOMP_RET_KILL:
+	case SECCOMP_RET_KILL_THREAD:
 	default:
-		log = seccomp_actions_logged & SECCOMP_LOG_KILL;
+		log = seccomp_actions_logged & SECCOMP_LOG_KILL_THREAD;
 	}
 
 	/*
-	 * Force an audit message to be emitted when the action is RET_KILL,
+	 * Force an audit message to be emitted when the action is RET_KILL_*,
 	 * RET_LOG, or the FILTER_FLAG_LOG bit was set and the action is
 	 * allowed to be logged by the admin.
 	 */
@@ -605,7 +607,7 @@ static void __secure_computing_strict(int this_syscall)
 #ifdef SECCOMP_DEBUG
 	dump_stack();
 #endif
-	seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL, true);
+	seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL_THREAD, true);
 	do_exit(SIGKILL);
 }
 
@@ -716,7 +718,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 		 */
 		return 0;
 
-	case SECCOMP_RET_KILL:
+	case SECCOMP_RET_KILL_THREAD:
 	default:
 		seccomp_log(this_syscall, SIGSYS, action, true);
 		/* Dump core only if this is the last remaining thread. */
@@ -878,7 +880,7 @@ static long seccomp_get_action_avail(const char __user *uaction)
 		return -EFAULT;
 
 	switch (action) {
-	case SECCOMP_RET_KILL:
+	case SECCOMP_RET_KILL_THREAD:
 	case SECCOMP_RET_TRAP:
 	case SECCOMP_RET_ERRNO:
 	case SECCOMP_RET_TRACE:
@@ -1029,19 +1031,20 @@ long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
 #ifdef CONFIG_SYSCTL
 
 /* Human readable action names for friendly sysctl interaction */
-#define SECCOMP_RET_KILL_NAME		"kill"
+#define SECCOMP_RET_KILL_THREAD_NAME	"kill_thread"
 #define SECCOMP_RET_TRAP_NAME		"trap"
 #define SECCOMP_RET_ERRNO_NAME		"errno"
 #define SECCOMP_RET_TRACE_NAME		"trace"
 #define SECCOMP_RET_LOG_NAME		"log"
 #define SECCOMP_RET_ALLOW_NAME		"allow"
 
-static const char seccomp_actions_avail[] = SECCOMP_RET_KILL_NAME	" "
-					    SECCOMP_RET_TRAP_NAME	" "
-					    SECCOMP_RET_ERRNO_NAME	" "
-					    SECCOMP_RET_TRACE_NAME	" "
-					    SECCOMP_RET_LOG_NAME	" "
-					    SECCOMP_RET_ALLOW_NAME;
+static const char seccomp_actions_avail[] =
+				SECCOMP_RET_KILL_THREAD_NAME	" "
+				SECCOMP_RET_TRAP_NAME		" "
+				SECCOMP_RET_ERRNO_NAME		" "
+				SECCOMP_RET_TRACE_NAME		" "
+				SECCOMP_RET_LOG_NAME		" "
+				SECCOMP_RET_ALLOW_NAME;
 
 struct seccomp_log_name {
 	u32		log;
@@ -1049,7 +1052,7 @@ struct seccomp_log_name {
 };
 
 static const struct seccomp_log_name seccomp_log_names[] = {
-	{ SECCOMP_LOG_KILL, SECCOMP_RET_KILL_NAME },
+	{ SECCOMP_LOG_KILL_THREAD, SECCOMP_RET_KILL_THREAD_NAME },
 	{ SECCOMP_LOG_TRAP, SECCOMP_RET_TRAP_NAME },
 	{ SECCOMP_LOG_ERRNO, SECCOMP_RET_ERRNO_NAME },
 	{ SECCOMP_LOG_TRACE, SECCOMP_RET_TRACE_NAME },
diff --git a/samples/seccomp/bpf-direct.c b/samples/seccomp/bpf-direct.c
index 151ec3f52189..235ce3c49ee9 100644
--- a/samples/seccomp/bpf-direct.c
+++ b/samples/seccomp/bpf-direct.c
@@ -129,7 +129,7 @@ static int install_filter(void)
 		/* Check that read is only using stdin. */
 		BPF_STMT(BPF_LD+BPF_W+BPF_ABS, syscall_arg(0)),
 		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, STDIN_FILENO, 4, 0),
-		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_KILL),
+		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_KILL_THREAD),
 
 		/* Check that write is only using stdout */
 		BPF_STMT(BPF_LD+BPF_W+BPF_ABS, syscall_arg(0)),
@@ -139,7 +139,7 @@ static int install_filter(void)
 
 		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
 		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_TRAP),
-		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_KILL),
+		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_KILL_THREAD),
 	};
 	struct sock_fprog prog = {
 		.len = (unsigned short)(sizeof(filter)/sizeof(filter[0])),
diff --git a/samples/seccomp/bpf-helper.h b/samples/seccomp/bpf-helper.h
index 1d8de9edd858..83dbe79cbe2c 100644
--- a/samples/seccomp/bpf-helper.h
+++ b/samples/seccomp/bpf-helper.h
@@ -44,7 +44,7 @@ void seccomp_bpf_print(struct sock_filter *filter, size_t count);
 #define ALLOW \
 	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW)
 #define DENY \
-	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_KILL)
+	BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_KILL_THREAD)
 #define JUMP(labels, label) \
 	BPF_JUMP(BPF_JMP+BPF_JA, FIND_LABEL((labels), (label)), \
 		 JUMP_JT, JUMP_JF)
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index a4d8eacd6281..5680e3ae33fd 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -68,15 +68,18 @@
 #define SECCOMP_MODE_FILTER 2
 #endif
 
+#ifndef SECCOMP_RET_KILL_THREAD
+#define SECCOMP_RET_KILL_THREAD	 0x00000000U /* kill the thread */
+#endif
 #ifndef SECCOMP_RET_KILL
-#define SECCOMP_RET_KILL        0x00000000U /* kill the task immediately */
-#define SECCOMP_RET_TRAP        0x00030000U /* disallow and force a SIGSYS */
-#define SECCOMP_RET_ERRNO       0x00050000U /* returns an errno */
-#define SECCOMP_RET_TRACE       0x7ff00000U /* pass to a tracer or disallow */
-#define SECCOMP_RET_ALLOW       0x7fff0000U /* allow */
+#define SECCOMP_RET_KILL	 SECCOMP_RET_KILL_THREAD
+#define SECCOMP_RET_TRAP	 0x00030000U /* disallow and force a SIGSYS */
+#define SECCOMP_RET_ERRNO	 0x00050000U /* returns an errno */
+#define SECCOMP_RET_TRACE	 0x7ff00000U /* pass to a tracer or disallow */
+#define SECCOMP_RET_ALLOW	 0x7fff0000U /* allow */
 #endif
 #ifndef SECCOMP_RET_LOG
-#define SECCOMP_RET_LOG       0x7ffc0000U /* allow after logging */
+#define SECCOMP_RET_LOG		 0x7ffc0000U /* allow after logging */
 #endif
 
 #ifndef SECCOMP_RET_ACTION
@@ -2669,7 +2672,7 @@ TEST_SIGNAL(filter_flag_log, SIGSYS)
 
 TEST(get_action_avail)
 {
-	__u32 actions[] = { SECCOMP_RET_KILL,  SECCOMP_RET_TRAP,
+	__u32 actions[] = { SECCOMP_RET_KILL_THREAD, SECCOMP_RET_TRAP,
 			    SECCOMP_RET_ERRNO, SECCOMP_RET_TRACE,
 			    SECCOMP_RET_LOG,   SECCOMP_RET_ALLOW };
 	__u32 unknown_action = 0x10000000U;
-- 
2.7.4

