From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9 00/24] ILP32 for ARM64
Date: Sun, 14 Oct 2018 21:53:22 +0200
Message-ID: <CAK8P3a1qUVoE0CYkCOU2N+-WkqMad15fFsakbwkpiiPPRFz-eA@mail.gmail.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
 <20180724173957.GA22106@yury-thinkpad> <20181010141017.GA2881@asgard.redhat.com>
 <7aac1a08-8948-1a04-cbd3-fbc6a53f9ff0@arm.com> <20181013020731.GD21972@asgard.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181013020731.GD21972@asgard.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Syromiatnikov <esyr@redhat.com>
Cc: Szabolcs Nagy <szabolcs.nagy@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, nd@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, David Miller <davem@davemloft.>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 13, 2018 at 4:07 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
>
> On Wed, Oct 10, 2018 at 03:39:07PM +0100, Szabolcs Nagy wrote:
> > On 10/10/18 15:10, Eugene Syromiatnikov wrote:
> > >  * What's the reasoning behind capping syscall arguments to 32 bit? x32
> > >    and MIPS N32 do not have such a restriction (and do not need special
> > >    wrappers for syscalls that pass 64-bit values as a result, except
> > >    when they do,  as it is the case for preadv2 on x32); moreover, that
> > >    would lead to insurmountable difficulties for AArch64 ILP32 tracers
> > >    that try to trace LP64 tracees, as it would be impossible to pass
> > >    64-bit addresses to process_vm_{read,write} or ptrace PEEK/POKE.
> >
> > but that's necessarily the case for all ilp32 abis:
> > the userspace syscall function receives 32bit
> > arguments so even if the kernel abi takes 64bit
> > args you cannot use that from c code. (the libc
> > does not even know which args should be sign or
> > zero extended.)
>
> glibc's syscall() prototype has kernel_ulong_t as its arguments (more
> specifically, to __syscall_ulong_t, which is 64-bit wide on x32; it
> should also have kernel_long_t as its return type instead of long,
> but that's another story), so it works perfectly fine in case of x32.
>
> > process_vm_readv/writev is limited by the ilp32
> > iovec struct, not by the syscall arguments.
>
> Right, on x32/N32 this issue is worked around by the usage of the respective
> x86_64/N64 call, and it looks like another thing that is impossible
> with AArch64 ilp32.
>
> > ptrace is specified to take void* addr argument,
> > and void* is 32bit on all ilp32 targets.
> > so again on the c language level there is no
> > way around the 32bit limitation.
>
> Which is an issue.

I have no idea why you think this is a problem specific to aarch64-ilp32:
If we want to be able to debug 64-bit tasks from a 32-bit task on any
architecture that has compat mode, we should solve it once and
extend the ptrace interface to allow it on *all* of them. We certainly
don't need /more/ special cases for the x32 hack, there should really
be fewer of them.

      Arnd
