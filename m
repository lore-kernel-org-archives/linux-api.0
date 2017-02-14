From: Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH v4 2/4] seccomp: Add sysctl to configure actions that should be logged
Date: Tue, 14 Feb 2017 03:55:57 +0000
Message-ID: <1487044559-6351-3-git-send-email-tyhicks@canonical.com>
References: <1487044559-6351-1-git-send-email-tyhicks@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487044559-6351-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, John Crispin <john@phrozen.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Administrators can write to this sysctl to set the maximum seccomp
action that should be logged. Any actions with values greater than
what's written to the sysctl will not be logged.

For example, all SECCOMP_RET_KILL, SECCOMP_RET_TRAP, and
SECCOMP_RET_ERRNO actions would be logged if "errno" were written to the
sysctl. SECCOMP_RET_TRACE and SECCOMP_RET_ALLOW actions would not be
logged since their values are higher than SECCOMP_RET_ERRNO.

The path to the sysctl is:

 /proc/sys/kernel/seccomp/log_max_action

The actions_avail sysctl can be read to discover the valid action names
that can be written to the log_max_action sysctl. The actions_avail
sysctl is also useful in understanding the ordering of actions used when
deciding the maximum action to log.

The default setting for the sysctl is to only log SECCOMP_RET_KILL
actions which matches the existing behavior.

There's one important exception to this sysctl. If a task is
specifically being audited, meaning that an audit context has been
allocated for the task, seccomp will log all actions other than
SECCOMP_RET_ALLOW despite the value of log_max_action. This exception
preserves the existing auditing behavior of tasks with an allocated
audit context.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
---
 Documentation/prctl/seccomp_filter.txt |  21 ++++++
 include/linux/audit.h                  |   6 +-
 kernel/seccomp.c                       | 123 ++++++++++++++++++++++++++++++++-
 3 files changed, 142 insertions(+), 8 deletions(-)

diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
index a5554ff..487cb0c 100644
--- a/Documentation/prctl/seccomp_filter.txt
+++ b/Documentation/prctl/seccomp_filter.txt
@@ -184,6 +184,27 @@ actions_avail:
 	program was built, differs from the set of actions actually
 	supported in the current running kernel.
 
+log_max_action:
+	A read-write file containing the most permissive seccomp return
+	value that should be logged. The list of valid strings that can
+	be written to this file can be found in the actions_avail sysctl.
+
+	The actions_avail sysctl can also serve as a way to discover the
+	ordering of seccomp return values so that you can easily
+	understand which return values will be logged. For example,
+	assume that the actions_avail file contains
+	"kill trap errno trace allow" and "errno" is written to the
+	log_max_action file. The SECCOMP_RET_KILL, SECCOMP_RET_TRAP, and
+	SECCOMP_RET_ERRNO actions will be logged.
+
+	It is important to note that the value of log_max_action does
+	not prevent certain actions from being logged when the audit
+	subsystem is configured to audit a task. If the action is more
+	permissive than what's written to log_max_action, the final
+	decision on whether to audit the action for that task is
+	ultimately left up to the audit subsystem to decide for all
+	seccomp return values other than SECCOMP_RET_ALLOW.
+
 Adding architecture support
 -----------------------
 
diff --git a/include/linux/audit.h b/include/linux/audit.h
index f51fca8d..e0d95fc 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -315,11 +315,7 @@ void audit_core_dumps(long signr);
 
 static inline void audit_seccomp(unsigned long syscall, long signr, int code)
 {
-	if (!audit_enabled)
-		return;
-
-	/* Force a record to be reported if a signal was delivered. */
-	if (signr || unlikely(!audit_dummy_context()))
+	if (audit_enabled && unlikely(!audit_dummy_context()))
 		__audit_seccomp(syscall, signr, code);
 }
 
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index e36dfe9..270a227 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -509,6 +509,22 @@ static void seccomp_send_sigsys(int syscall, int reason)
 }
 #endif	/* CONFIG_SECCOMP_FILTER */
 
