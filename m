From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v7 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Wed, 28 Mar 2018 15:32:20 -0400
Message-ID: <20180328153220.06a132f4@gandalf.local.home>
References: <20180328021105.4061744-1-ast@fb.com>
        <20180328130407.7476cf17@gandalf.local.home>
        <fdcb0bf0-f896-ffb3-b9de-0b17f5f70fc6@fb.com>
        <20180328133830.3d5d74d3@gandalf.local.home>
        <80d7af37-10ef-28d7-f03f-27b4b5849cd1@fb.com>
        <20180328141045.1202afeb@gandalf.local.home>
        <a5c8ff7c-8185-a3fd-89eb-45ddc099c03b@fb.com>
        <20180328145431.687643bc@gandalf.local.home>
        <842190155.225.1522264944386.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <842190155.225.1522264944386.JavaMail.zimbra@efficios.com>
Sender: netdev-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alexei Starovoitov <ast@fb.com>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, 28 Mar 2018 15:22:24 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> > > cache hot/cold argument clearly doesn't apply.  
> 
> In the current situation I'm fine with adding this extra field
> to struct tracepoint. However, we should keep in mind to move
> all non-required cache-cold fields to a separate section at
> some point. Clearly just this single field won't make a difference
> due to other fields and padding.

funcs is the only part of the tracepoint structure that needs hot
cache. Thus, instead of trying to keep the tracepoint structure small
for cache reasons, pull funcs out of the tracepoint structure.

What about this patch?

Of course, this just adds another 8 bytes per tracepoint :-/ But it
keeps the functions away from the tracepoint structures. We could even
add a section for them to be together, but I'm not sure that will help
much more that just letting the linker place them, as these function
pointers of the same system will probably be grouped together.

-- Steve

diff --git a/include/linux/tracepoint-defs.h b/include/linux/tracepoint-defs.h
index 35db8dd48c4c..8d100163e9af 100644
--- a/include/linux/tracepoint-defs.h
+++ b/include/linux/tracepoint-defs.h
@@ -32,7 +32,7 @@ struct tracepoint {
 	struct static_key key;
 	int (*regfunc)(void);
 	void (*unregfunc)(void);
-	struct tracepoint_func __rcu *funcs;
+	struct tracepoint_func **funcs;
 	u32 num_args;
 };
 
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index c92f4adbc0d7..b55282202f71 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -129,7 +129,7 @@ extern void syscall_unregfunc(void);
  * as "(void *, void)". The DECLARE_TRACE_NOARGS() will pass in just
  * "void *data", where as the DECLARE_TRACE() will pass in "void *data, proto".
  */
