From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] ioctl_ficlonerange.2/ioctl_fideduperange.2: mention
 same-fs requirement
Date: Thu, 9 Jun 2016 10:11:42 +0200
Message-ID: <f1f16a4c-046c-ea32-4171-a68f1044f85a@gmail.com>
References: <20160608164040.GB5740@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160608164040.GB5740@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, hch@infradead.org, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 06/08/2016 06:40 PM, Darrick J. Wong wrote:
> Mention that FICLONE, FICLONERANGE, and FIDEDUPERANGE all require both
> files to reside on the same filesystem.

Thanks, Darrick. Applied.

I sees there's also some small problems with the page licenses in these
two new pages: the markup "VERBATIM" is wrong. And you don't mention 
the GPL version.

Can I suggest either changing the license to the real "verbatim" 
license (https://www.kernel.org/doc/man-pages/licenses.html#verbatim),
or to a GPL with version (see 
https://www.kernel.org/doc/man-pages/licenses.html#gpl

Cheers,

Michael


> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man2/ioctl_ficlonerange.2  |    1 +
>  man2/ioctl_fideduperange.2 |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/man2/ioctl_ficlonerange.2 b/man2/ioctl_ficlonerange.2
> index 0cb1567..c6e0762 100644
> --- a/man2/ioctl_ficlonerange.2
> +++ b/man2/ioctl_ficlonerange.2
> @@ -36,6 +36,7 @@ file appear in the
>  .I dest_fd
>  file by sharing the underlying storage, which is faster than making a separate
>  physical copy of the data.
> +Both files must reside within the same filesystem.
>  If a file write should occur to a shared region,
>  the filesystem must ensure that the changes remain private to the file being
>  written.
> diff --git a/man2/ioctl_fideduperange.2 b/man2/ioctl_fideduperange.2
> index c69f8c5..44a7765 100644
> --- a/man2/ioctl_fideduperange.2
> +++ b/man2/ioctl_fideduperange.2
> @@ -34,6 +34,7 @@ file appear in the
>  .B dest_fd
>  file by sharing the underlying storage if the file data is identical
>  ("deduplication").
> +Both files must reside within the same filesystem.
>  This reduces storage consumption by allowing the filesystem
>  to store one shared copy of the data.
>  If a file write should occur to a shared
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
