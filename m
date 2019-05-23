From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.1 119/122] y2038: Make CONFIG_64BIT_TIME unconditional
Date: Thu, 23 May 2019 21:07:21 +0200
Message-ID: <20190523181721.342941070@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-102226-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Joseph Myers <joseph@codesourcery.com>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>, Lukasz Majewski <lukma@denx.de>, Stepan Golosunov <stepan@golosunov.pp.ru>
List-Id: linux-api@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit f3d964673b2f1c5d5c68c77273efcf7103eed03b upstream.

As Stepan Golosunov points out, there is a small mistake in the
get_timespec64() function in the kernel. It was originally added under the
assumption that CONFIG_64BIT_TIME would get enabled on all 32-bit and
64-bit architectures, but when the conversion was done, it was only turned
on for 32-bit ones.

The effect is that the get_timespec64() function never clears the upper
half of the tv_nsec field for 32-bit tasks in compat mode. Clearing this is
required for POSIX compliant behavior of functions that pass a 'timespec'
structure with a 64-bit tv_sec and a 32-bit tv_nsec, plus uninitialized
padding.

The easiest fix for linux-5.1 is to just make the Kconfig symbol
unconditional, as it was originally intended. As a follow-up, the #ifdef
CONFIG_64BIT_TIME can be removed completely..

Note: for native 32-bit mode, no change is needed, this works as
designed and user space should never need to clear the upper 32
bits of the tv_nsec field, in or out of the kernel.

Fixes: 00bf25d693e7 ("y2038: use time32 syscall names on 32-bit")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Joseph Myers <joseph@codesourcery.com>
Cc: libc-alpha@sourceware.org
Cc: linux-api@vger.kernel.org
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Lukasz Majewski <lukma@denx.de>
Cc: Stepan Golosunov <stepan@golosunov.pp.ru>
Link: https://lore.kernel.org/lkml/20190422090710.bmxdhhankurhafxq@sghpc.golosunov.pp.ru/
Link: https://lkml.kernel.org/r/20190429131951.471701-1-arnd@arndb.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
