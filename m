From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 7/8] pipe: make account_pipe_buffers() return a value, and
 use it
Date: Sat, 20 Aug 2016 08:51:32 +1200
Message-ID: <2742a9f6-e137-9ee3-2f24-63f3fe273450@gmail.com>
References: <67ce15aa-cf43-0c89-d079-2d966177c56d@gmail.com>
 <676aa52b-c4fc-3bf1-8051-39deca8bf0ab@gmail.com>
 <57B6D303.2060301@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <57B6D303.2060301@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vegard Nossum <vegard.nossum@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: mtk.manpages@gmail.com, Willy Tarreau <w@1wt.eu>, socketpair@gmail.com, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 08/19/2016 09:36 PM, Vegard Nossum wrote:
> On 08/19/2016 07:25 AM, Michael Kerrisk (man-pages) wrote:
>> This is an optional patch, to provide a small performance improvement.
>> Alter account_pipe_buffers() so that it returns the new value in
>> user->pipe_bufs. This means that we can refactor too_many_pipe_buffers_soft()
>> and too_many_pipe_buffers_hard() to avoid the costs of repeated use of
>> atomic_long_read() to get the value user->pipe_bufs.
> [...]
>> @@ -627,17 +625,18 @@ struct pipe_inode_info *alloc_pipe_info(void)
>>   	struct pipe_inode_info *pipe;
>>   	unsigned long pipe_bufs = PIPE_DEF_BUFFERS;
>>   	struct user_struct *user = get_current_user();
>> +	unsigned long num_bufs;
> 
> Maybe user_bufs would be more descriptive since num_bufs is a bit
> ambiguous without the context.

Okay -- changed.

>>   	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL_ACCOUNT);
>>   	if (pipe == NULL)
>>   		goto out_free_uid;
>>
>> -	if (too_many_pipe_buffers_soft(user))
>> +	if (too_many_pipe_buffers_soft(atomic_long_read(&user->pipe_bufs)))
>>   		pipe_bufs = 1;
>>
>> -	account_pipe_buffers(user, 0, pipe_bufs);
>> +	num_bufs = account_pipe_buffers(user, 0, pipe_bufs);
>>
>> -	if (too_many_pipe_buffers_hard(user))
>> +	if (too_many_pipe_buffers_hard(num_bufs))
>>   		goto out_revert_acct;
>>
>>   	pipe->bufs = kcalloc(pipe_bufs, sizeof(struct pipe_buffer),
> 
> Why not structure it like this?
> 
> num_bufs = account_pipe_buffers(user, 0, pipe_bufs);
> if (too_many_pipe_buffers_soft(num_bufs)) {
> 	num_bufs = account_pipe_buffers(user, pipe_bufs, 1);
> 	pipe_bufs = 1;
> }
> if (too_many_pipe_buffers_hard(num_bufs))
> 	goto out_revert_acct;
> 
> Otherwise you still have the case that somebody makes it past
> too_many_pipe_buffers_soft() before the accounting is done.

Ahh -- thanks! I knew there was a small glitch there, but decided to 
ignore it because didn't see the obvious solution. Fixed in 6/8 patch.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
