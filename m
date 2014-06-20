From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: Re: [PATCH v2] ns: introduce getnspid syscall
Date: Fri, 20 Jun 2014 13:02:10 +0200
Message-ID: <53A414B2.20108@nod.at>
References: <1403259512-10510-1-git-send-email-chenhanxiao@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1403259512-10510-1-git-send-email-chenhanxiao-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Chen Hanxiao <chenhanxiao-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am 20.06.2014 12:18, schrieb Chen Hanxiao:
> We need a direct method of getting the pid inside containers.
> If some issues occurred inside container guest, host user
> could not know which process is in trouble just by guest pid:
> the users of container guest only knew the pid inside containers.
> This will bring obstacle for trouble shooting.
> 
> int getnspid(pid_t pid, int fd1, int fd2);
> 
> pid: the pid number need to be translated.
> 
> fd: a file descriptor referring to one of
>     the namespace entries in a /proc/[pid]/ns/pid.
>     fd1 for destination ns(ns1), where the pid came from.
>     fd2 for reference ns(ns2), while fd2 = -2 means for current ns.
> 
> return value:
>     >0 : translated pid in ns1(fd1) seen from ns2(fd2).
>     <=0: on failure.
>

I don't think that adding a new system call for this is a good solution.
We need a more generic way. I bet people are interested in more than just PID numbers.

I agree with Eric that a procfs solution is more appropriate.

Thanks,
//richard

> Signed-off-by: Chen Hanxiao <chenhanxiao-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> ---
> v2: drop pidtype
>     check ns_ops before getting pid_namespace structure
> 
>  arch/x86/syscalls/syscall_32.tbl |  1 +
>  arch/x86/syscalls/syscall_64.tbl |  1 +
>  include/linux/syscalls.h         |  1 +
>  kernel/nsproxy.c                 | 45 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 48 insertions(+)
> 
> diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
> index d6b8679..9de0b32 100644
> --- a/arch/x86/syscalls/syscall_32.tbl
> +++ b/arch/x86/syscalls/syscall_32.tbl
> @@ -360,3 +360,4 @@
>  351	i386	sched_setattr		sys_sched_setattr
>  352	i386	sched_getattr		sys_sched_getattr
>  353	i386	renameat2		sys_renameat2
> +354	i386	getnspid		sys_getnspid
> diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
> index ec255a1..1630a8a 100644
> --- a/arch/x86/syscalls/syscall_64.tbl
> +++ b/arch/x86/syscalls/syscall_64.tbl
> @@ -323,6 +323,7 @@
>  314	common	sched_setattr		sys_sched_setattr
>  315	common	sched_getattr		sys_sched_getattr
>  316	common	renameat2		sys_renameat2
> +317	common	getnspid		sys_getnspid
>  
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index b0881a0..53dd0e8 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -866,4 +866,5 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
>  asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
>  			 unsigned long idx1, unsigned long idx2);
>  asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
> +asmlinkage long sys_getpidns(pid_t pid, int fd1, int fd2);
>  #endif
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index 8e78110..9701ade 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -261,6 +261,51 @@ out:
>  	return err;
>  }
>  
> +SYSCALL_DEFINE3(getnspid, pid_t, pid, int, fd1, int, fd2)
> +{
> +	struct file *file1 = NULL, *file2 = NULL;
> +	struct pid *pid_struct;
> +	struct pid_namespace *ns1, *ns2;
> +	struct proc_ns *ei;
> +	int ret = -EINVAL;
> +
> +	file1 = proc_ns_fget(fd1);
> +	if (IS_ERR(file1))
> +		return PTR_ERR(file1);
> +	ei = get_proc_ns(file_inode(file1));
> +	if (ei->ns_ops != &pidns_operations)
> +		goto out;
> +	ns1 = (struct pid_namespace *)ei->ns;
> +
> +	/* fd == -2 for current pid ns */
> +	if (fd2 == -2) {
> +		ns2 = task_active_pid_ns(current);
> +	} else {
> +		file2 = proc_ns_fget(fd2);
> +		if (IS_ERR(file2)) {
> +			fput(file1);
> +			return PTR_ERR(file2);
> +		}
> +		ei = get_proc_ns(file_inode(file2));
> +		if (ei->ns_ops != &pidns_operations)
> +			goto out;
> +		ns2 = (struct pid_namespace *)ei->ns;
> +	}
> +
> +	pid_struct = find_pid_ns(pid, ns1);
> +	if (!pid_struct) {
> +		ret = -ESRCH;
> +		goto out;
> +	}
> +
> +	ret = pid_nr_ns(pid_struct, ns2);
> +out:
> +	fput(file1);
> +	if (file2)
> +		fput(file2);
> +	return ret;
> +}
> +
>  int __init nsproxy_cache_init(void)
>  {
>  	nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC);
> 
