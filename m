From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v6 14/17] ext4: add basic fs-verity support
Date: Sun, 7 Jul 2019 14:51:17 -0400
Message-ID: <20190707185117.GC19775@mit.edu>
References: <20190701153237.1777-1-ebiggers@kernel.org>
 <20190701153237.1777-15-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190701153237.1777-15-ebiggers@kernel.org>
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

On Mon, Jul 01, 2019 at 08:32:34AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add most of fs-verity support to ext4.  fs-verity is a filesystem
> feature that enables transparent integrity protection and authentication
> of read-only files.  It uses a dm-verity like mechanism at the file
> level: a Merkle tree is used to verify any block in the file in
> log(filesize) time.  It is implemented mainly by helper functions in
> fs/verity/.  See Documentation/filesystems/fsverity.rst for the full
> documentation.
> 
> This commit adds all of ext4 fs-verity support except for the actual
> data verification, including:
> 
> - Adding a filesystem feature flag and an inode flag for fs-verity.
> 
> - Implementing the fsverity_operations to support enabling verity on an
>   inode and reading/writing the verity metadata.
> 
> - Updating ->write_begin(), ->write_end(), and ->writepages() to support
>   writing verity metadata pages.
> 
> - Calling the fs-verity hooks for ->open(), ->setattr(), and ->ioctl().
> 
> ext4 stores the verity metadata (Merkle tree and fsverity_descriptor)
> past the end of the file, starting at the first 64K boundary beyond
> i_size.  This approach works because (a) verity files are readonly, and
> (b) pages fully beyond i_size aren't visible to userspace but can be
> read/written internally by ext4 with only some relatively small changes
> to ext4.  This approach avoids having to depend on the EA_INODE feature
> and on rearchitecturing ext4's xattr support to support paging
> multi-gigabyte xattrs into memory, and to support encrypting xattrs.
> Note that the verity metadata *must* be encrypted when the file is,
> since it contains hashes of the plaintext data.
> 
> This patch incorporates work by Theodore Ts'o and Chandan Rajendra.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good.  You can add:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

Thanks,

					- Ted
