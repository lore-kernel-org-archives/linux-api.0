From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [v12][PATCH 8/9] Define eclone() syscall
Date: Tue, 10 Nov 2009 20:45:09 -0800
Message-ID: <20091111044509.GH11393@suka>
References: <20091111043440.GA9377@suka>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091111043440.GA9377@suka>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>
Cc: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, matthltc-npbjlsIvGkV82hYKe6nXyg@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Subject: [v12][PATCH 8/9] Define eclone() syscall

Container restart requires that a task have the same pid it had when it was
checkpointed. When containers are nested the tasks within the containers
exist in multiple pid namespaces and hence have multiple pids to specify
during restart.

eclone(), intended for use during restart, is the same as
clone(), except that it takes a 'pids' paramter. This parameter lets
caller choose specific pid numbers for the child process, in the
process's active and ancestor pid namespaces. (Descendant pid namespaces
in general don't matter since processes don't have pids in them anyway,
but see comments in copy_target_pids() regarding CLONE_NEWPID).

eclone() also attempts to address a second limitation of the
clone() system call. clone() is restricted to 32 clone flags and all but
one of these are in use. If more new clone flags are needed, we will be
forced to define a new variant of the clone() system call. To address
this, eclone() allows at least 64 clone flags with some room
for more if necessary.

To prevent unprivileged processes from misusing this interface,
eclone() currently needs CAP_SYS_ADMIN, when the 'pids' parameter
is non-NULL.

See Documentation/eclone in next patch for more details and an
example of its usage.

NOTE:
	- System calls are restricted to 6 parameters and the number and sizes
	  of parameters needed for eclone() exceed 6 integers. The new
	  prototype works around this restriction while providing some
	  flexibility if eclone() needs to be further extended in the
	  future.
TODO:
	- We should convert clone-flags to 64-bit value in all architectures.
	  Its probably best to do that as a separate patchset since clone_flags
	  touches several functions and that patchset seems independent of this
	  new system call.

Changelog[v12]:
	- [Serge Hallyn] Ignore ->child_stack_size if ->child_stack_base
	  is NULL.
	- [Oren Laadan, Serge Hallyn] Rename clone_with_pids() to eclone()
Changelog[v11]:
	- [Dave Hansen] Move clone_args validation checks to arch-indpeendent
	  code.
	- [Oren Laadan] Make args_size a parameter to system call and remove
	  it from 'struct clone_args'

Changelog[v10]:
	- Rename clone3() to clone_with_pids()
	- [Linus Torvalds] Use PTREGSCALL() rather than the generic syscall
	  implementation

Changelog[v9]:
	- [Roland McGrath, H. Peter Anvin] To avoid confusion on 64-bit
	  architectures split the new clone-flags into 'low' and 'high'
	  words and pass in the 'lower' flags as the first argument.
	  This would maintain similarity of the clone3() with clone()/
	  clone2(). Also has the side-effect of the name matching the
	  number of parameters :-)
	- [Roland McGrath] Rename structure to 'clone_args' and add a
	  'child_stack_size' field

Changelog[v8]
	- [Oren Laadan] parent_tid and child_tid fields in 'struct clone_arg'
	  must be 64-bit.
	- clone2() is in use in IA64. Rename system call to clone3().

Changelog[v7]:
	- [Peter Zijlstra, Arnd Bergmann] Rename system call to clone2()
	  and group parameters into a new 'struct clone_struct' object.

Changelog[v6]:
	- (Nathan Lynch, Arnd Bergmann, H. Peter Anvin, Linus Torvalds)
	  Change 'pid_set.pids' to a 'pid_t pids[]' so size of 'struct pid_set'
	  is constant across architectures.
	- (Nathan Lynch) Change pid_set.num_pids to unsigned and remove
	  'unum_pids < 0' check.

Changelog[v4]:
	- (Oren Laadan) rename 'struct target_pid_set' to 'struct pid_set'

Changelog[v3]:
	- (Oren Laadan) Allow CLONE_NEWPID flag (by allocating an extra pid
	  in the target_pids[] list and setting it 0. See copy_target_pids()).
	- (Oren Laadan) Specified target pids should apply only to youngest
	  pid-namespaces (see copy_target_pids())
	- (Matt Helsley) Update patch description.

Changelog[v2]:
	- Remove unnecessary printk and add a note to callers of
	  copy_target_pids() to free target_pids.
	- (Serge Hallyn) Mention CAP_SYS_ADMIN restriction in patch description.
	- (Oren Laadan) Add checks for 'num_pids < 0' (return -EINVAL) and
	  'num_pids == 0' (fall back to normal clone()).
	- Move arch-independent code (sanity checks and copy-in of target-pids)
	  into kernel/fork.c and simplify sys_clone_with_pids()

Changelog[v1]:
	- Fixed some compile errors (had fixed these errors earlier in my
	  git tree but had not refreshed patches before emailing them)

