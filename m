From: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Subject: Re: [PATCH RFC v5] pidns: introduce syscall translate_pid
Date: Thu, 31 May 2018 10:41:20 -0700
Message-ID: <3bdd6b27-0a46-5802-8671-07268cecc1c7@oracle.com>
References: <152286911105.615669.14053871624892399807.stgit@buzz>
 <ba7b704f-1fc4-a08d-e7cf-2766160bd419@oracle.com>
 <87h8oqhagl.fsf@xmission.com>
 <112c7cac-1982-3a2e-ffc0-878bc5ae4bb6@yandex-team.ru>
 <e1402871-77a5-6a0f-a75c-ccad77b93f49@oracle.com>
 <778ab3d0-b6bc-fdb5-669a-40222e5020d4@yandex-team.ru>
 <e3a1076d-cfd7-a034-dd08-2d74fbf751f3@oracle.com>
 <3e2c285a-1bf8-f71d-1b74-4d6465c29a54@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3e2c285a-1bf8-f71d-1b74-4d6465c29a54@yandex-team.ru>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Prakash Sangappa <prakash.sangappa@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org



On 05/15/2018 10:36 AM, Konstantin Khlebnikov wrote:
>
>
> On 15.05.2018 20:19, Nagarathnam Muthusamy wrote:
>>
>>
>> On 04/24/2018 10:36 PM, Konstantin Khlebnikov wrote:
>>> On 23.04.2018 20:37, Nagarathnam Muthusamy wrote:
>>>>
>>>>
>>>> On 04/05/2018 12:02 AM, Konstantin Khlebnikov wrote:
>>>>> On 05.04.2018 01:29, Eric W. Biederman wrote:
>>>>>> Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com> writes:
>>>>>>
>>>>>>> On 04/04/2018 12:11 PM, Konstantin Khlebnikov wrote:
>>>>>>>> Each process have different pids, one for each pid namespace it 
>>>>>>>> belongs.
>>>>>>>> When interaction happens within single pid-ns translation isn't 
>>>>>>>> required.
>>>>>>>> More complicated scenarios needs special handling.
>>>>>>>>
>>>>>>>> For example:
>>>>>>>> - reading pid-files or logs written inside container with pid 
>>>>>>>> namespace
>>>>>>>> - attaching with ptrace to tasks from different pid namespace
>>>>>>>> - passing pids across pid namespaces in any kind of API
>>>>>>>>
>>>>>>>> Currently there are several interfaces that could be used here:
>>>>>>>>
>>>>>>>> Pid namespaces are identified by inode number of 
>>>>>>>> /proc/[pid]/ns/pid.
>>>>>>
>>>>>> Using the inode number in interfaces is not an option. Especially 
>>>>>> not
>>>>>> withou referencing the device number for the filesystem as well.
>>>>>
>>>>> This is supposed to be single-instance fs,
>>>>> not part of proc but referenced but its magic "symlinks".
>>>>>
>>>>> Device numbers are not mentioned in "man namespaces".
>>>>>
>>>>>>
>>>>>>>> Pids for nested Pid namespaces are shown in file 
>>>>>>>> /proc/[pid]/status.
>>>>>>>> In some cases conversion pid -> vpid could be easily done using 
>>>>>>>> this
>>>>>>>> information, but backward translation requires scanning all tasks.
>>>>>>>>
>>>>>>>> Unix socket automatically translates pid attached to 
>>>>>>>> SCM_CREDENTIALS.
>>>>>>>> This requires CAP_SYS_ADMIN for sending arbitrary pids and 
>>>>>>>> entering
>>>>>>>> into pid namespace, this expose process and could be insecure.
>>>>>>>>
>>>>>>>> This patch adds new syscall for converting pids between pid 
>>>>>>>> namespaces:
>>>>>>>>
>>>>>>>> pid_t translate_pid(pid_t pid, int source_type, int source,
>>>>>>>>                                  int target_type, int target);
>>>>>>>>
>>>>>>>> @source_type and @target_type defines type of following arguments:
>>>>>>>>
>>>>>>>> TRANSLATE_PID_CURRENT_PIDNS  - current pid namespace, argument 
>>>>>>>> is unused
>>>>>>>> TRANSLATE_PID_TASK_PIDNS     - task pid-ns, argument is task pid
>>>>>>>
>>>>>>> I believe using pid to represent the namespace has been already
>>>>>>> discussed in V1 of this patch in 
>>>>>>> https://lkml.org/lkml/2015/9/22/1087
>>>>>>> after which we moved on to fd based version of this interface.
>>>>>>
>>>>>> Or in short why is the case of pids important?
>>>>>>
>>>>>> You Konstantin you almost said why they were important in your 
>>>>>> message
>>>>>> saying you were going to send this one.  However you don't 
>>>>>> explain in
>>>>>> your description why you want to identify pid namespaces by pid.
>>>>>>
>>>>>
>>>>> Open of /proc/[pid]/ns/pid requires same permissions as ptrace,
>>>>> pid based variant doesn't have such restrictions.
>>>>
>>>> Can you provide more information on usecase requiring PID 
>>>> translation but not used for tracing related purposes?
>>>
>>> Any introspection for [nested] containers. It's easier to work when 
>>> you have all information when you don't have any.
>>> For example our CMS https://github.com/yandex/porto allows to start 
>>> nested sub-container (or even deeper) by request from any container 
>>> and have to tell back which pid task is have. And it could translate 
>>> any pid inside into accessible by client and vice versa.
>>>
>>
>> I still dont get the exact reason why PID based approach to identify 
>> the namespace during pid translation process is absolutely required 
>> compared to fd based approach. 
>
> As I told open(/proc/%d/ns/pid) have security restrictions - same 
> uid/CAP_SYS_PTRACE/whatever
> Pidns-fd holds pid-namespace and without restrictions could be abused.
> Pid based API is racy but always available without any restrictions.
>
>
>> From your version of TranslatePid in
>>
>> https://github.com/yandex/porto/blob/0d7e6e7e1830dcd0038a057b2ab9964cec5b8fab/src/util/unix.cpp 
>>
>>
>> I see that you are going through the trouble of forking a process and 
>> sending SMC_CREDENTIALS for pid translation. Even your existing API 
>> could be extremely simplified if translate_pid based on file 
>> descriptors make it to the gate and I believe from the last 
>> discussion it was almost there 
>> https://patchwork.kernel.org/patch/10305439/
>>
>>
>>>> On a side note, can we have the types TRANSLATE_PID_CURRENT_PIDNS 
>>>> and TRANSLATE_PID_FD_PIDNS integrated first and then possibly 
>>>> extend the interface to include TRANSLATE_PID_TASK_PIDNS in future?
>>>
>>> I don't see reason for this separation.
>>> Pids and pid namespaces are part of the API for a long time.
>>
>> If you are talking about the translate_pid API proposed, I believe 
>> the V4 proposed under https://patchwork.kernel.org/patch/10003935/ 
>> had only fd based API before a mix of PID and fd based is proposed in 
>> V5. Again, I was just wondering if we can get the FD based approach 
>> in first and then extend the API to include PID based approach later 
>> as fd based approach could provide a lot of immediate benefits?
>>
>> Thanks,
>> Nagarathnam.
>>>
>>>>
>>>> Thanks,
>>>> Nagarathnam.
>>>>> Most pid-based syscalls are racy in some cases but they are
>>>>> here for decades and everybody knowns how to deal with it.
>>>>> So, I've decided to merge both worlds in one interface which 
>>>>> clearly tells what to expect.
>>>>
>>

Ping? Any additional comments on this patch?

Thanks,
Nagarathnam.
