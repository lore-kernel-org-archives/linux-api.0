From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH v2 4/9] parisc: allocate sys_membarrier system call number
Date: Mon,  7 Sep 2015 12:15:51 -0400
Message-ID: <1441642556-30972-5-git-send-email-mathieu.desnoyers@efficios.com>
References: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-parisc-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, linux-parisc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Tested-by: Helge Deller <deller@gmx.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-api@vger.kernel.org
CC: "James E.J. Bottomley" <jejb@parisc-linux.org>
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
index 8eefb12..4e77991 100644
--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -438,6 +438,7 @@
 	ENTRY_SAME(memfd_create)	/* 340 */
 	ENTRY_SAME(bpf)
 	ENTRY_COMP(execveat)
+	ENTRY_SAME(membarrier)
 
 
 .ifne (. - 90b) - (__NR_Linux_syscalls * (91b - 90b))
-- 
1.9.1

