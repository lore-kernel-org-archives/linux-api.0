From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [PATCH RFC] pidns: introduce syscall getvpid
Date: Tue, 15 Sep 2015 18:51:38 +0300
Message-ID: <55F83E8A.2040908@yandex-team.ru>
References: <20150915120924.14818.49490.stgit@buzz>
 <87h9mvg3kw.fsf@x220.int.ebiederm.org> <55F832D2.1070605@yandex-team.ru>
 <20150915151729.GA144242@dakara>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150915151729.GA144242@dakara>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 15.09.2015 18:17, St=E9phane Graber wrote:
> On Tue, Sep 15, 2015 at 06:01:38PM +0300, Konstantin Khlebnikov wrote=
:
>> On 15.09.2015 17:27, Eric W. Biederman wrote:
>>> Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> writes:
>>>
>>>> pid_t getvpid(pid_t pid, pid_t source, pid_t target);
>>>>
>>>> This syscall converts pid from one pid-ns into pid in another pid-=
ns:
>>>> it takes @pid in namespace of @source task (zero for current) and
>>>> returns related pid in namespace of @target task (zero for current=
 too).
>>>> If pid is unreachable from target pid-ns then it returns zero.
>>>
>>> This interface as presented is inherently racy.  It would be better
>>> if source and target were file descriptors referring to the namespa=
ces
>>> you wish to translate between.
>>
>> Yep, it's racy. As well as any operation with non-child pids.
>> With file descriptors for source/target result will be racy anyway.
>>
>>>
>>>> Such conversion is required for interaction between processes from
>>>> different pid-namespaces. For example when system service talks wi=
th
>>>> client from isolated container via socket about task in container:
>>>
>>> Sockets are already supported.  At least the metadata of sockets is=
=2E
>>>
>>> Maybe we need this but I am not convinced of it's utility.
>>>
>>> What are you trying to do that motivates this?
>>
>> I'm working on hierarchical container management system which
>> allows to create and control nested sub-containers from containers
>> ( https://github.com/yandex/porto ). Main server works in host and
>> have to interact with all levels of nested namespaces. This syscall
>> makes some operations much easier: server must remember only pid in
>> host pid namespace and convert it into right vpid on demand.
>
> Note that as Eric said earlier, sending a PID inside a ucred through =
a
> unix socket will have the pid translated.

We are using this already: clients in container connect to unix-socket
binded in host net-ns and bind-mounted into container =3D)
Server identifies them by pid from SO_PEERCRED

>
> So while your solution certainly should be faster, you can already ac=
hieve
> what you want today by doing:
>
> =3D=3D Translate PID in container to PID in host
>   - open a socket
>   - setns to container's pidns
>   - send ucred from that container containing the requested container=
 PID
>   - host sees the host PID
>

That's funny. But setns isn't enough,
task have to fork into pid-namespace.

