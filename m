From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: [RFC PATCH v6 01/11] x86/cet/ibt: Add Kconfig option for user-mode Indirect Branch Tracking
Date: Mon, 19 Nov 2018 13:49:24 -0800
Message-ID: <20181119214934.6174-2-yu-cheng.yu@intel.com>
References: <20181119214934.6174-1-yu-cheng.yu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181119214934.6174-1-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
List-Id: linux-api@vger.kernel.org

The user-mode indirect branch tracking support is done mostly by GCC
to insert ENDBR64/ENDBR32 instructions at branch targets.  The kernel
provides CPUID enumeration and feature setup.

Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
---
 arch/x86/Kconfig  | 16 ++++++++++++++++
 arch/x86/Makefile |  7 +++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 73dfb94cde71..b7f30ac89e27 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1925,6 +1925,9 @@ config X86_INTEL_CET
 config ARCH_HAS_SHSTK
 	def_bool n
 
+config ARCH_HAS_AS_LIMIT
+	def_bool n
+
 config ARCH_HAS_PROGRAM_PROPERTIES
 	def_bool n
 
@@ -1948,6 +1951,19 @@ config X86_INTEL_SHADOW_STACK_USER
 
 	  If unsure, say y.
 
+config X86_INTEL_BRANCH_TRACKING_USER
+	prompt "Intel Indirect Branch Tracking for user-mode"
+	def_bool n
+	depends on CPU_SUP_INTEL && X86_64
+	select X86_INTEL_CET
+	select ARCH_HAS_AS_LIMIT
+	select ARCH_HAS_PROGRAM_PROPERTIES
+	---help---
+	  Indirect Branch Tracking provides hardware protection against return-/jmp-
+	  oriented programming attacks.
+
+	  If unsure, say y
+
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 0e4746814452..7e6c4aeb0d92 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -159,6 +159,13 @@ ifdef CONFIG_X86_INTEL_SHADOW_STACK_USER
   endif
 endif
 
+# Check compiler ibt support
+ifdef CONFIG_X86_INTEL_BRANCH_TRACKING_USER
+  ifeq ($(call cc-option-yn, -fcf-protection=branch), n)
+      $(error CONFIG_X86_INTEL_BRANCH_TRACKING_USER not supported by compiler)
+  endif
+endif
+
 #
 # If the function graph tracer is used with mcount instead of fentry,
 # '-maccumulate-outgoing-args' is needed to prevent a GCC bug
-- 
2.17.1
