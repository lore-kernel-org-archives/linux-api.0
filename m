From: Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH bpf-next 2/5] tracepoint: compute num_args at build time
Date: Wed, 28 Feb 2018 20:19:54 -0800
Message-ID: <20180301041957.399230-3-ast@kernel.org>
References: <20180301041957.399230-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180301041957.399230-1-ast@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, mingo@kernel.org, rostedt@goodmis.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

add fancy macro to compute number of arguments passed into tracepoint
at compile time and store it as part of 'struct tracepoint'.
The number is necessary to check safety of bpf program access that
is coming in subsequent patch.

for_each_tracepoint_range() api has no users inside the kernel.
Make it more useful with ability to stop for_each() loop depending
via callback return value.
In such form it's used in subsequent patch.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/tracepoint-defs.h |  1 +
 include/linux/tracepoint.h      | 32 +++++++++++++++++++++++---------
 include/trace/define_trace.h    | 14 +++++++-------
 kernel/tracepoint.c             | 27 ++++++++++++++++-----------
 4 files changed, 47 insertions(+), 27 deletions(-)

diff --git a/include/linux/tracepoint-defs.h b/include/linux/tracepoint-defs.h
index 64ed7064f1fa..39a283c61c51 100644
--- a/include/linux/tracepoint-defs.h
+++ b/include/linux/tracepoint-defs.h
@@ -33,6 +33,7 @@ struct tracepoint {
 	int (*regfunc)(void);
 	void (*unregfunc)(void);
 	struct tracepoint_func __rcu *funcs;
+	u32 num_args;
 };
 
 #endif
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index c94f466d57ef..b1676e53bb23 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -40,9 +40,19 @@ tracepoint_probe_register_prio(struct tracepoint *tp, void *probe, void *data,
 			       int prio);
 extern int
 tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data);
-extern void
-for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
-		void *priv);
+
+#ifdef CONFIG_TRACEPOINTS
+void *
+for_each_kernel_tracepoint(void *(*fct)(struct tracepoint *tp, void *priv),
+			   void *priv);
+#else
+static inline void *
+for_each_kernel_tracepoint(void *(*fct)(struct tracepoint *tp, void *priv),
+			   void *priv)
+{
+	return NULL;
+}
+#endif
 
 #ifdef CONFIG_MODULES
 struct tp_module {
@@ -225,23 +235,27 @@ extern void syscall_unregfunc(void);
 		return static_key_false(&__tracepoint_##name.key);	\
 	}
 
+#define ___FN_COUNT(fn,n0,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,n13,n14,n15,n16,n,...) fn##n
+#define __FN_COUNT(fn,...) ___FN_COUNT(fn,##__VA_ARGS__,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0)
+#define __COUNT(...) __FN_COUNT(/**/,##__VA_ARGS__)
+
 /*
  * We have no guarantee that gcc and the linker won't up-align the tracepoint
  * structures, so we create an array of pointers that will be used for iteration
  * on the tracepoints.
  */
-#define DEFINE_TRACE_FN(name, reg, unreg)				 \
+#define DEFINE_TRACE_FN(name, reg, unreg, num_args)			 \
 	static const char __tpstrtab_##name[]				 \
 	__attribute__((section("__tracepoints_strings"))) = #name;	 \
 	struct tracepoint __tracepoint_##name				 \
 	__attribute__((section("__tracepoints"))) =			 \
-		{ __tpstrtab_##name, STATIC_KEY_INIT_FALSE, reg, unreg, NULL };\
+		{ __tpstrtab_##name, STATIC_KEY_INIT_FALSE, reg, unreg, NULL, num_args };\
 	static struct tracepoint * const __tracepoint_ptr_##name __used	 \
 	__attribute__((section("__tracepoints_ptrs"))) =		 \
 		&__tracepoint_##name;
 
-#define DEFINE_TRACE(name)						\
-	DEFINE_TRACE_FN(name, NULL, NULL);
+#define DEFINE_TRACE(name, num_args)					\
+	DEFINE_TRACE_FN(name, NULL, NULL, num_args);
 
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)				\
 	EXPORT_SYMBOL_GPL(__tracepoint_##name)
@@ -275,8 +289,8 @@ extern void syscall_unregfunc(void);
 		return false;						\
 	}
 
-#define DEFINE_TRACE_FN(name, reg, unreg)
-#define DEFINE_TRACE(name)
+#define DEFINE_TRACE_FN(name, reg, unreg, num_args)
+#define DEFINE_TRACE(name, num_args)
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
 #define EXPORT_TRACEPOINT_SYMBOL(name)
 
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index d9e3d4aa3f6e..c040eda95d41 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -25,7 +25,7 @@
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
-	DEFINE_TRACE(name)
+	DEFINE_TRACE(name, __COUNT(args))
 
 #undef TRACE_EVENT_CONDITION
 #define TRACE_EVENT_CONDITION(name, proto, args, cond, tstruct, assign, print) \
@@ -39,24 +39,24 @@
 #undef TRACE_EVENT_FN
 #define TRACE_EVENT_FN(name, proto, args, tstruct,		\
 		assign, print, reg, unreg)			\
-	DEFINE_TRACE_FN(name, reg, unreg)
+	DEFINE_TRACE_FN(name, reg, unreg, __COUNT(args))
 
 #undef TRACE_EVENT_FN_COND
 #define TRACE_EVENT_FN_COND(name, proto, args, cond, tstruct,		\
 		assign, print, reg, unreg)			\
