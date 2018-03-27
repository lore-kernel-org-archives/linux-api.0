From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v6 bpf-next 08/11] bpf: introduce BPF_RAW_TRACEPOINT
Date: Tue, 27 Mar 2018 14:58:24 -0400
Message-ID: <20180327145824.602dfdec@gandalf.local.home>
References: <20180327024706.2064725-1-ast@fb.com>
        <20180327024706.2064725-9-ast@fb.com>
        <20180327130211.284c8924@gandalf.local.home>
        <20180327131143.4b83534c@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180327131143.4b83534c@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: davem@davemloft.net, daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Tue, 27 Mar 2018 13:11:43 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 27 Mar 2018 13:02:11 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Honestly, I think this is too much of a short cut and a hack. I know
> > you want to keep it "simple" and save space, but you really should do
> > it the same way ftrace and perf do it. That is, create a section and
> > have all tracepoints create a structure that holds a pointer to the
> > tracepoint and to the bpf probe function. Then you don't even need the
> > kernel_tracepoint_find_by_name(), you just iterate over your table and
> > you get the tracepoint and the bpf function associated to it.  
> 
> Also, if you do it the perf/ftrace way, you get support for module
> tracepoints pretty much for free. Which would include tracepoints in
> networking code that is loaded by a module.

This doesn't include module code (but that wouldn't be too hard to set
up), but I compiled and booted this. I didn't test if it works (I
didn't have the way to test bpf here). But this patch applies on top of
this patch (patch 8). You can remove patch 7 and fold this into this
patch. And then you can also make the __bpf_trace_* function static.

This would be much more robust and less error prone.

-- Steve

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 1ab0e520d6fc..4fab7392e237 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -178,6 +178,15 @@
 #define TRACE_SYSCALLS()
 #endif
 
+#ifdef CONFIG_BPF_EVENTS
+#define BPF_RAW_TP() . = ALIGN(8);		\
+			 VMLINUX_SYMBOL(__start__bpf_raw_tp) = .;	\
+			 KEEP(*(__bpf_raw_tp_map))			\
+			 VMLINUX_SYMBOL(__stop__bpf_raw_tp) = .;
+#else
+#define BPF_RAW_TP()
+#endif
+
 #ifdef CONFIG_SERIAL_EARLYCON
 #define EARLYCON_TABLE() STRUCT_ALIGN();			\
 			 VMLINUX_SYMBOL(__earlycon_table) = .;	\
@@ -576,6 +585,7 @@
 	*(.init.rodata)							\
 	FTRACE_EVENTS()							\
 	TRACE_SYSCALLS()						\
+	BPF_RAW_TP()							\
 	KPROBE_BLACKLIST()						\
 	ERROR_INJECT_WHITELIST()					\
 	MEM_DISCARD(init.rodata)					\
diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 399ebe6f90cf..fb4778c0a248 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -470,8 +470,9 @@ unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx);
 int perf_event_attach_bpf_prog(struct perf_event *event, struct bpf_prog *prog);
 void perf_event_detach_bpf_prog(struct perf_event *event);
 int perf_event_query_prog_array(struct perf_event *event, void __user *info);
-int bpf_probe_register(struct tracepoint *tp, struct bpf_prog *prog);
-int bpf_probe_unregister(struct tracepoint *tp, struct bpf_prog *prog);
+int bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_prog *prog);
+int bpf_probe_unregister(struct bpf_raw_event_map *btp, struct bpf_prog *prog);
+struct bpf_raw_event_map *bpf_find_raw_tracepoint(const char *name);
 #else
 static inline unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx)
 {
@@ -491,14 +492,18 @@ perf_event_query_prog_array(struct perf_event *event, void __user *info)
 {
 	return -EOPNOTSUPP;
 }
-static inline int bpf_probe_register(struct tracepoint *tp, struct bpf_prog *p)
+static inline int bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_prog *p)
 {
 	return -EOPNOTSUPP;
 }
-static inline int bpf_probe_unregister(struct tracepoint *tp, struct bpf_prog *p)
+static inline int bpf_probe_unregister(struct bpf_raw_event_map *btp, struct bpf_prog *p)
 {
 	return -EOPNOTSUPP;
 }
+static inline struct bpf_raw_event_map *bpf_find_raw_tracepoint(const char *name)
+{
+	return NULL;
+}
 #endif
 
 enum {
diff --git a/include/linux/tracepoint-defs.h b/include/linux/tracepoint-defs.h
index 39a283c61c51..35db8dd48c4c 100644
--- a/include/linux/tracepoint-defs.h
+++ b/include/linux/tracepoint-defs.h
@@ -36,4 +36,9 @@ struct tracepoint {
 	u32 num_args;
 };
 
+struct bpf_raw_event_map {
+	struct tracepoint	*tp;
+	void			*bpf_func;
+};
+
 #endif
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f100c63ff19e..6037a2f0108a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1312,7 +1312,7 @@ static int bpf_obj_get(const union bpf_attr *attr)
 }
 
 struct bpf_raw_tracepoint {
-	struct tracepoint *tp;
+	struct bpf_raw_event_map *btp;
 	struct bpf_prog *prog;
 };
 
@@ -1321,7 +1321,7 @@ static int bpf_raw_tracepoint_release(struct inode *inode, struct file *filp)
 	struct bpf_raw_tracepoint *raw_tp = filp->private_data;
 
 	if (raw_tp->prog) {
-		bpf_probe_unregister(raw_tp->tp, raw_tp->prog);
+		bpf_probe_unregister(raw_tp->btp, raw_tp->prog);
 		bpf_prog_put(raw_tp->prog);
 	}
 	kfree(raw_tp);
