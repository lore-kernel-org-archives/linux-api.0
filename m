From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [Cluster-devel] [PATCH v5 6/7] fs: pass iocb to generic_write_sync
Date: Thu, 06 Nov 2014 10:18:41 +0000
Message-ID: <545B4B01.3080404@redhat.com>
References: <cover.1415220890.git.milosz@adfin.com> <5d53ede333de7cade713190e2b93e2dbadefa260.1415220890.git.milosz@adfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <5d53ede333de7cade713190e2b93e2dbadefa260.1415220890.git.milosz@adfin.com>
Sender: owner-linux-aio@kvack.org
To: Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-aio@kvack.org, Volker Lendecke <Volker.Lendecke@sernet.de>, Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-api@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, cluster-devel@redhat.com, Mel Gorman <mgorman@suse.de>, linux-fsdevel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Andrew Price <anprice@redhat.com>
List-Id: linux-api@vger.kernel.org

Hi,

On 05/11/14 21:14, Milosz Tanski wrote:
> From: Christoph Hellwig <hch@lst.de>
>
> Clean up the generic_write_sync by just passing an iocb and a bytes
> written / negative errno argument.  In addition to simplifying the
> callers this also prepares for passing a per-operation O_DSYNC
> flag.  Two callers didn't quite fit that scheme:
>
>   - dio_complete didn't both to update ki_pos as we don't need it
>     on a iocb that is about to be freed, so we had to add it. Additionally
>     it also synced out written data in the error case, which has been
>     changed to operate like the other callers.
>   - gfs2 also used generic_write_sync to implement a crude version
>     of fallocate.  It has been switched to use an open coded variant
>     instead.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
GFS2 bits:

Acked-by: Steven Whitehouse <swhiteho@redhat.com>

I know that Andy Price has some work in this area too, so in due course 
we'll have to be careful not to create a merge conflict here. Copying in 
Andy so he can see the changes,

Steve.

