From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Tue, 12 Feb 2019 14:10:23 -0700
Message-ID: <af6c2501-9efb-4177-74be-cd82b2ce7d6b@kernel.dk>
References: <20190207195552.22770-1-axboe@kernel.dk>
 <20190207195552.22770-14-axboe@kernel.dk>
 <bfd383aa-24fb-35ae-eef5-545ab0f493c7@gmail.com>
 <2ac73020-6ab0-e351-3a1a-180d0f1f801b@kernel.dk>
 <02e71636-5b63-41e6-0ffd-646f305011c9@gmail.com>
 <ad669e88-5a33-37e1-6d69-e2b182d89891@kernel.dk>
 <c2ef6663-3e15-d071-56e3-4afba7b2d778@gmail.com>
 <1f1dc8b8-ad8f-16d1-c688-0ab1ce2df378@kernel.dk>
 <6c7ea7da-ab56-f1b8-2399-c0579b4eceec@gmail.com>
 <a326cb39-d55d-8047-a916-1562b33af76a@kernel.dk>
 <b8555602-b2e7-c73b-b9bb-3b5f5569cfc7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <b8555602-b2e7-c73b-b9bb-3b5f5569cfc7@gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Alan Jenkins <alan.christopher.jenkins@gmail.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/12/19 1:23 PM, Alan Jenkins wrote:
