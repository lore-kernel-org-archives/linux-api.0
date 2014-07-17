From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v12 08/11] seccomp: split filter prep from check and apply
Date: Thu, 17 Jul 2014 11:08:35 -0700
Message-ID: <1405620518-18495-9-git-send-email-keescook@chromium.org>
References: <1405620518-18495-1-git-send-email-keescook@chromium.org>
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <1405620518-18495-1-git-send-email-keescook@chromium.org>
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
Cc: Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, David Drysdale <drysdale@google.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

In preparation for adding seccomp locking, move filter creation away
from where it is checked and applied. This will allow for locking where
no memory allocation is happening. The validation, filter attachment,
and seccomp mode setting can all happen under the future locks.

For extreme defensiveness, I've added a BUG_ON check for the calculated
size of the buffer allocation in case BPF_MAXINSN ever changes, which
shouldn't ever happen. The compiler should actually optimize out this
check since the test above it makes it impossible.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/seccomp.c |   97 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 67 insertions(+), 30 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index d2596136b0d1..58125160417c 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -18,6 +18,7 @@
 #include <linux/compat.h>
 #include <linux/sched.h>
 #include <linux/seccomp.h>
+#include <linux/slab.h>
 #include <linux/syscalls.h>
 
 /* #define SECCOMP_DEBUG 1 */
@@ -27,7 +28,6 @@
 #include <linux/filter.h>
 #include <linux/ptrace.h>
 #include <linux/security.h>
-#include <linux/slab.h>
 #include <linux/tracehook.h>
 #include <linux/uaccess.h>
 
@@ -213,27 +213,23 @@ static inline void seccomp_assign_mode(unsigned long seccomp_mode)
 
 #ifdef CONFIG_SECCOMP_FILTER
 /**
- * seccomp_attach_filter: Attaches a seccomp filter to current.
+ * seccomp_prepare_filter: Prepares a seccomp filter for use.
  * @fprog: BPF program to install
  *
- * Returns 0 on success or an errno on failure.
+ * Returns filter on success or an ERR_PTR on failure.
  */
-static long seccomp_attach_filter(struct sock_fprog *fprog)
+static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
 {
 	struct seccomp_filter *filter;
-	unsigned long fp_size = fprog->len * sizeof(struct sock_filter);
-	unsigned long total_insns = fprog->len;
+	unsigned long fp_size;
 	struct sock_filter *fp;
 	int new_len;
 	long ret;
 
 	if (fprog->len == 0 || fprog->len > BPF_MAXINSNS)
-		return -EINVAL;
-
-	for (filter = current->seccomp.filter; filter; filter = filter->prev)
-		total_insns += filter->prog->len + 4;  /* include a 4 instr penalty */
-	if (total_insns > MAX_INSNS_PER_PATH)
-		return -ENOMEM;
+		return ERR_PTR(-EINVAL);
+	BUG_ON(INT_MAX / fprog->len < sizeof(struct sock_filter));
+	fp_size = fprog->len * sizeof(struct sock_filter);
 
 	/*
 	 * Installing a seccomp filter requires that the task has
@@ -244,11 +240,11 @@ static long seccomp_attach_filter(struct sock_fprog *fprog)
 	if (!task_no_new_privs(current) &&
 	    security_capable_noaudit(current_cred(), current_user_ns(),
 				     CAP_SYS_ADMIN) != 0)
-		return -EACCES;
+		return ERR_PTR(-EACCES);
 
 	fp = kzalloc(fp_size, GFP_KERNEL|__GFP_NOWARN);
 	if (!fp)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	/* Copy the instructions from fprog. */
 	ret = -EFAULT;
@@ -292,13 +288,7 @@ static long seccomp_attach_filter(struct sock_fprog *fprog)
 
 	sk_filter_select_runtime(filter->prog);
 
-	/*
-	 * If there is an existing filter, make it the prev and don't drop its
-	 * task reference.
-	 */
-	filter->prev = current->seccomp.filter;
-	current->seccomp.filter = filter;
-	return 0;
+	return filter;
 
 free_filter_prog:
 	kfree(filter->prog);
@@ -306,19 +296,20 @@ free_filter:
 	kfree(filter);
 free_prog:
 	kfree(fp);
-	return ret;
+	return ERR_PTR(ret);
 }
 
 /**
- * seccomp_attach_user_filter - attaches a user-supplied sock_fprog
+ * seccomp_prepare_user_filter - prepares a user-supplied sock_fprog
  * @user_filter: pointer to the user data containing a sock_fprog.
  *
  * Returns 0 on success and non-zero otherwise.
  */
