From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/5] ipc: introduce ksys_ipc()/compat_ksys_ipc() for s390
Date: Thu, 17 Jan 2019 17:29:55 +0100
Message-ID: <CAK8P3a1u0OJKPnuBHVy4WSFy6T04kfNw5BwkpsLmkEU4KQD5eQ@mail.gmail.com>
References: <20190116131527.2071570-1-arnd@arndb.de> <20190116131527.2071570-3-arnd@arndb.de>
 <20190117132906.GB18351@osiris>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190117132906.GB18351@osiris>
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390 <linux-s390@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Mark Rutland <mark.rutland@arm.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 17, 2019 at 2:29 PM Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:

> diff --git a/arch/s390/kernel/sys_s390.c b/arch/s390/kernel/sys_s390.c
> index 6aa8fe00b39e..fd0cbbed4d9f 100644
> --- a/arch/s390/kernel/sys_s390.c
> +++ b/arch/s390/kernel/sys_s390.c
> @@ -58,6 +58,7 @@ SYSCALL_DEFINE1(mmap2, struct s390_mmap_arg_struct __user *, arg)
>         return error;
>  }
>
> +#ifdef CONFIG_SYSVIPC
>  /*
>   * sys_ipc() is the de-multiplexer for the SysV IPC calls.
>   */
> @@ -76,6 +77,7 @@ SYSCALL_DEFINE5(s390_ipc, uint, call, int, first, unsigned long, second,
>          */
>         return ksys_ipc(call, first, second, third, ptr, third);
>  }
> +#endif /* CONFIG_SYSVIPC */

Ack.

>  SYSCALL_DEFINE1(s390_personality, unsigned int, personality)
>  {
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index ab9d0e3c6d50..ad016a7db0ea 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -366,7 +366,7 @@ COND_SYSCALL(kexec_file_load);
>  /* s390 */
>  COND_SYSCALL(s390_pci_mmio_read);
>  COND_SYSCALL(s390_pci_mmio_write);
> -COND_SYSCALL_COMPAT(s390_ipc);
> +COND_SYSCALL(s390_ipc);
>
>  /* powerpc */
>  COND_SYSCALL(rtas);

I think you need to keep the

COND_SYSCALL_COMPAT(s390_ipc);

here, otherwise it still fails with CONFIG_SYSV_IPC=n, CONFIG_COMPAT=y, right?

       Arnd
