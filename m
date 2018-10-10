From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9 00/24] ILP32 for ARM64
Date: Wed, 10 Oct 2018 16:18:02 +0200
Message-ID: <CAK8P3a2svZe6FHoNzjkizwwDZfRQ4Y7qpX0y4m6T56uo8n4gVQ@mail.gmail.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
 <20180724173957.GA22106@yury-thinkpad> <20181010141017.GA2881@asgard.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181010141017.GA2881@asgard.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Syromiatnikov <esyr@redhat.com>
Cc: Yury Norov <ynorov@caviumnetworks.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James
List-Id: linux-api@vger.kernel.org

On 10/10/18, Eugene Syromiatnikov <esyr@redhat.com> wrote:
> On Tue, Jul 24, 2018 at 08:39:57PM +0300, Yury Norov wrote:
>> Hi all,
>>
>> + Pavel Machek, Palmer Dabbelt, Wookey.
>>
>> On Wed, May 16, 2018 at 11:18:45AM +0300, Yury Norov wrote:
>> > This series enables AARCH64 with ILP32 mode.
>> >
>> > As supporting work, it introduces ARCH_32BIT_OFF_T configuration
>> > option that is enabled for existing 32-bit architectures but disabled
>> > for new arches (so 64-bit off_t userspace type is used by new
>> > userspace).
>> > Also it deprecates getrlimit and setrlimit syscalls prior to prlimit64.
>> >
>> > Based on kernel v4.16. Tested with LTP, glibc testsuite, trinity,
>> > lmbench,
>> > CPUSpec.
>
>> This is the update of the series based on 4.17 kernel
>> https://github.com/norov/linux/tree/ilp32-4.17
>
> Hello.
>
> I have some questions regarding AArch64 ILP32 implementation for which I
> failed to find an answer myself:
>  * How ptrace() tracer is supposed to distinguish between ILP32 and LP64
>    tracees? For MIPS N32 and x32 this is possible based on syscall
>    number, but for AArch64 ILP32 I do not see such a sign. There's also
>    ARM_ip is employed for signalling entering/exiting, I wonder whether
>    it's possible to employ it also for signalling tracee's personality.

Don't know.

>  * What's the reasoning behind capping syscall arguments to 32 bit? x32
>    and MIPS N32 do not have such a restriction (and do not need special
>    wrappers for syscalls that pass 64-bit values as a result, except
>    when they do,  as it is the case for preadv2 on x32); moreover, that
>    would lead to insurmountable difficulties for AArch64 ILP32 tracers
>    that try to trace LP64 tracees, as it would be impossible to pass
>    64-bit addresses to process_vm_{read,write} or ptrace PEEK/POKE.

The idea is to keep the syscall entry points as similar as possible
between arm (aarch32) emulation and aarch64-ilp32 mode when
you have a kernel that supports both.

      Arnd
