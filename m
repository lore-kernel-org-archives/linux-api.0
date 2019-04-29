From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] y2038: make CONFIG_64BIT_TIME unconditional
Date: Mon, 29 Apr 2019 15:19:37 +0200
Message-ID: <20190429131951.471701-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Joseph Myers <joseph@codesourcery.com>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Lukasz Majewski <lukma@denx.de>, Stepan Golosunov <stepan@golosunov.pp.ru>
List-Id: linux-api@vger.kernel.org

As Stepan Golosunov points out, we made a small mistake in the
get_timespec64() function in the kernel. It was originally added under
the assumption that CONFIG_64BIT_TIME would get enabled on all 32-bit
and 64-bit architectures, but when I did the conversion, I only turned
it on for 32-bit ones.

The effect is that the get_timespec64() function never clears the upper
half of the tv_nsec field for 32-bit tasks in compat mode. Clearing this
is required for POSIX compliant behavior of functions that pass a
'timespec' structure with a 64-bit tv_sec and a 32-bit tv_nsec, plus
uninitialized padding.

The easiest fix for linux-5.1 is to just make the Kconfig symbol
unconditional, as it was originally intended. As a follow-up,
we should remove any #ifdef CONFIG_64BIT_TIME completely.

Note: for native 32-bit mode, no change is needed, this works as
designed and user space should never need to clear the upper 32
bits of the tv_nsec field, in or out of the kernel.

Fixes: 00bf25d693e7 ("y2038: use time32 syscall names on 32-bit")
Link: https://lore.kernel.org/lkml/20190422090710.bmxdhhankurhafxq@sghpc.golosunov.pp.ru/
Cc: Lukasz Majewski <lukma@denx.de>
Cc: Stepan Golosunov <stepan@golosunov.pp.ru>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Please apply this one as a bugfix for 5.1
---
 arch/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 33687dddd86a..9092e0ffe4d3 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -764,7 +764,7 @@ config COMPAT_OLD_SIGACTION
 	bool
 
 config 64BIT_TIME
-	def_bool ARCH_HAS_64BIT_TIME
+	def_bool y
 	help
 	  This should be selected by all architectures that need to support
 	  new system calls with a 64-bit time_t. This is relevant on all 32-bit
-- 
2.20.0
