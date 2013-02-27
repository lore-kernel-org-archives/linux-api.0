From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] ptrace: add ability to retrieve signals without removing from a queue (v3)
Date: Wed, 27 Feb 2013 18:37:08 +0400
Message-ID: <1361975829-1738-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pedro Alves <palves-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds a new ptrace request PTRACE_PEEKSIGINFO.

This request is used to retrieve information about pending signals
starting with the specified sequence number. Siginfo_t structures are
copied from the child into the buffer starting at "data".

The argument "addr" is a pointer to struct ptrace_peeksiginfo_args.
struct ptrace_peeksiginfo_args {
	u64 off;	/* from which siginfo to start */
	u32 flags;
	s32 nr;		/* how may siginfos to take */
};

"nr" has type "s32", because ptrace() returns "long", which has 32 bits
on i386 and a negative values is used for errors.

Currently here is only one flag PTRACE_PEEKSIGINFO_SHARED for dumping
signals from process-wide queue. If this flag is not set, signals are
read from a per-thread queue.

The request PTRACE_PEEKSIGINFO returns a number of dumped signals.  If a
signal with the specified sequence number doesn't exist, ptrace returns
zero.  The request returns an error, if no signal has been dumped.

Errors:
EINVAL - one or more specified flags are not supported or nr is negative
EFAULT - buf or addr is outside your accessible address space.

A result siginfo contains a kernel part of si_code which usually
striped, but it's required for queuing the same siginfo back during
restore of pending signals.

This functionality is required for checkpointing pending signals.
Pedro Alves suggested using it in "gdb" to peek at pending signals.
gdb already uses PTRACE_GETSIGINFO to get the siginfo for the signal
which was already dequeued. This functionality allows gdb to look at
the pending signals which were not reported yet.

The prototype of this code was developed by Oleg Nesterov.

v2: * don't wrapped on CONFIG_CHECKPOINT_RESTORE. This functionality is
      going to be used in gdb.
    * use ptrace_peeksiginfo_args, because addr is too small for
      encoding a signal number and flags.
v3: incorporate comments received from Andrew Morton

Cc: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Pedro Alves <palves-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 include/uapi/linux/ptrace.h | 12 +++++++
 kernel/ptrace.c             | 81 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index 022ab18..52ebcc8 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -5,6 +5,7 @@
 
 /* has the defines to get at the registers. */
 
+#include <linux/types.h>
 
 #define PTRACE_TRACEME		   0
 #define PTRACE_PEEKTEXT		   1
@@ -52,6 +53,17 @@
 #define PTRACE_INTERRUPT	0x4207
 #define PTRACE_LISTEN		0x4208
 
+#define PTRACE_PEEKSIGINFO	0x4209
+
+struct ptrace_peeksiginfo_args {
+	__u64 off;	/* from which siginfo to start */
+	__u32 flags;
+	__s32 nr;	/* how may siginfos to take */
+};
+
+/* Read signals from a shared (process wide) queue */
+#define PTRACE_PEEKSIGINFO_SHARED	(1 << 0)
+
 /* Wait extended result codes for the above trace options.  */
 #define PTRACE_EVENT_FORK	1
 #define PTRACE_EVENT_VFORK	2
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 6cbeaae..5ee48d7 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -24,6 +24,7 @@
 #include <linux/regset.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/cn_proc.h>
+#include <linux/compat.h>
 
 
 static int ptrace_trapping_sleep_fn(void *flags)
@@ -618,6 +619,82 @@ static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 	return error;
 }
 
+static int ptrace_peek_siginfo(struct task_struct *child,
+				unsigned long addr,
+				unsigned long data)
+{
+	struct ptrace_peeksiginfo_args arg;
+	struct sigpending *pending;
+	struct sigqueue *q;
+	int ret, i;
+
+	ret = copy_from_user(&arg, (void __user *) addr,
+				sizeof(struct ptrace_peeksiginfo_args));
+	if (ret)
+		return -EFAULT;
+
+	if (arg.flags & ~PTRACE_PEEKSIGINFO_SHARED)
+		return -EINVAL; /* unknown flags */
+
+	if (arg.nr < 0)
+		return -EINVAL;
+
+	if (arg.flags & PTRACE_PEEKSIGINFO_SHARED)
+		pending = &child->signal->shared_pending;
+	else
+		pending = &child->pending;
+
+	for (i = 0; i < arg.nr; i++) {
+		siginfo_t info;
+		s32 off = arg.off + i;
+
+		spin_lock_irq(&child->sighand->siglock);
+		list_for_each_entry(q, &pending->list, list) {
+			if (!off--) {
+				copy_siginfo(&info, &q->info);
+				break;
+			}
+		}
+		spin_unlock_irq(&child->sighand->siglock);
+
+		if (off >= 0) /* beyond the end of the list */
+			break;
+
+#ifdef CONFIG_COMPAT
+		if (unlikely(is_compat_task())) {
+			compat_siginfo_t __user *uinfo = compat_ptr(data);
+
+			ret = copy_siginfo_to_user32(uinfo, &info);
+			ret |= __put_user(info.si_code, &uinfo->si_code);
+		} else
+#endif
+		{
+			siginfo_t __user *uinfo = (siginfo_t __user *) data;
+
+			ret = copy_siginfo_to_user(uinfo, &info);
+			ret |= __put_user(info.si_code, &uinfo->si_code);
+		}
+
+		if (ret) {
+			ret = -EFAULT;
+			break;
+		}
+
+		data += sizeof(siginfo_t);
+
+		if (signal_pending(current)) {
+			i++; /* accounting the current siginfo */
+			break;
+		}
+
+		cond_resched();
+	}
+
+	if (i > 0)
+		return i;
+
+	return ret;
+}
 
 #ifdef PTRACE_SINGLESTEP
 #define is_singlestep(request)		((request) == PTRACE_SINGLESTEP)
@@ -742,6 +819,10 @@ int ptrace_request(struct task_struct *child, long request,
 		ret = put_user(child->ptrace_message, datalp);
 		break;
 
+	case PTRACE_PEEKSIGINFO:
+		ret = ptrace_peek_siginfo(child, addr, data);
+		break;
+
 	case PTRACE_GETSIGINFO:
 		ret = ptrace_getsiginfo(child, &siginfo);
 		if (!ret)
-- 
1.7.11.7
