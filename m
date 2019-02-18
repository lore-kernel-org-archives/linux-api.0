From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7/8] csky: Use latest system call ABI
Date: Mon, 18 Feb 2019 22:07:11 +0100
Message-ID: <20190218210712.3503891-8-arnd@arndb.de>
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

We don't yet have an upstream glibc port for csky, so there is no user
space for the existing ABI, and we can remove the definitions for 32-bit
time_t, off_t and struct resource.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/csky/Kconfig                   | 1 -
 arch/csky/include/uapi/asm/unistd.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/arch/csky/Kconfig b/arch/csky/Kconfig
index 6959e0b1e956..398113c845f5 100644
--- a/arch/csky/Kconfig
+++ b/arch/csky/Kconfig
@@ -1,6 +1,5 @@
 config CSKY
 	def_bool y
-	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select ARCH_USE_BUILTIN_BSWAP
diff --git a/arch/csky/include/uapi/asm/unistd.h b/arch/csky/include/uapi/asm/unistd.h
index ec60e49cea66..224c9a9ab45b 100644
--- a/arch/csky/include/uapi/asm/unistd.h
+++ b/arch/csky/include/uapi/asm/unistd.h
@@ -2,8 +2,6 @@
 // Copyright (C) 2018 Hangzhou C-SKY Microsystems co.,ltd.
 
 #define __ARCH_WANT_SYS_CLONE
-#define __ARCH_WANT_SET_GET_RLIMIT
-#define __ARCH_WANT_TIME32_SYSCALLS
 #include <asm-generic/unistd.h>
 
 #define __NR_set_thread_area	(__NR_arch_specific_syscall + 0)
-- 
2.20.0
