From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v5 14/16] ext4: add basic fs-verity support
Date: Thu, 20 Jun 2019 20:17:36 -0700
Message-ID: <20190621031736.GA742@sol.localdomain>
References: <20190620205043.64350-1-ebiggers@kernel.org>
 <20190620205043.64350-15-ebiggers@kernel.org>
 <20190620235938.GE5375@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190620235938.GE5375@magnolia>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-integrity@vger.kernel.org, linux-ext4@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Victor Hsieh <victorhsieh@google.com>
List-Id: linux-api@vger.kernel.org

Hi Darrick,

On Thu, Jun 20, 2019 at 04:59:38PM -0700, Darrick J. Wong wrote:
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 1cb67859e0518b..5a1deea3fb3e37 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -41,6 +41,7 @@
> >  #endif
> >  
> >  #include <linux/fscrypt.h>
> > +#include <linux/fsverity.h>
> >  
> >  #include <linux/compiler.h>
> >  
> > @@ -395,6 +396,7 @@ struct flex_groups {
> >  #define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
> >  #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
> >  #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
> > +#define EXT4_VERITY_FL			0x00100000 /* Verity protected inode */
> 
> Hmm, a new inode flag, superblock rocompat feature flag, and
> (presumably) the Merkle tree has some sort of well defined format which
> starts at the next 64k boundary past EOF.
> 
> Would you mind updating the relevant parts of the ondisk format
> documentation in Documentation/filesystems/ext4/, please?
> 
> I saw that the Merkle tree and verity descriptor formats themselves are
> documented in the first patch, so you could simply link the ext4
> documentation to it.
> 

Sure, I'll update the ext4 documentation.

> > +/*
> > + * Read some verity metadata from the inode.  __vfs_read() can't be used because
> > + * we need to read beyond i_size.
> > + */
> > +static int pagecache_read(struct inode *inode, void *buf, size_t count,
> > +			  loff_t pos)
> > +{
> > +	while (count) {
> > +		size_t n = min_t(size_t, count,
> > +				 PAGE_SIZE - offset_in_page(pos));
> > +		struct page *page;
> > +		void *addr;
> > +
> > +		page = read_mapping_page(inode->i_mapping, pos >> PAGE_SHIFT,
> > +					 NULL);
> > +		if (IS_ERR(page))
> > +			return PTR_ERR(page);
> > +
> > +		addr = kmap_atomic(page);
> > +		memcpy(buf, addr + offset_in_page(pos), n);
> > +		kunmap_atomic(addr);
> > +
> > +		put_page(page);
> > +
> > +		buf += n;
> > +		pos += n;
> > +		count -= n;
> > +	}
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Write some verity metadata to the inode for FS_IOC_ENABLE_VERITY.
> > + * kernel_write() can't be used because the file descriptor is readonly.
> > + */
> > +static int pagecache_write(struct inode *inode, const void *buf, size_t count,
> > +			   loff_t pos)
> > +{
> > +	while (count) {
> > +		size_t n = min_t(size_t, count,
> > +				 PAGE_SIZE - offset_in_page(pos));
> > +		struct page *page;
> > +		void *fsdata;
> > +		void *addr;
> > +		int res;
> > +
> > +		res = pagecache_write_begin(NULL, inode->i_mapping, pos, n, 0,
> > +					    &page, &fsdata);
> > +		if (res)
> > +			return res;
> > +
> > +		addr = kmap_atomic(page);
> > +		memcpy(addr + offset_in_page(pos), buf, n);
> > +		kunmap_atomic(addr);
> > +
> > +		res = pagecache_write_end(NULL, inode->i_mapping, pos, n, n,
> > +					  page, fsdata);
> > +		if (res < 0)
> > +			return res;
> > +		if (res != n)
> > +			return -EIO;
> > +
> > +		buf += n;
> > +		pos += n;
> > +		count -= n;
> > +	}
> > +	return 0;
> > +}
> 
> This same code is duplicated in the f2fs patch.  Is there a reason why
> they don't share this common code?  Even if you have to hide it under
> fs/verity/ ?
> 

Yes, pagecache_read() and pagecache_write() are identical between ext4 and f2fs.
I didn't put them in fs/verity/ because the "metadata past EOF" approach is a
choice of ext4 and f2fs and not intrinsic to the fs-verity feature itself, so to
avoid confusion I made the fs/verity/ support layer be completely clean of any
assumption that that's the way filesystems implement fs-verity.

Also, making the fsverity_operations call back into fs/verity/ adds a little
extra conceptual complexity about what belongs where, since then we'd have a
call stack of filesystem => fs/verity/ => filesystem => fs/verity/.

But if people would rather that ext4 and f2fs share these two functions anyway,
then sure, we could move them into fs/verity/, and other filesystems (if they
take a different approach to fs-verity) simply won't use them.

- Eric
