From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v2 9/9] s390/s390x: allocate sys_membarrier system
 call number
Date: Wed, 16 Sep 2015 15:20:05 +0000 (UTC)
Message-ID: <1822824828.9340.1442416805361.JavaMail.zimbra@efficios.com>
References: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com> <1441642556-30972-10-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441642556-30972-10-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: schwidefsky <schwidefsky@de.ibm.com>, heiko carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Sep 7, 2015, at 12:15 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> [ Untested on this architecture. To try it out: fetch linux-next/akpm,
>  apply this patch, build/run a membarrier-enabled kernel, and do make
>  kselftest. ]

Hi,

sys_membarrier has been merged into Linux 4.3-rc1. It can therefore
be tested on top of Linus' master by applying this patch.

Thanks,

Mathieu

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: linux-api@vger.kernel.org
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
> CC: Heiko Carstens <heiko.carstens@de.ibm.com>
> CC: linux-s390@vger.kernel.org
> ---
> arch/s390/include/uapi/asm/unistd.h | 3 ++-
> arch/s390/kernel/syscalls.S         | 1 +
> 2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/uapi/asm/unistd.h
> b/arch/s390/include/uapi/asm/unistd.h
> index 59d2bb4..2f1de70 100644
> --- a/arch/s390/include/uapi/asm/unistd.h
> +++ b/arch/s390/include/uapi/asm/unistd.h
> @@ -290,7 +290,8 @@
> #define __NR_s390_pci_mmio_write	352
> #define __NR_s390_pci_mmio_read		353
> #define __NR_execveat		354
> -#define NR_syscalls 355
> +#define __NR_membarrier		355
> +#define NR_syscalls 356
> 
> /*
>  * There are some system calls that are not present on 64 bit, some
> diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
> index f3f4a13..914c098 100644
> --- a/arch/s390/kernel/syscalls.S
> +++ b/arch/s390/kernel/syscalls.S
> @@ -363,3 +363,4 @@ SYSCALL(sys_bpf,compat_sys_bpf)
> SYSCALL(sys_s390_pci_mmio_write,compat_sys_s390_pci_mmio_write)
> SYSCALL(sys_s390_pci_mmio_read,compat_sys_s390_pci_mmio_read)
> SYSCALL(sys_execveat,compat_sys_execveat)
> +SYSCALL(sys_membarrier,sys_membarrier)
> --
> 1.9.1

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
