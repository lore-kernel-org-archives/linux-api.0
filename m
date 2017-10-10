From: Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v3 00/28] ARM Scalable Vector Extension (SVE)
Date: Tue, 10 Oct 2017 19:38:17 +0100
Message-ID: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Szabolcs Nagy <szabolcs.nagy-5wv7dgnIgG8@public.gmane.org>, Richard Sandiford <richard.sandiford-5wv7dgnIgG8@public.gmane.org>, Okamoto Takayuki <tokamoto-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Hayward <alan.hayward-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This series implements Linux kernel support for the ARM Scalable Vector
Extension (SVE). [1]  It supersedes the previous v2: see [3] for link.
See the individual patches for details of changes.

The patches apply on v4.14-rc4.
For convenience, a git tree is available. [4]


To reduce spam, some people may not been copied on the entire series.
For those who did not receive the whole series, it can be found in the
linux-arm-kernel archive. [2]


*Note* The final two patches (27-28) of the series are still RFC --
before committing to this ABI it would be good to get feedback on
whether the approach makes sense and whether it suitable for other
architectures.  These two patches are not required by the rest of the
series and can be revised or merged later.


Support for use of SVE by KVM guests is not currently included.
Instead, such use will be trapped and reflected to the guest as
undefined instruction execution.  SVE is hidden from the view of the
CPU feature registers visible to guests, so that guests will not
expect it to work.


This series has been build- and boot-tested on the ARM FVP Base model
with and without the SVE plugin.  Because there is no hardware with
SVE support yet, testing of the SVE functionality has only been
performed on the model.

Regression testing of v3 is under way.


Series summary:

 * Patches 1-5 contain some individual bits of preparatory spadework,
   which are indirectly related to SVE.

Dave Martin (5):
  regset: Add support for dynamically sized regsets
  arm64: KVM: Hide unsupported AArch64 CPU features from guests
  arm64: efi: Add missing Kconfig dependency on KERNEL_MODE_NEON
  arm64: Port deprecated instruction emulation to new sysctl interface
  arm64: fpsimd: Simplify uses of {set,clear}_ti_thread_flag()

   Non-trivial changes among these are:

   * Patch 1: updates the regset core code to handle regsets whose size
     is not fixed at compile time.  This avoids bloating coredumps even
     though the maximum theoretical SVE regset size is large.

   * Patch 2: extends KVM to modify the ARM architectural ID registers
     seen by guests, by trapping and emulating certain registers.  For
     SVE this is a temporary measure, but it may be useful for other
     architecture extensions.  This patch may also be built on in the
     future, since the only registers currently emulated are those
     required for hiding SVE.

 * Patches 6-10 add SVE-specific system register and structure layout
   definitions, and the low-level boot code and accessors needed for
   making use of SVE.

Dave Martin (5):
  arm64/sve: System register and exception syndrome definitions
  arm64/sve: Low-level SVE architectural state manipulation functions
  arm64/sve: Kconfig update and conditional compilation support
  arm64/sve: Signal frame and context structure definition
  arm64/sve: Low-level CPU setup

 * Patches 11-13 implement the core context management facilities to
   provide each user task with its own SVE register context, signal
   handling facilities, and sane programmer's model interoperation
   between SVE and FPSIMD.

Dave Martin (3):
  arm64/sve: Core task context handling
  arm64/sve: Support vector length resetting for new processes
  arm64/sve: Signal handling support

 * Patches 14 and 16 provide backend logic for detecting and making use
   of the different SVE vector lengths supported by the hardware.

 * Patch 15 moves around code in cpufeatures.c to fit.

Dave Martin (3):
  arm64/sve: Backend logic for setting the vector length
  arm64: cpufeature: Move sys_caps_initialised declarations
  arm64/sve: Probe SVE capabilities and usable vector lengths

 * Patches 17-18 update the kernel-mode NEON / EFI FPSIMD frameworks to
   interoperate correctly with SVE.

Dave Martin (2):
  arm64/sve: Preserve SVE registers around kernel-mode NEON use
  arm64/sve: Preserve SVE registers around EFI runtime service calls

 * Patches 19-21 implement the userspace frontend for managing SVE,
   comprising ptrace, some new arch-specific prctl() calls, and a new
   sysctl for init-time setup.

Dave Martin (3):
  arm64/sve: ptrace and ELF coredump support
  arm64/sve: Add prctl controls for userspace vector length management
  arm64/sve: Add sysctl to set the default vector length for new
    processes

 * Patches 22-24 provide stub KVM extensions for using KVM only on the
   host, while denying guest access.  (A future series will extend this
   with full support for SVE in guests.)

