From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [RFC PATCH v9 00/27] Control-flow Enforcement: Shadow Stack
Date: Wed,  5 Feb 2020 10:19:08 -0800
Message-ID: <20200205181935.3712-1-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

Control-flow Enforcement (CET) is a new Intel processor feature that blocks
return/jump-oriented programming attacks.  Details can be found in "Intel
64 and IA-32 Architectures Software Developer's Manual" [1].

This series depends on the XSAVES supervisor state series that was split
out and submitted earlier [2].

Changes from v8:

- Simplify signal handling code.
- Add guard pages around a Shadow Stack.
- Replace ELF parser with Dave Martin's patch [3].

The goal of this posting is to seek additional comments.

[1] Intel 64 and IA-32 Architectures Software Developer's Manual:

    https://software.intel.com/en-us/download/intel-64-and-ia-32-
    architectures-sdm-combined-volumes-1-2a-2b-2c-2d-3a-3b-3c-3d-and-4

[2] XSAVES supervisor states patches:
    https://lkml.kernel.org/r/20200121201843.12047-1-yu-cheng.yu@intel.com/

[3] Dave Martin's ELF program property parsing patch:
    https://lkml.kernel.org/r/20200122212144.6409-3-broonie@kernel.org/

[4] CET patches v8:

    https://lkml.kernel.org/r/20190813205225.12032-1-yu-cheng.yu@intel.com/
    https://lkml.kernel.org/r/20190813205359.12196-1-yu-cheng.yu@intel.com/

Dave Martin (1):
  ELF: Add ELF program property parsing support

Yu-cheng Yu (26):
  Documentation/x86: Add CET description
  x86/cpufeatures: Add CET CPU feature flags for Control-flow
    Enforcement Technology (CET)
  x86/fpu/xstate: Introduce CET MSR XSAVES supervisor states
  x86/cet: Add control-protection fault handler
  x86/cet/shstk: Add Kconfig option for user-mode Shadow Stack
    protection
  mm: Introduce VM_SHSTK for Shadow Stack memory
  Add guard pages around a Shadow Stack.
  x86/mm: Change _PAGE_DIRTY to _PAGE_DIRTY_HW
  x86/mm: Introduce _PAGE_DIRTY_SW
  x86/mm: Update pte_modify, pmd_modify, and _PAGE_CHG_MASK for
    _PAGE_DIRTY_SW
  drm/i915/gvt: Change _PAGE_DIRTY to _PAGE_DIRTY_BITS
  x86/mm: Modify ptep_set_wrprotect and pmdp_set_wrprotect for
    _PAGE_DIRTY_SW
  x86/mm: Shadow Stack page fault error checking
  mm: Handle Shadow Stack page fault
  mm: Handle THP/HugeTLB Shadow Stack page fault
  mm: Update can_follow_write_pte() for Shadow Stack
  x86/cet/shstk: User-mode Shadow Stack support
  x86/cet/shstk: Introduce WRUSS instruction
  x86/cet/shstk: Handle signals for Shadow Stack
  ELF: UAPI and Kconfig additions for ELF program properties
  binfmt_elf: Define GNU_PROPERTY_X86_FEATURE_1_AND
  ELF: Introduce arch_setup_elf_property()
  x86/cet/shstk: ELF header parsing for Shadow Stack
  x86/cet/shstk: Handle thread Shadow Stack
  mm/mmap: Add Shadow Stack pages to memory accounting
  x86/cet/shstk: Add arch_prctl functions for Shadow Stack

 .../admin-guide/kernel-parameters.txt         |   6 +
 Documentation/x86/index.rst                   |   1 +
 Documentation/x86/intel_cet.rst               | 294 +++++++++++++++
 arch/x86/Kconfig                              |  24 ++
 arch/x86/Makefile                             |   7 +
 arch/x86/entry/entry_64.S                     |   2 +-
 arch/x86/ia32/ia32_signal.c                   |  17 +
 arch/x86/include/asm/cet.h                    |  44 +++
 arch/x86/include/asm/cpufeatures.h            |   2 +
 arch/x86/include/asm/disabled-features.h      |   8 +-
 arch/x86/include/asm/elf.h                    |  13 +
 arch/x86/include/asm/fpu/internal.h           |   2 +
 arch/x86/include/asm/fpu/types.h              |  22 ++
 arch/x86/include/asm/fpu/xstate.h             |   5 +-
 arch/x86/include/asm/mmu_context.h            |   3 +
 arch/x86/include/asm/msr-index.h              |  18 +
 arch/x86/include/asm/pgtable.h                | 197 +++++++++-
 arch/x86/include/asm/pgtable_types.h          |  50 ++-
 arch/x86/include/asm/processor.h              |   5 +
 arch/x86/include/asm/special_insns.h          |  32 ++
 arch/x86/include/asm/traps.h                  |   5 +
 arch/x86/include/uapi/asm/prctl.h             |   5 +
 arch/x86/include/uapi/asm/processor-flags.h   |   2 +
 arch/x86/include/uapi/asm/sigcontext.h        |   9 +
 arch/x86/kernel/Makefile                      |   2 +
 arch/x86/kernel/cet.c                         | 344 ++++++++++++++++++
 arch/x86/kernel/cet_prctl.c                   |  84 +++++
 arch/x86/kernel/cpu/common.c                  |  25 ++
 arch/x86/kernel/cpu/cpuid-deps.c              |   2 +
 arch/x86/kernel/fpu/signal.c                  |  89 +++++
 arch/x86/kernel/fpu/xstate.c                  |  25 +-
 arch/x86/kernel/idt.c                         |   4 +
 arch/x86/kernel/process.c                     |  12 +-
 arch/x86/kernel/process_64.c                  |  31 ++
 arch/x86/kernel/relocate_kernel_64.S          |   2 +-
 arch/x86/kernel/signal.c                      |  10 +
 arch/x86/kernel/signal_compat.c               |   2 +-
 arch/x86/kernel/traps.c                       |  59 +++
 arch/x86/kvm/vmx/vmx.c                        |   2 +-
 arch/x86/mm/fault.c                           |  18 +
 arch/x86/mm/mmap.c                            |   2 +
 arch/x86/mm/pgtable.c                         |  41 +++
 drivers/gpu/drm/i915/gvt/gtt.c                |   2 +-
 fs/Kconfig.binfmt                             |   3 +
 fs/binfmt_elf.c                               | 131 +++++++
 fs/compat_binfmt_elf.c                        |   4 +
 fs/proc/task_mmu.c                            |   3 +
 include/asm-generic/pgtable.h                 |  40 ++
 include/linux/elf.h                           |  33 ++
 include/linux/mm.h                            |  28 +-
 include/uapi/asm-generic/siginfo.h            |   3 +-
 include/uapi/linux/elf.h                      |  12 +
 mm/gup.c                                      |   8 +-
 mm/huge_memory.c                              |  12 +-
 mm/memory.c                                   |   7 +-
 mm/mmap.c                                     |   5 +
 .../arch/x86/include/asm/disabled-features.h  |   8 +-
 57 files changed, 1779 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/x86/intel_cet.rst
 create mode 100644 arch/x86/include/asm/cet.h
 create mode 100644 arch/x86/kernel/cet.c
 create mode 100644 arch/x86/kernel/cet_prctl.c

-- 
2.21.0
