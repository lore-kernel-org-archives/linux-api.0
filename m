From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [v9][PATCH 9/9] Document clone3() syscall
Date: Sat, 24 Oct 2009 20:40:50 -0700
Message-ID: <20091025034050.GJ20327@us.ibm.com>
References: <20091025033508.GA20327@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091025033508.GA20327-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>
Cc: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, sukadev-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Subject: [v9][PATCH 9/9] Document clone3() syscall

This gives a brief overview of the clone3() system call.  We should
eventually describe more details in existing clone(2) man page or in
a new man page.

Changelog[v9]:
	- [Pavel Machek]: Fix an inconsistency and rename new file to
	  Documentation/clone3.
	- [Roland McGrath, H. Peter Anvin] Updates to description and
	  example to reflect new prototype of clone3() and the updated/
	  renamed 'struct clone_args'.

Changelog[v8]:
	- clone2() is already in use in IA64. Rename syscall to clone3()
	- Add notes to say that we return -EINVAL if invalid clone flags
	  are specified or if the reserved fields are not 0.
Changelog[v7]:
	- Rename clone_with_pids() to clone2()
	- Changes to reflect new prototype of clone2() (using clone_struct).

Signed-off-by: Sukadev Bhattiprolu <sukadev-8jLBTbqmX/OZamtmwQBW5tBPR1lH4CV8@public.gmane.org>
---
 Documentation/clone3 |  191 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 191 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/clone3

