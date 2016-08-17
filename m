From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 2/2] pipe: make pipe user buffer limit checks more precise
Date: Wed, 17 Aug 2016 21:34:51 +0200
Message-ID: <57B4BC5B.9050405@oracle.com>
References: <86c85cff-7fee-cded-386a-e1d518573dda@gmail.com>
 <db82480c-7956-b89d-1f4e-ba2c94f4067e@gmail.com>
 <57B301FE.9090108@oracle.com>
 <1532b6c4-c618-348c-d36a-9679d5d5a1b4@gmail.com>
 <57B38CF7.5080803@oracle.com>
 <67c8abf7-df7c-444d-7876-d160a211c969@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <67c8abf7-df7c-444d-7876-d160a211c969@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, socketpair@gmail.com, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 08/17/2016 10:02 AM, Michael Kerrisk (man-pages) wrote:
> On 08/17/2016 10:00 AM, Vegard Nossum wrote:
>>>> Isn't there also a race where two or more concurrent pipe()/fnctl()
>>>> calls can together push us over the limits before the accounting is done?
>>>
>>> I guess there is!
>>>
>>>> I think there really ought to be a check after doing the accounting if
>>>> we really want to be meticulous here.
>>>
>>> Let me confirm what I understand from your comment: because of the race,
>>> then a user could subvert the checks and allocate an arbitrary amount
>>> of kernel memory for pipes. Right?

Forgot to respond to this earlier, sorry. It wouldn't be an arbitrary
amount exactly, as it would still be limited by the number of processes
you could get to allocate a pipe at exactly the right moment (since each 
pipe would still be bound by the limit by itself).

>>> I'm not sure what you mean by "a check after doing the accounting". Is not the
>>> only solution here some kind of lock around the check+accounting steps?
>>
>> Instead of doing atomic_long_read() in the check + atomic_long_add() for
>> accounting we could do a single speculative atomic_long_add_return() and
>> then if it goes above the limit we can lower it again with atomic_sub()
>> when aborting the operation (if it doesn't go above the limit we don't
>> need to do anything).
>
> So, would that mean something like the following (where I've moved
> some checks from pipe_fcntl() to pipe_set_size()):
[...]
> static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long nr_pages)
> {
>          struct pipe_buffer *bufs;
>          unsigned int size;
>          long ret = 0;
>
>          size = nr_pages * PAGE_SIZE;
>          account_pipe_buffers(pipe, pipe->buffers, nr_pages);
>
>          /*
>           * If trying to increase the pipe capacity, check that an
>           * unprivileged user is not trying to exceed various limits.
>           * (Decreasing the pipe capacity is always permitted, even
>           * if the user is currently over a limit.)
>           */
>          if (nr_pages > pipe->buffers) {
>                  if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
>                          ret = -EPERM;
>                  } else if ((too_many_pipe_buffers_hard(pipe->user, 0) ||
>                                  too_many_pipe_buffers_soft(pipe->user, 0)) &&
>                                  !capable(CAP_SYS_RESOURCE) &&
>                                  !capable(CAP_SYS_ADMIN)) {
>                          ret = -EPERM;
>                  }
>          }
>
> 	/*
> 	 * If we exceeded a limit, revert the accounting and go no further
>           */
>          if (ret) {
>                  account_pipe_buffers(pipe, nr_pages, pipe->buffers);
>                  return ret;
>          }
[...]
>
> Seem okay? Probably, some analogous fix is required in alloc_pipe_info()
> when creating a pipe(?).

I suppose that works. You could still have account_pipe_buffers() return
the value of the new &pipe->user->pipe_bufs directly like I suggested in
my previous email to avoid the extra atomic accesses in
too_many_pipe_buffers_{soft,hard}() but I guess nobody *really* cares
that much about performance here.

I am no authority on this code but it looks safe and sound to me.


Vegard
