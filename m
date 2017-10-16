From: Nagarathnam Muthusamy <nagarathnam.muthusamy-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] pidns: introduce syscall translate_pid
Date: Mon, 16 Oct 2017 15:07:52 -0700
Message-ID: <fc2ae985-7ef7-0caf-4eb9-9348a5ca5e78@oracle.com>
References: <150788678482.924140.11785205105514746135.stgit@buzz>
 <20171013160514.GA27812@redhat.com>
 <3bdb5341-9ae6-265a-ce5b-45c2cfc76fad@yandex-team.ru>
 <d7b2a0b6-6d0c-5ca8-9d2b-3a1211713d34@yandex-team.ru>
 <20171016143628.b2ef80a9ef16d4345889b4d9@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016143628.b2ef80a9ef16d4345889b4d9-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, prakash sangappa <prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 10/16/2017 02:36 PM, Andrew Morton wrote:
> On Sat, 14 Oct 2017 11:17:47 +0300 Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> wrote:
>
>>>>> pid_t translate_pid(pid_t pid, int source, int target);
>>>>>
>>>>> This syscall converts pid from source pid-ns into pid in target pid-ns.
>>>>> If pid is unreachable from target pid-ns it returns zero.
>>>>>
>>>>> Pid-namespaces are referred file descriptors opened to proc files
>>>>> /proc/[pid]/ns/pid or /proc/[pid]/ns/pid_for_children. Negative argument
>>>>> refers to current pid namespace, same as file /proc/self/ns/pid.
>>>>>
>>>>> Kernel expose virtual pids in /proc/[pid]/status:NSpid, but backward
>>>>> translation requires scanning all tasks. Also pids could be translated
>>>>> by sending them through unix socket between namespaces, this method is
>>>>> slow and insecure because other side is exposed inside pid namespace.
>> Andrew asked why we might need this.
>>
>> Such conversion is required for interaction between processes across pid-namespaces.
>> For example to identify process in container by pid file looking from outside.
>>
>> Two years ago I've solved this in project of mine with monstrous code which
>> forks couple times just to convert pid, lucky for me performance wasn't important.
> That's a single user who needed this a single time, and found a
> userspace-based solution anyway.  This is not exactly compelling!
>
> Is there a stronger case to be made?  How does this change benefit our
> users?  Sell it to us!
Oracle database is planning to use pid namespace for sandboxing database 
instances and they need an API similar to translate_pid to effectively 
translate process IDs from other pid namespaces. Prakash (cced in mail) 
can provide more details on this usecase.

Thanks,
Nagarathnam.
