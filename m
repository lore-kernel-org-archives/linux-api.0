From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 17/17] xfs: support for synchronous DAX faults
Date: Tue, 24 Oct 2017 15:29:08 -0600
Message-ID: <20171024212908.GC1611@linux.intel.com>
References: <20171024152415.22864-1-jack@suse.cz>
 <20171024152415.22864-18-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171024152415.22864-18-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 24, 2017 at 05:24:14PM +0200, Jan Kara wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Return IOMAP_F_DIRTY from xfs_file_iomap_begin() when asked to prepare
> blocks for writing and the inode is pinned, and has dirty fields other
> than the timestamps.  In __xfs_filemap_fault() we then detect this case
> and call dax_finish_sync_fault() to make sure all metadata is committed,
> and to insert the page table entry.
> 
> Note that this will also dirty corresponding radix tree entry which is
> what we want - fsync(2) will still provide data integrity guarantees for
> applications not using userspace flushing. And applications using
> userspace flushing can avoid calling fsync(2) and thus avoid the
> performance overhead.
> 
> [JK: Added VM_SYNC flag handling]
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jan Kara <jack@suse.cz>

I don't know enough about XFS dirty inode handling to be able to comment on
the changes in xfs_file_iomap_begin(), but the rest looks good.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
