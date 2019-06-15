From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v4 11/16] fs-verity: implement
 FS_IOC_MEASURE_VERITY ioctl
Date: Sat, 15 Jun 2019 11:10:05 -0400
Message-ID: <20190615151005.GL6142@mit.edu>
References: <20190606155205.2872-1-ebiggers@kernel.org>
 <20190606155205.2872-12-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190606155205.2872-12-ebiggers@kernel.org>
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

On Thu, Jun 06, 2019 at 08:52:00AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a function for filesystems to call to implement the
> FS_IOC_MEASURE_VERITY ioctl.  This ioctl retrieves the file measurement
> that fs-verity calculated for the given file and is enforcing for reads;
> i.e., reads that don't match this hash will fail.  This ioctl can be
> used for authentication or logging of file measurements in userspace.
> 
> See the "FS_IOC_MEASURE_VERITY" section of
> Documentation/filesystems/fsverity.rst for the documentation.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good; you can add:

Reviewed-off-by: Theodore Ts'o <tytso@mit.edu>

						- Ted
