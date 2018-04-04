From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH RFC v5] pidns: introduce syscall translate_pid
Date: Wed, 04 Apr 2018 17:29:30 -0500
Message-ID: <87h8oqhagl.fsf@xmission.com>
References: <152286911105.615669.14053871624892399807.stgit@buzz>
        <ba7b704f-1fc4-a08d-e7cf-2766160bd419@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ba7b704f-1fc4-a08d-e7cf-2766160bd419@oracle.com> (Nagarathnam
        Muthusamy's message of "Wed, 4 Apr 2018 13:31:32 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Prakash Sangappa <prakash.sangappa@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com> writes:

> On 04/04/2018 12:11 PM, Konstantin Khlebnikov wrote:
>> Each process have different pids, one for each pid namespace it belongs.
>> When interaction happens within single pid-ns translation isn't required.
>> More complicated scenarios needs special handling.
>>
>> For example:
>> - reading pid-files or logs written inside container with pid namespace
>> - attaching with ptrace to tasks from different pid namespace
>> - passing pids across pid namespaces in any kind of API
>>
>> Currently there are several interfaces that could be used here:
>>
>> Pid namespaces are identified by inode number of /proc/[pid]/ns/pid.

Using the inode number in interfaces is not an option.  Especially not
withou referencing the device number for the filesystem as well.

>> Pids for nested Pid namespaces are shown in file /proc/[pid]/status.
>> In some cases conversion pid -> vpid could be easily done using this
>> information, but backward translation requires scanning all tasks.
>>
>> Unix socket automatically translates pid attached to SCM_CREDENTIALS.
>> This requires CAP_SYS_ADMIN for sending arbitrary pids and entering
>> into pid namespace, this expose process and could be insecure.
>>
>> This patch adds new syscall for converting pids between pid namespaces:
>>
>> pid_t translate_pid(pid_t pid, int source_type, int source,
>>                                 int target_type, int target);
>>
>> @source_type and @target_type defines type of following arguments:
>>
>> TRANSLATE_PID_CURRENT_PIDNS  - current pid namespace, argument is unused
>> TRANSLATE_PID_TASK_PIDNS     - task pid-ns, argument is task pid
>
> I believe using pid to represent the namespace has been already
> discussed in V1 of this patch in https://lkml.org/lkml/2015/9/22/1087
> after which we moved on to fd based version of this interface.

Or in short why is the case of pids important?

You Konstantin you almost said why they were important in your message
saying you were going to send this one.  However you don't explain in
your description why you want to identify pid namespaces by pid.

Eric
