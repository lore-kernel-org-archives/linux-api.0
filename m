From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 8/8] riscv: Use latest system call ABI
Date: Mon, 18 Feb 2019 22:07:12 +0100
Message-ID: <20190218210712.3503891-9-arnd@arndb.de>
References: <20190218210712.3503891-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190218210712.3503891-1-arnd@arndb.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: y2038@lists.linaro.org
Cc: linux-arch@vger.kernel.org, uclinux-h8-devel@lists.sourceforge.jp, arnd@arndb.de, yury.norov@gmail.com, linux-api@vger.kernel.org, Palmer Dabbelt <palmer@sifive.com>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, Vineet Gupta <vgupta@synopsys.com>, Guo Ren <guoren@kernel.org>, Greentime Hu <green.hu@gmail.com>, linux-hexagon@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Guan Xuetao <gxt@pku.edu.cn>, Stafford Horne <shorne@gmail.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

We don't yet have an upstream glibc port for riscv, so there is no user
space for the existing ABI, and we can remove the definitions for 32-bit
time_t, off_t and struct resource and system calls based on them,
including the vdso.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/riscv/Kconfig                   | 1 -
 arch/riscv/include/uapi/asm/unistd.h | 5 +----
 arch/riscv/kernel/vdso/Makefile      | 2 ++
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 09fa3a87bf30..feeeaa60697c 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -11,7 +11,6 @@ config 32BIT
 
 config RISCV
 	def_bool y
-	select ARCH_32BIT_OFF_T if !64BIT
 	# even on 32-bit, physical (and DMA) addresses are > 32-bits
 	select PHYS_ADDR_T_64BIT
 	select OF
diff --git a/arch/riscv/include/uapi/asm/unistd.h b/arch/riscv/include/uapi/asm/unistd.h
index 486a288b454c..0e2eeeb1fd27 100644
--- a/arch/riscv/include/uapi/asm/unistd.h
+++ b/arch/riscv/include/uapi/asm/unistd.h
@@ -17,11 +17,8 @@
 
 #ifdef __LP64__
 #define __ARCH_WANT_NEW_STAT
-#endif /* __LP64__ */
 #define __ARCH_WANT_SET_GET_RLIMIT
-#ifndef __LP64__
-#define __ARCH_WANT_TIME32_SYSCALLS
-#endif
+#endif /* __LP64__ */
 
 #include <asm-generic/unistd.h>
 
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index eed1c137f618..fec62b24df89 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -2,9 +2,11 @@
 
 # Symbols present in the vdso
 vdso-syms  = rt_sigreturn
+ifdef CONFIG_64BIT
 vdso-syms += gettimeofday
 vdso-syms += clock_gettime
 vdso-syms += clock_getres
+endif
 vdso-syms += getcpu
 vdso-syms += flush_icache
 
-- 
2.20.0
