From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [v12][PATCH 6/9] Check invalid clone flags
Date: Tue, 10 Nov 2009 20:44:22 -0800
Message-ID: <20091111044422.GF11393@suka>
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


Subject: [v12][PATCH 6/9] Check invalid clone flags

As pointed out by Oren Laadan, we want to ensure that unused bits in the
clone-flags remain unused and available for future. To ensure this, define
a mask of clone-flags and check the flags in the clone() system calls.

Changelog[v9]:
	- Include the unused clone-flag (CLONE_UNUSED) to VALID_CLONE_FLAGS
	  to avoid breaking any applications that may have set it. IOW, this
	  patch/check only applies to clone-flags bits 33 and higher.

Changelog[v8]:
	- New patch in set

Signed-off-by: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Acked-by: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
---
 include/linux/sched.h |   12 ++++++++++++
 kernel/fork.c         |    3 +++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..a4d2c23 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -29,6 +29,18 @@
 #define CLONE_NEWNET		0x40000000	/* New network namespace */
 #define CLONE_IO		0x80000000	/* Clone io context */
 
+#define CLONE_UNUSED        	0x00001000	/* Can be reused ? */
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
index c8a06de..11f77ed 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -982,6 +982,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
 
+	if (clone_flags & ~VALID_CLONE_FLAGS)
+		return ERR_PTR(-EINVAL);
+
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
 
-- 
1.6.0.4