-	DEFINE_TRACE_FN(name, reg, unreg)
+	DEFINE_TRACE_FN(name, reg, unreg, __COUNT(args))
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args) \
-	DEFINE_TRACE(name)
+	DEFINE_TRACE(name, __COUNT(args))
 
 #undef DEFINE_EVENT_FN
 #define DEFINE_EVENT_FN(template, name, proto, args, reg, unreg) \
-	DEFINE_TRACE_FN(name, reg, unreg)
+	DEFINE_TRACE_FN(name, reg, unreg, __COUNT(args))
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DEFINE_TRACE(name)
+	DEFINE_TRACE(name, __COUNT(args))
 
 #undef DEFINE_EVENT_CONDITION
 #define DEFINE_EVENT_CONDITION(template, name, proto, args, cond) \
@@ -64,7 +64,7 @@
 
 #undef DECLARE_TRACE
 #define DECLARE_TRACE(name, proto, args)	\
-	DEFINE_TRACE(name)
+	DEFINE_TRACE(name, __COUNT(args))
 
 #undef TRACE_INCLUDE
 #undef __TRACE_INCLUDE
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 671b13457387..3f2dc5738c2b 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -502,17 +502,22 @@ static __init int init_tracepoints(void)
 __initcall(init_tracepoints);
 #endif /* CONFIG_MODULES */
 
-static void for_each_tracepoint_range(struct tracepoint * const *begin,
-		struct tracepoint * const *end,
-		void (*fct)(struct tracepoint *tp, void *priv),
-		void *priv)
+static void *for_each_tracepoint_range(struct tracepoint * const *begin,
+				       struct tracepoint * const *end,
+				       void *(*fct)(struct tracepoint *tp, void *priv),
+				       void *priv)
 {
 	struct tracepoint * const *iter;
+	void *ret;
 
 	if (!begin)
-		return;
-	for (iter = begin; iter < end; iter++)
-		fct(*iter, priv);
+		return NULL;
+	for (iter = begin; iter < end; iter++) {
+		ret = fct(*iter, priv);
+		if (ret)
+			return ret;
+	}
+	return NULL;
 }
 
 /**
@@ -520,11 +525,11 @@ static void for_each_tracepoint_range(struct tracepoint * const *begin,
  * @fct: callback
  * @priv: private data
  */
-void for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
-		void *priv)
+void *for_each_kernel_tracepoint(void *(*fct)(struct tracepoint *tp, void *priv),
+				 void *priv)
 {
-	for_each_tracepoint_range(__start___tracepoints_ptrs,
-		__stop___tracepoints_ptrs, fct, priv);
+	return for_each_tracepoint_range(__start___tracepoints_ptrs,
+					 __stop___tracepoints_ptrs, fct, priv);
 }
 EXPORT_SYMBOL_GPL(for_each_kernel_tracepoint);
 
-- 
2.9.5
