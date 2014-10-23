From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 1/3] kcmp: Move kcmp.h into uapi
Date: Thu, 23 Oct 2014 09:49:14 +0200
Message-ID: <2940943.qiYEMaLEXx@wuerfel>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414040834-30209-1-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thursday 23 October 2014 16:07:12 Michael Ellerman wrote:
> --- a/include/linux/kcmp.h
> +++ b/include/linux/kcmp.h
> @@ -1,17 +1,6 @@
>  #ifndef _LINUX_KCMP_H
>  #define _LINUX_KCMP_H
>  
> -/* Comparison type */
> -enum kcmp_type {
> -       KCMP_FILE,
> -       KCMP_VM,
> -       KCMP_FILES,
> -       KCMP_FS,
> -       KCMP_SIGHAND,
> -       KCMP_IO,
> -       KCMP_SYSVSEM,
> -
> -       KCMP_TYPES,
> -};
> +#include <uapi/linux/kcmp.h>
>  
>  #endif /* _LINUX_KCMP_H */
> 

If the file is empty except for the uapi include, I think it's better to
delete it completely. The include path logic should ensure we pick the
other one up.

	Arnd
