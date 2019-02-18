From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/8] compat ABI: use non-compat openat and open_by_handle_at variants
Date: Mon, 18 Feb 2019 22:07:05 +0100
Message-ID: <20190218210712.3503891-2-arnd@arndb.de>
References: <20190218210712.3503891-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190218210712.3503891-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, yury.norov@gmail.com, linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org, uclinux-h8-devel@lists.sourceforge.jp, Stafford Horne <shorne@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Palmer Dabbelt <palmer@sifive.com>, Guo Ren <guoren@kernel.org>, Greentime Hu <green.hu@gmail.com>, arnd@arndb.de, linux-riscv@lists.infradead.org, Guan Xuetao <gxt@pku.edu.cn>, Yury Norov <ynorov@caviumnetworks.com>, Yury Norov <ynorov@marvell.com>
List-Id: linux-api@vger.kernel.org

From: Yury Norov <ynorov@caviumnetworks.com>

The only difference between native and compat openat and open_by_handle_at
is that non-compat version forces O_LARGEFILE, and it should be the
default behaviour for all architectures, as we are going to drop the
support of 32-bit userspace off_t.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Yury Norov <ynorov@marvell.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/uapi/asm-generic/unistd.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index acf9a07ab2ff..b928eff3bf92 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -179,7 +179,7 @@ __SYSCALL(__NR_fchownat, sys_fchownat)
 #define __NR_fchown 55
 __SYSCALL(__NR_fchown, sys_fchown)
 #define __NR_openat 56
-__SC_COMP(__NR_openat, sys_openat, compat_sys_openat)
+__SYSCALL(__NR_openat, sys_openat)
 #define __NR_close 57
 __SYSCALL(__NR_close, sys_close)
 #define __NR_vhangup 58
@@ -678,8 +678,7 @@ __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
 #define __NR_name_to_handle_at         264
 __SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
 #define __NR_open_by_handle_at         265
-__SC_COMP(__NR_open_by_handle_at, sys_open_by_handle_at, \
-	  compat_sys_open_by_handle_at)
+__SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
 #define __NR_clock_adjtime 266
 __SC_3264(__NR_clock_adjtime, sys_clock_adjtime32, sys_clock_adjtime)
 #define __NR_syncfs 267
-- 
2.20.0
