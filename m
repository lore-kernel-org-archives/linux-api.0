From: Yu-cheng Yu <yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v9 0/7] Control-flow Enforcement: Indirect Branch Tracking
Date: Wed,  5 Feb 2020 10:23:01 -0800
Message-ID: <20200205182308.4028-1-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H.J. Lu" <hjl.tools-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Nadav Amit <nadav.amit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yu-cheng Yu <yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Control-flow Enforcement (CET) is a new Intel processor feature that blocks
return/jump-oriented programming attacks.  Details can be found in "Intel
64 and IA-32 Architectures Software Developer's Manual" [1].

This is the second half of CET and enables Indirect Branch Tracking (IBT).

Changes from v8:

- Remove a patch that adds the legacy bitmap size to memory accounting,
  since the bitmap is now dynamically allocated.
- Change the legacy bitmap from a pre-defined address to
  get_unmapped_area().
- Fix mis-handling of WAIT_ENDBR in signals
- Split out PTRACE, VDSO, opcode map, and Makefile changes and submit
  separately.

[1] Intel 64 and IA-32 Architectures Software Developer's Manual:

    https://software.intel.com/en-us/download/intel-64-and-ia-32-
    architectures-sdm-combined-volumes-1-2a-2b-2c-2d-3a-3b-3c-3d-and-4

[2] CET patches v8:

    https://lkml.kernel.org/r/20190813205225.12032-1-yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
    https://lkml.kernel.org/r/20190813205359.12196-1-yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/

H.J. Lu (1):
  x86/cet/ibt: Add arch_prctl functions for Indirect Branch Tracking

Yu-cheng Yu (6):
  x86/cet/ibt: Add Kconfig option for user-mode Indirect Branch Tracking
  x86/cet/ibt: User-mode Indirect Branch Tracking support
  x86/cet/ibt: Handle signals for Indirect Branch Tracking
  x86/cet/ibt: ELF header parsing for Indirect Branch Tracking
  mm: Update alloc_set_pte() for zero page
  x86/cet/ibt: Introduce arch_prctl(ARCH_X86_CET_MARK_LEGACY_CODE)

 arch/x86/Kconfig                              |  17 ++
 arch/x86/Makefile                             |   7 +
 arch/x86/include/asm/cet.h                    |   7 +
 arch/x86/include/asm/disabled-features.h      |   8 +-
 arch/x86/include/uapi/asm/prctl.h             |   3 +
 arch/x86/kernel/Makefile                      |   2 +-
 arch/x86/kernel/cet.c                         |  58 ++++-
 arch/x86/kernel/cet_bitmap.c                  | 226 ++++++++++++++++++
 arch/x86/kernel/cet_prctl.c                   |  19 ++
 arch/x86/kernel/cpu/common.c                  |  17 ++
 arch/x86/kernel/fpu/signal.c                  |   8 +-
 arch/x86/kernel/process_64.c                  |   5 +
 mm/memory.c                                   |   8 +
 .../arch/x86/include/asm/disabled-features.h  |   8 +-
 14 files changed, 385 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/kernel/cet_bitmap.c

-- 
2.21.0
