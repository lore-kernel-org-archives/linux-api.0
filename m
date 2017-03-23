From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] lkdtm: add bad USER_DS test
Date: Thu, 23 Mar 2017 13:34:19 -0700
Message-ID: <20170323203419.GA62859@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jo
List-Id: linux-api@vger.kernel.org

This adds CORRUPT_USER_DS to check that the get_fs() test on syscall return
still sees USER_DS during the new VERIFY_PRE_USERMODE_STATE checks.

Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 drivers/misc/lkdtm.h      |  1 +
 drivers/misc/lkdtm_bugs.c | 20 ++++++++++++++++++++
 drivers/misc/lkdtm_core.c |  1 +
 3 files changed, 22 insertions(+)

diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
index 67d27be60405..3b4976396ec4 100644
--- a/drivers/misc/lkdtm.h
+++ b/drivers/misc/lkdtm.h
@@ -27,6 +27,7 @@ void lkdtm_REFCOUNT_ZERO_SUB(void);
 void lkdtm_REFCOUNT_ZERO_ADD(void);
 void lkdtm_CORRUPT_LIST_ADD(void);
 void lkdtm_CORRUPT_LIST_DEL(void);
+void lkdtm_CORRUPT_USER_DS(void);
 
 /* lkdtm_heap.c */
 void lkdtm_OVERWRITE_ALLOCATION(void);
diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
index e3f4cd8876b5..4906e53a6df3 100644
--- a/drivers/misc/lkdtm_bugs.c
+++ b/drivers/misc/lkdtm_bugs.c
@@ -8,6 +8,7 @@
 #include <linux/list.h>
 #include <linux/refcount.h>
 #include <linux/sched.h>
+#include <linux/uaccess.h>
 
 struct lkdtm_list {
 	struct list_head node;
@@ -279,3 +280,22 @@ void lkdtm_CORRUPT_LIST_DEL(void)
 	else
 		pr_err("list_del() corruption not detected!\n");
 }
+
+void lkdtm_CORRUPT_USER_DS(void)
+{
+	/*
+	 * Test that USER_DS has been set correctly on exiting a syscall.
+	 * Since setting this higher than USER_DS (TASK_SIZE) would introduce
+	 * an exploitable condition, we lower it instead, since that should
+	 * not create as large a problem on an unprotected system.
+	 */
+	mm_segment_t lowfs;
+#ifdef MAKE_MM_SEG
+	lowfs = MAKE_MM_SEG(TASK_SIZE - PAGE_SIZE);
+#else
+	lowfs = TASK_SIZE - PAGE_SIZE;
+#endif
+
+	pr_info("setting bad task size limit\n");
+	set_fs(lowfs);
+}
diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
index b9a4cd4a9b68..42d2b8e31e6b 100644
--- a/drivers/misc/lkdtm_core.c
+++ b/drivers/misc/lkdtm_core.c
@@ -199,6 +199,7 @@ struct crashtype crashtypes[] = {
 	CRASHTYPE(OVERFLOW),
 	CRASHTYPE(CORRUPT_LIST_ADD),
 	CRASHTYPE(CORRUPT_LIST_DEL),
+	CRASHTYPE(CORRUPT_USER_DS),
 	CRASHTYPE(CORRUPT_STACK),
 	CRASHTYPE(UNALIGNED_LOAD_STORE_WRITE),
 	CRASHTYPE(OVERWRITE_ALLOCATION),
-- 
2.7.4


-- 
Kees Cook
Pixel Security
