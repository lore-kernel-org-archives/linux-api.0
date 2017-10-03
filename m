From: Steve Grubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v7 1/1] audit: Record fanotify access control decisions
Date: Mon, 02 Oct 2017 20:21:39 -0400
Message-ID: <8238140.shJAMdJRPA@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Audit <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

The fanotify interface allows user space daemons to make access
control decisions. Under common criteria requirements, we need to
optionally record decisions based on policy. This patch adds a bit mask,
FAN_AUDIT, that a user space daemon can 'or' into the response decision
which will tell the kernel that it made a decision and record it.

It would be used something like this in user space code:

  response.response = FAN_DENY | FAN_AUDIT;
  write(fd, &response, sizeof(struct fanotify_response));

When the syscall ends, the audit system will record the decision as a
AUDIT_FANOTIFY auxiliary record to denote that the reason this event
occurred is the result of an access control decision from fanotify
rather than DAC or MAC policy.

A sample event looks like this:

type=PATH msg=audit(1504310584.332:290): item=0 name="./evil-ls"
inode=1319561 dev=fc:03 mode=0100755 ouid=1000 ogid=1000 rdev=00:00
obj=unconfined_u:object_r:user_home_t:s0 nametype=NORMAL
type=CWD msg=audit(1504310584.332:290): cwd="/home/sgrubb"
type=SYSCALL msg=audit(1504310584.332:290): arch=c000003e syscall=2
success=no exit=-1 a0=32cb3fca90 a1=0 a2=43 a3=8 items=1 ppid=901
pid=959 auid=1000 uid=1000 gid=1000 euid=1000 suid=1000
fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=pts1 ses=3 comm="bash"
exe="/usr/bin/bash" subj=unconfined_u:unconfined_r:unconfined_t:
s0-s0:c0.c1023 key=(null)
type=FANOTIFY msg=audit(1504310584.332:290): resp=2

Prior to using the audit flag, the developer needs to call
fanotify_init or'ing in FAN_ENABLE_AUDIT to ensure that the kernel
supports auditing. The calling process must also have the CAP_AUDIT_WRITE
capability.

* v5 remove ifdef around code block and == 0 from boolean check

* v6 update adds empty inline audit_fanotify function for when
CONFIG_AUDITSYSCALL is not defined.

* v7 rename audit_enabled variable to "audit" to avoid symbol collision

Signed-off-by: sgrubb <sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/notify/fanotify/fanotify.c      |  8 +++++++-
 fs/notify/fanotify/fanotify_user.c | 16 +++++++++++++++-
 fs/notify/fdinfo.c                 |  3 +++
 include/linux/audit.h              | 10 ++++++++++
 include/linux/fsnotify_backend.h   |  1 +
 include/uapi/linux/audit.h         |  1 +
 include/uapi/linux/fanotify.h      |  3 +++
 kernel/auditsc.c                   |  6 ++++++
 8 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 2fa99ae..1968d21 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -9,6 +9,7 @@
 #include <linux/sched/user.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/audit.h>
 
 #include "fanotify.h"
 
