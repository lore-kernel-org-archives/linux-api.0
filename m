From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 30/31] timerfd: convert to ->poll_mask
Date: Tue, 22 May 2018 19:59:39 +0300
Message-ID: <77dea8cf-d7e0-75ff-91c4-3bd0379e7464@cogentembedded.com>
References: <20180522113108.25713-1-hch@lst.de>
 <20180522113108.25713-31-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180522113108.25713-31-hch@lst.de>
Content-Language: en-MW
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello!

On 05/22/2018 02:31 PM, Christoph Hellwig wrote:

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/timerfd.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/timerfd.c b/fs/timerfd.c
> index cdad49da3ff7..d84a2bee4f82 100644
> --- a/fs/timerfd.c
> +++ b/fs/timerfd.c
> @@ -226,21 +226,20 @@ static int timerfd_release(struct inode *inode, struct file *file)
>  	kfree_rcu(ctx, rcu);
>  	return 0;
>  }
> -
> -static __poll_t timerfd_poll(struct file *file, poll_table *wait)
> +	

   Stray tab detected! :-)

> +static struct wait_queue_head *timerfd_get_poll_head(struct file *file,
> +		__poll_t eventmask)
>  {
>  	struct timerfd_ctx *ctx = file->private_data;
> -	__poll_t events = 0;
> -	unsigned long flags;
>  
> -	poll_wait(file, &ctx->wqh, wait);
> +	return &ctx->wqh;
> +}
>  
> -	spin_lock_irqsave(&ctx->wqh.lock, flags);
> -	if (ctx->ticks)
> -		events |= EPOLLIN;
> -	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
> +static __poll_t timerfd_poll_mask(struct file *file, __poll_t eventmask)
> +{
> +	struct timerfd_ctx *ctx = file->private_data;
>  
> -	return events;
> +	return ctx->ticks ? EPOLLIN : 0;
>  }
>  
>  static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
[...]

MBR, Sergei

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
