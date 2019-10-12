From: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/7 v2] tracing: Have trace events system open call tracing_open_generic_tr()
Date: Fri, 11 Oct 2019 20:57:51 -0400
Message-ID: <20191012005921.091872328@goodmis.org>
References: <20191012005747.210722465@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Garrett <matthewgarrett@google.com>, James Morris James Morris <jmorris@namei.org>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of having the trace events system open calls open code the taking of
the trace_array descriptor (with trace_array_get()) and then calling
trace_open_generic(), have it use the tracing_open_generic_tr() that does
the combination of the two. This requires making tracing_open_generic_tr()
global.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c        |  2 +-
 kernel/trace/trace.h        |  1 +
 kernel/trace/trace_events.c | 31 +++++--------------------------
 3 files changed, 7 insertions(+), 27 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fa7d813b04c6..94f1b9124939 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4156,7 +4156,7 @@ bool tracing_is_disabled(void)
  * Open and update trace_array ref count.
  * Must have the current trace_array passed to it.
  */
-static int tracing_open_generic_tr(struct inode *inode, struct file *filp)
+int tracing_open_generic_tr(struct inode *inode, struct file *filp)
 {
 	struct trace_array *tr = inode->i_private;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f801d154ff6a..854dbf4050f8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -681,6 +681,7 @@ void tracing_reset_online_cpus(struct trace_buffer *buf);
 void tracing_reset_current(int cpu);
 void tracing_reset_all_online_cpus(void);
 int tracing_open_generic(struct inode *inode, struct file *filp);
+int tracing_open_generic_tr(struct inode *inode, struct file *filp);
 bool tracing_is_disabled(void);
 bool tracer_tracing_is_on(struct trace_array *tr);
 void tracer_tracing_on(struct trace_array *tr);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index b89cdfe20bc1..0d29f2f13477 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1391,9 +1391,6 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	struct trace_array *tr;
 	int ret;
 
-	if (tracing_is_disabled())
-		return -ENODEV;
-
 	/* Make sure the system still exists */
 	mutex_lock(&event_mutex);
 	mutex_lock(&trace_types_lock);
@@ -1420,16 +1417,9 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	WARN_ON(!dir);
 
 	/* Still need to increment the ref count of the system */
-	if (trace_array_get(tr) < 0) {
-		put_system(dir);
-		return -ENODEV;
-	}
-
-	ret = tracing_open_generic(inode, filp);
-	if (ret < 0) {
-		trace_array_put(tr);
+	ret = tracing_open_generic_tr(inode, filp);
+	if (ret < 0)
 		put_system(dir);
-	}
 
 	return ret;
 }
@@ -1440,28 +1430,17 @@ static int system_tr_open(struct inode *inode, struct file *filp)
 	struct trace_array *tr = inode->i_private;
 	int ret;
 
-	if (tracing_is_disabled())
-		return -ENODEV;
-
-	if (trace_array_get(tr) < 0)
-		return -ENODEV;
-
 	/* Make a temporary dir that has no system but points to tr */
 	dir = kzalloc(sizeof(*dir), GFP_KERNEL);
-	if (!dir) {
-		trace_array_put(tr);
+	if (!dir)
 		return -ENOMEM;
-	}
 
-	dir->tr = tr;
-
-	ret = tracing_open_generic(inode, filp);
+	ret = tracing_open_generic_tr(inode, filp);
 	if (ret < 0) {
-		trace_array_put(tr);
 		kfree(dir);
 		return ret;
 	}
-
+	dir->tr = tr;
 	filp->private_data = dir;
 
 	return 0;
-- 
2.23.0
