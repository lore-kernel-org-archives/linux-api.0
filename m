From: Andrei Vagin <avagin@virtuozzo.com>
Subject: Re: [PATCH 2/2] pidns: Expose task pid_ns_for_children to userspace
Date: Tue, 17 Jan 2017 12:00:09 -0800
Message-ID: <20170117200008.GA12788@outlook.office365.com>
References: <148440326011.30622.12833059348082223242.stgit@localhost.localdomain>
 <148440329770.30622.16593902895676160550.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148440329770.30622.16593902895676160550.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: avagin@openvz.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, ebiederm@xmission.com, gorcunov@openvz.org, viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Sat, Jan 14, 2017 at 05:15:04PM +0300, Kirill Tkhai wrote:
> For correct checkpointing/restoring of a task from userspace
> it's need to know the task's pid_ns_for_children. Currently,
> there is no a sane way to do that (the only possible trick
> is to force the task create a new child and to analize the
> child's /proc/[pid]/ns/pid link, that is performance-stupid).
> 
> The patch exposes pid_ns_for_children to ns directory
> in standard way with the name "pid_for_children":
> 
> ~# ls /proc/5531/ns -l | grep pid
> lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid -> pid:[4026531836]
> lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid_for_children -> pid:[4026532286]
>

Cc: linux-api, Michael Kerrisk

Acked-by: Andrei Vagin <avagin@virtuozzo.com>

> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> ---
>  fs/proc/namespaces.c    |    1 +
>  include/linux/proc_ns.h |    1 +
>  kernel/pid_namespace.c  |   25 +++++++++++++++++++++++++
>  3 files changed, 27 insertions(+)
> 
> diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
> index 766f0c637ad1..3803b24ca220 100644
> --- a/fs/proc/namespaces.c
> +++ b/fs/proc/namespaces.c
> @@ -23,6 +23,7 @@ static const struct proc_ns_operations *ns_entries[] = {
>  #endif
>  #ifdef CONFIG_PID_NS
>  	&pidns_operations,
> +	&pidns_for_children_operations,
>  #endif
>  #ifdef CONFIG_USER_NS
>  	&userns_operations,
> diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
> index 88dba3b53375..58ab28d81fc2 100644
> --- a/include/linux/proc_ns.h
> +++ b/include/linux/proc_ns.h
> @@ -27,6 +27,7 @@ extern const struct proc_ns_operations netns_operations;
>  extern const struct proc_ns_operations utsns_operations;
>  extern const struct proc_ns_operations ipcns_operations;
>  extern const struct proc_ns_operations pidns_operations;
> +extern const struct proc_ns_operations pidns_for_children_operations;
>  extern const struct proc_ns_operations userns_operations;
>  extern const struct proc_ns_operations mntns_operations;
>  extern const struct proc_ns_operations cgroupns_operations;
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index df9e8e9e0be7..cbe950d4a11e 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -369,6 +369,20 @@ static struct ns_common *pidns_get(struct task_struct *task)
>  	return ns ? &ns->ns : NULL;
>  }
>  
> +static struct ns_common *pidns_for_children_get(struct task_struct *task)
> +{
> +	struct pid_namespace *ns = NULL;
> +
> +	task_lock(task);
> +	if (task->nsproxy) {
> +		ns = task->nsproxy->pid_ns_for_children;
> +		get_pid_ns(ns);
> +	}
> +	task_unlock(task);
> +
> +	return ns ? &ns->ns : NULL;
> +}
> +
>  static void pidns_put(struct ns_common *ns)
>  {
>  	put_pid_ns(to_pid_ns(ns));
> @@ -438,6 +452,17 @@ const struct proc_ns_operations pidns_operations = {
>  	.get_parent	= pidns_get_parent,
>  };
>  
> +const struct proc_ns_operations pidns_for_children_operations = {
> +	.name		= "pid_for_children",
> +	.real_ns_name	= "pid",
> +	.type		= CLONE_NEWPID,
> +	.get		= pidns_for_children_get,
> +	.put		= pidns_put,
> +	.install	= pidns_install,
> +	.owner		= pidns_owner,
> +	.get_parent	= pidns_get_parent,
> +};
> +
>  static __init int pid_namespaces_init(void)
>  {
>  	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
> 
