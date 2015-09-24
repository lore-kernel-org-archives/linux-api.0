From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v2] pidns: introduce syscall getvpid
Date: Thu, 24 Sep 2015 16:56:47 +0200
Message-ID: <20150924145647.GA24151@redhat.com>
References: <20150924135332.27813.21640.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150924135332.27813.21640.stgit@buzz>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/24, Konstantin Khlebnikov wrote:
>
> +SYSCALL_DEFINE3(getvpid, pid_t, pid, int, source, int, target)
> +{
> +	struct file *source_file = NULL, *target_file = NULL;
> +	struct pid_namespace *source_ns, *target_ns;
> +	struct pid *struct_pid;
> +	struct ns_common *ns;
> +	pid_t result;
> +
> +	if (source >= 0) {
> +		source_file = proc_ns_fget(source);
> +		result = PTR_ERR(source_file);
> +		if (IS_ERR(source_file))
> +			goto out;
> +		ns = get_proc_ns(file_inode(source_file));
> +		result = -EINVAL;
> +		if (ns->ops->type != CLONE_NEWPID)
> +			goto out;
> +		source_ns = container_of(ns, struct pid_namespace, ns);
> +	} else
> +		source_ns = task_active_pid_ns(current);
> +
> +	if (target >= 0) {
> +		target_file = proc_ns_fget(target);
> +		result = PTR_ERR(target_file);
> +		if (IS_ERR(target_file))
> +			goto out;
> +		ns = get_proc_ns(file_inode(target_file));
> +		result = -EINVAL;
> +		if (ns->ops->type != CLONE_NEWPID)
> +			goto out;
> +		target_ns = container_of(ns, struct pid_namespace, ns);
> +	} else
> +		target_ns = task_active_pid_ns(current);
> +

Hmm. Eric, Konstantin, how about (uncompiled/untested) patch below
in a preparation? The code above doesn't look very readable.

In fact I think another helper

	#define proc_ns_xxx(file, type)				\
		container_of(get_proc_ns(file_inode(file)),	\
				struct type, ns)

makes sense too.

Oleg.
---

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 99521e7..0877dd6 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -118,9 +118,10 @@ int ns_get_name(char *buf, size_t size, struct task_struct *task,
 	return res;
 }
 
-struct file *proc_ns_fget(int fd)
+struct file *proc_ns_fget(int fd, int nstype)
 {
 	struct file *file;
+	struct ns_common *ns;
 
 	file = fget(fd);
 	if (!file)
@@ -129,6 +130,10 @@ struct file *proc_ns_fget(int fd)
 	if (file->f_op != &ns_file_operations)
 		goto out_invalid;
 
+	ns = get_proc_ns(file_inode(file));
+	if (nstype && (ns->ops->type != nstype))
+		goto out_invalid;
+
 	return file;
 
 out_invalid:
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index 42dfc61..84c9770 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -65,7 +65,7 @@ static inline int ns_alloc_inum(struct ns_common *ns)
 
 #define ns_free_inum(ns) proc_free_inum((ns)->inum)
 
-extern struct file *proc_ns_fget(int fd);
+extern struct file *proc_ns_fget(int fd, int nstype);
 #define get_proc_ns(inode) ((struct ns_common *)(inode)->i_private)
 extern void *ns_get_path(struct path *path, struct task_struct *task,
 			const struct proc_ns_operations *ns_ops);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 49746c8..fee18ba 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -226,21 +226,17 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
 	struct ns_common *ns;
 	int err;
 
-	file = proc_ns_fget(fd);
+	file = proc_ns_fget(fd, nstype);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
-	err = -EINVAL;
-	ns = get_proc_ns(file_inode(file));
-	if (nstype && (ns->ops->type != nstype))
-		goto out;
-
 	new_nsproxy = create_new_namespaces(0, tsk, current_user_ns(), tsk->fs);
 	if (IS_ERR(new_nsproxy)) {
 		err = PTR_ERR(new_nsproxy);
 		goto out;
 	}
 
+	ns = get_proc_ns(file_inode(file));
 	err = ns->ops->install(new_nsproxy, ns);
 	if (err) {
 		free_nsproxy(new_nsproxy);
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 572af00..9dfbe68 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -424,15 +424,12 @@ struct net *get_net_ns_by_fd(int fd)
 	struct ns_common *ns;
 	struct net *net;
 
-	file = proc_ns_fget(fd);
+	file = proc_ns_fget(fd, CLONE_NEWNET);
 	if (IS_ERR(file))
 		return ERR_CAST(file);
 
 	ns = get_proc_ns(file_inode(file));
-	if (ns->ops == &netns_operations)
-		net = get_net(container_of(ns, struct net, ns));
-	else
-		net = ERR_PTR(-EINVAL);
+	net = get_net(container_of(ns, struct net, ns));
 
 	fput(file);
 	return net;
