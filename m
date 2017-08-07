From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v06 23/36] uapi linux/coda.h: use __kernel_pid_t and add
 u_short etc definitions for userspace
Date: Mon, 7 Aug 2017 17:06:10 +0200
Message-ID: <CAK8P3a1qZ7UjKVrtzOccTUnaUbWB56628zCSfx0qo5=gPYR59w@mail.gmail.com>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi> <20170806164428.2273-24-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170806164428.2273-24-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Harkes <jaharkes-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org>, codalist-/uMB558Y47wP4a1z8dhFYw@public.gmane.org, coda-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Aug 6, 2017 at 6:44 PM, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wrote:
> Fixes userspace compilation errors about unknown pid_t, u_short etc types.
>
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> Cc: Jan Harkes <jaharkes-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org>
> Cc: codalist-/uMB558Y47wP4a1z8dhFYw@public.gmane.org
> ---
>  include/uapi/linux/coda.h | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/coda.h b/include/uapi/linux/coda.h
> index 695fade33c64..2985ca00d63b 100644
> --- a/include/uapi/linux/coda.h
> +++ b/include/uapi/linux/coda.h
> @@ -100,7 +100,14 @@ typedef unsigned long long u_quad_t;
>  #if defined(__linux__)
>  #include <linux/time.h>
>  #define cdev_t u_quad_t
> +
>  #ifndef __KERNEL__
> +typedef unsigned long u_long;
> +typedef unsigned int u_int;
> +typedef unsigned short u_short;
> +typedef u_long ino_t;
> +typedef u_long dev_t;
> +typedef void *caddr_t;

This looks suspicious: obviously anyone who is including this
header today has to define those types somewhere. If you add
another definition, that will clash with the existing one.

Have you tried replacing the custom types with the regular
kernel types instead?

I would not worry about breaking other operating systems here,
in fact it may be better to remove the #ifdef for those altogether.

>  #if !defined(_UQUAD_T_) && (!defined(__GLIBC__) || __GLIBC__ < 2)
>  #define _UQUAD_T_ 1
>  typedef unsigned long long u_quad_t;
> @@ -295,8 +302,8 @@ struct coda_statfs {
>  struct coda_in_hdr {
>      u_int32_t opcode;
>      u_int32_t unique;      /* Keep multiple outstanding msgs distinct */
> -    pid_t pid;
> -    pid_t pgid;
> +    __kernel_pid_t pid;
> +    __kernel_pid_t pgid;
>      vuid_t uid;
>  };

This looks like an actual bugfix: pid_t might differ between libc and
the kernel, so the kernel interface has to use types that the kernel
defines. This is probably ok on any supported version of glibc,
so it's unlikely to have caused runtime problems, but it should be
fixed nonetheless.

       Arnd
