From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.15 07/24] Restartable sequences: Wire up powerpc
 system call
Date: Tue, 14 Nov 2017 15:03:57 -0500
Message-ID: <20171114200414.2188-8-mathieu.desnoyers@efficios.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: Will Deacon <will.deacon@arm.com>, Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>, "H . Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Russell King <linux@arm.linux.org.uk>, Andrew Hunter <ahh@google.com>, Ingo Molnar <mingo@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Paul Turner <pjt@google.com>, Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, Ben Maurer <bmaurer@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com>

Wire up the rseq system call on powerpc.

This provides an ABI improving the speed of a user-space getcpu
operation on powerpc by skipping the getcpu system call on the fast
path, as well as improving the speed of user-space operations on per-cpu
data compared to using load-reservation/store-conditional atomics.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Michael Ellerman <mpe@ellerman.id.au>
CC: Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/include/asm/systbl.h      | 1 +
 arch/powerpc/include/asm/unistd.h      | 2 +-
 arch/powerpc/include/uapi/asm/unistd.h | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index 449912f057f6..964321a5799c 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -389,3 +389,4 @@ COMPAT_SYS_SPU(preadv2)
 COMPAT_SYS_SPU(pwritev2)
 SYSCALL(kexec_file_load)
 SYSCALL(statx)
+SYSCALL(rseq)
diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
index 9ba11dbcaca9..e76bd5601ea4 100644
--- a/arch/powerpc/include/asm/unistd.h
+++ b/arch/powerpc/include/asm/unistd.h
@@ -12,7 +12,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define NR_syscalls		384
+#define NR_syscalls		385
 
 #define __NR__exit __NR_exit
 
diff --git a/arch/powerpc/include/uapi/asm/unistd.h b/arch/powerpc/include/uapi/asm/unistd.h
index df8684f31919..b1980fcd56d5 100644
--- a/arch/powerpc/include/uapi/asm/unistd.h
+++ b/arch/powerpc/include/uapi/asm/unistd.h
@@ -395,5 +395,6 @@
 #define __NR_pwritev2		381
 #define __NR_kexec_file_load	382
 #define __NR_statx		383
+#define __NR_rseq		384
 
 #endif /* _UAPI_ASM_POWERPC_UNISTD_H_ */
-- 
2.11.0
