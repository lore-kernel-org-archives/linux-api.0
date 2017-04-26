From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 2/2] pid_ns: Introduce ioctl to set vector of ns_last_pid's on ns hierarhy
Date: Wed, 26 Apr 2017 12:01:09 -0500
Message-ID: <87k267aysq.fsf@xmission.com>
References: <149245014695.17600.12640895883798122726.stgit@localhost.localdomain>
        <149245057248.17600.1341652606136269734.stgit@localhost.localdomain>
        <20170426155352.GA12131@redhat.com>
        <785e1986-da03-72aa-06c0-234ed2dbc0fd@virtuozzo.com>
        <005f52d9-efbe-9eaa-7f36-19945c8b06c3@virtuozzo.com>
        <87h91bcep5.fsf@xmission.com>
        <fcb261f1-77b6-87be-1d08-0e14857a06f1@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fcb261f1-77b6-87be-1d08-0e14857a06f1@virtuozzo.com> (Kirill
        Tkhai's message of "Wed, 26 Apr 2017 19:43:33 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Oleg Nesterov <oleg@redhat.com>, serge@hallyn.com, agruenba@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, paul@paul-moore.com, viro@zeniv.linux.org.uk, avagin@openvz.org, linux-fsdevel@vger.kernel.org, mtk.manpages@gmail.com, akpm@linux-foundation.org, luto@amacapital.net, gorcunov@openvz.org, mingo@kernel.org, keescook@chromium.org
List-Id: linux-api@vger.kernel.org

Kirill Tkhai <ktkhai@virtuozzo.com> writes:

> On 26.04.2017 19:32, Eric W. Biederman wrote:
>> Kirill Tkhai <ktkhai@virtuozzo.com> writes:
>> 
>>> On 26.04.2017 19:11, Kirill Tkhai wrote:
>>>> On 26.04.2017 18:53, Oleg Nesterov wrote:
>>>>> On 04/17, Kirill Tkhai wrote:
>>>>>>
>>>>>> +struct pidns_ioc_req {
>>>>>> +/* Set vector of last pids in namespace hierarchy */
>>>>>> +#define PIDNS_REQ_SET_LAST_PID_VEC	0x1
>>>>>> +	unsigned int req;
>>>>>> +	void __user *data;
>>>>>> +	unsigned int data_size;
>>>>>> +	char std_fields[0];
>>>>>> +};
>>>>>
>>>>> see below,
>>>>>
>>>>>> +static long set_last_pid_vec(struct pid_namespace *pid_ns,
>>>>>> +			     struct pidns_ioc_req *req)
>>>>>> +{
>>>>>> +	char *str, *p;
>>>>>> +	int ret = 0;
>>>>>> +	pid_t pid;
>>>>>> +
>>>>>> +	read_lock(&tasklist_lock);
>>>>>> +	if (!pid_ns->child_reaper)
>>>>>> +		ret = -EINVAL;
>>>>>> +	read_unlock(&tasklist_lock);
>>>>>> +	if (ret)
>>>>>> +		return ret;
>>>>>
>>>>> why do you need to check ->child_reaper under tasklist_lock? this looks pointless.
>>>>>
>>>>> In fact I do not understand how it is possible to hit pid_ns->child_reaper == NULL,
>>>>> there must be at least one task in this namespace, otherwise you can't open a file
>>>>> which has f_op == ns_file_operations, no?
>>>>
>>>> Sure, it's impossible to pick a pid_ns, if there is no the pid_ns's tasks. I added
>>>> it under impression of
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=dfda351c729733a401981e8738ce497eaffcaa00
>>>> but here it's completely wrong. It will be removed in v2.
>>>>  
>>>>>> +	if (req->data_size >= PAGE_SIZE)
>>>>>> +		return -EINVAL;
>>>>>> +	str = vmalloc(req->data_size + 1);
>>>>>
>>>>> then I don't understand why it makes sense to use vmalloc()
>>>>>
>>>>>> +	if (!str)
>>>>>> +		return -ENOMEM;
>>>>>> +	if (copy_from_user(str, req->data, req->data_size)) {
>>>>>> +		ret = -EFAULT;
>>>>>> +		goto out_vfree;
>>>>>> +	}
>>>>>> +	str[req->data_size] = '\0';
>>>>>> +
>>>>>> +	p = str;
>>>>>> +	while (p && *p != '\0') {
>>>>>> +		if (!ns_capable(pid_ns->user_ns, CAP_SYS_ADMIN)) {
>>>>>> +			ret = -EPERM;
>>>>>> +			goto out_vfree;
>>>>>> +		}
>>>>>> +
>>>>>> +		if (sscanf(p, "%d", &pid) != 1 || pid < 0 || pid > pid_max) {
>>>>>> +			ret = -EINVAL;
>>>>>> +			goto out_vfree;
>>>>>> +		}
>>>>>
>>>>> Well, this is ioctl(), do we really want to parse the strings?
>>>>>
>>>>> Can't we make
>>>>>
>>>>> 	struct pidns_ioc_req {
>>>>> 		...
>>>>> 		int nr_pids;
>>>>> 		pid_t  pids[0];
>>>>> 	}
>>>>>
>>>>> and just use get_user() in a loop? This way we can avoid vmalloc() or anything
>>>>> else altogether.
>>>>
>>>> Since it's a generic structure for different types of the requests, it may be extended
>>>> in the future. We won't be able to add new fields, if we compose the structure the way
>>>> you suggested, will we?
>>>
>>> Though, we may go this way if just do the fields generic:
>>>
>>> struct pidns_ioc_req {
>>>         unsigned int req;
>>>         unsigned int data_size;
>>>         union {
>>> 	        pid_t pid[0];
>>> 	};
>>> };
>>>
>>> Ok, I'll rework the patchset in this way.
>> 
>> You don't need that.  That is what new ioctl numbers are for.
>> 
>> Interfaces to the kernel don't need to become multiplexors to prepare
>> for the future when there is already an appropriate multiplexing
>> interface in place.
>
> That is, do you suggest to not introduce NS_SPECIFIC_IO from the first patch,
> and add PIDNS_REQ_SET_LAST_PID_VEC to the list of generic ns ioctls?
>
> ...
> #define NS_GET_OWNER_UID		_IO(NSIO, 0x4)
> #define PIDNS_REQ_SET_LAST_PID_VEC	_IO(NSIO, 0x5)

I have not looked at your proposal in detail.  But if we are going to do
this with ioctls there are enough that we should not need to play games.
There are 4 billion of them and 4194304 dedicated for namespace
operations.  Strictly it is 256 ioctls plus 14 bits dedicated for size.
Even that seems plenty.

Please let's make things as simple as we can.

Eric
