From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 17/19] y2038: use __kernel_timespec in sys_futex
Date: Sat, 16 May 2015 00:53:17 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1505160049210.4225@nanos>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de> <1430929826-318934-18-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430929826-318934-18-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, baolin.wang@linaro.org, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On Wed, 6 May 2015, Arnd Bergmann wrote:

> Conversion for sys_futex is particularly easy, we can use the unmodified
> compat_sys_futex on 32-bit systems to provide compatibility for 32-bit
> time_t, and change sys_futex to pass a __kernel_timespec, which matches
> what future libc implementations will use as their struct timespec.

Unless I'm missing something I doubt that you get away that easy. It
works on 32bit, but not on 64 bit with 32bit app support:

Native 64bit: 	   sys_futex()
32bit timespec32:  compat_sys_futex()
32bit timespec64:  ?????

You cannot map that to sys_futex() because the pointer size differs.
 
Thanks,

	tglx