@@ -78,7 +79,7 @@ static int fanotify_get_response(struct fsnotify_group *group,
 	fsnotify_finish_user_wait(iter_info);
 out:
 	/* userspace responded, convert to something usable */
-	switch (event->response) {
+	switch (event->response & ~FAN_AUDIT) {
 	case FAN_ALLOW:
 		ret = 0;
 		break;
@@ -86,6 +87,11 @@ static int fanotify_get_response(struct fsnotify_group *group,
 	default:
 		ret = -EPERM;
 	}
+
+	/* Check if the response should be audited */
+	if (event->response & FAN_AUDIT)
+		audit_fanotify(event->response & ~FAN_AUDIT);
+
 	event->response = 0;
 
 	pr_debug("%s: group=%p event=%p about to return ret=%d\n", __func__,
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 907a481..ea3c458 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -179,7 +179,7 @@ static int process_access_response(struct fsnotify_group *group,
 	 * userspace can send a valid response or we will clean it up after the
 	 * timeout
 	 */
-	switch (response) {
+	switch (response & ~FAN_AUDIT) {
 	case FAN_ALLOW:
 	case FAN_DENY:
 		break;
@@ -190,6 +190,9 @@ static int process_access_response(struct fsnotify_group *group,
 	if (fd < 0)
 		return -EINVAL;
 
+	if ((response & FAN_AUDIT) && !group->fanotify_data.audit)
+		return -EINVAL;
+
 	event = dequeue_event(group, fd);
 	if (!event)
 		return -ENOENT;
@@ -721,7 +724,11 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+#ifdef CONFIG_AUDITSYSCALL
+	if (flags & ~(FAN_ALL_INIT_FLAGS | FAN_ENABLE_AUDIT))
+#else
 	if (flags & ~FAN_ALL_INIT_FLAGS)
+#endif
 		return -EINVAL;
 
 	if (event_f_flags & ~FANOTIFY_INIT_ALL_EVENT_F_BITS)
@@ -805,6 +812,13 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 		group->fanotify_data.max_marks = FANOTIFY_DEFAULT_MAX_MARKS;
 	}
 
+	if (flags & FAN_ENABLE_AUDIT) {
+		fd = -EPERM;
+		if (!capable(CAP_AUDIT_WRITE))
+			goto out_destroy_group;
+		group->fanotify_data.audit = true;
+	}
+
 	fd = anon_inode_getfd("[fanotify]", &fanotify_fops, group, f_flags);
 	if (fd < 0)
 		goto out_destroy_group;
diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index dd63aa9..ed311e3 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -156,6 +156,9 @@ void fanotify_show_fdinfo(struct seq_file *m, struct file *f)
 	if (group->fanotify_data.max_marks == UINT_MAX)
 		flags |= FAN_UNLIMITED_MARKS;
 
+	if (group->fanotify_data.audit)
+		flags |= FAN_ENABLE_AUDIT;
+
 	seq_printf(m, "fanotify flags:%x event-flags:%x\n",
 		   flags, group->fanotify_data.f_flags);
 
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 2150bdc..9095617 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -360,6 +360,7 @@ extern int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
 extern void __audit_log_capset(const struct cred *new, const struct cred *old);
 extern void __audit_mmap_fd(int fd, int flags);
 extern void __audit_log_kern_module(char *name);
+extern void __audit_fanotify(unsigned int response);
 
 static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
 {
@@ -456,6 +457,12 @@ static inline void audit_log_kern_module(char *name)
 		__audit_log_kern_module(name);
 }
 
+static inline void audit_fanotify(unsigned int response)
+{
+	if (!audit_dummy_context())
+		__audit_fanotify(response);
+}
+
 extern int audit_n_rules;
 extern int audit_signals;
 #else /* CONFIG_AUDITSYSCALL */
@@ -572,6 +579,9 @@ static inline void audit_log_kern_module(char *name)
 {
 }
 
+static inline void audit_fanotify(unsigned int response)
+{ }
+
 static inline void audit_ptrace(struct task_struct *t)
 { }
 #define audit_n_rules 0
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index c6c6931..f4131f2 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -190,6 +190,7 @@ struct fsnotify_group {
 			int f_flags;
 			unsigned int max_marks;
 			struct user_struct *user;
+			bool audit;
 		} fanotify_data;
 #endif /* CONFIG_FANOTIFY */
 	};
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 0714a66..221f8b7 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -112,6 +112,7 @@
 #define AUDIT_FEATURE_CHANGE	1328	/* audit log listing feature changes */
 #define AUDIT_REPLACE		1329	/* Replace auditd if this packet unanswerd */
 #define AUDIT_KERN_MODULE	1330	/* Kernel Module events */
+#define AUDIT_FANOTIFY		1331	/* Fanotify access decision */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index 030508d..5dda19a 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -35,6 +35,7 @@
 
 #define FAN_UNLIMITED_QUEUE	0x00000010
 #define FAN_UNLIMITED_MARKS	0x00000020
+#define FAN_ENABLE_AUDIT	0x00000040
 
 #define FAN_ALL_INIT_FLAGS	(FAN_CLOEXEC | FAN_NONBLOCK | \
 				 FAN_ALL_CLASS_BITS | FAN_UNLIMITED_QUEUE |\
@@ -99,6 +100,8 @@ struct fanotify_response {
 /* Legit userspace responses to a _PERM event */
 #define FAN_ALLOW	0x01
 #define FAN_DENY	0x02
+#define FAN_AUDIT	0x10	/* Bit mask to create audit record for result */
+
 /* No fd set in event */
 #define FAN_NOFD	-1
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3260ba2..e046de8 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2390,6 +2390,12 @@ void __audit_log_kern_module(char *name)
 	context->type = AUDIT_KERN_MODULE;
 }
 
+void __audit_fanotify(unsigned int response)
+{
+	audit_log(current->audit_context, GFP_KERNEL,
+		AUDIT_FANOTIFY,	"resp=%u", response);
+}
+
 static void audit_log_task(struct audit_buffer *ab)
 {
 	kuid_t auid, uid;
-- 
2.9.5
