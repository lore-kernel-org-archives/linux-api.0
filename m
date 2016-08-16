From: Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] pipe: make pipe user buffer limit checks more precise
Date: Wed, 17 Aug 2016 00:00:23 +0200
Message-ID: <57B38CF7.5080803@oracle.com>
References: <86c85cff-7fee-cded-386a-e1d518573dda@gmail.com>
 <db82480c-7956-b89d-1f4e-ba2c94f4067e@gmail.com>
 <57B301FE.9090108@oracle.com>
 <1532b6c4-c618-348c-d36a-9679d5d5a1b4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1532b6c4-c618-348c-d36a-9679d5d5a1b4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Willy Tarreau <w@1wt.eu>, socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08/16/2016 10:21 PM, Michael Kerrisk (man-pages) wrote:
>>> @@ -1132,8 +1136,8 @@ long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
>>>    			if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
>>>    				ret = -EPERM;
>>>    				goto out;
>>> -			} else if ((too_many_pipe_buffers_hard(pipe->user) ||
>>> -				too_many_pipe_buffers_soft(pipe->user)) &&
>>> +			} else if ((too_many_pipe_buffers_hard(pipe->user, nr_pages) ||
>>> +				too_many_pipe_buffers_soft(pipe->user, nr_pages)) &&
>>>    				!capable(CAP_SYS_RESOURCE) &&
>>>    				!capable(CAP_SYS_ADMIN)) {
>>>    				ret = -EPERM;
>>>
>>
>> Isn't there also a race where two or more concurrent pipe()/fnctl()
>> calls can together push us over the limits before the accounting is done?
>
> I guess there is!
>
>> I think there really ought to be a check after doing the accounting if
>> we really want to be meticulous here.
>
> Let me confirm what I understand from your comment: because of the race,
> then a user could subvert the checks and allocate an arbitrary amount
> of kernel memory for pipes. Right?
>
> I'm not sure what you mean by "a check after doing the accounting". Is not the
> only solution here some kind of lock around the check+accounting steps?

Instead of doing atomic_long_read() in the check + atomic_long_add() for
accounting we could do a single speculative atomic_long_add_return() and
then if it goes above the limit we can lower it again with atomic_sub()
when aborting the operation (if it doesn't go above the limit we don't
need to do anything).


Vegard
