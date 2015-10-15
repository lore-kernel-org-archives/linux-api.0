From: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] selftests: memfd_test: Revised STACK_SIZE to make it
 16-byte aligned
Date: Thu, 15 Oct 2015 11:22:16 +0800
Message-ID: <CAG2=9p9xW2u=Cac9BE7sWPCq8zaYs-tmaQbHm-SM2ZhEMH4Tow@mail.gmail.com>
References: <1443684782-10898-1-git-send-email-zhang.chunyan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443684782-10898-1-git-send-email-zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Shuah,

Can this patch be allowed to merge into next realse?

Thanks,
Chunyan

On Thu, Oct 1, 2015 at 3:33 PM, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> There is a mandate of 16-byte aligned stack on AArch64 [1], so the
> STACK_SIZE here should also be 16-byte aligned, otherwise we would
> get an error when calling clone().
>
> [1] http://lxr.free-electrons.com/source/arch/arm64/kernel/process.c#L265
>
> Signed-off-by: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  tools/testing/selftests/memfd/memfd_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
> index 0b9eafb..aa5d3eb 100644
> --- a/tools/testing/selftests/memfd/memfd_test.c
> +++ b/tools/testing/selftests/memfd/memfd_test.c
> @@ -18,7 +18,7 @@
>  #include <unistd.h>
>
>  #define MFD_DEF_SIZE 8192
> -#define STACK_SIZE 65535
> +#define STACK_SIZE 65536
>
>  static int sys_memfd_create(const char *name,
>                             unsigned int flags)
> --
> 1.9.1
>
