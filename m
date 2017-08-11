From: Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH v6 3/6] seccomp: Sysctl to configure actions that are allowed to be logged
Date: Fri, 11 Aug 2017 04:33:54 +0000
Message-ID: <1502426037-3777-4-git-send-email-tyhicks@canonical.com>
References: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, John Crispin <john@phrozen.org>, Tycho Andersen <tycho@docker.com>, linux-audit@redhat.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Adminstrators can write to this sysctl to set the seccomp actions that
are allowed to be logged. Any actions not found in this sysctl will not
be logged.

For example, all SECCOMP_RET_KILL, SECCOMP_RET_TRAP, and
SECCOMP_RET_ERRNO actions would be loggable if "kill trap errno" were
written to the sysctl. SECCOMP_RET_TRACE actions would not be logged
since its string representation ("trace") wasn't present in the sysctl
value.

The path to the sysctl is:

 /proc/sys/kernel/seccomp/actions_logged

The actions_avail sysctl can be read to discover the valid action names
that can be written to the actions_logged sysctl with the exception of
"allow". SECCOMP_RET_ALLOW actions cannot be configured for logging.

The default setting for the sysctl is to allow all actions to be logged
except SECCOMP_RET_ALLOW. While only SECCOMP_RET_KILL actions are
currently logged, an upcoming patch will allow applications to request
additional actions to be logged.

There's one important exception to this sysctl. If a task is
specifically being audited, meaning that an audit context has been
allocated for the task, seccomp will log all actions other than
SECCOMP_RET_ALLOW despite the value of actions_logged. This exception
preserves the existing auditing behavior of tasks with an allocated
audit context.

With this patch, the logic for deciding if an action will be logged is:

if action == RET_ALLOW:
  do not log
else if action == RET_KILL && RET_KILL in actions_logged:
  log
else if audit_enabled && task-is-being-audited:
  log
else:
  do not log

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
---
 Documentation/userspace-api/seccomp_filter.rst |  18 +++
 include/linux/audit.h                          |   6 +-
 kernel/seccomp.c                               | 171 ++++++++++++++++++++++++-
 3 files changed, 187 insertions(+), 8 deletions(-)

diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
index 35fc7cb..2d1d8ab 100644
--- a/Documentation/userspace-api/seccomp_filter.rst
+++ b/Documentation/userspace-api/seccomp_filter.rst
@@ -187,6 +187,24 @@ directory. Here's a description of each file in that directory:
 	program was built, differs from the set of actions actually
 	supported in the current running kernel.
 
+``actions_logged``:
+	A read-write ordered list of seccomp return values (refer to the
+	``SECCOMP_RET_*`` macros above) that are allowed to be logged. Writes
+	to the file do not need to be in ordered form but reads from the file
+	will be ordered in the same way as the actions_avail sysctl.
+
+	It is important to note that the value of ``actions_logged`` does not
+	prevent certain actions from being logged when the audit subsystem is
+	configured to audit a task. If the action is not found in
+	``actions_logged`` list, the final decision on whether to audit the
+	action for that task is ultimately left up to the audit subsystem to
+	decide for all seccomp return values other than ``SECCOMP_RET_ALLOW``.
+
+	The ``allow`` string is not accepted in the ``actions_logged`` sysctl
+	as it is not possible to log ``SECCOMP_RET_ALLOW`` actions. Attempting
+	to write ``allow`` to the sysctl will result in an EINVAL being
+	returned.
+
 Adding architecture support
 ===========================
 
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 2150bdc..8c30f06 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -314,11 +314,7 @@ void audit_core_dumps(long signr);
 
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
index 1e57eff..2cb362a 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -545,6 +545,45 @@ static void seccomp_send_sigsys(int syscall, int reason)
 }
 #endif	/* CONFIG_SECCOMP_FILTER */
 
