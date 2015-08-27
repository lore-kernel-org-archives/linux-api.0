From: Matt Turner <mattst88@gmail.com>
Subject: Re: [RFC PATCH 7/9] alpha: allocate sys_membarrier system call number
Date: Thu, 27 Aug 2015 11:34:20 -0700
Message-ID: <CAEdQ38HvhvcbmV_zCi=hHBnx7OnuHgX_SvvhEFjs+-hYYaDa_w@mail.gmail.com>
References: <1440698215-8355-1-git-send-email-mathieu.desnoyers@efficios.com> <1440698215-8355-8-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-alpha-owner@vger.kernel.org>
In-Reply-To: <1440698215-8355-8-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-alpha-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha <linux-alpha@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 27, 2015 at 10:56 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> [ Untested on this architecture. To try it out: fetch linux-next/akpm,
>   apply this patch, build/run a membarrier-enabled kernel, and do make
>   kselftest. ]
>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: linux-api@vger.kernel.org
> CC: Richard Henderson <rth@twiddle.net>
> CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> CC: Matt Turner <mattst88@gmail.com>
> CC: linux-alpha@vger.kernel.org
> ---
>  arch/alpha/include/uapi/asm/unistd.h | 1 +
>  arch/alpha/kernel/systbls.S          | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/arch/alpha/include/uapi/asm/unistd.h b/arch/alpha/include/uapi/asm/unistd.h
> index aa33bf5..7725619 100644
> --- a/arch/alpha/include/uapi/asm/unistd.h
> +++ b/arch/alpha/include/uapi/asm/unistd.h
> @@ -475,5 +475,6 @@
>  #define __NR_getrandom                 511
>  #define __NR_memfd_create              512
>  #define __NR_execveat                  513
> +#define __NR_membarrier                        514

NR_SYSCALLS in arch/alpha/include/asm/unistd.h needs to be updated as well.

>
>  #endif /* _UAPI_ALPHA_UNISTD_H */
> diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
> index 9b62e3f..1ea64f4 100644
> --- a/arch/alpha/kernel/systbls.S
> +++ b/arch/alpha/kernel/systbls.S
> @@ -532,6 +532,7 @@ sys_call_table:
>         .quad sys_getrandom
>         .quad sys_memfd_create
>         .quad sys_execveat
> +       .quad sys_membarrier
>
>         .size sys_call_table, . - sys_call_table
>         .type sys_call_table, @object
> --
> 1.9.1
>
