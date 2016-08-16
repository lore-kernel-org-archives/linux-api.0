From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 2/2] pipe: make pipe user buffer limit checks more precise
Date: Tue, 16 Aug 2016 14:07:26 +0200
Message-ID: <57B301FE.9090108@oracle.com>
References: <86c85cff-7fee-cded-386a-e1d518573dda@gmail.com>
 <db82480c-7956-b89d-1f4e-ba2c94f4067e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <db82480c-7956-b89d-1f4e-ba2c94f4067e@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, socketpair@gmail.com, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 08/16/2016 01:14 PM, Michael Kerrisk (man-pages) wrote:
> As currently implemented, when creating a new pipe or increasing
> a pipe's capacity with fcntl(F_SETPIPE_SZ), the checks against
> the limits in /proc/sys/fs/pipe-user-pages-{soft,hard} (added by
> commit 759c01142a5d0) do not include the pages required for the
> new pipe or increased capacity.  In the case of fcntl(F_SETPIPE_SZ),
> this means that an unprivileged user can make a one-time capacity
> increase that pushes the user consumption over the limits by up
> to the value specified in /proc/sys/fs/pipe-max-size (which
> defaults to 1 MiB, but might be set to a much higher value).
>
> This patch remedies the problem by including the capacity required
> for the new pipe or the pipe capacity increase in the check against
> the limit.
>
> There is a small chance that this change could break user-space,
> since there are cases where pipe() and fcntl(F_SETPIPE_SZ) calls
> that previously succeeded might fail. However, the chances are
> small, since (a) the pipe-user-pages-{soft,hard} limits are new
> (in 4.5), and the default soft/hard limits are high/unlimited.
> Therefore, it seems warranted to make these limits operate more
> precisely (and behave more like what users probably expect).
>
> Using the test program shown in the previous patch, on an unpatched
> kernel, we first set some limits:
>
>      # echo 0 > /proc/sys/fs/pipe-user-pages-soft
>      # echo 1000000000 > /proc/sys/fs/pipe-max-size
>      # echo 10000 > /proc/sys/fs/pipe-user-pages-hard    # 40.96 MB
>
> Then show that we can set a pipe with capacity (100MB) that is
> over the hard limit
>
>      # sudo -u mtk ./test_F_SETPIPE_SZ 1 100000000
>      Loop 1: set pipe capacity to 100000000 bytes
>          F_SETPIPE_SZ returned 134217728
>
> Now set the capacity to 100MB twice. The second call fails (which is
> probably surprising to most users, since it seems like a no-op):
>
>      # sudo -u mtk ./test_F_SETPIPE_SZ 1 100000000 0 100000000
>      Loop 1: set pipe capacity to 100000000 bytes
>          F_SETPIPE_SZ returned 134217728
>      Loop 2: set pipe capacity to 100000000 bytes
>          Loop 2, pipe 0: F_SETPIPE_SZ failed: fcntl: Operation not permitted
>
> With a patched kernel, setting a capacity over the limit fails at the
> first attempt:
>
>      # echo 0 > /proc/sys/fs/pipe-user-pages-soft
>      # echo 1000000000 > /proc/sys/fs/pipe-max-size
>      # echo 10000 > /proc/sys/fs/pipe-user-pages-hard
>      # sudo -u mtk ./test_F_SETPIPE_SZ 1 100000000
>          Loop 1: set pipe capacity to 100000000 bytes
>              Loop 1, pipe 0: F_SETPIPE_SZ failed: fcntl: Operation not permitted
>
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: Vegard Nossum <vegard.nossum@oracle.com>
> Cc: socketpair@gmail.com
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: stable@vger.kernel.org
> Cc: linux-api@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
> ---
>   fs/pipe.c | 24 ++++++++++++++----------
>   1 file changed, 14 insertions(+), 10 deletions(-)
>
> diff --git a/fs/pipe.c b/fs/pipe.c
> index a98ebca..397d8d9 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -610,16 +610,20 @@ static void account_pipe_buffers(struct pipe_inode_info *pipe,
>   	atomic_long_add(new - old, &pipe->user->pipe_bufs);
>   }
>
> -static bool too_many_pipe_buffers_soft(struct user_struct *user)
> +static bool too_many_pipe_buffers_soft(struct user_struct *user,
> +				       unsigned int nr_pages)
>   {
>   	return pipe_user_pages_soft &&
> -	       atomic_long_read(&user->pipe_bufs) >= pipe_user_pages_soft;
> +	       atomic_long_read(&user->pipe_bufs) + nr_pages >=
> +			pipe_user_pages_soft;
>   }
>
> -static bool too_many_pipe_buffers_hard(struct user_struct *user)
> +static bool too_many_pipe_buffers_hard(struct user_struct *user,
> +				       unsigned int nr_pages)
>   {
>   	return pipe_user_pages_hard &&
> -	       atomic_long_read(&user->pipe_bufs) >= pipe_user_pages_hard;
> +	       atomic_long_read(&user->pipe_bufs) + nr_pages >=
> +			pipe_user_pages_hard;
>   }
>
>   struct pipe_inode_info *alloc_pipe_info(void)
> @@ -631,13 +635,13 @@ struct pipe_inode_info *alloc_pipe_info(void)
>   		unsigned long pipe_bufs = PIPE_DEF_BUFFERS;
>   		struct user_struct *user = get_current_user();
>
> -		if (!too_many_pipe_buffers_hard(user)) {
> -			if (too_many_pipe_buffers_soft(user))
> -				pipe_bufs = 1;
> +		if (too_many_pipe_buffers_soft(user, PIPE_DEF_BUFFERS))

Why not pass pipe_bufs here instead of PIPE_DEF_BUFFERS?

> +			pipe_bufs = 1;
> +
> +		if (!too_many_pipe_buffers_hard(user, pipe_bufs))
>   			pipe->bufs = kcalloc(pipe_bufs,
>   					     sizeof(struct pipe_buffer),
>   					     GFP_KERNEL_ACCOUNT);
> -		}
>
>   		if (pipe->bufs) {
>   			init_waitqueue_head(&pipe->wait);

Not your fault, but this function is a bit weird in that if the
too_many_pipe_buffers() calls fail, we'll return ENFILE to userspace?
Same if kcalloc() fails.

> @@ -1132,8 +1136,8 @@ long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
>   			if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
>   				ret = -EPERM;
>   				goto out;
> -			} else if ((too_many_pipe_buffers_hard(pipe->user) ||
> -				too_many_pipe_buffers_soft(pipe->user)) &&
> +			} else if ((too_many_pipe_buffers_hard(pipe->user, nr_pages) ||
> +				too_many_pipe_buffers_soft(pipe->user, nr_pages)) &&
>   				!capable(CAP_SYS_RESOURCE) &&
>   				!capable(CAP_SYS_ADMIN)) {
>   				ret = -EPERM;
>

Isn't there also a race where two or more concurrent pipe()/fnctl()
calls can together push us over the limits before the accounting is done?

I think there really ought to be a check after doing the accounting if
we really want to be meticulous here.

Thanks for fixing these and good catch!


Vegard
