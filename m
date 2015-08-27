From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH 0/9] allocate sys_membarrier system call number on major archs
Date: Thu, 27 Aug 2015 13:56:46 -0400
Message-ID: <1440698215-8355-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

Wire up the sys_membarrier system call on all major architectures.
This would need testing from architecture maintainers and/or
enthusiasts. Posting as RFC for now. Could be picked into Andrew's
tree once we get the Tested-by tags.

Thanks,

Mathieu

Mathieu Desnoyers (9):
  powerpc: allocate sys_membarrier system call number
  arm: allocate sys_membarrier system call number
  arm64: allocate sys_membarrier system call number
  mips: allocate sys_membarrier system call number
  s390/s390x: allocate sys_membarrier system call number
  sparc/sparc64: allocate sys_membarrier system call number
  alpha: allocate sys_membarrier system call number
  ia64: allocate sys_membarrier system call number
  parisc: allocate sys_membarrier system call number

 arch/alpha/include/uapi/asm/unistd.h   |  1 +
 arch/alpha/kernel/systbls.S            |  1 +
 arch/arm/include/asm/unistd.h          |  2 +-
 arch/arm/include/uapi/asm/unistd.h     |  1 +
 arch/arm/kernel/calls.S                |  1 +
 arch/arm64/include/asm/unistd32.h      |  2 ++
 arch/ia64/include/asm/unistd.h         |  2 +-
 arch/ia64/include/uapi/asm/unistd.h    |  1 +
 arch/ia64/kernel/entry.S               |  1 +
 arch/mips/include/uapi/asm/unistd.h    | 15 +++++++++------
 arch/mips/kernel/scall32-o32.S         |  1 +
 arch/mips/kernel/scall64-64.S          |  1 +
 arch/mips/kernel/scall64-n32.S         |  1 +
 arch/mips/kernel/scall64-o32.S         |  1 +
 arch/parisc/include/uapi/asm/unistd.h  |  3 ++-
 arch/parisc/kernel/syscall_table.S     |  1 +
 arch/powerpc/include/asm/systbl.h      |  1 +
 arch/powerpc/include/asm/unistd.h      |  2 +-
 arch/powerpc/include/uapi/asm/unistd.h |  1 +
 arch/s390/include/uapi/asm/unistd.h    |  3 ++-
 arch/s390/kernel/syscalls.S            |  1 +
 arch/sparc/include/uapi/asm/unistd.h   |  3 ++-
 arch/sparc/kernel/systbls_32.S         |  2 +-
 arch/sparc/kernel/systbls_64.S         |  4 ++--
 24 files changed, 37 insertions(+), 15 deletions(-)

-- 
1.9.1
