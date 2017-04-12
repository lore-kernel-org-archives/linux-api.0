From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v2 1/2] ns: Allow ns_entries to have custom symlink content
Date: Wed, 12 Apr 2017 18:33:47 +0300
Message-ID: <149201120318.6007.7362655181033883000.stgit@localhost.localdomain>
References: <149201102204.6007.8628824763325355297.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <149201102204.6007.8628824763325355297.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Patch series "Expose task pid_ns_for_children to userspace".

pid_ns_for_children set by a task is known only to the task itself, and
it's impossible to identify it from outside.

It's a big problem for checkpoint/restore software like CRIU, because it
can't correctly handle tasks, that do setns(CLONE_NEWPID) in proccess of
their work.  If they have a custom pid_ns_for_children before dump, they
must have the same ns after restore.  Otherwise, restored task bumped into
enviroment it does not expect.

This patchset solves the problem.  It exposes pid_ns_for_children to ns
directory in standard way with the name "pid_for_children":

~# ls /proc/5531/ns -l | grep pid
lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid -> pid:[4026531836]
lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid_for_children -> pid:[4026532286]

This patch (of 2):

Make possible to have link content prefix yyy
different from the link name xxx:

$ readlink /proc/[pid]/ns/xxx
yyy:[4026531838]

This will be used in next patch.

Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Reviewed-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Acked-by: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 fs/nsfs.c               |    4 +++-
 include/linux/proc_ns.h |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 1656843e87d2..495f12b83a7b 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -195,9 +195,11 @@ int ns_get_name(char *buf, size_t size, struct task_struct *task,
 {
 	struct ns_common *ns;
 	int res = -ENOENT;
+	const char *name;
 	ns = ns_ops->get(task);
 	if (ns) {
-		res = snprintf(buf, size, "%s:[%u]", ns_ops->name, ns->inum);
+		name = ns_ops->real_ns_name ? : ns_ops->name;
+		res = snprintf(buf, size, "%s:[%u]", name, ns->inum);
 		ns_ops->put(ns);
 	}
 	return res;
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index 12cb8bd81d2d..88dba3b53375 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -14,6 +14,7 @@ struct inode;
 
 struct proc_ns_operations {
 	const char *name;
+	const char *real_ns_name;
 	int type;
 	struct ns_common *(*get)(struct task_struct *task);
 	void (*put)(struct ns_common *ns);