Signed-off-by: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Acked-by: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
---
 arch/x86/include/asm/syscalls.h    |    1 +
 arch/x86/include/asm/unistd_32.h   |    1 +
 arch/x86/kernel/entry_32.S         |    1 +
 arch/x86/kernel/process_32.c       |   47 ++++++++++++++
 arch/x86/kernel/syscall_table_32.S |    1 +
 include/linux/sched.h              |    2 +
 include/linux/types.h              |   11 +++
 kernel/fork.c                      |  124 +++++++++++++++++++++++++++++++++++-
 8 files changed, 187 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 372b76e..2cadb8e 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -40,6 +40,7 @@ long sys_iopl(struct pt_regs *);
 
 /* kernel/process_32.c */
 int sys_clone(struct pt_regs *);
+int sys_eclone(struct pt_regs *);
 int sys_execve(struct pt_regs *);
 
 /* kernel/signal.c */
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index 6fb3c20..030b121 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -342,6 +342,7 @@
 #define __NR_pwritev		334
 #define __NR_rt_tgsigqueueinfo	335
 #define __NR_perf_event_open	336
+#define __NR_eclone		337
 
 #ifdef __KERNEL__
 
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c097e7d..7e7f3c8 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -718,6 +718,7 @@ ptregs_##name: \
 PTREGSCALL(iopl)
 PTREGSCALL(fork)
 PTREGSCALL(clone)
+PTREGSCALL(eclone)
 PTREGSCALL(vfork)
 PTREGSCALL(execve)
 PTREGSCALL(sigaltstack)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4cf7956..be7c1a1 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -445,6 +445,53 @@ int sys_clone(struct pt_regs *regs)
 	return do_fork(clone_flags, newsp, regs, 0, parent_tidptr, child_tidptr);
 }
 
+int sys_eclone(struct pt_regs *regs)
+{
+	int rc;
+	int args_size;
+	struct clone_args kca;
+	unsigned long flags;
+	int __user *parent_tid_ptr;
+	int __user *child_tid_ptr;
+	unsigned long __user child_stack;
+	unsigned long stack_size;
+	unsigned int flags_low;
+	struct clone_args __user *uca;
+	pid_t __user *pids;
+
+	flags_low = regs->bx;
+	uca = (struct clone_args __user *)regs->cx;
+	args_size = regs->dx;
+	pids = (pid_t __user *)regs->di;
+
+	rc = fetch_clone_args_from_user(uca, args_size, &kca);
+	if (rc)
+		return rc;
+
+	/*
+	 * TODO: Convert 'clone-flags' to 64-bits on all architectures.
+	 * TODO: When ->clone_flags_high is non-zero, copy it in to the
+	 * 	 higher word(s) of 'flags':
+	 *
+	 * 		flags = (kca.clone_flags_high << 32) | flags_low;
+	 */
+	flags = flags_low;
+	parent_tid_ptr = (int *)kca.parent_tid_ptr;
+	child_tid_ptr = (int *)kca.child_tid_ptr;
+	stack_size = (unsigned long)kca.child_stack_size;
+
+	child_stack = 0UL;
+	if (kca.child_stack_base)
+		child_stack = (unsigned long)kca.child_stack_base + stack_size;
+
+	if (!child_stack)
+		child_stack = regs->sp;
+
+	return do_fork_with_pids(flags, child_stack, regs, stack_size,
+				parent_tid_ptr, child_tid_ptr, kca.nr_pids,
+				pids);
+}
+
 /*
  * sys_execve() executes a new program.
  */
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 0157cd2..2b6394c 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -336,3 +336,4 @@ ENTRY(sys_call_table)
 	.long sys_pwritev
 	.long sys_rt_tgsigqueueinfo	/* 335 */
 	.long sys_perf_event_open
+	.long ptregs_eclone
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 85e971a..b2a881d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2153,6 +2153,8 @@ extern int disallow_signal(int);
 
 extern int do_execve(char *, char __user * __user *, char __user * __user *, struct pt_regs *);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
+extern int fetch_clone_args_from_user(struct clone_args __user *, int,
+				struct clone_args *);
 extern long do_fork_with_pids(unsigned long, unsigned long, struct pt_regs *,
 				unsigned long, int __user *, int __user *,
 				unsigned int, pid_t __user *);
diff --git a/include/linux/types.h b/include/linux/types.h
index c42724f..0d08683 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -204,6 +204,17 @@ struct ustat {
 	char			f_fpack[6];
 };
 
