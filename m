From: Boqun Feng <boqun.feng@gmail.com>
Subject: [RFC 3/4] Restartable sequences: Wire up powerpc system call
Date: Wed, 27 Jul 2016 23:05:16 +0800
Message-ID: <20160727150517.26983-3-boqun.feng@gmail.com>
References: <20160727150352.GA32142@tardis.cn.ibm.com>
 <20160727150517.26983-1-boqun.feng@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160727150517.26983-1-boqun.feng@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

Wire up the rseq system call on powerpc.

This provides an ABI improving the speed of a user-space getcpu
operation on powerpc by skipping the getcpu system call on the fast
path, as well as improving the speed of user-space operations on per-cpu
data compared to using load-reservation/store-conditional atomics.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 arch/powerpc/include/asm/systbl.h      | 1 +
 arch/powerpc/include/asm/unistd.h      | 2 +-
 arch/powerpc/include/uapi/asm/unistd.h | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 2fc5d4db503c..c68f4d0d00b2 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -386,3 +386,4 @@ SYSCALL(mlock2)
 SYSCALL(copy_file_range)
 COMPAT_SYS_SPU(preadv2)
 COMPAT_SYS_SPU(pwritev2)
+SYSCALL(rseq)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index cf12c580f6b2..a01e97d3f305 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -12,7 +12,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define NR_syscalls		382
+#define NR_syscalls		383
 
 #define __NR__exit __NR_exit
 
diff --git a/arch/powerpc/include/uapi/asm/unistd.h b/arch/powerpc/include/uapi/asm/unistd.h
index e9f5f41aa55a..d1849d64c8ef 100644
--- a/arch/powerpc/include/uapi/asm/unistd.h
+++ b/arch/powerpc/include/uapi/asm/unistd.h
@@ -392,5 +392,6 @@
 #define __NR_copy_file_range	379
 #define __NR_preadv2		380
 #define __NR_pwritev2		381
+#define __NR_rseq		382
 
 #endif /* _UAPI_ASM_POWERPC_UNISTD_H_ */
-- 
2.9.0
