From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v4 14/16] ext4: add basic fs-verity support
Date: Tue, 18 Jun 2019 18:46:15 -0400
Message-ID: <20190618224615.GB4576@mit.edu>
References: <20190606155205.2872-1-ebiggers@kernel.org>
 <20190606155205.2872-15-ebiggers@kernel.org>
 <20190615153112.GO6142@mit.edu> <20190618175117.GF184520@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190618175117.GF184520@gmail.com>
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

On Tue, Jun 18, 2019 at 10:51:18AM -0700, Eric Biggers wrote:
> On Sat, Jun 15, 2019 at 11:31:12AM -0400, Theodore Ts'o wrote:
> > On Thu, Jun 06, 2019 at 08:52:03AM -0700, Eric Biggers wrote:
> > > +/*
> > > + * Format of ext4 verity xattr.  This points to the location of the verity
> > > + * descriptor within the file data rather than containing it directly because
> > > + * the verity descriptor *must* be encrypted when ext4 encryption is used.  But,
> > > + * ext4 encryption does not encrypt xattrs.
> > > + */
> > > +struct fsverity_descriptor_location {
> > > +	__le32 version;
> > > +	__le32 size;
> > > +	__le64 pos;
> > > +};
> > 
> > What's the benefit of storing the location in an xattr as opposed to
> > just keying it off the end of i_size, rounded up to next page size (or
> > 64k) as I had suggested earlier?
> > 
> > Using an xattr burns xattr space, which is a limited resource, and it
> > adds some additional code complexity.  Does the benefits outweigh the
> > added complexity?
> > 
> > 						- Ted
> 
> It means that only the fs/verity/ support layer has to be aware of the format of
> the fsverity_descriptor, and the filesystem can just treat it an as opaque blob.
> 
> Otherwise the filesystem would need to read the first 'sizeof(struct
> fsverity_descriptor)' bytes and use those to calculate the size as
> 'sizeof(struct fsverity_descriptor) + le32_to_cpu(desc.sig_size)', then read the
> rest.  Is this what you have in mind?

So right now, the way enable_verity() works is that it appends the
Merkle tree to the data file, rounding up to the next page (but we
might change so we round up to the next 64k boundary).  Then it calls
end_enable_verity(), which is a file system specific function, passing
in the descriptor and the descriptor size.

Today ext4 and f2fs appends the descriptor after the Merkle, and then
sets the xattr containing the fsverity_descriptor_location.  Correct?

What I'm suggesting that ext4 do instead is that it appends the
descriptor to the Merkle tree, and then assuming that there is the
(descriptor size % block_size) is less than PAGE_SIZE-4, we can write
the descriptor size into the last 4 bytes of the last block in the
file.  If there is not enough space at the end of the descriptor, then
we append a block to the file, and then write the descriptor_size into
last 4 bytes of that block.

When ext4 needs to find the descriptor, it simply reads the last block
from the file, reads it into the page cache, reads the last 4 bytes
from that block to fetch the descriptor size, and it can use the
logical offset of the last block and the descriptor size to calculate
the beginning offset of the descriptor size.

We can then fake up the fsverity_descriptor_location structure, and
pass that into fsverity.

It does add a bit of extra complexity, but 99.9% of the time, it
requires no extra space.  The last 0.098% of the time, the file size
will grow by 4k, but if we can avoid spilling over to an external
xattr block, it will all be worth it.

And in the V1 version of the fsverity code, I had already written the
code to descend the extent tree to find the last logical block in the
extent tree.

> It's also somewhat nice to have the version number in the xattr, in case we ever
> introduce a new fs-verity format for ext4 or f2fs.

We already have a version number in the fsverity descriptor.  Surely
that is what we would bump if we need to itnroduce a new fs-verity
format?

						- Ted
