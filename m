From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH 3/9] arm64: allocate sys_membarrier system call number
Date: Thu, 27 Aug 2015 13:56:49 -0400
Message-ID: <1440698215-8355-4-git-send-email-mathieu.desnoyers@efficios.com>
References: <1440698215-8355-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440698215-8355-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

arm64 sys_membarrier number is already wired for arm64 through
asm-generic/unistd.h, but needs to be allocated separately for
the 32-bit compability layer of arm64.

[ Untested on this architecture. To try it out: fetch linux-next/akpm,
  apply this patch, build/run a membarrier-enabled kernel, and do make
  kselftest. ]

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-api@vger.kernel.org
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/unistd32.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index cef934a..d97be80 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -797,3 +797,5 @@ __SYSCALL(__NR_memfd_create, sys_memfd_create)
 __SYSCALL(__NR_bpf, sys_bpf)
 #define __NR_execveat 387
 __SYSCALL(__NR_execveat, compat_sys_execveat)
+#define __NR_membarrier 388
+__SYSCALL(__NR_membarrier, sys_membarrier)
-- 
1.9.1
