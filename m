From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v9 10/11] seccomp: allow mode setting across threads
Date: Fri, 27 Jun 2014 16:22:59 -0700
Message-ID: <1403911380-27787-11-git-send-email-keescook@chromium.org>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1403911380-27787-1-git-send-email-keescook@chromium.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-mips@linux-mips.org, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Borkmann <dborkman@redhat.com>, Julien Tinnes <jln@chromium.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, David Drysdale <drysdale@google.com>, linux-arm-kernel@lists.infradead.org, Alexei Starovoitov <ast@plumgrid.com>
List-Id: linux-api@vger.kernel.org

This changes the mode setting helper to allow threads to change the
seccomp mode from another thread. We must maintain barriers to keep
TIF_SECCOMP synchronized with the rest of the seccomp state.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/seccomp.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index e1ff2c193190..7bbcb9ed16df 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -207,12 +207,18 @@ static inline bool seccomp_check_mode(unsigned long seccomp_mode)
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
@@ -433,12 +439,17 @@ static int mode1_syscalls_32[] = {
 
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
@@ -543,7 +554,7 @@ static long seccomp_set_mode_strict(void)
 #ifdef TIF_NOTSC
 	disable_TSC();
 #endif
-	seccomp_assign_mode(seccomp_mode);
+	seccomp_assign_mode(current, seccomp_mode);
 	ret = 0;
 
 out:
@@ -593,7 +604,7 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	/* Do not free the successfully attached filter. */
 	prepared = NULL;
 
-	seccomp_assign_mode(seccomp_mode);
+	seccomp_assign_mode(current, seccomp_mode);
 out:
 	spin_unlock_irq(&current->sighand->siglock);
 	seccomp_filter_free(prepared);
-- 
1.7.9.5
