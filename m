From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [RFC PATCH v9 24/27] x86/cet/shstk: ELF header parsing for Shadow Stack
Date: Wed,  5 Feb 2020 10:19:32 -0800
Message-ID: <20200205181935.3712-25-yu-cheng.yu@intel.com>
References: <20200205181935.3712-1-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20200205181935.3712-1-yu-cheng.yu@intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

Check an ELF file's .note.gnu.property, and setup Shadow Stack if the
application supports it.

v9:
- Change cpu_feature_enabled() to static_cpu_has().

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/Kconfig             |  2 ++
 arch/x86/include/asm/elf.h   | 13 +++++++++++++
 arch/x86/kernel/process_64.c | 31 +++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6c34b701c588..d1447380e02e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1987,6 +1987,8 @@ config X86_INTEL_SHADOW_STACK_USER
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select X86_INTEL_CET
 	select ARCH_HAS_SHSTK
+	select ARCH_USE_GNU_PROPERTY
+	select ARCH_BINFMT_ELF_STATE
 	---help---
 	  Shadow Stack (SHSTK) provides protection against program
 	  stack corruption.  It is active when the kernel has this
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 69c0f892e310..fac79b621e0a 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -367,6 +367,19 @@ extern int compat_arch_setup_additional_pages(struct linux_binprm *bprm,
 					      int uses_interp);
 #define compat_arch_setup_additional_pages compat_arch_setup_additional_pages
 
+#ifdef CONFIG_ARCH_BINFMT_ELF_STATE
+struct arch_elf_state {
+	unsigned int gnu_property;
+};
+
+#define INIT_ARCH_ELF_STATE {	\
+	.gnu_property = 0,	\
+}
+
+#define arch_elf_pt_proc(ehdr, phdr, elf, interp, state) (0)
+#define arch_check_elf(ehdr, interp, interp_ehdr, state) (0)
+#endif
+
 /* Do not change the values. See get_align_mask() */
 enum align_flags {
 	ALIGN_VA_32	= BIT(0),
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 506d66830d4d..99548cde0cc6 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -732,3 +732,34 @@ unsigned long KSTK_ESP(struct task_struct *task)
 {
 	return task_pt_regs(task)->sp;
 }
+
+#ifdef CONFIG_ARCH_USE_GNU_PROPERTY
+int arch_parse_elf_property(u32 type, const void *data, size_t datasz,
+			     bool compat, struct arch_elf_state *state)
+{
+	if (type != GNU_PROPERTY_X86_FEATURE_1_AND)
+		return 0;
+
+	if (datasz != sizeof(unsigned int))
+		return -ENOEXEC;
+
+	state->gnu_property = *(unsigned int *)data;
+	return 0;
+}
+
+int arch_setup_elf_property(struct arch_elf_state *state)
+{
+	int r = 0;
+
+	memset(&current->thread.cet, 0, sizeof(struct cet_status));
+
+	if (static_cpu_has(X86_FEATURE_SHSTK)) {
+		if (state->gnu_property & GNU_PROPERTY_X86_FEATURE_1_SHSTK)
+			r = cet_setup_shstk();
+		if (r < 0)
+			return r;
+	}
+
+	return r;
+}
+#endif
-- 
2.21.0
