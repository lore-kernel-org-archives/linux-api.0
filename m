From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [tip GIT PULL] y2038: timekeeping syscall changes
Date: Thu, 19 Apr 2018 12:48:11 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1804191240510.1563@nanos.tec.linutronix.de>
References: <CAK8P3a2CEK=4Os4gbnXbR7VJJgaXVQ7NLjihr7rvMSK6g3_tNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2CEK=4Os4gbnXbR7VJJgaXVQ7NLjihr7rvMSK6g3_tNA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Deepa Dinamani <deepa.kernel@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, 19 Apr 2018, Arnd Bergmann wrote:

> The following changes since commit 60cc43fc888428bb2f18f08997432d426a243338:
> 
>   Linux 4.17-rc1 (2018-04-15 18:24:20 -0700)
> 
> are available in the git repository at:
> 
>   git+ssh://gitolite@ra.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git
> tags/y2038-timekeeping

Please don't use the +ssh address as that's only accessible for those who
have a k.org account.

     git://git.kernel.org/

is accessible for everyone.

> ----------------------------------------------------------------
> Arnd Bergmann (2):
>       compat: add an asm-generic/compat.h file

Please start the subject line sentence with an uppercase letter.

>       sparc: compat: allow including asm/compat.h for 32-bit
> 
> Deepa Dinamani (10):
>       compat: Make compat helpers independent of CONFIG_COMPAT
>       include: Move compat_timespec/ timeval to compat_time.h

The proper subsystem is 'time:' not 'include:'

>       compat: enable compat_get/put_timespec64 always

>       arch: introduce CONFIG_64BIT_TIME
>       arch: Introduce CONFIG_COMPAT_32BIT_TIME

At least it should be consistent..

>       posix-clocks: Make compat syscalls depend on CONFIG_COMPAT_32BIT_TIME

'posix-timers:' please

>       include: Add new y2038 safe __kernel_timespec

'time:'

>       fix get_timespec64() for y2038 safe compat interfaces

Bah. This lacks a subsystem, i.e. 'time:'

>       change time types to new y2038 safe __kernel_* types

Ditto

>       nanosleep: change time types to safe __kernel_* types

Can you please fix that and send me an updated pull request?

Thanks,

	tglx
