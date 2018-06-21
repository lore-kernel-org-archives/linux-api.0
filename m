From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH v4 1/4] seccomp: add a return code to trap to userspace
Date: Thu, 21 Jun 2018 16:04:13 -0600
Message-ID: <20180621220416.5412-2-tycho@tycho.ws>
References: <20180621220416.5412-1-tycho@tycho.ws>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621220416.5412-1-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, "Tobin C . Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org

This patch introduces a means for syscalls matched in seccomp to notify
some other task that a particular filter has been triggered.

The motivation for this is primarily for use with containers. For example,
if a container does an init_module(), we obviously don't want to load this
untrusted code, which may be compiled for the wrong version of the kernel
anyway. Instead, we could parse the module image, figure out which module
the container is trying to load and load it on the host.

As another example, containers cannot mknod(), since this checks
capable(CAP_SYS_ADMIN). However, harmless devices like /dev/null or
/dev/zero should be ok for containers to mknod, but we'd like to avoid hard
coding some whitelist in the kernel. Another example is mount(), which has
many security restrictions for good reason, but configuration or runtime
knowledge could potentially be used to relax these restrictions.

This patch adds functionality that is already possible via at least two
other means that I know about, both of which involve ptrace(): first, one
could ptrace attach, and then iterate through syscalls via PTRACE_SYSCALL.
Unfortunately this is slow, so a faster version would be to install a
filter that does SECCOMP_RET_TRACE, which triggers a PTRACE_EVENT_SECCOMP.
Since ptrace allows only one tracer, if the container runtime is that
tracer, users inside the container (or outside) trying to debug it will not
be able to use ptrace, which is annoying. It also means that older
distributions based on Upstart cannot boot inside containers using ptrace,
since upstart itself uses ptrace to start services.

The actual implementation of this is fairly small, although getting the
synchronization right was/is slightly complex.

Finally, it's worth noting that the classic seccomp TOCTOU of reading
memory data from the task still applies here, but can be avoided with
careful design of the userspace handler: if the userspace handler reads all
of the task memory that is necessary before applying its security policy,
the tracee's subsequent memory edits will not be read by the tracer.

v2: * make id a u64; the idea here being that it will never overflow,
      because 64 is huge (one syscall every nanosecond => wrap every 584
      years) (Andy)
    * prevent nesting of user notifications: if someone is already attached
      the tree in one place, nobody else can attach to the tree (Andy)
    * notify the listener of signals the tracee receives as well (Andy)
    * implement poll
v3: * lockdep fix (Oleg)
    * drop unnecessary WARN()s (Christian)
    * rearrange error returns to be more rpetty (Christian)
    * fix build in !CONFIG_SECCOMP_USER_NOTIFICATION case
v4: * fix implementation of poll to use poll_wait() (Jann)
    * change listener's fd flags to be 0 (Jann)
    * hoist filter initialization out of ifdefs to its own function
      init_user_notification()
    * add some more testing around poll() and closing the listener while a
      syscall is in action
    * s/GET_LISTENER/NEW_LISTENER, since you can't _get_ a listener, but it
      creates a new one (Matthew)
    * correctly handle pid namespaces, add some testcases (Matthew)
    * use EINPROGRESS instead of EINVAL when a notification response is
      written twice (Matthew)
    * fix comment typo from older version (SEND vs READ) (Matthew)
    * whitespace and logic simplification (Tobin)
    * add some Documentation/ bits on userspace trapping

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
CC: Kees Cook <keescook@chromium.org>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Eric W. Biederman <ebiederm@xmission.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>
CC: Christian Brauner <christian.brauner@ubuntu.com>
CC: Tyler Hicks <tyhicks@canonical.com>
CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
---
 .../userspace-api/seccomp_filter.rst          |  68 +++
 arch/Kconfig                                  |   7 +
 include/linux/seccomp.h                       |   7 +-
 include/uapi/linux/seccomp.h                  |  20 +-
 kernel/seccomp.c                              | 410 +++++++++++++++++-
 tools/testing/selftests/seccomp/seccomp_bpf.c | 380 +++++++++++++++-
 6 files changed, 882 insertions(+), 10 deletions(-)

diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
index 82a468bc7560..e51422559dd6 100644
--- a/Documentation/userspace-api/seccomp_filter.rst
+++ b/Documentation/userspace-api/seccomp_filter.rst
@@ -122,6 +122,11 @@ In precedence order, they are:
 	Results in the lower 16-bits of the return value being passed
 	to userland as the errno without executing the system call.
 
+``SECCOMP_RET_USER_NOTIF``:
+    Results in a ``struct seccomp_notif`` message sent on the userspace
+    notification fd, if it is attached, or ``-ENOSYS`` if it is not. See below
+    on discussion of how to handle user notifications.
+
 ``SECCOMP_RET_TRACE``:
 	When returned, this value will cause the kernel to attempt to
 	notify a ``ptrace()``-based tracer prior to executing the system
@@ -183,6 +188,69 @@ The ``samples/seccomp/`` directory contains both an x86-specific example
 and a more generic example of a higher level macro interface for BPF
 program generation.
 
