From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v7 03/12] fs: introduce i_mapdcount
Date: Mon, 9 Oct 2017 14:08:24 +1100
Message-ID: <20171009030824.GG3666@dastard>
References: <150732931273.22363.8436792888326501071.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150732933283.22363.570426117546397495.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <150732933283.22363.570426117546397495.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 06, 2017 at 03:35:32PM -0700, Dan Williams wrote:
> When ->iomap_begin() sees this count being non-zero and determines that
> the block map of the file needs to be modified to satisfy the I/O
> request it will instead return an error. This is needed for MAP_DIRECT
> where, due to locking constraints, we can't rely on xfs_break_layouts()
> to protect against allocating write-faults either from the process that
> setup the MAP_DIRECT mapping nor other processes that have the file
> mapped.  xfs_break_layouts() requires XFS_IOLOCK which is problematic to
> mix with the XFS_MMAPLOCK in the fault path.
> 
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
> Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
> Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  fs/xfs/xfs_iomap.c |    9 +++++++++
>  include/linux/fs.h |   31 +++++++++++++++++++++++++++++++
>  2 files changed, 40 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index a1909bc064e9..6816f8ebbdcf 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1053,6 +1053,15 @@ xfs_file_iomap_begin(
>  			goto out_unlock;
>  		}
>  		/*
> +		 * If a file has MAP_DIRECT mappings disable block map
> +		 * updates. This should only effect mmap write faults as
> +		 * other paths are protected by an FL_LAYOUT lease.
> +		 */
> +		if (i_mapdcount_read(inode)) {
> +			error = -ETXTBSY;
> +			goto out_unlock;
> +		}

That looks really fragile. For one, it's going to miss modifications
to reflinked files altogether. Ignoring that, however, I don't want to
have to care one bit about the internals of the MAP_DIRECT
implementation in the filesystem code. Hide it behind something with
an obvious name that returns the appropriate error and the
filesystem code becomes self documenting:

	if ((flags & IOMAP_WRITE) && imap_needs_alloc(inode, &imap, nimaps)) {
		.....
		error = iomap_can_allocate(inode);
		if (error)
			goto out_unlock;

Then you can put all the MAP_DIRECT stuff and the comments
explaining what is does inside the generic function that determines
if we are allowed to allocate on that inode or not.

> +		/*
>  		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
>  		 * pages to keep the chunks of work done where somewhat symmetric
>  		 * with the work writeback does. This is a completely arbitrary
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c2b9bf3dc4e9..f83871b188ff 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -642,6 +642,9 @@ struct inode {
>  	atomic_t		i_count;
>  	atomic_t		i_dio_count;
>  	atomic_t		i_writecount;
> +#ifdef CONFIG_FS_DAX
> +	atomic_t		i_mapdcount;	/* count of MAP_DIRECT vmas */
> +#endif

Is there any way to avoid growing the struct inode for this?

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