+struct clone_args {
+	u64 clone_flags_high;
+	u64 child_stack_base;
+	u64 child_stack_size;
+	u64 parent_tid_ptr;
+	u64 child_tid_ptr;
+	u32 nr_pids;
+	u32 reserved0;
+	u64 reserved1;
+};
+
 #endif	/* __KERNEL__ */
 #endif /*  __ASSEMBLY__ */
 #endif /* _LINUX_TYPES_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 210e841..cacc26b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1372,6 +1372,114 @@ struct task_struct * __cpuinit fork_idle(int cpu)
 }
 
 /*
+ * If user specified any 'target-pids' in @upid_setp, copy them from
+ * user and return a pointer to a local copy of the list of pids. The
+ * caller must free the list, when they are done using it.
+ *
+ * If user did not specify any target pids, return NULL (caller should
+ * treat this like normal clone).
+ *
+ * On any errors, return the error code
+ */
+static pid_t *copy_target_pids(int unum_pids, pid_t __user *upids)
+{
+	int j;
+	int rc;
+	int size;
+	int knum_pids;		/* # of pids needed in kernel */
+	pid_t *target_pids;
+
+	if (!unum_pids)
+		return NULL;
+
+	knum_pids = task_pid(current)->level + 1;
+	if (unum_pids > knum_pids)
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * To keep alloc_pid() simple, allocate an extra pid_t in target_pids[]
+	 * and set it to 0. This last entry in target_pids[] corresponds to the
+	 * (yet-to-be-created) descendant pid-namespace if CLONE_NEWPID was
+	 * specified. If CLONE_NEWPID was not specified, this last entry will
+	 * simply be ignored.
+	 */
+	target_pids = kzalloc((knum_pids + 1) * sizeof(pid_t), GFP_KERNEL);
+	if (!target_pids)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * A process running in a level 2 pid namespace has three pid namespaces
+	 * and hence three pid numbers. If this process is checkpointed,
+	 * information about these three namespaces are saved. We refer to these
+	 * namespaces as 'known namespaces'.
+	 *
+	 * If this checkpointed process is however restarted in a level 3 pid
+	 * namespace, the restarted process has an extra ancestor pid namespace
+	 * (i.e 'unknown namespace') and 'knum_pids' exceeds 'unum_pids'.
+	 *
+	 * During restart, the process requests specific pids for its 'known
+	 * namespaces' and lets kernel assign pids to its 'unknown namespaces'.
+	 *
+	 * Since the requested-pids correspond to 'known namespaces' and since
+	 * 'known-namespaces' are younger than (i.e descendants of) 'unknown-
+	 * namespaces', copy requested pids to the back-end of target_pids[]
+	 * (i.e before the last entry for CLONE_NEWPID mentioned above).
+	 * Any entries in target_pids[] not corresponding to a requested pid
+	 * will be set to zero and kernel assigns a pid in those namespaces.
+	 *
+	 * NOTE: The order of pids in target_pids[] is oldest pid namespace to
+	 * 	 youngest (target_pids[0] corresponds to init_pid_ns). i.e.
+	 * 	 the order is:
+	 *
+	 * 		- pids for 'unknown-namespaces' (if any)
+	 * 		- pids for 'known-namespaces' (requested pids)
+	 * 		- 0 in the last entry (for CLONE_NEWPID).
+	 */
+	j = knum_pids - unum_pids;
+	size = unum_pids * sizeof(pid_t);
+
+	rc = copy_from_user(&target_pids[j], upids, size);
+	if (rc) {
+		rc = -EFAULT;
+		goto out_free;
+	}
+
+	return target_pids;
+
+out_free:
+	kfree(target_pids);
+	return ERR_PTR(rc);
+}
+
+int
+fetch_clone_args_from_user(struct clone_args __user *uca, int args_size,
+			struct clone_args *kca)
+{
+	int rc;
+
+	/*
+	 * TODO: If size of clone_args is not what the kernel expects, it
+	 * 	 could be that kernel is newer and has an extended structure.
+	 * 	 When that happens, this check needs to be smarter.  For now,
+	 * 	 assume exact match.
+	 */
+	if (args_size != sizeof(struct clone_args))
+		return -EINVAL;
+
+	rc = copy_from_user(kca, uca, args_size);
+	if (rc)
+		return -EFAULT;
+
+	/*
+	 * To avoid future compatibility issues, ensure unused fields are 0.
+	 */
+	if (kca->reserved0 || kca->reserved1 || kca->clone_flags_high)
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
  *  Ok, this is the main fork-routine.
  *
  * It copies the process, and if successful kick-starts
@@ -1389,7 +1497,7 @@ long do_fork_with_pids(unsigned long clone_flags,
 	struct task_struct *p;
 	int trace = 0;
 	long nr;
-	pid_t *target_pids = NULL;
+	pid_t *target_pids;
 
 	/*
 	 * Do some preliminary argument and permissions checking before we
@@ -1423,6 +1531,16 @@ long do_fork_with_pids(unsigned long clone_flags,
 		}
 	}
 
+	target_pids = copy_target_pids(num_pids, upids);
+	if (target_pids) {
+		if (IS_ERR(target_pids))
+			return PTR_ERR(target_pids);
+
+		nr = -EPERM;
+		if (!capable(CAP_SYS_ADMIN))
+			goto out_free;
+	}
+
 	/*
 	 * When called from kernel_thread, don't do user tracing stuff.
 	 */
@@ -1484,6 +1602,10 @@ long do_fork_with_pids(unsigned long clone_flags,
 	} else {
 		nr = PTR_ERR(p);
 	}
+
+out_free:
+	kfree(target_pids);
+
 	return nr;
 }
 
-- 
1.6.0.4