+Userspace Notification
+======================
+
+The ``SECCOMP_RET_USER_NOTIF`` return code lets seccomp filters pass a
+particular syscall to userspace to be handled. This may be useful for
+applications like container managers, which whish to intercept particular
+syscalls (``mount()``, ``finit_module()``, etc.) and change their behavior.
+
+There are currently two APIs to acquire a userspace notification fd for a
+particular filter. The first is when the filter is installed, the task
+installing the filter can ask the ``seccomp()`` syscall:
+
+.. code-block::
+
+    fd = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_NEW_LISTENER, &prog);
+
+which (on success) will return a listener fd for the filter, which can them be
+passed around via ``SCM_RIGHTS`` or similar. Alternativley, a filter fd can be
+acquired via:
+
+.. code-block::
+
+    fd = ptrace(PTRACE_SECCOMP_NEW_LISTENER, pid, 0);
+
+which grabs the 0th filter for some task which the tracer has privilege over.
+Note that filter fds correspond to a particular filter, and not a particular
+task. So if this task then forks, notifications from both tasks will appear on
+the same filter fd. Reads and writes to/from a filter fd are also synchronized,
+so a filter fd can safely have many readers.
+
+The interface for a seccomp notification fd consists of two structures:
+
+.. code-block::
+
+    struct seccomp_notif {
+        __u64 id;
+        pid_t pid;
+        struct seccomp_data data;
+    };
+
+    struct seccomp_notif_resp {
+        __u64 id;
+        __s32 error;
+        __s64 val;
+    };
+
+Users can ``read()`` or ``poll()`` on a seccomp notification fd to receive a
+``struct seccomp_notif``, which contains three members: a globally unique
+``id``, the ``pid`` of the task which triggered this request (which may be 0 if
+the task is in a pid ns not visible from the listener's pid namespace), and the
+``data`` passed to seccomp. Userspace can then make a decision based on this
+information about what to do, and ``write()`` a response, indicating what
+should be returned to userspace. The ``id`` member of ``struct
+seccomp_notif_resp`` should be the same ``id`` as in ``struct seccomp_notif``.
+
+It is worth noting that ``struct seccomp_data`` contains the values of register
+arguments to the syscall, but does not contain pointers to memory. The task's
+memory is accessiable to suitably privileged traces via via ``ptrace()`` or
+``/proc/pid/map_files/``. However, care should be taken to avoid the TOCTOU
+mentioned above in this document: all arguments being read from the tracee's
+memory should be read into the tracer's memory before any policy decisions are
+made. This allows for an atomic decision on syscall arguments.
+
 Sysctls
 =======
 
diff --git a/arch/Kconfig b/arch/Kconfig
index 1aa59063f1fd..2f0c97bf4bc8 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -414,6 +414,13 @@ config PLUGIN_HOSTCC
 	  Host compiler used to build GCC plugins.  This can be $(HOSTCXX),
 	  $(HOSTCC), or a null string if GCC plugin is unsupported.
 
+config SECCOMP_USER_NOTIFICATION
+	bool "Enable the SECCOMP_RET_USER_NOTIF seccomp action"
+	depends on SECCOMP_FILTER
+	help
+	  Enable SECCOMP_RET_USER_NOTIF, a return code which can be used by seccomp
+	  programs to notify a userspace listener that a particular event happened.
+
 config HAVE_GCC_PLUGINS
 	bool
 	help
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index e5320f6c8654..017444b5efed 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -4,9 +4,10 @@
 
 #include <uapi/linux/seccomp.h>
 
-#define SECCOMP_FILTER_FLAG_MASK	(SECCOMP_FILTER_FLAG_TSYNC	| \
-					 SECCOMP_FILTER_FLAG_LOG	| \
-					 SECCOMP_FILTER_FLAG_SPEC_ALLOW)
+#define SECCOMP_FILTER_FLAG_MASK	(SECCOMP_FILTER_FLAG_TSYNC | \
+					 SECCOMP_FILTER_FLAG_LOG | \
+					 SECCOMP_FILTER_FLAG_SPEC_ALLOW | \
+					 SECCOMP_FILTER_FLAG_NEW_LISTENER)
 
 #ifdef CONFIG_SECCOMP
 
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 9efc0e73d50b..8836a3b25500 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -17,9 +17,10 @@
 #define SECCOMP_GET_ACTION_AVAIL	2
 
 /* Valid flags for SECCOMP_SET_MODE_FILTER */
-#define SECCOMP_FILTER_FLAG_TSYNC	(1UL << 0)
-#define SECCOMP_FILTER_FLAG_LOG		(1UL << 1)
-#define SECCOMP_FILTER_FLAG_SPEC_ALLOW	(1UL << 2)
+#define SECCOMP_FILTER_FLAG_TSYNC		(1UL << 0)
+#define SECCOMP_FILTER_FLAG_LOG			(1UL << 1)
+#define SECCOMP_FILTER_FLAG_SPEC_ALLOW		(1UL << 2)
+#define SECCOMP_FILTER_FLAG_NEW_LISTENER	(1UL << 3)
 
 /*
  * All BPF programs must return a 32-bit value.
@@ -35,6 +36,7 @@
 #define SECCOMP_RET_KILL	 SECCOMP_RET_KILL_THREAD
 #define SECCOMP_RET_TRAP	 0x00030000U /* disallow and force a SIGSYS */
 #define SECCOMP_RET_ERRNO	 0x00050000U /* returns an errno */
+#define SECCOMP_RET_USER_NOTIF   0x7fc00000U /* notifies userspace */
 #define SECCOMP_RET_TRACE	 0x7ff00000U /* pass to a tracer or disallow */
 #define SECCOMP_RET_LOG		 0x7ffc0000U /* allow after logging */
 #define SECCOMP_RET_ALLOW	 0x7fff0000U /* allow */
@@ -60,4 +62,16 @@ struct seccomp_data {
 	__u64 args[6];
 };
 
