From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v9 00/24] ILP32 for ARM64
Date: Sat, 13 Oct 2018 12:36:21 -0700
Message-ID: <CALCETrVuabkb5ZQOSgQQTEq8CrS602NBpAkE2=4n982r1f5reQ@mail.gmail.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ynorov@caviumnetworks.com
Cc: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, klimov.linux@gmail.com, schwab@suse.de, Andrew Pinski <pinskia@gmail.com>, bamv2005@gmail.com, Chris Metcalf <cmetcalf@mellanox.com>, christoph.muellner@theobroma-systems.com, Dave Martin <Dave.Martin@arm.com>, "David S. Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>Ja
List-Id: linux-api@vger.kernel.org

On Wed, May 16, 2018 at 1:19 AM Yury Norov <ynorov@caviumnetworks.com> wrote:
>
> This series enables AARCH64 with ILP32 mode.
>
> As supporting work, it introduces ARCH_32BIT_OFF_T configuration
> option that is enabled for existing 32-bit architectures but disabled
> for new arches (so 64-bit off_t userspace type is used by new userspace).
> Also it deprecates getrlimit and setrlimit syscalls prior to prlimit64.

A few thoughts:

1. I've never been able to shake the feeling that x32 should not need
kernel support at all.  As far as I can tell, the kernel support is an
enormous amount of code and complexity to deal with exactly two
issues.  First, ILP32 only has 32-bit pointers, so there needs to be a
way to tell the kernel to only use the lower 4 GB of user address
space.  That part is easy.  Second, ILP32 user code is highly unlikely
to end up with the same struct layout as ILP64 code.  The latter seems
like it should be solved entirely in userspace by adding a way to
annotate a structure as being a kernel ABI structure and getting the
toolchain to lay it out as if it were ILP64 even though the target is
ILP32.

2. I think you should make a conscious decision as to whether the
ILP32-ness of a syscall is a property of the task or of the syscall.
On x86, x32-ness is a property of the syscall, but historically it
also got rather entangled with the state of the task, and the result
was a mess.  It looks like you're making it be a property of the task,
which is fine, but you're making it impossible for very clever ILP32
libraries to include little ILP64 stubs that do fancy things with full
64-bit syscalls.

3. Make very certain that you aren't exploitable by malicious
processes that set the high bits in ILP32 syscall args.  x86 compat
has issues like that in the past.
