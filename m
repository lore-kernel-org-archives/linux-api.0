From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v4 14/16] ext4: add basic fs-verity support
Date: Tue, 18 Jun 2019 10:51:18 -0700
Message-ID: <20190618175117.GF184520@gmail.com>
References: <20190606155205.2872-1-ebiggers@kernel.org>
 <20190606155205.2872-15-ebiggers@kernel.org>
 <20190615153112.GO6142@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190615153112.GO6142@mit.edu>
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

On Sat, Jun 15, 2019 at 11:31:12AM -0400, Theodore Ts'o wrote:
> On Thu, Jun 06, 2019 at 08:52:03AM -0700, Eric Biggers wrote:
> > +/*
> > + * Format of ext4 verity xattr.  This points to the location of the verity
> > + * descriptor within the file data rather than containing it directly because
> > + * the verity descriptor *must* be encrypted when ext4 encryption is used.  But,
> > + * ext4 encryption does not encrypt xattrs.
> > + */
> > +struct fsverity_descriptor_location {
> > +	__le32 version;
> > +	__le32 size;
> > +	__le64 pos;
> > +};
> 
> What's the benefit of storing the location in an xattr as opposed to
> just keying it off the end of i_size, rounded up to next page size (or
> 64k) as I had suggested earlier?
> 
> Using an xattr burns xattr space, which is a limited resource, and it
> adds some additional code complexity.  Does the benefits outweigh the
> added complexity?
> 
> 						- Ted

It means that only the fs/verity/ support layer has to be aware of the format of
the fsverity_descriptor, and the filesystem can just treat it an as opaque blob.

Otherwise the filesystem would need to read the first 'sizeof(struct
fsverity_descriptor)' bytes and use those to calculate the size as
'sizeof(struct fsverity_descriptor) + le32_to_cpu(desc.sig_size)', then read the
rest.  Is this what you have in mind?

Alternatively the filesystem could prepend the fsverity_descriptor with its
size, similar to how in the v1 and v2 patchsets there was an fsverity_footer
appended to the fsverity_descriptor.  But an xattr seems a cleaner approach to
store a few bytes that don't need to be encrypted.

Putting the verity descriptor before the Merkle tree also means that we'd have
to pass the desc_size to ->begin_enable_verity(), ->read_merkle_tree_page(), and
->write_merkle_tree_block(), versus just passing the merkle_tree_size to
->end_enable_verity().  This would be easy, but it would still add a bit of
complexity in the fsverity_operations rather than reduce it.

It's also somewhat nice to have the version number in the xattr, in case we ever
introduce a new fs-verity format for ext4 or f2fs.

So to me, it doesn't seem like the other possible solutions are better.

- Eric
