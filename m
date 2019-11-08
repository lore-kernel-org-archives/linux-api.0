From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [man-pages RFC PATCH] statx.2: document
 STATX_ATTR_VERITY
Date: Fri, 8 Nov 2019 11:35:58 -0800
Message-ID: <20191108193557.GA12997@gmail.com>
References: <20191107014420.GD15212@magnolia>
 <20191107220248.32025-1-ebiggers@kernel.org>
 <5DC525E8.4060705@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <5DC525E8.4060705@bfs.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: walter harms <wharms@bfs.de>
Cc: linux-man@vger.kernel.org, tytso@mit.edu, darrick.wong@oracle.com, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, dhowells@redhat.com, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, jaegeuk@kernel.org, linux-ext4@vger.kernel.org, victorhsieh@google.com
List-Id: linux-api@vger.kernel.org

On Fri, Nov 08, 2019 at 09:23:04AM +0100, walter harms wrote:
> 
> 
> Am 07.11.2019 23:02, schrieb Eric Biggers:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Document the verity attribute for statx().
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  man2/statx.2 | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > RFC since the kernel patches are currently under review.
> > The kernel patches can be found here:
> > https://lkml.kernel.org/linux-fscrypt/20191029204141.145309-1-ebiggers@kernel.org/T/#u
> > 
> > diff --git a/man2/statx.2 b/man2/statx.2
> > index d2f1b07b8..713bd1260 100644
> > --- a/man2/statx.2
> > +++ b/man2/statx.2
> > @@ -461,6 +461,10 @@ See
> >  .TP
> >  .B STATX_ATTR_ENCRYPTED
> >  A key is required for the file to be encrypted by the filesystem.
> > +.TP
> > +.B STATX_ATTR_VERITY
> > +The file has fs-verity enabled.  It cannot be written to, and all reads from it
> > +will be verified against a Merkle tree.
> 
> Using "Merkle tree" opens a can of worm and what will happen when the methode will change ?
> Does it matter at all ? i would suggest "filesystem" here.
> 

Fundamentally, fs-verity guarantees that all data read is verified against a
cryptographic hash that covers the entire file.  I think it will be helpful to
convey that here, e.g. to avoid confusion with non-cryptographic, individual
block checksums supported by filesystems like btrfs and zfs.

Now, the only sane way to implement this model is with a Merkle tree, and this
is part of the fs-verity UAPI (via the file hash), so that's where I'm coming
from here.  Perhaps the phrase "Merkle tree" could be interpreted too strictly,
though, so it would be better to emphasize the more abstract model.  How about
the following?:

	The file has fs-verity enabled.  It cannot be written to, and all reads
	from it will be verified against a cryptographic hash that covers the
	entire file, e.g. via a Merkle tree.

- Eric
