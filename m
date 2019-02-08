From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Fri, 8 Feb 2019 08:13:18 -0700
Message-ID: <ad669e88-5a33-37e1-6d69-e2b182d89891@kernel.dk>
References: <20190207195552.22770-1-axboe@kernel.dk>
 <20190207195552.22770-14-axboe@kernel.dk>
 <bfd383aa-24fb-35ae-eef5-545ab0f493c7@gmail.com>
 <2ac73020-6ab0-e351-3a1a-180d0f1f801b@kernel.dk>
 <02e71636-5b63-41e6-0ffd-646f305011c9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <02e71636-5b63-41e6-0ffd-646f305011c9@gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Alan Jenkins <alan.christopher.jenkins@gmail.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/8/19 7:02 AM, Alan Jenkins wrote:
> On 08/02/2019 12:57, Jens Axboe wrote:
>> On 2/8/19 5:17 AM, Alan Jenkins wrote:
>>>> +static int io_sqe_files_scm(struct io_ring_ctx *ctx)
>>>> +{
>>>> +#if defined(CONFIG_NET)
>>>> +	struct scm_fp_list *fpl = ctx->user_files;
>>>> +	struct sk_buff *skb;
>>>> +	int i;
>>>> +
>>>> +	skb =  __alloc_skb(0, GFP_KERNEL, 0, NUMA_NO_NODE);
>>>> +	if (!skb)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	skb->sk = ctx->ring_sock->sk;
>>>> +	skb->destructor = unix_destruct_scm;
>>>> +
>>>> +	fpl->user = get_uid(ctx->user);
>>>> +	for (i = 0; i < fpl->count; i++) {
>>>> +		get_file(fpl->fp[i]);
>>>> +		unix_inflight(fpl->user, fpl->fp[i]);
>>>> +		fput(fpl->fp[i]);
>>>> +	}
>>>> +
>>>> +	UNIXCB(skb).fp = fpl;
>>>> +	skb_queue_head(&ctx->ring_sock->sk->sk_receive_queue, skb);
>>> This code sounds elegant if you know about the existence of unix_gc(),
>>> but quite mysterious if you don't.  (E.g. why "inflight"?)  Could we
>>> have a brief comment, to comfort mortal readers on their journey?
>>>
>>> /* A message on a unix socket can hold a reference to a file. This can
>>> cause a reference cycle. So there is a garbage collector for unix
>>> sockets, which we hook into here. */
>> Yes that's a good idea, I've added a comment as to why we go through the
>> trouble of doing this socket + skb dance.
> 
> Great, thanks.
> 
>>> I think this is bypassing too_many_unix_fds() though?  I understood that
>>> was intended to bound kernel memory allocation, at least in principle.
>> As the code stands above, it'll cap it at 253. I'm just now reworking it
>> to NOT be limited to the SCM max fd count, but still impose a limit of
>> 1024 on the number of registered files. This is important to cap the
>> memory allocation attempt as well.
> 
> I saw you were limiting to SCM_MAX_FD per io_uring.  On the other hand, 
> there's no specific limit on the number of io_urings you can open (only 
> the standard limits on fds).  So this would let you allocate hundreds of 
> times more files than the previous limit RLIMIT_NOFILE...

But there is, the io_uring itself is under the memlock rlimit.

> static inline bool too_many_unix_fds(struct task_struct *p)
> {
> 	struct user_struct *user = current_user();
> 
> 	if (unlikely(user->unix_inflight > task_rlimit(p, RLIMIT_NOFILE)))
> 		return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
> 	return false;
> }
> 
> RLIMIT_NOFILE is technically per-task, but here it is capping 
> unix_inflight per-user.  So the way I look at this, the number of file 
> descriptors per user is bounded by NOFILE * NPROC.  Then 
> user->unix_inflight can have one additional process' worth (NOFILE) of 
> "inflight" files.  (Plus SCM_MAX_FD slop, because too_many_fds() is only 
> called once per SCM_RIGHTS).
> 
> Because io_uring doesn't check too_many_unix_fds(), I think it will let 
> you have about 253 (or 1024) more process' worth of open files. That 
> could be big proportionally when RLIMIT_NPROC is low.
> 
> I don't know if it matters.  It maybe reads like an oversight though.
> 
> (If it does matter, it might be cleanest to change too_many_unix_fds() 
> to get rid of the "slop".  Since that may be different between af_unix 
> and io_uring; 253 v.s. 1024 or whatever. E.g. add a parameter for the 
> number of inflight files we want to add.)

I don't think it matters. The files in the fixed file set have already
been opened by the application, so it counts towards the number of open
files that is allowed to have. I don't think we should impose further
limits on top of that.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
