From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v6 15/17] ext4: add fs-verity read support
Date: Sun, 7 Jul 2019 14:54:18 -0400
Message-ID: <20190707185418.GD19775@mit.edu>
References: <20190701153237.1777-1-ebiggers@kernel.org>
 <20190701153237.1777-16-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190701153237.1777-16-ebiggers@kernel.org>
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

On Mon, Jul 01, 2019 at 08:32:35AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Make ext4_mpage_readpages() verify data as it is read from fs-verity
> files, using the helper functions from fs/verity/.
> 
> To support both encryption and verity simultaneously, this required
> refactoring the decryption workflow into a generic "post-read
> processing" workflow which can do decryption, verification, or both.
> 
> The case where the ext4 block size is not equal to the PAGE_SIZE is not
> supported yet, since in that case ext4_mpage_readpages() sometimes falls
> back to block_read_full_page(), which does not support fs-verity yet.
> 
> Co-developed-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good.  Since there's a S-o-B, some might claim that a
Reviewed-by: is not necessary, but to the extent that you modified
this code as well:

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

							- Ted
