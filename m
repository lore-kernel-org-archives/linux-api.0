From: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/4] kernel: add a helper to get an owning user namespace for a namespace
Date: Fri, 26 Aug 2016 16:08:08 -0700
Message-ID: <1472252891-4963-2-git-send-email-avagin@openvz.org>
References: <1472252891-4963-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472252891-4963-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Return -EPERM if an owning user namespace is outside of a process
current user namespace.

v2: In a first version ns_get_owner returned ENOENT for init_user_ns.
    This special cases was removed from this version. There is nothing
    outside of init_user_ns, so we can return EPERM.

Signed-off-by: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 fs/namespace.c                 |  6 ++++++
 include/linux/proc_ns.h        |  1 +
 include/linux/user_namespace.h |  7 +++++++
 ipc/namespace.c                |  6 ++++++
 kernel/cgroup.c                |  6 ++++++
 kernel/pid_namespace.c         |  6 ++++++
 kernel/user_namespace.c        | 24 ++++++++++++++++++++++++
 kernel/utsname.c               |  6 ++++++
 net/core/net_namespace.c       |  6 ++++++
 9 files changed, 68 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 491b8f3..f985817 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3368,10 +3368,16 @@ static int mntns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	return 0;
 }
 
+static struct user_namespace *mntns_get_owner(struct ns_common *ns)
+{
+	return to_mnt_ns(ns)->user_ns;
+}
+
 const struct proc_ns_operations mntns_operations = {
 	.name		= "mnt",
 	.type		= CLONE_NEWNS,
 	.get		= mntns_get,
 	.put		= mntns_put,
 	.install	= mntns_install,
+	.get_owner	= mntns_get_owner,
 };
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index de0e771..cfc8be7 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -18,6 +18,7 @@ struct proc_ns_operations {
 	struct ns_common *(*get)(struct task_struct *task);
 	void (*put)(struct ns_common *ns);
 	int (*install)(struct nsproxy *nsproxy, struct ns_common *ns);
+	struct user_namespace *(*get_owner)(struct ns_common *ns);
 };
 
 extern const struct proc_ns_operations netns_operations;
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 30ffe10..eb209d4 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -106,6 +106,8 @@ extern ssize_t proc_setgroups_write(struct file *, const char __user *, size_t,
 extern int proc_setgroups_show(struct seq_file *m, void *v);
 extern bool userns_may_setgroups(const struct user_namespace *ns);
 extern bool current_in_userns(const struct user_namespace *target_ns);
+
+struct ns_common *ns_get_owner(struct ns_common *ns);
 #else
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
@@ -139,6 +141,11 @@ static inline bool current_in_userns(const struct user_namespace *target_ns)
 {
 	return true;
 }
+
+static inline struct ns_common *ns_get_owner(struct ns_common *ns)
+{
+	return ERR_PTR(-EPERM);
+}
 #endif
 
 #endif /* _LINUX_USER_H */
diff --git a/ipc/namespace.c b/ipc/namespace.c
index 7309142..991a31e 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -188,10 +188,16 @@ static int ipcns_install(struct nsproxy *nsproxy, struct ns_common *new)
 	return 0;
 }
 
+static struct user_namespace *ipcns_get_owner(struct ns_common *ns)
+{
+	return to_ipc_ns(ns)->user_ns;
+}
+
 const struct proc_ns_operations ipcns_operations = {
 	.name		= "ipc",
 	.type		= CLONE_NEWIPC,
 	.get		= ipcns_get,
 	.put		= ipcns_put,
 	.install	= ipcns_install,
+	.get_owner	= ipcns_get_owner,
 };
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e9e4427..4204693 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -6421,12 +6421,18 @@ static void cgroupns_put(struct ns_common *ns)
 	put_cgroup_ns(to_cg_ns(ns));
 }
 
+static struct user_namespace *cgroupns_get_owner(struct ns_common *ns)
+{
+	return to_cg_ns(ns)->user_ns;
+}
+
 const struct proc_ns_operations cgroupns_operations = {
 	.name		= "cgroup",
 	.type		= CLONE_NEWCGROUP,
 	.get		= cgroupns_get,
 	.put		= cgroupns_put,
 	.install	= cgroupns_install,
+	.get_owner	= cgroupns_get_owner,
 };
 
 static __init int cgroup_namespaces_init(void)
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 30a7f33..1860d9d 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -405,12 +405,18 @@ static int pidns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	return 0;
 }
 
+static struct user_namespace *pidns_get_owner(struct ns_common *ns)
+{
+	return to_pid_ns(ns)->user_ns;
+}
+
 const struct proc_ns_operations pidns_operations = {
 	.name		= "pid",
 	.type		= CLONE_NEWPID,
 	.get		= pidns_get,
 	.put		= pidns_put,
 	.install	= pidns_install,
+	.get_owner	= pidns_get_owner,
 };
 
 static __init int pid_namespaces_init(void)
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 0edafe3..f0521e4 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1050,12 +1050,36 @@ static int userns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	return commit_creds(cred);
 }
 
+struct ns_common *ns_get_owner(struct ns_common *ns)
+{
+	struct user_namespace *my_user_ns = current_user_ns();
+	struct user_namespace *owner, *p;
+
+	/* See if the owner is in the current user namespace */
+	owner = p = ns->ops->get_owner(ns);
+	for (;;) {
+		if (!p)
+			return ERR_PTR(-EPERM);
+		if (p == my_user_ns)
+			break;
+		p = p->parent;
+	}
+
+	return &get_user_ns(owner)->ns;
+}
+
+static struct user_namespace *userns_get_owner(struct ns_common *ns)
+{
+	return to_user_ns(ns)->parent;
+}
+
 const struct proc_ns_operations userns_operations = {
 	.name		= "user",
 	.type		= CLONE_NEWUSER,
 	.get		= userns_get,
 	.put		= userns_put,
 	.install	= userns_install,
+	.get_owner	= userns_get_owner,
 };
 
 static __init int user_namespaces_init(void)
diff --git a/kernel/utsname.c b/kernel/utsname.c
index f3b0bb4..3b3028f 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -154,10 +154,16 @@ static int utsns_install(struct nsproxy *nsproxy, struct ns_common *new)
 	return 0;
 }
 
+static struct user_namespace *utsns_get_owner(struct ns_common *ns)
+{
+	return to_uts_ns(ns)->user_ns;
+}
+
 const struct proc_ns_operations utsns_operations = {
 	.name		= "uts",
 	.type		= CLONE_NEWUTS,
 	.get		= utsns_get,
 	.put		= utsns_put,
 	.install	= utsns_install,
+	.get_owner	= utsns_get_owner,
 };
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 3e2812a..1ccba4b 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -1016,11 +1016,17 @@ static int netns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 	return 0;
 }
 
+static struct user_namespace *netns_get_owner(struct ns_common *ns)
+{
+	return to_net_ns(ns)->user_ns;
+}
+
 const struct proc_ns_operations netns_operations = {
 	.name		= "net",
 	.type		= CLONE_NEWNET,
 	.get		= netns_get,
 	.put		= netns_put,
 	.install	= netns_install,
+	.get_owner	= netns_get_owner,
 };
 #endif
-- 
2.5.5
