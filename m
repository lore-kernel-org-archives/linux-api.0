From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [PATCH v7 00/14] Control-flow Enforcement: Branch Tracking, PTRACE
Date: Thu,  6 Jun 2019 13:09:12 -0700
Message-ID: <20190606200926.4029-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

The previous version of CET Branch Tracking/PTRACE patches is here:

  https://lkml.org/lkml/2018/11/20/203

Summary of changes from v6:

  Rebase to v5.2-rc3.

  Add Branch Tracking in the signal handling routines.

  Fix Branch Tracking (and Shadow Stack) for vsyscall (patch #12):
    This patch can be dropped if we expect CET blocking vsyscall.

  Include H.J. Lu's patch to discard .note.gnu.property in the kernel.

H.J. Lu (4):
  x86/vdso: Insert endbr32/endbr64 to vDSO
  x86/vdso/32: Add ENDBR32 to __kernel_vsyscall entry point
  x86/vsyscall/64: Add ENDBR64 to vsyscall entry points
  x86: Discard .note.gnu.property sections

Yu-cheng Yu (10):
  x86/cet/ibt: Add Kconfig option for user-mode Indirect Branch Tracking
  x86/cet/ibt: User-mode indirect branch tracking support
  x86/cet/ibt: Add IBT legacy code bitmap setup function
  x86/cet/ibt: Handle signals for IBT
  mm/mmap: Add IBT bitmap size to address space limit check
  x86/cet/ibt: ELF header parsing for IBT
  x86/cet/ibt: Add arch_prctl functions for IBT
  x86/cet/ibt: Add ENDBR to op-code-map
  x86/vsyscall/64: Fixup shadow stack and branch tracking for vsyscall
  x86/cet: Add PTRACE interface for CET

 arch/x86/Kconfig                              | 16 ++++
 arch/x86/Makefile                             |  7 ++
 arch/x86/entry/vdso/Makefile                  | 12 ++-
 arch/x86/entry/vdso/vdso-layout.lds.S         |  1 +
 arch/x86/entry/vdso/vdso32/system_call.S      |  3 +
 arch/x86/entry/vsyscall/vsyscall_64.c         | 28 +++++++
 arch/x86/entry/vsyscall/vsyscall_emu_64.S     |  9 +++
 arch/x86/include/asm/cet.h                    |  8 ++
 arch/x86/include/asm/disabled-features.h      |  8 +-
 arch/x86/include/asm/fpu/regset.h             |  7 +-
 arch/x86/include/asm/mmu_context.h            | 10 +++
 arch/x86/include/uapi/asm/prctl.h             |  2 +
 arch/x86/kernel/cet.c                         | 80 +++++++++++++++++++
 arch/x86/kernel/cet_prctl.c                   | 21 +++++
 arch/x86/kernel/cpu/common.c                  | 17 ++++
 arch/x86/kernel/fpu/regset.c                  | 41 ++++++++++
 arch/x86/kernel/process_64.c                  |  6 ++
 arch/x86/kernel/ptrace.c                      | 16 ++++
 arch/x86/kernel/vmlinux.lds.S                 | 11 ++-
 arch/x86/lib/x86-opcode-map.txt               | 13 ++-
 include/uapi/linux/elf.h                      |  1 +
 mm/mmap.c                                     | 19 ++++-
 .../arch/x86/include/asm/disabled-features.h  |  8 +-
 tools/objtool/arch/x86/lib/x86-opcode-map.txt | 13 ++-
 24 files changed, 345 insertions(+), 12 deletions(-)

-- 
2.17.1
