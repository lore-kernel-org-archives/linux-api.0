From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] manpage: update FALLOC_FL_INSERT_RANGE flag in fallocate
Date: Fri, 08 May 2015 11:40:10 +0200
Message-ID: <554C847A.9050709@gmail.com>
References: <009201d0894f$d87f0890$897d19b0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <009201d0894f$d87f0890$897d19b0$@samsung.com>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Namjae,

> Update FALLOC_FL_INSERT_RANGE flag in fallocate.

Sorry -- I should have said that I already applied your V2 
patch and made the fix we discussed (and that you add below).
I just hadn't pushed to Git yet. Done now.

Cheers,

Michael

On 05/08/2015 07:28 AM, Namjae Jeon wrote:
> Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  man2/fallocate.2 | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 84 insertions(+), 5 deletions(-)
> 
> diff --git a/man2/fallocate.2 b/man2/fallocate.2
> index 0cc1a00..0d31027 100644
> --- a/man2/fallocate.2
> +++ b/man2/fallocate.2
> @@ -228,6 +228,59 @@ ext4, for extent-based files (since Linux 3.15)
>  .IP *
>  SMB3 (since Linux 3.17)
>  .\" commit 30175628bf7f521e9ee31ac98fa6d6fe7441a556
> +.SS Increasing file space
> +flag (available since Linux 4.1)
> +.\" commit dd46c787788d5bf5b974729d43e4c405814a4c7d
> +Specifying the
> +.BR FALLOC_FL_INSERT_RANGE
> +flag in
> +.I mode
> +will increase the file space by inserting a hole within the file size without
> +overwriting any existing data.
> +The hole will start at
> +.I offset
> +and continue for
> +.I len
> +bytes.
> +For inserting hole inside file, the contents of the file starting at
> +.I offset
> +will be shifted towards right by
> +.I len
> +bytes.
> +Inserting a hole inside the file will increase the file size by
> +.I len
> +bytes.
> +
> +This mode has the same limitation as
> +.BR FALLOC_FL_COLLAPSE_RANGE
> +regarding the
> +granularity of the operation.
> +If the granularity requirements are not met,
> +.BR fallocate ()
> +will fail with the error
> +.BR EINVAL.
> +If the
> +.I offset
> +is greater than or equal to the end of file, an error is
> +returned.
> +For such type of operations, i.e. inserting a hole at the end of file,
> +.BR ftruncate(2)
> +should be used.
> +In case
> +.IR offset + len
> +exceeds the maximum file size, errno will be set to
> +.B EFBIG.
> +
> +No other flags may be specified in
> +.IR mode
> +in conjunction with
> +.BR FALLOC_FL_INSERT_RANGE .
> +
> +As of Linux 4.1,
> +.B FALLOC_FL_INSERT_RANGE
> +is supported by
> +XFS.
> +.\" commit a904b1ca5751faf5ece8600e18cd3b674afcca1b
>  .SH RETURN VALUE
>  On success,
>  .BR fallocate ()
> @@ -245,6 +298,12 @@ is not a valid file descriptor, or is not opened for writing.
>  .IR offset + len
>  exceeds the maximum file size.
>  .TP
> +.B EFBIG
> +.I mode
> +is
> +.BR FALLOC_FL_INSERT_RANGE ,
> +the current file size+len exceeds the maximum file size.
> +.TP
>  .B EINTR
>  A signal was caught during execution.
>  .TP
> @@ -273,7 +332,17 @@ reaches or passes the end of the file.
>  .B EINVAL
>  .I mode
>  is
> -.BR FALLOC_FL_COLLAPSE_RANGE ,
> +.BR FALLOC_FL_INSERT_RANGE
> +and the range specified by
> +.I offset
> +reaches or passes the end of the file.
> +.TP
> +.B EINVAL
> +.I mode
> +is
> +.BR FALLOC_FL_COLLAPSE_RANGE
> +or
> +.BR FALLOC_FL_INSERT_RANGE ,
>  but either
>  .I offset
>  or
> @@ -282,18 +351,24 @@ is not a multiple of the filesystem block size.
>  .TP
>  .B EINVAL
>  .I mode
> -contains both
> +contains either of
>  .B FALLOC_FL_COLLAPSE_RANGE
> +or
> +.B FALLOC_FL_INSERT_RANGE
>  and other flags;
>  no other flags are permitted with
> -.BR FALLOC_FL_COLLAPSE_RANGE .
> +.BR FALLOC_FL_COLLAPSE_RANGE
> +or
> +.BR FALLOC_FL_INSERT_RANGE .
>  .TP
>  .B EINVAL
>  .I mode
>  is
>  .BR FALLOC_FL_COLLAPSE_RANGE
>  or
> -.BR FALLOC_FL_ZERO_RANGE ,
> +.BR FALLOC_FL_ZERO_RANGE
> +or
> +.BR FALLOC_FL_INSERT_RANGE ,
>  but the file referred to by
>  .I fd
>  is not a regular file.
> @@ -345,6 +420,8 @@ specifies
>  .BR FALLOC_FL_PUNCH_HOLE
>  or
>  .BR FALLOC_FL_COLLAPSE_RANGE
> +or
> +.BR FALLOC_FL_INSERT_RANGE
>  and
>  the file referred to by
>  .I fd
> @@ -363,7 +440,9 @@ refers to a pipe or FIFO.
>  .B ETXTBSY
>  .I mode
>  specifies
> -.BR FALLOC_FL_COLLAPSE_RANGE ,
> +.BR FALLOC_FL_COLLAPSE_RANGE
> +or
> +.BR FALLOC_FL_INSERT_RANGE ,
>  but the file referred to by
>  .IR fd
>  is currently being executed.
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
