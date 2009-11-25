From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [v13][PATCH 10/12] Implement sys_eclone for s390
Date: Wed, 25 Nov 2009 11:00:17 -0800
Message-ID: <20091125190017.GK30858@us.ibm.com>
References: <20091125185543.GA30858@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934787AbZKYTAX@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091125185543.GA30858@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Dobriyan <adobriyan@gmail.com>, Pavel Emelyanov <xemul@openvz.org>, hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, haveblue@us.ibm.com, Matt Helsley <matthltc@us.ibm.com>, arnd@arndb.de, roland@redhat.com, mtk.manpages@googlemail.com, linux-api@vger.kernel.org, Containers <containers@lists.linux-foundation.org>
List-Id: linux-api@vger.kernel.org


From: Serge E. Hallyn <serue@us.ibm.com>
Subject: [v13][PATCH 10/12] Implement sys_eclone for s390

Implement the s390 hook for sys_eclone().

Changelog:
	Nov 24: Removed user-space code from commit log. See user-cr git tree.
	Nov 17: remove redundant flags_high check
	Nov 13: As suggested by Heiko, convert eclone to take its
		parameters via registers.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 arch/s390/include/asm/unistd.h    |    3 ++-
 arch/s390/kernel/compat_wrapper.S |    8 ++++++++
 arch/s390/kernel/process.c        |   37 +++++++++++++++++++++++++++++++++++++
 arch/s390/kernel/syscalls.S       |    1 +
 4 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/arch/s390/include/asm/unistd.h b/arch/s390/include/asm/unistd.h
index cb5232d..cbf6c7c 100644
--- a/arch/s390/include/asm/unistd.h
+++ b/arch/s390/include/asm/unistd.h
@@ -269,7 +269,8 @@
 #define	__NR_pwritev		329
 #define __NR_rt_tgsigqueueinfo	330
 #define __NR_perf_event_open	331
-#define NR_syscalls 332
+#define __NR_eclone		332
+#define NR_syscalls 333
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index cbd9901..816ae61 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1849,6 +1849,14 @@ sys_clone_wrapper:
 	llgtr	%r5,%r5			# int *
 	jg	sys_clone		# branch to system call
 
+	.globl	sys_eclone_wrapper
+sys_eclone_wrapper:
+	llgfr	%r2,%r2			# unsigned int
+	llgtr	%r3,%r3			# struct clone_args *
+	lgfr	%r4,%r4			# int
+	llgtr	%r5,%r5			# pid_t *
+	jg	sys_eclone		# branch to system call
+
 	.globl	sys32_execve_wrapper
 sys32_execve_wrapper:
 	llgtr	%r2,%r2			# char *
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 5417eb5..0a59317 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -241,6 +241,43 @@ SYSCALL_DEFINE4(clone, unsigned long, newsp, unsigned long, clone_flags,
 		       parent_tidptr, child_tidptr);
 }
 
+SYSCALL_DEFINE4(eclone, unsigned int, flags_low, struct clone_args __user *,
+		uca, int, args_size, pid_t __user *, pids)
+{
+	int rc;
+	struct pt_regs *regs = task_pt_regs(current);
+	struct clone_args kca;
+	int __user *parent_tid_ptr;
+	int __user *child_tid_ptr;
+	unsigned long flags;
+	unsigned long __user child_stack;
+	unsigned long stack_size;
+
+	rc = fetch_clone_args_from_user(uca, args_size, &kca);
+	if (rc)
+		return rc;
+
+	flags = flags_low;
+	parent_tid_ptr = (int __user *) kca.parent_tid_ptr;
+	child_tid_ptr =  (int __user *) kca.child_tid_ptr;
+
+	stack_size = (unsigned long) kca.child_stack_size;
+	if (stack_size)
+		return -EINVAL;
+
+	child_stack = (unsigned long) kca.child_stack;
+	if (!child_stack)
+		child_stack = regs->gprs[15];
+
+	/*
+	 * TODO: On 32-bit systems, clone_flags is passed in as 32-bit value
+	 * 	 to several functions. Need to convert clone_flags to 64-bit.
+	 */
+	return do_fork_with_pids(flags, child_stack, regs, stack_size,
+				parent_tid_ptr, child_tid_ptr, kca.nr_pids,
+				pids);
+}
+
 /*
  * This is trivial, and on the face of it looks like it
  * could equally well be done in user mode.
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index 30eca07..fb8708d 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -340,3 +340,4 @@ SYSCALL(sys_preadv,sys_preadv,compat_sys_preadv_wrapper)
 SYSCALL(sys_pwritev,sys_pwritev,compat_sys_pwritev_wrapper)
 SYSCALL(sys_rt_tgsigqueueinfo,sys_rt_tgsigqueueinfo,compat_sys_rt_tgsigqueueinfo_wrapper) /* 330 */
 SYSCALL(sys_perf_event_open,sys_perf_event_open,sys_perf_event_open_wrapper)
+SYSCALL(sys_eclone,sys_eclone,sys_eclone_wrapper)
-- 
1.6.0.4
