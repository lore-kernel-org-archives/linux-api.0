From: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Subject: Re: [RESEND RFC] translate_pid API
Date: Wed, 14 Mar 2018 14:22:51 -0700
Message-ID: <990e88fa-ab50-9645-b031-14e1afbf7ccc@oracle.com>
References: <1520875093-18174-1-git-send-email-nagarathnam.muthusamy@oracle.com>
 <87vadzqqq6.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87vadzqqq6.fsf@xmission.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, khlebnikov@yandex-team.ru, Nagarajan.Muthukrishnan@oracle.com, prakash.sangappa@oracle.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, serge.hallyn@ubuntu.com, esyr@redhat.com, jannh@google.com
List-Id: linux-api@vger.kernel.org



On 03/13/2018 08:29 PM, ebiederm@xmission.com wrote:
> nagarathnam.muthusamy@oracle.com writes:
>
>> Resending the RFC with participants of previous discussions
>> in the list.
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Please read below to see why.
>
>> Following patch which is a variation of a solution discussed
>> in https://lwn.net/Articles/736330/ provides the users of
>> pid namespace, the functionality of pid translation between
>> namespaces using a namespace identifier. The topic of
>> pid translation has been discussed in the community few times
>> but there has always been a resistance to adding new solution
>> for this problem.
> So far there has been no clear cut case that is worth the maintenance
> challenge.  As I recall the conversations they have always resulted
> in a better way discovered.
>
>> I will outline the planned usecase of pid namespace by oracle
>> database and explain why any of the existing solution cannot
>> be used to solve their problem.
>>
>> Consider a system in which several PID namespaces with multiple
>> nested levels exists in parallel with monitor processes managing
>> all the namespaces. PID translation is required for controlling
>> and accessing information about the processes by the monitors
>> and other processes down the hierarchy of namespaces. Controlling
>> primarily involves sending signals or using ptrace by a process in
>> parent namespace on any of the processes in its child namespace.
>> Accessing information deals with the reading /proc/<pid>/* files
>> of processes in child namespace. None of the processes have
>> root/CAP_SYS_ADMIN privileges.
> So one process inside of a pid namespace one process outside of
> the pid namespace and they are talking about some other process
> inside the pid namespace.
>
> Agreed that is a usecase that likely needs pid translation.
>
>> Existing methods:
>>
>> *) SCM_CREDENTIALS message:
>> 	Ref: http://man7.org/linux/man-pages/man7/unix.7.html
>> 	The sender can translate its pid from its own namespace
>> to a pid in the target namespace by sending and receiving the
>> SCM_CREDENTIALS message. The drawback of this method is the
>> requirement of a socket communication channel to pid translation
>> which adds to the management overhead. This method does not enable
>> the sender to translate the pid of other process unless it is root
>> or it has CAP_SYS_ADMIN.
> Or it has CAP_SYS_ADMIN (in the sending pid namespace).
> That is fair.
>
>> *) /proc/<pid>/status file
>> 	Ref: http://man7.org/linux/man-pages/man5/proc.5.html
>> 	Ref: https://patchwork.kernel.org/patch/5861791/
>> 	/proc/<pid>/status file provides a way to find the pids
>> associated with a process in different namespaces. Pid translation
>> from child namespace to parent namespace from parent namespace would
>> require searching all the status file in the parent namespace to find
>> the desired pid at desired level which is inefficient.
> That is fair.
>> Method under review:
>>
>> *) pidns: introduce syscall translate_pid
>> 	Ref: https://lwn.net/Articles/736330/
>> 	This solution though not integrated yet, when used would require
>> monitor to have open file descriptor for every level of namespace it
>> has to monitor which results in explosion of number of file descriptors
>> the monitor has to keep open.
> You know what tough nuggies.
>
> File descriptors aren't or at least shouldn't be that expensive.  And
> you are already committing to tracking the pid namespaces anyway.  An
> int for a file descriptor is cheaper than a u64 for the userspace
> process.

The size of individual file descriptor was not the issue but the
number of file descriptors to track for each level in a nested
PID namespace is the issue.

> The cost of that ``cheaper'' u64 that is not in any namespace is that
> you now have to go and implement a namespace of namespaces.  You haven't
> even attempted it.  So just no.    Anything that brings us to needing
> a namespace of namespaces is a bad design.

I am not trying to implement a namespace of namespaces. The ID
exported through /proc/<pid>/ns/pidns_id is associated with the
pid namespace of the process. The function of this ID is very similar to
that of the inode number exported by /proc/<pid>/ns/pid file (ie) uniquely
identify a pid namespace in the system.

Inode numbers can be recycled very fast and hence I proposed a
separate ID. Instead of exporting inode number through /proc/<pid>/ns/pid
file we could directly export this new ID but I instead moved it to
a separate file so that any existing application which depends on this
number being 32-bit wont break.

>> Following patch uses a 64-bit ID for namespace exported by procfs
>> for pid translation through a new file /proc/<pid>/ns/pidns_id.
> And this design detail is what brings the automatic nack.
>
> Use file descriptros and it sounds like your use case justifies what you
> are trying to do.

File descriptors are problematic for following reasons.
1) I need to open a couple of file descriptors for every pid translation 
request.
2) In case of nested PID namespaces, say a new pid namespace is created 
at level 20,
     with unique ID, I could just record this ID in a shared memory for 
interested process
     to use. In case of file descriptors, every level has to figure out 
the process ID of the
     newly created namespace's init process and open a file descriptor 
to track it.

Thanks,
Nagarathnam.
>
>> [root@brm-x4600-01 ~]# ls -l /proc/4690/ns
>> total 0
>> lrwxrwxrwx 1 root root 0 Mar  1 15:55 cgroup -> cgroup:[4026531835]
>> lrwxrwxrwx 1 root root 0 Mar  1 15:55 ipc -> ipc:[4026531839]
>> lrwxrwxrwx 1 root root 0 Mar  1 15:55 mnt -> mnt:[4026532324]
>> lrwxrwxrwx 1 root root 0 Mar  1 15:55 net -> net:[4026531993]
>> lrwxrwxrwx 1 root root 0 Mar  1 15:55 pid -> pid:[4026532325]
>> lrwxrwxrwx 1 root root 0 Mar  1 15:55 pid_for_children -> pid:[4026532325]
>> lrwxrwxrwx 1 root root 0 Mar  1 15:55 pidns_id -> [14994344851325148137]
>> lrwxrwxrwx 1 root root 0 Mar  1 15:55 user -> user:[4026531837]
>> lrwxrwxrwx 1 root root 0 Mar  1 15:55 uts -> uts:[4026531838]
>>
>> Though there is a problem of ID being recycled in longterm, managing
>> an ID per namespace is easier than having open file descriptors per
>> pid namespace. Existing namespace inode numbers recycles faster and hence
>> their usability as ID for this API is less.
> No.
>
> A namespace of namespaces is a much harder problem.  We aren't going
> there.
>
> It sounds like you may be struggling with lifetime issues and when
> to close/get rid of your pid namespace identifier.  That could deserve
> a conversation.  Idenitifiers that are not namespaced are absolutely not
> the solution.
>
> Eric
>
>
>> Signed-off-by: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
>> ---
>>   arch/x86/entry/syscalls/syscall_32.tbl |   1 +
>>   arch/x86/entry/syscalls/syscall_64.tbl |   2 +
>>   fs/nsfs.c                              |   9 +-
>>   fs/proc/namespaces.c                   |   1 +
>>   include/linux/ns_common.h              |   1 +
>>   include/linux/pid_namespace.h          |   3 +
>>   include/linux/proc_ns.h                |   1 +
>>   include/linux/syscalls.h               |   1 +
>>   kernel/pid_namespace.c                 | 190 ++++++++++++++++++++++++++++++++-
>>   kernel/sys_ni.c                        |   4 +
>>   10 files changed, 208 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
>> index 448ac21..31bf798 100644
>> --- a/arch/x86/entry/syscalls/syscall_32.tbl
>> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
>> @@ -391,3 +391,4 @@
>>   382	i386	pkey_free		sys_pkey_free
>>   383	i386	statx			sys_statx
>>   384	i386	arch_prctl		sys_arch_prctl			compat_sys_arch_prctl
>> +385	i386	translate_pid		sys_translate_pid		compat_sys_translate_pid
>> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
>> index 5aef183..89196c3 100644
>> --- a/arch/x86/entry/syscalls/syscall_64.tbl
>> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
>> @@ -339,6 +339,7 @@
>>   330	common	pkey_alloc		sys_pkey_alloc
>>   331	common	pkey_free		sys_pkey_free
>>   332	common	statx			sys_statx
>> +333	64	translate_pid		sys_translate_pid
>>   
>>   #
>>   # x32-specific system call numbers start at 512 to avoid cache impact
>> @@ -380,3 +381,4 @@
>>   545	x32	execveat		compat_sys_execveat/ptregs
>>   546	x32	preadv2			compat_sys_preadv64v2
>>   547	x32	pwritev2		compat_sys_pwritev64v2
>> +548	x32	translate_pid		compat_sys_translate_pid
>> diff --git a/fs/nsfs.c b/fs/nsfs.c
>> index 36b0772..c635465 100644
>> --- a/fs/nsfs.c
>> +++ b/fs/nsfs.c
>> @@ -222,8 +222,13 @@ int ns_get_name(char *buf, size_t size, struct task_struct *task,
>>   	const char *name;
>>   	ns = ns_ops->get(task);
>>   	if (ns) {
>> -		name = ns_ops->real_ns_name ? : ns_ops->name;
>> -		res = snprintf(buf, size, "%s:[%u]", name, ns->inum);
>> +		if (!strcmp(ns_ops->name, "pidns_id")) {
>> +			res = snprintf(buf, size, "[%llu]",
>> +				       (unsigned long long)ns->ns_id);
>> +		} else {
>> +			name = ns_ops->real_ns_name ? : ns_ops->name;
>> +			res = snprintf(buf, size, "%s:[%u]", name, ns->inum);
>> +		}
>>   		ns_ops->put(ns);
>>   	}
>>   	return res;
>> diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
>> index 59b17e5..ac823ce 100644
>> --- a/fs/proc/namespaces.c
>> +++ b/fs/proc/namespaces.c
>> @@ -24,6 +24,7 @@
>>   #endif
>>   #ifdef CONFIG_PID_NS
>>   	&pidns_operations,
>> +	&pidns_id_operations,
>>   	&pidns_for_children_operations,
>>   #endif
>>   #ifdef CONFIG_USER_NS
>> diff --git a/include/linux/ns_common.h b/include/linux/ns_common.h
>> index 5fbc400..6ca3d43 100644
>> --- a/include/linux/ns_common.h
>> +++ b/include/linux/ns_common.h
>> @@ -8,6 +8,7 @@ struct ns_common {
>>   	atomic_long_t stashed;
>>   	const struct proc_ns_operations *ops;
>>   	unsigned int inum;
>> +	u64 ns_id;
>>   };
>>   
>>   #endif
>> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
>> index 49538b1..11d1d57 100644
>> --- a/include/linux/pid_namespace.h
>> +++ b/include/linux/pid_namespace.h
>> @@ -11,6 +11,7 @@
>>   #include <linux/kref.h>
>>   #include <linux/ns_common.h>
>>   #include <linux/idr.h>
>> +#include <linux/list_bl.h>
>>   
>>   
>>   struct fs_pin;
>> @@ -44,6 +45,8 @@ struct pid_namespace {
>>   	kgid_t pid_gid;
>>   	int hide_pid;
>>   	int reboot;	/* group exit code if this pidns was rebooted */
>> +	struct hlist_bl_node node;
>> +	atomic_t lookups_pending;
>>   	struct ns_common ns;
>>   } __randomize_layout;
>>   
>> diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
>> index d31cb62..861e38bd 100644
>> --- a/include/linux/proc_ns.h
>> +++ b/include/linux/proc_ns.h
>> @@ -28,6 +28,7 @@ struct proc_ns_operations {
>>   extern const struct proc_ns_operations utsns_operations;
>>   extern const struct proc_ns_operations ipcns_operations;
>>   extern const struct proc_ns_operations pidns_operations;
>> +extern const struct proc_ns_operations pidns_id_operations;
>>   extern const struct proc_ns_operations pidns_for_children_operations;
>>   extern const struct proc_ns_operations userns_operations;
>>   extern const struct proc_ns_operations mntns_operations;
>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>> index a78186d..574349a 100644
>> --- a/include/linux/syscalls.h
>> +++ b/include/linux/syscalls.h
>> @@ -901,6 +901,7 @@ asmlinkage long sys_open_by_handle_at(int mountdirfd,
>>   				      struct file_handle __user *handle,
>>   				      int flags);
>>   asmlinkage long sys_setns(int fd, int nstype);
>> +asmlinkage long sys_translate_pid(pid_t pid, u64 source, u64 target);
>>   asmlinkage long sys_process_vm_readv(pid_t pid,
>>   				     const struct iovec __user *lvec,
>>   				     unsigned long liovcnt,
>> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
>> index 0b53eef..ff83aa8 100644
>> --- a/kernel/pid_namespace.c
>> +++ b/kernel/pid_namespace.c
>> @@ -22,6 +22,12 @@
>>   #include <linux/sched/task.h>
>>   #include <linux/sched/signal.h>
>>   #include <linux/idr.h>
>> +#include <linux/random.h>
>> +#include <linux/compat.h>
>> +
>> +#define	PID_NS_ID_HASH_BITS     9
>> +
>> +struct	hlist_bl_head *pid_ns_hash;
>>   
>>   struct pid_cache {
>>   	int nr_ids;
>> @@ -34,6 +40,13 @@ struct pid_cache {
>>   static DEFINE_MUTEX(pid_caches_mutex);
>>   static struct kmem_cache *pid_ns_cachep;
>>   
>> +static inline struct hlist_bl_head *
>> +	pid_ns_hash_head(struct hlist_bl_head *hash,
>> +			 uint64_t key)
>> +{
>> +	return &hash[hash_64(key, PID_NS_ID_HASH_BITS)];
>> +}
>> +
>>   /*
>>    * creates the kmem cache to allocate pids from.
>>    * @nr_ids: the number of numerical ids this pid will have to carry
>> @@ -93,12 +106,24 @@ static void dec_pid_namespaces(struct ucounts *ucounts)
>>   	dec_ucount(ucounts, UCOUNT_PID_NAMESPACES);
>>   }
>>   
>> +static inline u64 get_namespace_id(void)
>> +{
>> +	u64 id = 0;
>> +
>> +	while (!id)
>> +		get_random_bytes(&id, sizeof(id));
>> +
>> +	return id;
>> +}
>> +
>>   static struct pid_namespace *create_pid_namespace(struct user_namespace *user_ns,
>>   	struct pid_namespace *parent_pid_ns)
>>   {
>> -	struct pid_namespace *ns;
>> -	unsigned int level = parent_pid_ns->level + 1;
>> +	struct pid_namespace *ns, *pt;
>>   	struct ucounts *ucounts;
>> +	struct hlist_bl_head *head;
>> +	struct hlist_bl_node *dup_node;
>> +	unsigned int level = parent_pid_ns->level + 1;
>>   	int err;
>>   
>>   	err = -EINVAL;
>> @@ -135,7 +160,24 @@ static struct pid_namespace *create_pid_namespace(struct user_namespace *user_ns
>>   	ns->ucounts = ucounts;
>>   	ns->pid_allocated = PIDNS_ADDING;
>>   	INIT_WORK(&ns->proc_work, proc_cleanup_work);
>> -
>> +	ns->ns.ns_id = get_namespace_id();
>> +	while (1) {
>> +		head = pid_ns_hash_head(pid_ns_hash, ns->ns.ns_id);
>> +		hlist_bl_lock(head);
>> +		hlist_bl_for_each_entry(pt, dup_node, head, node) {
>> +			if (ns->ns.ns_id == pt->ns.ns_id) {
>> +				/*
>> +				 * ID is taken. Move to next ID;
>> +				 */
>> +				ns->ns.ns_id = get_namespace_id();
>> +				hlist_bl_unlock(head);
>> +				continue;
>> +			}
>> +		}
>> +		break;
>> +	}
>> +	hlist_bl_add_head(&ns->node, head);
>> +	hlist_bl_unlock(head);
>>   	return ns;
>>   
>>   out_free_idr:
>> @@ -159,6 +201,30 @@ static void delayed_free_pidns(struct rcu_head *p)
>>   
>>   static void destroy_pid_namespace(struct pid_namespace *ns)
>>   {
>> +	struct pid_namespace *ph;
>> +	struct hlist_bl_head *head;
>> +	struct hlist_bl_node *dup_node;
>> +
>> +	/*
>> +	 * Remove the namespace structure from hash table so
>> +	 * now new lookups can start on it.
>> +	 */
>> +	if (ns->ns.ns_id) {
>> +		head = pid_ns_hash_head(pid_ns_hash, ns->ns.ns_id);
>> +		hlist_bl_lock(head);
>> +		hlist_bl_for_each_entry(ph, dup_node, head, node) {
>> +			if (ns->ns.ns_id == ph->ns.ns_id) {
>> +				hlist_bl_del_init(&ph->node);
>> +				break;
>> +			}
>> +		}
>> +		hlist_bl_unlock(head);
>> +	}
>> +	/*
>> +	 * Wait for pending lookups to complete.
>> +	 */
>> +	while (atomic_read(&ns->lookups_pending))
>> +		cpu_relax();
>>   	ns_free_inum(&ns->ns);
>>   
>>   	idr_destroy(&ns->idr);
>> @@ -463,6 +529,17 @@ static struct user_namespace *pidns_owner(struct ns_common *ns)
>>   	.get_parent	= pidns_get_parent,
>>   };
>>   
>> +const struct proc_ns_operations pidns_id_operations = {
>> +	.name		= "pidns_id",
>> +	.real_ns_name	= "pid",
>> +	.type		= CLONE_NEWPID,
>> +	.get		= pidns_get,
>> +	.put		= pidns_put,
>> +	.install	= pidns_install,
>> +	.owner		= pidns_owner,
>> +	.get_parent	= pidns_get_parent,
>> +};
>> +
>>   const struct proc_ns_operations pidns_for_children_operations = {
>>   	.name		= "pid_for_children",
>>   	.real_ns_name	= "pid",
>> @@ -474,9 +551,116 @@ static struct user_namespace *pidns_owner(struct ns_common *ns)
>>   	.get_parent	= pidns_get_parent,
>>   };
>>   
>> +/*
>> + * translate_pid - convert pid in source pid-ns into target pid-ns.
>> + * @pid: pid for translation
>> + * @source: pid-ns id
>> + * @target: pid-ns id
>> + *
>> + * Return pid in @target pid-ns, zero if task have no pid there,
>> + * or -ESRCH of task with @pid is not found in @source pid-ns.
>> + */
>> +SYSCALL_DEFINE3(translate_pid, pid_t, pid, u64, source,
>> +		u64, target)
>> +{
>> +	struct pid_namespace *source_ns = NULL, *target_ns = NULL;
>> +	struct pid *struct_pid;
>> +	struct pid_namespace *ph;
>> +	struct hlist_bl_head *shead = NULL;
>> +	struct hlist_bl_head *thead = NULL;
>> +	struct hlist_bl_node *dup_node;
>> +	pid_t result;
>> +
>> +	if (!source) {
>> +		source_ns = &init_pid_ns;
>> +	} else {
>> +		shead = pid_ns_hash_head(pid_ns_hash, source);
>> +		hlist_bl_lock(shead);
>> +		hlist_bl_for_each_entry(ph, dup_node, shead, node) {
>> +			if (source == ph->ns.ns_id) {
>> +				source_ns = ph;
>> +				break;
>> +			}
>> +		}
>> +		if (!source_ns) {
>> +			hlist_bl_unlock(shead);
>> +			return -EINVAL;
>> +		}
>> +	}
>> +	if (!ptrace_may_access(source_ns->child_reaper,
>> +			       PTRACE_MODE_READ_FSCREDS)) {
>> +		if (shead)
>> +			hlist_bl_unlock(shead);
>> +		return -EPERM;
>> +	}
>> +
>> +	atomic_inc(&source_ns->lookups_pending);
>> +	if (shead)
>> +		hlist_bl_unlock(shead);
>> +
>> +	if (!target) {
>> +		target_ns = &init_pid_ns;
>> +	} else {
>> +		thead = pid_ns_hash_head(pid_ns_hash, target);
>> +		hlist_bl_lock(thead);
>> +		hlist_bl_for_each_entry(ph, dup_node, thead, node) {
>> +			if (target == ph->ns.ns_id) {
>> +				target_ns = ph;
>> +				break;
>> +			}
>> +		}
>> +		if (!target_ns) {
>> +			atomic_dec(&source_ns->lookups_pending);
>> +			hlist_bl_unlock(thead);
>> +			return -EINVAL;
>> +		}
>> +	}
>> +	if (!ptrace_may_access(target_ns->child_reaper,
>> +			       PTRACE_MODE_READ_FSCREDS)) {
>> +		atomic_dec(&source_ns->lookups_pending);
>> +		if (thead)
>> +			hlist_bl_unlock(thead);
>> +		return -EPERM;
>> +	}
>> +	atomic_inc(&target_ns->lookups_pending);
>> +	if (thead)
>> +		hlist_bl_unlock(thead);
>> +
>> +	rcu_read_lock();
>> +	struct_pid = find_pid_ns(pid, source_ns);
>> +	result = struct_pid ? pid_nr_ns(struct_pid, target_ns) : -ESRCH;
>> +	rcu_read_unlock();
>> +	atomic_dec(&source_ns->lookups_pending);
>> +	atomic_dec(&target_ns->lookups_pending);
>> +	return result;
>> +}
>> +
>> +#ifdef	CONFIG_COMPAT
>> +COMPAT_SYSCALL_DEFINE5(translate_pid, pid_t, pid, u32, s0, u32, s1,
>> +		       u32, t0, u32, t1)
>> +{
>> +#ifdef __BIG_ENDIAN
>> +	return sys_translate_pid(pid, ((u64)s0 << 32) | s1,
>> +				 ((u64)t0 << 32) | t1);
>> +#else
>> +	return sys_translate_pid(pid, ((u64)s1 << 32) | s0,
>> +				 ((u64)t1 << 32) | t0);
>> +#endif
>> +}
>> +#endif
>> +
>>   static __init int pid_namespaces_init(void)
>>   {
>> +	unsigned long bucket_count;
>> +	int i;
>> +
>> +	bucket_count = (1UL << PID_NS_ID_HASH_BITS);
>>   	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
>> +	pid_ns_hash = kmalloc_array(bucket_count, sizeof(struct hlist_bl_head),
>> +				    GFP_KERNEL);
>> +
>> +	for (i = 0; i < bucket_count; i++)
>> +		INIT_HLIST_BL_HEAD(&pid_ns_hash[i]);
>>   
>>   #ifdef CONFIG_CHECKPOINT_RESTORE
>>   	register_sysctl_paths(kern_path, pid_ns_ctl_table);
>> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
>> index b518976..467255f 100644
>> --- a/kernel/sys_ni.c
>> +++ b/kernel/sys_ni.c
>> @@ -259,3 +259,7 @@ asmlinkage long sys_ni_syscall(void)
>>   cond_syscall(sys_pkey_mprotect);
>>   cond_syscall(sys_pkey_alloc);
>>   cond_syscall(sys_pkey_free);
>> +
>> +/* pid translation */
>> +cond_syscall(sys_translate_pid);
>> +cond_syscall(compat_sys_translate_pid);
