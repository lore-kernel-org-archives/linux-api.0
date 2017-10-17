From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH v4] pidns: introduce syscall translate_pid
Date: Tue, 17 Oct 2017 10:41:08 +0300
Message-ID: <647ebdbf-ef15-1838-13f6-5bb9cf729f74@yandex-team.ru>
References: <150788678482.924140.11785205105514746135.stgit@buzz>
 <20171013160514.GA27812@redhat.com>
 <3bdb5341-9ae6-265a-ce5b-45c2cfc76fad@yandex-team.ru>
 <20171016162436.GB4142@redhat.com>
 <6bba1416-746c-0636-9c6d-d2c9d8934dc6@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6bba1416-746c-0636-9c6d-d2c9d8934dc6@oracle.com>
Content-Language: ru-RU
Sender: linux-kernel-owner@vger.kernel.org
To: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Eugene Syromiatnikov <esyr@redhat.com>
List-Id: linux-api@vger.kernel.org

On 17.10.2017 00:05, Nagarathnam Muthusamy wrote:
> 
> 
> On 10/16/2017 09:24 AM, Oleg Nesterov wrote:
>> On 10/13, Konstantin Khlebnikov wrote:
>>>
>>> On 13.10.2017 19:05, Oleg Nesterov wrote:
>>>> I won't insist, but this suggests we should add a new helper,
>>>> get_ns_by_fd_type(fd, type), and convert get_net_ns_by_fd() to use it
>>>> as well.
>>> That was in v3.
>>>
>>> I'll prefer to this later, separately. And replace fget with fdget which
>>> allows to do this without atomic operations if task is single-threaded.
>> OK, agreed,
>>
>>>> Stupid question. Can't we make a simpler API which doesn't need /proc/ ?
>>>> I mean,
>>>>
>>>>     sys_translate_pid(pid_t pid, pid_t source_pid, pid_t target_pid)
>>>>     {
>>>>         struct pid_namespace *source_ns, *target_ns;
>>>>
>>>>         source_ns = task_active_pid_ns(find_task_by_vpid(source_pid));
>>>>         target_ns = task_active_pid_ns(find_task_by_vpid(target_pid));
>>>>
>>>>         ...
>>>>     }
>>>>> Yes, this is more limited... Do you have a use-case when this is not enough?
>>> That was in v1 but considered too racy.
>> Hmm, I don't understand...
>>
>> Yes sure, this is racy but open("/proc/$pid/ns/pid") is racy too?
>>
>> OK, once you do fd=open("/proc/$pid/ns/pid") you can use this fd even after
>> its owner exits, while find_task_by_vpid() will fail or find another task if
>> this pid was already reused.
>>
>> But once again, do you have a use-case when this is important?
> 
> I believe that in V1 Eric pointed out that pid in general is not a clean way to represent
> namespace. (https://lkml.org/lkml/2015/9/22/1087) Few old interfaces used pid only because at that time there was no better way to represent 
> namespaces.
> 

Yeah, that was a reason.

If we think further - all syscalls who operates with non-child tasks racy and
must be be replaced with some kind of pidfd or taskfd.

Eric pointed that too: https://lkml.org/lkml/2015/9/28/508

>>
>>> But we could merge both ways:
>>>
>>> source >= 0 - pidns fs
>>> source < 0  - task_pid = -source
>> But for what? I must have missed something...

I mean we could have both ways to point namespace in one agrument.
Some classic syscalls emply similar magic for negative pids.

This is cheap and looks almost sane. =)

>>
>> Oleg.
>>
> 
