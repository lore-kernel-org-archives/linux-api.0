From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v1 1/4] syscalls: Restore address limit after a syscall
Date: Wed,  8 Mar 2017 13:38:41 -0800
Message-ID: <20170308213844.131877-1-thgarnie@google.com>
Return-path: <kernel-hardening-return-6930-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
To: Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, Thomas Garnier <thgarnie@google.com>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

This patch prevents a syscall to modify the address limit of the
caller. The address limit is kept by the syscall wrapper and restored
just after the syscall ends.

For example, it would mitigation this bug:

- https://bugs.chromium.org/p/project-zero/issues/detail?id=990

By default, this change warns if the segment is incorrect while
returning to user-mode and fix it. The
CONFIG_VERIFY_PRE_USERMODE_STATE_BUG option can be enabled to halt
instead if needed.

The CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE option is also
added so each architecture can optimize how the
verify_pre_usermode_state function is called.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20170308
---
 include/linux/syscalls.h | 19 +++++++++++++++++++
 init/Kconfig             | 16 ++++++++++++++++
 kernel/sys.c             | 11 +++++++++++
 3 files changed, 46 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 980c3c9b06f8..78a2268ecd6e 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -191,6 +191,22 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	SYSCALL_METADATA(sname, x, __VA_ARGS__)			\
 	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
 
+asmlinkage void verify_pre_usermode_state(void);
+
+#ifndef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
+static inline bool has_user_ds(void) {
+	bool ret = segment_eq(get_fs(), USER_DS);
+	// Prevent re-ordering the call
+	barrier();
+	return ret;
+}
+#else
+static inline bool has_user_ds(void) {
+	return false;
+}
+#endif
+
+
 #define __PROTECT(...) asmlinkage_protect(__VA_ARGS__)
 #define __SYSCALL_DEFINEx(x, name, ...)					\
 	asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))	\
@@ -199,7 +215,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
 	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
 	{								\
+		bool user_caller = has_user_ds();			\
 		long ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));	\
+		if (user_caller)					\
+			verify_pre_usermode_state();			\
 		__MAP(x,__SC_TEST,__VA_ARGS__);				\
 		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
 		return ret;						\
diff --git a/init/Kconfig b/init/Kconfig
index c859c993c26f..ab958b59063f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1929,6 +1929,22 @@ config PROFILING
 config TRACEPOINTS
 	bool
 
+#
+# Set by each architecture that want to optimize how verify_pre_usermode_state
+# is called.
+#
+config ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
+	bool
+
+config VERIFY_PRE_USERMODE_STATE_BUG
+	bool "Halt on incorrect state on returning to user-mode"
+	default n
+	help
+	  By default a warning is logged and the state is fixed. This option
+	  crashes the kernel instead.
+
+	  If unsure, say Y.
+
 source "arch/Kconfig"
 
 endmenu		# General setup
diff --git a/kernel/sys.c b/kernel/sys.c
index 196c7134bee6..cc2ebf7fae55 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2459,3 +2459,14 @@ COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
 	return 0;
 }
 #endif /* CONFIG_COMPAT */
+
+/* Called before coming back to user-mode */
+asmlinkage void verify_pre_usermode_state(void)
+{
+#ifdef CONFIG_VERIFY_PRE_USERMODE_STATE_BUG
+	BUG_ON(!segment_eq(get_fs(), USER_DS));
+#else
+	if (WARN_ON(!segment_eq(get_fs(), USER_DS)))
+		set_fs(USER_DS);
+#endif
+}
-- 
2.12.0.246.ga2ecc84866-goog
