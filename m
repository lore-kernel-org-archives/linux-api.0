From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 01/12] Oops: Pass regs to oops_exit()
Date: Tue, 02 Nov 2010 18:29:31 -0700
Message-ID: <20101103012930.4641.93668.stgit@crlf.mtv.corp.google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101103012917.4641.57113.stgit-+dUuAhMFdFN6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Cc: adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Later commits in this series will want to see pt_regs if available when a
machine oopses.  Pass regs if available on to oops_exit().

Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
index a45a63c..918c498 100644
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
index 5d8f0f3..90c8259 100644
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
index c3d86fa..6b3f31e 100644
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -102,7 +102,7 @@ void die(const char * str, struct pt_regs * regs, long err)
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
index 2b0a35e..995eb70 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -181,7 +181,7 @@ extern long (*panic_blink)(int state);
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
