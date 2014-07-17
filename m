From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v12 10/11] seccomp: allow mode setting across threads
Date: Thu, 17 Jul 2014 11:08:37 -0700
Message-ID: <1405620518-18495-11-git-send-email-keescook@chromium.org>
References: <1405620518-18495-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405620518-18495-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, David Drysdale <drysdale@google.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This changes the mode setting helper to allow threads to change the
seccomp mode from another thread. We must maintain barriers to keep
TIF_SECCOMP synchronized with the rest of the seccomp state.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/seccomp.c |   36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index d5543e787e4e..9065d2c79c56 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -173,21 +173,24 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
  */
 static u32 seccomp_run_filters(int syscall)
 {
-	struct seccomp_filter *f;
+	struct seccomp_filter *f = ACCESS_ONCE(current->seccomp.filter);
 	struct seccomp_data sd;
 	u32 ret = SECCOMP_RET_ALLOW;
 
 	/* Ensure unexpected behavior doesn't result in failing open. */
-	if (WARN_ON(current->seccomp.filter == NULL))
+	if (unlikely(WARN_ON(f == NULL)))
 		return SECCOMP_RET_KILL;
 
+	/* Make sure cross-thread synced filter points somewhere sane. */
+	smp_read_barrier_depends();
+
 	populate_seccomp_data(&sd);
 
 	/*
 	 * All filters in the list are evaluated and the lowest BPF return
 	 * value always takes priority (ignoring the DATA).
 	 */
-	for (f = current->seccomp.filter; f; f = f->prev) {
+	for (; f; f = f->prev) {
 		u32 cur_ret = SK_RUN_FILTER(f->prog, (void *)&sd);
 
 		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
@@ -207,12 +210,18 @@ static inline bool seccomp_may_assign_mode(unsigned long seccomp_mode)
 	return true;
 }
 
-static inline void seccomp_assign_mode(unsigned long seccomp_mode)
+static inline void seccomp_assign_mode(struct task_struct *task,
+				       unsigned long seccomp_mode)
 {
-	BUG_ON(!spin_is_locked(&current->sighand->siglock));
+	BUG_ON(!spin_is_locked(&task->sighand->siglock));
 
-	current->seccomp.mode = seccomp_mode;
-	set_tsk_thread_flag(current, TIF_SECCOMP);
+	task->seccomp.mode = seccomp_mode;
+	/*
+	 * Make sure TIF_SECCOMP cannot be set before the mode (and
+	 * filter) is set.
+	 */
+	smp_mb__before_atomic();
+	set_tsk_thread_flag(task, TIF_SECCOMP);
 }
 
 #ifdef CONFIG_SECCOMP_FILTER
@@ -435,12 +444,17 @@ static int mode1_syscalls_32[] = {
 
 int __secure_computing(int this_syscall)
 {
-	int mode = current->seccomp.mode;
 	int exit_sig = 0;
 	int *syscall;
 	u32 ret;
 
-	switch (mode) {
+	/*
+	 * Make sure that any changes to mode from another thread have
+	 * been seen after TIF_SECCOMP was seen.
+	 */
+	rmb();
+
+	switch (current->seccomp.mode) {
 	case SECCOMP_MODE_STRICT:
 		syscall = mode1_syscalls;
 #ifdef CONFIG_COMPAT
@@ -545,7 +559,7 @@ static long seccomp_set_mode_strict(void)
 #ifdef TIF_NOTSC
 	disable_TSC();
 #endif
-	seccomp_assign_mode(seccomp_mode);
+	seccomp_assign_mode(current, seccomp_mode);
 	ret = 0;
 
 out:
@@ -595,7 +609,7 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	/* Do not free the successfully attached filter. */
 	prepared = NULL;
 
-	seccomp_assign_mode(seccomp_mode);
+	seccomp_assign_mode(current, seccomp_mode);
 out:
 	spin_unlock_irq(&current->sighand->siglock);
 	seccomp_filter_free(prepared);
-- 
1.7.9.5