Dave Martin (3):
  arm64/sve: KVM: Prevent guests from using SVE
  arm64/sve: KVM: Treat guest SVE use as undefined instruction
    execution
  arm64/sve: KVM: Hide SVE from CPU features exposed to guests

And finally:

 * Patch 25 disengages the safety catch, enabling the kernel SVE runtime
   support and allowing userspace to use SVE.

Dave Martin (1):
  arm64/sve: Detect SVE and activate runtime support

 * Patch 26 adds some basic documentation.

Dave Martin (1):
  arm64/sve: Add documentation

 * Patches 27-28 (which may be considered RFC) propose a mechanism to
   report the maximum runtime signal frame size to userspace.

Dave Martin (2):
  arm64: signal: Report signal frame size to userspace via auxv
  arm64/sve: signal: Include SVE when computing AT_MINSIGSTKSZ


References:

[1] ARM Scalable Vector Extension
https://community.arm.com/groups/processors/blog/2016/08/22/technology-update-the-scalable-vector-extension-sve-for-the-armv8-a-architecture

[2] linux-arm-kernel October 2017 Archives by thread
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-October/thread.html

[3] [PATCH v2 00/28] ARM Scalable Vector Extension (SVE)
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-August/529575.html

[4] http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve/v3
    git://linux-arm.org/linux-dm.git sve/v3


Full series and diffstat:

Dave Martin (28):
  regset: Add support for dynamically sized regsets
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
 Documentation/arm64/sve.txt                   | 484 ++++++++++++++
 arch/arm/include/asm/kvm_host.h               |   3 +
 arch/arm64/Kconfig                            |  12 +
 arch/arm64/include/asm/cpu.h                  |   4 +
 arch/arm64/include/asm/cpucaps.h              |   3 +-
 arch/arm64/include/asm/cpufeature.h           |  42 ++
 arch/arm64/include/asm/elf.h                  |   5 +
 arch/arm64/include/asm/esr.h                  |   3 +-
 arch/arm64/include/asm/fpsimd.h               |  73 +-
 arch/arm64/include/asm/fpsimdmacros.h         | 148 ++++
 arch/arm64/include/asm/kvm_arm.h              |   5 +-
 arch/arm64/include/asm/kvm_host.h             |  11 +
 arch/arm64/include/asm/processor.h            |  10 +
 arch/arm64/include/asm/sysreg.h               |  24 +
 arch/arm64/include/asm/thread_info.h          |   2 +
 arch/arm64/include/asm/traps.h                |   2 +
 arch/arm64/include/uapi/asm/auxvec.h          |   3 +-
 arch/arm64/include/uapi/asm/hwcap.h           |   1 +
 arch/arm64/include/uapi/asm/ptrace.h          | 138 ++++
 arch/arm64/include/uapi/asm/sigcontext.h      | 120 +++-
 arch/arm64/kernel/armv8_deprecated.c          |  15 +-
 arch/arm64/kernel/cpufeature.c                |  97 ++-
 arch/arm64/kernel/cpuinfo.c                   |   7 +
 arch/arm64/kernel/entry-fpsimd.S              |  17 +
 arch/arm64/kernel/entry.S                     |  14 +-
 arch/arm64/kernel/fpsimd.c                    | 927 +++++++++++++++++++++++++-
 arch/arm64/kernel/head.S                      |  13 +-
 arch/arm64/kernel/process.c                   |  14 +-
 arch/arm64/kernel/ptrace.c                    | 271 +++++++-
 arch/arm64/kernel/signal.c                    | 222 +++++-
 arch/arm64/kernel/signal32.c                  |   2 +-
 arch/arm64/kernel/traps.c                     |   7 +-
 arch/arm64/kvm/handle_exit.c                  |   8 +
 arch/arm64/kvm/hyp/switch.c                   |  12 +-
 arch/arm64/kvm/sys_regs.c                     | 292 ++++++--
 fs/binfmt_elf.c                               |   6 +-
 include/linux/regset.h                        |  67 +-
 include/uapi/linux/elf.h                      |   1 +
 include/uapi/linux/prctl.h                    |   9 +
 kernel/sys.c                                  |  12 +
 virt/kvm/arm/arm.c                            |   3 +
 42 files changed, 2970 insertions(+), 145 deletions(-)
 create mode 100644 Documentation/arm64/sve.txt

-- 
2.1.4
