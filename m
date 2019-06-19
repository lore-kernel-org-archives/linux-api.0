From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v4 14/16] ext4: add basic fs-verity support
Date: Tue, 18 Jun 2019 23:05:22 -0400
Message-ID: <20190619030522.GA28351@mit.edu>
References: <20190606155205.2872-1-ebiggers@kernel.org>
 <20190606155205.2872-15-ebiggers@kernel.org>
 <20190615153112.GO6142@mit.edu> <20190618175117.GF184520@gmail.com>
 <20190618224615.GB4576@mit.edu> <20190618234133.GL184520@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190618234133.GL184520@gmail.com>
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

On Tue, Jun 18, 2019 at 04:41:34PM -0700, Eric Biggers wrote:
> 
> I don't think your proposed solution is so simple.  By definition the last
> extent ends on a filesystem block boundary, while the Merkle tree ends on a
> Merkle tree block boundary.  In the future we might support the case where these
> differ, so we don't want to preclude that in the on-disk format we choose now.
> Therefore, just storing the desc_size isn't enough; we'd actually have to store
> (desc_pos, desc_size), like I'm doing in the xattr.

I don't think any of this matters much, since what you're describing
above is all about the Merkle tree, and that doesn't affect how we
find the fsverity descriptor information.  We can just say that
fsverity descriptor block begins on the next file system block
boundary after the Merkle tree.  And in the case where say, the Merkle
tree is 4k and the file system block size is 64k, that's fine --- the
fs descriptor would just begin at the next 64k (fs blocksize)
boundary.

> Also, using ext4_find_extent() to find the last mapped block (as the v1 and v2
> patchsets did) assumes the file actually uses extents.  So we'd have to forbid
> non-extents based files as a special case, as the v2 patchset did.  We'd also
> have to find a way to implement the same functionality on f2fs (which should be
> possible, but it seems it would require some new code; there's nothing like
> f2fs_get_extent()) unless we did something different for f2fs.

So first, if f2fs wants to continue using the xattr, that's fine.  The
code to write and fetch the fsverity descriptor is in file system
specific code, and so this is something I'm happy to support just for
ext4, and it shouldn't require any special changes in the common
fsverity code at all.  Secondly, I suspect it's not *that* hard to
find the last logical block mapping in f2fs, but I'll let Jaeguk
comment on that.

Finally, it's not that hard to find the last mapped block for indirect
blocks, if we really care about supporting that combination.  (There
are enough other things --- like fallocate --- which don't work with
indirect mapped files, so I don't feel especially bad forbidding that
combination.  A quick check in enable_verity() to return EOPNOTSUPP if
the EXTENTS_FL flag is not present is not all that different from what
we do with fallocate today.)

But if we *did* want to support it, it's actually quite easy to find
the last mapped block for an indirect mapped inode.  I just didn't
bother to write the code, but it requires at most 3 block reads if
there is a triple indirection block.  Otherwise, if there is a double
indirection block in the inode, it requires at most 2 block reads, and
otherwise, at most a single block read.

> Note that on Android devices (the motivating use case for fs-verity), the xattrs
> of user data files on ext4 already spill into an external xattr block, due to
> the fscrypt and SELinux xattrs.  If/when people actually start caring about
> this, they'll need to increase the inode size to 512 bytes anyway, in which case
> there will be plenty of space for a few more in-line xattrs.  So I don't think
> we should jump through too many hoops to avoid using an xattr.

I'm thinking about other cases where we might not be using fscrypt,
but where we might still be using fsverity and SELinux --- or maybe
cases where the file systems are using 128 byte inodes, and where only
fsverity is required.  (There are a *vast* number of production file
systems using 128 byte inodes.)

Cheers,

						- Ted
