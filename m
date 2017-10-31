From: Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v5 00/30] ARM Scalable Vector Extension (SVE)
Date: Tue, 31 Oct 2017 15:50:52 +0000
Message-ID: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Szabolcs Nagy <szabolcs.nagy-5wv7dgnIgG8@public.gmane.org>, Okamoto Takayuki <tokamoto-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Hayward <alan.hayward-5wv7dgnIgG8@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "H . J . Lu" <hjl.tools-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This series implements Linux kernel support for the ARM Scalable Vector
Extension (SVE). [1]  It supersedes the previous v3: see [3] for link
and full cover letter.

This is a minor update to v4, but does contain a couple of important
fixes.

As in previous postings, the last two patches (here 29-30) are still
RFC and not proposed for merging at this time.

The patches apply on
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git
for-next/core
d7b1d22d3821 ("arm64: uapi: Remove PSR_Q_BIT")

To reduce spam, some people may not been copied on the entire series.
For those who did not receive the whole series, it can be found in the
linux-arm-kernel archive. [2]

See the individual patches for details of changes.

For reviewer convenience, a git tree is available. [4]

Since there are some changes against already-reviewed patches, I've also
pushed an unsquashed fixes tree for people to take a look at if it
helps. [5]


Summary:

 * "regset: Add support for dynamically sized regsets" fixed to avoid
   x86 breakage;

 * one trival arm64 patch added to add asmlinkage annotations, and a
   corresponding minor change to the Core task context handling patch;

 * one new arm64 fix ("signal: Verify extra data is user-readable in
   sys_rt_sigreturn") to ensure that access_ok() checks are done for the
   whole extended signal frame, not just the base frame;

 * one minor fix to the SVE sigreturn code to return consistent
   intermediate error values (semantic correctness, non-functional
   change);

 * one minor change to call __copy_from_user() instead of
   copy_from_user() in a situation where there is already an access_ok()
   check;


[1] ARM Scalable Vector Extension
https://community.arm.com/groups/processors/blog/2016/08/22/technology-update-the-scalable-vector-extension-sve-for-the-armv8-a-architecture

[2] linux-arm-kernel October 2017 Archives by thread
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-October/thread.html

[3] [PATCH v4 00/28] ARM Scalable Vector Extension (SVE)
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-October/539414.html

[4] For review and testing only -- **do not pull**
    (This branch has review changelogs which should not form part of
    the final commits.)

    v5 series (this posting)

    http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve/v5
    git://linux-arm.org/linux-dm.git sve/v5

[5] For review and testing only -- **do not pull**
    (This branch has review changelogs which should not form part of
    the final commits.)

    v4 with unsquashed fixes

    http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve/v4%2Bfixes
    git://linux-arm.org/linux-dm.git sve/v4+fixes


Dave Martin (30):
  regset: Add support for dynamically sized regsets
  arm64: fpsimd: Correctly annotate exception helpers called from asm
  arm64: signal: Verify extra data is user-readable in sys_rt_sigreturn
  arm64: KVM: Hide unsupported AArch64 CPU features from guests
  arm64: efi: Add missing Kconfig dependency on KERNEL_MODE_NEON
  arm64: Port deprecated instruction emulation to new sysctl interface
  arm64: fpsimd: Simplify uses of {set,clear}_ti_thread_flag()
  arm64/sve: System register and exception syndrome definitions
  arm64/sve: Low-level SVE architectural state manipulation functions
  arm64/sve: Kconfig update and conditional compilation support
  arm64/sve: Signal frame and context structure definition
  arm64/sve: Low-level CPU setup
  arm64/sve: Core task context handling
  arm64/sve: Support vector length resetting for new processes
  arm64/sve: Signal handling support
  arm64/sve: Backend logic for setting the vector length
  arm64: cpufeature: Move sys_caps_initialised declarations
  arm64/sve: Probe SVE capabilities and usable vector lengths
  arm64/sve: Preserve SVE registers around kernel-mode NEON use
  arm64/sve: Preserve SVE registers around EFI runtime service calls
  arm64/sve: ptrace and ELF coredump support
  arm64/sve: Add prctl controls for userspace vector length management
  arm64/sve: Add sysctl to set the default vector length for new
    processes
  arm64/sve: KVM: Prevent guests from using SVE
  arm64/sve: KVM: Treat guest SVE use as undefined instruction execution
  arm64/sve: KVM: Hide SVE from CPU features exposed to guests
  arm64/sve: Detect SVE and activate runtime support
  arm64/sve: Add documentation
  arm64: signal: Report signal frame size to userspace via auxv
  arm64/sve: signal: Include SVE when computing AT_MINSIGSTKSZ

 Documentation/arm64/cpu-feature-registers.txt |   6 +-
 Documentation/arm64/elf_hwcaps.txt            |   4 +
 Documentation/arm64/sve.txt                   | 508 +++++++++++++++
 arch/arm/include/asm/kvm_host.h               |   3 +
 arch/arm64/Kconfig                            |  12 +
 arch/arm64/include/asm/cpu.h                  |   4 +
 arch/arm64/include/asm/cpucaps.h              |   3 +-
 arch/arm64/include/asm/cpufeature.h           |  42 ++
 arch/arm64/include/asm/elf.h                  |   5 +
 arch/arm64/include/asm/esr.h                  |   3 +-
 arch/arm64/include/asm/fpsimd.h               |  71 +-
 arch/arm64/include/asm/fpsimdmacros.h         | 148 +++++
 arch/arm64/include/asm/kvm_arm.h              |   5 +-
 arch/arm64/include/asm/kvm_host.h             |  11 +
 arch/arm64/include/asm/processor.h            |  10 +
 arch/arm64/include/asm/sysreg.h               |  24 +
 arch/arm64/include/asm/thread_info.h          |   5 +
 arch/arm64/include/asm/traps.h                |   2 +
 arch/arm64/include/uapi/asm/auxvec.h          |   3 +-
 arch/arm64/include/uapi/asm/hwcap.h           |   1 +
 arch/arm64/include/uapi/asm/ptrace.h          | 138 ++++
 arch/arm64/include/uapi/asm/sigcontext.h      | 120 +++-
 arch/arm64/kernel/armv8_deprecated.c          |  15 +-
 arch/arm64/kernel/cpufeature.c                |  99 ++-
 arch/arm64/kernel/cpuinfo.c                   |   7 +
 arch/arm64/kernel/entry-fpsimd.S              |  17 +
 arch/arm64/kernel/entry.S                     |  40 +-
 arch/arm64/kernel/fpsimd.c                    | 907 +++++++++++++++++++++++++-
 arch/arm64/kernel/head.S                      |  13 +-
 arch/arm64/kernel/process.c                   |  24 +
 arch/arm64/kernel/ptrace.c                    | 280 +++++++-
 arch/arm64/kernel/signal.c                    | 220 ++++++-
 arch/arm64/kernel/signal32.c                  |   2 +-
 arch/arm64/kernel/traps.c                     |   7 +-
 arch/arm64/kvm/handle_exit.c                  |   8 +
 arch/arm64/kvm/hyp/switch.c                   |  12 +-
 arch/arm64/kvm/sys_regs.c                     | 292 +++++++--
 fs/binfmt_elf.c                               |  10 +-
 include/linux/regset.h                        |  67 +-
 include/uapi/linux/elf.h                      |   1 +
 include/uapi/linux/prctl.h                    |   9 +
 kernel/sys.c                                  |  12 +
 virt/kvm/arm/arm.c                            |   3 +
 43 files changed, 3023 insertions(+), 150 deletions(-)
 create mode 100644 Documentation/arm64/sve.txt

-- 
2.1.4
