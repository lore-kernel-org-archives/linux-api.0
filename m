From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/8] checksyscalls: fix up mq_timedreceive and stat exceptions
Date: Mon, 18 Feb 2019 22:07:10 +0100
Message-ID: <20190218210712.3503891-7-arnd@arndb.de>
References: <20190218210712.3503891-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190218210712.3503891-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, yury.norov@gmail.com, linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org, uclinux-h8-devel@lists.sourceforge.jp, Stafford Horne <shorne@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Palmer Dabbelt <palmer@sifive.com>, Guo Ren <guoren@kernel.org>, Greentime Hu <green.hu@gmail.com>, arnd@arndb.de, linux-riscv@lists.infradead.org, Guan Xuetao <gxt@pku.edu.cn>
List-Id: linux-api@vger.kernel.org

mq_timedreceive was spelled incorrectly, and we need exceptions
for new architectures that leave out newstat or stat64, implementing
only statx() now.

Fixes: 48166e6ea47d ("y2038: add 64-bit time_t syscalls to all 32-bit architectures")
Fixes: bf4b6a7d371e ("y2038: Remove stat64 family from default syscall set")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 scripts/checksyscalls.sh | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index ffd635efbdca..a18b47695f55 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -30,13 +30,10 @@ cat << EOF
 #define __IGNORE_readlink	/* readlinkat */
 #define __IGNORE_symlink	/* symlinkat */
 #define __IGNORE_utimes		/* futimesat */
-#if BITS_PER_LONG == 64
 #define __IGNORE_stat		/* fstatat */
 #define __IGNORE_lstat		/* fstatat */
-#else
 #define __IGNORE_stat64		/* fstatat64 */
 #define __IGNORE_lstat64	/* fstatat64 */
-#endif
 
 #ifndef __ARCH_WANT_SET_GET_RLIMIT
 #define __IGNORE_getrlimit	/* getrlimit */
@@ -138,7 +135,7 @@ cat << EOF
 #define __IGNORE_io_pgetevents
 #define __IGNORE_recvmmsg
 #define __IGNORE_mq_timedsend
-#define __IGNORE_mq_timedreceiv
+#define __IGNORE_mq_timedreceive
 #define __IGNORE_semtimedop
 #define __IGNORE_rt_sigtimedwait
 #define __IGNORE_futex
-- 
2.20.0