-static long seccomp_attach_user_filter(const char __user *user_filter)
+static struct seccomp_filter *
+seccomp_prepare_user_filter(const char __user *user_filter)
 {
 	struct sock_fprog fprog;
-	long ret = -EFAULT;
+	struct seccomp_filter *filter = ERR_PTR(-EFAULT);
 
 #ifdef CONFIG_COMPAT
 	if (is_compat_task()) {
@@ -331,9 +322,39 @@ static long seccomp_attach_user_filter(const char __user *user_filter)
 #endif
 	if (copy_from_user(&fprog, user_filter, sizeof(fprog)))
 		goto out;
-	ret = seccomp_attach_filter(&fprog);
+	filter = seccomp_prepare_filter(&fprog);
 out:
-	return ret;
+	return filter;
+}
+
+/**
+ * seccomp_attach_filter: validate and attach filter
+ * @flags:  flags to change filter behavior
+ * @filter: seccomp filter to add to the current process
+ *
+ * Returns 0 on success, -ve on error.
+ */
+static long seccomp_attach_filter(unsigned int flags,
+				  struct seccomp_filter *filter)
+{
+	unsigned long total_insns;
+	struct seccomp_filter *walker;
+
+	/* Validate resulting filter length. */
+	total_insns = filter->prog->len;
+	for (walker = current->seccomp.filter; walker; walker = walker->prev)
+		total_insns += walker->prog->len + 4;  /* 4 instr penalty */
+	if (total_insns > MAX_INSNS_PER_PATH)
+		return -ENOMEM;
+
+	/*
+	 * If there is an existing filter, make it the prev and don't drop its
+	 * task reference.
+	 */
+	filter->prev = current->seccomp.filter;
+	current->seccomp.filter = filter;
+
+	return 0;
 }
 
 /* get_seccomp_filter - increments the reference count of the filter on @tsk */
@@ -346,6 +367,14 @@ void get_seccomp_filter(struct task_struct *tsk)
 	atomic_inc(&orig->usage);
 }
 
+static inline void seccomp_filter_free(struct seccomp_filter *filter)
+{
+	if (filter) {
+		sk_filter_free(filter->prog);
+		kfree(filter);
+	}
+}
+
 /* put_seccomp_filter - decrements the ref count of tsk->seccomp.filter */
 void put_seccomp_filter(struct task_struct *tsk)
 {
@@ -354,8 +383,7 @@ void put_seccomp_filter(struct task_struct *tsk)
 	while (orig && atomic_dec_and_test(&orig->usage)) {
 		struct seccomp_filter *freeme = orig;
 		orig = orig->prev;
-		sk_filter_free(freeme->prog);
-		kfree(freeme);
+		seccomp_filter_free(freeme);
 	}
 }
 
@@ -533,21 +561,30 @@ static long seccomp_set_mode_filter(unsigned int flags,
 				    const char __user *filter)
 {
 	const unsigned long seccomp_mode = SECCOMP_MODE_FILTER;
+	struct seccomp_filter *prepared = NULL;
 	long ret = -EINVAL;
 
 	/* Validate flags. */
 	if (flags != 0)
 		goto out;
 
+	/* Prepare the new filter before holding any locks. */
+	prepared = seccomp_prepare_user_filter(filter);
+	if (IS_ERR(prepared))
+		return PTR_ERR(prepared);
+
 	if (!seccomp_may_assign_mode(seccomp_mode))
 		goto out;
 
-	ret = seccomp_attach_user_filter(filter);
+	ret = seccomp_attach_filter(flags, prepared);
 	if (ret)
 		goto out;
+	/* Do not free the successfully attached filter. */
+	prepared = NULL;
 
 	seccomp_assign_mode(seccomp_mode);
 out:
+	seccomp_filter_free(prepared);
 	return ret;
 }
 #else
-- 
1.7.9.5
