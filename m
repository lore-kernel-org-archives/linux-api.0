From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v4 3/4] seccomp: Implement SECCOMP_RET_KILL_PROCESS action
Date: Fri, 11 Aug 2017 15:05:15 -0700
Message-ID: <1502489117-70522-4-git-send-email-keescook@chromium.org>
References: <1502489117-70522-1-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502489117-70522-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Fabricio Voznika <fvoznika@google.com>, Tyler Hicks <tyhicks@canonical.com>, Tycho Andersen <tycho@docker.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>, Mathias Svensson <idolf@google.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Right now, SECCOMP_RET_KILL_THREAD (neé SECCOMP_RET_KILL) kills the
current thread. There have been a few requests for this to kill the entire
process (the thread group). This cannot be just changed (discovered when
adding coredump support since coredumping kills the entire process)
because there are userspace programs depending on the thread-kill
behavior.

Instead, implement SECCOMP_RET_KILL_PROCESS, which is 0x80000000, and can
be processed as "-1" by the kernel, below the existing RET_KILL that is
ABI-set to "0". For userspace, SECCOMP_RET_ACTION_FULL is added to expand
the mask to the signed bit. Old userspace using the SECCOMP_RET_ACTION
mask will see SECCOMP_RET_KILL_PROCESS as 0 still, but this would only
be visible when examining the siginfo in a core dump from a RET_KILL_*,
where it will think it was thread-killed instead of process-killed.

Attempts to introduce this behavior via other ways (filter flags,
seccomp struct flags, masked RET_DATA bits) all come with weird
side-effects and baggage. This change preserves the central behavioral
expectations of the seccomp filter engine without putting too great
a burden on changes needed in userspace to use the new action.

The new action is discoverable by userspace through either the new
actions_avail sysctl or through the SECCOMP_GET_ACTION_AVAIL seccomp
operation. If used without checking for availability, old kernels
will treat RET_KILL_PROCESS as RET_KILL_THREAD (since the old mask
will produce RET_KILL_THREAD).

Cc: Paul Moore <paul@paul-moore.com>
Cc: Fabricio Voznika <fvoznika@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/userspace-api/seccomp_filter.rst | 7 ++++++-
 include/uapi/linux/seccomp.h                   | 1 +
 kernel/seccomp.c                               | 9 +++++++--
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
index d76396f2d8ed..099c412951d6 100644
--- a/Documentation/userspace-api/seccomp_filter.rst
+++ b/Documentation/userspace-api/seccomp_filter.rst
@@ -87,10 +87,15 @@ Return values
 A seccomp filter may return any of the following values. If multiple
 filters exist, the return value for the evaluation of a given system
 call will always use the highest precedent value. (For example,
-``SECCOMP_RET_KILL_THREAD`` will always take precedence.)
+``SECCOMP_RET_KILL_PROCESS`` will always take precedence.)
 
 In precedence order, they are:
 
+``SECCOMP_RET_KILL_PROCESS``:
+	Results in the entire process exiting immediately without executing
+	the system call.  The exit status of the task (``status & 0x7f``)
+	will be ``SIGSYS``, not ``SIGKILL``.
+
 ``SECCOMP_RET_KILL_THREAD``:
 	Results in the task exiting immediately without executing the
 	system call.  The exit status of the task (``status & 0x7f``) will
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 7e77c92df78a..f6bc1dea3247 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -38,6 +38,7 @@
 #define SECCOMP_RET_ALLOW	 0x7fff0000U /* allow */
 
 /* Masks for the return value sections. */
+#define SECCOMP_RET_ACTION_FULL	0xffff0000U
 #define SECCOMP_RET_ACTION	0x7fff0000U
 #define SECCOMP_RET_DATA	0x0000ffffU
 
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 5c7299b9d953..c24579dfa7a1 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -181,6 +181,7 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
  *
  * Returns valid seccomp BPF response codes.
  */
+#define ACTION_ONLY(ret) ((s32)((ret) & (SECCOMP_RET_ACTION_FULL)))
 static u32 seccomp_run_filters(const struct seccomp_data *sd,
 			       struct seccomp_filter **match)
 {
@@ -206,7 +207,7 @@ static u32 seccomp_run_filters(const struct seccomp_data *sd,
 	for (; f; f = f->prev) {
 		u32 cur_ret = BPF_PROG_RUN(f->prog, sd);
 
-		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION)) {
+		if (ACTION_ONLY(cur_ret) < ACTION_ONLY(ret)) {
 			ret = cur_ret;
 			*match = f;
 		}
@@ -650,7 +651,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 
 	filter_ret = seccomp_run_filters(sd, &match);
 	data = filter_ret & SECCOMP_RET_DATA;
-	action = filter_ret & SECCOMP_RET_ACTION;
+	action = filter_ret & SECCOMP_RET_ACTION_FULL;
 
 	switch (action) {
 	case SECCOMP_RET_ERRNO:
@@ -890,6 +891,7 @@ static long seccomp_get_action_avail(const char __user *uaction)
 		return -EFAULT;
 
 	switch (action) {
+	case SECCOMP_RET_KILL_PROCESS:
 	case SECCOMP_RET_KILL_THREAD:
 	case SECCOMP_RET_TRAP:
 	case SECCOMP_RET_ERRNO:
@@ -1041,6 +1043,7 @@ long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
 #ifdef CONFIG_SYSCTL
 
 /* Human readable action names for friendly sysctl interaction */
+#define SECCOMP_RET_KILL_PROCESS_NAME	"kill_process"
 #define SECCOMP_RET_KILL_THREAD_NAME	"kill_thread"
 #define SECCOMP_RET_TRAP_NAME		"trap"
 #define SECCOMP_RET_ERRNO_NAME		"errno"
@@ -1049,6 +1052,7 @@ long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
 #define SECCOMP_RET_ALLOW_NAME		"allow"
 
 static const char seccomp_actions_avail[] =
+				SECCOMP_RET_KILL_PROCESS_NAME	" "
 				SECCOMP_RET_KILL_THREAD_NAME	" "
 				SECCOMP_RET_TRAP_NAME		" "
 				SECCOMP_RET_ERRNO_NAME		" "
@@ -1062,6 +1066,7 @@ struct seccomp_log_name {
 };
 
 static const struct seccomp_log_name seccomp_log_names[] = {
+	{ SECCOMP_LOG_KILL_PROCESS, SECCOMP_RET_KILL_PROCESS_NAME },
 	{ SECCOMP_LOG_KILL_THREAD, SECCOMP_RET_KILL_THREAD_NAME },
 	{ SECCOMP_LOG_TRAP, SECCOMP_RET_TRAP_NAME },
 	{ SECCOMP_LOG_ERRNO, SECCOMP_RET_ERRNO_NAME },
-- 
2.7.4
