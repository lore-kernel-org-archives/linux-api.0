From: Daniel Colascione <dancol@google.com>
Subject: [PATCH] Add /proc/pid_generation
Date: Wed, 21 Nov 2018 12:14:44 -0800
Message-ID: <20181121201452.77173-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: timmurray@google.com, primiano@google.com, joelaf@google.com, Daniel Colascione <dancol@google.com>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Prashant Dhamdhere <pdhamdhe@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Pavel Tatashin <pasha.tatashin@oracle.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matthew
List-Id: linux-api@vger.kernel.org

Trace analysis code needs a coherent picture of the set of processes
and threads running on a system. While it's possible to enumerate all
tasks via /proc, this enumeration is not atomic. If PID numbering
rolls over during snapshot collection, the resulting snapshot of the
process and thread state of the system may be incoherent, confusing
trace analysis tools. The fundamental problem is that if a PID is
reused during a userspace scan of /proc, it's impossible to tell, in
post-processing, whether a fact that the userspace /proc scanner
reports regarding a given PID refers to the old or new task named by
that PID, as the scan of that PID may or may not have occurred before
the PID reuse, and there's no way to "stamp" a fact read from the
kernel with a trace timestamp.

This change adds a per-pid-namespace 64-bit generation number,
incremented on PID rollover, and exposes it via a new proc file
/proc/pid_generation. By examining this file before and after /proc
enumeration, user code can detect the potential reuse of a PID and
restart the task enumeration process, repeating until it gets a
coherent snapshot.

PID rollover ought to be rare, so in practice, scan repetitions will
be rare.

Signed-off-by: Daniel Colascione <dancol@google.com>
---
 Documentation/filesystems/proc.txt |  1 +
 include/linux/pid.h                |  1 +
 include/linux/pid_namespace.h      |  2 ++
 init/main.c                        |  1 +
 kernel/pid.c                       | 36 +++++++++++++++++++++++++++++-
 5 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 12a5e6e693b6..f58a359f9a2c 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -615,6 +615,7 @@ Table 1-5: Kernel info in /proc
  partitions  Table of partitions known to the system           
  pci	     Deprecated info of PCI bus (new way -> /proc/bus/pci/,
              decoupled by lspci					(2.4)
+ pid_gen     PID rollover count
  rtc         Real time clock                                   
  scsi        SCSI info (see text)                              
  slabinfo    Slab pool info                                    
diff --git a/include/linux/pid.h b/include/linux/pid.h
index 14a9a39da9c7..2e4b41a32e86 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -112,6 +112,7 @@ extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
 int next_pidmap(struct pid_namespace *pid_ns, unsigned int last);
 
 extern struct pid *alloc_pid(struct pid_namespace *ns);
+extern u64 read_pid_generation(struct pid_namespace *ns);
 extern void free_pid(struct pid *pid);
 extern void disable_pid_allocation(struct pid_namespace *ns);
 
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 49538b172483..fa92ae66fb98 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -44,6 +44,7 @@ struct pid_namespace {
 	kgid_t pid_gid;
 	int hide_pid;
 	int reboot;	/* group exit code if this pidns was rebooted */
+	u64 generation;  /* incremented on wraparound */
 	struct ns_common ns;
 } __randomize_layout;
 
@@ -99,5 +100,6 @@ static inline int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
 extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
 void pidhash_init(void);
 void pid_idr_init(void);
+void pid_proc_init(void);
 
 #endif /* _LINUX_PID_NS_H */
diff --git a/init/main.c b/init/main.c
index ee147103ba1b..20c595e852c6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -730,6 +730,7 @@ asmlinkage __visible void __init start_kernel(void)
 	cgroup_init();
 	taskstats_init_early();
 	delayacct_init();
+	pid_proc_init();
 
 	check_bugs();
 
diff --git a/kernel/pid.c b/kernel/pid.c
index b2f6c506035d..cd5f4aa8eb55 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -174,6 +174,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 
 	for (i = ns->level; i >= 0; i--) {
 		int pid_min = 1;
+		unsigned int old_cursor;
 
 		idr_preload(GFP_KERNEL);
 		spin_lock_irq(&pidmap_lock);
@@ -182,7 +183,8 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 		 * init really needs pid 1, but after reaching the maximum
 		 * wrap back to RESERVED_PIDS
 		 */
-		if (idr_get_cursor(&tmp->idr) > RESERVED_PIDS)
+		old_cursor = idr_get_cursor(&tmp->idr);
+		if (old_cursor > RESERVED_PIDS)
 			pid_min = RESERVED_PIDS;
 
 		/*
@@ -191,6 +193,8 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 		 */
 		nr = idr_alloc_cyclic(&tmp->idr, NULL, pid_min,
 				      pid_max, GFP_ATOMIC);
+		if (unlikely(idr_get_cursor(&tmp->idr) <= old_cursor))
+			tmp->generation += 1;
 		spin_unlock_irq(&pidmap_lock);
 		idr_preload_end();
 
@@ -246,6 +250,16 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 	return ERR_PTR(retval);
 }
 
+u64 read_pid_generation(struct pid_namespace *ns)
+{
+	u64 generation;
+
+	spin_lock_irq(&pidmap_lock);
+	generation = ns->generation;
+	spin_unlock_irq(&pidmap_lock);
+	return generation;
+}
+
 void disable_pid_allocation(struct pid_namespace *ns)
 {
 	spin_lock_irq(&pidmap_lock);
@@ -449,6 +463,17 @@ struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
 	return idr_get_next(&ns->idr, &nr);
 }
 
+#ifdef CONFIG_PROC_FS
+static int pid_generation_show(struct seq_file *m, void *v)
+{
+	u64 generation =
+		read_pid_generation(proc_pid_ns(file_inode(m->file)));
+	seq_printf(m, "%llu\n", generation);
+	return 0;
+
+};
+#endif
+
 void __init pid_idr_init(void)
 {
 	/* Verify no one has done anything silly: */
@@ -465,4 +490,13 @@ void __init pid_idr_init(void)
 
 	init_pid_ns.pid_cachep = KMEM_CACHE(pid,
 			SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
+
+}
+
+void __init pid_proc_init(void)
+{
+	/* pid_idr_init is too early, so get a separate init function. */
+#ifdef CONFIG_PROC_FS
+	WARN_ON(!proc_create_single("pid_gen", 0, NULL, pid_generation_show));
+#endif
 }
-- 
2.19.1.1215.g8438c0b245-goog
