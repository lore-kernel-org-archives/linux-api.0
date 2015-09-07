From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 0/9] Allocate sys_membarrier on main architectures
Date: Mon,  7 Sep 2015 12:15:47 -0400
Message-ID: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Following feedback from architecture maintainers, this is v2 of this
patchset. Status:

* Picked into maintainer's tree:
  - powerpc
* Ready to be picked into maintainer's tree (acked/tested):
  - mips, sparc/sparc64, parisc,
* Awaiting feedback/testing:
  - arm, arm64, ia64, s390/s390x

Thanks,

Mathieu

Mathieu Desnoyers (9):
  [picked] powerpc: allocate sys_membarrier system call number
  mips: allocate sys_membarrier system call number
  sparc/sparc64: allocate sys_membarrier system call number
  parisc: allocate sys_membarrier system call number
  alpha: allocate sys_membarrier system call number
  arm: allocate sys_membarrier system call number
  arm64: allocate sys_membarrier system call number
  ia64: allocate sys_membarrier system call number
  s390/s390x: allocate sys_membarrier system call number

 arch/alpha/include/asm/unistd.h        |  2 +-
 arch/alpha/include/uapi/asm/unistd.h   |  1 +
 arch/alpha/kernel/systbls.S            |  1 +
 arch/arm/include/asm/unistd.h          |  2 +-
 arch/arm/include/uapi/asm/unistd.h     |  1 +
 arch/arm/kernel/calls.S                |  1 +
 arch/arm64/include/asm/unistd.h        |  2 +-
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
 26 files changed, 39 insertions(+), 17 deletions(-)

-- 
1.9.1