-#define __DO_TRACE(tp, proto, args, cond, rcucheck)			\
+#define __DO_TRACE(name, proto, args, cond, rcucheck)			\
 	do {								\
 		struct tracepoint_func *it_func_ptr;			\
 		void *it_func;						\
@@ -140,7 +140,7 @@ extern void syscall_unregfunc(void);
 		if (rcucheck)						\
 			rcu_irq_enter_irqson();				\
 		rcu_read_lock_sched_notrace();				\
-		it_func_ptr = rcu_dereference_sched((tp)->funcs);	\
+		it_func_ptr = rcu_dereference_sched(__trace_##name##_funcs); \
 		if (it_func_ptr) {					\
 			do {						\
 				it_func = (it_func_ptr)->func;		\
@@ -158,7 +158,7 @@ extern void syscall_unregfunc(void);
 	static inline void trace_##name##_rcuidle(proto)		\
 	{								\
 		if (static_key_false(&__tracepoint_##name.key))		\
-			__DO_TRACE(&__tracepoint_##name,		\
+			__DO_TRACE(name,				\
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args),			\
 				TP_CONDITION(cond), 1);			\
@@ -181,10 +181,11 @@ extern void syscall_unregfunc(void);
  */
 #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
 	extern struct tracepoint __tracepoint_##name;			\
+	extern struct tracepoint_func __rcu *__trace_##name##_funcs;	\
 	static inline void trace_##name(proto)				\
 	{								\
 		if (static_key_false(&__tracepoint_##name.key))		\
-			__DO_TRACE(&__tracepoint_##name,		\
+			__DO_TRACE(name,				\
 				TP_PROTO(data_proto),			\
 				TP_ARGS(data_args),			\
 				TP_CONDITION(cond), 0);			\
@@ -233,9 +234,11 @@ extern void syscall_unregfunc(void);
 #define DEFINE_TRACE_FN(name, reg, unreg, num_args)			 \
 	static const char __tpstrtab_##name[]				 \
 	__attribute__((section("__tracepoints_strings"))) = #name;	 \
+	struct tracepoint_func __rcu *__trace_##name##_funcs;		 \
 	struct tracepoint __tracepoint_##name				 \
 	__attribute__((section("__tracepoints"))) =			 \
-		{ __tpstrtab_##name, STATIC_KEY_INIT_FALSE, reg, unreg, NULL, num_args };\
+		{ __tpstrtab_##name, STATIC_KEY_INIT_FALSE, reg, unreg,	 \
+		  &__trace_##name##_funcs, num_args };			 \
 	static struct tracepoint * const __tracepoint_ptr_##name __used	 \
 	__attribute__((section("__tracepoints_ptrs"))) =		 \
 		&__tracepoint_##name;
@@ -244,9 +247,12 @@ extern void syscall_unregfunc(void);
 	DEFINE_TRACE_FN(name, NULL, NULL, num_args);
 
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)				\
-	EXPORT_SYMBOL_GPL(__tracepoint_##name)
+	EXPORT_SYMBOL_GPL(__tracepoint_##name);				\
+	EXPORT_SYMBOL_GPL(__trace_##name##_funcs)
+
 #define EXPORT_TRACEPOINT_SYMBOL(name)					\
-	EXPORT_SYMBOL(__tracepoint_##name)
+	EXPORT_SYMBOL(__tracepoint_##name);				\
+	EXPORT_SYMBOL(__trace_##name##_funcs)
 
 #else /* !TRACEPOINTS_ENABLED */
 #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index a02bc09d765a..47b884809f22 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -809,6 +809,7 @@ static void free_synth_tracepoint(struct tracepoint *tp)
 	if (!tp)
 		return;
 
+	kfree(tp->funcs);
 	kfree(tp->name);
 	kfree(tp);
 }
@@ -827,6 +828,13 @@ static struct tracepoint *alloc_synth_tracepoint(char *name)
 		return ERR_PTR(-ENOMEM);
 	}
 
+	tp->funcs = kzalloc(sizeof(*tp->funcs), GFP_KERNEL);
+	if (!tp->funcs) {
+		kfree(tp->name);
+		kfree(tp);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	return tp;
 }
 
@@ -846,7 +854,7 @@ static inline void trace_synth(struct synth_event *event, u64 *var_ref_vals,
 		if (!(cpu_online(raw_smp_processor_id())))
 			return;
 
-		probe_func_ptr = rcu_dereference_sched((tp)->funcs);
+		probe_func_ptr = rcu_dereference_sched(*(tp)->funcs);
 		if (probe_func_ptr) {
 			do {
 				probe_func = probe_func_ptr->func;
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 671b13457387..638a35f77841 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -203,7 +203,7 @@ static int tracepoint_add_func(struct tracepoint *tp,
 			return ret;
 	}
 
-	tp_funcs = rcu_dereference_protected(tp->funcs,
+	tp_funcs = rcu_dereference_protected(*tp->funcs,
 			lockdep_is_held(&tracepoints_mutex));
 	old = func_add(&tp_funcs, func, prio);
 	if (IS_ERR(old)) {
@@ -217,7 +217,7 @@ static int tracepoint_add_func(struct tracepoint *tp,
 	 * a pointer to it.  This array is referenced by __DO_TRACE from
 	 * include/linux/tracepoint.h using rcu_dereference_sched().
 	 */
-	rcu_assign_pointer(tp->funcs, tp_funcs);
+	rcu_assign_pointer(*tp->funcs, tp_funcs);
 	if (!static_key_enabled(&tp->key))
 		static_key_slow_inc(&tp->key);
 	release_probes(old);
@@ -235,7 +235,7 @@ static int tracepoint_remove_func(struct tracepoint *tp,
 {
 	struct tracepoint_func *old, *tp_funcs;
 
-	tp_funcs = rcu_dereference_protected(tp->funcs,
+	tp_funcs = rcu_dereference_protected(*tp->funcs,
 			lockdep_is_held(&tracepoints_mutex));
 	old = func_remove(&tp_funcs, func);
 	if (IS_ERR(old)) {
@@ -251,7 +251,7 @@ static int tracepoint_remove_func(struct tracepoint *tp,
 		if (static_key_enabled(&tp->key))
 			static_key_slow_dec(&tp->key);
 	}
-	rcu_assign_pointer(tp->funcs, tp_funcs);
+	rcu_assign_pointer(*tp->funcs, tp_funcs);
 	release_probes(old);
 	return 0;
 }
@@ -398,7 +398,7 @@ static void tp_module_going_check_quiescent(struct tracepoint * const *begin,
 	if (!begin)
 		return;
 	for (iter = begin; iter < end; iter++)
-		WARN_ON_ONCE((*iter)->funcs);
+		WARN_ON_ONCE(*(*iter)->funcs);
 }
 
 static int tracepoint_module_coming(struct module *mod)
