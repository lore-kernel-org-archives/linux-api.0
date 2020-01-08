From: "prakash.sangappa" <prakash.sangappa@oracle.com>
Subject: Re: [RESEND RFC PATCH 1/1] Selectively allow CAP_SYS_NICE capability
 inside user namespaces
Date: Wed, 8 Jan 2020 13:23:22 -0800
Message-ID: <b231b9b4-c37d-1d9f-7054-1b4be41302b4@oracle.com>
References: <1574096478-11520-1-git-send-email-prakash.sangappa@oracle.com>
 <1574096478-11520-2-git-send-email-prakash.sangappa@oracle.com>
 <87wobszzqi.fsf@x220.int.ebiederm.org>
 <0d7fb84d-e7e8-c442-37a3-23b036fdf12c@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0d7fb84d-e7e8-c442-37a3-23b036fdf12c@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org, serge@hallyn.com
List-Id: linux-api@vger.kernel.org



On 11/21/2019 05:45 PM, Prakash Sangappa wrote:
>
>
> On 11/21/19 1:27 PM, ebiederm@xmission.com wrote:
>> Prakash Sangappa <prakash.sangappa@oracle.com> writes:
<..>
>> 2) If I read the other thread correctly there was talk about setting the
>>     nice levels of processes in other containers.  Ouch!
>
> No not in other containers. Only on processes within the container 
> which has this capability. The use case is to use it in a container 
> with user namespace and pid namespace. So no processes from other 
> containers should be visible. Necessary checks should be added?.
>
>
>>
>>     The only thing I can think that makes any sense at all is to allow
>>     setting the nice levels of the processes in your own container.
>
> Yes that is the intended use.
>
>>
>>     I can totally see having a test to see if a processes credentials 
>> are
>>     in the caller's user namespace or a child of caller's user namespace
>>     and allowing admin level access if the caller has the appropriate
>>     caps in their user namespace.
>
> Ok
>
>>     But in this case I don't see anything preventing the admin in a
>>     container from using the ordinary nice levels on a task. You are
>>     unlocking the nice levels reserved for the system administrator
>>     for special occassions.   I don't see how that makes any sense
>>     to do from inside a container.
>
> But this is what seems to be lacking. A container could have some 
> critical processes running which need to run at a higher priority.

Any comments about this? What would be the recommendation for dealing 
with such a requirement?
