From: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Subject: [PATCH v21 006/100] eclone (6/11): Check invalid clone flags
Date: Sat,  1 May 2010 10:14:48 -0400
Message-ID: <1272723382-19470-7-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1272723382-19470-1-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

As pointed out by Oren Laadan, we want to ensure that unused bits in the
clone-flags remain unused and available for future. To ensure this, define
a mask of clone-flags and check the flags in the clone() system calls.

Changelog[v9]:
	- Include the unused clone-flag (CLONE_UNUSED) to VALID_CLONE_FLAGS
	  to avoid breaking any applications that may have set it. IOW, this
	  patch/check only applies to clone-flags bits 33 and higher.

Changelog[v8]:
	- New patch in set

Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Acked-by: Serge E. Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Tested-by: Serge E. Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Acked-by: Oren Laadan <orenl.cs.columbia.edu>
---
 include/linux/sched.h |   12 ++++++++++++
 kernel/fork.c         |    3 +++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index dad7f66..5de3ce5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -29,6 +29,18 @@
 #define CLONE_NEWNET		0x40000000	/* New network namespace */
 #define CLONE_IO		0x80000000	/* Clone io context */
 
+#define CLONE_UNUSED		0x00001000	/* Can be reused ? */
+
+#define VALID_CLONE_FLAGS	(CSIGNAL | CLONE_VM | CLONE_FS | CLONE_FILES |\
+				 CLONE_SIGHAND | CLONE_UNUSED | CLONE_PTRACE |\
+				 CLONE_VFORK  | CLONE_PARENT | CLONE_THREAD  |\
+				 CLONE_NEWNS  | CLONE_SYSVSEM | CLONE_SETTLS |\
+				 CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID  |\
+				 CLONE_DETACHED | CLONE_UNTRACED             |\
+				 CLONE_CHILD_SETTID | CLONE_STOPPED          |\
+				 CLONE_NEWUTS | CLONE_NEWIPC | CLONE_NEWUSER |\
+				 CLONE_NEWPID | CLONE_NEWNET | CLONE_IO)
+
 /*
  * Scheduling policies
  */
diff --git a/kernel/fork.c b/kernel/fork.c
index 9d2b57e..e41b3d1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -964,6 +964,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
 
+	if (clone_flags & ~VALID_CLONE_FLAGS)
+		return ERR_PTR(-EINVAL);
+
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
 
-- 
1.6.3.3
