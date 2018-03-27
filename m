From: Alexei Starovoitov <ast@fb.com>
Subject: [PATCH v6 bpf-next 06/11] tracepoint: compute num_args at build time
Date: Mon, 26 Mar 2018 19:47:01 -0700
Message-ID: <20180327024706.2064725-7-ast@fb.com>
References: <20180327024706.2064725-1-ast@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180327024706.2064725-1-ast@fb.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

compute number of arguments passed into tracepoint
at compile time and store it as part of 'struct tracepoint'.
The number is necessary to check safety of bpf program access that
is coming in subsequent patch.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/tracepoint-defs.h |  1 +
 include/linux/tracepoint.h      | 12 ++++++------
 include/trace/define_trace.h    | 14 +++++++-------
 3 files changed, 14 insertions(+), 13 deletions(-)

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
index c94f466d57ef..c92f4adbc0d7 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -230,18 +230,18 @@ extern void syscall_unregfunc(void);
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
@@ -275,8 +275,8 @@ extern void syscall_unregfunc(void);
 		return false;						\
 	}
 
-#define DEFINE_TRACE_FN(name, reg, unreg)
-#define DEFINE_TRACE(name)
+#define DEFINE_TRACE_FN(name, reg, unreg, num_args)
+#define DEFINE_TRACE(name, num_args)
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
 #define EXPORT_TRACEPOINT_SYMBOL(name)
 
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index d9e3d4aa3f6e..96b22ace9ae7 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -25,7 +25,7 @@
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
-	DEFINE_TRACE(name)
+	DEFINE_TRACE(name, COUNT_ARGS(args))
 
 #undef TRACE_EVENT_CONDITION
 #define TRACE_EVENT_CONDITION(name, proto, args, cond, tstruct, assign, print) \
@@ -39,24 +39,24 @@
 #undef TRACE_EVENT_FN
 #define TRACE_EVENT_FN(name, proto, args, tstruct,		\
 		assign, print, reg, unreg)			\
-	DEFINE_TRACE_FN(name, reg, unreg)
+	DEFINE_TRACE_FN(name, reg, unreg, COUNT_ARGS(args))
 
 #undef TRACE_EVENT_FN_COND
 #define TRACE_EVENT_FN_COND(name, proto, args, cond, tstruct,		\
 		assign, print, reg, unreg)			\
-	DEFINE_TRACE_FN(name, reg, unreg)
+	DEFINE_TRACE_FN(name, reg, unreg, COUNT_ARGS(args))
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args) \
-	DEFINE_TRACE(name)
+	DEFINE_TRACE(name, COUNT_ARGS(args))
 
 #undef DEFINE_EVENT_FN
 #define DEFINE_EVENT_FN(template, name, proto, args, reg, unreg) \
-	DEFINE_TRACE_FN(name, reg, unreg)
+	DEFINE_TRACE_FN(name, reg, unreg, COUNT_ARGS(args))
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
-	DEFINE_TRACE(name)
+	DEFINE_TRACE(name, COUNT_ARGS(args))
 
 #undef DEFINE_EVENT_CONDITION
 #define DEFINE_EVENT_CONDITION(template, name, proto, args, cond) \
@@ -64,7 +64,7 @@
 
 #undef DECLARE_TRACE
 #define DECLARE_TRACE(name, proto, args)	\
-	DEFINE_TRACE(name)
+	DEFINE_TRACE(name, COUNT_ARGS(args))
 
 #undef TRACE_INCLUDE
 #undef __TRACE_INCLUDE
-- 
2.9.5
