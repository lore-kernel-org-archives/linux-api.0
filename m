From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v4 05/16] fs-verity: add Kconfig and the
 helper functions for hashing
Date: Tue, 18 Jun 2019 09:32:56 -0700
Message-ID: <20190618163255.GB184520@gmail.com>
References: <20190606155205.2872-1-ebiggers@kernel.org>
 <20190606155205.2872-6-ebiggers@kernel.org>
 <20190615125731.GF6142@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190615125731.GF6142@mit.edu>
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

On Sat, Jun 15, 2019 at 08:57:31AM -0400, Theodore Ts'o wrote:
> On Thu, Jun 06, 2019 at 08:51:54AM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add the beginnings of the fs/verity/ support layer, including the
> > Kconfig option and various helper functions for hashing.  To start, only
> > SHA-256 is supported, but other hash algorithms can easily be added.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Looks good; you can add:
> 
> Reviewed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> One thought for consideration below...
> 
> 
> > +
> > +/*
> > + * Maximum depth of the Merkle tree.  Up to 64 levels are theoretically possible
> > + * with a very small block size, but we'd like to limit stack usage during
> > + * verification, and in practice this is plenty.  E.g., with SHA-256 and 4K
> > + * blocks, a file with size UINT64_MAX bytes needs just 8 levels.
> > + */
> > +#define FS_VERITY_MAX_LEVELS		16
> 
> Maybe we should make FS_VERITY_MAX_LEVELS 8 for now?  This is an
> implementation-level restriction, and currently we don't support any
> architectures that have a page size < 4k.  We can always bump this
> number up in the future if it ever becomes necessary, and limiting max
> levels to 8 saves almost 100 bytes of stack space in verify_page().
> 
> 						- Ted

Yes, I agree.  I'll reduce MAX_LEVELS to 8 for now and tweak the comment.

- Eric