> ---
>   fs/block_dev.c     |  8 +-------
>   fs/btrfs/file.c    |  7 ++-----
>   fs/cifs/file.c     |  8 +-------
>   fs/direct-io.c     |  8 ++------
>   fs/ext4/file.c     |  8 +-------
>   fs/gfs2/file.c     |  9 +++++++--
>   fs/ntfs/file.c     |  8 ++------
>   fs/udf/file.c      | 11 ++---------
>   fs/xfs/xfs_file.c  |  8 +-------
>   include/linux/fs.h |  8 +-------
>   mm/filemap.c       | 30 ++++++++++++++++++++----------
>   11 files changed, 40 insertions(+), 73 deletions(-)
>
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index cc9d411..c529b1c 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1568,18 +1568,12 @@ static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>    */
>   ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   {
> -	struct file *file = iocb->ki_filp;
>   	struct blk_plug plug;
>   	ssize_t ret;
>   
>   	blk_start_plug(&plug);
>   	ret = __generic_file_write_iter(iocb, from);
> -	if (ret > 0) {
> -		ssize_t err;
> -		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
> -		if (err < 0)
> -			ret = err;
> -	}
> +	ret = generic_write_sync(iocb, ret);
>   	blk_finish_plug(&plug);
>   	return ret;
>   }
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index a18ceab..4f4a6f7 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1820,11 +1820,8 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>   	 */
>   	BTRFS_I(inode)->last_trans = root->fs_info->generation + 1;
>   	BTRFS_I(inode)->last_sub_trans = root->log_transid;
> -	if (num_written > 0) {
> -		err = generic_write_sync(file, pos, num_written);
> -		if (err < 0)
> -			num_written = err;
> -	}
> +
> +	num_written = generic_write_sync(iocb, num_written);
>   
>   	if (sync)
>   		atomic_dec(&BTRFS_I(inode)->sync_writers);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index c485afa..32359de 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2706,13 +2706,7 @@ cifs_writev(struct kiocb *iocb, struct iov_iter *from)
>   		rc = __generic_file_write_iter(iocb, from);
>   		mutex_unlock(&inode->i_mutex);
>   
> -		if (rc > 0) {
> -			ssize_t err;
> -
> -			err = generic_write_sync(file, iocb->ki_pos - rc, rc);
> -			if (err < 0)
> -				rc = err;
> -		}
> +		rc = generic_write_sync(iocb, rc);
>   	} else {
>   		mutex_unlock(&inode->i_mutex);
>   	}
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index e181b6b..b72ac83 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -257,12 +257,8 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
>   	inode_dio_done(dio->inode);
>   	if (is_async) {
>   		if (dio->rw & WRITE) {
> -			int err;
> -
> -			err = generic_write_sync(dio->iocb->ki_filp, offset,
> -						 transferred);
> -			if (err < 0 && ret > 0)
> -				ret = err;
> +			dio->iocb->ki_pos = offset + transferred;
> +			ret = generic_write_sync(dio->iocb, ret);
>   		}
>   
>   		aio_complete(dio->iocb, ret, 0);
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index aca7b24..79b000c 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -175,13 +175,7 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   	ret = __generic_file_write_iter(iocb, from);
>   	mutex_unlock(&inode->i_mutex);
>   
> -	if (ret > 0) {
> -		ssize_t err;
> -
> -		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
> -		if (err < 0)
> -			ret = err;
> -	}
> +	ret = generic_write_sync(iocb, ret);
>   	if (o_direct)
>   		blk_finish_plug(&plug);
>   
> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> index 80dd44d..3fafeca 100644
> --- a/fs/gfs2/file.c
> +++ b/fs/gfs2/file.c
> @@ -895,8 +895,13 @@ retry:
>   		gfs2_quota_unlock(ip);
>   	}
>   
> -	if (error == 0)
> -		error = generic_write_sync(file, pos, count);
> +	if (error)
> +		goto out_unlock;
> +
> +	if ((file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host)) {
> +		error = vfs_fsync_range(file, pos, pos + count - 1,
> +			       (file->f_flags & __O_SYNC) ? 0 : 1);
> +	}
>   	goto out_unlock;
>   
>   out_trans_fail:
> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> index 643faa4..4f3d664 100644
> --- a/fs/ntfs/file.c
> +++ b/fs/ntfs/file.c
> @@ -2127,12 +2127,8 @@ static ssize_t ntfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>   	mutex_lock(&inode->i_mutex);
>   	ret = ntfs_file_aio_write_nolock(iocb, iov, nr_segs, &iocb->ki_pos);
>   	mutex_unlock(&inode->i_mutex);
> -	if (ret > 0) {
> -		int err = generic_write_sync(file, iocb->ki_pos - ret, ret);
> -		if (err < 0)
> -			ret = err;
> -	}
> -	return ret;
> +
> +	return generic_write_sync(iocb, ret);
>   }
>   
>   /**
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index bb15771..1cdabd0 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -155,16 +155,9 @@ static ssize_t udf_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   	retval = __generic_file_write_iter(iocb, from);
>   	mutex_unlock(&inode->i_mutex);
>   
> -	if (retval > 0) {
> -		ssize_t err;
> -
> +	if (retval > 0)
>   		mark_inode_dirty(inode);
> -		err = generic_write_sync(file, iocb->ki_pos - retval, retval);
> -		if (err < 0)
> -			retval = err;
> -	}
> -
> -	return retval;
> +	return generic_write_sync(iocb, retval);
>   }
>   
>   long udf_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 0655915..a8cab66 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -792,14 +792,8 @@ xfs_file_write_iter(
>   		ret = xfs_file_buffered_aio_write(iocb, from);
>   
>   	if (ret > 0) {
> -		ssize_t err;
> -
>   		XFS_STATS_ADD(xs_write_bytes, ret);
> -
> -		/* Handle various SYNC-type writes */
> -		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
> -		if (err < 0)
> -			ret = err;
> +		ret = generic_write_sync(iocb, ret);
>   	}
>   	return ret;
>   }
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index eaebd99..7d0e116 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2242,13 +2242,7 @@ extern int filemap_fdatawrite_range(struct address_space *mapping,
>   extern int vfs_fsync_range(struct file *file, loff_t start, loff_t end,
>   			   int datasync);
>   extern int vfs_fsync(struct file *file, int datasync);
> -static inline int generic_write_sync(struct file *file, loff_t pos, loff_t count)
> -{
> -	if (!(file->f_flags & O_DSYNC) && !IS_SYNC(file->f_mapping->host))
> -		return 0;
> -	return vfs_fsync_range(file, pos, pos + count - 1,
> -			       (file->f_flags & __O_SYNC) ? 0 : 1);
> -}
> +extern int generic_write_sync(struct kiocb *iocb, loff_t count);
>   extern void emergency_sync(void);
>   extern void emergency_remount(void);
>   #ifdef CONFIG_BLOCK
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 09d3af3..6107058 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2664,6 +2664,24 @@ out:
>   }
>   EXPORT_SYMBOL(__generic_file_write_iter);
>   
> +int generic_write_sync(struct kiocb *iocb, loff_t count)
> +{
> +	struct file *file = iocb->ki_filp;
> +
> +	if (count > 0 &&
> +	    ((file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host))) {
> +		bool fdatasync = !(file->f_flags & __O_SYNC);
> +		ssize_t ret = 0;
> +
> +		ret = vfs_fsync_range(file, iocb->ki_pos - count,
> +				iocb->ki_pos - 1, fdatasync);
> +		if (ret < 0)
> +			return ret;
> +	}
> +	return count;
> +}
> +EXPORT_SYMBOL(generic_write_sync);
> +
>   /**
>    * generic_file_write_iter - write data to a file
>    * @iocb:	IO state structure
> @@ -2675,22 +2693,14 @@ EXPORT_SYMBOL(__generic_file_write_iter);
>    */
>   ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   {
> -	struct file *file = iocb->ki_filp;
> -	struct inode *inode = file->f_mapping->host;
> +	struct inode *inode = iocb->ki_filp->f_mapping->host;
>   	ssize_t ret;
>   
>   	mutex_lock(&inode->i_mutex);
>   	ret = __generic_file_write_iter(iocb, from);
>   	mutex_unlock(&inode->i_mutex);
>   
> -	if (ret > 0) {
> -		ssize_t err;
> -
> -		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
> -		if (err < 0)
> -			ret = err;
> -	}
> -	return ret;
> +	return generic_write_sync(iocb, ret);
>   }
>   EXPORT_SYMBOL(generic_file_write_iter);
>   

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
