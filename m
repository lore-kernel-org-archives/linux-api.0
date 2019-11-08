From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [man-pages RFC PATCH] statx.2: document
 STATX_ATTR_VERITY
Date: Thu, 7 Nov 2019 16:47:00 -0800
Message-ID: <20191108004700.GA6213@magnolia>
References: <20191107014420.GD15212@magnolia>
 <20191107220248.32025-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20191107220248.32025-1-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-man@vger.kernel.org, tytso@mit.edu, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, dhowells@redhat.com, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, jaegeuk@kernel.org, linux-ext4@vger.kernel.org, victorhsieh@google.com
List-Id: linux-api@vger.kernel.org

On Thu, Nov 07, 2019 at 02:02:48PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Document the verity attribute for statx().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  man2/statx.2 | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> RFC since the kernel patches are currently under review.
> The kernel patches can be found here:
> https://lkml.kernel.org/linux-fscrypt/20191029204141.145309-1-ebiggers@kernel.org/T/#u
> 
> diff --git a/man2/statx.2 b/man2/statx.2
> index d2f1b07b8..713bd1260 100644
> --- a/man2/statx.2
> +++ b/man2/statx.2
> @@ -461,6 +461,10 @@ See
>  .TP
>  .B STATX_ATTR_ENCRYPTED
>  A key is required for the file to be encrypted by the filesystem.
> +.TP
> +.B STATX_ATTR_VERITY
> +The file has fs-verity enabled.  It cannot be written to, and all reads from it
> +will be verified against a Merkle tree.

mkerrisk might ask you to start the new sentence on a separate line, but
otherwise looks good to me. :)

--D

>  .SH RETURN VALUE
>  On success, zero is returned.
>  On error, \-1 is returned, and
> -- 
> 2.24.0.rc1.363.gb1bccd3e3d-goog
> 
