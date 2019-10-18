From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [RFC PATCH v2 5/5] btrfs: implement RWF_ENCODED writes
Date: Fri, 18 Oct 2019 16:33:00 -0700
Message-ID: <20191018233300.GE59713@vader>
References: <cover.1571164762.git.osandov@fb.com>
 <904de93d9bbe630aff7f725fd587810c6eb48344.1571164762.git.osandov@fb.com>
 <0da91628-7f54-7d24-bf58-6807eb9535a5@suse.com>
 <20191018225513.GD59713@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191018225513.GD59713@vader>
Sender: linux-btrfs-owner@vger.kernel.org
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 18, 2019 at 03:55:13PM -0700, Omar Sandoval wrote:
> On Wed, Oct 16, 2019 at 01:44:56PM +0300, Nikolay Borisov wrote:
> > 
> > 
> > On 15.10.19 г. 21:42 ч., Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > 
> > > The implementation resembles direct I/O: we have to flush any ordered
> > > extents, invalidate the page cache, and do the io tree/delalloc/extent
> > > map/ordered extent dance. From there, we can reuse the compression code
> > > with a minor modification to distinguish the write from writeback.
> > > 
> > > Now that read and write are implemented, this also sets the
> > > FMODE_ENCODED_IO flag in btrfs_file_open().
> > > 
> > > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > > ---
> > >  fs/btrfs/compression.c |   6 +-
> > >  fs/btrfs/compression.h |   5 +-
> > >  fs/btrfs/ctree.h       |   2 +
> > >  fs/btrfs/file.c        |  40 +++++++--
> > >  fs/btrfs/inode.c       | 197 ++++++++++++++++++++++++++++++++++++++++-
> > >  5 files changed, 237 insertions(+), 13 deletions(-)
> > > 

[snip]

> > > +	for (;;) {
> > > +		struct btrfs_ordered_extent *ordered;
> > > +
> > > +		ret = btrfs_wait_ordered_range(inode, start, end - start + 1);
> > > +		if (ret)
> > > +			goto out_pages;
> > > +		ret = invalidate_inode_pages2_range(inode->i_mapping,
> > > +						    start >> PAGE_SHIFT,
> > > +						    end >> PAGE_SHIFT);
> > > +		if (ret)
> > > +			goto out_pages;
> > > +		lock_extent_bits(io_tree, start, end, &cached_state);
> > > +		ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), start,
> > > +						     end - start + 1);
> > > +		if (!ordered &&
> > > +		    !filemap_range_has_page(inode->i_mapping, start, end))
> > > +			break;
> > > +		if (ordered)
> > > +			btrfs_put_ordered_extent(ordered);
> > > +		unlock_extent_cached(io_tree, start, end, &cached_state);
> > > +		cond_resched();
> > > +	}
> > > +
> > > +	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, start,
> > > +					   num_bytes);
> > > +	if (ret)
> > > +		goto out_unlock;
> > > +
> > > +	ret = btrfs_reserve_extent(root, num_bytes, disk_num_bytes,
> > > +				   disk_num_bytes, 0, 0, &ins, 1, 1);
> > > +	if (ret)
> > > +		goto out_delalloc_release;
> > > +
> > > +	em = create_io_em(inode, start, num_bytes, start, ins.objectid,
> > > +			  ins.offset, ins.offset, num_bytes, compression,
> > > +			  BTRFS_ORDERED_COMPRESSED);
> > > +	if (IS_ERR(em)) {
> > > +		ret = PTR_ERR(em);
> > > +		goto out_free_reserve;
> > > +	}
> > > +	free_extent_map(em);
> > > +
> > > +	ret = btrfs_add_ordered_extent_compress(inode, start, ins.objectid,
> > > +						num_bytes, ins.offset,
> > > +						BTRFS_ORDERED_COMPRESSED,
> > > +						compression);
> > > +	if (ret) {
> > > +		btrfs_drop_extent_cache(BTRFS_I(inode), start, end, 0);
> > > +		goto out_free_reserve;
> > > +	}
> > > +	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
> > > +
> > > +	if (start + encoded->len > inode->i_size)
> > > +		i_size_write(inode, start + encoded->len);
> > 
> > Don't we want the inode size to be updated once data hits disk and
> > btrfs_finish_ordered_io is called?
> 
> Yup, you're right, this is too early.

Actually, no, this part is fine. Compare to the call to i_size_write()
in btrfs_get_blocks_direct_write(): we lock the extent in the io_tree,
create the ordered extent, update i_size, then unlock the extent. Anyone
else who comes in is going to find the ordered extent and wait on that.

> > > +
> > > +	unlock_extent_cached(io_tree, start, end, &cached_state);
> > > +
> > > +	btrfs_delalloc_release_extents(BTRFS_I(inode), num_bytes, false);
> > > +
> > > +	if (btrfs_submit_compressed_write(inode, start, num_bytes, ins.objectid,
> > > +					  ins.offset, pages, nr_pages, 0,
> > > +					  false)) {
> > > +		struct page *page = pages[0];
> > > +
> > > +		page->mapping = inode->i_mapping;
> > > +		btrfs_writepage_endio_finish_ordered(page, start, end, 0);
> > > +		page->mapping = NULL;
> > > +		ret = -EIO;
> > > +		goto out_pages;
> > > +	}
> 
> I also need to wait for the I/O to finish here.
> 
> > > +	iocb->ki_pos += encoded->len;
> > > +	return orig_count;
> > > +
> > > +out_free_reserve:
> > > +	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
> > > +	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, 1);
> > > +out_delalloc_release:
> > > +	btrfs_delalloc_release_space(inode, data_reserved, start, num_bytes,
> > > +				     true);
> > > +out_unlock:
> > > +	unlock_extent_cached(io_tree, start, end, &cached_state);
> > > +out_pages:
> > > +	for (i = 0; i < nr_pages; i++) {
> > > +		if (pages[i])
> > > +			put_page(pages[i]);
> > > +	}
> > > +	kvfree(pages);
> > > +	return ret;
> > > +}
> > > +
> > >  #ifdef CONFIG_SWAP
> > >  /*
> > >   * Add an entry indicating a block group or device which is pinned by a
> > > 
