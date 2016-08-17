From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] pipe: make pipe user buffer limit checks more precise
Date: Wed, 17 Aug 2016 20:02:17 +1200
Message-ID: <67c8abf7-df7c-444d-7876-d160a211c969@gmail.com>
References: <86c85cff-7fee-cded-386a-e1d518573dda@gmail.com>
 <db82480c-7956-b89d-1f4e-ba2c94f4067e@gmail.com>
 <57B301FE.9090108@oracle.com>
 <1532b6c4-c618-348c-d36a-9679d5d5a1b4@gmail.com>
 <57B38CF7.5080803@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57B38CF7.5080803-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Willy Tarreau <w@1wt.eu>, socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Vegard,

On 08/17/2016 10:00 AM, Vegard Nossum wrote:
> On 08/16/2016 10:21 PM, Michael Kerrisk (man-pages) wrote:
>>>> @@ -1132,8 +1136,8 @@ long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
>>>>    			if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
>>>>    				ret = -EPERM;
>>>>    				goto out;
>>>> -			} else if ((too_many_pipe_buffers_hard(pipe->user) ||
>>>> -				too_many_pipe_buffers_soft(pipe->user)) &&
>>>> +			} else if ((too_many_pipe_buffers_hard(pipe->user, nr_pages) ||
>>>> +				too_many_pipe_buffers_soft(pipe->user, nr_pages)) &&
>>>>    				!capable(CAP_SYS_RESOURCE) &&
>>>>    				!capable(CAP_SYS_ADMIN)) {
>>>>    				ret = -EPERM;
>>>>
>>>
>>> Isn't there also a race where two or more concurrent pipe()/fnctl()
>>> calls can together push us over the limits before the accounting is done?
>>
>> I guess there is!
>>
>>> I think there really ought to be a check after doing the accounting if
>>> we really want to be meticulous here.
>>
>> Let me confirm what I understand from your comment: because of the race,
>> then a user could subvert the checks and allocate an arbitrary amount
>> of kernel memory for pipes. Right?
>>
>> I'm not sure what you mean by "a check after doing the accounting". Is not the
>> only solution here some kind of lock around the check+accounting steps?
> 
> Instead of doing atomic_long_read() in the check + atomic_long_add() for
> accounting we could do a single speculative atomic_long_add_return() and
> then if it goes above the limit we can lower it again with atomic_sub()
> when aborting the operation (if it doesn't go above the limit we don't
> need to do anything).

So, would that mean something like the following (where I've moved
some checks from pipe_fcntl() to pipe_set_size()):

8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---

long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
{
        struct pipe_inode_info *pipe;
        long ret;

        pipe = get_pipe_info(file);
        if (!pipe)
                return -EBADF;

        __pipe_lock(pipe);

        switch (cmd) {
        case F_SETPIPE_SZ: {
                unsigned int size, nr_pages;

                size = round_pipe_size(arg);
                nr_pages = size >> PAGE_SHIFT;

                ret = -EINVAL;
                if (!nr_pages)
                        goto out;

                ret = pipe_set_size(pipe, nr_pages);
                break;
                }
        case F_GETPIPE_SZ:
                ret = pipe->buffers * PAGE_SIZE;
                break;
        default:
                ret = -EINVAL;
                break;
        }

out:
        __pipe_unlock(pipe);
        return ret;
}


/*...*/

static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long nr_pages)
{
        struct pipe_buffer *bufs;
        unsigned int size;
        long ret = 0;

        size = nr_pages * PAGE_SIZE;
        account_pipe_buffers(pipe, pipe->buffers, nr_pages);

        /*
         * If trying to increase the pipe capacity, check that an
         * unprivileged user is not trying to exceed various limits.
         * (Decreasing the pipe capacity is always permitted, even
         * if the user is currently over a limit.)
         */
        if (nr_pages > pipe->buffers) {
                if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
                        ret = -EPERM;
                } else if ((too_many_pipe_buffers_hard(pipe->user, 0) ||
                                too_many_pipe_buffers_soft(pipe->user, 0)) &&
                                !capable(CAP_SYS_RESOURCE) &&
                                !capable(CAP_SYS_ADMIN)) {
                        ret = -EPERM;
                }
        }

	/*
	 * If we exceeded a limit, revert the accounting and go no further
         */
        if (ret) {
                account_pipe_buffers(pipe, nr_pages, pipe->buffers);
                return ret;
        }

        /*
         * We can shrink the pipe, if arg >= pipe->nrbufs. Since we don't
         * expect a lot of shrink+grow operations, just free and allocate
         * again like we would do for growing. If the pipe currently
         * contains more buffers than arg, then return busy.
         */
        if (nr_pages < pipe->nrbufs)
                return -EBUSY;

        bufs = kcalloc(nr_pages, sizeof(*bufs),
                       GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
        if (unlikely(!bufs))
                return -ENOMEM;

        /*
         * The pipe array wraps around, so just start the new one at zero
         * and adjust the indexes.
         */
        if (pipe->nrbufs) {
                unsigned int tail;
                unsigned int head;

                tail = pipe->curbuf + pipe->nrbufs;
                if (tail < pipe->buffers)
                        tail = 0;
                else
                        tail &= (pipe->buffers - 1);

                head = pipe->nrbufs - tail;
                if (head)
                        memcpy(bufs, pipe->bufs + pipe->curbuf, head * sizeof(struct pipe_buffer));
                if (tail)
                        memcpy(bufs + head, pipe->bufs, tail * sizeof(struct pipe_buffer));
        }

        pipe->curbuf = 0;
        kfree(pipe->bufs);
        pipe->bufs = bufs;
        pipe->buffers = nr_pages;
        return nr_pages * PAGE_SIZE;
}

8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---8x---

Seem okay? Probably, some analogous fix is required in alloc_pipe_info()
when creating a pipe(?).

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
