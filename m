From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 12/15] sparc64: fix sparc_ipc type conversion
Date: Thu, 10 Jan 2019 17:24:32 +0100
Message-ID: <20190110162435.309262-13-arnd@arndb.de>
References: <20190110162435.309262-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190110162435.309262-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, firoz.khan@linaro.org, ebiederm@xmission.com, deepa.kernel@gmail.com, linux@dominikbrodowski.net, akpm@linux-foundation.org, dave@stgolabs.net, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-paris
List-Id: linux-api@vger.kernel.org

__kernel_timespec and timespec are currently the same type, but once
they are different, the type cast has to be changed here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/sparc/kernel/sys_sparc_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 274ed0b9b3e0..1c079e7bab09 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -344,7 +344,7 @@ SYSCALL_DEFINE6(sparc_ipc, unsigned int, call, int, first, unsigned long, second
 			goto out;
 		case SEMTIMEDOP:
 			err = sys_semtimedop(first, ptr, (unsigned int)second,
-				(const struct timespec __user *)
+				(const struct __kernel_timespec __user *)
 					     (unsigned long) fifth);
 			goto out;
 		case SEMGET:
-- 
2.20.0
