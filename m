From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v3 03/11] tracing/syscalls: add compat syscall metadata
Date: Wed, 12 Oct 2016 19:50:39 +1100
Message-ID: <8737k254tc.fsf@concordia.ellerman.id.au>
References: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com> <1476182576-15247-4-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476182576-15247-4-git-send-email-marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org> writes:

> Now that compat syscalls are properly distinguished from native calls,
> we can add metadata for compat syscalls as well.
> All the macros used to generate the metadata are the same as for
> standard syscalls, but with a compat_ prefix to distinguish them easily.
>
> Signed-off-by: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
> Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
> Cc: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Cc: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> Cc: linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
> ---
>  arch/powerpc/include/asm/ftrace.h | 15 +++++---
>  include/linux/compat.h            | 74 +++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_syscalls.c     |  8 +++--
>  3 files changed, 90 insertions(+), 7 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
> index 686c5f7..9697a73 100644
> --- a/arch/powerpc/include/asm/ftrace.h
> +++ b/arch/powerpc/include/asm/ftrace.h
> @@ -73,12 +73,17 @@ struct dyn_arch_ftrace {
>  static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
>  {
>  	/*
> -	 * Compare the symbol name with the system call name. Skip the .sys or .SyS
> -	 * prefix from the symbol name and the sys prefix from the system call name and
> -	 * just match the rest. This is only needed on ppc64 since symbol names on
> -	 * 32bit do not start with a period so the generic function will work.
> +	 * Compare the symbol name with the system call name. Skip the .sys,
> +	 * .SyS or .compat_sys prefix from the symbol name and the sys prefix
> +	 * from the system call name and just match the rest. This is only
> +	 * needed on ppc64 since symbol names on 32bit do not start with a
> +	 * period so the generic function will work.
>  	 */
> -	return !strcmp(sym + 4, name + 3);
> +	int prefix_len = 3;
> +
> +	if (!strncasecmp(name, "compat_", 7))
> +		prefix_len = 10;
> +	return !strcmp(sym + prefix_len + 1, name + prefix_len);
>  }

It's annoying that we have to duplicate all that just to do a + 1.

How about this as a precursor?

cheers


diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index dd5f916b351d..bd65f2adeb09 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -226,10 +226,6 @@ You need very few things to get the syscalls tracing in an arch.
 - If the system call table on this arch is more complicated than a simple array
   of addresses of the system calls, implement an arch_syscall_addr to return
   the address of a given system call.
-- If the symbol names of the system calls do not match the function names on
-  this arch, define ARCH_HAS_SYSCALL_MATCH_SYM_NAME in asm/ftrace.h and
-  implement arch_syscall_match_sym_name with the appropriate logic to return
-  true if the function name corresponds with the symbol name.
 - Tag this arch as HAVE_SYSCALL_TRACEPOINTS.
 
 
diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index 686c5f70eb84..dc48f5b2878d 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -60,6 +60,12 @@ struct dyn_arch_ftrace {
 	struct module *mod;
 };
 #endif /*  CONFIG_DYNAMIC_FTRACE */
+
+#ifdef PPC64_ELF_ABI_v1
+/* On ppc64 ABIv1 (BE) we have to skip the leading '.' in the symbol name */
+#define ARCH_SYM_NAME_SKIP_CHARS 1
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
@@ -67,20 +73,4 @@ struct dyn_arch_ftrace {
 #endif
 #endif
 
-#if defined(CONFIG_FTRACE_SYSCALLS) && !defined(__ASSEMBLY__)
-#ifdef PPC64_ELF_ABI_v1
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
-#endif
-#endif /* CONFIG_FTRACE_SYSCALLS && !__ASSEMBLY__ */
-
 #endif /* _ASM_POWERPC_FTRACE */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index b2b6efc083a4..91a7315dbe43 100644
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
 
 #ifdef ARCH_TRACE_IGNORE_COMPAT_SYSCALLS
 /*
@@ -88,11 +90,11 @@ find_syscall_meta(unsigned long syscall)
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
