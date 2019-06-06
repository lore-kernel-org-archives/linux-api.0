From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [PATCH v7 03/14] x86/cet/ibt: Add IBT legacy code bitmap setup function
Date: Thu,  6 Jun 2019 13:09:15 -0700
Message-ID: <20190606200926.4029-4-yu-cheng.yu@intel.com>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606200926.4029-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

Indirect Branch Tracking (IBT) provides an optional legacy code bitmap
that allows execution of legacy, non-IBT compatible library by an
IBT-enabled application.  When set, each bit in the bitmap indicates
one page of legacy code.

The bitmap is allocated and setup from the application.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/include/asm/cet.h |  1 +
 arch/x86/kernel/cet.c      | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/include/asm/cet.h b/arch/x86/include/asm/cet.h
index 89330e4159a9..9e613a6598c9 100644
--- a/arch/x86/include/asm/cet.h
+++ b/arch/x86/include/asm/cet.h
@@ -31,6 +31,7 @@ void cet_disable_free_shstk(struct task_struct *p);
 int cet_restore_signal(bool ia32, struct sc_ext *sc);
 int cet_setup_signal(bool ia32, unsigned long rstor, struct sc_ext *sc);
 int cet_setup_ibt(void);
+int cet_setup_ibt_bitmap(unsigned long bitmap, unsigned long size);
 void cet_disable_ibt(void);
 #else
 static inline int prctl_cet(int option, unsigned long arg2) { return -EINVAL; }
diff --git a/arch/x86/kernel/cet.c b/arch/x86/kernel/cet.c
index 14ad25b8ff21..e0ef996d3148 100644
--- a/arch/x86/kernel/cet.c
+++ b/arch/x86/kernel/cet.c
@@ -22,6 +22,7 @@
 #include <asm/fpu/types.h>
 #include <asm/cet.h>
 #include <asm/special_insns.h>
+#include <asm/elf.h>
 #include <uapi/asm/sigcontext.h>
 
 static int set_shstk_ptr(unsigned long addr)
@@ -361,3 +362,28 @@ void cet_disable_ibt(void)
 
 	current->thread.cet.ibt_enabled = 0;
 }
+
+int cet_setup_ibt_bitmap(unsigned long bitmap, unsigned long size)
+{
+	u64 r;
+
+	if (!current->thread.cet.ibt_enabled)
+		return -EINVAL;
+
+	if (!PAGE_ALIGNED(bitmap) || (size > TASK_SIZE_MAX))
+		return -EINVAL;
+
+	current->thread.cet.ibt_bitmap_addr = bitmap;
+	current->thread.cet.ibt_bitmap_size = size;
+
+	/*
+	 * Turn on IBT legacy bitmap.
+	 */
+	modify_fpu_regs_begin();
+	rdmsrl(MSR_IA32_U_CET, r);
+	r |= (MSR_IA32_CET_LEG_IW_EN | bitmap);
+	wrmsrl(MSR_IA32_U_CET, r);
+	modify_fpu_regs_end();
+
+	return 0;
+}
-- 
2.17.1
