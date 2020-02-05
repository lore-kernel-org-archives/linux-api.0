From: Yu-cheng Yu <yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v9 05/27] x86/cet/shstk: Add Kconfig option for user-mode Shadow Stack protection
Date: Wed,  5 Feb 2020 10:19:13 -0800
Message-ID: <20200205181935.3712-6-yu-cheng.yu@intel.com>
References: <20200205181935.3712-1-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200205181935.3712-1-yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H.J. Lu" <hjl.tools-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Nadav Amit <nadav.amit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yu-cheng Yu <yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Introduce Kconfig option: X86_INTEL_SHADOW_STACK_USER.

Shadow Stack (SHSTK) provides protection against function return address
corruption.  It is active when the kernel has this feature enabled, and
both the processor and the application support it.  When this feature is
enabled, legacy non-SHSTK applications continue to work, but without SHSTK
protection.

The user-mode SHSTK protection is only implemented for the 64-bit kernel.
IA32 applications are supported under the compatibility mode.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/Kconfig  | 22 ++++++++++++++++++++++
 arch/x86/Makefile |  7 +++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5e8949953660..6c34b701c588 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1974,6 +1974,28 @@ config X86_INTEL_TSX_MODE_AUTO
 	  side channel attacks- equals the tsx=auto command line parameter.
 endchoice
 
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
+	  Shadow Stack (SHSTK) provides protection against program
+	  stack corruption.  It is active when the kernel has this
+	  feature enabled, and the processor and the application
+	  support it.  When this feature is enabled, legacy non-SHSTK
+	  applications continue to work, but without SHSTK protection.
+
+	  If unsure, say y.
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 94df0868804b..c34f5befa4c8 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -149,6 +149,13 @@ ifdef CONFIG_X86_X32
 endif
 export CONFIG_X86_X32_ABI
 
+# Check assembler Shadow Stack suppot
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
2.21.0
