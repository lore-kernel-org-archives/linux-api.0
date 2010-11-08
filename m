From: Mike Waychison <mikew@google.com>
Subject: [PATCH v2 15/23] Oops: Pass regs to oops_exit()
Date: Mon, 08 Nov 2010 12:33:05 -0800
Message-ID: <20101108203304.22479.93234.stgit@crlf.mtv.corp.google.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com, Matt Mackall <mpm@selenic.com>
Cc: adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com, Greg KH <greg@kroah.com>, =?utf-8?q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>, akpm@linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Later commits in this series will want to see pt_regs if available when a
machine oopses.  Pass regs if available on to oops_exit().

Signed-off-by: Mike Waychison <mikew@google.com>
---
 arch/arm/kernel/traps.c     |    2 +-
 arch/parisc/kernel/traps.c  |    2 +-
 arch/powerpc/kernel/traps.c |    2 +-
 arch/s390/kernel/traps.c    |    2 +-
 arch/sh/kernel/traps_32.c   |    2 +-
 arch/x86/kernel/dumpstack.c |    2 +-
 include/linux/kernel.h      |    2 +-
 kernel/panic.c              |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index cda78d5..45cc7c0 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -280,7 +280,7 @@ void die(const char *str, struct pt_regs *regs, int err)
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE);
 	spin_unlock_irq(&die_lock);
-	oops_exit();
+	oops_exit(regs);
 
 	if (in_interrupt())
 		panic("Fatal exception in interrupt");
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 8b58bf0..4aa5514 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -294,7 +294,7 @@ void die_if_kernel(char *str, struct pt_regs *regs, long err)
 		panic("Fatal exception");
 	}
 
-	oops_exit();
+	oops_exit(regs);
 	do_exit(SIGSEGV);
 }
 
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 1b2cdc8..76b950e 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -170,7 +170,7 @@ int die(const char *str, struct pt_regs *regs, long err)
 	if (panic_on_oops)
 		panic("Fatal exception");
 
-	oops_exit();
+	oops_exit(regs);
 	do_exit(err);
 
 	return 0;
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 7064082..73f3f2f 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -305,7 +305,7 @@ void die(const char * str, struct pt_regs * regs, long err)
 		panic("Fatal exception in interrupt");
 	if (panic_on_oops)
 		panic("Fatal exception: panic_on_oops");
-	oops_exit();
+	oops_exit(regs);
 	do_exit(SIGSEGV);
 }
 
diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
index 3484c2f..425bd8f 100644
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -103,7 +103,7 @@ void die(const char * str, struct pt_regs * regs, long err)
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE);
 	spin_unlock_irq(&die_lock);
-	oops_exit();
+	oops_exit(regs);
 
 	if (kexec_should_crash(current))
 		crash_kexec(regs);
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 6e8752c..89c720c 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -254,7 +254,7 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 		/* Nest count reaches zero, release the lock. */
 		arch_spin_unlock(&die_lock);
 	raw_local_irq_restore(flags);
-	oops_exit();
+	oops_exit(regs);
 
 	if (!signr)
 		return;
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 450092c..442b4a5 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -197,7 +197,7 @@ extern long (*panic_blink)(int state);
 NORET_TYPE void panic(const char * fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
 extern void oops_enter(void);
-extern void oops_exit(void);
+extern void oops_exit(struct pt_regs *);
 void print_oops_end_marker(void);
 extern int oops_may_print(void);
 NORET_TYPE void do_exit(long error_code)
diff --git a/kernel/panic.c b/kernel/panic.c
index 4c13b1a..c3f39cd 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -349,7 +349,7 @@ void print_oops_end_marker(void)
  * Called when the architecture exits its oops handler, after printing
  * everything.
  */
-void oops_exit(void)
+void oops_exit(struct pt_regs *regs)
 {
 	do_oops_enter_exit();
 	print_oops_end_marker();
