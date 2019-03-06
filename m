From: Laura Abbott <labbott@redhat.com>
Subject: Re: [PATCH] ipc: Fix building compat mode without sysvipc
Date: Wed, 6 Mar 2019 06:44:51 -0800
Message-ID: <3614a6b8-0c2f-747c-ce60-b58e79c5cec5@redhat.com>
References: <20190306142944.834167-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190306142944.834167-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, y2038@lists.linaro.org
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 3/6/19 6:29 AM, Arnd Bergmann wrote:
> As John Stultz noticed, my y2038 syscall series caused a link
> failure when CONFIG_SYSVIPC is enabled but CONFIG_COMPAT is
> enabled:
> 

is this supposed to be "CONFIG_SYSVIPC is disabled" to match the
subject?

> arch/arm64/kernel/sys32.o:(.rodata+0x960): undefined reference to `__arm64_compat_sys_old_semctl'
> arch/arm64/kernel/sys32.o:(.rodata+0x980): undefined reference to `__arm64_compat_sys_old_msgctl'
> arch/arm64/kernel/sys32.o:(.rodata+0x9a0): undefined reference to `__arm64_compat_sys_old_shmctl'
> 
> Add the missing entries in kernel/sys_ni.c for the new system
> calls.
> 
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I'm about to send off my pull requests for arm-soc, so I'd just
> send another one with just this common from my y2038 tree.
> ---
>   kernel/sys_ni.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index 85e5ccec0955..62a6c8707799 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -202,6 +202,7 @@ COND_SYSCALL(msgget);
>   COND_SYSCALL(old_msgctl);
>   COND_SYSCALL(msgctl);
>   COND_SYSCALL_COMPAT(msgctl);
> +COND_SYSCALL_COMPAT(old_msgctl);
>   COND_SYSCALL(msgrcv);
>   COND_SYSCALL_COMPAT(msgrcv);
>   COND_SYSCALL(msgsnd);
> @@ -212,6 +213,7 @@ COND_SYSCALL(semget);
>   COND_SYSCALL(old_semctl);
>   COND_SYSCALL(semctl);
>   COND_SYSCALL_COMPAT(semctl);
> +COND_SYSCALL_COMPAT(old_semctl);
>   COND_SYSCALL(semtimedop);
>   COND_SYSCALL(semtimedop_time32);
>   COND_SYSCALL(semop);
> @@ -221,6 +223,7 @@ COND_SYSCALL(shmget);
>   COND_SYSCALL(old_shmctl);
>   COND_SYSCALL(shmctl);
>   COND_SYSCALL_COMPAT(shmctl);
> +COND_SYSCALL_COMPAT(old_shmctl);
>   COND_SYSCALL(shmat);
>   COND_SYSCALL_COMPAT(shmat);
>   COND_SYSCALL(shmdt);
> 
