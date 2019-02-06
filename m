From: Dmitry Safonov <dima@arista.com>
Subject: [PATCH 14/32] x86/VDSO: Build VDSO with -ffunction-sections
Date: Wed,  6 Feb 2019 00:10:48 +0000
Message-ID: <20190206001107.16488-15-dima@arista.com>
References: <20190206001107.16488-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206001107.16488-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andrei Vagin <avagin@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

As it has been discussed on timens RFC, adding a new conditional branch
`if (inside_time_ns)` on VDSO for all processes is undesirable.
It will add a penalty for everybody as branch predictor may mispredict
the jump. Also there are instruction cache lines wasted on cmp/jmp.

Those effects of introducing time namespace are very much unwanted
having in mind how much work have been spent on micro-optimisation
vdso code.

Addressing those problems, there are two versions of VDSO's .so:
for host tasks (without any penalty) and for processes inside of time
namespace with clk_to_ns() that subtracts offsets from host's time.

Unfortunately, to allow changing VDSO VMA on a running process,
the entry points to VDSO should have the same offsets (addresses).
That's needed as i.e. application that calls setns() may have already
resolved VDSO symbols in GOT/PLT.

Compile VDSO images with -ffunction-sections so that VDSO entries can be
aligned on the same addresses with linker script magic.
Put ia32 functions those are written in assembly into corresponding
sections.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/Makefile             | 2 +-
 arch/x86/entry/vdso/vdso32/sigreturn.S   | 2 ++
 arch/x86/entry/vdso/vdso32/system_call.S | 2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 2433ed9342fd..55ba81d4415c 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -3,7 +3,7 @@
 # Building vDSO images for x86.
 #
 
-KBUILD_CFLAGS += $(DISABLE_LTO)
+KBUILD_CFLAGS += $(DISABLE_LTO) -ffunction-sections
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
diff --git a/arch/x86/entry/vdso/vdso32/sigreturn.S b/arch/x86/entry/vdso/vdso32/sigreturn.S
index c3233ee98a6b..b641ccf8d664 100644
--- a/arch/x86/entry/vdso/vdso32/sigreturn.S
+++ b/arch/x86/entry/vdso/vdso32/sigreturn.S
@@ -11,6 +11,7 @@
 	.globl __kernel_sigreturn
 	.type __kernel_sigreturn,@function
 	nop /* this guy is needed for .LSTARTFDEDLSI1 below (watch for HACK) */
+	.section .text.__kernel_sigreturn, "ax"
 	ALIGN
 __kernel_sigreturn:
 .LSTART_sigreturn:
@@ -21,6 +22,7 @@ __kernel_sigreturn:
 	nop
 	.size __kernel_sigreturn,.-.LSTART_sigreturn
 
+	.section .text.__kernel_rt_sigreturn, "ax"
 	.globl __kernel_rt_sigreturn
 	.type __kernel_rt_sigreturn,@function
 	ALIGN
diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vdso/vdso32/system_call.S
index 263d7433dea8..13ec05287f63 100644
--- a/arch/x86/entry/vdso/vdso32/system_call.S
+++ b/arch/x86/entry/vdso/vdso32/system_call.S
@@ -8,7 +8,7 @@
 #include <asm/cpufeatures.h>
 #include <asm/alternative-asm.h>
 
-	.text
+	.section .text.__kernel_vsyscall, "ax"
 	.globl __kernel_vsyscall
 	.type __kernel_vsyscall,@function
 	ALIGN
-- 
2.20.1
