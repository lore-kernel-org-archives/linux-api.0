From: Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] pipe: make account_pipe_buffers() return a value, and
 use it
Date: Fri, 19 Aug 2016 11:36:03 +0200
Message-ID: <57B6D303.2060301@oracle.com>
References: <67ce15aa-cf43-0c89-d079-2d966177c56d@gmail.com>
 <676aa52b-c4fc-3bf1-8051-39deca8bf0ab@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <676aa52b-c4fc-3bf1-8051-39deca8bf0ab-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Willy Tarreau <w@1wt.eu>, socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08/19/2016 07:25 AM, Michael Kerrisk (man-pages) wrote:
> This is an optional patch, to provide a small performance improvement.
> Alter account_pipe_buffers() so that it returns the new value in
> user->pipe_bufs. This means that we can refactor too_many_pipe_buffers_soft()
> and too_many_pipe_buffers_hard() to avoid the costs of repeated use of
> atomic_long_read() to get the value user->pipe_bufs.
[...]
> @@ -627,17 +625,18 @@ struct pipe_inode_info *alloc_pipe_info(void)
>   	struct pipe_inode_info *pipe;
>   	unsigned long pipe_bufs = PIPE_DEF_BUFFERS;
>   	struct user_struct *user = get_current_user();
> +	unsigned long num_bufs;

Maybe user_bufs would be more descriptive since num_bufs is a bit
ambiguous without the context.

>
>   	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL_ACCOUNT);
>   	if (pipe == NULL)
>   		goto out_free_uid;
>
> -	if (too_many_pipe_buffers_soft(user))
> +	if (too_many_pipe_buffers_soft(atomic_long_read(&user->pipe_bufs)))
>   		pipe_bufs = 1;
>
> -	account_pipe_buffers(user, 0, pipe_bufs);
> +	num_bufs = account_pipe_buffers(user, 0, pipe_bufs);
>
> -	if (too_many_pipe_buffers_hard(user))
> +	if (too_many_pipe_buffers_hard(num_bufs))
>   		goto out_revert_acct;
>
>   	pipe->bufs = kcalloc(pipe_bufs, sizeof(struct pipe_buffer),

Why not structure it like this?

num_bufs = account_pipe_buffers(user, 0, pipe_bufs);
if (too_many_pipe_buffers_soft(num_bufs)) {
	num_bufs = account_pipe_buffers(user, pipe_bufs, 1);
	pipe_bufs = 1;
}
if (too_many_pipe_buffers_hard(num_bufs))
	goto out_revert_acct;

Otherwise you still have the case that somebody makes it past
too_many_pipe_buffers_soft() before the accounting is done.


Vegard
