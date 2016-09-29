From: Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 5/8] pipe: simplify logic in alloc_pipe_info()
Date: Thu, 29 Sep 2016 13:46:40 +0200
Message-ID: <1e567c77-e33d-a8e3-83b5-346230e6acfa@oracle.com>
References: <ef9ce203-6683-31b1-26dc-e0b823aba73e@gmail.com>
 <aef030c1-0257-98a9-4988-186efa48530c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aef030c1-0257-98a9-4988-186efa48530c-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Willy Tarreau <w@1wt.eu>, socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08/29/2016 02:21 AM, Michael Kerrisk (man-pages) wrote:
> Replace an 'if' block that covers most of the code in this function
> with a 'goto'. This makes the code a little simpler to read, and also
> simplifies the next patch (fix limit checking in alloc_pipe_info())
>
> Cc: Willy Tarreau <w@1wt.eu>
> Cc: Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Cc: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/pipe.c | 45 +++++++++++++++++++++++----------------------
>  1 file changed, 23 insertions(+), 22 deletions(-)
>
> diff --git a/fs/pipe.c b/fs/pipe.c
> index f45a173..256fc5a 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -625,33 +625,34 @@ static bool too_many_pipe_buffers_hard(struct user_struct *user)
>  struct pipe_inode_info *alloc_pipe_info(void)
>  {
>  	struct pipe_inode_info *pipe;
> +	unsigned long pipe_bufs = PIPE_DEF_BUFFERS;
> +	struct user_struct *user = get_current_user();
>
>  	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL_ACCOUNT);
> -	if (pipe) {
> -		unsigned long pipe_bufs = PIPE_DEF_BUFFERS;
> -		struct user_struct *user = get_current_user();
> -
> -		if (!too_many_pipe_buffers_hard(user)) {
> -			if (too_many_pipe_buffers_soft(user))
> -				pipe_bufs = 1;
> -			pipe->bufs = kcalloc(pipe_bufs,
> -					     sizeof(struct pipe_buffer),
> -					     GFP_KERNEL_ACCOUNT);
> -		}
> +	if (pipe == NULL)
> +		goto out_free_uid;

if (!pipe) would probably be more canonical, but I don't know anybody
really cares.


Vegard
