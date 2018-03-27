From: Alexei Starovoitov <ast@fb.com>
Subject: [PATCH v6 bpf-next 07/11] tracepoint: introduce kernel_tracepoint_find_by_name
Date: Mon, 26 Mar 2018 19:47:02 -0700
Message-ID: <20180327024706.2064725-8-ast@fb.com>
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

introduce kernel_tracepoint_find_by_name() helper to let bpf core
find tracepoint by name and later attach bpf probe to a tracepoint

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/tracepoint.h | 6 ++++++
 kernel/tracepoint.c        | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index c92f4adbc0d7..a00b84473211 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -43,6 +43,12 @@ tracepoint_probe_unregister(struct tracepoint *tp, void *probe, void *data);
 extern void
 for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
 		void *priv);
+#ifdef CONFIG_TRACEPOINTS
+struct tracepoint *kernel_tracepoint_find_by_name(const char *name);
+#else
+static inline struct tracepoint *
+kernel_tracepoint_find_by_name(const char *name) { return NULL; }
+#endif
 
 #ifdef CONFIG_MODULES
 struct tp_module {
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 671b13457387..e2a9a0391ae2 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -528,6 +528,15 @@ void for_each_kernel_tracepoint(void (*fct)(struct tracepoint *tp, void *priv),
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
