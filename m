From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: [PATCH v4 03/12] tracing/syscalls: drop arch_syscall_match_sym_name
Date: Fri, 14 Oct 2016 10:35:05 +0200
Message-ID: <1476434115-25428-4-git-send-email-marcin.nowakowski@imgtec.com>
References: <1476434115-25428-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476434115-25428-1-git-send-email-marcin.nowakowski@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, Marcin Nowakowski <marcin.nowakowski@imgtec.com>, Michael Ellerman <mpe@ellerman.id.au>
List-Id: linux-api@vger.kernel.org

arch_syscall_match_sym_name has been previously added to allow arch to
override syscall_match_sym_name method, but only ppc arch implements it
and the only difference made is that a prefix is longer. This can be
simplified by using a #define specifying the prefix length difference
for a given arch.
Next commit will make syscall_match_sym_name implementation a bit
larger, so clean it up now to avoid further patching arch code whenever
the core method changes.

Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 Documentation/trace/ftrace-design.txt |  4 ----
 arch/powerpc/include/asm/ftrace.h     | 15 ++-------------
 kernel/trace/trace_syscalls.c         | 14 ++++++++------
 3 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index a273dd0..c30608e 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -237,10 +237,6 @@ You need very few things to get the syscalls tracing in an arch.
 - If the system call table on this arch is more complicated than a simple array
   of addresses of the system calls, implement an arch_syscall_addr to return
   the address of a given system call.
-- If the symbol names of the system calls do not match the function names on
-  this arch, define ARCH_HAS_SYSCALL_MATCH_SYM_NAME in asm/ftrace.h and
-  implement arch_syscall_match_sym_name with the appropriate logic to return
-  true if the function name corresponds with the symbol name.
 - Tag this arch as HAVE_SYSCALL_TRACEPOINTS.
 
 
diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index 686c5f7..f266051 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -67,20 +67,9 @@ struct dyn_arch_ftrace {
 #endif
 #endif
 
-#if defined(CONFIG_FTRACE_SYSCALLS) && !defined(__ASSEMBLY__)
 #ifdef PPC64_ELF_ABI_v1
-#define ARCH_HAS_SYSCALL_MATCH_SYM_NAME
-static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
-{
-	/*
-	 * Compare the symbol name with the system call name. Skip the .sys or .SyS
-	 * prefix from the symbol name and the sys prefix from the system call name and
-	 * just match the rest. This is only needed on ppc64 since symbol names on
-	 * 32bit do not start with a period so the generic function will work.
-	 */
-	return !strcmp(sym + 4, name + 3);
-}
+/* On ppc64 ABIv1 (BE) we have to skip the leading '.' in the symbol name */
+#define ARCH_SYM_NAME_SKIP_CHARS 1
 #endif
-#endif /* CONFIG_FTRACE_SYSCALLS && !__ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_FTRACE */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 9065db3..707a57c 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -31,8 +31,11 @@ extern struct syscall_metadata *__stop_syscalls_metadata[];
 
 static struct syscall_metadata **syscalls_metadata;
 
-#ifndef ARCH_HAS_SYSCALL_MATCH_SYM_NAME
-static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
+#ifndef ARCH_SYM_NAME_SKIP_CHARS
+#define ARCH_SYM_NAME_SKIP_CHARS 0
+#endif
+
+static inline bool syscall_match_sym_name(const char *sym, const char *name)
 {
 	/*
 	 * Only compare after the "sys" prefix. Archs that use
@@ -40,9 +43,8 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 	 * with ".SyS" or ".sys" instead of "sys", leading to an unwanted
 	 * mismatch.
 	 */
-	return !strcmp(sym + 3, name + 3);
+	return !strcmp(sym + 3 + ARCH_SYM_NAME_SKIP_CHARS, name + 3);
 }
-#endif
 
 #ifdef ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP
 /*
@@ -86,11 +88,11 @@ find_syscall_meta(unsigned long syscall)
 	stop = __stop_syscalls_metadata;
 	kallsyms_lookup(syscall, NULL, NULL, NULL, str);
 
-	if (arch_syscall_match_sym_name(str, "sys_ni_syscall"))
+	if (syscall_match_sym_name(str, "sys_ni_syscall"))
 		return NULL;
 
 	for ( ; start < stop; start++) {
-		if ((*start)->name && arch_syscall_match_sym_name(str, (*start)->name))
+		if ((*start)->name && syscall_match_sym_name(str, (*start)->name))
 			return *start;
 	}
 	return NULL;
-- 
2.7.4
