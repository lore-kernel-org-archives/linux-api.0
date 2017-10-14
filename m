From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [PATCH v4] pidns: introduce syscall translate_pid
Date: Sat, 14 Oct 2017 11:17:47 +0300
Message-ID: <d7b2a0b6-6d0c-5ca8-9d2b-3a1211713d34@yandex-team.ru>
References: <150788678482.924140.11785205105514746135.stgit@buzz>
 <20171013160514.GA27812@redhat.com>
 <3bdb5341-9ae6-265a-ce5b-45c2cfc76fad@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3bdb5341-9ae6-265a-ce5b-45c2cfc76fad-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Nagarathnam Muthusamy <nagarathnam.muthusamy-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 13.10.2017 19:13, Konstantin Khlebnikov wrote:
> 
> 
> On 13.10.2017 19:05, Oleg Nesterov wrote:
>> On 10/13, Konstantin Khlebnikov wrote:
>>>
>>> pid_t translate_pid(pid_t pid, int source, int target);
>>>
>>> This syscall converts pid from source pid-ns into pid in target pid-ns.
>>> If pid is unreachable from target pid-ns it returns zero.
>>>
>>> Pid-namespaces are referred file descriptors opened to proc files
>>> /proc/[pid]/ns/pid or /proc/[pid]/ns/pid_for_children. Negative argument
>>> refers to current pid namespace, same as file /proc/self/ns/pid.
>>>
>>> Kernel expose virtual pids in /proc/[pid]/status:NSpid, but backward
>>> translation requires scanning all tasks. Also pids could be translated
>>> by sending them through unix socket between namespaces, this method is
>>> slow and insecure because other side is exposed inside pid namespace.

Andrew asked why we might need this.

Such conversion is required for interaction between processes across pid-namespaces.
For example to identify process in container by pid file looking from outside.

Two years ago I've solved this in project of mine with monstrous code which
forks couple times just to convert pid, lucky for me performance wasn't important.

>>>
>>> Examples:
>>> translate_pid(pid, ns, -1)      - get pid in our pid namespace
>>> translate_pid(pid, -1, ns)      - get pid in other pid namespace
>>> translate_pid(1, ns, -1)        - get pid of init task for namespace
>>> translate_pid(pid, -1, ns) > 0  - is pid is reachable from ns?
>>> translate_pid(1, ns1, ns2) > 0  - is ns1 inside ns2?
>>> translate_pid(1, ns1, ns2) == 0 - is ns1 outside ns2?
>>> translate_pid(1, ns1, ns2) == 1 - is ns1 equal ns2?
>>
>> Add Eugene, strace probably wants this too.
>>
>> I have a vague feeling we have already discussed this in the past, but
>> I can't recall anything...
> 
> Yeah, v3 was two years ago.
> 
>>
>>> +static struct pid_namespace *get_pid_ns_by_fd(int fd)
>>> +{
>>> +    struct pid_namespace *pidns;
>>> +    struct ns_common *ns;
>>> +    struct file *file;
>>> +
>>> +    file = proc_ns_fget(fd);
>>> +    if (IS_ERR(file))
>>> +        return ERR_CAST(file);
>>> +
>>> +    ns = get_proc_ns(file_inode(file));
>>> +    if (ns->ops->type == CLONE_NEWPID)
>>> +        pidns = get_pid_ns(to_pid_ns(ns));
>>> +    else
>>> +        pidns = ERR_PTR(-EINVAL);
>>> +
>>> +    fput(file);
>>> +    return pidns;
>>> +}
>>
>> I won't insist, but this suggests we should add a new helper,
>> get_ns_by_fd_type(fd, type), and convert get_net_ns_by_fd() to use it
>> as well.
> 
> That was in v3.
> 
> I'll prefer to this later, separately. And replace fget with fdget which
> allows to do this without atomic operations if task is single-threaded.
> 
>>
>>> +SYSCALL_DEFINE3(translate_pid, pid_t, pid, int, source, int, target)
>>> +{
>>> +    struct pid_namespace *source_ns, *target_ns;
>>> +    struct pid *struct_pid;
>>> +    pid_t result;
>>> +
>>> +    if (source >= 0) {
>>> +        source_ns = get_pid_ns_by_fd(source);
>>> +        result = PTR_ERR(source_ns);
>>> +        if (IS_ERR(source_ns))
>>> +            goto err_source;
>>> +    } else
>>> +        source_ns = task_active_pid_ns(current);
>>> +
>>> +    if (target >= 0) {
>>> +        target_ns = get_pid_ns_by_fd(target);
>>> +        result = PTR_ERR(target_ns);
>>> +        if (IS_ERR(target_ns))
>>> +            goto err_target;
>>> +    } else
>>> +        target_ns = task_active_pid_ns(current);
>>> +
>>> +    rcu_read_lock();
>>> +    struct_pid = find_pid_ns(pid, source_ns);
>>> +    result = struct_pid ? pid_nr_ns(struct_pid, target_ns) : -ESRCH;
>>> +    rcu_read_unlock();
>>
>> Stupid question. Can't we make a simpler API which doesn't need /proc/ ?
>> I mean,
>>
>>     sys_translate_pid(pid_t pid, pid_t source_pid, pid_t target_pid)
>>     {
>>         struct pid_namespace *source_ns, *target_ns;
>>
>>         source_ns = task_active_pid_ns(find_task_by_vpid(source_pid));
>>         target_ns = task_active_pid_ns(find_task_by_vpid(target_pid));
>>
>>         ...
>>     }
>>  > Yes, this is more limited... Do you have a use-case when this is not enough?
> 
> That was in v1 but considered too racy.

But we could merge both ways:

source >= 0 - pidns fs
source < 0  - task_pid = -source

Then "-1" points to init task in current pidns
which obviously lives in current pidns too,
thus lookup isn't required:

if (source >= 0)
     source_ns = get_pid_ns_by_fd(source);
else if (source == -1)
     source_ns = task_active_pid_ns(current);
else
     source_ns = task_active_pid_ns(find_task_by_vpid(-source));

> 
>  >> v1: https://lkml.org/lkml/2015/9/15/411
>  >> v2: https://lkml.org/lkml/2015/9/24/278
>  >> v3: https://lkml.org/lkml/2015/9/28/3
