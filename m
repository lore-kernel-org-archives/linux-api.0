From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v2 2/2] pidns: Expose task pid_ns_for_children to userspace
Date: Wed, 12 Apr 2017 18:34:27 +0300
Message-ID: <149201123914.6007.2187327078064239572.stgit@localhost.localdomain>
References: <149201102204.6007.8628824763325355297.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <149201102204.6007.8628824763325355297.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

pid_ns_for_children set by a task is known only to the task itself,
and it's impossible to identify it from outside.

It's a big problem for checkpoint/restore software like CRIU,
because it can't correctly handle tasks, that do setns(CLONE_NEWPID)
in proccess of their work.

This patch solves the problem, and it exposes pid_ns_for_children
to ns directory in standard way with the name "pid_for_children":

~# ls /proc/5531/ns -l | grep pid
lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid -> pid:[4026531836]
lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid_for_children -> pid:[4026532286]

v2: Do not allow to get namespace if there is no child reaper created,
as other tasks need initializations it did (e.g., pid_namespace::proc_mnt),
and we don't want they race.

Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 fs/proc/namespaces.c    |    1 +
 include/linux/proc_ns.h |    1 +
 kernel/pid_namespace.c  |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 766f0c637ad1..3803b24ca220 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -23,6 +23,7 @@ static const struct proc_ns_operations *ns_entries[] = {
 #endif
 #ifdef CONFIG_PID_NS
 	&pidns_operations,
+	&pidns_for_children_operations,
 #endif
 #ifdef CONFIG_USER_NS
 	&userns_operations,
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index 88dba3b53375..58ab28d81fc2 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -27,6 +27,7 @@ extern const struct proc_ns_operations netns_operations;
 extern const struct proc_ns_operations utsns_operations;
 extern const struct proc_ns_operations ipcns_operations;
 extern const struct proc_ns_operations pidns_operations;
+extern const struct proc_ns_operations pidns_for_children_operations;
 extern const struct proc_ns_operations userns_operations;
 extern const struct proc_ns_operations mntns_operations;
 extern const struct proc_ns_operations cgroupns_operations;
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index de461aa0bf9a..d1f3e9f558b8 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -374,6 +374,29 @@ static struct ns_common *pidns_get(struct task_struct *task)
 	return ns ? &ns->ns : NULL;
 }
 
+static struct ns_common *pidns_for_children_get(struct task_struct *task)
+{
+	struct pid_namespace *ns = NULL;
+
+	task_lock(task);
+	if (task->nsproxy) {
+		ns = task->nsproxy->pid_ns_for_children;
+		get_pid_ns(ns);
+	}
+	task_unlock(task);
+
+	if (ns) {
+		read_lock(&tasklist_lock);
+		if (!ns->child_reaper) {
+			put_pid_ns(ns);
+			ns = NULL;
+		}
+		read_unlock(&tasklist_lock);
+	}
+
+	return ns ? &ns->ns : NULL;
+}
+
 static void pidns_put(struct ns_common *ns)
 {
 	put_pid_ns(to_pid_ns(ns));
@@ -443,6 +466,17 @@ const struct proc_ns_operations pidns_operations = {
 	.get_parent	= pidns_get_parent,
 };
 
+const struct proc_ns_operations pidns_for_children_operations = {
+	.name		= "pid_for_children",
+	.real_ns_name	= "pid",
+	.type		= CLONE_NEWPID,
+	.get		= pidns_for_children_get,
+	.put		= pidns_put,
+	.install	= pidns_install,
+	.owner		= pidns_owner,
+	.get_parent	= pidns_get_parent,
+};
+
 static __init int pid_namespaces_init(void)
 {
 	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
