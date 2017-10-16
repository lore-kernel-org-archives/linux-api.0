From: Nagarathnam Muthusamy <nagarathnam.muthusamy-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] pidns: introduce syscall translate_pid
Date: Mon, 16 Oct 2017 14:05:05 -0700
Message-ID: <6bba1416-746c-0636-9c6d-d2c9d8934dc6@oracle.com>
References: <150788678482.924140.11785205105514746135.stgit@buzz>
 <20171013160514.GA27812@redhat.com>
 <3bdb5341-9ae6-265a-ce5b-45c2cfc76fad@yandex-team.ru>
 <20171016162436.GB4142@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016162436.GB4142-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 10/16/2017 09:24 AM, Oleg Nesterov wrote:
> On 10/13, Konstantin Khlebnikov wrote:
>>
>> On 13.10.2017 19:05, Oleg Nesterov wrote:
>>> I won't insist, but this suggests we should add a new helper,
>>> get_ns_by_fd_type(fd, type), and convert get_net_ns_by_fd() to use it
>>> as well.
>> That was in v3.
>>
>> I'll prefer to this later, separately. And replace fget with fdget which
>> allows to do this without atomic operations if task is single-threaded.
> OK, agreed,
>
>>> Stupid question. Can't we make a simpler API which doesn't need /proc/ ?
>>> I mean,
>>>
>>> 	sys_translate_pid(pid_t pid, pid_t source_pid, pid_t target_pid)
>>> 	{
>>> 		struct pid_namespace *source_ns, *target_ns;
>>>
>>> 		source_ns = task_active_pid_ns(find_task_by_vpid(source_pid));
>>> 		target_ns = task_active_pid_ns(find_task_by_vpid(target_pid));
>>>
>>> 		...
>>> 	}
>>>> Yes, this is more limited... Do you have a use-case when this is not enough?
>> That was in v1 but considered too racy.
> Hmm, I don't understand...
>
> Yes sure, this is racy but open("/proc/$pid/ns/pid") is racy too?
>
> OK, once you do fd=open("/proc/$pid/ns/pid") you can use this fd even after
> its owner exits, while find_task_by_vpid() will fail or find another task if
> this pid was already reused.
>
> But once again, do you have a use-case when this is important?

I believe that in V1 Eric pointed out that pid in general is not a clean 
way to represent
namespace. (https://lkml.org/lkml/2015/9/22/1087) Few old interfaces 
used pid only because at that time there was no better way to represent 
namespaces.

>
>> But we could merge both ways:
>>
>> source >= 0 - pidns fs
>> source < 0  - task_pid = -source
> But for what? I must have missed something...
>
> Oleg.
>
