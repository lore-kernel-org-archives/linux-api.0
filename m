From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [PATCH v7 23/27] x86/cet/shstk: ELF header parsing of Shadow Stack
Date: Thu,  6 Jun 2019 13:06:42 -0700
Message-ID: <20190606200646.3951-24-yu-cheng.yu@intel.com>
References: <20190606200646.3951-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606200646.3951-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

Look in .note.gnu.property of an ELF file and check if Shadow Stack needs
to be enabled for the task.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/Kconfig             |  1 +
 arch/x86/kernel/process_64.c | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1664918c2c1c..df8b57de75b2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1928,6 +1928,7 @@ config X86_INTEL_SHADOW_STACK_USER
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select X86_INTEL_CET
 	select ARCH_HAS_SHSTK
+	select ARCH_USE_GNU_PROPERTY
 	---help---
 	  Shadow stack provides hardware protection against program stack
 	  corruption.  Only when all the following are true will an application
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 250e4c4ac6d9..c51df5b4e116 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -828,3 +828,27 @@ unsigned long KSTK_ESP(struct task_struct *task)
 {
 	return task_pt_regs(task)->sp;
 }
+
+#ifdef CONFIG_ARCH_USE_GNU_PROPERTY
+int arch_setup_property(void *ehdr, void *phdr, struct file *f, bool inter)
+{
+	int r;
+	uint32_t property;
+
+	r = get_gnu_property(ehdr, phdr, f, GNU_PROPERTY_X86_FEATURE_1_AND,
+			     &property);
+
+	memset(&current->thread.cet, 0, sizeof(struct cet_status));
+
+	if (r)
+		return r;
+
+	if (cpu_feature_enabled(X86_FEATURE_SHSTK)) {
+		if (property & GNU_PROPERTY_X86_FEATURE_1_SHSTK)
+			r = cet_setup_shstk();
+		if (r < 0)
+			return r;
+	}
+	return r;
+}
+#endif
-- 
2.17.1
