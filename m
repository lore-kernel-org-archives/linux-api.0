From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/8] pipe: fix limit checking in pipe_set_size()
Date: Sat, 20 Aug 2016 11:17:46 +1200
Message-ID: <ea75f57d-9bb8-33b5-3b63-8f99f4981561@gmail.com>
References: <67ce15aa-cf43-0c89-d079-2d966177c56d@gmail.com>
 <7f0732a9-6172-e92d-7c5b-473b769fe37e@gmail.com>
 <57B6C3B7.2000903@oracle.com>
 <a451bb84-4a38-b00c-5bbb-dbaf914b8788@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a451bb84-4a38-b00c-5bbb-dbaf914b8788-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Willy Tarreau <w@1wt.eu>, socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08/20/2016 08:56 AM, Michael Kerrisk (man-pages) wrote:
> Hi Vegard,
> 
> On 08/19/2016 08:30 PM, Vegard Nossum wrote:
>> On 08/19/2016 07:25 AM, Michael Kerrisk (man-pages) wrote:
>>> The limit checking in pipe_set_size() (used by fcntl(F_SETPIPE_SZ))
>>> has the following problems:
>> [...]
>>> @@ -1030,6 +1030,7 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
>>>   {
>>>   	struct pipe_buffer *bufs;
>>>   	unsigned int size, nr_pages;
>>> +	long ret = 0;
>>>
>>>   	size = round_pipe_size(arg);
>>>   	nr_pages = size >> PAGE_SHIFT;
>>> @@ -1037,13 +1038,26 @@ static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
>>>   	if (!nr_pages)
>>>   		return -EINVAL;
>>>
>>> -	if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size)
>>> -		return -EPERM;
>>> +	account_pipe_buffers(pipe->user, pipe->buffers, nr_pages);
>>>
>>> -	if ((too_many_pipe_buffers_hard(pipe->user) ||
>>> -			too_many_pipe_buffers_soft(pipe->user)) &&
>>> -			!capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
>>> -		return -EPERM;
>>> +	/*
>>> +	 * If trying to increase the pipe capacity, check that an
>>> +	 * unprivileged user is not trying to exceed various limits.
>>> +	 * (Decreasing the pipe capacity is always permitted, even
>>> +	 * if the user is currently over a limit.)
>>> +	 */
>>> +	if (nr_pages > pipe->buffers) {
>>> +		if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
>>> +			ret = -EPERM;
>>> +			goto out_revert_acct;
>>> +		} else if ((too_many_pipe_buffers_hard(pipe->user) ||
>>> +				too_many_pipe_buffers_soft(pipe->user)) &&
>>> +				!capable(CAP_SYS_RESOURCE) &&
>>> +				!capable(CAP_SYS_ADMIN)) {
>>> +			ret = -EPERM;
>>> +			goto out_revert_acct;
>>> +		}
>>> +	}
>>
>> I'm slightly worried about not checking arg/nr_pages before we pass it
>> on to account_pipe_buffers().
>>
>> The potential problem happens if the user passes a very large number
>> which will overflow pipe->user->pipe_bufs.
>>
>> On 32-bit, sizeof(int) == sizeof(long), so if they pass arg = INT_MAX
>> then round_pipe_size() returns INT_MAX. Although it's true that the
>> accounting is done in terms of pages and not bytes, so you'd need on the
>> order of (1 << 13) = 8192 processes hitting the limit at the same time
>> in order to make it overflow, which seems a bit unlikely.
>>
>> (See https://lkml.org/lkml/2016/8/12/215 for another discussion on the
>> limit checking)
>>
>> Is there any reason why we couldn't do the (size > pipe_max_size) check
>> before calling account_pipe_buffers()?
> 
> No reason that I can see. Just a little more work to be done in the
> code, I think.

And, just so I make sure we're understanding each other... I assume you
mean changing the code here to something like:

static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
{
        struct pipe_buffer *bufs;
        unsigned int size, nr_pages;
        unsigned long user_bufs;
        long ret = 0;

        size = round_pipe_size(arg);
        nr_pages = size >> PAGE_SHIFT;

        if (!nr_pages)
                return -EINVAL;

        /*
         * If trying to increase the pipe capacity, check that an
         * unprivileged user is not trying to exceed various limits
         * (soft limit check here, hard limit check just below).
         * Decreasing the pipe capacity is always permitted, even
         * if the user is currently over a limit.
         */
        if (nr_pages > pipe->buffers &&
                        size > pipe_max_size && !capable(CAP_SYS_RESOURCE))
                return -EPERM;

        user_bufs = account_pipe_buffers(pipe->user, pipe->buffers, nr_pages);

        if (nr_pages > pipe->buffers &&
                        too_many_pipe_buffers_hard(user_bufs ||
                        too_many_pipe_buffers_soft(user_bufs)) &&
                        !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
                ret = -EPERM;
                goto out_revert_acct;
        }

Right?

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
