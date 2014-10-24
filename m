From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] vfs: Define new syscalls preadv2,pwritev2
Date: Fri, 24 Oct 2014 02:36:59 -0700
Message-ID: <20141024093659.GB29178@infradead.org>
References: <cover.1413923420.git.milosz@adfin.com>
 <1613303dfaa91e6ff09cdd7860e0316765663ba6.1413923420.git.milosz@adfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <1613303dfaa91e6ff09cdd7860e0316765663ba6.1413923420.git.milosz@adfin.com>
Sender: owner-linux-aio@kvack.org
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

> diff --git a/mm/filemap.c b/mm/filemap.c
> index cb7f530..45964c8 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1735,7 +1735,7 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
>  		}
>  	}
>  
> -	retval = do_generic_file_read(file, ppos, iter, retval);
> +	retval = do_generic_file_read(file, ppos, iter, retval, iocb->ki_rwflags);

I think this belongs into the last patch, together with the last hunk
from the first patch.

Otherwise looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
