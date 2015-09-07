From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH v2 9/9] s390/s390x: allocate sys_membarrier system call number
Date: Mon,  7 Sep 2015 12:15:56 -0400
Message-ID: <1441642556-30972-10-git-send-email-mathieu.desnoyers@efficios.com>
References: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441642556-30972-1-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

[ Untested on this architecture. To try it out: fetch linux-next/akpm,
  apply this patch, build/run a membarrier-enabled kernel, and do make
  kselftest. ]

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
CC: Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
CC: linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 arch/s390/include/uapi/asm/unistd.h | 3 ++-
 arch/s390/kernel/syscalls.S         | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/uapi/asm/unistd.h b/arch/s390/include/uapi/asm/unistd.h
index 59d2bb4..2f1de70 100644
--- a/arch/s390/include/uapi/asm/unistd.h
+++ b/arch/s390/include/uapi/asm/unistd.h
@@ -290,7 +290,8 @@
 #define __NR_s390_pci_mmio_write	352
 #define __NR_s390_pci_mmio_read		353
 #define __NR_execveat		354
-#define NR_syscalls 355
+#define __NR_membarrier		355
+#define NR_syscalls 356
 
 /* 
  * There are some system calls that are not present on 64 bit, some
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index f3f4a13..914c098 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -363,3 +363,4 @@ SYSCALL(sys_bpf,compat_sys_bpf)
 SYSCALL(sys_s390_pci_mmio_write,compat_sys_s390_pci_mmio_write)
 SYSCALL(sys_s390_pci_mmio_read,compat_sys_s390_pci_mmio_read)
 SYSCALL(sys_execveat,compat_sys_execveat)
+SYSCALL(sys_membarrier,sys_membarrier)
-- 
1.9.1
