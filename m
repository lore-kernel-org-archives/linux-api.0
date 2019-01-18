From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 21/29] sparc64: add custom adjtimex/clock_adjtime functions
Date: Fri, 18 Jan 2019 17:18:27 +0100
Message-ID: <20190118161835.2259170-22-arnd@arndb.de>
References: <20190118161835.2259170-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190118161835.2259170-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.or
List-Id: linux-api@vger.kernel.org

sparc64 is the only architecture on Linux that has a 'timeval'
definition with a 32-bit tv_usec but a 64-bit tv_sec. This causes
problems for sparc32 compat mode when we convert it to use the
new __kernel_timex type that has the same layout as all other
64-bit architectures.

To avoid adding sparc64 specific code into the generic adjtimex
implementation, this adds a wrapper in the sparc64 system call handling
that converts the sparc64 'timex' into the new '__kernel_timex'.

At this point, the two structures are defined to be identical,
but that will change in the next step once we convert sparc32.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/sparc/kernel/sys_sparc_64.c       | 59 +++++++++++++++++++++++++-
 arch/sparc/kernel/syscalls/syscall.tbl |  6 ++-
 include/linux/timex.h                  |  2 +
 kernel/time/posix-timers.c             | 24 +++++------
 4 files changed, 76 insertions(+), 15 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 1c079e7bab09..37de18a11207 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -28,8 +28,9 @@
 #include <linux/random.h>
 #include <linux/export.h>
 #include <linux/context_tracking.h>
-
+#include <linux/timex.h>
 #include <linux/uaccess.h>
+
 #include <asm/utrap.h>
 #include <asm/unistd.h>
 
@@ -544,6 +545,62 @@ SYSCALL_DEFINE2(getdomainname, char __user *, name, int, len)
 	return err;
 }
 
+SYSCALL_DEFINE1(sparc_adjtimex, struct timex __user *, txc_p)
+{
+	struct timex txc;		/* Local copy of parameter */
+	struct timex *kt = (void *)&txc;
+	int ret;
+
+	/* Copy the user data space into the kernel copy
+	 * structure. But bear in mind that the structures
+	 * may change
+	 */
+	if (copy_from_user(&txc, txc_p, sizeof(struct timex)))
+		return -EFAULT;
+
+	/*
+	 * override for sparc64 specific timeval type: tv_usec
+	 * is 32 bit wide instead of 64-bit in __kernel_timex
+	 */
+	kt->time.tv_usec = txc.time.tv_usec;
+	ret = do_adjtimex(kt);
+	txc.time.tv_usec = kt->time.tv_usec;
+
+	return copy_to_user(txc_p, &txc, sizeof(struct timex)) ? -EFAULT : ret;
+}
+
+SYSCALL_DEFINE2(sparc_clock_adjtime, const clockid_t, which_clock,struct timex __user *, txc_p)
+{
+	struct timex txc;		/* Local copy of parameter */
+	struct timex *kt = (void *)&txc;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_POSIX_TIMERS)) {
+		pr_err_once("process %d (%s) attempted a POSIX timer syscall "
+		    "while CONFIG_POSIX_TIMERS is not set\n",
+		    current->pid, current->comm);
+
+		return -ENOSYS;
+	}
+
+	/* Copy the user data space into the kernel copy
+	 * structure. But bear in mind that the structures
+	 * may change
+	 */
+	if (copy_from_user(&txc, txc_p, sizeof(struct timex)))
+		return -EFAULT;
+
+	/*
+	 * override for sparc64 specific timeval type: tv_usec
+	 * is 32 bit wide instead of 64-bit in __kernel_timex
+	 */
+	kt->time.tv_usec = txc.time.tv_usec;
+	ret = do_clock_adjtime(which_clock, kt);
+	txc.time.tv_usec = kt->time.tv_usec;
+
+	return copy_to_user(txc_p, &txc, sizeof(struct timex)) ? -EFAULT : ret;
+}
+
 SYSCALL_DEFINE5(utrap_install, utrap_entry_t, type,
 		utrap_handler_t, new_p, utrap_handler_t, new_d,
 		utrap_handler_t __user *, old_p,
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 24ebef675184..e70110375399 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -258,7 +258,8 @@
 216	64	sigreturn		sys_nis_syscall
 217	common	clone			sys_clone
 218	common	ioprio_get		sys_ioprio_get
-219	common	adjtimex		sys_adjtimex			compat_sys_adjtimex
+219	32	adjtimex		sys_adjtimex			compat_sys_adjtimex
+219	64	adjtimex		sys_sparc_adjtimex
 220	32	sigprocmask		sys_sigprocmask			compat_sys_sigprocmask
 220	64	sigprocmask		sys_nis_syscall
 221	common	create_module		sys_ni_syscall
@@ -377,7 +378,8 @@
 331	common	prlimit64		sys_prlimit64
 332	common	name_to_handle_at	sys_name_to_handle_at
 333	common	open_by_handle_at	sys_open_by_handle_at		compat_sys_open_by_handle_at
-334	common	clock_adjtime		sys_clock_adjtime		compat_sys_clock_adjtime
+334	32	clock_adjtime		sys_clock_adjtime		compat_sys_clock_adjtime
+334	64	clock_adjtime		sys_sparc_clock_adjtime
 335	common	syncfs			sys_syncfs
 336	common	sendmmsg		sys_sendmmsg			compat_sys_sendmmsg
 337	common	setns			sys_setns
diff --git a/include/linux/timex.h b/include/linux/timex.h
index 7f40e9e42ecc..a15e6aeb8d49 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -159,6 +159,8 @@ extern unsigned long tick_nsec;		/* SHIFTED_HZ period (nsec) */
 #define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
 extern int do_adjtimex(struct timex *);
+extern int do_clock_adjtime(const clockid_t which_clock, struct timex * ktx);
+
 extern void hardpps(const struct timespec64 *, const struct timespec64 *);
 
 int read_current_timer(unsigned long *timer_val);
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 8955f32f2a36..8f7f1dd95940 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1047,22 +1047,28 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 	return error;
 }
 
