From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: [RFC PATCH 3/3] tracing/syscalls: add compat syscall metadata
Date: Fri, 9 Sep 2016 10:03:29 +0200
Message-ID: <1473408209-17335-4-git-send-email-marcin.nowakowski@imgtec.com>
References: <1473408209-17335-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473408209-17335-1-git-send-email-marcin.nowakowski@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, Marcin Nowakowski <marcin.nowakowski@imgtec.com>
List-Id: linux-api@vger.kernel.org

Now that compat syscalls are properly distinguished from native calls,
we can add metadata for compat syscalls as well.
All the macros used to generate the metadata are the same as for
standard syscalls, but with a compat_ prefix to distinguish them easily.

Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>

---
 include/linux/compat.h        | 74 +++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_syscalls.c |  7 ++--
 2 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index f964ef7..9e84c92 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -30,7 +30,80 @@
 #define __SC_DELOUSE(t,v) ((t)(unsigned long)(v))
 #endif
 
+#ifdef CONFIG_FTRACE_SYSCALLS
+#ifndef __SC_STR_ADECL
+#define __SC_STR_ADECL(t, a)	#a
+#endif
+
+#ifndef __SC_STR_TDECL
+#define __SC_STR_TDECL(t, a)	#t
+#endif
+
+extern struct trace_event_class event_class_syscall_enter;
+extern struct trace_event_class event_class_syscall_exit;
+extern struct trace_event_functions enter_syscall_print_funcs;
+extern struct trace_event_functions exit_syscall_print_funcs;
+
+#define COMPAT_SYSCALL_TRACE_ENTER_EVENT(sname)				\
+	static struct syscall_metadata __syscall_meta_compat_##sname;		\
+	static struct trace_event_call __used				\
+	  event_enter_compat_##sname = {					\
+		.class			= &event_class_syscall_enter,	\
+		{							\
+			.name                   = "compat_sys_enter"#sname,	\
+		},							\
+		.event.funcs            = &enter_syscall_print_funcs,	\
+		.data			= (void *)&__syscall_meta_compat_##sname,\
+		.flags                  = TRACE_EVENT_FL_CAP_ANY,	\
+	};								\
+	static struct trace_event_call __used				\
+	  __attribute__((section("_ftrace_events")))			\
+	 *__event_enter_compat_##sname = &event_enter_compat_##sname;
+
+#define COMPAT_SYSCALL_TRACE_EXIT_EVENT(sname)					\
+	static struct syscall_metadata __syscall_meta_compat_##sname;		\
+	static struct trace_event_call __used				\
+	  event_exit_compat_##sname = {					\
+		.class			= &event_class_syscall_exit,	\
+		{							\
+			.name                   = "compat_sys_exit"#sname,	\
+		},							\
+		.event.funcs		= &exit_syscall_print_funcs,	\
+		.data			= (void *)&__syscall_meta_compat_##sname,\
+		.flags                  = TRACE_EVENT_FL_CAP_ANY,	\
+	};								\
+	static struct trace_event_call __used				\
+	  __attribute__((section("_ftrace_events")))			\
+	*__event_exit_compat_##sname = &event_exit_compat_##sname;
+
+#define COMPAT_SYSCALL_METADATA(sname, nb, ...)			\
+	static const char *types_compat_##sname[] = {			\
+		__MAP(nb,__SC_STR_TDECL,__VA_ARGS__)		\
+	};							\
+	static const char *args_compat_##sname[] = {			\
+		__MAP(nb,__SC_STR_ADECL,__VA_ARGS__)		\
+	};							\
+	COMPAT_SYSCALL_TRACE_ENTER_EVENT(sname);			\
+	COMPAT_SYSCALL_TRACE_EXIT_EVENT(sname);			\
+	static struct syscall_metadata __used			\
+	  __syscall_meta_compat_##sname = {				\
+		.name 		= "compat_sys"#sname,			\
+		.nb_args 	= nb,				\
+		.types		= nb ? types_compat_##sname : NULL,	\
+		.args		= nb ? args_compat_##sname : NULL,	\
+		.enter_event	= &event_enter_compat_##sname,		\
+		.exit_event	= &event_exit_compat_##sname,		\
+		.enter_fields	= LIST_HEAD_INIT(__syscall_meta_compat_##sname.enter_fields), \
+	};							\
+	static struct syscall_metadata __used			\
+	  __attribute__((section("__syscalls_metadata")))	\
+	 *__p_syscall_meta_compat_##sname = &__syscall_meta_compat_##sname;
+#else
+#define COMPAT_SYSCALL_METADATA(sname, nb, ...)
+#endif
+
 #define COMPAT_SYSCALL_DEFINE0(name) \
+		COMPAT_SYSCALL_METADATA(_##name, 0);				\
 	asmlinkage long compat_sys_##name(void)
 
 #define COMPAT_SYSCALL_DEFINE1(name, ...) \
@@ -47,6 +120,7 @@
 	COMPAT_SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
 
 #define COMPAT_SYSCALL_DEFINEx(x, name, ...)				\
+		COMPAT_SYSCALL_METADATA(name, x, __VA_ARGS__) \
 	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))\
 		__attribute__((alias(__stringify(compat_SyS##name))));  \
 	static inline long C_SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index dc7df38..5c3587f 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -35,12 +35,15 @@ static struct syscall_metadata **syscalls_metadata;
 static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
 {
 	/*
-	 * Only compare after the "sys" prefix. Archs that use
+	 * Only compare after the "sys" or "compat_sys" prefix. Archs that use
 	 * syscall wrappers may have syscalls symbols aliases prefixed
 	 * with ".SyS" or ".sys" instead of "sys", leading to an unwanted
 	 * mismatch.
 	 */
-	return !strcmp(sym + 3, name + 3);
+	int prefix_len = 3;
+	if (!strncasecmp(sym, "compat_", 7))
+		prefix_len = 10;
+	return !strcmp(sym + prefix_len, name + prefix_len);
 }
 #endif
 
-- 
2.7.4
