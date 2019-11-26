From: Nikolay Borisov <nborisov@suse.com>
Subject: Re: [RFC PATCH v3 04/12] btrfs: get rid of trivial
 __btrfs_lookup_bio_sums() wrappers
Date: Tue, 26 Nov 2019 15:56:31 +0200
Message-ID: <dc600214-0f19-b321-8573-6193b5f47e16@suse.com>
References: <cover.1574273658.git.osandov@fb.com>
 <bca47beb2f4eef766accebef683137e94313f7d3.1574273658.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <bca47beb2f4eef766accebef683137e94313f7d3.1574273658.git.osandov@fb.com>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Amir Goldstein <amir73il@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org



On 20.11.19 г. 20:24 ч., Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Currently, we have two wrappers for __btrfs_lookup_bio_sums():
> btrfs_lookup_bio_sums_dio(), which is used for direct I/O, and
> btrfs_lookup_bio_sums(), which is used everywhere else. The only
> difference is that the _dio variant looks up csums starting at the given
> offset instead of using the page index, which isn't actually direct
> I/O-specific. Let's clean up the signature and return value of
> __btrfs_lookup_bio_sums(), rename it to btrfs_lookup_bio_sums(), and get
> rid of the trivial helpers.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Overall looks good but 2 nits, see below.

In any case:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/compression.c |  4 ++--
>  fs/btrfs/ctree.h       |  4 +---
>  fs/btrfs/file-item.c   | 35 +++++++++++++++++------------------
>  fs/btrfs/inode.c       |  6 +++---
>  4 files changed, 23 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index b05b361e2062..4df6f0c58dc9 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -660,7 +660,7 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
>  
>  			if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
>  				ret = btrfs_lookup_bio_sums(inode, comp_bio,
> -							    sums);
> +							    false, 0, sums);
>  				BUG_ON(ret); /* -ENOMEM */
>  			}
>  
> @@ -689,7 +689,7 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
>  	BUG_ON(ret); /* -ENOMEM */
>  
>  	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
> -		ret = btrfs_lookup_bio_sums(inode, comp_bio, sums);
> +		ret = btrfs_lookup_bio_sums(inode, comp_bio, false, 0, sums);
>  		BUG_ON(ret); /* -ENOMEM */
>  	}
>  
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index fe2b8765d9e6..4bc40bf49b0e 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2787,9 +2787,7 @@ struct btrfs_dio_private;
>  int btrfs_del_csums(struct btrfs_trans_handle *trans,
>  		    struct btrfs_fs_info *fs_info, u64 bytenr, u64 len);
>  blk_status_t btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
> -				   u8 *dst);
> -blk_status_t btrfs_lookup_bio_sums_dio(struct inode *inode, struct bio *bio,
> -			      u64 logical_offset);
> +				   bool at_offset, u64 offset, u8 *dst);
>  int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
>  			     struct btrfs_root *root,
>  			     u64 objectid, u64 pos,
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 1a599f50837b..a87c40502267 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -148,8 +148,21 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> -static blk_status_t __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
> -				   u64 logical_offset, u8 *dst, int dio)
> +/**
> + * btrfs_lookup_bio_sums - Look up checksums for a bio.
> + * @inode: inode that the bio is for.
> + * @bio: bio embedded in btrfs_io_bio.
> + * @at_offset: If true, look up checksums for the extent at @c offset.

nit: that @c is an editing artifact? On the other hand rather than
having an explicit bool signifying whether we want a specific offset
can't we simply check if offset is != 0 ?

<snip>
