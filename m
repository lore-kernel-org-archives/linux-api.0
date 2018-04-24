From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/7] aio: remove an outdated BUG_ON and comment in
 aio_complete
Date: Tue, 24 Apr 2018 14:27:57 -0700
Message-ID: <20180424212757.GA26258@magnolia>
References: <20180415150108.1341-1-hch@lst.de>
 <20180415150108.1341-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180415150108.1341-3-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, Apr 15, 2018 at 05:01:03PM +0200, Christoph Hellwig wrote:
> These days we don't treat sync iocbs special in the aio completion code as
> they never use it.  Remove the old comment and BUG_ON given that the
> current definition of is_sync_kiocb makes it impossible to hit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/aio.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index add46b06be86..7c1855afd723 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1107,15 +1107,6 @@ static void aio_complete(struct kiocb *kiocb, long res, long res2)
>  		file_end_write(file);
>  	}
>  
> -	/*
> -	 * Special case handling for sync iocbs:
> -	 *  - events go directly into the iocb for fast handling
> -	 *  - the sync task with the iocb in its stack holds the single iocb
> -	 *    ref, no other paths have a way to get another ref
> -	 *  - the sync task helpfully left a reference to itself in the iocb
> -	 */
> -	BUG_ON(is_sync_kiocb(kiocb));
> -
>  	if (iocb->ki_list.next) {
>  		unsigned long flags;
>  
> -- 
> 2.17.0
> 

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