diff --git a/Documentation/clone3 b/Documentation/clone3
new file mode 100644
index 0000000..466fac2
--- /dev/null
+++ b/Documentation/clone3
@@ -0,0 +1,191 @@
+
+struct clone_args {
+	u64 clone_flags_high;
+	u64 child_stack_base;
+	u64 child_stack_size;
+	u64 parent_tid_ptr;
+	u64 child_tid_ptr;
+	u32 nr_pids;
+	u32 clone_args_size;
+	u64 reserved1;
+};
+
+
+clone3(u32 flags_low, struct clone_args * __user cargs, pid_t * __user pids)
+
+	In addition to doing everything that clone() system call does,
+	the clone3() system call:
+
+		- allows additional clone flags (31 of 32 bits in the flags
+		  parameter to clone() are in use)
+
+		- allows user to specify a pid for the child process in its
+		  active and ancestor pid name spaces.
+
+	This system call is meant to be used when restarting an application
+	from a checkpoint.  Such restart requires that the processes in the
+	application have the same pids they had when the application was
+	checkpointed. When containers are nested, the processes within the
+	containers exist in multiple pid namespaces and hence have multiple
+	pids to specify during restart.
+
+	The @flags_low parameter is identical to the 'clone_flags' parameter
+	in existing clone() system call.
+
+	The fields in 'struct clone_args' are meant to be used as follows:
+
+	u64 clone_flags_high:
+
+		When clone3() supports more than 32 clone flags, the higher
+		bits in the clone_flags should be specified in this field.
+		This field is currently unused and must be set to 0.
+
+	u64 child_stack_base;
+	u64 child_stack_size;
+
+		These two fields correspond to the 'child_stack' fields
+		in clone() and clone2() system calls (on IA64).
+
+	u64 parent_tid_ptr;
+	u64 child_tid_ptr;
+
+		These two fields correspond to the 'parent_tid_ptr' and
+		'child_tid_ptr' fields in the clone() system call
+
+	u32 nr_pids;
+
+		nr_pids specifies the number of pids in the @pids array
+		parameter to clone3() (see below). nr_pids should not exceed
+		the current nesting level of the calling process (i.e if the
+		process is in init_pid_ns, nr_pids must be 1, if process is
+		in a pid namespace that is a child of init-pid-ns, nr_pids
+		cannot exceed 2, and so on).
+
+	u32 clone_args_size;
+
+		clone_args_size specifes the sizeof(struct clone_args) and is
+		intended to enable extending this structure in the future,
+		while preserving backward compatibility.  For now, this field
+		must be set to the sizeof(struct clone_args) and this size must
+		match the kernel's view of the structure.
+
+	u64 reserved1;
+
+		reserved1 is intended to enable extending the functionality
+		of the clone3() system call in the future, while preserving
+		backward compatibility. It must currently be set to 0.
+
+
+	The @pids parameter defines the set of pids that should be assigned to
+	the child process in its active and ancestor pid name spaces. The
+	descendant pid namespaces do not matter since a process does not have a
+	pid in descendant namespaces, unless the process is in a new pid
+	namespace in which case the process is a container-init (and must have
+	the pid 1 in that namespace).
+
+	See CLONE_NEWPID section of clone(2) man page for details about pid
+	namespaces.
+
+	The order pids in @pids corresponds to the nesting order of pid-
+	namespaces, with @pids[0] corresponding to the init_pid_ns.
+
+	If a pid in the @pids list is 0, the kernel will assign the next
+	available pid in the pid namespace, for the process.
+
+	If a pid in the @pids list is non-zero, the kernel tries to assign
+	the specified pid in that namespace.  If that pid is already in use
+	by another process, the system call fails (see EBUSY below).
+
+	On success, the system call returns the pid of the child process in
+	the parent's active pid namespace.
+
+	On failure, clone3() returns -1 and sets 'errno' to one of following
+	values (the child process is not created).
+
+	EPERM	Caller does not have the SYS_ADMIN privilege needed to excute
+		this call.
+
+	EINVAL	The number of pids specified in 'clone_args.nr_pids' exceeds
+		the current nesting level of parent process
+
+	EINVAL	Not all specified clone-flags are valid.
+
+	EINVAL	The reserved fields in the clone_args argument are not 0.
+
+	EBUSY	A requested pid is in use by another process in that name space.
+
+---
+/* Example usage of clone3() on i386 */
+
+#include <stdio.h>
+#include <signal.h>
+#include <errno.h>
+
+#define __NR_clone3	337
+#define TEST_PID	399
+#define STACKSIZE	8192
+
+typedef unsigned long long u64;
+typedef unsigned int u32;
+typedef int pid_t;
+
+struct clone_args {
+	u64 clone_flags_high;
+	u64 child_stack_base;
+	u64 child_stack_size;
+	u64 parent_tid_ptr;
+	u64 child_tid_ptr;
+	u32 nr_pids;
+	u32 clone_args_size;
+	u64 reserved1;
+};
+
+int do_child(void *arg)
+{
+	printf("Child, pid %d, arg %s\n", getpid(), arg);
+
+	if (getpid() != TEST_PID)
+		printf("Expected pid %d, actual %d\n", TEST_PID, getpid());
+
+	_Exit(0);
+}
+
+main()
+{
+	int rc;
+	void **stack;
+	struct clone_args cargs;
+
+	u32 flags_low 	= SIGCHLD;
+	char *arg_str 	= "Args for child: abcdefg";
+	pid_t pids[] 	= { 377, TEST_PID };
+
+	stack = (void **)(malloc(STACKSIZE) + STACKSIZE - 1);
+
+	/* Set up stack for child */
+	*--stack = arg_str;
+	*--stack = NULL;
+	*--stack = do_child;
+
+	cargs.clone_flags_high = (u64)0;
+	cargs.child_stack_base = (u64)stack;
+	cargs.child_stack_size = (u64)0;
+
+	cargs.nr_pids = 2;              /* assumes we are in a child pid ns */
+	cargs.parent_tid_ptr = (u64)0;
+	cargs.child_tid_ptr = (u64)0;
+
+	cargs.clone_args_size = sizeof(cargs);
+	cargs.reserved1 = (u64)0;
+
+	rc = syscall(__NR_clone3, flags_low, &cargs, &pids);
+
+	if (rc != TEST_PID) {
+		printf("Parent: expected rc %d, actual %d, errno %d\n",
+				 TEST_PID, rc, errno);
+	} else {
+		printf("Parent: clone3() returns %d, errno %d\n", rc, errno);
+	}
+
+	waitpid(-1, NULL, 0);
+}
-- 