+/* For use with seccomp_actions_logged */
+#define SECCOMP_LOG_KILL		(1 << 0)
+#define SECCOMP_LOG_TRAP		(1 << 2)
+#define SECCOMP_LOG_ERRNO		(1 << 3)
+#define SECCOMP_LOG_TRACE		(1 << 4)
+#define SECCOMP_LOG_ALLOW		(1 << 5)
+
+static u32 seccomp_actions_logged = SECCOMP_LOG_KILL  | SECCOMP_LOG_TRAP  |
+				    SECCOMP_LOG_ERRNO | SECCOMP_LOG_TRACE;
+
+static inline void seccomp_log(unsigned long syscall, long signr, u32 action)
+{
+	bool log = false;
+
+	switch (action) {
+	case SECCOMP_RET_ALLOW:
+	case SECCOMP_RET_TRAP:
+	case SECCOMP_RET_ERRNO:
+	case SECCOMP_RET_TRACE:
+		break;
+	case SECCOMP_RET_KILL:
+	default:
+		log = seccomp_actions_logged & SECCOMP_LOG_KILL;
+	}
+
+	/*
+	 * Force an audit message to be emitted when the action is RET_KILL and
+	 * the action is allowed to be logged by the admin.
+	 */
+	if (log)
+		return __audit_seccomp(syscall, signr, action);
+
+	/*
+	 * Let the audit subsystem decide if the action should be audited based
+	 * on whether the current task itself is being audited.
+	 */
+	return audit_seccomp(syscall, signr, action);
+}
+
 /*
  * Secure computing mode 1 allows only read/write/exit/sigreturn.
  * To be fully secure this must be combined with rlimit
@@ -570,7 +609,7 @@ static void __secure_computing_strict(int this_syscall)
 #ifdef SECCOMP_DEBUG
 	dump_stack();
 #endif
-	audit_seccomp(this_syscall, SIGKILL, SECCOMP_RET_KILL);
+	seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL);
 	do_exit(SIGKILL);
 }
 
@@ -680,7 +719,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 
 	case SECCOMP_RET_KILL:
 	default:
-		audit_seccomp(this_syscall, SIGSYS, action);
+		seccomp_log(this_syscall, SIGSYS, action);
 
 		/*
 		 * The only way match can be NULL here is if something
@@ -719,7 +758,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	unreachable();
 
 skip:
-	audit_seccomp(this_syscall, 0, action);
+	seccomp_log(this_syscall, 0, action);
 	return -1;
 }
 #else
@@ -1024,6 +1063,127 @@ static const char seccomp_actions_avail[] = SECCOMP_RET_KILL_NAME	" "
 					    SECCOMP_RET_TRACE_NAME	" "
 					    SECCOMP_RET_ALLOW_NAME;
 
+struct seccomp_log_name {
+	u32		log;
+	const char	*name;
+};
+
+static const struct seccomp_log_name seccomp_log_names[] = {
+	{ SECCOMP_LOG_KILL, SECCOMP_RET_KILL_NAME },
+	{ SECCOMP_LOG_TRAP, SECCOMP_RET_TRAP_NAME },
+	{ SECCOMP_LOG_ERRNO, SECCOMP_RET_ERRNO_NAME },
+	{ SECCOMP_LOG_TRACE, SECCOMP_RET_TRACE_NAME },
+	{ SECCOMP_LOG_ALLOW, SECCOMP_RET_ALLOW_NAME },
+	{ }
+};
+
+static bool seccomp_names_from_actions_logged(char *names, size_t size,
+					      u32 actions_logged)
+{
+	const struct seccomp_log_name *cur;
+	bool append_space = false;
+
+	for (cur = seccomp_log_names; cur->name && size; cur++) {
+		ssize_t ret;
+
+		if (!(actions_logged & cur->log))
+			continue;
+
+		if (append_space) {
+			ret = strscpy(names, " ", size);
+			if (ret < 0)
+				return false;
+
+			names += ret;
+			size -= ret;
+		} else
+			append_space = true;
+
+		ret = strscpy(names, cur->name, size);
+		if (ret < 0)
+			return false;
+
+		names += ret;
+		size -= ret;
+	}
+
+	return true;
+}
+
+static bool seccomp_action_logged_from_name(u32 *action_logged,
+					    const char *name)
+{
+	const struct seccomp_log_name *cur;
+
+	for (cur = seccomp_log_names; cur->name; cur++) {
+		if (!strcmp(cur->name, name)) {
+			*action_logged = cur->log;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static bool seccomp_actions_logged_from_names(u32 *actions_logged, char *names)
+{
+	char *name;
+
+	*actions_logged = 0;
+	while ((name = strsep(&names, " ")) && *name) {
+		u32 action_logged = 0;
+
+		if (!seccomp_action_logged_from_name(&action_logged, name))
+			return false;
+
+		*actions_logged |= action_logged;
+	}
+
+	return true;
+}
+
+static int seccomp_actions_logged_handler(struct ctl_table *ro_table, int write,
+					  void __user *buffer, size_t *lenp,
+					  loff_t *ppos)
+{
+	char names[sizeof(seccomp_actions_avail)];
+	struct ctl_table table;
+	int ret;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	memset(names, 0, sizeof(names));
+
+	if (!write) {
+		if (!seccomp_names_from_actions_logged(names, sizeof(names),
+						       seccomp_actions_logged))
+			return -EINVAL;
+	}
+
+	table = *ro_table;
+	table.data = names;
+	table.maxlen = sizeof(names);
+	ret = proc_dostring(&table, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
+
+	if (write) {
+		u32 actions_logged;
+
+		if (!seccomp_actions_logged_from_names(&actions_logged,
+						       table.data))
+			return -EINVAL;
+
+		if (actions_logged & SECCOMP_LOG_ALLOW)
+			return -EINVAL;
+
+		seccomp_actions_logged = actions_logged;
+	}
+
+	return 0;
+}
+
 static struct ctl_path seccomp_sysctl_path[] = {
 	{ .procname = "kernel", },
 	{ .procname = "seccomp", },
@@ -1038,6 +1198,11 @@ static struct ctl_table seccomp_sysctl_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dostring,
 	},
+	{
+		.procname	= "actions_logged",
+		.mode		= 0644,
+		.proc_handler	= seccomp_actions_logged_handler,
+	},
 	{ }
 };
 
-- 
2.7.4
