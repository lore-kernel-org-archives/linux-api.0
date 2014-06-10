From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 9/9] MIPS: add seccomp syscall
Date: Tue, 10 Jun 2014 16:01:54 -0700
Message-ID: <1402441314-7447-10-git-send-email-keescook@chromium.org>
References: <1402441314-7447-1-git-send-email-keescook@chromium.org>
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <1402441314-7447-1-git-send-email-keescook@chromium.org>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Alexei Starovoitov <ast@plumgrid.com>, John Johansen <john.johansen@canonical.com>, Russell King <linux@arm.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Frederic Weisbecker <fweisbec@gmail.com>, "David A. Long" <dave.long@lina>
List-Id: linux-api@vger.kernel.org

Wires up the new seccomp syscall.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/mips/include/uapi/asm/unistd.h |   15 +++++++++------
 arch/mips/kernel/scall32-o32.S      |    1 +
 arch/mips/kernel/scall64-64.S       |    1 +
 arch/mips/kernel/scall64-n32.S      |    1 +
 arch/mips/kernel/scall64-o32.S      |    1 +
 5 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/mips/include/uapi/asm/unistd.h b/arch/mips/include/uapi/asm/unistd.h
index 5805414777e0..9bc13eaf9d67 100644
--- a/arch/mips/include/uapi/asm/unistd.h
+++ b/arch/mips/include/uapi/asm/unistd.h
@@ -372,16 +372,17 @@
 #define __NR_sched_setattr		(__NR_Linux + 349)
 #define __NR_sched_getattr		(__NR_Linux + 350)
 #define __NR_renameat2			(__NR_Linux + 351)
+#define __NR_seccomp			(__NR_Linux + 352)
 
 /*
  * Offset of the last Linux o32 flavoured syscall
  */
-#define __NR_Linux_syscalls		351
+#define __NR_Linux_syscalls		352
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
 
 #define __NR_O32_Linux			4000
-#define __NR_O32_Linux_syscalls		351
+#define __NR_O32_Linux_syscalls		352
 
 #if _MIPS_SIM == _MIPS_SIM_ABI64
 
@@ -701,16 +702,17 @@
 #define __NR_sched_setattr		(__NR_Linux + 309)
 #define __NR_sched_getattr		(__NR_Linux + 310)
 #define __NR_renameat2			(__NR_Linux + 311)
+#define __NR_seccomp			(__NR_Linux + 312)
 
 /*
  * Offset of the last Linux 64-bit flavoured syscall
  */
-#define __NR_Linux_syscalls		311
+#define __NR_Linux_syscalls		312
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */
 
 #define __NR_64_Linux			5000
-#define __NR_64_Linux_syscalls		311
+#define __NR_64_Linux_syscalls		312
 
 #if _MIPS_SIM == _MIPS_SIM_NABI32
 
@@ -1034,15 +1036,16 @@
 #define __NR_sched_setattr		(__NR_Linux + 313)
 #define __NR_sched_getattr		(__NR_Linux + 314)
 #define __NR_renameat2			(__NR_Linux + 315)
+#define __NR_seccomp			(__NR_Linux + 316)
 
 /*
  * Offset of the last N32 flavoured syscall
  */
-#define __NR_Linux_syscalls		315
+#define __NR_Linux_syscalls		316
 
 #endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
 
 #define __NR_N32_Linux			6000
-#define __NR_N32_Linux_syscalls		315
+#define __NR_N32_Linux_syscalls		316
 
 #endif /* _UAPI_ASM_UNISTD_H */
diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
index 3245474f19d5..ab02d14f1b5c 100644
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -578,3 +578,4 @@ EXPORT(sys_call_table)
 	PTR	sys_sched_setattr
 	PTR	sys_sched_getattr		/* 4350 */
 	PTR	sys_renameat2
+	PTR	sys_seccomp
diff --git a/arch/mips/kernel/scall64-64.S b/arch/mips/kernel/scall64-64.S
index be2fedd4ae33..010dccf128ec 100644
--- a/arch/mips/kernel/scall64-64.S
+++ b/arch/mips/kernel/scall64-64.S
@@ -431,4 +431,5 @@ EXPORT(sys_call_table)
 	PTR	sys_sched_setattr
 	PTR	sys_sched_getattr		/* 5310 */
 	PTR	sys_renameat2
+	PTR	sys_seccomp
 	.size	sys_call_table,.-sys_call_table
diff --git a/arch/mips/kernel/scall64-n32.S b/arch/mips/kernel/scall64-n32.S
index c1dbcda4b816..c3b3b6525df5 100644
--- a/arch/mips/kernel/scall64-n32.S
+++ b/arch/mips/kernel/scall64-n32.S
@@ -424,4 +424,5 @@ EXPORT(sysn32_call_table)
 	PTR	sys_sched_setattr
 	PTR	sys_sched_getattr
 	PTR	sys_renameat2			/* 6315 */
+	PTR	sys_seccomp
 	.size	sysn32_call_table,.-sysn32_call_table
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index f1343ccd7ed7..bb1550b1f501 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -557,4 +557,5 @@ EXPORT(sys32_call_table)
 	PTR	sys_sched_setattr
 	PTR	sys_sched_getattr		/* 4350 */
 	PTR	sys_renameat2
+	PTR	sys_seccomp
 	.size	sys32_call_table,.-sys32_call_table
-- 
1.7.9.5
