From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4] pidns: introduce syscall translate_pid
Date: Tue, 17 Oct 2017 15:40:17 -0700
Message-ID: <CALCETrWv5sYXvyL2mYwDK99O-awB6e2KV++oQK7Nrmgkvt9vPA@mail.gmail.com>
References: <150788678482.924140.11785205105514746135.stgit@buzz>
 <20171013160514.GA27812@redhat.com> <3bdb5341-9ae6-265a-ce5b-45c2cfc76fad@yandex-team.ru>
 <d7b2a0b6-6d0c-5ca8-9d2b-3a1211713d34@yandex-team.ru> <20171016143628.b2ef80a9ef16d4345889b4d9@linux-foundation.org>
 <fc2ae985-7ef7-0caf-4eb9-9348a5ca5e78@oracle.com> <fb03aaef-84e5-c869-11cc-6e1d8b4699c8@oracle.com>
 <CALCETrUg0xrkWnsQhq5L9RpDunrD8w7C3EjxeOPPrQv2h1KMEA@mail.gmail.com>
 <a41bbfdf-6af5-6b29-36bf-1ed677b6ca75@oracle.com> <CALCETrXXDQEddqx5yUnGtgZnv_7eDc=GAFsmUSNPV45BGxQbPw@mail.gmail.com>
 <59E685B3.1000200@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <59E685B3.1000200-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: prakash sangappa <prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nagarathnam Muthusamy <nagarathnam.muthusamy-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 17, 2017 at 3:35 PM, prakash sangappa
<prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 10/17/2017 3:02 PM, Andy Lutomirski wrote:
>>
>> On Tue, Oct 17, 2017 at 8:38 AM, Prakash Sangappa
>> <prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>>
>>>
>>> On 10/16/17 5:52 PM, Andy Lutomirski wrote:
>>>>
>>>> On Mon, Oct 16, 2017 at 3:54 PM, prakash.sangappa
>>>> <prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>>>>
>>>>>
>>>>> On 10/16/2017 03:07 PM, Nagarathnam Muthusamy wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 10/16/2017 02:36 PM, Andrew Morton wrote:
>>>>>>>
>>>>>>> On Sat, 14 Oct 2017 11:17:47 +0300 Konstantin Khlebnikov
>>>>>>> <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> wrote:
>>>>>>>
>>>>>>>>>>> pid_t translate_pid(pid_t pid, int source, int target);
>>>>>>>>>>>
>>>>>>>>>>> This syscall converts pid from source pid-ns into pid in target
>>>>>>>>>>> pid-ns.
>>>>>>>>>>> If pid is unreachable from target pid-ns it returns zero.
>>>>>>>>>>>
>>>>>>>>>>> Pid-namespaces are referred file descriptors opened to proc files
>>>>>>>>>>> /proc/[pid]/ns/pid or /proc/[pid]/ns/pid_for_children. Negative
>>>>>>>>>>> argument
>>>>>>>>>>> refers to current pid namespace, same as file /proc/self/ns/pid.
>>>>>>>>>>>
>>>>>>>>>>> Kernel expose virtual pids in /proc/[pid]/status:NSpid, but
>>>>>>>>>>> backward
>>>>>>>>>>> translation requires scanning all tasks. Also pids could be
>>>>>>>>>>> translated
>>>>>>>>>>> by sending them through unix socket between namespaces, this
>>>>>>>>>>> method
>>>>>>>>>>> is
>>>>>>>>>>> slow and insecure because other side is exposed inside pid
>>>>>>>>>>> namespace.
>>>>>>>>
>>>>>>>> Andrew asked why we might need this.
>>>>>>>>
>>>>>>>> Such conversion is required for interaction between processes across
>>>>>>>> pid-namespaces.
>>>>>>>> For example to identify process in container by pid file looking
>>>>>>>> from
>>>>>>>> outside.
>>>>>>>>
>>>>>>>> Two years ago I've solved this in project of mine with monstrous
>>>>>>>> code
>>>>>>>> which
>>>>>>>> forks couple times just to convert pid, lucky for me performance
>>>>>>>> wasn't
>>>>>>>> important.
>>>>>>>
>>>>>>> That's a single user who needed this a single time, and found a
>>>>>>> userspace-based solution anyway.  This is not exactly compelling!
>>>>>>>
>>>>>>> Is there a stronger case to be made?  How does this change benefit
>>>>>>> our
>>>>>>> users?  Sell it to us!
>>>>>>
>>>>>> Oracle database is planning to use pid namespace for sandboxing
>>>>>> database
>>>>>> instances and they need an API similar to translate_pid to effectively
>>>>>> translate process IDs from other pid namespaces. Prakash (cced in
>>>>>> mail)
>>>>>> can
>>>>>> provide more details on this usecase.
>>>>>
>>>>>
>>>>> As Nagarathnam indicated, Oracle Database will be using pid namespaces
>>>>> and
>>>>> needs a direct method of converting pids of processes in the pid
>>>>> namespace
>>>>> hierarchy. In this use case multiple
>>>>> nested PID namespaces will be used.  The currently available mechanism
>>>>> are
>>>>> not very efficient for this use case. For ex. as Konstantin described,
>>>>> using
>>>>> /proc/<pid>/status would require the application to scan all the pid's
>>>>> status files to determine the pid of given process in a child
>>>>> namespace.
>>>>>
>>>>> Use of SCM_CREDENTIALS's socket message is another way, which would
>>>>> require
>>>>> every process starting inside a pid namespace to send this message and
>>>>> the
>>>>> receiving process in the target namespace would have to save the
>>>>> converted
>>>>> pid and reference it. This mechanism becomes cumbersome especially if
>>>>> the
>>>>> application has to deal with multiple nested pid namespaces. Also, the
>>>>> Database needs to be able to convert a thread's global pid(gettid()).
>>>>> Passing the thread's pid(gettid()) in SCM_CREDENTIALS message requires
>>>>> CAP_SYS_ADMIN, which is an issue.
>>>>>
>>>>> So having a direct method, like the API that Konstantin is proposing,
>>>>> will
>>>>> work best for the Database
>>>>> since pid of a process in any of the nested pid namespaces can be
>>>>> converted
>>>>> as and when required. I think with the proposed API, the application
>>>>> should
>>>>> be able to convert pid of a process or tid(gettid()) of a thread as
>>>>> well.
>>>>>
>>>> Can you explain what Oracle's database is planning to do with this
>>>> information?
>>>
>>>
>>> Database uses the PID to programmatically find out if the process/thread
>>> is
>>> alive(kill 0) also send signals to the processes requesting it to dump
>>> status/debug information and kill the processes in case of a shutdown
>>> abort
>>> of the instance.
>>
>> What I'm wondering is: how does the caller of kill() end up
>> controlling a task whose pid it doesn't know in its own namespace?
>
>
> I was generally describing how DB would use the PID of process. The above
> description
> was in the case when no namespaces are used.
>
> With use of namespaces, the DB would convert the PID of processes inside
> its children namespaces to PID in its namespace and use that pid to issue
> kill().

Seems vaguely sensible.

If I were designing this type of system, I'd have a manager process in
each namespace running as PID 1, though -- PID 1 is special and needs
to understand what's going on anyway.  Then PID 1 would do the kill()
calls and wouldn't need translate_pid().


>
> -Prakash.
>
>>
>>> -Prakash.
>>>
>>>
>
