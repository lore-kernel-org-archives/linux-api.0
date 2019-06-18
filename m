From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v4 10/16] fs-verity: implement
 FS_IOC_ENABLE_VERITY ioctl
Date: Tue, 18 Jun 2019 09:50:18 -0700
Message-ID: <20190618165017.GD184520@gmail.com>
References: <20190606155205.2872-1-ebiggers@kernel.org>
 <20190606155205.2872-11-ebiggers@kernel.org>
 <20190615150821.GK6142@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190615150821.GK6142@mit.edu>
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

On Sat, Jun 15, 2019 at 11:08:21AM -0400, Theodore Ts'o wrote:
> On Thu, Jun 06, 2019 at 08:51:59AM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add a function for filesystems to call to implement the
> > FS_IOC_ENABLE_VERITY ioctl.  This ioctl enables fs-verity on a file.
> > 
> > See the "FS_IOC_ENABLE_VERITY" section of
> > Documentation/filesystems/fsverity.rst for the documentation.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> > diff --git a/fs/verity/enable.c b/fs/verity/enable.c
> > new file mode 100644
> > index 000000000000..7e7ef9d3c376
> > --- /dev/null
> > +++ b/fs/verity/enable.c
> > +	/* Tell the filesystem to finish enabling verity on the file */
> > +	err = vops->end_enable_verity(filp, desc, desc_size, params.tree_size);
> > +	if (err) {
> > +		fsverity_err(inode, "%ps() failed with err %d",
> > +			     vops->end_enable_verity, err);
> > +		fsverity_free_info(vi);
> > +	} else {
> > +		/* Successfully enabled verity */
> > +
> > +		WARN_ON(!IS_VERITY(inode));
> > +
> > +		/*
> > +		 * Readers can start using ->i_verity_info immediately, so it
> > +		 * can't be rolled back once set.  So don't set it until just
> > +		 * after the filesystem has successfully enabled verity.
> > +		 */
> > +		fsverity_set_info(inode, vi);
> > +	}
> 
> If end_enable_Verity() retuns success, and IS_VERITY is not set, I
> would think that we should report the error via fsverity_err() and
> return an error to userspace, and *not* call fsverity_set_info().  I
> don't think the stack trace printed by WARN_ON is going to very
> interesting, since the call path which gets us to enable_verity() is
> not going to be surprising.
> 

I want to keep it as WARN_ON() because if it happens it's a kernel bug, and
WARNs are reported as bugs by automated tools.  But I can do the following so it
returns an error code too:

@@ -229,11 +235,12 @@ static int enable_verity(struct file *filp,
 		fsverity_err(inode, "%ps() failed with err %d",
 			     vops->end_enable_verity, err);
 		fsverity_free_info(vi);
+	} else if (WARN_ON(!IS_VERITY(inode))) {
+		err = -EINVAL;
+		fsverity_free_info(vi);
 	} else {
 		/* Successfully enabled verity */
 
-		WARN_ON(!IS_VERITY(inode));
-
 		/*
 		 * Readers can start using ->i_verity_info immediately, so it
 		 * can't be rolled back once set.  So don't set it until just

> > +
> > +	if (inode->i_size <= 0) {
> > +		err = -EINVAL;
> > +		goto out_unlock;
> > +	}
> 
> How hard would it be to support fsverity for zero-length files?  There
> would be no Merkle tree, but there still would be an fsverity header
> file on which we can calculate a checksum for the digital signature.
> 
>      	      	     	       	 - Ted
> 

Empty files would have to be special-cased, e.g. defining the root hash to be
all 0's, since there are no blocks to checksum.  It would be straightforward,
but it would still be a special case, e.g.:

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index ee9dd578e59fb..e859a2b6a4310 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -112,6 +112,12 @@ static int build_merkle_tree(struct inode *inode,
 	unsigned int level;
 	int err = -ENOMEM;
 
+	if (inode->i_size == 0) {
+		/* Empty file is a special case; root hash is all 0's */
+		memset(root_hash, 0, params->digest_size);
+		return 0;
+	}
+

On the other hand, *not* supporting empty files is a special case from the
user's point of view.  It means that fs-verity isn't supported on every possible
file.  Thinking about it, that's probably worse than having a special case in
the *implementation*.

So now I'm leaning towards changing it to support empty files.

- Eric
