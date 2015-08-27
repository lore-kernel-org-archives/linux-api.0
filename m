From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH 9/9] parisc: allocate sys_membarrier system call number
Date: Thu, 27 Aug 2015 13:56:55 -0400
Message-ID: <1440698215-8355-10-git-send-email-mathieu.desnoyers@efficios.com>
References: <1440698215-8355-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <1440698215-8355-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-parisc-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

[ Untested on this architecture. To try it out: fetch linux-next/akpm,
  apply this patch, build/run a membarrier-enabled kernel, and do make
  kselftest. ]

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-api@vger.kernel.org
CC: "James E.J. Bottomley" <jejb@parisc-linux.org>
CC: Helge Deller <deller@gmx.de>
CC: linux-parisc@vger.kernel.org
---
 arch/parisc/include/uapi/asm/unistd.h | 3 ++-
 arch/parisc/kernel/syscall_table.S    | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/parisc/include/uapi/asm/unistd.h b/arch/parisc/include/uapi/asm/unistd.h
index 2e639d7..dadcada 100644
--- a/arch/parisc/include/uapi/asm/unistd.h
+++ b/arch/parisc/include/uapi/asm/unistd.h
@@ -358,8 +358,9 @@
 #define __NR_memfd_create	(__NR_Linux + 340)
 #define __NR_bpf		(__NR_Linux + 341)
 #define __NR_execveat		(__NR_Linux + 342)
+#define __NR_membarrier		(__NR_Linux + 343)
 
-#define __NR_Linux_syscalls	(__NR_execveat + 1)
+#define __NR_Linux_syscalls	(__NR_membarrier + 1)
 
 
 #define __IGNORE_select		/* newselect */
diff --git a/arch/parisc/kernel/syscall_table.S b/arch/parisc/kernel/syscall_table.S
index 8eefb12..2faa43b 100644
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -438,6 +438,7 @@
 	ENTRY_SAME(memfd_create)	/* 340 */
 	ENTRY_SAME(bpf)
 	ENTRY_COMP(execveat)
+	ENTRY_COMP(membarrier)
 
 
 .ifne (. - 90b) - (__NR_Linux_syscalls * (91b - 90b))
-- 
1.9.1