> =3D=3D Translate PID on host to PID in container
>   - open a socket
>   - setns to container's pidns
>   - send ucred from the host containing the request host PID
>     (send will fail if the host PID isn't part of that container)
>   - container sees the container PID
>
>>
>>>
>>> Eric
>>>
>>>
>>>> getvpid(pid, client_pid, 0)  -> pid in our pid namespace
>>>> getvpid(pid, 0, client_pid)  -> pid in client pid namespace
>>>>
>>>> Also service can get pid of init task and match it with container:
>>>>
>>>> getvpid(1, client_pid, 0)    -> pid of init task for client_pid
>>>>
>>>> Seems like gdb and strace could use this too for converting pids o=
f
>>>> newly forked tasks (IIRR they get pid from %rax) into pid from
>>>> correct namespace for further interaction.
>>>>
>>>> As a bonus syscall getvpid can compare pid namespaces and
>>>> test isolation without mounted procfs:
>>>>
>>>> getvpid(1, 0, pid) =3D=3D 0      -> pid in our sub-pid-namespace
>>>> getvpid(1, 0, pid) =3D=3D 1      -> pid in our pid-namespace
>>>> getvpid(1, pid1, pid2) =3D=3D 0  -> pid1 isolated from pid2
>>>> getvpid(1, pid1, pid2) =3D=3D 1  -> tasks are in one pid-namespace
>>>> getvpid(1, pid1, pid2) > 1   -> pid1 is in sub-pidns of pid2
>>>>
>>>> Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
>>>> ---
>>>>   arch/x86/entry/syscalls/syscall_32.tbl |    1 +
>>>>   arch/x86/entry/syscalls/syscall_64.tbl |    1 +
>>>>   include/linux/syscalls.h               |    1 +
>>>>   kernel/pid.c                           |   36 ++++++++++++++++++=
++++++++++++++
>>>>   4 files changed, 39 insertions(+)
>>>>
>>>> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/ent=
ry/syscalls/syscall_32.tbl
>>>> index 7663c455b9f6..dadb55d42fc9 100644
>>>> --- a/arch/x86/entry/syscalls/syscall_32.tbl
>>>> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
>>>> @@ -382,3 +382,4 @@
>>>>   373	i386	shutdown		sys_shutdown
>>>>   374	i386	userfaultfd		sys_userfaultfd
>>>>   375	i386	membarrier		sys_membarrier
>>>> +376	i386	getvpid			sys_getvpid
>>>> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/ent=
ry/syscalls/syscall_64.tbl
>>>> index 278842fdf1f6..0338f2eb3b7c 100644
>>>> --- a/arch/x86/entry/syscalls/syscall_64.tbl
>>>> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
>>>> @@ -331,6 +331,7 @@
>>>>   322	64	execveat		stub_execveat
>>>>   323	common	userfaultfd		sys_userfaultfd
>>>>   324	common	membarrier		sys_membarrier
>>>> +325	common	getvpid			sys_getvpid
>>>>
>>>>   #
>>>>   # x32-specific system call numbers start at 512 to avoid cache i=
mpact
>>>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>>>> index a460e2ef2843..3405c30999e3 100644
>>>> --- a/include/linux/syscalls.h
>>>> +++ b/include/linux/syscalls.h
>>>> @@ -222,6 +222,7 @@ asmlinkage long sys_nanosleep(struct timespec =
__user *rqtp, struct timespec __us
>>>>   asmlinkage long sys_alarm(unsigned int seconds);
>>>>   asmlinkage long sys_getpid(void);
>>>>   asmlinkage long sys_getppid(void);
>>>> +asmlinkage long sys_getvpid(pid_t pid, pid_t source, pid_t target=
);
>>>>   asmlinkage long sys_getuid(void);
>>>>   asmlinkage long sys_geteuid(void);
>>>>   asmlinkage long sys_getgid(void);
>>>> diff --git a/kernel/pid.c b/kernel/pid.c
>>>> index ca368793808e..caa676ff7364 100644
>>>> --- a/kernel/pid.c
>>>> +++ b/kernel/pid.c
>>>> @@ -567,6 +567,42 @@ struct pid *find_ge_pid(int nr, struct pid_na=
mespace *ns)
>>>>   	return pid;
>>>>   }
>>>>
>>>> +/**
>>>> + * sys_getvpid - convert pid from one pid-namespace into pid from=
 another
>>>> + *
>>>> + * @pid    - pid of requested task
>>>> + * @source - pid of task in source pid-namespace, zero for curren=
t
>>>> + * @target - pid of task in target pid-namespace, zero for curren=
t
>>>> + *
>>>> + * Returns pid from target pid-ns or zero if pid is unreachable.
>>>> + * Returns -ESRCH if some of pids are not found.
>>>> + */
>>>> +SYSCALL_DEFINE3(getvpid, pid_t, pid, pid_t, source, pid_t, target=
)
>>>> +{
>>>> +#ifdef CONFIG_PID_NS
>>>> +	struct pid_namespace *current_ns =3D task_active_pid_ns(current)=
;
>>>> +	struct pid_namespace *source_ns =3D current_ns, *target_ns =3D c=
urrent_ns;
>>>> +	struct pid *task_pid;
>>>> +	pid_t result =3D -ESRCH;
>>>> +
>>>> +	rcu_read_lock();
>>>> +	if (source)
>>>> +		source_ns =3D ns_of_pid(find_pid_ns(source, current_ns));
>>>> +	if (target)
>>>> +		target_ns =3D ns_of_pid(find_pid_ns(target, current_ns));
>>>> +	if (source_ns && target_ns) {
>>>> +		task_pid =3D find_pid_ns(pid, source_ns);
>>>> +		if (task_pid)
>>>> +			result =3D pid_nr_ns(task_pid, target_ns);
>>>> +	}
>>>> +	rcu_read_unlock();
>>>> +
>>>> +	return result;
>>>> +#else
>>>> +	return pid;
>>>> +#endif /* CONFIG_PID_NS */
>>>> +}
>>>> +
>>>>   /*
>>>>    * The pid hash table is scaled according to the amount of memor=
y in the
>>>>    * machine.  From a minimum of 16 slots up to 4096 slots at one =
gigabyte or
>>
>>
>> --
>> Konstantin
>> _______________________________________________
>> Containers mailing list
>> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
>> https://lists.linuxfoundation.org/mailman/listinfo/containers
>


--=20
Konstantin
