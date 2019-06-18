From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v4 07/16] fs-verity: add the hook for file
 ->open()
Date: Tue, 18 Jun 2019 09:35:04 -0700
Message-ID: <20190618163503.GC184520@gmail.com>
References: <20190606155205.2872-1-ebiggers@kernel.org>
 <20190606155205.2872-8-ebiggers@kernel.org>
 <20190615144207.GH6142@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190615144207.GH6142@mit.edu>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-integrity@vger.kernel.org, linux-ext4@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Victor Hsieh <victorhsieh@google.com>
List-Id: linux-api@vger.kernel.org

On Sat, Jun 15, 2019 at 10:42:07AM -0400, Theodore Ts'o wrote:
> On Thu, Jun 06, 2019 at 08:51:56AM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add the fsverity_file_open() function, which prepares an fs-verity file
> > to be read from.  If not already done, it loads the fs-verity descriptor
> > from the filesystem and sets up an fsverity_info structure for the inode
> > which describes the Merkle tree and contains the file measurement.  It
> > also denies all attempts to open verity files for writing.
> > 
> > This commit also begins the include/linux/fsverity.h header, which
> > declares the interface between fs/verity/ and filesystems.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Looks good; you can add:
> 
> Reviewed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> 						- Ted
> 
> > +/*
> > + * Validate the given fsverity_descriptor and create a new fsverity_info from
> > + * it.  The signature (if present) is also checked.
> > + */
> > +struct fsverity_info *fsverity_create_info(const struct inode *inode,
> > +					   const void *_desc, size_t desc_size)
> 
> Well, technically it's not checked (yet).  It doesn't get checked
> until [PATCH 13/16]: support builtin file signatures.  If we want to
> be really nit-picky, that portion of the comment could be moved to
> later in the series.
> 

Yes, I missed this when splitting out the patches.  I'll move it to patch 13.

- Eric
