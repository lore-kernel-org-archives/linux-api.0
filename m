From: Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH v6 17/17] f2fs: add fs-verity support
Date: Wed, 3 Jul 2019 09:25:44 +0800
Message-ID: <b9b6d387-b893-18cc-b574-7775607ec5b3@huawei.com>
References: <20190701153237.1777-1-ebiggers@kernel.org>
 <20190701153237.1777-18-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190701153237.1777-18-ebiggers@kernel.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-integrity@vger.kernel.org, linux-ext4@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Victor Hsieh <victorhsieh@google.com>
List-Id: linux-api@vger.kernel.org

On 2019/7/1 23:32, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add fs-verity support to f2fs.  fs-verity is a filesystem feature that
> enables transparent integrity protection and authentication of read-only
> files.  It uses a dm-verity like mechanism at the file level: a Merkle
> tree is used to verify any block in the file in log(filesize) time.  It
> is implemented mainly by helper functions in fs/verity/.  See
> Documentation/filesystems/fsverity.rst for the full documentation.
> 
> The f2fs support for fs-verity consists of:
> 
> - Adding a filesystem feature flag and an inode flag for fs-verity.
> 
> - Implementing the fsverity_operations to support enabling verity on an
>   inode and reading/writing the verity metadata.
> 
> - Updating ->readpages() to verify data as it's read from verity files
>   and to support reading verity metadata pages.
> 
> - Updating ->write_begin(), ->write_end(), and ->writepages() to support
>   writing verity metadata pages.
> 
> - Calling the fs-verity hooks for ->open(), ->setattr(), and ->ioctl().
> 
> Like ext4, f2fs stores the verity metadata (Merkle tree and
> fsverity_descriptor) past the end of the file, starting at the first 64K
> boundary beyond i_size.  This approach works because (a) verity files
> are readonly, and (b) pages fully beyond i_size aren't visible to
> userspace but can be read/written internally by f2fs with only some
> relatively small changes to f2fs.  Extended attributes cannot be used
> because (a) f2fs limits the total size of an inode's xattr entries to
> 4096 bytes, which wouldn't be enough for even a single Merkle tree
> block, and (b) f2fs encryption doesn't encrypt xattrs, yet the verity
> metadata *must* be encrypted when the file is because it contains hashes
> of the plaintext data.
> 
> Acked-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Chao Yu <yuchao0@huawei.com>

Thanks,