+static u32 seccomp_log_max_action = SECCOMP_RET_KILL;
+
+static inline void seccomp_log(unsigned long syscall, long signr, u32 action)
+{
+	/* Force an audit message to be emitted when the action is not greater
+	 * than the configured maximum action.
+	 */
+	if (action <= seccomp_log_max_action)
+		return __audit_seccomp(syscall, signr, action);
+
+	/* Let the audit subsystem decide if the action should be audited based
+	 * on whether the current task itself is being audited.
+	 */
+	return audit_seccomp(syscall, signr, action);
+}
+
 /*
  * Secure computing mode 1 allows only read/write/exit/sigreturn.
  * To be fully secure this must be combined with rlimit
@@ -534,7 +550,7 @@ static void __secure_computing_strict(int this_syscall)
 #ifdef SECCOMP_DEBUG
 	dump_stack();
 #endif
-	audit_seccomp(this_syscall, SIGKILL, SECCOMP_RET_KILL);
+	seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL);
 	do_exit(SIGKILL);
 }
 
@@ -633,18 +649,30 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 		return 0;
 
 	case SECCOMP_RET_ALLOW:
+		/* Open-coded seccomp_log(), optimized for the RET_ALLOW hot
+		 * path.
+		 *
+		 * We only want to log RET_ALLOW actions when the admin has
+		 * configured them to be logged via the log_max_action sysctl.
+		 * Therefore, call __audit_seccomp() directly so that RET_ALLOW
+		 * actions are not audited simply because the task is being
+		 * audited.
+		 */
+		if (unlikely(seccomp_log_max_action == SECCOMP_RET_ALLOW))
+			__audit_seccomp(this_syscall, 0, action);
+
 		return 0;
 
 	case SECCOMP_RET_KILL:
 	default:
-		audit_seccomp(this_syscall, SIGSYS, action);
+		seccomp_log(this_syscall, SIGSYS, action);
 		do_exit(SIGSYS);
 	}
 
 	unreachable();
 
 skip:
-	audit_seccomp(this_syscall, 0, action);
+	seccomp_log(this_syscall, 0, action);
 	return -1;
 }
 #else
@@ -917,12 +945,96 @@ long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
 #define SECCOMP_RET_TRACE_NAME		"trace"
 #define SECCOMP_RET_ALLOW_NAME		"allow"
 
+/* Largest strlen() of all action names */
+#define SECCOMP_RET_MAX_NAME_LEN	5
+
 static char seccomp_actions_avail[] = SECCOMP_RET_KILL_NAME	" "
 				      SECCOMP_RET_TRAP_NAME	" "
 				      SECCOMP_RET_ERRNO_NAME	" "
 				      SECCOMP_RET_TRACE_NAME	" "
 				      SECCOMP_RET_ALLOW_NAME;
 
+struct seccomp_action_name {
+	u32		action;
+	const char	*name;
+};
+
+static struct seccomp_action_name seccomp_action_names[] = {
+	{ SECCOMP_RET_KILL, SECCOMP_RET_KILL_NAME },
+	{ SECCOMP_RET_TRAP, SECCOMP_RET_TRAP_NAME },
+	{ SECCOMP_RET_ERRNO, SECCOMP_RET_ERRNO_NAME },
+	{ SECCOMP_RET_TRACE, SECCOMP_RET_TRACE_NAME },
+	{ SECCOMP_RET_ALLOW, SECCOMP_RET_ALLOW_NAME },
+	{ }
+};
+
+static bool seccomp_name_from_action(const char **namep, u32 action)
+{
+	struct seccomp_action_name *cur;
+
+	for (cur = seccomp_action_names; cur->name; cur++) {
+		if (cur->action == action) {
+			*namep = cur->name;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static bool seccomp_action_from_name(u32 *action, const char *name)
+{
+	struct seccomp_action_name *cur;
+
+	for (cur = seccomp_action_names; cur->name; cur++) {
+		if (!strcmp(cur->name, name)) {
+			*action = cur->action;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static int seccomp_log_max_action_handler(struct ctl_table *ro_table, int write,
+					  void __user *buffer, size_t *lenp,
+					  loff_t *ppos)
+{
+	char name[SECCOMP_RET_MAX_NAME_LEN + 1] = { };
+	struct ctl_table table;
+	int ret;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!write) {
+		const char *namep;
+
+		if (!seccomp_name_from_action(&namep, seccomp_log_max_action))
+			return -EINVAL;
+
+		strncpy(name, namep, sizeof(name) - 1);
+	}
+
+	table = *ro_table;
+	table.data = name;
+	table.maxlen = sizeof(name);
+	ret = proc_dostring(&table, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
+
+	if (write) {
+		u32 action;
+
+		if (!seccomp_action_from_name(&action, table.data))
+			return -EINVAL;
+
+		seccomp_log_max_action = action;
+	}
+
+	return 0;
+}
+
 static struct ctl_path seccomp_sysctl_path[] = {
 	{ .procname = "kernel", },
 	{ .procname = "seccomp", },
@@ -937,6 +1049,11 @@ static struct ctl_table seccomp_sysctl_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dostring,
 	},
+	{
+		.procname	= "log_max_action",
+		.mode		= 0644,
+		.proc_handler	= seccomp_log_max_action_handler,
+	},
 	{ }
 };
 
-- 
2.7.4
