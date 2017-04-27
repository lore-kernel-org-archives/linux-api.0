From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v3] pid_ns: Introduce ioctl to set vector of ns_last_pid's
 on ns hierarhy
Date: Thu, 27 Apr 2017 18:52:36 +0300
Message-ID: <12a73543-79ea-4bac-7e96-6ab237534af2@virtuozzo.com>
References: <149329634856.21195.14196911999722279118.stgit@localhost.localdomain>
 <87mvb16fv7.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87mvb16fv7.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 27.04.2017 18:15, Eric W. Biederman wrote:
> Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:
> 
>> On implementing of nested pid namespaces support in CRIU
>> (checkpoint-restore in userspace tool) we run into
>> the situation, that it's impossible to create a task with
>> specific NSpid effectively. After commit 49f4d8b93ccf
>> "pidns: Capture the user namespace and filter ns_last_pid"
>> it is impossible to set ns_last_pid on any pid namespace,
>> except task's active pid_ns (before the commit it was possible
>> to write to pid_ns_for_children). Thus, if a restored task
>> in a container has more than one pid_ns levels, the restorer
>> code must have a task helper for every pid namespace
>> of the task's pid_ns hierarhy.
>>
>> This is a big problem, because of communication with
>> a helper for every pid_ns in the hierarchy is not cheap.
>> It's not performance-good as it implies many helpers wakeups
>> to create a single task (independently, how you communicate
>> with the helpers). This patch tries to decide the problem.
> 
> I see the problem and we definitely need to do something.
> Your patch does appear better than what we have been doing.
> So a tenative conceptual ack.
> 
> At the same time it is legitimate to claim that the use of
> task_active_pid_ns(current) rather than
> current->nsproxy->pid_ns_for_children is a regression caused by the
> above commit.  So we can fix the original issue as well.
> 
> I do have to ask when was this problem discovered, and why did it take
> so long to discover?  The regeression happened nearly 5 years ago.
> 
> Was CRIU already using this?

CRIU uses ns_last_pid, but we never had nested pid namespace hierarchy.
When there is only one level of pid namespaces, then active pid namespace
is the save as pid_ns_for_children, so we never faced with this problem.

Now we're working on Docker support, and its recent versions create nested
pid namespaces (I have no information, when they begun to do that). So,
we met this problem.
 
> It looks like the fix is a one line low danger change to
> /proc/sys/kernel/ns_last_pid.  With a low danger as pid_ns_for_children
> rarely differs from task_active_pid_ns().
> 
> 
>> It introduces a new pid_ns ioctl(NS_SET_LAST_PID_VEC),
>> which allows to write a vector of last pids on pid_ns hierarchy.
>> The vector is passed as array of pids in struct ns_ioc_pid_vec,
>> written in reverse order. The first number corresponds to
>> the opened namespace ns_last_pid, the second is to its parent, etc.
>> So, if you have the pid namespaces hierarchy like:
>>
>> pid_ns1 (grand father)
>>   |
>>   v
>> pid_ns2 (father)
>>   |
>>   v
>> pid_ns3 (child)
>>
>> and the pid_ns3 is open, then the corresponding vector will be
>> {last_ns_pid3, last_ns_pid2, last_ns_pid1}. This vector may be
>> short and it may contain less levels. For example,
>> {last_ns_pid3, last_ns_pid2} or even {last_ns_pid3}, in dependence
>> of which levels you want to populate.
>>
>> v3: Use __u32 in uapi instead of unsigned int.
>>
>> v2: Kill pid_ns->child_reaper check as it's impossible to have
>> such a pid namespace file open.
>> Use generic namespaces ioctl() number.
>> Pass pids as array, not as a string.
>>
>> Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
>> ---
>>  fs/nsfs.c                     |    5 +++++
>>  include/linux/pid_namespace.h |   12 ++++++++++++
>>  include/uapi/linux/nsfs.h     |    7 +++++++
>>  kernel/pid_namespace.c        |   35 +++++++++++++++++++++++++++++++++++
>>  4 files changed, 59 insertions(+)
>>
>> diff --git a/fs/nsfs.c b/fs/nsfs.c
>> index 323f492e0822..f669a1552003 100644
>> --- a/fs/nsfs.c
>> +++ b/fs/nsfs.c
>> @@ -6,6 +6,7 @@
>>  #include <linux/ktime.h>
>>  #include <linux/seq_file.h>
>>  #include <linux/user_namespace.h>
>> +#include <linux/pid_namespace.h>
>>  #include <linux/nsfs.h>
>>  #include <linux/uaccess.h>
>>  
>> @@ -186,6 +187,10 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
>>  		argp = (uid_t __user *) arg;
>>  		uid = from_kuid_munged(current_user_ns(), user_ns->owner);
>>  		return put_user(uid, argp);
>> +	case NS_SET_LAST_PID_VEC:
>> +		if (ns->ops->type != CLONE_NEWPID)
>> +			return -EINVAL;
>> +		return pidns_set_last_pid_vec(ns, (void *)arg);
>>  	default:
>>  		return -ENOTTY;
>>  	}
>> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
>> index c2a989dee876..c8dc4173a4e8 100644
>> --- a/include/linux/pid_namespace.h
>> +++ b/include/linux/pid_namespace.h
>> @@ -9,6 +9,7 @@
>>  #include <linux/nsproxy.h>
>>  #include <linux/kref.h>
>>  #include <linux/ns_common.h>
>> +#include <uapi/linux/nsfs.h>
> 
> No need for the extra include and slowing down the build. Just
> declare the relevant structures.

