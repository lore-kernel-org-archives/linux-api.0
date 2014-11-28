From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 1/3] kcmp: Move kcmp.h into uapi
Date: Fri, 28 Nov 2014 13:18:42 +1100
Message-ID: <1417141122.6694.5.camel@concordia>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414040834-30209-1-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2014-10-23 at 16:07 +1100, Michael Ellerman wrote:
> kcmp.h appears to be part of the API, it's documented in kcmp(2), and
> the selftests/kcmp code uses it. So move it to uapi so it's actually
> exported.

Looks like this series fell through the cracks?

It still applies on rc6. Should I resend?

cheers

> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> ---
>  include/linux/kcmp.h      | 13 +------------
>  include/uapi/linux/Kbuild |  1 +
>  include/uapi/linux/kcmp.h | 17 +++++++++++++++++
>  3 files changed, 19 insertions(+), 12 deletions(-)
>  create mode 100644 include/uapi/linux/kcmp.h
> 
> diff --git a/include/linux/kcmp.h b/include/linux/kcmp.h
> index 2dcd1b3aafc8..9dfb23e1771b 100644
> --- a/include/linux/kcmp.h
> +++ b/include/linux/kcmp.h
> @@ -1,17 +1,6 @@
>  #ifndef _LINUX_KCMP_H
>  #define _LINUX_KCMP_H
>  
> -/* Comparison type */
> -enum kcmp_type {
> -	KCMP_FILE,
> -	KCMP_VM,
> -	KCMP_FILES,
> -	KCMP_FS,
> -	KCMP_SIGHAND,
> -	KCMP_IO,
> -	KCMP_SYSVSEM,
> -
> -	KCMP_TYPES,
> -};
> +#include <uapi/linux/kcmp.h>
>  
>  #endif /* _LINUX_KCMP_H */
> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> index b70237e8bc37..1cf50d682dbf 100644
> --- a/include/uapi/linux/Kbuild
> +++ b/include/uapi/linux/Kbuild
> @@ -209,6 +209,7 @@ header-y += ivtvfb.h
>  header-y += ixjuser.h
>  header-y += jffs2.h
>  header-y += joystick.h
> +header-y += kcmp.h
>  header-y += kd.h
>  header-y += kdev_t.h
>  header-y += kernel-page-flags.h
> diff --git a/include/uapi/linux/kcmp.h b/include/uapi/linux/kcmp.h
> new file mode 100644
> index 000000000000..84df14b37360
> --- /dev/null
> +++ b/include/uapi/linux/kcmp.h
> @@ -0,0 +1,17 @@
> +#ifndef _UAPI_LINUX_KCMP_H
> +#define _UAPI_LINUX_KCMP_H
> +
> +/* Comparison type */
> +enum kcmp_type {
> +	KCMP_FILE,
> +	KCMP_VM,
> +	KCMP_FILES,
> +	KCMP_FS,
> +	KCMP_SIGHAND,
> +	KCMP_IO,
> +	KCMP_SYSVSEM,
> +
> +	KCMP_TYPES,
> +};
> +
> +#endif /* _UAPI_LINUX_KCMP_H */
