From: Nikolay Borisov <nborisov@suse.com>
Subject: Re: [RFC PATCH v3 05/12] btrfs: don't advance offset for compressed
 bios in btrfs_csum_one_bio()
Date: Tue, 26 Nov 2019 16:18:45 +0200
Message-ID: <9669273e-5a73-540f-2091-5ce64e093062@suse.com>
References: <cover.1574273658.git.osandov@fb.com>
 <a669365a9165b18814c635f61ed566fdcd47a96f.1574273658.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a669365a9165b18814c635f61ed566fdcd47a96f.1574273658.git.osandov@fb.com>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Amir Goldstein <amir73il@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org



On 20.11.19 г. 20:24 ч., Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> btrfs_csum_one_bio() loops over each sector in the bio while keeping a

'sector' here is ambiguous it really loops over every fs block (which in
btrfs is also known as sector). SO perhaps change the wording in the
changelog but also in the function instead of nr_sectors perhahps it
could be renamed to blockcount?

> cursor of its current logical position in the file in order to look up
> the ordered extent to add the checksums to. However, this doesn't make
> much sense for compressed extents, as a sector on disk does not
> correspond to a sector of decompressed file data. It happens to work
> because 1) the compressed bio always covers one ordered extent and 2)
> the size of the bio is always less than the size of the ordered extent.
> However, the second point will not always be true for encoded writes.
> 
> Let's add a boolean parameter to btrfs_csum_one_bio() to indicate that
> it can assume that the bio only covers one ordered extent. Since we're
> already changing the signature, let's make contig bool instead of int,
> too.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/compression.c |  5 +++--
>  fs/btrfs/ctree.h       |  2 +-
>  fs/btrfs/file-item.c   | 19 +++++++++++--------
>  fs/btrfs/inode.c       |  8 ++++----
>  4 files changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 4df6f0c58dc9..05b6e404a291 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -374,7 +374,8 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
>  			BUG_ON(ret); /* -ENOMEM */
>  
>  			if (!skip_sum) {
> -				ret = btrfs_csum_one_bio(inode, bio, start, 1);
> +				ret = btrfs_csum_one_bio(inode, bio, start,
> +							 true, true);
>  				BUG_ON(ret); /* -ENOMEM */
>  			}
>  
> @@ -405,7 +406,7 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
>  	BUG_ON(ret); /* -ENOMEM */
>  
>  	if (!skip_sum) {
> -		ret = btrfs_csum_one_bio(inode, bio, start, 1);
> +		ret = btrfs_csum_one_bio(inode, bio, start, true, true);
>  		BUG_ON(ret); /* -ENOMEM */
>  	}
>  
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 4bc40bf49b0e..c32741879088 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2802,7 +2802,7 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
>  			   struct btrfs_root *root,
>  			   struct btrfs_ordered_sum *sums);
>  blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
> -		       u64 file_start, int contig);
> +				u64 file_start, bool contig, bool one_ordered);
>  int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
>  			     struct list_head *list, int search_commit);
>  void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index a87c40502267..c95772949b00 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -423,13 +423,14 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
>   * @inode:	 Owner of the data inside the bio
>   * @bio:	 Contains the data to be checksummed
>   * @file_start:  offset in file this bio begins to describe
> - * @contig:	 Boolean. If true/1 means all bio vecs in this bio are
> - *		 contiguous and they begin at @file_start in the file. False/0
> - *		 means this bio can contains potentially discontigous bio vecs
> - *		 so the logical offset of each should be calculated separately.
> + * @contig:      If true, all bio vecs in @bio are contiguous and they begin at
> + *               @file_start in the file. If false, @bio may contain
> + *               discontigous bio vecs, so the logical offset of each should be
> + *               calculated separately (@file_start is ignored).
> + * @one_ordered: If true, @bio only refers to one ordered extent.
>   */
>  blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
> -		       u64 file_start, int contig)
> +				u64 file_start, bool contig, bool one_ordered)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  	SHASH_DESC_ON_STACK(shash, fs_info->csum_shash);
> @@ -482,8 +483,9 @@ blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
>  						 - 1);
>  
>  		for (i = 0; i < nr_sectors; i++) {
> -			if (offset >= ordered->file_offset + ordered->len ||
> -				offset < ordered->file_offset) {
> +			if (!one_ordered &&
> +			    (offset >= ordered->file_offset + ordered->len ||
> +			     offset < ordered->file_offset)) {
>  				unsigned long bytes_left;
>  
>  				sums->len = this_sum_bytes;
> @@ -515,7 +517,8 @@ blk_status_t btrfs_csum_one_bio(struct inode *inode, struct bio *bio,
>  			kunmap_atomic(data);
>  			crypto_shash_final(shash, (char *)(sums->sums + index));
>  			index += csum_size;
> -			offset += fs_info->sectorsize;
> +			if (!one_ordered)
> +				offset += fs_info->sectorsize;
>  			this_sum_bytes += fs_info->sectorsize;
>  			total_bytes += fs_info->sectorsize;
>  		}
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index ad5bffb24199..4c1ed6dddfd8 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2039,7 +2039,7 @@ static blk_status_t btrfs_submit_bio_start(void *private_data, struct bio *bio,
>  	struct inode *inode = private_data;
>  	blk_status_t ret = 0;
>  
> -	ret = btrfs_csum_one_bio(inode, bio, 0, 0);
> +	ret = btrfs_csum_one_bio(inode, bio, 0, false, false);
>  	BUG_ON(ret); /* -ENOMEM */
>  	return 0;
>  }
> @@ -2104,7 +2104,7 @@ static blk_status_t btrfs_submit_bio_hook(struct inode *inode, struct bio *bio,
>  					  0, inode, btrfs_submit_bio_start);
>  		goto out;
>  	} else if (!skip_sum) {
> -		ret = btrfs_csum_one_bio(inode, bio, 0, 0);
> +		ret = btrfs_csum_one_bio(inode, bio, 0, false, false);
>  		if (ret)
>  			goto out;
>  	}
> @@ -8272,7 +8272,7 @@ static blk_status_t btrfs_submit_bio_start_direct_io(void *private_data,
>  {
>  	struct inode *inode = private_data;
>  	blk_status_t ret;
> -	ret = btrfs_csum_one_bio(inode, bio, offset, 1);
> +	ret = btrfs_csum_one_bio(inode, bio, offset, true, false);
>  	BUG_ON(ret); /* -ENOMEM */
>  	return 0;
>  }
> @@ -8379,7 +8379,7 @@ static inline blk_status_t btrfs_submit_dio_bio(struct bio *bio,
>  		 * If we aren't doing async submit, calculate the csum of the
>  		 * bio now.
>  		 */
> -		ret = btrfs_csum_one_bio(inode, bio, file_offset, 1);
> +		ret = btrfs_csum_one_bio(inode, bio, file_offset, true, false);
>  		if (ret)
>  			goto err;
>  	} else {
> 
