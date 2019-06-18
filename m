From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v4 13/16] fs-verity: support builtin file
 signatures
Date: Tue, 18 Jun 2019 09:58:49 -0700
Message-ID: <20190618165849.GE184520@gmail.com>
References: <20190606155205.2872-1-ebiggers@kernel.org>
 <20190606155205.2872-14-ebiggers@kernel.org>
 <20190615152143.GN6142@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190615152143.GN6142@mit.edu>
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

On Sat, Jun 15, 2019 at 11:21:43AM -0400, Theodore Ts'o wrote:
> On Thu, Jun 06, 2019 at 08:52:02AM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > To meet some users' needs, add optional support for having fs-verity
> > handle a portion of the authentication policy in the kernel.  An
> > ".fs-verity" keyring is created to which X.509 certificates can be
> > added; then a sysctl 'fs.verity.require_signatures' can be set to cause
> > the kernel to enforce that all fs-verity files contain a signature of
> > their file measurement by a key in this keyring.
> 
> I think it might be a good idea to allow the require_signatures
> setting to be set on a per-file system basis, via a mount option?  We
> could plumb it in via a flag in fsverity_info, set by the file system.

Perhaps, but this is something that can be added later, so I think we should
hold off on it until someone needs it.

> 
> Other than this feature request, looks good; you can add:
> 
> Reviewed-off-by: Theodore Ts'o <tytso@mit.edu>
> 

I assume you mean "Reviewed-by" :-)

- Eric
