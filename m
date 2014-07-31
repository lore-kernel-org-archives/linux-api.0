From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 4/5] ftrace: Require designated initialization of structures
Date: Thu, 31 Jul 2014 16:47:59 -0700
Message-ID: <bf79fbd5a2a1b24a4df6a4ee14c8b81be6b0b2ff.1406850006.git.josh@joshtriplett.org>
References: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christopher Li <sparse@chrisli.org>, Ingo Molnar <mingo@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Michal Marek <mmarek@suse.cz>, Neil Brown <neilb@suse.de>, Steven Rostedt <rostedt@goodmis.org>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-sparse@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Mark various ftrace structures with __designated_init.  Fix some ftrace
macros to use designated initializers for those structures.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/ftrace.h       | 4 ++--
 include/linux/ftrace_event.h | 4 ++--
 include/linux/syscalls.h     | 8 ++------
 include/trace/ftrace.h       | 8 ++------
 kernel/trace/trace_export.c  | 4 +---
 5 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 404a686..cb2d023 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -260,7 +260,7 @@ struct ftrace_func_command {
 	int			(*func)(struct ftrace_hash *hash,
 					char *func, char *cmd,
 					char *params, int enable);
-};
+} __designated_init;
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
@@ -283,7 +283,7 @@ struct ftrace_probe_ops {
 					 unsigned long ip,
 					 struct ftrace_probe_ops *ops,
 					 void *data);
-};
+} __designated_init;
 
 extern int
 register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index cff3106..25af313 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -198,7 +198,7 @@ struct ftrace_event_class {
 	struct list_head	*(*get_fields)(struct ftrace_event_call *);
 	struct list_head	fields;
 	int			(*raw_init)(struct ftrace_event_call *);
-};
+} __designated_init;
 
 extern int ftrace_event_reg(struct ftrace_event_call *event,
 			    enum trace_reg type, void *data);
@@ -293,7 +293,7 @@ struct ftrace_event_call {
 	int	(*perf_perm)(struct ftrace_event_call *,
 			     struct perf_event *);
 #endif
-};
+} __designated_init;
 
 static inline const char *
 ftrace_event_name(struct ftrace_event_call *call)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b0881a0..3002648 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -120,9 +120,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static struct ftrace_event_call __used				\
 	  event_enter_##sname = {					\
 		.class			= &event_class_syscall_enter,	\
-		{							\
-			.name                   = "sys_enter"#sname,	\
-		},							\
+		.name                   = "sys_enter"#sname,		\
 		.event.funcs            = &enter_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
 		.flags                  = TRACE_EVENT_FL_CAP_ANY,	\
@@ -136,9 +134,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static struct ftrace_event_call __used				\
 	  event_exit_##sname = {					\
 		.class			= &event_class_syscall_exit,	\
-		{							\
-			.name                   = "sys_exit"#sname,	\
-		},							\
+		.name                   = "sys_exit"#sname,		\
 		.event.funcs		= &exit_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
 		.flags                  = TRACE_EVENT_FL_CAP_ANY,	\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 26b4f2e..095aaca 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -699,9 +699,7 @@ static struct ftrace_event_class __used __refdata event_class_##call = { \
 									\
 static struct ftrace_event_call __used event_##call = {			\
 	.class			= &event_class_##template,		\
-	{								\
-		.tp			= &__tracepoint_##call,		\
-	},								\
+	.tp			= &__tracepoint_##call,			\
 	.event.funcs		= &ftrace_event_type_funcs_##template,	\
 	.print_fmt		= print_fmt_##template,			\
 	.flags			= TRACE_EVENT_FL_TRACEPOINT,		\
@@ -716,9 +714,7 @@ static const char print_fmt_##call[] = print;				\
 									\
 static struct ftrace_event_call __used event_##call = {			\
 	.class			= &event_class_##template,		\
-	{								\
-		.tp			= &__tracepoint_##call,		\
-	},								\
+	.tp			= &__tracepoint_##call,			\
 	.event.funcs		= &ftrace_event_type_funcs_##call,	\
 	.print_fmt		= print_fmt_##call,			\
 	.flags			= TRACE_EVENT_FL_TRACEPOINT,		\
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index d4ddde2..40f472f 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -174,9 +174,7 @@ struct ftrace_event_class __refdata event_class_ftrace_##call = {	\
 									\
 struct ftrace_event_call __used event_##call = {			\
 	.class			= &event_class_ftrace_##call,		\
-	{								\
-		.name			= #call,			\
-	},								\
+	.name			= #call,				\
 	.event.type		= etype,				\
 	.print_fmt		= print,				\
 	.flags			= TRACE_EVENT_FL_IGNORE_ENABLE | TRACE_EVENT_FL_USE_CALL_FILTER, \
-- 
2.0.1
