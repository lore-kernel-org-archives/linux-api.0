From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2] pid_ns: Introduce ioctl to set vector of
 ns_last_pid's on ns hierarhy
Date: Thu, 27 Apr 2017 13:55:54 +0200
Message-ID: <20170427115554.GA22360@kroah.com>
References: <149329053642.12846.16389129928422677700.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <149329053642.12846.16389129928422677700.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 27, 2017 at 01:57:16PM +0300, Kirill Tkhai wrote:
> --- a/include/uapi/linux/nsfs.h
> +++ b/include/uapi/linux/nsfs.h
> @@ -14,5 +14,12 @@
>  #define NS_GET_NSTYPE		_IO(NSIO, 0x3)
>  /* Get owner UID (in the caller's user namespace) for a user namespace */
>  #define NS_GET_OWNER_UID	_IO(NSIO, 0x4)
> +/* Set a vector of ns_last_pid for a pid namespace stack */
> +#define NS_SET_LAST_PID_VEC	_IO(NSIO, 0x5)
> +
> +struct ns_ioc_pid_vec {
> +	unsigned int nr;

Please make this an explicit type, variables that cross the user/kernel
boundry should be using __u32 and friends, not vague things like "int".

thanks,

greg k-h
