From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] generic syscalls: wire up userfaultfd syscall
Date: Tue, 22 Sep 2015 16:52:52 +0100
Message-ID: <20150922155251.GJ7356@arm.com>
References: <1442919139-18027-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442919139-18027-1-git-send-email-andre.przywara@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <Catalin.Marinas@arm.com>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 22, 2015 at 11:52:19AM +0100, Andre Przywara wrote:
> Enable the new userfaultfd syscall in the generic syscall table.
> Briefly tested on arm64 with the selftest from the tools directory.

Can you update the selftest too, please? Last time I looked at that it had
typo for the powerpc check and looked pretty unloved...

Will

> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  include/uapi/asm-generic/unistd.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
> index 8da542a..82c91bc 100644
> --- a/include/uapi/asm-generic/unistd.h
> +++ b/include/uapi/asm-generic/unistd.h
> @@ -711,9 +711,11 @@ __SYSCALL(__NR_bpf, sys_bpf)
>  __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
>  #define __NR_membarrier 282
>  __SYSCALL(__NR_membarrier, sys_membarrier)
> +#define __NR_userfaultfd 283
> +__SYSCALL(__NR_userfaultfd, sys_userfaultfd)
>  
>  #undef __NR_syscalls
> -#define __NR_syscalls 283
> +#define __NR_syscalls 284
>  
>  /*
>   * All syscalls below here should go away really,
> -- 
> 2.5.1
> 
