From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/36] fs: unexport poll_schedule_timeout
Date: Mon, 19 Mar 2018 19:13:14 -0700
Message-ID: <20180320021314.GF7282@magnolia>
References: <20180305212743.16664-1-hch@lst.de>
 <20180305212743.16664-10-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180305212743.16664-10-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 05, 2018 at 01:27:16PM -0800, Christoph Hellwig wrote:
> No users outside of select.c.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/select.c          | 3 +--
>  include/linux/poll.h | 2 --
>  2 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/select.c b/fs/select.c
> index b6c36254028a..686de7b3a1db 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -233,7 +233,7 @@ static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
>  	add_wait_queue(wait_address, &entry->wait);
>  }
>  
> -int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
> +static int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
>  			  ktime_t *expires, unsigned long slack)
>  {
>  	int rc = -EINTR;
> @@ -258,7 +258,6 @@ int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
>  
>  	return rc;
>  }
> -EXPORT_SYMBOL(poll_schedule_timeout);
>  
>  /**
>   * poll_select_set_timeout - helper function to setup the timeout value
> diff --git a/include/linux/poll.h b/include/linux/poll.h
> index f45ebd017eaa..a3576da63377 100644
> --- a/include/linux/poll.h
> +++ b/include/linux/poll.h
> @@ -96,8 +96,6 @@ struct poll_wqueues {
>  
>  extern void poll_initwait(struct poll_wqueues *pwq);
>  extern void poll_freewait(struct poll_wqueues *pwq);
> -extern int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
> -				 ktime_t *expires, unsigned long slack);
>  extern u64 select_estimate_accuracy(struct timespec64 *tv);
>  
>  #define MAX_INT64_SECONDS (((s64)(~((u64)0)>>1)/HZ)-1)
> -- 
> 2.14.2
> 

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
