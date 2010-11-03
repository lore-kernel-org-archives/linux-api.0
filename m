From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 02/12] kmsg_dumper: Pass pt_regs along to dumpers.
Date: Tue, 02 Nov 2010 18:29:37 -0700
Message-ID: <20101103012936.4641.64774.stgit@crlf.mtv.corp.google.com>
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

A subsequent commit adding netoops functionality would like access to the
pt_regs to have them recorded in the dump.  Pass the register values along if
available.

Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/char/ramoops.c    |    4 +++-
 drivers/mtd/mtdoops.c     |    4 +++-
 include/linux/kmsg_dump.h |    8 ++++++--
 kernel/kexec.c            |    5 +++--
 kernel/panic.c            |    4 ++--
 kernel/printk.c           |    4 ++--
 6 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 74f00b5..9acf52c 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -56,7 +56,9 @@ static struct ramoops_context {
 } oops_cxt;
 
 static void ramoops_do_dump(struct kmsg_dumper *dumper,
-		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
+		enum kmsg_dump_reason reason,
+		struct pt_regs *pt_regs,
+		const char *s1, unsigned long l1,
 		const char *s2, unsigned long l2)
 {
 	struct ramoops_context *cxt = container_of(dumper,
diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
index 1ee72f3..cf07cf5 100644
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -298,7 +298,9 @@ static void find_next_position(struct mtdoops_context *cxt)
 }
 
 static void mtdoops_do_dump(struct kmsg_dumper *dumper,
-		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
+		enum kmsg_dump_reason reason,
+		struct pt_regs *pt_regs,
+		const char *s1, unsigned long l1,
 		const char *s2, unsigned long l2)
 {
 	struct mtdoops_context *cxt = container_of(dumper,
diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
index 24b4414..a229acc 100644
--- a/include/linux/kmsg_dump.h
+++ b/include/linux/kmsg_dump.h
@@ -14,6 +14,8 @@
 
 #include <linux/list.h>
 
+struct pt_regs;
+
 enum kmsg_dump_reason {
 	KMSG_DUMP_OOPS,
 	KMSG_DUMP_PANIC,
@@ -30,6 +32,7 @@ enum kmsg_dump_reason {
  */
 struct kmsg_dumper {
 	void (*dump)(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
+			struct pt_regs *pt_regs,
 			const char *s1, unsigned long l1,
 			const char *s2, unsigned long l2);
 	struct list_head list;
@@ -37,13 +40,14 @@ struct kmsg_dumper {
 };
 
 #ifdef CONFIG_PRINTK
-void kmsg_dump(enum kmsg_dump_reason reason);
+void kmsg_dump(enum kmsg_dump_reason reason, struct pt_regs *pt_regs);
 
 int kmsg_dump_register(struct kmsg_dumper *dumper);
 
 int kmsg_dump_unregister(struct kmsg_dumper *dumper);
 #else
-static inline void kmsg_dump(enum kmsg_dump_reason reason)
+static inline void kmsg_dump(enum kmsg_dump_reason reason,
+			     struct pt_regs *pt_regs)
 {
 }
 
diff --git a/kernel/kexec.c b/kernel/kexec.c
index c0613f7..6e89a52 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1078,10 +1078,11 @@ void crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
-			kmsg_dump(KMSG_DUMP_KEXEC);
-
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
+
+			kmsg_dump(KMSG_DUMP_KEXEC, &fixed_regs);
+
 			machine_crash_shutdown(&fixed_regs);
 			machine_kexec(kexec_crash_image);
 		}
diff --git a/kernel/panic.c b/kernel/panic.c
index c3f39cd..b3a4440 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -87,7 +87,7 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	crash_kexec(NULL);
 
-	kmsg_dump(KMSG_DUMP_PANIC);
+	kmsg_dump(KMSG_DUMP_PANIC, NULL);
 
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
@@ -353,7 +353,7 @@ void oops_exit(struct pt_regs *regs)
 {
 	do_oops_enter_exit();
 	print_oops_end_marker();
-	kmsg_dump(KMSG_DUMP_OOPS);
+	kmsg_dump(KMSG_DUMP_OOPS, regs);
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
diff --git a/kernel/printk.c b/kernel/printk.c
index 8fe465a..ad0c74e 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1532,7 +1532,7 @@ static const char *kmsg_to_str(enum kmsg_dump_reason reason)
  * Iterate through each of the dump devices and call the oops/panic
  * callbacks with the log buffer.
  */
-void kmsg_dump(enum kmsg_dump_reason reason)
+void kmsg_dump(enum kmsg_dump_reason reason, struct pt_regs *pt_regs)
 {
 	unsigned long end;
 	unsigned chars;
@@ -1569,7 +1569,7 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 		return;
 	}
 	list_for_each_entry(dumper, &dump_list, list)
-		dumper->dump(dumper, reason, s1, l1, s2, l2);
+		dumper->dump(dumper, reason, pt_regs, s1, l1, s2, l2);
 	spin_unlock_irqrestore(&dump_list_lock, flags);
 }
 #endif
