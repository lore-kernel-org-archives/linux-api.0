From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 05/19] y2038: make linux/compat_time.h usable on 32-bit
Date: Wed,  6 May 2015 18:30:12 +0200
Message-ID: <1430929826-318934-6-git-send-email-arnd@arndb.de>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: baolin.wang@linaro.org, tglx@linutronix.de, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org, ruchandani.tina@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

This adds the necessary type definitions to allow using the
linux/compat_time.h header file on 32-bit architectures without
adding an asm/compat.h header in each architecture.

The types we define here are used in the compat system call
definitions of some system calls that also pass a time_t
in another structure, but are themselves not depending on the
size of time_t.

This also adds a way to use COMPAT_SYSCALL_DEFINE() by
including the compat.h header file. Some code may need to
get reshuffled here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/compat.h      |  6 ++++--
 include/linux/compat_time.h | 24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 41b0dae6203b..fefc45094107 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -5,8 +5,6 @@
  * syscall compatibility layer.
  */
 
-#ifdef CONFIG_COMPAT
-
 #include <linux/stat.h>
 #include <linux/param.h>	/* for HZ */
 #include <linux/sem.h>
@@ -17,7 +15,9 @@
 #include <linux/unistd.h>
 #include <linux/compat_time.h>
 
+#ifdef CONFIG_COMPAT
 #include <asm/compat.h>
+#endif
 #include <asm/siginfo.h>
 #include <asm/signal.h>
 
@@ -52,6 +52,8 @@
 	}								\
 	static inline long C_SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
+#ifdef CONFIG_COMPAT
+
 #ifndef compat_user_stack_pointer
 #define compat_user_stack_pointer() current_user_stack_pointer()
 #endif
diff --git a/include/linux/compat_time.h b/include/linux/compat_time.h
index 37564582f6a5..e17375a91f76 100644
--- a/include/linux/compat_time.h
+++ b/include/linux/compat_time.h
@@ -78,6 +78,30 @@ struct compat_timex {
 	compat_int_t:32; compat_int_t:32; compat_int_t:32;
 };
 
+#ifdef CONFIG_COMPAT
+#include <asm/compat.h>
+
+#define _COMPAT_NSIG_WORDS     (_COMPAT_NSIG / _COMPAT_NSIG_BPW)
+typedef struct {
+       compat_sigset_word      sig[_COMPAT_NSIG_WORDS];
+} compat_sigset_t;
+
+#else
+
+#define compat_mmsghdr mmsghdr
+#define compat_stat stat
+#define compat_siginfo siginfo
+#define compat_sigevent sigevent
+#define compat_sigset_t sigset_t
+#define __compat_uid_t __kernel_uid_t
+#define __compat_gid_t __kernel_gid_t
+#define compat_mode_t __kernel_mode_t
+#define copy_siginfo_to_user32(uinfo, info) copy_siginfo_to_user(uinfo, info)
+static inline void __user *compat_ptr(compat_uptr_t ptr)
+{
+	return (void __user*)ptr;
+}
+#endif
 
 /*
  * These functions operate on 32- or 64-bit specs depending on
-- 
2.1.0.rc2
