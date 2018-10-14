From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v9 00/24] ILP32 for ARM64
Date: Sun, 14 Oct 2018 21:49:01 +0200
Message-ID: <CAK8P3a1Yhhv1TcQTcF0MinicGovgp_0g_sXqADe3fjVTtOK_aw@mail.gmail.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com> <CALCETrVuabkb5ZQOSgQQTEq8CrS602NBpAkE2=4n982r1f5reQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVuabkb5ZQOSgQQTEq8CrS602NBpAkE2=4n982r1f5reQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Yury Norov <ynorov@caviumnetworks.com>, Catalin Marinas <catalin.marinas@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, David Miller <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 13, 2018 at 9:36 PM Andy Lutomirski <luto@amacapital.net> wrote:
>
> On Wed, May 16, 2018 at 1:19 AM Yury Norov <ynorov@caviumnetworks.com> wrote:
> >
> > This series enables AARCH64 with ILP32 mode.
> >
> > As supporting work, it introduces ARCH_32BIT_OFF_T configuration
> > option that is enabled for existing 32-bit architectures but disabled
> > for new arches (so 64-bit off_t userspace type is used by new userspace).
> > Also it deprecates getrlimit and setrlimit syscalls prior to prlimit64.
>
> Second, ILP32 user code is highly unlikely
> to end up with the same struct layout as ILP64 code.  The latter seems
> like it should be solved entirely in userspace by adding a way to
> annotate a structure as being a kernel ABI structure and getting the
> toolchain to lay it out as if it were ILP64 even though the target is
> ILP32.

The syscall ABI could be almost completely abstracted in glibc, the
main issue is ioctl and a couple of related interfaces that pass data
structures (read() on /dev/input/*, mmap on /dev/snd/*
or raw sockets, fcntl).

The question whether a data type is laid out like a 64-bit architecture
would cannot be a property of the type in most of those cases,
because the same types are used elsewhere. Many ioctls just
take a pointer to a 'long' or similar, and then you have structures
like 'timespec' that are used both in syscall/ioctl ABI and in normal
user space code, but are required to be laid out differently there.
(timespec is a bad example because y2038 of course, but it
illustrates the point).

> 2. I think you should make a conscious decision as to whether the
> ILP32-ness of a syscall is a property of the task or of the syscall.
> On x86, x32-ness is a property of the syscall, but historically it
> also got rather entangled with the state of the task, and the result
> was a mess.  It looks like you're making it be a property of the task,
> which is fine, but you're making it impossible for very clever ILP32
> libraries to include little ILP64 stubs that do fancy things with full
> 64-bit syscalls.
>
> 3. Make very certain that you aren't exploitable by malicious
> processes that set the high bits in ILP32 syscall args.  x86 compat
> has issues like that in the past.

This point was actually the most important one for keeping the
aarch64 ilp32 interface as restricted as it is: it doesn't allow
anything that the normal aarch32/armv7 emulation doesn't
already provide.

        Arnd
