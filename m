From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v2 4/9] parisc: allocate sys_membarrier system call
 number
Date: Wed, 16 Sep 2015 15:07:00 +0000 (UTC)
Message-ID: <1649019858.9290.1442416020165.JavaMail.zimbra@efficios.com>
References: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com> <1441642556-30972-5-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441642556-30972-5-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Helge Deller <deller@gmx.de>, "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: linux-kernel@vger.kernel.org, linux-parisc <linux-parisc@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Sep 7, 2015, at 12:15 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Tested-by: Helge Deller <deller@gmx.de>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: linux-api@vger.kernel.org
> CC: "James E.J. Bottomley" <jejb@parisc-linux.org>
> CC: linux-parisc@vger.kernel.org

Hi,

FYI, sys_membarrier has been pulled into Linux 4.3-rc1. Please
feel free to wire it up on parisc.

Thanks!

Mathieu

> ---
> arch/parisc/include/uapi/asm/unistd.h | 3 ++-
> arch/parisc/kernel/syscall_table.S    | 1 +
> 2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/parisc/include/uapi/asm/unistd.h
> b/arch/parisc/include/uapi/asm/unistd.h
> index 2e639d7..dadcada 100644
> --- a/arch/parisc/include/uapi/asm/unistd.h
> +++ b/arch/parisc/include/uapi/asm/unistd.h
> @@ -358,8 +358,9 @@
> #define __NR_memfd_create	(__NR_Linux + 340)
> #define __NR_bpf		(__NR_Linux + 341)
> #define __NR_execveat		(__NR_Linux + 342)
> +#define __NR_membarrier		(__NR_Linux + 343)
> 
> -#define __NR_Linux_syscalls	(__NR_execveat + 1)
> +#define __NR_Linux_syscalls	(__NR_membarrier + 1)
> 
> 
> #define __IGNORE_select		/* newselect */
> diff --git a/arch/parisc/kernel/syscall_table.S
> b/arch/parisc/kernel/syscall_table.S
> index 8eefb12..4e77991 100644
> --- a/arch/parisc/kernel/syscall_table.S
> +++ b/arch/parisc/kernel/syscall_table.S
> @@ -438,6 +438,7 @@
> 	ENTRY_SAME(memfd_create)	/* 340 */
> 	ENTRY_SAME(bpf)
> 	ENTRY_COMP(execveat)
> +	ENTRY_SAME(membarrier)
> 
> 
> .ifne (. - 90b) - (__NR_Linux_syscalls * (91b - 90b))
> --
> 1.9.1

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
