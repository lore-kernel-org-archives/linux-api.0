From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH 2/2] selftests/userfaultfd: improve syscall number
 definition
Date: Tue, 22 Sep 2015 07:49:13 -0600
Message-ID: <56015C59.5010300@osg.samsung.com>
References: <1442918756-17892-1-git-send-email-andre.przywara@arm.com>
 <1442918756-17892-3-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442918756-17892-3-git-send-email-andre.przywara-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/22/2015 04:45 AM, Andre Przywara wrote:
> At the moment the userfaultfd test program only supports x86 and an
> architecture called "powewrpc" ;-)
> Fix that typo and add the syscall numbers for other architectures as
> well.
> Also as in an ideal world a syscall number should come from the system
> header file <asm/unistd.h>, include that header and guard the explicit
> syscall number section below to avoid redefinitions.
> 
> Signed-off-by: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
> ---
>  tools/testing/selftests/vm/userfaultfd.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
> index 2c7cca6..63be27f 100644
> --- a/tools/testing/selftests/vm/userfaultfd.c
> +++ b/tools/testing/selftests/vm/userfaultfd.c
> @@ -65,16 +65,27 @@
>  #include <sys/ioctl.h>
>  #include <pthread.h>
>  #include "../../../../include/uapi/linux/userfaultfd.h"
> +#include <asm/unistd.h>
>  
> +/* ideally the above user header provides that number, but ... */
> +#ifndef __NR_userfaultfd
>  #ifdef __x86_64__
>  #define __NR_userfaultfd 323
>  #elif defined(__i386__)
>  #define __NR_userfaultfd 374
> -#elif defined(__powewrpc__)
> +#elif defined(__powerpc__)
>  #define __NR_userfaultfd 364
> +#elif defined(__ia64__)
> +#define __NR_userfaultfd 1343
> +#elif defined(__arm__)
> +#define __NR_userfaultfd 388
> +#elif defined(__aarch64__)
> +/* this is from the generic syscall table, used also on other architectures */
> +#define __NR_userfaultfd 283
>  #else
>  #error "missing __NR_userfaultfd definition"
>  #endif
> +#endif /* !__NR_userfaultfd */
>  
>  static unsigned long nr_cpus, nr_pages, nr_pages_per_cpu, page_size;
>  
> 

This is not okay. User-space shouldn't be (re)defining/duplicating
syscall numbers. I can't take this patch.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
