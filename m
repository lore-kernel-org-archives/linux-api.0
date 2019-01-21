From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 29/29] y2038: add 64-bit time_t syscalls to all 32-bit architectures
Date: Mon, 21 Jan 2019 17:31:01 +0100
Message-ID: <CAK8P3a2grsgvLeBHFoLnnpJti7qkZFfBPTrXf+CoihtOJKySzw@mail.gmail.com>
References: <20190118161835.2259170-1-arnd@arndb.de> <20190118161835.2259170-30-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190118161835.2259170-30-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>
Cc: Matt Turner <mattst88@gmail.com>, Russell King - ARM Linux <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Michal Simek <monstr@monstr.eu>, Paul Burton <paul.burton@mips.com>, Helge Deller <deller@gmx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>, David Miller <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 18, 2019 at 5:25 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> This adds 21 new system calls on each ABI that has 32-bit time_t
> today. All of these have the exact same semantics as their existing
> counterparts, and the new ones all have macro names that end in 'time64'
> for clarification.
>
> This gets us to the point of being able to safely use a C library
> that has 64-bit time_t in user space. There are still a couple of
> loose ends to tie up in various areas of the code, but this is the
> big one, and should be entirely uncontroversial at this point.

I've successfully tested this with musl and LTP now, using an
i386 kernel. The musl port I used is at
https://git.linaro.org/people/arnd.bergmann/musl-y2038.git/
This is just an updated version of what I used for testing last
year, using the current syscall assignment, and going back
to the time32 versions of getitimer/setitimer and
wait4/waitid/getusage.

It's certainly not intended for merging like this, but a proper
musl port is under discussion now, and this should be
sufficient if anyone else wants to try out the new syscall
ABI before we merge it.

The LTP I have is heavily hacked, and has a number of
failures resulting from differences between musl and glibc,
or from the way we convert between the kernel types and
the user space types.

The testing found one minor bug in all the kernel syscall tables:

> +418    common  mq_timedsend_time64             sys_mq_timedsend
> +419    common  mq_timedreceiv_time64           sys_mq_timedreceive

While this would have fit in with umount(), creat() and mknod(),
it was unintentional, and I've changed it back to
mq_timedreceive_time64 (with an added 'e').

       Arnd
