From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/8] pipe: fix limit checking in pipe_set_size()
Date: Mon, 22 Aug 2016 09:14:27 +1200
Message-ID: <8b893c3b-aa41-ffb3-a652-a42a746d26fb@gmail.com>
References: <67ce15aa-cf43-0c89-d079-2d966177c56d@gmail.com>
 <7f0732a9-6172-e92d-7c5b-473b769fe37e@gmail.com>
 <57B6C3B7.2000903@oracle.com>
 <a451bb84-4a38-b00c-5bbb-dbaf914b8788@gmail.com>
 <ea75f57d-9bb8-33b5-3b63-8f99f4981561@gmail.com>
 <f99fff13-aacf-8673-8553-366f6c952654@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f99fff13-aacf-8673-8553-366f6c952654-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Willy Tarreau <w@1wt.eu>, socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08/21/2016 10:33 PM, Vegard Nossum wrote:
> On 08/20/2016 01:17 AM, Michael Kerrisk (man-pages) wrote:
>> On 08/20/2016 08:56 AM, Michael Kerrisk (man-pages) wrote:
>>> On 08/19/2016 08:30 PM, Vegard Nossum wrote:
>>>> Is there any reason why we couldn't do the (size > pipe_max_size) check
>>>> before calling account_pipe_buffers()?
>>>
>>> No reason that I can see. Just a little more work to be done in the
>>> code, I think.
>>
>> And, just so I make sure we're understanding each other... I assume you
>> mean changing the code here to something like:
> [...]
>>         if (nr_pages > pipe->buffers &&
>>                         size > pipe_max_size && !capable(CAP_SYS_RESOURCE))
>>                 return -EPERM;
>>
>>         user_bufs = account_pipe_buffers(pipe->user, pipe->buffers, nr_pages);
>>
>>         if (nr_pages > pipe->buffers &&
>>                         too_many_pipe_buffers_hard(user_bufs ||
>>                         too_many_pipe_buffers_soft(user_bufs)) &&
>>                         !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
>>                 ret = -EPERM;
>>                 goto out_revert_acct;
>>         }
>>
>> Right?
> 
> Yup, that's what I had in mind.

Okay -- changed.

> (The parantheses are messed up though.)

Yup, was just a quick untested edit to make sure we meant the same thing.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
