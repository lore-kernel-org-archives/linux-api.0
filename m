From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] manpage: update FALLOC_FL_INSERT_RANGE flag in fallocate
Date: Thu, 07 May 2015 10:19:29 +0200
Message-ID: <554B2011.5010703@gmail.com>
References: <006d01d08884$dcfc7ea0$96f57be0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <006d01d08884$dcfc7ea0$96f57be0$@samsung.com>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Namjae Jeon,

Thanks for the revised patch. I have a question below:

On 05/07/2015 07:15 AM, Namjae Jeon wrote:
> Update FALLOC_FL_INSERT_RANGE flag in fallocate.
> 
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
> +overlaps with end of file OR if it is greater than end of file, an error is


Could that last line not be simplified to

   if the offset is greater than or equal to the end of file

?

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
