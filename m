From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH RFC v5] pidns: introduce syscall translate_pid
Date: Thu, 5 Apr 2018 10:02:42 +0300
Message-ID: <112c7cac-1982-3a2e-ffc0-878bc5ae4bb6@yandex-team.ru>
References: <152286911105.615669.14053871624892399807.stgit@buzz>
 <ba7b704f-1fc4-a08d-e7cf-2766160bd419@oracle.com>
 <87h8oqhagl.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87h8oqhagl.fsf@xmission.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Prakash Sangappa <prakash.sangappa@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On 05.04.2018 01:29, Eric W. Biederman wrote:
> Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com> writes:
> 
>> On 04/04/2018 12:11 PM, Konstantin Khlebnikov wrote:
>>> Each process have different pids, one for each pid namespace it belongs.
>>> When interaction happens within single pid-ns translation isn't required.
>>> More complicated scenarios needs special handling.
>>>
>>> For example:
>>> - reading pid-files or logs written inside container with pid namespace
>>> - attaching with ptrace to tasks from different pid namespace
>>> - passing pids across pid namespaces in any kind of API
>>>
>>> Currently there are several interfaces that could be used here:
>>>
>>> Pid namespaces are identified by inode number of /proc/[pid]/ns/pid.
> 
> Using the inode number in interfaces is not an option.  Especially not
> withou referencing the device number for the filesystem as well.

This is supposed to be single-instance fs,
not part of proc but referenced but its magic "symlinks".

Device numbers are not mentioned in "man namespaces".

> 
>>> Pids for nested Pid namespaces are shown in file /proc/[pid]/status.
>>> In some cases conversion pid -> vpid could be easily done using this
>>> information, but backward translation requires scanning all tasks.
>>>
>>> Unix socket automatically translates pid attached to SCM_CREDENTIALS.
>>> This requires CAP_SYS_ADMIN for sending arbitrary pids and entering
>>> into pid namespace, this expose process and could be insecure.
>>>
>>> This patch adds new syscall for converting pids between pid namespaces:
>>>
>>> pid_t translate_pid(pid_t pid, int source_type, int source,
>>>                                  int target_type, int target);
>>>
>>> @source_type and @target_type defines type of following arguments:
>>>
>>> TRANSLATE_PID_CURRENT_PIDNS  - current pid namespace, argument is unused
>>> TRANSLATE_PID_TASK_PIDNS     - task pid-ns, argument is task pid
>>
>> I believe using pid to represent the namespace has been already
>> discussed in V1 of this patch in https://lkml.org/lkml/2015/9/22/1087
>> after which we moved on to fd based version of this interface.
> 
> Or in short why is the case of pids important?
> 
> You Konstantin you almost said why they were important in your message
> saying you were going to send this one.  However you don't explain in
> your description why you want to identify pid namespaces by pid.
> 

Open of /proc/[pid]/ns/pid requires same permissions as ptrace,
pid based variant doesn't have such restrictions.
Most pid-based syscalls are racy in some cases but they are
here for decades and everybody knowns how to deal with it.
So, I've decided to merge both worlds in one interface which clearly tells what to expect.
