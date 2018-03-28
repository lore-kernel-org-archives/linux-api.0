From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] aio: remove an outdated comment in aio_complete
Date: Wed, 28 Mar 2018 09:05:58 -0700
Message-ID: <20180328160558.GB11581@magnolia>
References: <20180328072639.16885-1-hch@lst.de>
 <20180328072639.16885-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180328072639.16885-3-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 28, 2018 at 09:26:35AM +0200, Christoph Hellwig wrote:
> These days we don't treat sync iocbs special in the aio completion code as
> they never use it.  Remove the old comment and BUG_ON given that the
> current definition of is_sync_kiocb makes it impossible to hit.
> iocb to the top of the function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah that looks fairly impossible now...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/aio.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 03d59593912d..f536b0f249d4 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1100,15 +1100,6 @@ static void aio_complete(struct kiocb *kiocb, long res, long res2)
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
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
