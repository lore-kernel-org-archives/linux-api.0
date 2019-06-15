From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v4 10/16] fs-verity: implement
 FS_IOC_ENABLE_VERITY ioctl
Date: Sat, 15 Jun 2019 11:08:21 -0400
Message-ID: <20190615150821.GK6142@mit.edu>
References: <20190606155205.2872-1-ebiggers@kernel.org>
 <20190606155205.2872-11-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190606155205.2872-11-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-integrity@vger.kernel.org, linux-ext4@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Victor Hsieh <victorhsieh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 06, 2019 at 08:51:59AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a function for filesystems to call to implement the
> FS_IOC_ENABLE_VERITY ioctl.  This ioctl enables fs-verity on a file.
> 
> See the "FS_IOC_ENABLE_VERITY" section of
> Documentation/filesystems/fsverity.rst for the documentation.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

> diff --git a/fs/verity/enable.c b/fs/verity/enable.c
> new file mode 100644
> index 000000000000..7e7ef9d3c376
> --- /dev/null
> +++ b/fs/verity/enable.c
> +	/* Tell the filesystem to finish enabling verity on the file */
> +	err = vops->end_enable_verity(filp, desc, desc_size, params.tree_size);
> +	if (err) {
> +		fsverity_err(inode, "%ps() failed with err %d",
> +			     vops->end_enable_verity, err);
> +		fsverity_free_info(vi);
> +	} else {
> +		/* Successfully enabled verity */
> +
> +		WARN_ON(!IS_VERITY(inode));
> +
> +		/*
> +		 * Readers can start using ->i_verity_info immediately, so it
> +		 * can't be rolled back once set.  So don't set it until just
> +		 * after the filesystem has successfully enabled verity.
> +		 */
> +		fsverity_set_info(inode, vi);
> +	}

If end_enable_Verity() retuns success, and IS_VERITY is not set, I
would think that we should report the error via fsverity_err() and
return an error to userspace, and *not* call fsverity_set_info().  I
don't think the stack trace printed by WARN_ON is going to very
interesting, since the call path which gets us to enable_verity() is
not going to be surprising.

> +
> +	if (inode->i_size <= 0) {
> +		err = -EINVAL;
> +		goto out_unlock;
> +	}

How hard would it be to support fsverity for zero-length files?  There
would be no Merkle tree, but there still would be an fsverity header
file on which we can calculate a checksum for the digital signature.

     	      	     	       	 - Ted