@@ -1339,7 +1339,7 @@ static const struct file_operations bpf_raw_tp_fops = {
 static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 {
 	struct bpf_raw_tracepoint *raw_tp;
-	struct tracepoint *tp;
+	struct bpf_raw_event_map *btp;
 	struct bpf_prog *prog;
 	char tp_name[128];
 	int tp_fd, err;
@@ -1349,14 +1349,14 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 		return -EFAULT;
 	tp_name[sizeof(tp_name) - 1] = 0;
 
-	tp = kernel_tracepoint_find_by_name(tp_name);
-	if (!tp)
+	btp = bpf_find_raw_tracepoint(tp_name);
+	if (!btp)
 		return -ENOENT;
 
 	raw_tp = kmalloc(sizeof(*raw_tp), GFP_USER | __GFP_ZERO);
 	if (!raw_tp)
 		return -ENOMEM;
-	raw_tp->tp = tp;
+	raw_tp->btp = btp;
 
 	prog = bpf_prog_get_type(attr->raw_tracepoint.prog_fd,
 				 BPF_PROG_TYPE_RAW_TRACEPOINT);
@@ -1365,7 +1365,7 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 		goto out_free_tp;
 	}
 
-	err = bpf_probe_register(raw_tp->tp, prog);
+	err = bpf_probe_register(raw_tp->btp, prog);
 	if (err)
 		goto out_put_prog;
 
@@ -1373,7 +1373,7 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 	tp_fd = anon_inode_getfd("bpf-raw-tracepoint", &bpf_raw_tp_fops, raw_tp,
 				 O_CLOEXEC);
 	if (tp_fd < 0) {
-		bpf_probe_unregister(raw_tp->tp, prog);
+		bpf_probe_unregister(raw_tp->btp, prog);
 		err = tp_fd;
 		goto out_put_prog;
 	}
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index eb58ef156d36..e578b173fe1d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -965,6 +965,19 @@ int perf_event_query_prog_array(struct perf_event *event, void __user *info)
 	return ret;
 }
 
+extern struct bpf_raw_event_map *__start__bpf_raw_tp[];
+extern struct bpf_raw_event_map *__stop__bpf_raw_tp[];
+
+struct bpf_raw_event_map *bpf_find_raw_tracepoint(const char *name)
+{
+	struct bpf_raw_event_map* const *btp = __start__bpf_raw_tp;
+
+	for (; btp < __stop__bpf_raw_tp; btp++)
+		if (!strcmp((*btp)->tp->name, name))
+			return *btp;
+	return NULL;
+}
+
 static __always_inline
 void __bpf_trace_run(struct bpf_prog *prog, u64 *args)
 {
@@ -1020,10 +1033,9 @@ BPF_TRACE_DEFN_x(10);
 BPF_TRACE_DEFN_x(11);
 BPF_TRACE_DEFN_x(12);
 
-static int __bpf_probe_register(struct tracepoint *tp, struct bpf_prog *prog)
+static int __bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_prog *prog)
 {
-	unsigned long addr;
-	char buf[128];
+	struct tracepoint *tp = btp->tp;
 
 	/*
 	 * check that program doesn't access arguments beyond what's
@@ -1032,43 +1044,25 @@ static int __bpf_probe_register(struct tracepoint *tp, struct bpf_prog *prog)
 	if (prog->aux->max_ctx_offset > tp->num_args * sizeof(u64))
 		return -EINVAL;
 
-	snprintf(buf, sizeof(buf), "__bpf_trace_%s", tp->name);
-	addr = kallsyms_lookup_name(buf);
-	if (!addr)
-		return -ENOENT;
-
-	return tracepoint_probe_register(tp, (void *)addr, prog);
+	return tracepoint_probe_register(tp, (void *)btp->bpf_func, prog);
 }
 
-int bpf_probe_register(struct tracepoint *tp, struct bpf_prog *prog)
+int bpf_probe_register(struct bpf_raw_event_map *btp, struct bpf_prog *prog)
 {
 	int err;
 
 	mutex_lock(&bpf_event_mutex);
-	err = __bpf_probe_register(tp, prog);
+	err = __bpf_probe_register(btp, prog);
 	mutex_unlock(&bpf_event_mutex);
 	return err;
 }
 
-static int __bpf_probe_unregister(struct tracepoint *tp, struct bpf_prog *prog)
-{
-	unsigned long addr;
-	char buf[128];
-
-	snprintf(buf, sizeof(buf), "__bpf_trace_%s", tp->name);
-	addr = kallsyms_lookup_name(buf);
-	if (!addr)
-		return -ENOENT;
-
-	return tracepoint_probe_unregister(tp, (void *)addr, prog);
-}
-
-int bpf_probe_unregister(struct tracepoint *tp, struct bpf_prog *prog)
+int bpf_probe_unregister(struct bpf_raw_event_map *btp, struct bpf_prog *prog)
 {
 	int err;
 
 	mutex_lock(&bpf_event_mutex);
-	err = __bpf_probe_unregister(tp, prog);
+	err = tracepoint_probe_unregister(btp->tp, (void *)btp->bpf_func, prog);
 	mutex_unlock(&bpf_event_mutex);
 	return err;
 }
