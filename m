From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [v13][PATCH 04/12] Add target_pids parameter to alloc_pid()
Date: Wed, 25 Nov 2009 10:58:22 -0800
Message-ID: <20091125185822.GE30858@us.ibm.com>
References: <20091125185543.GA30858@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933116AbZKYS6m@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091125185543.GA30858@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Dobriyan <adobriyan@gmail.com>, Pavel Emelyanov <xemul@openvz.org>, hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, haveblue@us.ibm.com, Matt Helsley <matthltc@us.ibm.com>, arnd@arndb.de, roland@redhat.com, mtk.manpages@googlemail.com, linux-api@vger.kernel.org, Containers <containers@lists.linux-foundation.org>
List-Id: linux-api@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [v13][PATCH 04/12] Add target_pids parameter to alloc_pid()

This parameter is currently NULL, but will be used in a follow-on patch.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 include/linux/pid.h |    2 +-
 kernel/fork.c       |    3 ++-
 kernel/pid.c        |    9 +++++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index 49f1c2f..914185d 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -119,7 +119,7 @@ extern struct pid *find_get_pid(int nr);
 extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
 int next_pidmap(struct pid_namespace *pid_ns, int last);
 
-extern struct pid *alloc_pid(struct pid_namespace *ns);
+extern struct pid *alloc_pid(struct pid_namespace *ns, pid_t *target_pids);
 extern void free_pid(struct pid *pid);
 
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index 8053c10..00adf9f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -980,6 +980,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	int retval;
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
+	pid_t *target_pids = NULL;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1156,7 +1157,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_io;
 
 	if (pid != &init_struct_pid) {
-		pid = alloc_pid(p->nsproxy->pid_ns);
+		pid = alloc_pid(p->nsproxy->pid_ns, target_pids);
 		if (IS_ERR(pid)) {
 			retval = PTR_ERR(pid);
 			goto bad_fork_cleanup_io;
diff --git a/kernel/pid.c b/kernel/pid.c
index c50a711..ad3408b 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -280,13 +280,14 @@ void free_pid(struct pid *pid)
 	call_rcu(&pid->rcu, delayed_put_pid);
 }
 
-struct pid *alloc_pid(struct pid_namespace *ns)
+struct pid *alloc_pid(struct pid_namespace *ns, pid_t *target_pids)
 {
 	struct pid *pid;
 	enum pid_type type;
 	int i, nr;
 	struct pid_namespace *tmp;
 	struct upid *upid;
+	pid_t tpid;
 
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
 	if (!pid) {
@@ -296,7 +297,11 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
-		nr = alloc_pidmap(tmp);
+		tpid = 0;
+		if (target_pids)
+			tpid = target_pids[i];
+
+		nr = set_pidmap(tmp, tpid);
 		if (nr < 0)
 			goto out_free;
 
-- 
1.6.0.4