> On 12/02/2019 17:33, Jens Axboe wrote:
>> On 2/12/19 10:21 AM, Alan Jenkins wrote:
>>> On 12/02/2019 15:17, Jens Axboe wrote:
>>>> On 2/12/19 5:29 AM, Alan Jenkins wrote:
>>>>> On 08/02/2019 15:13, Jens Axboe wrote:
>>>>>> On 2/8/19 7:02 AM, Alan Jenkins wrote:
>>>>>>> On 08/02/2019 12:57, Jens Axboe wrote:
>>>>>>>> On 2/8/19 5:17 AM, Alan Jenkins wrote:
>>>>>>>>>> +static int io_sqe_files_scm(struct io_ring_ctx *ctx)
>>>>>>>>>> +{
>>>>>>>>>> +#if defined(CONFIG_NET)
>>>>>>>>>> +	struct scm_fp_list *fpl = ctx->user_files;
>>>>>>>>>> +	struct sk_buff *skb;
>>>>>>>>>> +	int i;
>>>>>>>>>> +
>>>>>>>>>> +	skb =  __alloc_skb(0, GFP_KERNEL, 0, NUMA_NO_NODE);
>>>>>>>>>> +	if (!skb)
>>>>>>>>>> +		return -ENOMEM;
>>>>>>>>>> +
>>>>>>>>>> +	skb->sk = ctx->ring_sock->sk;
>>>>>>>>>> +	skb->destructor = unix_destruct_scm;
>>>>>>>>>> +
>>>>>>>>>> +	fpl->user = get_uid(ctx->user);
>>>>>>>>>> +	for (i = 0; i < fpl->count; i++) {
>>>>>>>>>> +		get_file(fpl->fp[i]);
>>>>>>>>>> +		unix_inflight(fpl->user, fpl->fp[i]);
>>>>>>>>>> +		fput(fpl->fp[i]);
>>>>>>>>>> +	}
>>>>>>>>>> +
>>>>>>>>>> +	UNIXCB(skb).fp = fpl;
>>>>>>>>>> +	skb_queue_head(&ctx->ring_sock->sk->sk_receive_queue, skb);
>>>>>>>>> This code sounds elegant if you know about the existence of unix_gc(),
>>>>>>>>> but quite mysterious if you don't.  (E.g. why "inflight"?)  Could we
>>>>>>>>> have a brief comment, to comfort mortal readers on their journey?
>>>>>>>>>
>>>>>>>>> /* A message on a unix socket can hold a reference to a file. This can
>>>>>>>>> cause a reference cycle. So there is a garbage collector for unix
>>>>>>>>> sockets, which we hook into here. */
>>>>>>>> Yes that's a good idea, I've added a comment as to why we go through the
>>>>>>>> trouble of doing this socket + skb dance.
>>>>>>> Great, thanks.
>>>>>>>
>>>>>>>>> I think this is bypassing too_many_unix_fds() though?  I understood that
>>>>>>>>> was intended to bound kernel memory allocation, at least in principle.
>>>>>>>> As the code stands above, it'll cap it at 253. I'm just now reworking it
>>>>>>>> to NOT be limited to the SCM max fd count, but still impose a limit of
>>>>>>>> 1024 on the number of registered files. This is important to cap the
>>>>>>>> memory allocation attempt as well.
>>>>>>> I saw you were limiting to SCM_MAX_FD per io_uring.  On the other hand,
>>>>>>> there's no specific limit on the number of io_urings you can open (only
>>>>>>> the standard limits on fds).  So this would let you allocate hundreds of
>>>>>>> times more files than the previous limit RLIMIT_NOFILE...
>>>>>> But there is, the io_uring itself is under the memlock rlimit.
>>>>>>
>>>>>>> static inline bool too_many_unix_fds(struct task_struct *p)
>>>>>>> {
>>>>>>> 	struct user_struct *user = current_user();
>>>>>>>
>>>>>>> 	if (unlikely(user->unix_inflight > task_rlimit(p, RLIMIT_NOFILE)))
>>>>>>> 		return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
>>>>>>> 	return false;
>>>>>>> }
>>>>>>>
>>>>>>> RLIMIT_NOFILE is technically per-task, but here it is capping
>>>>>>> unix_inflight per-user.  So the way I look at this, the number of file
>>>>>>> descriptors per user is bounded by NOFILE * NPROC.  Then
>>>>>>> user->unix_inflight can have one additional process' worth (NOFILE) of
>>>>>>> "inflight" files.  (Plus SCM_MAX_FD slop, because too_many_fds() is only
>>>>>>> called once per SCM_RIGHTS).
>>>>>>>
>>>>>>> Because io_uring doesn't check too_many_unix_fds(), I think it will let
>>>>>>> you have about 253 (or 1024) more process' worth of open files. That
>>>>>>> could be big proportionally when RLIMIT_NPROC is low.
>>>>>>>
>>>>>>> I don't know if it matters.  It maybe reads like an oversight though.
>>>>>>>
>>>>>>> (If it does matter, it might be cleanest to change too_many_unix_fds()
>>>>>>> to get rid of the "slop".  Since that may be different between af_unix
>>>>>>> and io_uring; 253 v.s. 1024 or whatever. E.g. add a parameter for the
>>>>>>> number of inflight files we want to add.)
>>>>>> I don't think it matters. The files in the fixed file set have already
>>>>>> been opened by the application, so it counts towards the number of open
>>>>>> files that is allowed to have. I don't think we should impose further
>>>>>> limits on top of that.
>>>>> A process can open one io_uring and 199 other files.  Register the 199
>>>>> files in the io_uring, then close their file descriptors.  The main
>>>>> NOFILE limit only counts file descriptors.  So then you can open one
>>>>> io_uring, 198 other files, and repeat.
>>>>>
>>>>> You're right, I had forgotten the memlock limit on io_uring.  That makes
>>>>> it much less of a practical problem.
>>>>>
>>>>> But it raises a second point.  It's not just that it lets users allocate
>>>>> more files.  You might not want to be limited by user->unix_inflight.
>>>>> But you are calling unix_inflight(), which increments it!  Then if
>>>>> unix->inflight exceeds the NOFILE limit, you will avoid seeing any
>>>>> errors with io_uring, but the user will not be able to send files over
>>>>> unix sockets.
>>>>>
>>>>> So I think this is confusing to read, and confusing to troubleshoot if
>>>>> the limit is ever hit.
>>>>>
>>>>> I would be happy if io_uring didn't increment user->unix_inflight.  I'm
>>>>> not sure what the best way is to arrange that.
>>>> How about we just do something like the below? I think that's the saner
>>>> approach, rather than bypass user->unix_inflight. It's literally the
>>>> same thing.
>>>>
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index a4973af1c272..5196b3aa935e 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -2041,6 +2041,13 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
>>>>    	struct sk_buff *skb;
>>>>    	int i;
>>>>    
>>>> +	if (!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
>>>> +		struct user_struct *user = ctx->user;
>>>> +
>>>> +		if (user->unix_inflight > task_rlimit(current, RLIMIT_NOFILE))
>>>> +			return -EMFILE;
>>>> +	}
>>>> +
>>>>    	fpl = kzalloc(sizeof(*fpl), GFP_KERNEL);
>>>>    	if (!fpl)
>>>>    		return -ENOMEM;
>>>>
>>>>
>>> Welp, you gave me exactly what I asked for.  So now I'd better be
>>> positive about it :-D.
>> ;-)
>>
>>> I hope this will be documented accurately, at least where the EMFILE
>>> result is explained for this syscall.
>> How's this:
>>
>> http://git.kernel.dk/cgit/liburing/commit/?id=37e48698a09aa1e37690f8fa6dfd8da69a48ee60
> 
> +.B EMFILE
> +.BR IORING_REGISTER_FILES
> +was specified and adding
> +.I nr_args
> +file references would exceed the maximum allowed number of files the process
> +is allowed to have according to the
> +.B
> +RLIMIT_NOFILE
> +resource limit and the caller does not have
> +.B CAP_SYS_RESOURCE
> +capability.
> +.TP
> 
> I was struggling with this.  The POSIX part of RLIMIT_NOFILE is applied 
> per-process.  But the part we're talking about here, the Linux-specific 
> "unix_inflight" resource, is actually accounted per-user.  It's like 
> RLIMIT_NPROC.  The value of RLIMIT_NPROC is per-process, but the 
> resource it limits is counted in user->processes.
> 
> This subtlety of the NOFILE limit is not made clear in the text above, 
> nor in unix(7), nor in getrlimit(2).  I would interpret all these docs 
> as saying this limit is a per-process thing - I think they are misleading.

Fair point, I'll add an update to clearly state it's a per process
limit.

> IORING_MAX_FIXED_FILES is being raised to 1024, which is the same as the 
> (soft limit) value for RLIMIT_NOFILE which the kernel sets for the init 
> process.  I have an unjustifiable nervousness, that there will be some 
> `fio` command, or a test written that maxes out IORING_REGISTER_FILES.  
> When you do that, it will provoke unexpected failures e.g. in GUI apps.  
> If we can't rule that out, the next best thing is a friendly man page.

If we apply the limit to sendmsg and friends, it should be applied here
as well.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
