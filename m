From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v10 1/3] x86/syscalls: Check address limit on user-mode return
Date: Wed, 14 Jun 2017 18:12:01 -0700
Message-ID: <20170615011203.144108-1-thgarnie@google.com>
Return-path: <kernel-hardening-return-8584-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Dave Hansen <dave.hansen@intel.com>, David Howells <dhowells@redhat.com>, Russell King <linux@armlinux.org.uk>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Pratyush Anand <panand@redhat.com>, Chris Metcalf <cmetcalf@mellanox.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Ensure the address limit is a user-mode segment before returning to
user-mode. Otherwise a process can corrupt kernel-mode memory and elevate
privileges [1].

The set_fs function sets the TIF_SETFS flag to force a slow path on
return. In the slow path, the address limit is checked to be USER_DS if
needed.

The addr_limit_user_check function is added as a cross-architecture
function to check the address limit.

[1] https://bugs.chromium.org/p/project-zero/issues/detail?id=990

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
v10 redesigns the change to use work flags on set_fs as recommended by
Linus and agreed by others.

Based on next-20170609
---
 arch/x86/entry/common.c            |  3 +++
 arch/x86/include/asm/thread_info.h |  5 ++++-
 arch/x86/include/asm/uaccess.h     |  7 ++++++-
 include/linux/syscalls.h           | 16 ++++++++++++++++
 4 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index cdefcfdd9e63..03505ffbe1b6 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -23,6 +23,7 @@
 #include <linux/user-return-notifier.h>
 #include <linux/uprobes.h>
 #include <linux/livepatch.h>
+#include <linux/syscalls.h>
 
 #include <asm/desc.h>
 #include <asm/traps.h>
@@ -183,6 +184,8 @@ __visible inline void prepare_exit_to_usermode(struct pt_regs *regs)
 	struct thread_info *ti = current_thread_info();
 	u32 cached_flags;
 
+	addr_limit_user_check();
+
 	if (IS_ENABLED(CONFIG_PROVE_LOCKING) && WARN_ON(!irqs_disabled()))
 		local_irq_disable();
 
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e00e1bd6e7b3..5161da1a0fa0 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -98,6 +98,7 @@ struct thread_info {
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
 #define TIF_ADDR32		29	/* 32-bit address space on 64 bits */
 #define TIF_X32			30	/* 32-bit native x86-64 binary */
+#define TIF_FSCHECK		31	/* Check FS is USER_DS on return */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -122,6 +123,7 @@ struct thread_info {
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_ADDR32		(1 << TIF_ADDR32)
 #define _TIF_X32		(1 << TIF_X32)
+#define _TIF_FSCHECK		(1 << TIF_FSCHECK)
 
 /*
  * work to do in syscall_trace_enter().  Also includes TIF_NOHZ for
@@ -137,7 +139,8 @@ struct thread_info {
 	(_TIF_SYSCALL_TRACE | _TIF_NOTIFY_RESUME | _TIF_SIGPENDING |	\
 	 _TIF_NEED_RESCHED | _TIF_SINGLESTEP | _TIF_SYSCALL_EMU |	\
 	 _TIF_SYSCALL_AUDIT | _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE |	\
-	 _TIF_PATCH_PENDING | _TIF_NOHZ | _TIF_SYSCALL_TRACEPOINT)
+	 _TIF_PATCH_PENDING | _TIF_NOHZ | _TIF_SYSCALL_TRACEPOINT |	\
+	 _TIF_FSCHECK)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index a059aac9e937..11433f9018e2 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -26,7 +26,12 @@
 
 #define get_ds()	(KERNEL_DS)
 #define get_fs()	(current->thread.addr_limit)
-#define set_fs(x)	(current->thread.addr_limit = (x))
+static inline void set_fs(mm_segment_t fs)
+{
+	current->thread.addr_limit = fs;
+	/* On user-mode return, check fs is correct */
+	set_thread_flag(TIF_FSCHECK);
+}
 
 #define segment_eq(a, b)	((a).seg == (b).seg)
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 980c3c9b06f8..ac0cf6fb25d6 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -206,6 +206,22 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	}								\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
+#ifdef TIF_FSCHECK
+/*
+ * Called before coming back to user-mode. Returning to user-mode with an
+ * address limit different than USER_DS can allow to overwrite kernel memory.
+ */
+static inline void addr_limit_user_check(void)
+{
+
+	if (!test_thread_flag(TIF_FSCHECK))
+		return;
+
+	BUG_ON(!segment_eq(get_fs(), USER_DS));
+	clear_thread_flag(TIF_FSCHECK);
+}
+#endif
+
 asmlinkage long sys32_quotactl(unsigned int cmd, const char __user *special,
 			       qid_t id, void __user *addr);
 asmlinkage long sys_time(time_t __user *tloc);
-- 
2.13.1.518.g3df882009-goog