+struct seccomp_notif {
+	__u64 id;
+	pid_t pid;
+	struct seccomp_data data;
+};
+
+struct seccomp_notif_resp {
+	__u64 id;
+	__s32 error;
+	__s64 val;
+};
+
 #endif /* _UAPI_LINUX_SECCOMP_H */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index fd023ac24e10..24949478a812 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -33,6 +33,7 @@
 #endif
 
 #ifdef CONFIG_SECCOMP_FILTER
+#include <linux/file.h>
 #include <linux/filter.h>
 #include <linux/pid.h>
 #include <linux/ptrace.h>
@@ -40,6 +41,50 @@
 #include <linux/tracehook.h>
 #include <linux/uaccess.h>
 
+#ifdef CONFIG_SECCOMP_USER_NOTIFICATION
+#include <linux/anon_inodes.h>
+
+enum notify_state {
+	SECCOMP_NOTIFY_INIT,
+	SECCOMP_NOTIFY_SENT,
+	SECCOMP_NOTIFY_REPLIED,
+};
+
+struct seccomp_knotif {
+	/* The struct pid of the task whose filter triggered the notification */
+	struct pid *pid;
+
+	/* The "cookie" for this request; this is unique for this filter. */
+	u32 id;
+
+	/*
+	 * The seccomp data. This pointer is valid the entire time this
+	 * notification is active, since it comes from __seccomp_filter which
+	 * eclipses the entire lifecycle here.
+	 */
+	const struct seccomp_data *data;
+
+	/*
+	 * Notification states. When SECCOMP_RET_USER_NOTIF is returned, a
+	 * struct seccomp_knotif is created and starts out in INIT. Once the
+	 * handler reads the notification off of an FD, it transitions to SENT.
+	 * If a signal is received the state transitions back to INIT and
+	 * another message is sent. When the userspace handler replies, state
+	 * transitions to REPLIED.
+	 */
+	enum notify_state state;
+
+	/* The return values, only valid when in SECCOMP_NOTIFY_REPLIED */
+	int error;
+	long val;
+
+	/* Signals when this has entered SECCOMP_NOTIFY_REPLIED */
+	struct completion ready;
+
+	struct list_head list;
+};
+#endif
+
 /**
  * struct seccomp_filter - container for seccomp BPF programs
  *
@@ -66,6 +111,30 @@ struct seccomp_filter {
 	bool log;
 	struct seccomp_filter *prev;
 	struct bpf_prog *prog;
+
+#ifdef CONFIG_SECCOMP_USER_NOTIFICATION
+	/*
+	 * A semaphore that users of this notification can wait on for
+	 * changes. Actual reads and writes are still controlled with
+	 * filter->notify_lock.
+	 */
+	struct semaphore request;
+
+	/* A lock for all notification-related accesses. */
+	struct mutex notify_lock;
+
+	/* Is there currently an attached listener? */
+	bool has_listener;
+
+	/* The id of the next request. */
+	u64 next_id;
+
+	/* A list of struct seccomp_knotif elements. */
+	struct list_head notifications;
+
+	/* A wait queue for poll. */
+	wait_queue_head_t wqh;
+#endif
 };
 
 /* Limit any path through the tree to 256KB worth of instructions. */
@@ -359,6 +428,19 @@ static inline void seccomp_sync_threads(unsigned long flags)
 	}
 }
 
