From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Fri, 8 Feb 2019 05:57:50 -0700
Message-ID: <2ac73020-6ab0-e351-3a1a-180d0f1f801b@kernel.dk>
References: <20190207195552.22770-1-axboe@kernel.dk>
 <20190207195552.22770-14-axboe@kernel.dk>
 <bfd383aa-24fb-35ae-eef5-545ab0f493c7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <bfd383aa-24fb-35ae-eef5-545ab0f493c7@gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Alan Jenkins <alan.christopher.jenkins@gmail.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/8/19 5:17 AM, Alan Jenkins wrote:
>> +static int io_sqe_files_scm(struct io_ring_ctx *ctx)
>> +{
>> +#if defined(CONFIG_NET)
>> +	struct scm_fp_list *fpl = ctx->user_files;
>> +	struct sk_buff *skb;
>> +	int i;
>> +
>> +	skb =  __alloc_skb(0, GFP_KERNEL, 0, NUMA_NO_NODE);
>> +	if (!skb)
>> +		return -ENOMEM;
>> +
>> +	skb->sk = ctx->ring_sock->sk;
>> +	skb->destructor = unix_destruct_scm;
>> +
>> +	fpl->user = get_uid(ctx->user);
>> +	for (i = 0; i < fpl->count; i++) {
>> +		get_file(fpl->fp[i]);
>> +		unix_inflight(fpl->user, fpl->fp[i]);
>> +		fput(fpl->fp[i]);
>> +	}
>> +
>> +	UNIXCB(skb).fp = fpl;
>> +	skb_queue_head(&ctx->ring_sock->sk->sk_receive_queue, skb);
> 
> This code sounds elegant if you know about the existence of unix_gc(), 
> but quite mysterious if you don't.  (E.g. why "inflight"?)  Could we 
> have a brief comment, to comfort mortal readers on their journey?
> 
> /* A message on a unix socket can hold a reference to a file. This can 
> cause a reference cycle. So there is a garbage collector for unix 
> sockets, which we hook into here. */

Yes that's a good idea, I've added a comment as to why we go through the
trouble of doing this socket + skb dance.

> I think this is bypassing too_many_unix_fds() though?  I understood that 
> was intended to bound kernel memory allocation, at least in principle.

As the code stands above, it'll cap it at 253. I'm just now reworking it
to NOT be limited to the SCM max fd count, but still impose a limit of
1024 on the number of registered files. This is important to cap the
memory allocation attempt as well.

> Also, this code relies on CONFIG_NET.  To handle the case where 
> CONFIG_NET is not enabled, don't you still need to forbid registering an 
> io_uring fd ?

Good point, we do still need to reject the io_uring fd itself if
CONFIG_UNIX is not enabled. Done.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
