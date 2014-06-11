From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 5/9] seccomp: split mode set routines
Date: Tue, 10 Jun 2014 20:25:17 -0700
Message-ID: <1402457121-8410-6-git-send-email-keescook@chromium.org>
References: <1402457121-8410-1-git-send-email-keescook@chromium.org>
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <1402457121-8410-1-git-send-email-keescook@chromium.org>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Alexei Starovoitov <ast@plumgrid.com>, John Johansen <john.johansen@canonical.com>, Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Extracts the common check/assign logic, and separates the two mode
setting paths to make things more readable with fewer #ifdefs within
function bodies.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/seccomp.c |  124 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 85 insertions(+), 39 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 7ec99b99e400..39d32c2904fc 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -195,7 +195,29 @@ static u32 seccomp_run_filters(int syscall)
 	}
 	return ret;
 }
+#endif /* CONFIG_SECCOMP_FILTER */
 
+static inline bool seccomp_check_mode(struct task_struct *task,
+				      unsigned long seccomp_mode)
+{
+	BUG_ON(!spin_is_locked(&task->sighand->siglock));
+
+	if (task->seccomp.mode && task->seccomp.mode != seccomp_mode)
+		return false;
+
+	return true;
+}
+
+static inline void seccomp_assign_mode(struct task_struct *task,
+				       unsigned long seccomp_mode)
+{
+	BUG_ON(!spin_is_locked(&task->sighand->siglock));
+
+	task->seccomp.mode = seccomp_mode;
+	set_tsk_thread_flag(task, TIF_SECCOMP);
+}
+
+#ifdef CONFIG_SECCOMP_FILTER
 /**
  * seccomp_prepare_filter: Prepares a seccomp filter for use.
  * @fprog: BPF program to install
@@ -486,69 +508,86 @@ long prctl_get_seccomp(void)
 }
 
 /**
- * seccomp_set_mode: internal function for setting seccomp mode
- * @seccomp_mode: requested mode to use
- * @filter: optional struct sock_fprog for use with SECCOMP_MODE_FILTER
+ * seccomp_set_mode_strict: internal function for setting strict seccomp
  *
- * This function may be called repeatedly with a @seccomp_mode of
- * SECCOMP_MODE_FILTER to install additional filters.  Every filter
- * successfully installed will be evaluated (in reverse order) for each system
- * call the task makes.
+ * Once current->seccomp.mode is non-zero, it may not be changed.
+ *
+ * Returns 0 on success or -EINVAL on failure.
+ */
+static long seccomp_set_mode_strict(void)
+{
+	const unsigned long seccomp_mode = SECCOMP_MODE_STRICT;
+	unsigned long irqflags;
+	int ret = -EINVAL;
+
+	if (unlikely(!lock_task_sighand(current, &irqflags)))
+		return -EINVAL;
+
+	if (!seccomp_check_mode(current, seccomp_mode))
+		goto out;
+
+#ifdef TIF_NOTSC
+	disable_TSC();
+#endif
+	seccomp_assign_mode(current, seccomp_mode);
+	ret = 0;
+
+out:
+	unlock_task_sighand(current, &irqflags);
+
+	return ret;
+}
+
+#ifdef CONFIG_SECCOMP_FILTER
+/**
+ * seccomp_set_mode_filter: internal function for setting seccomp filter
+ * @filter: struct sock_fprog containing filter
+ *
+ * This function may be called repeatedly to install additional filters.
+ * Every filter successfully installed will be evaluated (in reverse order)
+ * for each system call the task makes.
  *
  * Once current->seccomp.mode is non-zero, it may not be changed.
  *
  * Returns 0 on success or -EINVAL on failure.
  */
-static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
+static long seccomp_set_mode_filter(char __user *filter)
 {
+	const unsigned long seccomp_mode = SECCOMP_MODE_FILTER;
 	struct seccomp_filter *prepared = NULL;
 	unsigned long irqflags;
 	long ret = -EINVAL;
 
-#ifdef CONFIG_SECCOMP_FILTER
-	/* Prepare the new filter outside of the seccomp lock. */
-	if (seccomp_mode == SECCOMP_MODE_FILTER) {
-		prepared = seccomp_prepare_user_filter(filter);
-		if (IS_ERR(prepared))
-			return PTR_ERR(prepared);
-	}
-#endif
+	/* Prepare the new filter outside of any locking. */
+	prepared = seccomp_prepare_user_filter(filter);
+	if (IS_ERR(prepared))
+		return PTR_ERR(prepared);
 
 	if (unlikely(!lock_task_sighand(current, &irqflags)))
 		goto out_free;
 
-	if (current->seccomp.mode &&
-	    current->seccomp.mode != seccomp_mode)
+	if (!seccomp_check_mode(current, seccomp_mode))
 		goto out;
 
-	switch (seccomp_mode) {
-	case SECCOMP_MODE_STRICT:
-		ret = 0;
-#ifdef TIF_NOTSC
-		disable_TSC();
-#endif
-		break;
-#ifdef CONFIG_SECCOMP_FILTER
-	case SECCOMP_MODE_FILTER:
-		ret = seccomp_attach_filter(prepared);
-		if (ret)
-			goto out;
-		/* Do not free the successfully attached filter. */
-		prepared = NULL;
-		break;
-#endif
-	default:
+	ret = seccomp_attach_filter(prepared);
+	if (ret)
 		goto out;
-	}
+	/* Do not free the successfully attached filter. */
+	prepared = NULL;
 
-	current->seccomp.mode = seccomp_mode;
-	set_thread_flag(TIF_SECCOMP);
+	seccomp_assign_mode(current, seccomp_mode);
 out:
 	unlock_task_sighand(current, &irqflags);
 out_free:
 	kfree(prepared);
 	return ret;
 }
+#else
+static inline long seccomp_set_mode_filter(char __user *filter)
+{
+	return -EINVAL;
+}
+#endif
 
 /**
  * prctl_set_seccomp: configures current->seccomp.mode
@@ -559,5 +598,12 @@ out_free:
  */
 long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
 {
-	return seccomp_set_mode(seccomp_mode, filter);
+	switch (seccomp_mode) {
+	case SECCOMP_MODE_STRICT:
+		return seccomp_set_mode_strict();
+	case SECCOMP_MODE_FILTER:
+		return seccomp_set_mode_filter(filter);
+	default:
+		return -EINVAL;
+	}
 }
-- 
1.7.9.5
