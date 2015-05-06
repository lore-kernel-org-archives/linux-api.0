From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v10 12/12] manpage: update FALLOC_FL_INSERT_RANGE flag
 in fallocate
Date: Wed, 06 May 2015 14:43:25 +0200
Message-ID: <554A0C6D.8070408@gmail.com>
References: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com> <1424533554-28024-13-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424533554-28024-13-git-send-email-linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Namjae Jeon <linkinjeon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, bfoster-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Hello Namjae Jeon,

I see that FALLOC_FL_INSERT_RANGE has hit mainline. Could I ask you refresh 
this patch, please? (Against latest man-pages Git, please, since the current
patch does not apply cleanly).

See some comments below.

On 02/21/2015 04:45 PM, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> 
> Update FALLOC_FL_INSERT_RANGE flag in fallocate.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  man2/fallocate.2 |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 82 insertions(+), 6 deletions(-)
> 
> diff --git a/man2/fallocate.2 b/man2/fallocate.2
> index adf42db..9b3c460 100644
> --- a/man2/fallocate.2
> +++ b/man2/fallocate.2
> @@ -8,7 +8,7 @@
>  .\" 2011-09-19: Added FALLOC_FL_PUNCH_HOLE
>  .\" 2011-09-19: Substantial restructuring of the page
>  .\"
> -.TH FALLOCATE 2 2015-01-22 "Linux" "Linux Programmer's Manual"
> +.TH FALLOCATE 2 2015-02-14 "Linux" "Linux Programmer's Manual"

No need to update the timestamp on the page. I have scripts
that do this automatically.

>  .SH NAME
>  fallocate \- manipulate file space
>  .SH SYNOPSIS
> @@ -225,6 +225,56 @@ XFS (since Linux 3.14)
>  .IP *
>  ext4, for extent-based files (since Linux 3.14)
>  .\" commit b8a8684502a0fc852afa0056c6bb2a9273f6fcc0
> +.SS Increasing file space
> +.\" TODO: Mention commit id and supporting Linux version

Yes, please add the commit ID and "Linux 4.1".

> +Specifying the
> +.BR FALLOC_FL_INSERT_RANGE
> +flag in
> +.I mode
> +will increase the file space by inserting a hole within the file size without
> +overwriting any existing data. The hole will start at
                                  ^
Please start new sentences on new source lines. (Same thing at various 
lines below.)

> +.I offset
> +and continue for
> +.I len
> +bytes. For inserting hole inside file, the contents of the file starting at

Please start new sentences on new source lines.

> +.I offset
> +will be shifted towards right by
> +.I len
> +bytes. Inserting a hole inside the file will increase the file size by

Please start new sentences on new source lines.

> +.I len
> +bytes.
> +
> +This mode has the same limitation as
> +.BR FALLOC_FL_COLLAPSE_RANGE
> +regarding the
> +granularity of the operation.
> +If the granulrity requirements are not met,

Spelling: "granularity"

> +.BR fallocate ()
> +will fail with the error
> +.BR EINVAL.
> +If the
> +.I offset
> +overlaps with end of file OR if it is greater than end of file, an error is
> +returned. For such type of operations, i.e. inserting a hole at the end of

Please start new sentences on new source lines.

> +file,
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
> +As of Linux XXXX,
> +.\" TODO: Mention commit id and supporting Linux version
> +.B FALLOC_FL_INSERT_RANGE
> +is supported by
> +ext4 (only for extent-based files) and XFS.

Is the ext4 support really there? Grep Linus's current Git, it appears
that only XFS support is currently there?

> +
>  .SH RETURN VALUE
>  On success,
>  .BR fallocate ()
> @@ -242,6 +292,12 @@ is not a valid file descriptor, or is not opened for writing.
>  .IR offset + len
>  exceeds the maximum file size.
>  .TP
> +.B EFBIG
> +.I mode
> +is
> +.BR FALLOC_FL_INSERT_RANGE ,
> +the current file size+len excceds the maximum file size.

"exceeds"

> +.TP
>  .B EINTR
>  A signal was caught during execution.
>  .TP
> @@ -270,7 +326,17 @@ reaches or passes the end of the file.
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
> @@ -279,18 +345,24 @@ is not a multiple of the filesystem block size.
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
> @@ -342,6 +414,8 @@ specifies
>  .BR FALLOC_FL_PUNCH_HOLE
>  or
>  .BR FALLOC_FL_COLLAPSE_RANGE
> +or
> +.BR FALLOC_FL_INSERT_RANGE
>  and
>  the file referred to by
>  .I fd
> @@ -360,7 +434,9 @@ refers to a pipe or FIFO.
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

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
