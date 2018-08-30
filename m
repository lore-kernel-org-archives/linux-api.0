From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [RFC PATCH v3 0/8] Control Flow Enforcement: Branch Tracking, PTRACE
Date: Thu, 30 Aug 2018 07:40:01 -0700
Message-ID: <20180830144009.3314-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

This set includes CET Indirect Branch Tracking patches and a PTRACE patch.

Summary of changes from v2:

  Allocate IBT bitmap at the start of a task.

H.J. Lu (1):
  x86: Insert endbr32/endbr64 to vDSO

Yu-cheng Yu (7):
  x86/cet/ibt: Add Kconfig option for user-mode Indirect Branch Tracking
  x86/cet/ibt: User-mode indirect branch tracking support
  x86/cet/ibt: ELF header parsing for IBT
  x86/cet/ibt: Add arch_prctl functions for IBT
  x86/cet/ibt: Add ENDBR to op-code-map
  mm/mmap: Add IBT bitmap size to address space limit check
  x86/cet: Add PTRACE interface for CET

 arch/x86/Kconfig                              | 12 +++
 arch/x86/Makefile                             |  7 ++
 arch/x86/entry/vdso/.gitignore                |  4 +
 arch/x86/entry/vdso/Makefile                  | 12 ++-
 arch/x86/entry/vdso/vdso-layout.lds.S         |  1 +
 arch/x86/include/asm/cet.h                    |  8 ++
 arch/x86/include/asm/disabled-features.h      |  8 +-
 arch/x86/include/asm/fpu/regset.h             |  7 +-
 arch/x86/include/uapi/asm/elf_property.h      |  1 +
 arch/x86/include/uapi/asm/prctl.h             |  1 +
 arch/x86/include/uapi/asm/resource.h          |  5 ++
 arch/x86/kernel/cet.c                         | 74 +++++++++++++++++++
 arch/x86/kernel/cet_prctl.c                   | 38 +++++++++-
 arch/x86/kernel/cpu/common.c                  | 20 ++++-
 arch/x86/kernel/elf.c                         |  8 +-
 arch/x86/kernel/fpu/regset.c                  | 41 ++++++++++
 arch/x86/kernel/process.c                     |  2 +
 arch/x86/kernel/ptrace.c                      | 16 ++++
 arch/x86/lib/x86-opcode-map.txt               | 13 +++-
 include/uapi/asm-generic/resource.h           |  3 +
 include/uapi/linux/elf.h                      |  1 +
 mm/mmap.c                                     | 12 ++-
 tools/objtool/arch/x86/lib/x86-opcode-map.txt | 13 +++-
 23 files changed, 294 insertions(+), 13 deletions(-)

-- 
2.17.1
