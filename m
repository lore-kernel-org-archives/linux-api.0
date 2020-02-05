From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [RFC PATCH v9 2/7] x86/cet/ibt: User-mode Indirect Branch Tracking support
Date: Wed,  5 Feb 2020 10:23:03 -0800
Message-ID: <20200205182308.4028-3-yu-cheng.yu@intel.com>
References: <20200205182308.4028-1-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20200205182308.4028-1-yu-cheng.yu@intel.com>
Sender: linux-arch-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

Introduce user-mode Indirect Branch Tracking (IBT) support.  Update setup
routines to include IBT.

v9:
- Change cpu_feature_enabled() to static_cpu_has().

v2:
- Change noibt to no_cet_ibt.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/include/asm/cet.h                    |  5 +++
 arch/x86/include/asm/disabled-features.h      |  8 ++++-
 arch/x86/kernel/cet.c                         | 34 +++++++++++++++++++
 arch/x86/kernel/cpu/common.c                  | 17 ++++++++++
 .../arch/x86/include/asm/disabled-features.h  |  8 ++++-
 5 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cet.h b/arch/x86/include/asm/cet.h
index b64f6d810ae0..d3f0d50d51ec 100644
--- a/arch/x86/include/asm/cet.h
+++ b/arch/x86/include/asm/cet.h
@@ -16,6 +16,9 @@ struct cet_status {
 	unsigned long	shstk_size;
 	unsigned int	locked:1;
 	unsigned int	shstk_enabled:1;
+	unsigned int	ibt_enabled:1;
+	unsigned int	ibt_bitmap_used:1;
+	unsigned long	ibt_bitmap_base;
 };
 
 #ifdef CONFIG_X86_INTEL_CET
@@ -26,6 +29,8 @@ int cet_alloc_shstk(unsigned long *arg);
 void cet_disable_free_shstk(struct task_struct *p);
 int cet_restore_signal(bool ia32, struct sc_ext *sc);
 int cet_setup_signal(bool ia32, unsigned long rstor, struct sc_ext *sc);
+int cet_setup_ibt(void);
+void cet_disable_ibt(void);
 #else
 static inline int prctl_cet(int option, unsigned long arg2) { return -EINVAL; }
 static inline int cet_setup_thread_shstk(struct task_struct *p) { return 0; }
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index e1454509ad83..09f81a09dae7 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -68,6 +68,12 @@
 #define DISABLE_SHSTK	(1<<(X86_FEATURE_SHSTK & 31))
 #endif
 
+#ifdef CONFIG_X86_INTEL_BRANCH_TRACKING_USER
+#define DISABLE_IBT	0
+#else
+#define DISABLE_IBT	(1<<(X86_FEATURE_IBT & 31))
+#endif
+
 /*
  * Make sure to add features to the correct mask
  */
@@ -89,7 +95,7 @@
 #define DISABLED_MASK15	0
 #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP|DISABLE_SHSTK)
 #define DISABLED_MASK17	0
-#define DISABLED_MASK18	0
+#define DISABLED_MASK18	(DISABLE_IBT)
 #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/arch/x86/kernel/cet.c b/arch/x86/kernel/cet.c
index 01aa24c40a5d..26f5d7c4fbff 100644
--- a/arch/x86/kernel/cet.c
+++ b/arch/x86/kernel/cet.c
@@ -13,6 +13,8 @@
 #include <linux/uaccess.h>
 #include <linux/sched/signal.h>
 #include <linux/compat.h>
+#include <linux/vmalloc.h>
+#include <linux/bitops.h>
 #include <asm/msr.h>
 #include <asm/user.h>
 #include <asm/fpu/internal.h>
@@ -342,3 +344,35 @@ int cet_setup_signal(bool ia32, unsigned long rstor_addr, struct sc_ext *sc_ext)
 	end_update_msrs();
 
 	return 0;
+}
+
+int cet_setup_ibt(void)
+{
+	u64 msr_val;
+
+	if (!static_cpu_has(X86_FEATURE_IBT))
+		return -EOPNOTSUPP;
+
+	start_update_msrs();
+	rdmsrl(MSR_IA32_U_CET, msr_val);
+	msr_val |= (MSR_IA32_CET_ENDBR_EN | MSR_IA32_CET_NO_TRACK_EN);
+	wrmsrl(MSR_IA32_U_CET, msr_val);
+	end_update_msrs();
+	current->thread.cet.ibt_enabled = 1;
+	return 0;
+}
+
+void cet_disable_ibt(void)
+{
+	u64 msr_val;
+
+	if (!static_cpu_has(X86_FEATURE_IBT))
+		return;
+
+	start_update_msrs();
+	rdmsrl(MSR_IA32_U_CET, msr_val);
+	msr_val &= MSR_IA32_CET_SHSTK_EN;
+	wrmsrl(MSR_IA32_U_CET, msr_val);
+	end_update_msrs();
+	current->thread.cet.ibt_enabled = 0;
+}
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 40498ec72fda..c1ffde5c2ace 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -510,6 +510,23 @@ static __init int setup_disable_shstk(char *s)
 __setup("no_cet_shstk", setup_disable_shstk);
 #endif
 
+#ifdef CONFIG_X86_INTEL_BRANCH_TRACKING_USER
+static __init int setup_disable_ibt(char *s)
+{
+	/* require an exact match without trailing characters */
+	if (s[0] != '\0')
+		return 0;
+
+	if (!boot_cpu_has(X86_FEATURE_IBT))
+		return 1;
+
+	setup_clear_cpu_cap(X86_FEATURE_IBT);
+	pr_info("x86: 'no_cet_ibt' specified, disabling Branch Tracking\n");
+	return 1;
+}
+__setup("no_cet_ibt", setup_disable_ibt);
+#endif
+
 /*
  * Some CPU features depend on higher CPUID levels, which may not always
  * be available due to CPUID level capping or broken virtualization
diff --git a/tools/arch/x86/include/asm/disabled-features.h b/tools/arch/x86/include/asm/disabled-features.h
index e1454509ad83..09f81a09dae7 100644
--- a/tools/arch/x86/include/asm/disabled-features.h
+++ b/tools/arch/x86/include/asm/disabled-features.h
@@ -68,6 +68,12 @@
 #define DISABLE_SHSTK	(1<<(X86_FEATURE_SHSTK & 31))
 #endif
 
+#ifdef CONFIG_X86_INTEL_BRANCH_TRACKING_USER
+#define DISABLE_IBT	0
+#else
+#define DISABLE_IBT	(1<<(X86_FEATURE_IBT & 31))
+#endif
+
 /*
  * Make sure to add features to the correct mask
  */
@@ -89,7 +95,7 @@
 #define DISABLED_MASK15	0
 #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP|DISABLE_SHSTK)
 #define DISABLED_MASK17	0
-#define DISABLED_MASK18	0
+#define DISABLED_MASK18	(DISABLE_IBT)
 #define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
-- 
2.21.0
