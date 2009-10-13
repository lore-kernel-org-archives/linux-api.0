From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [RFC][v8][PATCH 3/10]: Make pid_max a pid_ns property
Date: Mon, 12 Oct 2009 21:50:41 -0700
Message-ID: <20091013045041.GC28435@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091013044925.GA28181-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/containers>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org



From: Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: [RFC][v8][PATCH 3/10]: Make pid_max a pid_ns property

Remove the pid_max global, and make it a property of the
pid_namespace.  When a pid_ns is created, it inherits
the parent's pid_ns.

Fixing up sysctl (trivial akin to ipc version, but
potentially tedious to get right for all CONFIG*
combinations) is left for later.

Changelog[v2]:
	- Port to newer kernel
	- Make pid_max a local variable in alloc_pidmap() to simplify code/patch

Signed-off-by: Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Sukadev Bhattiprolu <sukadev-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 include/linux/pid_namespace.h |    1 +
 kernel/pid.c                  |    4 ++--
 kernel/pid_namespace.c        |    1 +
 kernel/sysctl.c               |    4 ++--
 4 files changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/pid_namespace.h
===================================================================
--- linux-2.6.orig/include/linux/pid_namespace.h	2009-09-09 19:06:21.000000000 -0700
+++ linux-2.6/include/linux/pid_namespace.h	2009-09-09 19:07:20.000000000 -0700
@@ -30,6 +30,7 @@ struct pid_namespace {
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct bsd_acct_struct *bacct;
 #endif
+	int pid_max;
 };
 
 extern struct pid_namespace init_pid_ns;
Index: linux-2.6/kernel/pid.c
===================================================================
--- linux-2.6.orig/kernel/pid.c	2009-09-09 19:06:46.000000000 -0700
+++ linux-2.6/kernel/pid.c	2009-09-09 19:07:20.000000000 -0700
@@ -43,8 +43,6 @@ static struct hlist_head *pid_hash;
 static int pidhash_shift;
 struct pid init_struct_pid = INIT_STRUCT_PID;
 
-int pid_max = PID_MAX_DEFAULT;
-
 #define RESERVED_PIDS		300
 
 int pid_max_min = RESERVED_PIDS + 1;
@@ -78,6 +76,7 @@ struct pid_namespace init_pid_ns = {
 	.last_pid = 0,
 	.level = 0,
 	.child_reaper = &init_task,
+	.pid_max = PID_MAX_DEFAULT,
 };
 EXPORT_SYMBOL_GPL(init_pid_ns);
 
@@ -151,6 +150,7 @@ static int alloc_pidmap(struct pid_names
 {
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
 	int rc = -EAGAIN;
+	int pid_max = pid_ns->pid_max;
 	struct pidmap *map;
 
 	pid = last + 1;
Index: linux-2.6/kernel/pid_namespace.c
===================================================================
--- linux-2.6.orig/kernel/pid_namespace.c	2009-09-09 19:06:21.000000000 -0700
+++ linux-2.6/kernel/pid_namespace.c	2009-09-09 19:07:20.000000000 -0700
@@ -87,6 +87,7 @@ static struct pid_namespace *create_pid_
 
 	kref_init(&ns->kref);
 	ns->level = level;
+	ns->pid_max = parent_pid_ns->pid_max;
 	ns->parent = get_pid_ns(parent_pid_ns);
 
 	set_bit(0, ns->pidmap[0].page);
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c	2009-09-09 19:06:21.000000000 -0700
+++ linux-2.6/kernel/sysctl.c	2009-09-09 19:07:20.000000000 -0700
@@ -55,6 +55,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
+#include <linux/pid_namespace.h>
 
 #ifdef CONFIG_X86
 #include <asm/nmi.h>
@@ -78,7 +79,6 @@ extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
 extern char core_pattern[];
-extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
@@ -670,7 +670,7 @@ static struct ctl_table kern_table[] = {
 	{
 		.ctl_name	= KERN_PIDMAX,
 		.procname	= "pid_max",
-		.data		= &pid_max,
+		.data		= &init_pid_ns.pid_max,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
