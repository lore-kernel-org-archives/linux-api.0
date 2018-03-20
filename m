From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/36] aio: don't print the page size at boot time
Date: Mon, 19 Mar 2018 17:11:07 -0700
Message-ID: <20180320001107.GD4860@magnolia>
References: <20180305212743.16664-1-hch@lst.de>
 <20180305212743.16664-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180305212743.16664-2-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 05, 2018 at 01:27:08PM -0800, Christoph Hellwig wrote:
> The page size is in no way related to the aio code, and printing it in
> the (debug) dmesg at every boot serves no purpose.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/aio.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index a062d75109cb..03d59593912d 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -264,9 +264,6 @@ static int __init aio_setup(void)
>  
>  	kiocb_cachep = KMEM_CACHE(aio_kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
>  	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
> -
> -	pr_debug("sizeof(struct page) = %zu\n", sizeof(struct page));
> -
>  	return 0;
>  }
>  __initcall(aio_setup);
> -- 
> 2.14.2
> 

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
