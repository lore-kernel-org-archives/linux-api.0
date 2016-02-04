From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [patch] MAINTAINERS: trim the file triggers for ABI/API
Date: Thu, 4 Feb 2016 07:38:33 -0700
Message-ID: <56B36269.3040402@osg.samsung.com>
References: <56B35A9F.1080303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56B35A9F.1080303-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/04/2016 07:05 AM, Michael Kerrisk (man-pages) wrote:
> Josh Tripplett's commit ea8f8fc8631d9f890580a94d57a18bfeb827fa2e
> was well intentioned (I even Acked it), but in practice it has mostly
> generated (a lot of) useless noise on linux-api as developers of
> drivers and implementers of other uninteresting changes run
> scripts/get-maintainers.pl and unthinkingly paste the results
> into their email clients. And that commit didn't really
> help catch the really important API changes (new system calls,
> new options to existing system calls, new pseudofile entries,
> and so on). So, trim the 'F:' triggers for the "ABI/API" entry
> in MAINTAINERS right back to the minimum.
> 
> Signed-off-by: Michael Kerrisk <mtk.man-pages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  MAINTAINERS | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f678c37..56f7a4f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -223,9 +223,7 @@ F:  drivers/scsi/aacraid/
> 
>  ABI/API
>  L:     linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> -F:     Documentation/ABI/
>  F:     include/linux/syscalls.h
> -F:     include/uapi/
>  F:     kernel/sys_ni.c
> 
>  ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
> 

Acked-by: Shuah khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
