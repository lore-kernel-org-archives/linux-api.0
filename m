From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 3/8] nowait aio: return if direct write will trigger
 writeback
Date: Thu, 16 Mar 2017 06:20:52 -0700
Message-ID: <20170316132052.GG4033@bombadil.infradead.org>
References: <20170315215107.5628-1-rgoldwyn@suse.de>
 <20170315215107.5628-4-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170315215107.5628-4-rgoldwyn@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 15, 2017 at 04:51:02PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Find out if the write will trigger a wait due to writeback. If yes,
> return -EAGAIN.
> 
> This introduces a new function filemap_range_has_page() which
> returns true if the file's mapping has a page within the range
> mentioned.
> 
> Return -EINVAL for buffered AIO: there are multiple causes of
> delay such as page locks, dirty throttling logic, page loading
> from disk etc. which cannot be taken care of.

Also, this patch only touches the write path; we have a similar call to
write_and_wait_range() in generic_file_read_iter().

Actually, why do we even have that?  Why can't we satisfy an O_DIRECT
read from the cache?
