From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [RFC PATCH v6 00/11] Control-flow Enforcement: Branch Tracking, PTRACE
Date: Mon, 19 Nov 2018 13:49:23 -0800
Message-ID: <20181119214934.6174-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

The previous version of CET Branch Tracking/PTRACE patches is at the following
link:

  https://lkml.org/lkml/2018/10/11/662

Summary of changes from v5:

  Remove the legacy code bitmap allocation from kernel.  Now GLIBC
  allocates the bitmap and passes it to the kernel.

  Some small fixes.

H.J. Lu (3):
  x86: Insert endbr32/endbr64 to vDSO
  x86/vsyscall/32: Add ENDBR32 to vsyscall entry point
  x86/vsyscall/64: Add ENDBR64 to vsyscall entry points

Yu-cheng Yu (8):
  x86/cet/ibt: Add Kconfig option for user-mode Indirect Branch Tracking
  x86/cet/ibt: User-mode indirect branch tracking support
  x86/cet/ibt: Add IBT legacy code bitmap setup function
  mm/mmap: Add IBT bitmap size to address space limit check
  x86/cet/ibt: ELF header parsing for IBT
  x86/cet/ibt: Add arch_prctl functions for IBT
  x86/cet/ibt: Add ENDBR to op-code-map
  x86/cet: Add PTRACE interface for CET

 arch/x86/Kconfig                              | 16 ++++++
 arch/x86/Makefile                             |  7 +++
 arch/x86/entry/vdso/.gitignore                |  4 ++
 arch/x86/entry/vdso/Makefile                  | 12 ++++-
 arch/x86/entry/vdso/vdso-layout.lds.S         |  1 +
 arch/x86/entry/vdso/vdso32/system_call.S      |  3 ++
 arch/x86/entry/vsyscall/vsyscall_emu_64.S     |  9 ++++
 arch/x86/include/asm/cet.h                    |  8 +++
 arch/x86/include/asm/disabled-features.h      |  8 ++-
 arch/x86/include/asm/fpu/regset.h             |  7 +--
 arch/x86/include/asm/mmu_context.h            | 10 ++++
 arch/x86/include/uapi/asm/elf_property.h      |  1 +
 arch/x86/include/uapi/asm/prctl.h             |  2 +
 arch/x86/kernel/cet.c                         | 54 +++++++++++++++++++
 arch/x86/kernel/cet_prctl.c                   | 21 ++++++++
 arch/x86/kernel/cpu/common.c                  | 17 ++++++
 arch/x86/kernel/elf.c                         |  5 ++
 arch/x86/kernel/fpu/regset.c                  | 41 ++++++++++++++
 arch/x86/kernel/process.c                     |  1 +
 arch/x86/kernel/ptrace.c                      | 16 ++++++
 arch/x86/lib/x86-opcode-map.txt               | 13 ++++-
 include/uapi/linux/elf.h                      |  1 +
 mm/mmap.c                                     | 19 ++++++-
 .../arch/x86/include/asm/disabled-features.h  |  8 ++-
 tools/objtool/arch/x86/lib/x86-opcode-map.txt | 13 ++++-
 25 files changed, 286 insertions(+), 11 deletions(-)

-- 
2.17.1
