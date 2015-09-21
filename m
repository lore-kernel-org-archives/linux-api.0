From: Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: Re: [PATCH RFC] pidns: introduce syscall getvpid
Date: Mon, 21 Sep 2015 10:49:39 +0800
Message-ID: <55FF7043.5020701@cn.fujitsu.com>
References: <20150915120924.14818.49490.stgit@buzz> <87h9mvg3kw.fsf@x220.int.ebiederm.org> <55F832D2.1070605@yandex-team.ru> <20150915151729.GA144242@dakara> <20150915174143.GE4699@ubuntumail> <55F91C3D.1040209@yandex-team.ru> <20150916143939.GA32226@mail.hallyn.com> <87twquzag1.fsf@x220.int.ebiederm.org> <20150916163123.GA1039@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150916163123.GA1039-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, =?windows-1252?Q?St=E9phane_Graber?= <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org


On 09/17/2015 12:31 AM, Serge E. Hallyn wrote:
> On Wed, Sep 16, 2015 at 09:49:02AM -0500, Eric W. Biederman wrote:
>> "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:
>>
>>> On Wed, Sep 16, 2015 at 10:37:33AM +0300, Konstantin Khlebnikov wro=
te:
>>>> On 15.09.2015 20:41, Serge Hallyn wrote:
>>>>> Quoting St=E9phane Graber (stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org):
>>>>>> On Tue, Sep 15, 2015 at 06:01:38PM +0300, Konstantin Khlebnikov =
wrote:
>>>>>>> On 15.09.2015 17:27, Eric W. Biederman wrote:
>>>>>>>> Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> writes:
>>>>>>>>
>>>>>>>>> pid_t getvpid(pid_t pid, pid_t source, pid_t target);
>>>>>>>>>
>>>>>>>>> This syscall converts pid from one pid-ns into pid in another=
 pid-ns:
>>>>>>>>> it takes @pid in namespace of @source task (zero for current)=
 and
>>>>>>>>> returns related pid in namespace of @target task (zero for cu=
rrent too).
>>>>>>>>> If pid is unreachable from target pid-ns then it returns zero=
=2E
>>>>>>>> This interface as presented is inherently racy.  It would be b=
etter
>>>>>>>> if source and target were file descriptors referring to the na=
mespaces
>>>>>>>> you wish to translate between.
>>>>>>> Yep, it's racy. As well as any operation with non-child pids.
>>>>>>> With file descriptors for source/target result will be racy any=
way.
>>>>>>>
>>>>>>>>> Such conversion is required for interaction between processes=
 from
>>>>>>>>> different pid-namespaces. For example when system service tal=
ks with
>>>>>>>>> client from isolated container via socket about task in conta=
iner:
>>>>>>>> Sockets are already supported.  At least the metadata of socke=
ts is.
>>>>>>>>
>>>>>>>> Maybe we need this but I am not convinced of it's utility.
>>>>>>>>
>>>>>>>> What are you trying to do that motivates this?
>>>>>>> I'm working on hierarchical container management system which
>>>>>>> allows to create and control nested sub-containers from contain=
ers
>>>>>>> ( https://github.com/yandex/porto ). Main server works in host =
and
>>>>>>> have to interact with all levels of nested namespaces. This sys=
call
>>>>>>> makes some operations much easier: server must remember only pi=
d in
>>>>>>> host pid namespace and convert it into right vpid on demand.
>>>>>> Note that as Eric said earlier, sending a PID inside a ucred thr=
ough a
>>>>>> unix socket will have the pid translated.
>>>>>>
>>>>>> So while your solution certainly should be faster, you can alrea=
dy achieve
>>>>>> what you want today by doing:
>>>>>>
>>>>>> =3D=3D Translate PID in container to PID in host
>>>>>>   - open a socket
>>>>>>   - setns to container's pidns
>>>>>>   - send ucred from that container containing the requested cont=
ainer PID
>>>>>>   - host sees the host PID
>>>>>>
>>>>>> =3D=3D Translate PID on host to PID in container
>>>>>>   - open a socket
>>>>>>   - setns to container's pidns
>>>>>>   - send ucred from the host containing the request host PID
>>>>>>     (send will fail if the host PID isn't part of that container=
)
>>>>>>   - container sees the container PID
>>>>> In addition, since commit e4bc332451 : /proc/PID/status: show all=
 sets of pid according to ns
>>>>> we now also have 'NSpid' etc in /proc/$$/status.
>>>>>
>>>> As I see this works perfectly only for converting host pid into vi=
rtual.
>>>>
>>>> Backward conversion is troublesome: we have to scan all pids in ho=
st
>>>> procfs and somehow filter tasks from container and its sub-pid-ns.
>>>> Or I am missing something trivial?
>>> Ah, no that doesn't help with this.
>>>
>>> What St=E9phane describes is what I've done in several projects.
>>> Getting it right is however actually quite tricky.  I'm not
>>> convinced it's at the level of "since you can do (sweep hands)
>>> all this, we don't need a simple syscall to do it."
>>>
>>> So I'd encourage you to resend using namespace inode fds for
>>> source and target as Eric suggested.  We still may decide that
>>> the syscall isn't needed, but it's a trivial change to your
>>> patch and removes that race.  And I'm not convinced it's not
>>> needed.
>> At this point my primary concern is that a pattern that would need t=
o be
>> convering to and from pids quickly is potentially fundamentally racy=
 to
>> the point of broken.
> The cgmanager GetTasks and GetTasksRecursive, and reading of the
> lxcfs cgroup /tasks files, require converting every pid from the
> cgmanager's namespace to the reading task's namespace.
>
>> Especially with unix domain sockets passing and converting pids in a=
 way
>> that covers the common case.
>>
>> I am clearly missing some nuance of this use case.
> lxcfs and cgmanager are imo proof that we *can* do without the new
> syscall.  However, the git history will show that there are some
> complications, and the system load when a few systemds are starting
> will show that it does take a performance toll on the host at some
> point.  Still as I say it's doable.  The syscall implementation was
> very simple, though.

Yes, previous email discussed about the implementation of syscall or pr=
ocfs:
http://www.gossamer-threads.com/lists/linux/kernel/1971723?search_strin=
g=3Dchen%20hanxiao;#1971723

but it seems complicated implemented by procfs, the original discussion=
 at:
http://www.gossamer-threads.com/lists/linux/kernel/2076440?search_strin=
g=3Dchen%20hanxiao;#2076440

Thanks,
Chen

>
> -serge
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> .
>
