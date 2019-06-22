From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v5 02/16] fs-verity: add MAINTAINERS file
 entry
Date: Sat, 22 Jun 2019 15:11:19 -0700
Message-ID: <20190622221119.GB19686@jaegeuk-macbookpro.roam.corp.google.com>
References: <20190620205043.64350-1-ebiggers@kernel.org>
 <20190620205043.64350-3-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190620205043.64350-3-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-ext4@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Victor Hsieh <victorhsieh@google.com>
List-Id: linux-api@vger.kernel.org

On 06/20, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> fs-verity will be jointly maintained by Eric Biggers and Theodore Ts'o.
> 
> Reviewed-by: Theodore Ts'o <tytso@mit.edu>

Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>

> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  MAINTAINERS | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a6954776a37e70..655065116f9228 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6505,6 +6505,18 @@ S:	Maintained
>  F:	fs/notify/
>  F:	include/linux/fsnotify*.h
>  
> +FSVERITY: READ-ONLY FILE-BASED AUTHENTICITY PROTECTION
> +M:	Eric Biggers <ebiggers@kernel.org>
> +M:	Theodore Y. Ts'o <tytso@mit.edu>
> +L:	linux-fscrypt@vger.kernel.org
> +Q:	https://patchwork.kernel.org/project/linux-fscrypt/list/
> +T:	git git://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git fsverity
> +S:	Supported
> +F:	fs/verity/
> +F:	include/linux/fsverity.h
> +F:	include/uapi/linux/fsverity.h
> +F:	Documentation/filesystems/fsverity.rst
> +
>  FUJITSU LAPTOP EXTRAS
>  M:	Jonathan Woithe <jwoithe@just42.net>
>  L:	platform-driver-x86@vger.kernel.org
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