+#ifdef CONFIG_SECCOMP_USER_NOTIFICATION
+static void init_user_notification(struct seccomp_filter *sfilter)
+{
+	mutex_init(&sfilter->notify_lock);
+	sema_init(&sfilter->request, 0);
+	INIT_LIST_HEAD(&sfilter->notifications);
+	sfilter->next_id = get_random_u64();
+	init_waitqueue_head(&sfilter->wqh);
+}
+#else
+static inline void init_user_notification(struct seccomp_filter *sfilter) { }
+#endif
+
 /**
  * seccomp_prepare_filter: Prepares a seccomp filter for use.
  * @fprog: BPF program to install
@@ -392,6 +474,8 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
 	if (!sfilter)
 		return ERR_PTR(-ENOMEM);
 
+	init_user_notification(sfilter);
+
 	ret = bpf_prog_create_from_user(&sfilter->prog, fprog,
 					seccomp_check_filter, save_orig);
 	if (ret < 0) {
@@ -556,13 +640,15 @@ static void seccomp_send_sigsys(int syscall, int reason)
 #define SECCOMP_LOG_TRACE		(1 << 4)
 #define SECCOMP_LOG_LOG			(1 << 5)
 #define SECCOMP_LOG_ALLOW		(1 << 6)
+#define SECCOMP_LOG_USER_NOTIF		(1 << 7)
 
 static u32 seccomp_actions_logged = SECCOMP_LOG_KILL_PROCESS |
 				    SECCOMP_LOG_KILL_THREAD  |
 				    SECCOMP_LOG_TRAP  |
 				    SECCOMP_LOG_ERRNO |
 				    SECCOMP_LOG_TRACE |
-				    SECCOMP_LOG_LOG;
+				    SECCOMP_LOG_LOG |
+				    SECCOMP_LOG_USER_NOTIF;
 
 static inline void seccomp_log(unsigned long syscall, long signr, u32 action,
 			       bool requested)
@@ -581,6 +667,9 @@ static inline void seccomp_log(unsigned long syscall, long signr, u32 action,
 	case SECCOMP_RET_TRACE:
 		log = requested && seccomp_actions_logged & SECCOMP_LOG_TRACE;
 		break;
+	case SECCOMP_RET_USER_NOTIF:
+		log = requested && seccomp_actions_logged & SECCOMP_LOG_USER_NOTIF;
+		break;
 	case SECCOMP_RET_LOG:
 		log = seccomp_actions_logged & SECCOMP_LOG_LOG;
 		break;
@@ -651,6 +740,82 @@ void secure_computing_strict(int this_syscall)
 }
 #else
 
+#ifdef CONFIG_SECCOMP_USER_NOTIFICATION
+static u64 seccomp_next_notify_id(struct seccomp_filter *filter)
+{
+	/* Note: overflow is ok here, the id just needs to be unique */
+	return filter->next_id++;
+}
+
+static void seccomp_do_user_notification(int this_syscall,
+					 struct seccomp_filter *match,
+					 const struct seccomp_data *sd)
+{
+	int err;
+	long ret = 0;
+	struct seccomp_knotif n = {};
+
+	mutex_lock(&match->notify_lock);
+	err = -ENOSYS;
+	if (!match->has_listener)
+		goto out;
+
+	n.pid = task_pid(current);
+	n.state = SECCOMP_NOTIFY_INIT;
+	n.data = sd;
+	n.id = seccomp_next_notify_id(match);
+	init_completion(&n.ready);
+
+	list_add(&n.list, &match->notifications);
+	wake_up_poll(&match->wqh, EPOLLIN | EPOLLRDNORM);
+
+	mutex_unlock(&match->notify_lock);
+	up(&match->request);
+
+	err = wait_for_completion_interruptible(&n.ready);
+	mutex_lock(&match->notify_lock);
+
+	/*
+	 * Here it's possible we got a signal and then had to wait on the mutex
+	 * while the reply was sent, so let's be sure there wasn't a response
+	 * in the meantime.
+	 */
+	if (err < 0 && n.state != SECCOMP_NOTIFY_REPLIED) {
+		/*
+		 * We got a signal. Let's tell userspace about it (potentially
+		 * again, if we had already notified them about the first one).
+		 */
+		if (n.state == SECCOMP_NOTIFY_SENT) {
+			n.state = SECCOMP_NOTIFY_INIT;
+			up(&match->request);
+		}
+		mutex_unlock(&match->notify_lock);
+		err = wait_for_completion_killable(&n.ready);
+		mutex_lock(&match->notify_lock);
+		if (err < 0)
+			goto remove_list;
+	}
+
+	ret = n.val;
+	err = n.error;
+
+remove_list:
+	list_del(&n.list);
+out:
+	mutex_unlock(&match->notify_lock);
+	syscall_set_return_value(current, task_pt_regs(current),
+				 err, ret);
+}
+#else
+static void seccomp_do_user_notification(int this_syscall,
+					 struct seccomp_filter *match,
+					 const struct seccomp_data *sd)
+{
+	seccomp_log(this_syscall, SIGSYS, SECCOMP_RET_USER_NOTIF, true);
+	do_exit(SIGSYS);
+}
+#endif
+
 #ifdef CONFIG_SECCOMP_FILTER
 static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 			    const bool recheck_after_trace)
@@ -728,6 +893,9 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 
 		return 0;
 
+	case SECCOMP_RET_USER_NOTIF:
+		seccomp_do_user_notification(this_syscall, match, sd);
+		goto skip;
 	case SECCOMP_RET_LOG:
 		seccomp_log(this_syscall, 0, action, true);
 		return 0;
@@ -834,6 +1002,9 @@ static long seccomp_set_mode_strict(void)
 }
 
 #ifdef CONFIG_SECCOMP_FILTER
+static struct file *init_listener(struct task_struct *,
+				  struct seccomp_filter *);
+
 /**
  * seccomp_set_mode_filter: internal function for setting seccomp filter
  * @flags:  flags to change filter behavior
@@ -853,6 +1024,8 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	const unsigned long seccomp_mode = SECCOMP_MODE_FILTER;
 	struct seccomp_filter *prepared = NULL;
 	long ret = -EINVAL;
+	int listener = 0;
+	struct file *listener_f = NULL;
 
 	/* Validate flags. */
 	if (flags & ~SECCOMP_FILTER_FLAG_MASK)
@@ -863,13 +1036,28 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	if (IS_ERR(prepared))
 		return PTR_ERR(prepared);
 
+	if (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) {
+		listener = get_unused_fd_flags(0);
+		if (listener < 0) {
+			ret = listener;
+			goto out_free;
+		}
+
+		listener_f = init_listener(current, prepared);
+		if (IS_ERR(listener_f)) {
+			put_unused_fd(listener);
+			ret = PTR_ERR(listener_f);
+			goto out_free;
+		}
+	}
+
 	/*
 	 * Make sure we cannot change seccomp or nnp state via TSYNC
 	 * while another thread is in the middle of calling exec.
 	 */
 	if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
 	    mutex_lock_killable(&current->signal->cred_guard_mutex))
-		goto out_free;
+		goto out_put_fd;
 
 	spin_lock_irq(&current->sighand->siglock);
 
