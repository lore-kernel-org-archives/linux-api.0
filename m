From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 06/24] thread: move thread bits accessors to separated file
Date: Wed, 16 May 2018 11:18:51 +0300
Message-ID: <20180516081910.10067-7-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

Thread bits may be accessed from low-level code, so isolating is a measure
to avoid circular dependencies in header files.

The exact reason for circular dependency is WARN_ON() macro added in patch
edd63a27 "set_restore_sigmask() is never called without SIGPENDING (and
never should be)"

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 include/linux/sched.h       |  1 +
 include/linux/thread_bits.h | 76 +++++++++++++++++++++++++++++++++++++
 include/linux/thread_info.h | 64 +------------------------------
 3 files changed, 78 insertions(+), 63 deletions(-)
 create mode 100644 include/linux/thread_bits.h

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b161ef8a902e..c1bddf06baed 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -27,6 +27,7 @@
 #include <linux/signal_types.h>
 #include <linux/mm_types_task.h>
 #include <linux/task_io_accounting.h>
+#include <linux/thread_bits.h>
 
 /* task_struct member predeclarations (sorted alphabetically): */
 struct audit_context;
diff --git a/include/linux/thread_bits.h b/include/linux/thread_bits.h
new file mode 100644
index 000000000000..7512f8527e9a
--- /dev/null
+++ b/include/linux/thread_bits.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+/* Common low-level thread bits accessors */
+
+#ifndef _LINUX_THREAD_BITS_H
+#define _LINUX_THREAD_BITS_H
+
+#ifndef __ASSEMBLY__
+
+/*
+ * For per-arch arch_within_stack_frames() implementations, defined in
+ * asm/thread_info.h.
+ */
+enum {
+	BAD_STACK = -1,
+	NOT_STACK = 0,
+	GOOD_FRAME,
+	GOOD_STACK,
+};
+
+#include <linux/bitops.h>
+#include <asm/thread_info.h>
+
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+/*
+ * For CONFIG_THREAD_INFO_IN_TASK kernels we need <asm/current.h> for the
+ * definition of current, but for !CONFIG_THREAD_INFO_IN_TASK kernels,
+ * including <asm/current.h> can cause a circular dependency on some platforms.
+ */
+#include <asm/current.h>
+#define current_thread_info() ((struct thread_info *)current)
+#endif
+
+/*
+ * flag set/clear/test wrappers
+ * - pass TIF_xxxx constants to these functions
+ */
+
+static inline void set_ti_thread_flag(struct thread_info *ti, int flag)
+{
+	set_bit(flag, (unsigned long *)&ti->flags);
+}
+
+static inline void clear_ti_thread_flag(struct thread_info *ti, int flag)
+{
+	clear_bit(flag, (unsigned long *)&ti->flags);
+}
+
+static inline int test_and_set_ti_thread_flag(struct thread_info *ti, int flag)
+{
+	return test_and_set_bit(flag, (unsigned long *)&ti->flags);
+}
+
+static inline int test_and_clear_ti_thread_flag(struct thread_info *ti, int flag)
+{
+	return test_and_clear_bit(flag, (unsigned long *)&ti->flags);
+}
+
+static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
+{
+	return test_bit(flag, (unsigned long *)&ti->flags);
+}
+
+#define set_thread_flag(flag) \
+	set_ti_thread_flag(current_thread_info(), flag)
+#define clear_thread_flag(flag) \
+	clear_ti_thread_flag(current_thread_info(), flag)
+#define test_and_set_thread_flag(flag) \
+	test_and_set_ti_thread_flag(current_thread_info(), flag)
+#define test_and_clear_thread_flag(flag) \
+	test_and_clear_ti_thread_flag(current_thread_info(), flag)
+#define test_thread_flag(flag) \
+	test_ti_thread_flag(current_thread_info(), flag)
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _LINUX_THREAD_BITS_H */
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 34f053a150a9..793ab9b290ad 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -11,30 +11,9 @@
 #include <linux/types.h>
 #include <linux/bug.h>
 #include <linux/restart_block.h>
-
-#ifdef CONFIG_THREAD_INFO_IN_TASK
-/*
- * For CONFIG_THREAD_INFO_IN_TASK kernels we need <asm/current.h> for the
- * definition of current, but for !CONFIG_THREAD_INFO_IN_TASK kernels,
- * including <asm/current.h> can cause a circular dependency on some platforms.
- */
-#include <asm/current.h>
-#define current_thread_info() ((struct thread_info *)current)
-#endif
+#include <linux/thread_bits.h>
 
 #include <linux/bitops.h>
-
-/*
- * For per-arch arch_within_stack_frames() implementations, defined in
- * asm/thread_info.h.
- */
-enum {
-	BAD_STACK = -1,
-	NOT_STACK = 0,
-	GOOD_FRAME,
-	GOOD_STACK,
-};
-
 #include <asm/thread_info.h>
 
 #ifdef __KERNEL__
@@ -49,47 +28,6 @@ enum {
 # define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT)
 #endif
 
-/*
- * flag set/clear/test wrappers
- * - pass TIF_xxxx constants to these functions
- */
-
-static inline void set_ti_thread_flag(struct thread_info *ti, int flag)
-{
-	set_bit(flag, (unsigned long *)&ti->flags);
-}
-
-static inline void clear_ti_thread_flag(struct thread_info *ti, int flag)
-{
-	clear_bit(flag, (unsigned long *)&ti->flags);
-}
-
-static inline int test_and_set_ti_thread_flag(struct thread_info *ti, int flag)
-{
-	return test_and_set_bit(flag, (unsigned long *)&ti->flags);
-}
-
-static inline int test_and_clear_ti_thread_flag(struct thread_info *ti, int flag)
-{
-	return test_and_clear_bit(flag, (unsigned long *)&ti->flags);
-}
-
-static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
-{
-	return test_bit(flag, (unsigned long *)&ti->flags);
-}
-
-#define set_thread_flag(flag) \
-	set_ti_thread_flag(current_thread_info(), flag)
-#define clear_thread_flag(flag) \
-	clear_ti_thread_flag(current_thread_info(), flag)
-#define test_and_set_thread_flag(flag) \
-	test_and_set_ti_thread_flag(current_thread_info(), flag)
-#define test_and_clear_thread_flag(flag) \
-	test_and_clear_ti_thread_flag(current_thread_info(), flag)
-#define test_thread_flag(flag) \
-	test_ti_thread_flag(current_thread_info(), flag)
-
 #define tif_need_resched() test_thread_flag(TIF_NEED_RESCHED)
 
 #ifndef CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES
-- 
2.17.0
