From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 4/8] pipe: fix limit checking in pipe_set_size()
Date: Fri, 19 Aug 2016 07:48:18 +0200
Message-ID: <20160819054818.GH17944@1wt.eu>
References: <67ce15aa-cf43-0c89-d079-2d966177c56d@gmail.com>
 <7f0732a9-6172-e92d-7c5b-473b769fe37e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7f0732a9-6172-e92d-7c5b-473b769fe37e-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vegard Nossum <vegard.nossum-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, socketpair-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Michael,

Since you're changing this code, it's probably worth swapping the size
check and capable() below to save a function call in the normal path :

On Fri, Aug 19, 2016 at 05:25:35PM +1200, Michael Kerrisk (man-pages) wrote:
> +	if (nr_pages > pipe->buffers) {
> +		if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {

=>		if (size > pipe_max_size && !capable(CAP_SYS_RESOURCE)) {

> +			ret = -EPERM;
> +			goto out_revert_acct;
> +		} else if ((too_many_pipe_buffers_hard(pipe->user) ||
> +				too_many_pipe_buffers_soft(pipe->user)) &&
> +				!capable(CAP_SYS_RESOURCE) &&
> +				!capable(CAP_SYS_ADMIN)) {
> +			ret = -EPERM;
> +			goto out_revert_acct;
> +		}
> +	}
(...)

Cheers,
Willy