-SYSCALL_DEFINE2(clock_adjtime, const clockid_t, which_clock,
-		struct timex __user *, utx)
+int do_clock_adjtime(const clockid_t which_clock, struct timex * ktx)
 {
 	const struct k_clock *kc = clockid_to_kclock(which_clock);
-	struct timex ktx;
-	int err;
 
 	if (!kc)
 		return -EINVAL;
 	if (!kc->clock_adj)
 		return -EOPNOTSUPP;
 
+	return kc->clock_adj(which_clock, ktx);
+}
+
+SYSCALL_DEFINE2(clock_adjtime, const clockid_t, which_clock,
+		struct timex __user *, utx)
+{
+	struct timex ktx;
+	int err;
+
 	if (copy_from_user(&ktx, utx, sizeof(ktx)))
 		return -EFAULT;
 
-	err = kc->clock_adj(which_clock, &ktx);
+	err = do_clock_adjtime(which_clock, &ktx);
 
 	if (err >= 0 && copy_to_user(utx, &ktx, sizeof(ktx)))
 		return -EFAULT;
@@ -1126,20 +1132,14 @@ COMPAT_SYSCALL_DEFINE2(clock_gettime, clockid_t, which_clock,
 COMPAT_SYSCALL_DEFINE2(clock_adjtime, clockid_t, which_clock,
 		       struct old_timex32 __user *, utp)
 {
-	const struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timex ktx;
 	int err;
 
-	if (!kc)
-		return -EINVAL;
-	if (!kc->clock_adj)
-		return -EOPNOTSUPP;
-
 	err = get_old_timex32(&ktx, utp);
 	if (err)
 		return err;
 
-	err = kc->clock_adj(which_clock, &ktx);
+	err = do_clock_adjtime(which_clock, &ktx);
 
 	if (err >= 0)
 		err = put_old_timex32(utp, &ktx);
-- 
2.20.0
