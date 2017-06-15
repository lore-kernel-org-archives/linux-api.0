From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v10 3/3] arm64/syscalls: Check address limit on user-mode return
Date: Wed, 14 Jun 2017 18:12:03 -0700
Message-ID: <20170615011203.144108-3-thgarnie@google.com>
References: <20170615011203.144108-1-thgarnie@google.com>
Return-path: <kernel-hardening-return-8586-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170615011203.144108-1-thgarnie@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, David Howells <dhowells@redhat.com>, Russell King <linux@armlinux.org.uk>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Pratyush Anand <panand@redhat.com>, Chris Metcalf <cmetcalf@mellanox.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Ensure the address limit is a user-mode segment before returning to
user-mode. Otherwise a process can corrupt kernel-mode memory and
elevate privileges [1].

The set_fs function sets the TIF_SETFS flag to force a slow path on
return. In the slow path, the address limit is checked to be USER_DS if
needed.

[1] https://bugs.chromium.org/p/project-zero/issues/detail?id=990

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
v10 redesigns the change to use work flags on set_fs as recommended by
Linus and agreed by others.

Based on next-20170609
---
 arch/arm64/include/asm/thread_info.h | 4 +++-
 arch/arm64/include/asm/uaccess.h     | 3 +++
 arch/arm64/kernel/signal.c           | 5 +++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 46c3b93cf865..c5ba565544ee 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -86,6 +86,7 @@ struct thread_info {
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_FOREIGN_FPSTATE	3	/* CPU's FP state is not current's */
 #define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */
+#define TIF_FSCHECK		5	/* Check FS is USER_DS on return */
 #define TIF_NOHZ		7
 #define TIF_SYSCALL_TRACE	8
 #define TIF_SYSCALL_AUDIT	9
@@ -107,11 +108,12 @@ struct thread_info {
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
+#define _TIF_FSCHECK		(1 << TIF_FSCHECK)
 #define _TIF_32BIT		(1 << TIF_32BIT)
 
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
 				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
-				 _TIF_UPROBE)
+				 _TIF_UPROBE | _TIF_FSCHECK)
 
 #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
 				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 7b8a04789cef..ced7a7c2dd41 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -45,6 +45,9 @@ static inline void set_fs(mm_segment_t fs)
 {
 	current_thread_info()->addr_limit = fs;
 
+	/* On user-mode return, check fs is correct */
+	set_thread_flag(TIF_FSCHECK);
+
 	/*
 	 * Enable/disable UAO so that copy_to_user() etc can access
 	 * kernel memory with the unprivileged instructions.
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index c7b6de62f9d3..0f0279148bdc 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -25,6 +25,7 @@
 #include <linux/uaccess.h>
 #include <linux/tracehook.h>
 #include <linux/ratelimit.h>
+#include <linux/syscalls.h>
 
 #include <asm/debug-monitors.h>
 #include <asm/elf.h>
@@ -408,6 +409,10 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 	 * Update the trace code with the current status.
 	 */
 	trace_hardirqs_off();
+
+	/* Check valid user FS if needed */
+	addr_limit_user_check();
+
 	do {
 		if (thread_flags & _TIF_NEED_RESCHED) {
 			schedule();
-- 
2.13.1.518.g3df882009-goog
