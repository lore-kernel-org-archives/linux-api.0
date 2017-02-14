From: Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH v4 3/4] seccomp: Create an action to log before allowing
Date: Tue, 14 Feb 2017 03:55:58 +0000
Message-ID: <1487044559-6351-4-git-send-email-tyhicks@canonical.com>
References: <1487044559-6351-1-git-send-email-tyhicks@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <1487044559-6351-1-git-send-email-tyhicks@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>
Cc: linux-api@vger.kernel.org, linux-audit@redhat.com, linux-kernel@vger.kernel.org, John Crispin <john@phrozen.org>
List-Id: linux-api@vger.kernel.org

Add a new action, SECCOMP_RET_LOG, that logs a syscall before allowing
the syscall. At the implementation level, this action is identical to
the existing SECCOMP_RET_ALLOW action. However, it can be very useful when
initially developing a seccomp filter for an application. The developer
can set the default action to be SECCOMP_RET_LOG, maybe mark any
obviously needed syscalls with SECCOMP_RET_ALLOW, and then put the
application through its paces. A list of syscalls that triggered the
default action (SECCOMP_RET_LOG) can be easily gleaned from the logs and
that list can be used to build the syscall whitelist. Finally, the
developer can change the default action to the desired value.

This provides a more friendly experience than seeing the application get
killed, then updating the filter and rebuilding the app, seeing the
application get killed due to a different syscall, then updating the
filter and rebuilding the app, etc.

The functionality is similar to what's supported by the various LSMs.
SELinux has permissive mode, AppArmor has complain mode, SMACK has
bring-up mode, etc.

SECCOMP_RET_LOG is given a lower value than SECCOMP_RET_ALLOW so that
"allow" can be written to the max_action_to_log sysctl in order to get a
list of logged actions without the, potentially larger, set of allowed
actions.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
---
 Documentation/prctl/seccomp_filter.txt | 6 ++++++
 include/uapi/linux/seccomp.h           | 1 +
 kernel/seccomp.c                       | 7 +++++++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
index 487cb0c..b776bc7 100644
--- a/Documentation/prctl/seccomp_filter.txt
+++ b/Documentation/prctl/seccomp_filter.txt
@@ -138,6 +138,12 @@ SECCOMP_RET_TRACE:
 	allow use of ptrace, even of other sandboxed processes, without
 	extreme care; ptracers can use this mechanism to escape.)
 
+SECCOMP_RET_LOG:
+	Results in the system call being executed after it is logged. This
+	should be used by application developers to learn which syscalls their
+	application needs without having to iterate through multiple test and
+	development cycles to build the list.
+
 SECCOMP_RET_ALLOW:
 	Results in the system call being executed.
 
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 0f238a4..bb7d57d 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -29,6 +29,7 @@
 #define SECCOMP_RET_TRAP	0x00030000U /* disallow and force a SIGSYS */
 #define SECCOMP_RET_ERRNO	0x00050000U /* returns an errno */
 #define SECCOMP_RET_TRACE	0x7ff00000U /* pass to a tracer or disallow */
+#define SECCOMP_RET_LOG		0x7ffc0000U /* allow after logging */
 #define SECCOMP_RET_ALLOW	0x7fff0000U /* allow */
 
 /* Masks for the return value sections. */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 270a227..1f52c56 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -648,6 +648,10 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 
 		return 0;
 
+	case SECCOMP_RET_LOG:
+		seccomp_log(this_syscall, 0, action);
+		return 0;
+
 	case SECCOMP_RET_ALLOW:
 		/* Open-coded seccomp_log(), optimized for the RET_ALLOW hot
 		 * path.
@@ -943,6 +947,7 @@ long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
 #define SECCOMP_RET_TRAP_NAME		"trap"
 #define SECCOMP_RET_ERRNO_NAME		"errno"
 #define SECCOMP_RET_TRACE_NAME		"trace"
+#define SECCOMP_RET_LOG_NAME		"log"
 #define SECCOMP_RET_ALLOW_NAME		"allow"
 
 /* Largest strlen() of all action names */
@@ -952,6 +957,7 @@ static char seccomp_actions_avail[] = SECCOMP_RET_KILL_NAME	" "
 				      SECCOMP_RET_TRAP_NAME	" "
 				      SECCOMP_RET_ERRNO_NAME	" "
 				      SECCOMP_RET_TRACE_NAME	" "
+				      SECCOMP_RET_LOG_NAME	" "
 				      SECCOMP_RET_ALLOW_NAME;
 
 struct seccomp_action_name {
@@ -964,6 +970,7 @@ static struct seccomp_action_name seccomp_action_names[] = {
 	{ SECCOMP_RET_TRAP, SECCOMP_RET_TRAP_NAME },
 	{ SECCOMP_RET_ERRNO, SECCOMP_RET_ERRNO_NAME },
 	{ SECCOMP_RET_TRACE, SECCOMP_RET_TRACE_NAME },
+	{ SECCOMP_RET_LOG, SECCOMP_RET_LOG_NAME },
 	{ SECCOMP_RET_ALLOW, SECCOMP_RET_ALLOW_NAME },
 	{ }
 };
-- 
2.7.4
