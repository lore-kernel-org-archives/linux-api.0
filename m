From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH v42] proc: add /proc/*/stack (was Re: linux-next: proc tree
	build failure)
Date: Mon, 10 Nov 2008 11:42:29 +0300
Message-ID: <20081110084229.GA8690@x200.localdomain>
References: <20081110162941.e9e9ef3a.sfr@canb.auug.org.au> <20081110055311.GA3138@x200.localdomain> <20081110073623.GA475@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081110073623.GA475@elte.hu>
Sender: linux-next-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 10, 2008 at 08:36:23AM +0100, Ingo Molnar wrote:
> 
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > On Mon, Nov 10, 2008 at 04:29:41PM +1100, Stephen Rothwell wrote:
> > > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> > > 
> > > fs/proc/base.c:2547: error: 'pid_stack' undeclared here (not in a function)
> > > 
> > > Caused by an interaction of commits
> > > 078e9901c02d4899db5b24f708b8dfbca8935891 ("stacktrace:
> > > add /proc/<pid>/stack to dump task's stack trace") and
> > > 35f0b5fd7fab907a1119eaa614d9b24e5e225755 ("stacktrace:
> > > convert /proc/<pid>/stack to seqfiles") from the tip-core tree with commit
> > > 5d8880e3e0fb96459c652ac5e1504b90c949b3b9 ("proc: remove '##' usage") from
> > > the proc tree.
> > > 
> > > The former added a new usage of INF (which the second converted to a
> > > ONE).  I added the following patch to the merge of the proc tree and can
> > > carry it.
> > 
> > Time to steal this /proc/*/stack from Ingo. :-)
> 
> Alexey, would you like to carry them for v2.6.29? They are in a 
> separate tree here, the pull coordinates are below.
> 
> Please preserve the sha1's (do not rebase/cherry-pick, etc.) so that i 
> can carry it too without causing confusion.

Sorry, I can't.

It's two commits, PROC_BLOCK_SIZE moving chunk is now unneeded, because
seqfiles are in use, grabbing tasklist_lock for protection from task
dissapearing is unneeded -- proc_single_show() pins task_struct, entry
is added only to tgid table.

So, here is final version:


commit 12bf5a00732a5f9512081291097d0e4a3224e8a3
Author: Ken Chen <kenchen@google.com>
Date:   Mon Nov 10 11:26:08 2008 +0300

    proc: add /proc/*/stack
    
    /proc/*/stack adds the ability to query a task's stack trace. It is more
    useful than /proc/*/wchan as it provides full stack trace instead of single
    depth. Example output:
    
    	$ cat /proc/self/stack
    	[<c010a271>] save_stack_trace_tsk+0x17/0x35
    	[<c01827b4>] proc_pid_stack+0x4a/0x76
    	[<c018312d>] proc_single_show+0x4a/0x5e
    	[<c016bdec>] seq_read+0xf3/0x29f
    	[<c015a004>] vfs_read+0x6d/0x91
    	[<c015a0c1>] sys_read+0x3b/0x60
    	[<c0102eda>] syscall_call+0x7/0xb
    	[<ffffffff>] 0xffffffff
    
    Signed-off-by: Ken Chen <kenchen@google.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index bcceb99..11f5b75 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -139,6 +139,7 @@ Table 1-1: Process specific entries in /proc
  statm		Process memory status information
  status		Process status in human readable form
  wchan		If CONFIG_KALLSYMS is set, a pre-decoded wchan
+ stack		Report full stack trace, enable via CONFIG_STACKTRACE
  smaps		Extension based on maps, the rss size for each mapped file
 ..............................................................................
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6e850e9..738ea78 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -65,6 +65,7 @@
 #include <linux/mm.h>
 #include <linux/rcupdate.h>
 #include <linux/kallsyms.h>
+#include <linux/stacktrace.h>
 #include <linux/resource.h>
 #include <linux/module.h>
 #include <linux/mount.h>
@@ -337,6 +338,37 @@ static int proc_pid_wchan(struct task_struct *task, char *buffer)
 }
 #endif /* CONFIG_KALLSYMS */
 
+#ifdef CONFIG_STACKTRACE
+
+#define MAX_STACK_TRACE_DEPTH	64
+
+static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
+			  struct pid *pid, struct task_struct *task)
+{
+	struct stack_trace trace;
+	unsigned long *entries;
+	int i;
+
+	entries = kmalloc(MAX_STACK_TRACE_DEPTH * sizeof(*entries), GFP_KERNEL);
+	if (!entries)
+		return -ENOMEM;
+
+	trace.nr_entries	= 0;
+	trace.max_entries	= MAX_STACK_TRACE_DEPTH;
+	trace.entries		= entries;
+	trace.skip		= 0;
+	save_stack_trace_tsk(task, &trace);
+
+	for (i = 0; i < trace.nr_entries; i++) {
+		seq_printf(m, "[<%p>] %pS\n",
+			   (void *)entries[i], (void *)entries[i]);
+	}
+	kfree(entries);
+
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_SCHEDSTATS
 /*
  * Provides /proc/PID/schedstat
@@ -2484,6 +2516,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_KALLSYMS
 	INF("wchan",      S_IRUGO, proc_pid_wchan),
 #endif
+#ifdef CONFIG_STACKTRACE
+	ONE("stack",      S_IRUSR, proc_pid_stack),
+#endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, proc_pid_schedstat),
 #endif
@@ -2819,6 +2854,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_KALLSYMS
 	INF("wchan",     S_IRUGO, proc_pid_wchan),
 #endif
+#ifdef CONFIG_STACKTRACE
+	ONE("stack",      S_IRUSR, proc_pid_stack),
+#endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat", S_IRUGO, proc_pid_schedstat),
 #endif
