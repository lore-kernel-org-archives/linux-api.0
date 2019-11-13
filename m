From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/23] y2038 cleanups
Date: Wed, 13 Nov 2019 22:40:50 +0100
Message-ID: <CAK8P3a1CbDaPqNsOVOuq2UDPSOwzd2U_WEmmXBMwCOhv1=iaSQ@mail.gmail.com>
References: <20191108210236.1296047-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20191108210236.1296047-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
To: y2038 Mailman List <y2038@lists.linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Richard Henderson <rth@twiddle.net>, Tony Luck <tony.luck@intel.com>, Paul Burton <paul.burton@mips.com>, Greentime Hu <green.hu@gmail.com>, Helge Deller <deller@gmx.de>, Michael Ellerman <mpe@ellerman.id.au>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, the arch/x86 maintainers <x86@kernel.org>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Al Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>, John Stultz <john.stultz@linaro.org>, Stephen Boyd <sboyd@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tyc>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 8, 2019 at 10:04 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> This is a series of cleanups for the y2038 work, mostly intended
> for namespace cleaning: the kernel defines the traditional
> time_t, timeval and timespec types that often lead to y2038-unsafe
> code. Even though the unsafe usage is mostly gone from the kernel,
> having the types and associated functions around means that we
> can still grow new users, and that we may be missing conversions
> to safe types that actually matter.
>
> As there is no rush on any of these patches, I would either
> queue them up in linux-next through my y2038 branch, or
> Thomas could add them to the tip tree if he wants.
>
> As mentioned in another series, this is part of a larger
> effort to fix all the remaining bits and pieces that are
> not completed yet from the y2038 conversion, and the full
> set can be found at:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/log/?h=y2038-endgame
>
> Maintainers, please review and provide Acks.
>
> Let me know if you have any opinion on whether we should do
> the include last two patches of this series or not.
>
>      Arnd
>
> Arnd Bergmann (23):
>   y2038: remove CONFIG_64BIT_TIME
>   y2038: add __kernel_old_timespec and __kernel_old_time_t
>   y2038: vdso: change timeval to __kernel_old_timeval
>   y2038: vdso: change timespec to __kernel_old_timespec
>   y2038: vdso: change time_t to __kernel_old_time_t
>   y2038: vdso: nds32: open-code timespec_add_ns()
>   y2038: vdso: powerpc: avoid timespec references
>   y2038: ipc: remove __kernel_time_t reference from headers
>   y2038: stat: avoid 'time_t' in 'struct stat'
>   y2038: uapi: change __kernel_time_t to __kernel_old_time_t
>   y2038: rusage: use __kernel_old_timeval
>   y2038: syscalls: change remaining timeval to __kernel_old_timeval
>   y2038: socket: remove timespec reference in timestamping
>   y2038: make ns_to_compat_timeval use __kernel_old_timeval
>   y2038: elfcore: Use __kernel_old_timeval for process times
>   y2038: timerfd: Use timespec64 internally
>   y2038: time: avoid timespec usage in settimeofday()
>   y2038: itimer: compat handling to itimer.c
>   y2038: use compat_{get,set}_itimer on alpha
>   y2038: move itimer reset into itimer.c
>   y2038: itimer: change implementation to timespec64
>   [RFC] y2038: itimer: use ktime_t internally
>   y2038: allow disabling time32 system calls

I've dropped the "[RFC] y2038: itimer: use ktime_t internally" patch
for the moment,
and added two other patches from other series:

y2038: remove CONFIG_64BIT_TIME
y2038: socket: use __kernel_old_timespec instead of timespec

Tentatively pushed out the patches with the Acks I have received so
far to my y2038 branch on git.kernel.org so it gets included in linux-next.

If I hear no complaints, I'll send a pull request for the merge window,
along with the compat-ioctl series I have already queued up in the same
branch.

    Arnd
