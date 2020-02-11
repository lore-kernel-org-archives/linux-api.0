From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] prctl.2: doc PR_SET/GET_IO_FLUSHER
Date: Tue, 11 Feb 2020 15:17:25 +0100
Message-ID: <20200211141725.4vbnh3iifbbaquec@wittgenstein>
References: <20200210221557.8021-1-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200210221557.8021-1-mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Christie <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, masato.suzuki-Sjgp3cTcYWE@public.gmane.org, damien.lemoal-Sjgp3cTcYWE@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

I think you've missed:
mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

:)

Christian

On Mon, Feb 10, 2020 at 04:15:57PM -0600, Mike Christie wrote:
> This patch documents the PR_SET_IO_FLUSHER and PR_GET_IO_FLUSHER
> prctl commands added to the linux kernel for 5.6 in commit:
> 
> commit 8d19f1c8e1937baf74e1962aae9f90fa3aeab463
> Author: Mike Christie <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Mon Nov 11 18:19:00 2019 -0600
> 
>     prctl: PR_{G,S}ET_IO_FLUSHER to support controlling memory reclaim
> 
> Signed-off-by: Mike Christie <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> 
> V2:
> - My initial patch for this was very bad. This version is almost 100%
> taken word for word from Dave Chinner's review comments.
> 
> 
>  man2/prctl.2 | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/man2/prctl.2 b/man2/prctl.2
> index 720ec04e4..b481d186b 100644
> --- a/man2/prctl.2
> +++ b/man2/prctl.2
> @@ -1381,6 +1381,30 @@ system call on Tru64).
>  for information on versions and architectures.)
>  Return unaligned access control bits, in the location pointed to by
>  .IR "(unsigned int\ *) arg2" .
> +.TP
> +.B PR_SET_IO_FLUSHER (Since Linux 5.6)
> +An IO_FLUSHER is a user process that the kernel uses to issue IO
> +that cleans dirty page cache data and/or filesystem metadata. The
> +kernel may need to clean this memory when under memory pressure in
> +order to free it. This means there is potential for a memory reclaim
> +recursion deadlock if the user process attempts to allocate memory
> +and the kernel then blocks waiting for it to clean memory before it
> +can make reclaim progress.
> +
> +The kernel avoids these recursion problems internally via a special
> +process state that prevents recursive reclaim from issuing new IO.
> +If \fIarg2\fP is 1, the \fPPR_SET_IO_FLUSHER\fP control allows a userspace
> +process to set up this same process state and hence avoid the memory
> +reclaim recursion deadlocks in the same manner the kernel avoids them.
> +If \fIarg2\fP is 0, the process will clear the IO_FLUSHER state, and the
> +default behavior will be used.
> +
> +Examples of IO_FLUSHER applications are FUSE daemons, zoned disk
> +emulation daemons, etc."
> +.TP
> +.B PR_GET_IO_FLUSHER (Since Linux 5.6)
> +Return as the function result 1 if the caller is in the IO_FLUSHER state and
> +0 if not.
>  .SH RETURN VALUE
>  On success,
>  .BR PR_GET_DUMPABLE ,
> @@ -1395,6 +1419,7 @@ On success,
>  .BR PR_GET_SPECULATION_CTRL ,
>  .BR PR_MCE_KILL_GET ,
>  .BR PR_CAP_AMBIENT + PR_CAP_AMBIENT_IS_SET ,
> +.BR PR_GET_IO_FLUSHER ,
>  and (if it returns)
>  .BR PR_GET_SECCOMP
>  return the nonnegative values described above.
> -- 
> 2.21.0
> 
