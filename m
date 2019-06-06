From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [PATCH v7 07/27] x86/cet/shstk: Add Kconfig option for user-mode shadow stack
Date: Thu,  6 Jun 2019 13:06:26 -0700
Message-ID: <20190606200646.3951-8-yu-cheng.yu@intel.com>
References: <20190606200646.3951-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606200646.3951-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

Introduce Kconfig option X86_INTEL_SHADOW_STACK_USER.

An application has shadow stack protection when all the following are
true:

  (1) The kernel has X86_INTEL_SHADOW_STACK_USER enabled,
  (2) The running processor supports the shadow stack,
  (3) The application is built with shadow stack enabled tools & libs
      and, and at runtime, all dependent shared libs can support
      shadow stack.

If this kernel config option is enabled, but (2) or (3) above is not
true, the application runs without the shadow stack protection.
Existing legacy applications will continue to work without the shadow
stack protection.

The user-mode shadow stack protection is only implemented for the
64-bit kernel.  Thirty-two bit applications are supported under the
compatibility mode.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/Kconfig  | 25 +++++++++++++++++++++++++
 arch/x86/Makefile |  7 +++++++
 2 files changed, 32 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2bbbd4d1ba31..1664918c2c1c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1915,6 +1915,31 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 
 	  If unsure, say y.
 
+config X86_INTEL_CET
+	def_bool n
+
+config ARCH_HAS_SHSTK
+	def_bool n
+
+config X86_INTEL_SHADOW_STACK_USER
+	prompt "Intel Shadow Stack for user-mode"
+	def_bool n
+	depends on CPU_SUP_INTEL && X86_64
+	select ARCH_USES_HIGH_VMA_FLAGS
+	select X86_INTEL_CET
+	select ARCH_HAS_SHSTK
+	---help---
+	  Shadow stack provides hardware protection against program stack
+	  corruption.  Only when all the following are true will an application
+	  have the shadow stack protection: the kernel supports it (i.e. this
+	  feature is enabled), the application is compiled and linked with
+	  shadow stack enabled, and the processor supports this feature.
+	  When the kernel has this configuration enabled, existing non shadow
+	  stack applications will continue to work, but without shadow stack
+	  protection.
+
+	  If unsure, say y.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 56e748a7679f..0b2e9df48907 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -148,6 +148,13 @@ ifdef CONFIG_X86_X32
 endif
 export CONFIG_X86_X32_ABI
 
+# Check assembler shadow stack suppot
+ifdef CONFIG_X86_INTEL_SHADOW_STACK_USER
+  ifeq ($(call as-instr, saveprevssp, y),)
+      $(error CONFIG_X86_INTEL_SHADOW_STACK_USER not supported by the assembler)
+  endif
+endif
+
 #
 # If the function graph tracer is used with mcount instead of fentry,
 # '-maccumulate-outgoing-args' is needed to prevent a GCC bug
-- 
2.17.1