@@ -887,6 +1075,16 @@ static long seccomp_set_mode_filter(unsigned int flags,
 	spin_unlock_irq(&current->sighand->siglock);
 	if (flags & SECCOMP_FILTER_FLAG_TSYNC)
 		mutex_unlock(&current->signal->cred_guard_mutex);
+out_put_fd:
+	if (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) {
+		if (ret < 0) {
+			fput(listener_f);
+			put_unused_fd(listener);
+		} else {
+			fd_install(listener, listener_f);
+			ret = listener;
+		}
+	}
 out_free:
 	seccomp_filter_free(prepared);
 	return ret;
@@ -915,6 +1113,9 @@ static long seccomp_get_action_avail(const char __user *uaction)
 	case SECCOMP_RET_LOG:
 	case SECCOMP_RET_ALLOW:
 		break;
+	case SECCOMP_RET_USER_NOTIF:
+		if (IS_ENABLED(CONFIG_SECCOMP_USER_NOTIFICATION))
+			break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1111,6 +1312,7 @@ long seccomp_get_metadata(struct task_struct *task,
 #define SECCOMP_RET_KILL_THREAD_NAME	"kill_thread"
 #define SECCOMP_RET_TRAP_NAME		"trap"
 #define SECCOMP_RET_ERRNO_NAME		"errno"
+#define SECCOMP_RET_USER_NOTIF_NAME	"user_notif"
 #define SECCOMP_RET_TRACE_NAME		"trace"
 #define SECCOMP_RET_LOG_NAME		"log"
 #define SECCOMP_RET_ALLOW_NAME		"allow"
@@ -1120,6 +1322,7 @@ static const char seccomp_actions_avail[] =
 				SECCOMP_RET_KILL_THREAD_NAME	" "
 				SECCOMP_RET_TRAP_NAME		" "
 				SECCOMP_RET_ERRNO_NAME		" "
+				SECCOMP_RET_USER_NOTIF_NAME     " "
 				SECCOMP_RET_TRACE_NAME		" "
 				SECCOMP_RET_LOG_NAME		" "
 				SECCOMP_RET_ALLOW_NAME;
@@ -1137,6 +1340,7 @@ static const struct seccomp_log_name seccomp_log_names[] = {
 	{ SECCOMP_LOG_TRACE, SECCOMP_RET_TRACE_NAME },
 	{ SECCOMP_LOG_LOG, SECCOMP_RET_LOG_NAME },
 	{ SECCOMP_LOG_ALLOW, SECCOMP_RET_ALLOW_NAME },
+	{ SECCOMP_LOG_USER_NOTIF, SECCOMP_RET_USER_NOTIF_NAME },
 	{ }
 };
 
@@ -1342,3 +1546,205 @@ static int __init seccomp_sysctl_init(void)
 device_initcall(seccomp_sysctl_init)
 
 #endif /* CONFIG_SYSCTL */
+
+#ifdef CONFIG_SECCOMP_USER_NOTIFICATION
+static int seccomp_notify_release(struct inode *inode, struct file *file)
+{
+	struct seccomp_filter *filter = file->private_data;
+	struct seccomp_knotif *knotif;
+
+	mutex_lock(&filter->notify_lock);
+
+	/*
+	 * If this file is being closed because e.g. the task who owned it
+	 * died, let's wake everyone up who was waiting on us.
+	 */
+	list_for_each_entry(knotif, &filter->notifications, list) {
+		if (knotif->state == SECCOMP_NOTIFY_REPLIED)
+			continue;
+
+		knotif->state = SECCOMP_NOTIFY_REPLIED;
+		knotif->error = -ENOSYS;
+		knotif->val = 0;
+
+		complete(&knotif->ready);
+	}
+
+	wake_up_all(&filter->wqh);
+	filter->has_listener = false;
+	mutex_unlock(&filter->notify_lock);
+	__put_seccomp_filter(filter);
+	return 0;
+}
+
+static ssize_t seccomp_notify_read(struct file *f, char __user *buf,
+				   size_t size, loff_t *ppos)
+{
+	struct seccomp_filter *filter = f->private_data;
+	struct seccomp_knotif *knotif = NULL, *cur;
+	struct seccomp_notif unotif = {};
+	ssize_t ret;
+
+	/* No offset reads. */
+	if (*ppos != 0)
+		return -EINVAL;
+
+	ret = down_interruptible(&filter->request);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&filter->notify_lock);
+	list_for_each_entry(cur, &filter->notifications, list) {
+		if (cur->state == SECCOMP_NOTIFY_INIT) {
+			knotif = cur;
+			break;
+		}
+	}
+
+	/*
+	 * If we didn't find a notification, it could be that the task was
+	 * interrupted between the time we were woken and when we were able to
+	 * acquire the rw lock. Should we retry here or just -ENOENT? -ENOENT
+	 * for now.
+	 */
+	if (!knotif) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	unotif.id = knotif->id;
+	unotif.pid = pid_vnr(knotif->pid);
+	unotif.data = *(knotif->data);
+
+	size = min_t(size_t, size, sizeof(unotif));
+	if (copy_to_user(buf, &unotif, size)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = sizeof(unotif);
+	knotif->state = SECCOMP_NOTIFY_SENT;
+	wake_up_poll(&filter->wqh, EPOLLOUT | EPOLLWRNORM);
+
+out:
+	mutex_unlock(&filter->notify_lock);
+	return ret;
+}
+
+static ssize_t seccomp_notify_write(struct file *file, const char __user *buf,
+				    size_t size, loff_t *ppos)
+{
+	struct seccomp_filter *filter = file->private_data;
+	struct seccomp_notif_resp resp = {};
+	struct seccomp_knotif *knotif = NULL;
+	ssize_t ret = -EINVAL;
+
+	/* No partial writes. */
+	if (*ppos != 0)
+		return -EINVAL;
+
+	size = min_t(size_t, size, sizeof(resp));
+	if (copy_from_user(&resp, buf, size))
+		return -EFAULT;
+
+	ret = mutex_lock_interruptible(&filter->notify_lock);
+	if (ret < 0)
+		return ret;
+
+	list_for_each_entry(knotif, &filter->notifications, list) {
+		if (knotif->id == resp.id)
+			break;
+	}
+
+	if (!knotif || knotif->id != resp.id) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Allow exactly one reply. */
+	if (knotif->state != SECCOMP_NOTIFY_SENT) {
+		ret = -EINPROGRESS;
+		goto out;
+	}
+
+	ret = size;
+	knotif->state = SECCOMP_NOTIFY_REPLIED;
+	knotif->error = resp.error;
+	knotif->val = resp.val;
+	complete(&knotif->ready);
+out:
+	mutex_unlock(&filter->notify_lock);
+	return ret;
+}
+
+static __poll_t seccomp_notify_poll(struct file *file,
+				    struct poll_table_struct *poll_tab)
+{
+	struct seccomp_filter *filter = file->private_data;
+	__poll_t ret = 0;
+	struct seccomp_knotif *cur;
+
+	poll_wait(file, &filter->wqh, poll_tab);
+
+	ret = mutex_lock_interruptible(&filter->notify_lock);
+	if (ret < 0)
+		return ret;
+
+	list_for_each_entry(cur, &filter->notifications, list) {
+		if (cur->state == SECCOMP_NOTIFY_INIT)
+			ret |= EPOLLIN | EPOLLRDNORM;
+		if (cur->state == SECCOMP_NOTIFY_SENT)
+			ret |= EPOLLOUT | EPOLLWRNORM;
+		if (ret & EPOLLIN && ret & EPOLLOUT)
+			break;
+	}
+
+	mutex_unlock(&filter->notify_lock);
+
+	return ret;
+}
+
+static const struct file_operations seccomp_notify_ops = {
+	.read = seccomp_notify_read,
+	.write = seccomp_notify_write,
+	.poll = seccomp_notify_poll,
+	.release = seccomp_notify_release,
+};
+
+static struct file *init_listener(struct task_struct *task,
+				  struct seccomp_filter *filter)
+{
+	struct file *ret = ERR_PTR(-EBUSY);
+	struct seccomp_filter *cur;
+	int filter_nesting = 0;
+
+	for (cur = task->seccomp.filter; cur; cur = cur->prev) {
+		mutex_lock_nested(&cur->notify_lock, filter_nesting);
+		filter_nesting++;
+		if (cur->has_listener)
+			goto out;
+	}
+
+	ret = anon_inode_getfile("seccomp notify", &seccomp_notify_ops,
+				 filter, O_RDWR);
+	if (IS_ERR(ret))
+		goto out;
+
+
+	/* The file has a reference to it now */
+	__get_seccomp_filter(filter);
+	filter->has_listener = true;
+
+out:
+	for (cur = task->seccomp.filter; cur; cur = cur->prev)
+		mutex_unlock(&cur->notify_lock);
+
+	return ret;
+}
+#else
+static struct file *init_listener(struct task_struct *task,
+				  struct seccomp_filter *filter)
+{
+	return ERR_PTR(-EINVAL);
+}
+#endif
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index e1473234968d..328f90fe6ee2 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -5,6 +5,7 @@
  * Test code for seccomp bpf.
  */
 
+#define _GNU_SOURCE
 #include <sys/types.h>
 
 /*
@@ -40,10 +41,11 @@
 #include <sys/fcntl.h>
 #include <sys/mman.h>
 #include <sys/times.h>
+#include <sys/socket.h>
 
-#define _GNU_SOURCE
 #include <unistd.h>
 #include <sys/syscall.h>
+#include <poll.h>
 
 #include "../kselftest_harness.h"
 
@@ -154,6 +156,24 @@ struct seccomp_metadata {
 };
 #endif
 
+#ifndef SECCOMP_FILTER_FLAG_NEW_LISTENER
+#define SECCOMP_FILTER_FLAG_NEW_LISTENER (1UL << 3)
+
+#define SECCOMP_RET_USER_NOTIF 0x7fc00000U
+
+struct seccomp_notif {
+	__u64 id;
+	pid_t pid;
+	struct seccomp_data data;
+};
+
+struct seccomp_notif_resp {
+	__u64 id;
+	__s32 error;
+	__s64 val;
+};
+#endif
+
 #ifndef seccomp
 int seccomp(unsigned int op, unsigned int flags, void *args)
 {
@@ -2077,7 +2097,8 @@ TEST(detect_seccomp_filter_flags)
 {
 	unsigned int flags[] = { SECCOMP_FILTER_FLAG_TSYNC,
 				 SECCOMP_FILTER_FLAG_LOG,
-				 SECCOMP_FILTER_FLAG_SPEC_ALLOW };
+				 SECCOMP_FILTER_FLAG_SPEC_ALLOW,
+				 SECCOMP_FILTER_FLAG_NEW_LISTENER };
 	unsigned int flag, all_flags;
 	int i;
 	long ret;
@@ -2933,6 +2954,361 @@ TEST(get_metadata)
 	ASSERT_EQ(0, kill(pid, SIGKILL));
 }
 
+static int user_trap_syscall(int nr, unsigned int flags)
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_LD+BPF_W+BPF_ABS,
+			offsetof(struct seccomp_data, nr)),
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, nr, 0, 1),
+		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_USER_NOTIF),
+		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
+	};
+
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+
+	return seccomp(SECCOMP_SET_MODE_FILTER, flags, &prog);
+}
+
+static int read_notif(int listener, struct seccomp_notif *req)
+{
+	int ret;
+
+	do {
+		errno = 0;
+		ret = read(listener, req, sizeof(*req));
+	} while (ret == -1 && errno == ENOENT);
+	return ret;
+}
+
+static void signal_handler(int signal)
+{
+}
+
+#define USER_NOTIF_MAGIC 116983961184613L
+TEST(get_user_notification_syscall)
+{
+	pid_t pid;
+	long ret;
+	int status, listener;
+	struct seccomp_notif req = {};
+	struct seccomp_notif_resp resp = {};
+	struct pollfd pollfd;
+
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)ARRAY_SIZE(filter),
+		.filter = filter,
+	};
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	/* Check that we get -ENOSYS with no listener attached */
+	if (pid == 0) {
+		if (user_trap_syscall(__NR_getpid, 0) < 0)
+			exit(1);
+		ret = syscall(__NR_getpid);
+		exit(ret >= 0 || errno != ENOSYS);
+	}
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+
+	/* Add some no-op filters so that we (don't) trigger lockdep. */
+	EXPECT_EQ(seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog), 0);
+	EXPECT_EQ(seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog), 0);
+	EXPECT_EQ(seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog), 0);
+	EXPECT_EQ(seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog), 0);
+
+	/* Check that the basic notification machinery works */
+	listener = user_trap_syscall(__NR_getpid,
+				     SECCOMP_FILTER_FLAG_NEW_LISTENER);
+	EXPECT_GE(listener, 0);
+
+	/* Installing a second listener in the chain should EBUSY */
+	EXPECT_EQ(user_trap_syscall(__NR_getpid,
+				    SECCOMP_FILTER_FLAG_NEW_LISTENER),
+		  -1);
+	EXPECT_EQ(errno, EBUSY);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		ret = syscall(__NR_getpid);
+		exit(ret != USER_NOTIF_MAGIC);
+	}
+
+	pollfd.fd = listener;
+	pollfd.events = POLLIN | POLLOUT;
+
+	EXPECT_GT(poll(&pollfd, 1, -1), 0);
+	EXPECT_EQ(pollfd.revents, POLLIN);
+
+	EXPECT_EQ(read(listener, &req, sizeof(req)), sizeof(req));
+
+	pollfd.fd = listener;
+	pollfd.events = POLLIN | POLLOUT;
+
+	EXPECT_GT(poll(&pollfd, 1, -1), 0);
+	EXPECT_EQ(pollfd.revents, POLLOUT);
+
+	EXPECT_EQ(req.data.nr,  __NR_getpid);
+
+	resp.id = req.id;
+	resp.error = 0;
+	resp.val = USER_NOTIF_MAGIC;
+
+	EXPECT_EQ(write(listener, &resp, sizeof(resp)), sizeof(resp));
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+
+	/*
+	 * Check that nothing bad happens when we kill the task in the middle
+	 * of a syscall.
+	 */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		ret = syscall(__NR_getpid);
+		exit(ret != USER_NOTIF_MAGIC);
+	}
+
+	ret = read(listener, &req, sizeof(req));
+	EXPECT_EQ(ret, sizeof(req));
+
+	EXPECT_EQ(kill(pid, SIGKILL), 0);
+	EXPECT_EQ(waitpid(pid, NULL, 0), pid);
+
+	resp.id = req.id;
+	ret = write(listener, &resp, sizeof(resp));
+	EXPECT_EQ(ret, -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	/*
+	 * Check that we get another notification about a signal in the middle
+	 * of a syscall.
+	 */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		if (signal(SIGUSR1, signal_handler) == SIG_ERR) {
+			perror("signal");
+			exit(1);
+		}
+		ret = syscall(__NR_getpid);
+		exit(ret != USER_NOTIF_MAGIC);
+	}
+
+	ret = read_notif(listener, &req);
+	EXPECT_EQ(ret, sizeof(req));
+	EXPECT_EQ(errno, 0);
+
+	EXPECT_EQ(kill(pid, SIGUSR1), 0);
+
+	ret = read_notif(listener, &req);
+	EXPECT_EQ(ret, sizeof(req));
+	EXPECT_EQ(errno, 0);
+
+	resp.id = req.id;
+	ret = write(listener, &resp, sizeof(resp));
+	EXPECT_EQ(ret, sizeof(resp));
+	EXPECT_EQ(errno, 0);
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+
+	/*
+	 * Check that we get an ENOSYS when the listener is closed.
+	 */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0) {
+		close(listener);
+		ret = syscall(__NR_getpid);
+		exit(ret != -1 && errno != ENOSYS);
+	}
+
+	close(listener);
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
+/*
+ * Check that a pid in a child namespace still shows up as valid in ours.
+ */
+TEST(user_notification_child_pid_ns)
+{
+	pid_t pid;
+	int status, listener;
+	int sk_pair[2];
+	char c;
+	struct seccomp_notif req = {};
+	struct seccomp_notif_resp resp = {};
+
+	ASSERT_EQ(socketpair(PF_LOCAL, SOCK_SEQPACKET, 0, sk_pair), 0);
+	ASSERT_EQ(unshare(CLONE_NEWPID), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		EXPECT_EQ(user_trap_syscall(__NR_getpid, 0), 0);
+
+		/* Signal we're ready and have installed the filter. */
+		EXPECT_EQ(write(sk_pair[1], "J", 1), 1);
+
+		EXPECT_EQ(read(sk_pair[1], &c, 1), 1);
+		EXPECT_EQ(c, 'H');
+
+		exit(syscall(__NR_getpid) != USER_NOTIF_MAGIC);
+	}
+
+	EXPECT_EQ(read(sk_pair[0], &c, 1), 1);
+	EXPECT_EQ(c, 'J');
+
+	EXPECT_EQ(ptrace(PTRACE_ATTACH, pid), 0);
+	EXPECT_EQ(waitpid(pid, NULL, 0), pid);
+	listener = ptrace(PTRACE_SECCOMP_NEW_LISTENER, pid, 0);
+	EXPECT_GE(listener, 0);
+	EXPECT_EQ(ptrace(PTRACE_DETACH, pid, NULL, 0), 0);
+
+	/* Now signal we are done and respond with magic */
+	EXPECT_EQ(write(sk_pair[0], "H", 1), 1);
+
+	EXPECT_EQ(read(listener, &req, sizeof(req)), sizeof(req));
+	EXPECT_EQ(req.pid, pid);
+
+	resp.id = req.id;
+	resp.error = 0;
+	resp.val = USER_NOTIF_MAGIC;
+
+	EXPECT_EQ(write(listener, &resp, sizeof(resp)), sizeof(resp));
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+	close(listener);
+}
+
+/*
+ * Check that a pid in a sibling (i.e. unrelated) namespace shows up as 0, i.e.
+ * invalid.
+ */
+TEST(user_notification_sibling_pid_ns)
+{
+	pid_t pid, pid2;
+	int status, listener;
+	int sk_pair[2];
+	char c;
+	struct seccomp_notif req = {};
+	struct seccomp_notif_resp resp = {};
+
+	ASSERT_EQ(socketpair(PF_LOCAL, SOCK_SEQPACKET, 0, sk_pair), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		int child_pair[2];
+		ASSERT_EQ(unshare(CLONE_NEWPID), 0);
+
+		ASSERT_EQ(socketpair(PF_LOCAL, SOCK_SEQPACKET, 0, child_pair), 0);
+
+		pid2 = fork();
+		ASSERT_GE(pid2, 0);
+
+		if (pid2 == 0) {
+			close(child_pair[0]);
+			EXPECT_EQ(user_trap_syscall(__NR_getpid, 0), 0);
+
+			/* Signal we're ready and have installed the filter. */
+			EXPECT_EQ(write(child_pair[1], "J", 1), 1);
+
+			EXPECT_EQ(read(child_pair[1], &c, 1), 1);
+			EXPECT_EQ(c, 'H');
+
+			exit(syscall(__NR_getpid) != USER_NOTIF_MAGIC);
+		}
+
+		/* check that child has installed the filter */
+		EXPECT_EQ(read(child_pair[0], &c, 1), 1);
+		EXPECT_EQ(c, 'J');
+
+		/* tell parent who child is */
+		EXPECT_EQ(write(sk_pair[1], &pid2, sizeof(pid2)), sizeof(pid2));
+
+		/* parent has installed listener, tell child to call syscall */
+		EXPECT_EQ(read(sk_pair[1], &c, 1), 1);
+		EXPECT_EQ(c, 'H');
+		EXPECT_EQ(write(child_pair[0], "H", 1), 1);
+
+		EXPECT_EQ(waitpid(pid2, &status, 0), pid2);
+		EXPECT_EQ(true, WIFEXITED(status));
+		EXPECT_EQ(0, WEXITSTATUS(status));
+		exit(WEXITSTATUS(status));
+	}
+
+	EXPECT_EQ(read(sk_pair[0], &pid2, sizeof(pid2)), sizeof(pid2));
+
+	EXPECT_EQ(ptrace(PTRACE_ATTACH, pid2), 0);
+	EXPECT_EQ(waitpid(pid2, NULL, 0), pid2);
+	listener = ptrace(PTRACE_SECCOMP_NEW_LISTENER, pid2, 0);
+	EXPECT_GE(listener, 0);
+	EXPECT_EQ(errno, 0);
+	EXPECT_EQ(ptrace(PTRACE_DETACH, pid2, NULL, 0), 0);
+
+	/* Create the sibling ns, and sibling in it. */
+	EXPECT_EQ(unshare(CLONE_NEWPID), 0);
+	EXPECT_EQ(errno, 0);
+
+	pid2 = fork();
+	EXPECT_GE(pid2, 0);
+
+	if (pid2 == 0) {
+		ASSERT_EQ(read(listener, &req, sizeof(req)), sizeof(req));
+		/*
+		 * The pid should be 0, i.e. the task is in some namespace that
+		 * we can't "see".
+		 */
+		ASSERT_EQ(req.pid, 0);
+
+		resp.id = req.id;
+		resp.error = 0;
+		resp.val = USER_NOTIF_MAGIC;
+
+		ASSERT_EQ(write(listener, &resp, sizeof(resp)), sizeof(resp));
+		exit(0);
+	}
+
+	close(listener);
+
+	/* Now signal we are done setting up sibling listener. */
+	EXPECT_EQ(write(sk_pair[0], "H", 1), 1);
+
+	EXPECT_EQ(waitpid(pid, &status, 0), pid);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+
+	EXPECT_EQ(waitpid(pid2, &status, 0), pid2);
+	EXPECT_EQ(true, WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
+
 /*
  * TODO:
  * - add microbenchmarks
-- 
2.17.1
