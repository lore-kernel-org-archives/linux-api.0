From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH v12 03/11] seccomp: split mode setting routines
Date: Thu, 17 Jul 2014 11:08:30 -0700
Message-ID: <1405620518-18495-4-git-send-email-keescook@chromium.org>
References: <1405620518-18495-1-git-send-email-keescook@chromium.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405620518-18495-1-git-send-email-keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Separates the two mode setting paths to make things more readable with
fewer #ifdefs within function bodies.

Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Reviewed-by: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
---
 kernel/seccomp.c |   71 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 48 insertions(+), 23 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 9df7def86c3b..05cac2c2eca1 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -489,48 +489,66 @@ long prctl_get_seccomp(void)
 }
 
 /**
- * seccomp_set_mode: internal function for setting seccomp mode
- * @seccomp_mode: requested mode to use
- * @filter: optional struct sock_fprog for use with SECCOMP_MODE_FILTER
- *
- * This function may be called repeatedly with a @seccomp_mode of
- * SECCOMP_MODE_FILTER to install additional filters.  Every filter
- * successfully installed will be evaluated (in reverse order) for each system
- * call the task makes.
+ * seccomp_set_mode_strict: internal function for setting strict seccomp
  *
  * Once current->seccomp.mode is non-zero, it may not be changed.
  *
  * Returns 0 on success or -EINVAL on failure.
  */
-static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
+static long seccomp_set_mode_strict(void)
 {
+	const unsigned long seccomp_mode = SECCOMP_MODE_STRICT;
 	long ret = -EINVAL;
 
 	if (!seccomp_may_assign_mode(seccomp_mode))
 		goto out;
 
-	switch (seccomp_mode) {
-	case SECCOMP_MODE_STRICT:
-		ret = 0;
 #ifdef TIF_NOTSC
-		disable_TSC();
+	disable_TSC();
 #endif
-		break;
+	seccomp_assign_mode(seccomp_mode);
+	ret = 0;
+
+out:
+
+	return ret;
+}
+
 #ifdef CONFIG_SECCOMP_FILTER
-	case SECCOMP_MODE_FILTER:
-		ret = seccomp_attach_user_filter(filter);
-		if (ret)
-			goto out;
-		break;
-#endif
-	default:
+/**
+ * seccomp_set_mode_filter: internal function for setting seccomp filter
+ * @filter: struct sock_fprog containing filter
+ *
+ * This function may be called repeatedly to install additional filters.
+ * Every filter successfully installed will be evaluated (in reverse order)
+ * for each system call the task makes.
+ *
+ * Once current->seccomp.mode is non-zero, it may not be changed.
+ *
+ * Returns 0 on success or -EINVAL on failure.
+ */
+static long seccomp_set_mode_filter(char __user *filter)
+{
+	const unsigned long seccomp_mode = SECCOMP_MODE_FILTER;
+	long ret = -EINVAL;
+
+	if (!seccomp_may_assign_mode(seccomp_mode))
+		goto out;
+
+	ret = seccomp_attach_user_filter(filter);
+	if (ret)
 		goto out;
-	}
 
 	seccomp_assign_mode(seccomp_mode);
 out:
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
@@ -541,5 +559,12 @@ out:
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
