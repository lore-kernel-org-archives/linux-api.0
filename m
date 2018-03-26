From: Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH v2 bpf-next] bpf, tracing: unbreak lttng
Date: Mon, 26 Mar 2018 16:02:20 -0700
Message-ID: <20180326230220.1069180-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

for_each_kernel_tracepoint() is used by out-of-tree lttng module
and therefore cannot be changed.
Instead introduce kernel_tracepoint_find_by_name() to find
tracepoint by name.

Fixes: 9e9afbae6514 ("tracepoint: compute num_args at build time")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
v1->v2: fix 'undef CONFIG_TRACEPOINTS' build as spotted by Mathieu
---
 include/linux/tracepoint.h | 13 ++++++++-----
 kernel/bpf/syscall.c       | 11 +----------
 kernel/tracepoint.c        | 36 ++++++++++++++++++++----------------
 3 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 2194e7c31484..d578a962091e 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -42,13 +42,16 @@ extern int
 tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data);
 
 #ifdef CONFIG_TRACEPOINTS
-void *
-for_each_kernel_tracepoint(void *(*fct)(struct tracepoint *tp, void *priv),
+void
+for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
 			   void *priv);
+struct tracepoint *kernel_tracepoint_find_by_name(const char *name);
 #else
-static inline void *
-for_each_kernel_tracepoint(void *(*fct)(struct tracepoint *tp, void *priv),
-			   void *priv)
+static inline void
+for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
+			   void *priv) {}
+static inline struct tracepoint *
+kernel_tracepoint_find_by_name(const char *name)
 {
 	return NULL;
 }
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ae8b43f1cee3..644311777d8e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1334,15 +1334,6 @@ static const struct file_operations bpf_raw_tp_fops = {
 	.write		= bpf_dummy_write,
 };
 
-static void *__find_tp(struct tracepoint *tp, void *priv)
-{
-	char *name = priv;
-
-	if (!strcmp(tp->name, name))
-		return tp;
-	return NULL;
-}
-
 #define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.prog_fd
 
 static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
@@ -1358,7 +1349,7 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 		return -EFAULT;
 	tp_name[sizeof(tp_name) - 1] = 0;
 
-	tp = for_each_kernel_tracepoint(__find_tp, tp_name);
+	tp = kernel_tracepoint_find_by_name(tp_name);
 	if (!tp)
 		return -ENOENT;
 
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 3f2dc5738c2b..764d02fbe782 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -502,22 +502,17 @@ static __init int init_tracepoints(void)
 __initcall(init_tracepoints);
 #endif /* CONFIG_MODULES */
 
-static void *for_each_tracepoint_range(struct tracepoint * const *begin,
-				       struct tracepoint * const *end,
-				       void *(*fct)(struct tracepoint *tp, void *priv),
-				       void *priv)
+static void for_each_tracepoint_range(struct tracepoint * const *begin,
+				      struct tracepoint * const *end,
+				      void (*fct)(struct tracepoint *tp, void *priv),
+				      void *priv)
 {
 	struct tracepoint * const *iter;
-	void *ret;
 
 	if (!begin)
-		return NULL;
-	for (iter = begin; iter < end; iter++) {
-		ret = fct(*iter, priv);
-		if (ret)
-			return ret;
-	}
-	return NULL;
+		return;
+	for (iter = begin; iter < end; iter++)
+		fct(*iter, priv);
 }
 
 /**
@@ -525,14 +520,23 @@ static void *for_each_tracepoint_range(struct tracepoint * const *begin,
  * @fct: callback
  * @priv: private data
  */
-void *for_each_kernel_tracepoint(void *(*fct)(struct tracepoint *tp, void *priv),
-				 void *priv)
+void for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
+				void *priv)
 {
-	return for_each_tracepoint_range(__start___tracepoints_ptrs,
-					 __stop___tracepoints_ptrs, fct, priv);
+	for_each_tracepoint_range(__start___tracepoints_ptrs,
+				  __stop___tracepoints_ptrs, fct, priv);
 }
 EXPORT_SYMBOL_GPL(for_each_kernel_tracepoint);
 
+struct tracepoint *kernel_tracepoint_find_by_name(const char *name)
+{
+	struct tracepoint * const *tp = __start___tracepoints_ptrs;
+
+	for (; tp < __stop___tracepoints_ptrs; tp++)
+		if (!strcmp((*tp)->name, name))
+			return *tp;
+	return NULL;
+}
 #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
 
 /* NB: reg/unreg are called while guarded with the tracepoints_mutex */
-- 
2.9.5
