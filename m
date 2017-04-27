From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 2/2] pid_ns: Introduce ioctl to set vector of ns_last_pid's on ns hierarhy
Date: Thu, 27 Apr 2017 11:39:44 -0500
Message-ID: <87o9vhztwv.fsf@xmission.com>
References: <149245014695.17600.12640895883798122726.stgit@localhost.localdomain>
        <149245057248.17600.1341652606136269734.stgit@localhost.localdomain>
        <20170426155352.GA12131@redhat.com>
        <785e1986-da03-72aa-06c0-234ed2dbc0fd@virtuozzo.com>
        <20170427161255.GA19350@redhat.com>
        <fdd61d9c-6f88-1669-4d12-31748395fe99@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fdd61d9c-6f88-1669-4d12-31748395fe99-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> (Kirill
        Tkhai's message of "Thu, 27 Apr 2017 19:17:51 +0300")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:

> On 27.04.2017 19:12, Oleg Nesterov wrote:
>> On 04/26, Kirill Tkhai wrote:
>>>
>>> On 26.04.2017 18:53, Oleg Nesterov wrote:
>>>>
>>>>> +static long set_last_pid_vec(struct pid_namespace *pid_ns,
>>>>> +			     struct pidns_ioc_req *req)
>>>>> +{
>>>>> +	char *str, *p;
>>>>> +	int ret = 0;
>>>>> +	pid_t pid;
>>>>> +
>>>>> +	read_lock(&tasklist_lock);
>>>>> +	if (!pid_ns->child_reaper)
>>>>> +		ret = -EINVAL;
>>>>> +	read_unlock(&tasklist_lock);
>>>>> +	if (ret)
>>>>> +		return ret;
>>>>
>>>> why do you need to check ->child_reaper under tasklist_lock? this looks pointless.
>>>>
>>>> In fact I do not understand how it is possible to hit pid_ns->child_reaper == NULL,
>>>> there must be at least one task in this namespace, otherwise you can't open a file
>>>> which has f_op == ns_file_operations, no?
>>>
>>> Sure, it's impossible to pick a pid_ns, if there is no the pid_ns's tasks. I added
>>> it under impression of
>>> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=dfda351c729733a401981e8738ce497eaffcaa00
>>> but here it's completely wrong. It will be removed in v2.
>> 
>> Hmm. But if I read this commit correctly then we really need to check
>> pid_ns->child_reaper != NULL ?
>> 
>> Currently we can't pick an "empty" pid_ns. But after the commit above a task
>> can do sys_unshare(CLONE_NEWPID), another (or the same) task can open its
>> /proc/$pid/ns/pid_for_children and call ns_ioctl() before the 1st alloc_pid() ?
>
> Another task can't open /proc/$pid/ns/pid_for_children before the 1st alloc_pid(),
> because pid_for_children is available to open only after the 1st alloc_pid().
> So, it's impossible to call ioctl() on it.

That sounds reasonable.

There is definitely the chance of the child_reaper dying after we have
joined a pid namespace.    So child_reaper can be stale if not NULL.

As long as we don't mess up the first pid allocation I don't
see any reason why we should care about last_pid in a pid_namespace.
And this ioctl can be used to set all of the other pids on the first
pid allocation by calling it in the parent pid namespace.

There is still the chance of racing with a pid reaper dying.   Why do we
care about child_reaper in this case?

Changing last_pid is completely pointless if child_reaper is dead or
missing but why would we care?

Although looking at it we probably want to call set_last_pid just to
be consistent with everything else.

Eric
