From: Prakash Sangappa <prakash.sangappa@oracle.com>
Subject: Re: [RESEND RFC PATCH 1/1] Selectively allow CAP_SYS_NICE capability
 inside user namespaces
Date: Thu, 21 Nov 2019 17:45:57 -0800
Message-ID: <0d7fb84d-e7e8-c442-37a3-23b036fdf12c@oracle.com>
References: <1574096478-11520-1-git-send-email-prakash.sangappa@oracle.com>
 <1574096478-11520-2-git-send-email-prakash.sangappa@oracle.com>
 <87wobszzqi.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87wobszzqi.fsf@x220.int.ebiederm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org, serge@hallyn.com
List-Id: linux-api@vger.kernel.org



On 11/21/19 1:27 PM, ebiederm@xmission.com wrote:
> Prakash Sangappa <prakash.sangappa@oracle.com> writes:
>
>> Allow CAP_SYS_NICE to take effect for processes having effective uid of a
>> root user from init namespace.
>>
>> Signed-off-by: Prakash Sangappa <prakash.sangappa@oracle.com>
>> ---
>>   kernel/sched/core.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 7880f4f..628bd46 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -4548,6 +4548,8 @@ int can_nice(const struct task_struct *p, const int nice)
>>   	int nice_rlim = nice_to_rlimit(nice);
>>   
>>   	return (nice_rlim <= task_rlimit(p, RLIMIT_NICE) ||
>> +		(ns_capable(__task_cred(p)->user_ns, CAP_SYS_NICE) &&
>> +		uid_eq(current_euid(), GLOBAL_ROOT_UID)) ||
>>   		capable(CAP_SYS_NICE));
>>   }
>>   
>> @@ -4784,7 +4786,9 @@ static int __sched_setscheduler(struct task_struct *p,
>>   	/*
>>   	 * Allow unprivileged RT tasks to decrease priority:
>>   	 */
>> -	if (user && !capable(CAP_SYS_NICE)) {
>> +	if (user && !(ns_capable(__task_cred(p)->user_ns, CAP_SYS_NICE) &&
>> +		uid_eq(current_euid(), GLOBAL_ROOT_UID)) &&
>> +		!capable(CAP_SYS_NICE)) {
>>   		if (fair_policy(policy)) {
>>   			if (attr->sched_nice < task_nice(p) &&
>>   			    !can_nice(p, attr->sched_nice))
>
> I remember looking at this before.  I don't remember if I commented.

Thanks for looking at this.

>
> 1) Having GLOBAL_ROOT_UID in a user namespace is A Bad Idea™.
>     Definitely not something we should make special case for.
>     That configuration is almost certainly a privilege escalation waiting
>     to happen.

Mapping root uid 0(GLOBAL_ROOT_UID) from init namespace into a user 
namespace is allowed right now. so the proposal was to extend this to 
allow capabilities like CAP_SYS_NICE to take effect which is lacking.

Understand encouraging use of GLOBAL_ROOT_UID for this purpose may not 
be a good idea.

We could look at other means to grant such capabilities to user 
namespace thru a per process /proc file like 'cap_map' or something as 
suggested in the other thread. What do you think about this approach?

Only privileged user in init namespace gets to add an entry to this 
file. We need to define if this gets inherited by any nested user 
namespaces that get created.



> 2) If I read the other thread correctly there was talk about setting the
>     nice levels of processes in other containers.  Ouch!

No not in other containers. Only on processes with in the container 
which as this capability. The use case is to use it in a container with 
user namespace and pid namespace. So no processes from other containers 
should be visible. Necessary checks should be added?.


>
>     The only thing I can think that makes any sense at all is to allow
>     setting the nice levels of the processes in your own container.

Yes that is the intended use.

>
>     I can totally see having a test to see if a processes credentials are
>     in the caller's user namespace or a child of caller's user namespace
>     and allowing admin level access if the caller has the appropriate
>     caps in their user namespace.

Ok

>     But in this case I don't see anything preventing the admin in a
>     container from using the ordinary nice levels on a task.  You are
>     unlocking the nice levels reserved for the system administrator
>     for special occassions.   I don't see how that makes any sense
>     to do from inside a container.

But this is what seems to be lacking. A container could have some 
critical processes running which need to run at a higher priority.

>
> The design goal of user namespaces (assuming a non-buggy kernel) is to
> ensure user namespaces give a user no more privileges than the user had
> before creating a user namespace.  In this case you are granting a user
> who creates a user namespace the ability to change nice levels on all
> process in the system (limited to users whose uid happens to be
> GLOBAL_ROOT_UID).  But still this is effectively a way to get
> CAP_SYS_NICE back if it was dropped.

Giving privileges to only to those user with root uid from init 
namespace inside the user namespace(GLOBAL_ROOT_UID), or if not using 
GLOBAL_ROOT_UID, then privilege granted thru the /proc mechanism as 
mentioned above.

>
> As a violation of security policy this change simply can not be allowed.
> The entire idiom:  "ns_capable(__task_cred(p)->user_ns, ...)" is a check
> that provides no security.

If the effect of allowing such privileges inside user namespace could be 
controlled with use of Cgroups, even then would it be a concern?

-Prakash
> Eric
>
>
>
>
>
>     
>     
>
