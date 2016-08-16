From: Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] pipe: check limits only when increasing pipe capacity
Date: Tue, 16 Aug 2016 13:55:01 +0200
Message-ID: <57B2FF15.503@oracle.com>
References: <86c85cff-7fee-cded-386a-e1d518573dda@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86c85cff-7fee-cded-386a-e1d518573dda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Willy Tarreau <w@1wt.eu>, socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08/16/2016 01:10 PM, Michael Kerrisk (man-pages) wrote:
> When changing a pipe's capacity with fcntl(F_SETPIPE_SZ), various
> limits defined by /proc/sys/fs/pipe-* files are checked to see
> if unprivileged users are exceeding limits on memory consumption.
>
[...]

> ---
>   fs/pipe.c | 25 +++++++++++++++++--------
>   1 file changed, 17 insertions(+), 8 deletions(-)
>
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 4ebe6b2..a98ebca 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -1122,14 +1122,23 @@ long pipe_fcntl(struct file *file, unsigned int cmd, unsigned long arg)
>   		if (!nr_pages)
>   			goto out;
>
> -		if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
> -			ret = -EPERM;
> -			goto out;
> -		} else if ((too_many_pipe_buffers_hard(pipe->user) ||
> -			    too_many_pipe_buffers_soft(pipe->user)) &&
> -		           !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN)) {
> -			ret = -EPERM;
> -			goto out;
> +		/*
> +		 * If trying to increase the pipe capacity, check that an
> +		 * unprivileged user is not trying to exceed various limits.
> +		 * (Decreasing the pipe capacity is always permitted, even
> +		 * if the user is currently over a limit.)
> +		 */
> +		if (nr_pages > pipe->buffers) {
> +			if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
> +				ret = -EPERM;
> +				goto out;
> +			} else if ((too_many_pipe_buffers_hard(pipe->user) ||
> +				too_many_pipe_buffers_soft(pipe->user)) &&
> +				!capable(CAP_SYS_RESOURCE) &&
> +				!capable(CAP_SYS_ADMIN)) {
> +				ret = -EPERM;
> +				goto out;
> +			}
>   		}
>   		ret = pipe_set_size(pipe, nr_pages);
>   		break;
>

FWIW: Reviewed-by: Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>


Vegard
