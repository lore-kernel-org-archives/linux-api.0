From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [v13][PATCH 05/12] Add target_pids parameter to copy_process()
Date: Wed, 25 Nov 2009 10:58:42 -0800
Message-ID: <20091125185842.GF30858@us.ibm.com>
References: <20091125185543.GA30858@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932695AbZKYS6h@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091125185543.GA30858@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Dobriyan <adobriyan@gmail.com>, Pavel Emelyanov <xemul@openvz.org>, hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, haveblue@us.ibm.com, Matt Helsley <matthltc@us.ibm.com>, arnd@arndb.de, roland@redhat.com, mtk.manpages@googlemail.com, linux-api@vger.kernel.org, Containers <containers@lists.linux-foundation.org>
List-Id: linux-api@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [v13][PATCH 05/12] Add target_pids parameter to copy_process()

Add a 'target_pids' parameter to copy_process().  The new parameter will be
used in a follow-on patch when eclone() is implemented.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 kernel/fork.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 00adf9f..72c76a1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -975,12 +975,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 					unsigned long stack_size,
 					int __user *child_tidptr,
 					struct pid *pid,
+					pid_t *target_pids,
 					int trace)
 {
 	int retval;
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
-	pid_t *target_pids = NULL;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1361,7 +1361,7 @@ struct task_struct * __cpuinit fork_idle(int cpu)
 	struct pt_regs regs;
 
 	task = copy_process(CLONE_VM, 0, idle_regs(&regs), 0, NULL,
-			    &init_struct_pid, 0);
+			    &init_struct_pid, NULL, 0);
 	if (!IS_ERR(task))
 		init_idle(task, cpu);
 
@@ -1384,6 +1384,7 @@ long do_fork(unsigned long clone_flags,
 	struct task_struct *p;
 	int trace = 0;
 	long nr;
+	pid_t *target_pids = NULL;
 
 	/*
 	 * Do some preliminary argument and permissions checking before we
@@ -1424,7 +1425,7 @@ long do_fork(unsigned long clone_flags,
 		trace = tracehook_prepare_clone(clone_flags);
 
 	p = copy_process(clone_flags, stack_start, regs, stack_size,
-			 child_tidptr, NULL, trace);
+			 child_tidptr, NULL, target_pids, trace);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
-- 
1.6.0.4
