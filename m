From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ioctl_ficlonerange.2: mention a subtlety with length == 0
Date: Sat, 16 Jul 2016 12:26:01 +0200
Message-ID: <9c68078c-0723-7a8a-bee9-484bfd1ebdc7@gmail.com>
References: <20160714181111.GC5215@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160714181111.GC5215-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 07/14/2016 08:11 PM, Darrick J. Wong wrote:
> I forgot to document that passing length == 0 to clonerange actually
> makes it clone all the way to EOF, so do that now.

Thanks, Darrick. Applied.

Cheers,

Michael

> Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  man2/ioctl_ficlonerange.2 |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/man2/ioctl_ficlonerange.2 b/man2/ioctl_ficlonerange.2
> index d1da3e6..c4715d0 100644
> --- a/man2/ioctl_ficlonerange.2
> +++ b/man2/ioctl_ficlonerange.2
> @@ -59,6 +59,9 @@ into the file
>  at offset
>  .IR dest_offset ",
>  provided that both are files.
> +If
> +.IR src_length
> +is zero, the ioctl reflinks to the end of the source file.
>  This information is conveyed in a structure of
>  the following form:
>  .in +4n
>


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
