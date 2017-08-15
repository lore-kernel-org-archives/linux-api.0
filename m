From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH man] kcmp: Add KCMP_EPOLL_TFD description
Date: Tue, 15 Aug 2017 21:49:47 +0200
Message-ID: <1529b66d-5caa-7f34-251f-ec23428c418e@gmail.com>
References: <20170806073858.GB1916@uranus.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170806073858.GB1916-ZmlpmtaulQd+urZeOPWqwQ@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello Cyril,


On 08/06/2017 09:38 AM, Cyrill Gorcunov wrote:
>        KCMP_EPOLL_TFD
>               Check whether the file descriptor idx1 of process pid1 present in epoll(7)
>               instance described by idx2 of process  pid2.   The  argument  idx2  is  an
>               address of structure where the target file is described.
> 
>                   struct kcmp_epoll_slot {
>                        __u32 efd;
>                        __u32 tfd;
>                        __u64 toff;
>                   };
> 
>               where  efd  is  epoll  file descriptor from epoll_create(2) call, tfd is a
>               target file number, toff is a target file offset counted from zero.   Sev‐
>               eral  different  targets  may  be registered with the same file descriptor
>               number and setting specific offset helps to investigate each of them.

Thanks. I've applied this patch. Is there some example program that
demonstrates the use of this feature?

Cheers,

Michael


> Signed-off-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
>  man2/kcmp.2 |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> Index: man-pages/man2/kcmp.2
> ===================================================================
> --- man-pages.orig/man2/kcmp.2
> +++ man-pages/man2/kcmp.2
> @@ -156,6 +156,44 @@ See the discussion of the
>  .BR CLONE_VM
>  flag in
>  .BR clone (2).
> +.TP
> +.BR KCMP_EPOLL_TFD
> +Check whether the file descriptor
> +.I idx1
> +of the process
> +.I pid1
> +present in
> +.BR epoll (7)
> +instance described by
> +.I idx2
> +of the process
> +.IR pid2 .
> +The argument
> +.I idx2
> +is an address of a structure where the target file is described.
> +.in +4n
> +.nf
> +.sp
> +struct kcmp_epoll_slot {
> +	__u32 efd;
> +	__u32 tfd;
> +	__u64 toff;
> +};
> +.fi
> +.in
> +.sp
> +where
> +.I efd
> +is epoll file descriptor from
> +.BR epoll_create (2)
> +call,
> +.I tfd
> +is a target file number,
> +.I toff
> +is a target file offset counted from zero.
> +Several different targets may be registered with
> +the same file descriptor number and setting specific
> +offset helps to investigate each of them.
>  .PP
>  Note the
>  .BR kcmp ()
> @@ -246,6 +284,16 @@ Process
>  or
>  .I pid2
>  does not exist.
> +.TP
> +.B EFAULT
> +The epoll slot addressed by
> +.I idx2
> +is outside of the user's address space.
> +.TP
> +.B ENOENT
> +The target file is not present in
> +.BR epoll ()
> +instance.
>  .SH VERSIONS
>  The
>  .BR kcmp ()
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
