From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/10] xfs: nowait aio support
Date: Mon, 29 May 2017 01:33:38 -0700
Message-ID: <20170529083338.GC1899@infradead.org>
References: <20170524164150.9492-1-rgoldwyn@suse.de>
 <20170524164150.9492-10-rgoldwyn@suse.de>
 <20170528093113.GB14519@infradead.org>
 <cfc1e7ad-f74b-a14a-ac30-8472f7f684af@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cfc1e7ad-f74b-a14a-ac30-8472f7f684af@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

On Sun, May 28, 2017 at 09:38:26PM -0500, Goldwyn Rodrigues wrote:
> 
> 
> On 05/28/2017 04:31 AM, Christoph Hellwig wrote:
> > Despite my previous reviewed-by tag this will need another fix:
> > 
> > xfs_file_iomap_begin needs to return EAGAIN if we don't have the extent
> > list in memoery already.  E.g. something like this:
> > 
> > 	if ((flags & IOMAP_NOWAIT) && !(ip->i_d.if_flags & XFS_IFEXTENTS)) {
> > 		error = -EAGAIN;
> > 		goto out_unlock;
> > 	}
> > 
> > right after locking the ilock.
> > 
> 
> I am not sure if it is right to penalize the application to write to
> file which has been freshly opened (and is the first one to open). It
> basically means extent maps needs to be read from disk. Do you see a
> reason it would have a non-deterministic wait if it is the only user? I
> understand the block layer can block if it has too many requests though.

For either a read or a write we might have to read in the extent list
(note that for few enough extents they are stored in the inode and
we won't have to), in which case the call will block and by the
semantics you define we'll need to return -EAGAIN.

Btw, can you write a small blurb up for the man page to document these
ѕemantics in man-page like language?
