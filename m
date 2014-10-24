From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] vfs: Prepare for adding a new preadv/pwritev with
 user flags.
Date: Fri, 24 Oct 2014 02:35:18 -0700
Message-ID: <20141024093518.GA29178@infradead.org>
References: <cover.1413923420.git.milosz@adfin.com>
 <9306856a3ea74bcc41523430d74ef4be93d8f436.1413923420.git.milosz@adfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <9306856a3ea74bcc41523430d74ef4be93d8f436.1413923420.git.milosz@adfin.com>
Sender: owner-linux-aio@kvack.org
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 21, 2014 at 04:46:56PM -0400, Milosz Tanski wrote:
> Plumbing the flags argument through the vfs code so they can be passed down to
> __generic_file_(read/write)_iter function that do the acctual work.
> 
> Signed-off-by: Milosz Tanski <milosz@adfin.com>


The last hunk doesn't belong into this patch, both logically and because
the code won't actually compile after applying just this patch.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>


This is the culprit:

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 14b4642..cb7f530 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1465,7 +1465,7 @@ static void shrink_readahead_size_eio(struct file *filp,
>   * of the logic when it comes to error handling etc.
>   */
>  static ssize_t do_generic_file_read(struct file *filp, loff_t *ppos,
> -		struct iov_iter *iter, ssize_t written)
> +		struct iov_iter *iter, ssize_t written, int flags)
>  {
>  	struct address_space *mapping = filp->f_mapping;
>  	struct inode *inode = mapping->host;

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
