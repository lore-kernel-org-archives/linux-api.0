From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 02/11] time: Add struct __kernel_timex
Date: Thu, 10 Jan 2019 18:22:07 +0100
Message-ID: <20190110172216.313063-3-arnd@arndb.de>
References: <20190110172216.313063-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190110172216.313063-1-arnd@arndb.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dalias@libc.org, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, jcmvbkbc@gmail.com, deepa.kernel@gmail.com, hpa@zytor.com, sparclinux@vger.kernel.org, linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, mpe@ellerman.id.au, deller@gmx.de, x86@kernel.org, linux@armlinux.org.uk, mingo@redhat.com, geert@linux-m68k.org, benh@kernel.crashing.org, firoz.khan@linaro.org, mattst88@gmail.com, fenghua.yu@intel.com, Arnd Bergmann <arnd@arndb.de>, heiko.carstens@de.ibm.com, linux-fsdevel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, luto@kernel.org, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, monstr@monstr.eu, tony.luck@intel.com, linux-parisc@vger.kernel.org, netdev@vger.kernel.org, linux-mips@vger.kernel.org, paul.burton@mips.com, ebiederm@xmission.com, linux-alpha@vger.kernel.org, schwidefsky@de.ibm.com, akp
List-Id: linux-api@vger.kernel.org

From: Deepa Dinamani <deepa.kernel@gmail.com>

struct timex uses struct timeval internally.
struct timeval is not y2038 safe.
Introduce a new UAPI type struct __kernel_timex
that is y2038 safe.

struct __kernel_timex uses a timeval type that is
similar to struct __kernel_timespec which preserves the
same structure size across 32 bit and 64 bit ABIs.
struct __kernel_timex also restructures other members of the
structure to make the structure the same on 64 bit and 32 bit
architectures.
Note that struct __kernel_timex is the same as struct timex
on a 64 bit architecture.

The above solution is similar to other new y2038 syscalls
that are being introduced: both 32 bit and 64 bit ABIs
have a common entry, and the compat entry supports the old 32 bit
syscall interface.

Alternatives considered were:
1. Add new time type to struct timex that makes use of padded
   bits. This time type could be based on the struct __kernel_timespec.
   modes will use a flag to notify which time structure should be
   used internally.
   This needs some application level changes on both 64 bit and 32 bit
   architectures. Although 64 bit machines could continue to use the
   older timeval structure without any changes.

2. Add a new u8 type to struct timex that makes use of padded bits. This
   can be used to save higher order tv_sec bits. modes will use a flag to
   notify presence of such a type.
   This will need some application level changes on 32 bit architectures.

3. Add a new compat_timex structure that differs in only the size of the
   time type; keep rest of struct timex the same.
   This requires extra syscalls to manage all 3 cases on 64 bit
   architectures. This will not need any application level changes but will
   add more complexity from kernel side.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
 include/linux/timex.h      |  7 +++++++
 include/uapi/linux/timex.h | 41 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index 39c25dbebfe8..7f40e9e42ecc 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -53,6 +53,13 @@
 #ifndef _LINUX_TIMEX_H
 #define _LINUX_TIMEX_H
 
+/* CONFIG_64BIT_TIME enables new 64 bit time_t syscalls in the compat path
+ * and 32-bit emulation.
+ */
+#ifndef CONFIG_64BIT_TIME
+#define __kernel_timex timex
+#endif
+
 #include <uapi/linux/timex.h>
 
 #define ADJ_ADJTIME		0x8000	/* switch between adjtime/adjtimex modes */
diff --git a/include/uapi/linux/timex.h b/include/uapi/linux/timex.h
index 92685d826444..a1c6b73016a5 100644
--- a/include/uapi/linux/timex.h
+++ b/include/uapi/linux/timex.h
@@ -92,6 +92,47 @@ struct timex {
 	int  :32; int  :32; int  :32;
 };
 
+struct __kernel_timex_timeval {
+	__kernel_time64_t       tv_sec;
+	long long		tv_usec;
+};
+
+#ifndef __kernel_timex
+struct __kernel_timex {
+	unsigned int modes;	/* mode selector */
+	int :32;            /* pad */
+	long long offset;	/* time offset (usec) */
+	long long freq;	/* frequency offset (scaled ppm) */
+	long long maxerror;/* maximum error (usec) */
+	long long esterror;/* estimated error (usec) */
+	int status;		/* clock command/status */
+	int :32;            /* pad */
+	long long constant;/* pll time constant */
+	long long precision;/* clock precision (usec) (read only) */
+	long long tolerance;/* clock frequency tolerance (ppm)
+				   * (read only)
+				   */
+	struct __kernel_timex_timeval time;	/* (read only, except for ADJ_SETOFFSET) */
+	long long tick;	/* (modified) usecs between clock ticks */
+
+	long long ppsfreq;/* pps frequency (scaled ppm) (ro) */
+	long long jitter; /* pps jitter (us) (ro) */
+	int shift;              /* interval duration (s) (shift) (ro) */
+	int :32;            /* pad */
+	long long stabil;            /* pps stability (scaled ppm) (ro) */
+	long long jitcnt; /* jitter limit exceeded (ro) */
+	long long calcnt; /* calibration intervals (ro) */
+	long long errcnt; /* calibration errors (ro) */
+	long long stbcnt; /* stability limit exceeded (ro) */
+
+	int tai;		/* TAI offset (ro) */
+
+	int  :32; int  :32; int  :32; int  :32;
+	int  :32; int  :32; int  :32; int  :32;
+	int  :32; int  :32; int  :32;
+};
+#endif
+
 /*
  * Mode codes (timex.mode)
  */
-- 
2.20.0