So, I'll write just:

struct ns_ioc_pid_vec;

instead of that.

>>  
>>  struct pidmap {
>>         atomic_t nr_free;
>> @@ -103,6 +104,17 @@ static inline int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
>>  }
>>  #endif /* CONFIG_PID_NS */
>>  
>> +#if defined(CONFIG_PID_NS) && defined(CONFIG_CHECKPOINT_RESTORE)
>> +extern long pidns_set_last_pid_vec(struct ns_common *ns,
>> +				   struct ns_ioc_pid_vec __user *vec);
>> +#else /* CONFIG_PID_NS && CONFIG_CHECKPOINT_RESTORE */
>> +static inline long pidns_set_last_pid_vec(struct ns_common *ns,
>> +					  struct ns_ioc_pid_vec __user *vec)
>> +{
>> +	return -ENOTTY;
>> +}
>> +#endif /* CONFIG_PID_NS && CONFIG_CHECKPOINT_RESTORE */
> 
> Just CONFIG_PID_NS please.  Either this is good enough for everyone who
> has pid namespace support enabled or it isn't.

Great, if it's so. For me it looks better too.
 
>>  extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
>>  void pidhash_init(void);
>>  void pidmap_init(void);
>> diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
>> index 1a3ca79f466b..1254b02a47fa 100644
>> --- a/include/uapi/linux/nsfs.h
>> +++ b/include/uapi/linux/nsfs.h
>> @@ -14,5 +14,12 @@
>>  #define NS_GET_NSTYPE		_IO(NSIO, 0x3)
>>  /* Get owner UID (in the caller's user namespace) for a user namespace */
>>  #define NS_GET_OWNER_UID	_IO(NSIO, 0x4)
>> +/* Set a vector of ns_last_pid for a pid namespace stack */
>> +#define NS_SET_LAST_PID_VEC	_IO(NSIO, 0x5)
>> +
>> +struct ns_ioc_pid_vec {
>> +	__u32	nr;
>> +	pid_t	pid[0];
>> +};
>>  
>>  #endif /* __LINUX_NSFS_H */
>> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
>> index de461aa0bf9a..08b5fef23534 100644
>> --- a/kernel/pid_namespace.c
>> +++ b/kernel/pid_namespace.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/export.h>
>>  #include <linux/sched/task.h>
>>  #include <linux/sched/signal.h>
>> +#include <uapi/linux/nsfs.h>
>>  
>>  struct pid_cache {
>>  	int nr_ids;
>> @@ -428,6 +429,40 @@ static struct ns_common *pidns_get_parent(struct ns_common *ns)
>>  	return &get_pid_ns(pid_ns)->ns;
>>  }
>>  
>> +#ifdef CONFIG_CHECKPOINT_RESTORE
>> +long pidns_set_last_pid_vec(struct ns_common *ns,
>> +			    struct ns_ioc_pid_vec __user *vec)
>> +{
>> +	struct pid_namespace *pid_ns = to_pid_ns(ns);
>> +	pid_t pid, __user *pid_ptr;
>> +	u32 nr;
>> +
>> +	if (get_user(nr, &vec->nr))
>> +		return -EFAULT;
>> +	if (nr > 32 || nr < 1)
> 
> The maximum needs not to be hard coded.

Ah, I've missed MAX_PID_NS_LEVEL, thanks. 

>> +		return -EINVAL;
>> +
>> +	pid_ptr = &vec->pid[0];
> 
> All of the rest of the vector needs to be read in, in one go.

Hm, Oleg said we shouldn't allocate a memory for that. Should
I create array of MAX_PID_NS_LEVEL pids on stack?

>> +	do {
>> +		if (!ns_capable(pid_ns->user_ns, CAP_SYS_ADMIN))
>> +			return -EPERM;
> 
> Permission to change all of the namespaces should be checked before
> writing to pid_ns->last_pid happens.

Ok

>> +
>> +		if (get_user(pid, pid_ptr))
>> +			return -EFAULT;
>> +		if (pid < 0 || pid > pid_max)
>> +			return -EINVAL;
>> +
>> +		/* Write directly: see the comment in pid_ns_ctl_handler() */
>> +		pid_ns->last_pid = pid;
>> +
>> +		pid_ns = pid_ns->parent;
>> +		pid_ptr++;
>> +	} while (--nr > 0 && pid_ns);
>> +
>> +	return nr ? -EINVAL : 0;
>> +}
>> +#endif	/* CONFIG_CHECKPOINT_RESTORE */
>> +
>>  static struct user_namespace *pidns_owner(struct ns_common *ns)
>>  {
>>  	return to_pid_ns(ns)->user_ns;
